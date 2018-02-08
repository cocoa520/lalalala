//
//  CfbBlockCipherEx.m
//  
//
//  Created by Pallas on 8/9/16.
//
//  Complete

#import "CfbBlockCipherEx.h"
#import "Arrays.h"
#import "BlockCipher.h"
#import "CategoryExtend.h"
#import "ParametersWithIV.h"

@interface CfbBlockCipherEx ()

@property (nonatomic, readwrite, retain) NSMutableData *iv;
@property (nonatomic, readwrite, retain) NSMutableData *cfbV;
@property (nonatomic, readwrite, retain) NSMutableData *cfbOutV;
@property (nonatomic, readwrite, retain) NSMutableData *inBuf;
@property (nonatomic, readwrite, assign) int blockSize;
@property (nonatomic, readwrite, assign) BOOL encrypting;
@property (nonatomic, readwrite, assign) int byteCount;

@end

@implementation CfbBlockCipherEx
@synthesize iv = _iv;
@synthesize cfbV = _cfbV;
@synthesize cfbOutV = _cfbOutV;
@synthesize inBuf = _inBuf;
@synthesize blockSize = _blockSize;
@synthesize encrypting = _encrypting;
@synthesize byteCount = _byteCount;

/**
 * Basic constructor.
 *
 * @param cipher the block cipher to be used as the basis of the
 * feedback mode.
 * @param bitBlockSize the block size in bits (note: a multiple of 8)
 */
- (id)initWithCipher:(BlockCipher*)cipher withBitBlockSize:(int)bitBlockSize {
    if (self = [super initWithCipher:cipher]) {
        @autoreleasepool {
            [self setBlockSize:(bitBlockSize / 8)];
            int blocksize = [cipher getBlockSize];
            NSMutableData *tmpIV = [[NSMutableData alloc] initWithSize:blocksize];
            [self setIv:tmpIV];
            NSMutableData *tmpCfbV = [[NSMutableData alloc] initWithSize:blocksize];
            [self setCfbV:tmpCfbV];
            NSMutableData *tmpCfbOutV = [[NSMutableData alloc] initWithSize:blocksize];
            [self setCfbOutV:tmpCfbOutV];
            NSMutableData *tmpInBuf = [[NSMutableData alloc] initWithSize:self.blockSize];
            [self setInBuf:tmpInBuf];
#if !__has_feature(objc_arc)
            if (tmpIV != nil) [tmpIV release]; tmpIV = nil;
            if (tmpCfbV != nil) [tmpCfbV release]; tmpCfbV = nil;
            if (tmpCfbOutV != nil) [tmpCfbOutV release]; tmpCfbOutV = nil;
            if (tmpInBuf != nil) [tmpInBuf release]; tmpInBuf = nil;
#endif            
        }
        return self;
    } else {
        return nil;
    }
}

/**
 * Initialise the cipher and, possibly, the initialisation vector (IV).
 * If an IV isn't passed as part of the parameter, the IV will be all zeros.
 * An IV which is too short is handled in FIPS compliant fashion.
 *
 * @param encrypting if true the cipher is initialised for
 *  encryption, if false for decryption.
 * @param params the key and other data required by the cipher.
 * @exception IllegalArgumentException if the params argument is
 * inappropriate.
 */
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
    @autoreleasepool {
        [self setEncrypting:forEncryption];
        if (parameters != nil && [parameters isKindOfClass:[ParametersWithIV class]]) {
            ParametersWithIV *ivParam = (ParametersWithIV*)parameters;
            NSMutableData *IV = [ivParam getIV];
            
            if (IV.length < [self iv].length) {
                int diff = (int)([self iv].length - IV.length);
                [[self iv] copyFromIndex:diff withSource:IV withSourceIndex:0 withLength:(int)(IV.length)];
                
                [[self iv] clearFromIndex:0 withLength:diff];
                for (int i = 0; i < (int)([self iv].length - IV.length); i++) {
                    ((Byte*)([self iv].bytes))[i] = (Byte)0;
                }
            } else {
                [[self iv] copyFromIndex:0 withSource:IV withSourceIndex:0 withLength:(int)([self iv].length)];
            }
            
            [self reset];
            
            // if null it's an IV changed only.
            if ([ivParam parameters] != nil) {
                [[self getUnderlyingCipher] init:YES withParameters:[ivParam parameters]];
            }
        } else {
            [self reset];
            
            // if it's null, key is to be reused.
            if (parameters != nil) {
                [[self getUnderlyingCipher] init:YES withParameters:parameters];
            }
        }        
    }
}

/**
 * return the algorithm name and mode.
 *
 * @return the name of the underlying algorithm followed by "/CFB"
 * and the block size in bits.
 */
- (NSString*)algorithmName {
    return [NSString stringWithFormat:@"%@/CFB%d", [[self getUnderlyingCipher] algorithmName], (self.blockSize * 8)];
}

- (Byte)calculateByte:(Byte)b {
    return (self.encrypting) ? [self encryptByte:b] : [self decryptByte:b];
}

- (Byte)encryptByte:(Byte)inByte {
    if (self.byteCount == 0) {
        [[self getUnderlyingCipher] processBlock:[self cfbV] withInOff:0 withOutBuf:[self cfbOutV] withOutOff:0];
    }
    
    Byte rv = (Byte)(((Byte*)([self cfbOutV].bytes))[self.byteCount] ^ inByte);
    ((Byte*)([self inBuf].bytes))[self.byteCount++] = rv;
    
    if (self.byteCount == self.blockSize) {
        self.byteCount = 0;
        
        [[self cfbV] copyFromIndex:0 withSource:[self cfbV] withSourceIndex:self.blockSize withLength:((int)([self cfbV].length) - self.blockSize)];
        [[self cfbV] copyFromIndex:((int)([self cfbV].length) - self.blockSize) withSource:[self inBuf] withSourceIndex:0 withLength:self.blockSize];
    }
    
    return rv;
}

- (Byte)decryptByte:(Byte)inByte {
    if (self.byteCount == 0) {
        [[self getUnderlyingCipher] processBlock:[self cfbV] withInOff:0 withOutBuf:[self cfbOutV] withOutOff:0];
    }
    
    ((Byte*)([self inBuf].bytes))[self.byteCount] = inByte;
    Byte rv = (Byte)(((Byte*)([self cfbOutV].bytes))[self.byteCount++] ^ inByte);
    
    if (self.byteCount == self.blockSize) {
        self.byteCount = 0;
        
        [[self cfbV] copyFromIndex:0 withSource:[self cfbV] withSourceIndex:self.blockSize withLength:((int)([self cfbV].length) - self.blockSize)];
        [[self cfbV] copyFromIndex:((int)([self cfbV].length) - self.blockSize) withSource:[self inBuf] withSourceIndex:0 withLength:self.blockSize];
    }
    
    return rv;
}

/**
 * Process one block of input from the array in and write it to
 * the out array.
 *
 * @param in the array containing the input data.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the output data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception IllegalStateException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)processBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff {
    [self processBytes:inBuf withInOff:inOff withLen:self.blockSize withOutBytes:outBuf withOutOff:outOff];
    return self.blockSize;
}

/**
 * Do the appropriate processing for CFB mode encryption.
 *
 * @param in the array containing the data to be encrypted.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the encrypted data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception IllegalStateException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)encryptBlock:(NSData*)inBytes withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    [self processBytes:inBytes withInOff:inOff withLen:self.blockSize withOutBytes:outBytes withOutOff:outOff];
    return self.blockSize;
}

/**
 * Do the appropriate processing for CFB mode decryption.
 *
 * @param in the array containing the data to be decrypted.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the encrypted data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception IllegalStateException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)decryptBlock:(NSData*)inBytes withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    [self processBytes:inBytes withInOff:inOff withLen:self.blockSize withOutBytes:outBytes withOutOff:outOff];
    return self.blockSize;
}

/**
 * Return the current state of the initialisation vector.
 *
 * @return current IV
 */
- (NSMutableData*)getCurrentIV {
    return [[Arrays cloneWithByteArray:[self cfbV]] autorelease];
}

/**
 * reset the chaining vector back to the IV and reset the underlying
 * cipher.
 */
- (void)reset {
    [[self cfbV] copyFromIndex:0 withSource:[self iv] withSourceIndex:0 withLength:(int)([self iv].length)];
    [Arrays fillWithByteArray:[self inBuf] withB:((Byte)0)];
    self.byteCount = 0;
    
    [[self getUnderlyingCipher] reset];
}

@end
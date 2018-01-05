//
//  CbcBlockCipher.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "CbcBlockCipher.h"
#import "CategoryExtend.h"
#import "CipherParameters.h"
#import "ParametersWithIV.h"

@interface CbcBlockCipher ()

@property (nonatomic, readwrite, retain) NSMutableData *iv;
@property (nonatomic, readwrite, retain) NSMutableData *cbcV;
@property (nonatomic, readwrite, retain) NSMutableData *cbcNextV;
@property (nonatomic, readwrite, assign) int blockSize;
@property (nonatomic, readwrite, retain) BlockCipher *cipher;
@property (nonatomic, readwrite, assign) BOOL encrypting;

@end

@implementation CbcBlockCipher
@synthesize iv = _iv;
@synthesize cbcV = _cbcV;
@synthesize cbcNextV = _cbcNextV;
@synthesize blockSize = _blockSize;
@synthesize cipher = _cipher;
@synthesize encrypting = _encrypting;

/**
 * Basic constructor.
 *
 * @param cipher the block cipher to be used as the basis of chaining.
 */
- (id)initWithCipher:(BlockCipher*)cipher {
    if (self = [super init]) {
        @autoreleasepool {
            [self setCipher:cipher];
            [self setBlockSize:[[self cipher] getBlockSize]];
            
            NSMutableData *tmpIV = [[NSMutableData alloc] initWithSize:self.blockSize];
            [self setIv:tmpIV];
            NSMutableData *tmpCbcV = [[NSMutableData alloc] initWithSize:self.blockSize];
            [self setCbcV:tmpCbcV];
            NSMutableData *tmpCbcNextV = [[NSMutableData alloc] initWithSize:self.blockSize];
            [self setCbcNextV:tmpCbcNextV];
#if !__has_feature(objc_arc)
            if (tmpIV != nil) [tmpIV release]; tmpIV = nil;
            if (tmpCbcV != nil) [tmpCbcV release]; tmpCbcV = nil;
            if (tmpCbcNextV != nil) [tmpCbcNextV release]; tmpCbcNextV = nil;
#endif            
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setIv:nil];
    [self setCbcV:nil];
    [self setCbcNextV:nil];
    [self setCipher:nil];
    [super dealloc];
#endif
}

/**
 * return the underlying block cipher that we are wrapping.
 *
 * @return the underlying block cipher that we are wrapping.
 */
- (BlockCipher*)getUnderlyingCipher {
    return [self cipher];
}

/**
 * Initialise the cipher and, possibly, the initialisation vector (IV).
 * If an IV isn't passed as part of the parameter, the IV will be all zeros.
 *
 * @param forEncryption if true the cipher is initialised for
 *  encryption, if false for decryption.
 * @param param the key and other data required by the cipher.
 * @exception ArgumentException if the parameters argument is
 * inappropriate.
 */
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
    @autoreleasepool {
        BOOL oldEncrypting = [self encrypting];
        
        [self setEncrypting:forEncryption];
        
        if (parameters != nil && [parameters isKindOfClass:[ParametersWithIV class]]) {
            ParametersWithIV *ivParam = (ParametersWithIV*)parameters;
            NSMutableData *IV = [ivParam getIV];
            
            if (IV.length != self.blockSize) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"initialisation vector must be the same length as block size" userInfo:nil];
            }
            
            [[self iv] copyFromIndex:0 withSource:IV withSourceIndex:0 withLength:(int)(IV.length)];
            
            parameters = [ivParam parameters];
        }
        
        [self reset];
        
        // if null it's an IV changed only.
        if (parameters != nil) {
            [[self cipher] init:[self encrypting] withParameters:parameters];
        } else if (oldEncrypting != [self encrypting]) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"cannot change encrypting state without providing key." userInfo:nil];
        }
    }
}

/**
 * return the algorithm name and mode.
 *
 * @return the name of the underlying algorithm followed by "/CBC".
 */
- (NSString*)algorithmName {
    return [[[NSString alloc] initWithFormat:@"%@/CBC", [[self cipher] algorithmName]] autorelease];
}

- (BOOL)isPartialBlockOkay {
    return NO;
}

/**
 * return the block size of the underlying cipher.
 *
 * @return the block size of the underlying cipher.
 */
- (int)getBlockSize {
    return [[self cipher] getBlockSize];
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
 * @exception InvalidOperationException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)processBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff {
    return [self encrypting] ? [self encryptBlock:inBuf withInOff:inOff withOutBytes:outBuf withOutOff:outOff] : [self decryptBlock:inBuf withInOff:inOff withOutBytes:outBuf withOutOff:outOff];
}

/**
 * reset the chaining vector back to the IV and reset the underlying
 * cipher.
 */
- (void)reset {
    [[self cbcV] copyFromIndex:0 withSource:[self iv] withSourceIndex:0 withLength:(int)([self iv].length)];
    [[self cbcNextV] clearFromIndex:0 withLength:(int)([self cbcNextV].length)];
    
    [[self cipher] reset];
}

/**
 * Do the appropriate chaining step for CBC mode encryption.
 *
 * @param in the array containing the data to be encrypted.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the encrypted data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception InvalidOperationException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)encryptBlock:(NSMutableData*)input withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    if ((inOff + self.blockSize) > (int)(input.length)) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"input buffer too short" userInfo:nil];
    }
    
    /*
     * XOR the cbcV and the input,
     * then encrypt the cbcV
     */
    for (int i = 0; i < self.blockSize; i++) {
        ((Byte*)([self cbcV].bytes))[i] = (Byte)(((Byte*)([self cbcV].bytes))[i] ^ ((Byte*)(input.bytes))[inOff + i]);
    }
    
    int length = [[self cipher] processBlock:[self cbcV] withInOff:0 withOutBuf:outBytes withOutOff:outOff];
    
    /*
     * copy ciphertext to cbcV
     */
    [[self cbcV] copyFromIndex:0 withSource:outBytes withSourceIndex:outOff withLength:(int)([self cbcV].length)];
    
    return length;
}

/**
 * Do the appropriate chaining step for CBC mode decryption.
 *
 * @param in the array containing the data to be decrypted.
 * @param inOff offset into the in array the data starts at.
 * @param out the array the decrypted data will be copied into.
 * @param outOff the offset into the out array the output will start at.
 * @exception DataLengthException if there isn't enough data in in, or
 * space in out.
 * @exception InvalidOperationException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)decryptBlock:(NSMutableData*)input withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    if ((inOff + self.blockSize) > (int)(input.length)) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"input buffer too short" userInfo:nil];
    }
    
    [[self cbcNextV] copyFromIndex:0 withSource:input withSourceIndex:inOff withLength:self.blockSize];
    
    int length = [[self cipher] processBlock:input withInOff:inOff withOutBuf:outBytes withOutOff:outOff];
    
    /*
     * XOR the cbcV and the output
     */
    for (int i = 0; i < self.blockSize; i++) {
        ((Byte*)(outBytes.bytes))[outOff + i] = (Byte)(((Byte*)(outBytes.bytes))[outOff + i] ^ ((Byte*)([self cbcV].bytes))[i]);
    }
    
    /*
     * swap the back up buffer into next position
     */
    NSMutableData *tmp;
    
    tmp = [[self cbcV] retain];
    [self setCbcV:[self cbcNextV]];
    [self setCbcNextV:tmp];
#if !__has_feature(objc_arc)
    if (tmp) [tmp release]; tmp = nil;
#endif
    
    return length;
}

@end

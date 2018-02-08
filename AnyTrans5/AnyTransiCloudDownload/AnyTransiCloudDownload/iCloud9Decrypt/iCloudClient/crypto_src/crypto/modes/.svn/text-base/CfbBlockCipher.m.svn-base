//
//  CfbBlockCipher.m
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "CfbBlockCipher.h"
#import "CategoryExtend.h"
#import "ParametersWithIV.h"

@interface CfbBlockCipher ()

@property (nonatomic, readwrite, retain) NSMutableData *iv;
@property (nonatomic, readwrite, retain) NSMutableData *cfbV;
@property (nonatomic, readwrite, retain) NSMutableData *cfbOutV;
@property (nonatomic, readwrite, assign) BOOL encrypting;

@property (nonatomic, readwrite, assign) int blockSize;
@property (nonatomic, readwrite, retain) BlockCipher *cipher;

@end

@implementation CfbBlockCipher
@synthesize iv = _iv;
@synthesize cfbV = _cfbV;
@synthesize cfbOutV = _cfbOutV;
@synthesize encrypting = _encrypting;
@synthesize blockSize = _blockSize;
@synthesize cipher = _cipher;

/**
 * Basic constructor.
 *
 * @param cipher the block cipher to be used as the basis of the
 * feedback mode.
 * @param blockSize the block size in bits (note: a multiple of 8)
 */
- (id)initWithCipher:(BlockCipher*)cipher withBitBlockSize:(int)bitBlockSize {
    if (self = [super init]) {
        @autoreleasepool {
            [self setCipher:cipher];
            [self setBlockSize:(bitBlockSize / 8)];
            int blocksize = [cipher getBlockSize];
            NSMutableData *tmpIV = [[NSMutableData alloc] initWithSize:blocksize];
            [self setIv:tmpIV];
            NSMutableData *tmpCfbV = [[NSMutableData alloc] initWithSize:blocksize];
            [self setCfbV:tmpCfbV];
            NSMutableData *tmpCfbOutV = [[NSMutableData alloc] initWithSize:blocksize];
            [self setCfbOutV:tmpCfbOutV];
#if !__has_feature(objc_arc)
            if (tmpIV != nil) [tmpIV release]; tmpIV = nil;
            if (tmpCfbV != nil) [tmpCfbV release]; tmpCfbV = nil;
            if (tmpCfbOutV != nil) [tmpCfbOutV release]; tmpCfbOutV = nil;
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
    [self setCfbV:nil];
    [self setCfbOutV:nil];
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
 * An IV which is too short is handled in FIPS compliant fashion.
 *
 * @param forEncryption if true the cipher is initialised for
 *  encryption, if false for decryption.
 * @param param the key and other data required by the cipher.
 * @exception ArgumentException if the parameters argument is
 * inappropriate.
 */
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters *)parameters {
    [self setEncrypting:forEncryption];
    if (parameters != nil && [parameters isKindOfClass:[ParametersWithIV class]]) {
        ParametersWithIV *ivParam = (ParametersWithIV*)parameters;
        NSMutableData *IV = [ivParam getIV];
        int diff = (int)([self iv].length - IV.length);
        [[self iv] copyFromIndex:diff withSource:IV withSourceIndex:0 withLength:(int)(IV.length)];
        [[self iv] clearFromIndex:0 withLength:diff];
        
        parameters = [ivParam parameters];
    }
    [self reset];
    
    // if it's null, key is to be reused.
    if (parameters != nil) {
        [[self cipher] init:YES withParameters:parameters];
    }
}

/**
 * return the algorithm name and mode.
 *
 * @return the name of the underlying algorithm followed by "/CFB"
 * and the block size in bits.
 */
- (NSString*)algorithmName {
    return [NSString stringWithFormat:@"%@/CFB%d", [[self cipher] algorithmName], (self.blockSize * 8)];
}

- (BOOL)isPartialBlockOkay {
    return YES;
}

/**
 * return the block size we are operating at.
 *
 * @return the block size we are operating at (in bytes).
 */
- (int)getBlockSize {
    return self.blockSize;
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
    return self.encrypting ? [self encryptBlock:inBuf withInOff:inOff withOutBytes:outBuf withOutOff:outOff] : [self decryptBlock:inBuf withInOff:inOff withOutBytes:outBuf withOutOff:outOff];
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
 * @exception InvalidOperationException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)encryptBlock:(NSMutableData*)input withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    if ((inOff + self.blockSize) > (int)(input.length)) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"input buffer too short" userInfo:nil];
    }
    if ((outOff + self.blockSize) > (int)(outBytes.length)) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"output buffer too short" userInfo:nil];
    }
    [[self cipher] processBlock:[self cfbV] withInOff:0 withOutBuf:[self cfbOutV] withOutOff:0];
    // XOR the cfbV with the plaintext producing the ciphertext
    for (int i = 0; i < self.blockSize; i++) {
        ((Byte*)(outBytes.bytes))[outOff + i] = (Byte)((((Byte*)([self cfbOutV].bytes))[i]) ^ (((Byte*)(input.bytes))[inOff + i]));
    }
    // change over the input block.
    [[self cfbV] copyFromIndex:0 withSource:[self cfbV] withSourceIndex:self.blockSize withLength:((int)([self cfbV].length) - self.blockSize)];
    [[self cfbV] copyFromIndex:((int)([self cfbV].length) - self.blockSize) withSource:outBytes withSourceIndex:outOff withLength:self.blockSize];
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
 * @exception InvalidOperationException if the cipher isn't initialised.
 * @return the number of bytes processed and produced.
 */
- (int)decryptBlock:(NSMutableData*)input withInOff:(int)inOff withOutBytes:(NSMutableData*)outBytes withOutOff:(int)outOff {
    if ((inOff + self.blockSize) > (int)(input.length)) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"input buffer too short" userInfo:nil];
    }
    if ((outOff + self.blockSize) > (int)(outBytes.length)) {
        @throw [NSException exceptionWithName:@"DataLength" reason:@"output buffer too short" userInfo:nil];
    }
    [[self cipher] processBlock:[self cfbV] withInOff:0 withOutBuf:[self cfbOutV] withOutOff:0];
    // change over the input block.
    [[self cfbV] copyFromIndex:0 withSource:[self cfbV] withSourceIndex:self.blockSize withLength:((int)([self cfbV].length) - self.blockSize)];
    [[self cfbV] copyFromIndex:((int)([self cfbV].length) - self.blockSize) withSource:input withSourceIndex:inOff withLength:self.blockSize];
    // XOR the cfbV with the ciphertext producing the plaintext
    for (int i = 0; i < self.blockSize; i++) {
        ((Byte*)(outBytes.bytes))[outOff + i] = (Byte)((((Byte*)([self cfbOutV].bytes))[i]) ^ (((Byte*)(input.bytes))[inOff + i]));
        
    }
    return self.blockSize;
}

/**
 * reset the chaining vector back to the IV and reset the underlying
 * cipher.
 */
 -(void)reset {
     [[self cfbV] copyFromIndex:0 withSource:[self iv] withSourceIndex:0 withLength:(int)([self iv].length)];
     [[self cipher] reset];
}

@end

//
//  PaddedBufferedBlockCipher.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "PaddedBufferedBlockCipher.h"
#import "BlockCipher.h"
#import "BlockCipherPadding.h"
#import "CipherParameters.h"
#import "ParametersWithRandom.h"
#import "Pkcs7Padding.h"
#import "CategoryExtend.h"
#import "Check.h"

@interface PaddedBufferedBlockCipher ()

@property (nonatomic, readwrite, retain) BlockCipherPadding *padding;

@end

@implementation PaddedBufferedBlockCipher
@synthesize padding = _padding;

/**
 * Create a buffered block cipher with the desired padding.
 *
 * @param cipher the underlying block cipher this buffering object wraps.
 * @param padding the padding type.
 */
- (id)initWithCipher:(BlockCipher*)cipher withPadding:(BlockCipherPadding*)padding {
    if (self = [super init]) {
        @autoreleasepool {
            [self setCipher:cipher];
            [self setPadding:padding];
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:[cipher getBlockSize]];
            [self setBuf:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
            [self setBufOff:0];
        }
        return self;
    } else {
        return nil;
    }
}

/**
 * Create a buffered block cipher Pkcs7 padding
 *
 * @param cipher the underlying block cipher this buffering object wraps.
 */
- (id)initWithCipher:(BlockCipher*)cipher {
    Pkcs7Padding *pkcs7 = [[Pkcs7Padding alloc] init];
    if (self = [self initWithCipher:cipher withPadding:pkcs7]) {
#if !__has_feature(objc_arc)
        if (pkcs7 != nil) [pkcs7 release]; pkcs7 = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (pkcs7 != nil) [pkcs7 release]; pkcs7 = nil;
#endif
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setPadding:nil];
    [super dealloc];
#endif
}

/**
 * initialise the cipher.
 *
 * @param forEncryption if true the cipher is initialised for
 *  encryption, if false for decryption.
 * @param param the key and other data required by the cipher.
 * @exception ArgumentException if the parameters argument is
 * inappropriate.
 */
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
    [self setForEncryption:forEncryption];
    SecureRandom *initRandom = nil;
    if (parameters != nil && [parameters isKindOfClass:[ParametersWithRandom class]]) {
        ParametersWithRandom *p = (ParametersWithRandom*)parameters;
        initRandom = [p random];
        parameters = [p parameters];
    }
    
    [self reset];
    [[self padding] init:initRandom];
    [[self cipher] init:forEncryption withParameters:parameters];
}

/**
 * return the minimum size of the output buffer required for an update
 * plus a doFinal with an input of len bytes.
 *
 * @param len the length of the input.
 * @return the space required to accommodate a call to update and doFinal
 * with len bytes of input.
 */
- (int)getOutputSize:(int)inputLen {
    int total = inputLen + self.bufOff;
    int leftOver = total % (int)([self buf].length);
    
    if (leftOver == 0) {
        if ([self forEncryption]) {
            return total + (int)([self buf].length);
        }
        
        return total;
    }
    
    return total - leftOver + (int)([self buf].length);
}

/**
 * return the size of the output buffer required for an update
 * an input of len bytes.
 *
 * @param len the length of the input.
 * @return the space required to accommodate a call to update
 * with len bytes of input.
 */
- (int)getUpdateOutputSize:(int)inputLen {
    int total = inputLen + self.bufOff;
    int leftOver = total % (int)([self buf].length);
    
    if (leftOver == 0) {
        return total - (int)([self buf].length);
    }
    
    return total - leftOver;
}

/**
 * process a single byte, producing an output block if necessary.
 *
 * @param in the input byte.
 * @param out the space for any output that might be produced.
 * @param outOff the offset from which the output will be copied.
 * @return the number of output bytes copied to out.
 * @exception DataLengthException if there isn't enough space in out.
 * @exception InvalidOperationException if the cipher isn't initialised.
 */
- (int)processByte:(Byte)input withOutput:(NSMutableData*)output withOutOff:(int)outOff {
    int resultLen = 0;
    
    if (self.bufOff == [self buf].length) {
        resultLen = [[self cipher] processBlock:[self buf] withInOff:0 withOutBuf:output withOutOff:outOff];
        self.bufOff = 0;
    }
    
    ((Byte*)([self buf].bytes))[self.bufOff++] = input;
    
    return resultLen;
}

/**
 * process an array of bytes, producing output if necessary.
 *
 * @param in the input byte array.
 * @param inOff the offset at which the input data starts.
 * @param len the number of bytes to be copied out of the input array.
 * @param out the space for any output that might be produced.
 * @param outOff the offset from which the output will be copied.
 * @return the number of output bytes copied to out.
 * @exception DataLengthException if there isn't enough space in out.
 * @exception InvalidOperationException if the cipher isn't initialised.
 */
- (int)processBytes:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length withOutput:(NSMutableData*)output withOutOff:(int)outOff {
    if (length < 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Can't have a negative input length!" userInfo:nil];
    }
    
    int blockSize = [self getBlockSize];
    int outLength = [self getUpdateOutputSize:length];
    
    if (outLength > 0) {
        [Check outputLength:output withOff:outOff withLen:outLength withMsg:@"output buffer too short"];
    }
    
    int resultLen = 0;
    int gapLen = (int)([self buf].length) - self.bufOff;
    
    if (length > gapLen) {
        [[self buf] copyFromIndex:self.bufOff withSource:input withSourceIndex:inOff withLength:gapLen];
        
        resultLen += [[self cipher] processBlock:[self buf] withInOff:0 withOutBuf:output withOutOff:outOff];
        
        self.bufOff = 0;
        length -= gapLen;
        inOff += gapLen;
        
        while (length > [self buf].length) {
            resultLen += [[self cipher] processBlock:input withInOff:inOff withOutBuf:output withOutOff:(outOff + resultLen)];
            
            length -= blockSize;
            inOff += blockSize;
        }
    }
    
    [[self buf] copyFromIndex:self.bufOff withSource:input withSourceIndex:inOff withLength:length];
    
    self.bufOff += length;
    
    return resultLen;
}

/**
 * Process the last block in the buffer. If the buffer is currently
 * full and padding needs to be added a call to doFinal will produce
 * 2 * GetBlockSize() bytes.
 *
 * @param out the array the block currently being held is copied into.
 * @param outOff the offset at which the copying starts.
 * @return the number of output bytes copied to out.
 * @exception DataLengthException if there is insufficient space in out for
 * the output or we are decrypting and the input is not block size aligned.
 * @exception InvalidOperationException if the underlying cipher is not
 * initialised.
 * @exception InvalidCipherTextException if padding is expected and not found.
 */
- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    int blockSize = [[self cipher] getBlockSize];
    int resultLen = 0;
    
    if ([self forEncryption]) {
        if (self.bufOff == blockSize) {
            if ((outOff + 2 * blockSize) > (int)(output.length)) {
                [self reset];
                
                @throw [NSException exceptionWithName:@"OutputLength" reason:@"output buffer too short" userInfo:nil];
            }
            
            resultLen = [[self cipher] processBlock:[self buf] withInOff:0 withOutBuf:output withOutOff:outOff];
            self.bufOff = 0;
        }
        
        [[self padding] addPadding:[self buf] withInOff:self.bufOff];
        
        resultLen += [[self cipher] processBlock:[self buf] withInOff:0 withOutBuf:output withOutOff:(outOff + resultLen)];
        
        [self reset];
    } else {
        if (self.bufOff == blockSize) {
            resultLen = [[self cipher] processBlock:[self buf] withInOff:0 withOutBuf:[self buf] withOutOff:0];
            self.bufOff = 0;
        } else {
            [self reset];
            
            @throw [NSException exceptionWithName:@"DataLength" reason:@"last block incomplete in decryption" userInfo:nil];
        }
        
        @try {
            resultLen -= [[self padding] padCount:[self buf]];
            
            [output copyFromIndex:outOff withSource:[self buf] withSourceIndex:0 withLength:resultLen];
        }
        @finally {
            [self reset];
        }
    }
    
    return resultLen;
}

@end

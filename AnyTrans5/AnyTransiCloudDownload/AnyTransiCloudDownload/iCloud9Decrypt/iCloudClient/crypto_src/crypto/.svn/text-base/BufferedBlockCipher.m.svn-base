//
//  BufferedBlockCipher.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "BufferedBlockCipher.h"
#import "BlockCipher.h"
#import "ParametersWithRandom.h"
#import "Check.h"

#import "CategoryExtend.h"

@implementation BufferedBlockCipher
@synthesize buf = _buf;
@synthesize bufOff = _bufOff;
@synthesize forEncryption = _forEncryption;
@synthesize cipher = _cipher;

/**
 * constructor for subclasses
 */
- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}


/**
 * Create a buffered block cipher without padding.
 *
 * @param cipher the underlying block cipher this buffering object wraps.
 * false otherwise.
 */
- (id)initWithCipher:(BlockCipher*)cipher {
    if (self = [self init]) {
        if (cipher == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"cipher" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        
        @autoreleasepool {
            [self setCipher:cipher];
            NSMutableData *tmpBuf = [[NSMutableData alloc] initWithSize:[[self cipher] getBlockSize]];
            [self setBuf:tmpBuf];
            [self setBufOff:0];
#if !__has_feature(objc_arc)
            if (tmpBuf != nil) [tmpBuf release]; tmpBuf = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setBuf:nil];
    [self setCipher:nil];
    [super dealloc];
#endif
}

- (NSString*)algorithmName {
    return [[self cipher] algorithmName];
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
// Note: This doubles as the Init in the event that this cipher is being used as an IWrapper
- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
    [self setForEncryption:forEncryption];
    
    ParametersWithRandom *pwr = nil;
    if (parameters != nil && [parameters isKindOfClass:[ParametersWithRandom class]]) {
        pwr = (ParametersWithRandom*)parameters;
    }
    if (pwr != nil) {
        parameters = [pwr parameters];
    }
    
    [self reset];
    
    [[self cipher] init:forEncryption withParameters:parameters];
}

/**
 * return the blocksize for the underlying cipher.
 *
 * @return the blocksize for the underlying cipher.
 */
- (int)getBlockSize {
    return [[self cipher] getBlockSize];
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
    int leftOver = total % [[self buf] length];
    return total - leftOver;
}

/**
 * return the size of the output buffer required for an update plus a
 * doFinal with an input of len bytes.
 *
 * @param len the length of the input.
 * @return the space required to accommodate a call to update and doFinal
 * with len bytes of input.
 */
- (int)getOutputSize:(int)inputLen {
    return inputLen + self.bufOff;
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
    ((Byte*)([self buf].bytes))[self.bufOff++] = input;
    
    if (self.bufOff == [self buf].length) {
        if ((outOff + [self buf].length) > output.length) {
            @throw [NSException exceptionWithName:@"DataLength" reason:@"output buffer too short" userInfo:nil];
        }
        
        self.bufOff = 0;
        return [[self cipher] processBlock:[self buf] withInOff:0 withOutBuf:output withOutOff:outOff];
    }
    
    return 0;
}

- (NSMutableData*)processByte:(Byte)input {
    NSMutableData *outBytes = nil;
    @autoreleasepool {
        int outLength = [self getUpdateOutputSize:1];
        
        outBytes = outLength > 0 ? [[NSMutableData alloc] initWithSize:outLength] : nil;
        
        int pos = [self processByte:input withOutput:outBytes withOutOff:0];
        
        if (outLength > 0 && pos < outLength) {
            NSMutableData *tmp = [[NSMutableData alloc] initWithSize:pos];
            [tmp copyFromIndex:0 withSource:outBytes withSourceIndex:0 withLength:pos];
#if !__has_feature(objc_arc)
            if (outBytes != nil) [outBytes release]; outBytes = nil;
#endif
            outBytes = tmp;
        }
    }
    return (outBytes ? [outBytes autorelease] : nil);
}

- (NSMutableData*)processBytes:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    if (input == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"input" userInfo:nil];
    }
    
    if (length < 1) {
        return nil;
    }
    
    NSMutableData *outBytes = nil;
    @autoreleasepool {
        int outLength = [self getUpdateOutputSize:length];
        
        outBytes = outLength > 0 ? [[NSMutableData alloc] initWithSize:outLength] : nil;
        
        int pos = [self processBytes:input withInOff:inOff withLength:length withOutput:outBytes withOutOff:0];
        
        if (outLength > 0 && pos < outLength) {
            NSMutableData *tmp = [[NSMutableData alloc] initWithSize:pos];
            [tmp copyFromIndex:0 withSource:outBytes withSourceIndex:0 withLength:pos];
#if !__has_feature(objc_arc)
            if (outBytes != nil) [outBytes release]; outBytes = nil;
#endif
            outBytes = tmp;
        }
    }
    return (outBytes ? [outBytes autorelease] : nil);
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
- (int)processBytes:(NSMutableData *)input withInOff:(int)inOff withLength:(int)length withOutput:(NSMutableData *)output withOutOff:(int)outOff {
    if (length < 1) {
        if (length < 0) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Can't have a negative input length!" userInfo:nil];
        }
        return 0;
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
    if (self.bufOff == [self buf].length) {
        resultLen += [[self cipher] processBlock:[self buf] withInOff:0 withOutBuf:output withOutOff:(outOff + resultLen)];
        self.bufOff = 0;
    }
    return resultLen;
}

- (NSMutableData*)doFinal {
    NSMutableData *outBytes = [BufferedBlockCipher EmptyBuffer];
    
    int length = [self getOutputSize:0];
    if (length > 0) {
        outBytes = [[NSMutableData alloc] initWithSize:length];
        @autoreleasepool {
            int pos = [self doFinal:outBytes withOutOff:0];
            if (pos < outBytes.length) {
                NSMutableData *tmp = [[NSMutableData alloc] initWithSize:pos];
                [tmp copyFromIndex:0 withSource:outBytes withSourceIndex:0 withLength:pos];
#if !__has_feature(objc_arc)
                if (outBytes != nil) [outBytes release]; outBytes = nil;
#endif
                outBytes = tmp;
            }
        }
        [outBytes autorelease];
    } else {
        [self reset];
    }
    
    return outBytes;
}

- (NSMutableData*)doFinal:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    if (input == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"input" userInfo:nil];
    }
    
    int len = [self getOutputSize:length];
    
    NSMutableData *outBytes = [BufferedBlockCipher EmptyBuffer];
    
    if (len > 0) {
        outBytes = [[NSMutableData alloc] initWithSize:len];
        @autoreleasepool {
            int pos = (length > 0) ? [self processBytes:input withInOff:inOff withLength:length withOutput:outBytes withOutOff:0] : 0;
            
            pos += [self doFinal:outBytes withOutOff:pos];
            
            if (pos < outBytes.length) {
                NSMutableData *tmp = [[NSMutableData alloc] initWithSize:pos];
                [tmp copyFromIndex:0 withSource:outBytes withSourceIndex:0 withLength:pos];
#if !__has_feature(objc_arc)
                if (outBytes != nil) [outBytes release]; outBytes = nil;
#endif
                outBytes = tmp;
            }
        }
        [outBytes autorelease];
    } else {
        [self reset];
    }
    
    return outBytes;
}

/**
 * Process the last block in the buffer.
 *
 * @param out the array the block currently being held is copied into.
 * @param outOff the offset at which the copying starts.
 * @return the number of output bytes copied to out.
 * @exception DataLengthException if there is insufficient space in out for
 * the output, or the input is not block size aligned and should be.
 * @exception InvalidOperationException if the underlying cipher is not
 * initialised.
 * @exception InvalidCipherTextException if padding is expected and not found.
 * @exception DataLengthException if the input is not block size
 * aligned.
 */
- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    @try {
        if (self.bufOff != 0) {
            [Check dataLength:![[self cipher] isPartialBlockOkay] withMsg:@"data not block size aligned"];
            [Check outputLength:output withOff:outOff withLen:self.bufOff withMsg:@"output buffer too short for DoFinal()"];
            
            // NB: Can't copy directly, or we may write too much output
            [[self cipher] processBlock:[self buf] withInOff:0 withOutBuf:[self buf] withOutOff:0];
            [output copyFromIndex:outOff withSource:[self buf] withSourceIndex:0 withLength:self.bufOff];
        }
        
        return self.bufOff;
    }
    @finally {
        [self reset];
    }
}

/**
 * Reset the buffer and cipher. After resetting the object is in the same
 * state as it was after the last init (if there was one).
 */
- (void)reset {
    [[self buf] clearFromIndex:0 withLength:(int)([self buf].length)];
    self.bufOff = 0;
    
    [[self cipher] reset];
}

@end

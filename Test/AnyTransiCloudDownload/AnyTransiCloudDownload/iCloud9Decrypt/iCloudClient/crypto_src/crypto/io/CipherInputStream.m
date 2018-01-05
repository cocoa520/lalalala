//
//  CipherInputStream.m
//  
//
//  Created by Pallas on 8/30/16.
//
//  Complete

#import "CipherInputStream.h"
#import "Arrays.h"
#import "BufferedBlockCipher.h"
#import "CategoryExtend.h"

@interface CipherInputStream ()

@property (nonatomic, readwrite, retain) Stream *iN;
@property (nonatomic, readwrite, retain) BufferedBlockCipher *bufferedBlockCipher;
@property (nonatomic, readwrite, retain) NSMutableData *inBuf;
@property (nonatomic, readwrite, retain) NSMutableData *buf;
@property (nonatomic, readwrite, assign) int bufOff;
@property (nonatomic, readwrite, assign) int maxBuf;
@property (nonatomic, readwrite, assign) BOOL finalized;

@end

@implementation CipherInputStream
@synthesize iN = _iN;
@synthesize bufferedBlockCipher = _bufferedBlockCipher;
@synthesize inBuf = _inBuf;
@synthesize buf = _buf;
@synthesize bufOff = _bufOff;
@synthesize maxBuf = _maxBuf;
@synthesize finalized = _finalized;

+ (int)INPUT_BUF_SIZE {
    return 2048;
}

- (id)initWithIs:(Stream*)is withCipher:(BufferedBlockCipher*)cipher {
    if (self = [self initWithIs:is withCipher:cipher withBufSize:[CipherInputStream INPUT_BUF_SIZE]]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithIs:(Stream*)is withCipher:(BufferedBlockCipher*)cipher withBufSize:(int)bufSize {
    if (self = [super init]) {
        @autoreleasepool {
            [self setIN:is];
            [self setBufferedBlockCipher:cipher];
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:bufSize];
            [self setInBuf:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setIN:nil];
    [self setBufferedBlockCipher:nil];
    [self setInBuf:nil];
    [super dealloc];
#endif
}

/**
 * Read data from underlying stream and process with cipher until end of stream or some data is
 * available after cipher processing.
 *
 * @return -1 to indicate end of stream, or the number of bytes (> 0) available.
 */
- (int)nextChunk {
    if (self.finalized) {
        return -1;
    }
    
    self.bufOff = 0;
    self.maxBuf = 0;
    
    // Keep reading until EOF or cipher processing produces data
    while (self.maxBuf == 0) {
        int read = [[self iN] read:[self inBuf]];
        if (read == -1) {
            [self finaliseCipher];
            if (self.maxBuf == 0) {
                return -1;
            }
            return self.maxBuf;
        }
        
        @try {
            [self ensureCapacity:read withFinalOutput:NO];
            if ([self bufferedBlockCipher] != nil) {
                [self setMaxBuf:[[self bufferedBlockCipher] processBytes:[self inBuf] withInOff:0 withLength:read withOutput:[self buf] withOutOff:0]];
            }
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:@"CipherIO" reason:@"Error processing stream" userInfo:[exception userInfo]];
        }
    }
    return self.maxBuf;
}

- (void)finaliseCipher {
    @autoreleasepool {
        @try {
            self.finalized = YES;
            [self ensureCapacity:0 withFinalOutput:YES];
            if ([self bufferedBlockCipher]) {
                [self setMaxBuf:[[self bufferedBlockCipher] doFinal:[self buf] withOutOff:0]];
            } else {
                [self setMaxBuf:0]; // a stream cipher
            }
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:@"Exception" reason:@"Error finalising cipher" userInfo:[exception userInfo]];
        }
    }
}

/**
 * Reads data from the underlying stream and processes it with the cipher until the cipher
 * outputs data, and returns the next available byte.
 * <p>
 * If the underlying stream is exhausted by this call, the cipher will be finalised.
 * </p>
 * @throws IOException if there was an error closing the input stream.
 * @throws InvalidCipherTextIOException if the data read from the stream was invalid ciphertext
 * (e.g. the cipher is an AEAD cipher and the ciphertext tag check fails).
 */
- (int)read {
    if (self.bufOff >= self.maxBuf) {
        if ([self nextChunk] < 0) {
            return -1;
        }
    }
    
    return ((Byte*)([self buf].bytes))[self.bufOff++] & 0xff;
}

/**
 * Reads data from the underlying stream and processes it with the cipher until the cipher
 * outputs data, and then returns up to <code>b.length</code> bytes in the provided array.
 * <p>
 * If the underlying stream is exhausted by this call, the cipher will be finalised.
 * </p>
 * @param b the buffer into which the data is read.
 * @return the total number of bytes read into the buffer, or <code>-1</code> if there is no
 *         more data because the end of the stream has been reached.
 * @throws IOException if there was an error closing the input stream.
 * @throws InvalidCipherTextIOException if the data read from the stream was invalid ciphertext
 * (e.g. the cipher is an AEAD cipher and the ciphertext tag check fails).
 */
- (int)read:(NSMutableData*)buffer {
    return [self read:buffer withOff:0 withLen:(int)(buffer.length)];
}

/**
 * Reads data from the underlying stream and processes it with the cipher until the cipher
 * outputs data, and then returns up to <code>len</code> bytes in the provided array.
 * <p>
 * If the underlying stream is exhausted by this call, the cipher will be finalised.
 * </p>
 * @param b   the buffer into which the data is read.
 * @param off the start offset in the destination array <code>b</code>
 * @param len the maximum number of bytes read.
 * @return the total number of bytes read into the buffer, or <code>-1</code> if there is no
 *         more data because the end of the stream has been reached.
 * @throws IOException if there was an error closing the input stream.
 * @throws InvalidCipherTextIOException if the data read from the stream was invalid ciphertext
 * (e.g. the cipher is an AEAD cipher and the ciphertext tag check fails).
 */
- (int)read:(NSMutableData*)buffer withOff:(int)offset withLen:(int)count {
    if (self.bufOff >= self.maxBuf) {
        if ([self nextChunk] < 0) {
            return -1;
        }
    }
    
    int toSupply = MIN(count, [self available]);
    [buffer copyFromIndex:offset withSource:[self buf] withSourceIndex:[self bufOff] withLength:toSupply];
    self.bufOff += toSupply;
    return toSupply;
}

- (int64_t)skip:(int64_t)n {
    if (n <= 0) {
        return 0;
    }
    
    int skip = (int)MIN(n, [self available]);
    self.bufOff += skip;
    
    return skip;
}

- (int)available {
    return self.maxBuf - self.bufOff;
}

/**
 * Ensure the cipher text buffer has space sufficient to accept an upcoming output.
 *
 * @param updateSize the size of the pending update.
 * @param finalOutput <code>true</code> iff this the cipher is to be finalised.
 */
- (void)ensureCapacity:(int)updateSize withFinalOutput:(BOOL)finalOutput {
    int bufLen = updateSize;
    if (finalOutput) {
        if ([self bufferedBlockCipher]) {
            bufLen = [[self bufferedBlockCipher] getOutputSize:updateSize];
        }
    } else {
        if ([self bufferedBlockCipher]) {
            bufLen = [[self bufferedBlockCipher] getUpdateOutputSize:updateSize];
        }
    }
    
    if ((![self buf]) || ([self buf].length < bufLen)) {
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:bufLen];
        [self setBuf:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
    }
}

/**
 * Closes the underlying input stream and finalises the processing of the data by the cipher.
 *
 * @throws IOException if there was an error closing the input stream.
 * @throws InvalidCipherTextIOException if the data read from the stream was invalid ciphertext
 *             (e.g. the cipher is an AEAD cipher and the ciphertext tag check fails).
 */
- (void)close {
    @try {
        [[self iN] close];
    }
    @finally {
        if (![self finalized]) {
            [self finaliseCipher];
        }
    }
    self.maxBuf = self.bufOff = 0;
    if ([self buf]) {
        [self setBuf:nil];
    }
    [Arrays fillWithByteArray:[self inBuf] withB:(Byte)0];
}

/**
 * Return true if mark(readlimit) is supported. This will be true if the underlying stream supports marking and the
 * cipher used is a SkippingCipher,
 *
 * @return true if mark(readlimit) supported, false otherwise.
 */
- (BOOL)markSupported {
    return NO;
}

@end

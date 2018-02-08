//
//  GeneralDigest.m
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "GeneralDigest.h"
#import "CategoryExtend.h"

@interface GeneralDigest ()

@property (nonatomic, readwrite, retain) NSMutableData *xBuf;
@property (nonatomic, readwrite, assign) int xBufOff;
@property (nonatomic, readwrite, assign) int64_t byteCount;

@end

@implementation GeneralDigest
@synthesize xBuf = _xBuf;
@synthesize xBufOff = _xBufOff;
@synthesize byteCount = _byteCount;

static const int BYTE_LENGTH = 64;

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:4];
            [self setXBuf:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithGeneralDigest:(GeneralDigest*)t {
    if (self = [super init]) {
        @autoreleasepool {
            int length = (int)([t xBuf].length);
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:length];
            [self setXBuf:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
            [self copyIn:t];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setXBuf:nil];
    [super dealloc];
#endif
}

- (void)copyIn:(GeneralDigest*)t {
    int length = (int)([t xBuf].length);
    [[self xBuf] copyFromIndex:0 withSource:[t xBuf] withSourceIndex:0 withLength:length];
    
    [self setXBufOff:t.xBufOff];
    [self setByteCount:t.byteCount];
}

- (void)update:(Byte)input {
    ((Byte*)([self xBuf].bytes))[self.xBufOff++] = input;
    
    if (self.xBufOff == (int)([self xBuf].length)) {
        [self processWord:[self xBuf] withInOff:0];
        self.xBufOff = 0;
    }
    
    self.byteCount++;
}

- (void)blockUpdate:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    length = MAX(0, length);
    
    // fill the current word
    int i = 0;
    if (self.xBufOff != 0) {
        while (i < length) {
            ((Byte*)([self xBuf].bytes))[self.xBufOff++] = ((Byte*)(input.bytes))[inOff + i++];
            if (self.xBufOff == 4) {
                [self processWord:[self xBuf] withInOff:0];
                self.xBufOff = 0;
                break;
            }
        }
    }
    
    // process whole words.
    int limit = ((length - i) & ~3) + i;
    for (; i < limit; i += 4) {
        [self processWord:input withInOff:(inOff + i)];
    }

    // load in the remainder.
    while (i < length) {
        ((Byte*)([self xBuf].bytes))[self.xBufOff++] = ((Byte*)(input.bytes))[inOff + i++];
    }
    
    self.byteCount += length;
}

- (void)finish {
    int64_t bitLength = (self.byteCount << 3);
    
    // add the pad bytes.
    [self update:(Byte)128];
    
    while (self.xBufOff != 0) [self update:(Byte)0];
    [self processLength:bitLength];
    [self processBlock];
}

- (void)reset {
    self.byteCount = 0;
    self.xBufOff = 0;
    [[self xBuf] clearFromIndex:0 withLength:(int)([self xBuf].length)];
}

- (int)getByteLength {
    return BYTE_LENGTH;
}

- (void)processWord:(NSMutableData*)input withInOff:(int)inOff {
}

- (void)processLength:(int64_t)bitLength {
}

- (void)processBlock {
}

- (NSString*)algorithmName {
    return nil;
}

- (int)getDigestSize {
    return 0;
}

- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    return 0;
}

- (Memoable*)copy {
    return nil;
}

- (void)reset:(Memoable*)other {
}

@end

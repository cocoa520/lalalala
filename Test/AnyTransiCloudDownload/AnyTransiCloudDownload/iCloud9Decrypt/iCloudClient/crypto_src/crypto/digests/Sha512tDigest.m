//
//  Sha512tDigest.m
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "Sha512tDigest.h"

@interface Sha512tDigest ()

@property (nonatomic, readwrite, assign) int digestLength;
@property (nonatomic, readwrite, assign) uint64_t h1t;
@property (nonatomic, readwrite, assign) uint64_t h2t;
@property (nonatomic, readwrite, assign) uint64_t h3t;
@property (nonatomic, readwrite, assign) uint64_t h4t;
@property (nonatomic, readwrite, assign) uint64_t h5t;
@property (nonatomic, readwrite, assign) uint64_t h6t;
@property (nonatomic, readwrite, assign) uint64_t h7t;
@property (nonatomic, readwrite, assign) uint64_t h8t;

@end

@implementation Sha512tDigest
@synthesize digestLength = _digestLength;
@synthesize h1t = _h1t;
@synthesize h2t = _h2t;
@synthesize h3t = _h3t;
@synthesize h4t = _h4t;
@synthesize h5t = _h5t;
@synthesize h6t = _h6t;
@synthesize h7t = _h7t;
@synthesize h8t = _h8t;

static const uint64_t A5 = 0xa5a5a5a5a5a5a5a5UL;

/**
 * Standard constructor
 */
- (id)initWithBitLength:(int)bitLength {
    if (self = [super init]) {
        if (bitLength >= 512) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"bitLength cannot be >= 512" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (bitLength % 8 != 0) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"bitLength needs to be a multiple of 8" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (bitLength == 384) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"bitLength cannot be 384 use SHA384 instead" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        
        [self setDigestLength:(bitLength / 8)];
        
        [self tIvGenerate:(self.digestLength * 8)];
        
        [self reset];
        return self;
    } else {
        return nil;
    }
   
}

/**
 * Copy constructor.  This will copy the state of the provided
 * message digest.
 */
- (id)initWithSha512tDigest:(Sha512tDigest*)t {
    if (self = [super initWithLongDigest:t]) {
        [self setDigestLength:t.digestLength];
        
        [self reset:t];
        return self;
    } else {
        return nil;
    }
}

- (NSString*)algorithmName {
    return [NSString stringWithFormat:@"SHA-512/%d", (self.digestLength * 8)];
}

- (int)getDigestSize {
    return [self digestLength];
}

- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    [self finish];
    
    [Sha512tDigest UInt64_To_BE:self.h1 withBs:output withOff:outOff withMax:self.digestLength];
    [Sha512tDigest UInt64_To_BE:self.h2 withBs:output withOff:(outOff + 8) withMax:(self.digestLength - 8)];
    [Sha512tDigest UInt64_To_BE:self.h3 withBs:output withOff:(outOff + 16) withMax:(self.digestLength - 16)];
    [Sha512tDigest UInt64_To_BE:self.h4 withBs:output withOff:(outOff + 24) withMax:(self.digestLength - 24)];
    [Sha512tDigest UInt64_To_BE:self.h5 withBs:output withOff:(outOff + 32) withMax:(self.digestLength - 32)];
    [Sha512tDigest UInt64_To_BE:self.h6 withBs:output withOff:(outOff + 40) withMax:(self.digestLength - 40)];
    [Sha512tDigest UInt64_To_BE:self.h7 withBs:output withOff:(outOff + 48) withMax:(self.digestLength - 48)];
    [Sha512tDigest UInt64_To_BE:self.h8 withBs:output withOff:(outOff + 56) withMax:(self.digestLength - 56)];
    
    [self reset];
    
    return self.digestLength;
}

/**
 * reset the chaining variables
 */
- (void)reset {
    [super reset];
    
    /*
     * initial hash values use the iv generation algorithm for t.
     */
    [self setH1:self.h1t];
    [self setH2:self.h2t];
    [self setH3:self.h3t];
    [self setH4:self.h4t];
    [self setH5:self.h5t];
    [self setH6:self.h6t];
    [self setH7:self.h7t];
    [self setH8:self.h8t];
}

- (void)tIvGenerate:(int)bitLength {
    @autoreleasepool {
        [self setH1:(0x6a09e667f3bcc908UL ^ A5)];
        [self setH2:(0xbb67ae8584caa73bUL ^ A5)];
        [self setH3:(0x3c6ef372fe94f82bUL ^ A5)];
        [self setH4:(0xa54ff53a5f1d36f1UL ^ A5)];
        [self setH5:(0x510e527fade682d1UL ^ A5)];
        [self setH6:(0x9b05688c2b3e6c1fUL ^ A5)];
        [self setH7:(0x1f83d9abfb41bd6bUL ^ A5)];
        [self setH8:(0x5be0cd19137e2179UL ^ A5)];
        
        [self update:0x53];
        [self update:0x48];
        [self update:0x41];
        [self update:0x2D];
        [self update:0x35];
        [self update:0x31];
        [self update:0x32];
        [self update:0x2F];
        
        if (bitLength > 100) {
            [self update:((Byte)(bitLength / 100 + 0x30))];
            bitLength = bitLength % 100;
            [self update:((Byte)(bitLength / 10 + 0x30))];
            bitLength = bitLength % 10;
            [self update:((Byte)(bitLength + 0x30))];
        } else if (bitLength > 10) {
            [self update:((Byte)(bitLength / 10 + 0x30))];
            bitLength = bitLength % 10;
            [self update:((Byte)(bitLength + 0x30))];
        } else {
            [self update:((Byte)(bitLength + 0x30))];
        }
        
        [self finish];
        
        [self setH1t:self.h1];
        [self setH2t:self.h2];
        [self setH3t:self.h3];
        [self setH4t:self.h4];
        [self setH5t:self.h5];
        [self setH6t:self.h6];
        [self setH7t:self.h7];
        [self setH8t:self.h8];        
    }
}

+ (void)UInt64_To_BE:(uint64_t)n withBs:(NSMutableData*)bs withOff:(int)off withMax:(int)max {
    if (max > 0) {
        [Sha512tDigest UInt32_To_BE:(uint)(n >> 32) withBs:bs withOff:off withMax:max];
        
        if (max > 4) {
            [Sha512tDigest UInt32_To_BE:(uint)n withBs:bs withOff:(off + 4) withMax:(max - 4)];
        }
    }
}

+ (void)UInt32_To_BE:(uint)n withBs:(NSMutableData*)bs withOff:(int)off withMax:(int)max {
    int num = MIN(4, max);
    while (--num >= 0) {
        int shift = 8 * (3 - num);
        ((Byte*)(bs.bytes))[off + num] = (Byte)(n >> shift);
    }
}

- (Memoable*)copy {
    return [[[Sha512tDigest alloc] initWithSha512tDigest:self] autorelease];
}

- (void)reset:(Memoable*)other {
    Sha512tDigest *t = (Sha512tDigest*)other;
    
    if (self.digestLength != t.digestLength) {
        @throw [NSException exceptionWithName:@"MemoableReset" reason:@"digestLength inappropriate in other" userInfo:nil];
    }
    
    [super copyIn:t];
    
    [self setH1t:t.h1t];
    [self setH2t:t.h2t];
    [self setH3t:t.h3t];
    [self setH4t:t.h4t];
    [self setH5t:t.h5t];
    [self setH6t:t.h6t];
    [self setH7t:t.h7t];
    [self setH8t:t.h8t];
}

@end

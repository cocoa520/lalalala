//
//  Sha256Digest.m
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "Sha256Digest.h"
#import "CategoryExtend.h"
#import "Pack.h"

@interface Sha256Digest ()

@property (nonatomic, readwrite, assign) uint h1;
@property (nonatomic, readwrite, assign) uint h2;
@property (nonatomic, readwrite, assign) uint h3;
@property (nonatomic, readwrite, assign) uint h4;
@property (nonatomic, readwrite, assign) uint h5;
@property (nonatomic, readwrite, assign) uint h6;
@property (nonatomic, readwrite, assign) uint h7;
@property (nonatomic, readwrite, assign) uint h8;
@property (nonatomic, readwrite, retain) NSMutableArray *x;
@property (nonatomic, readwrite, assign) int xOff;

@end

@implementation Sha256Digest
@synthesize h1 = _h1;
@synthesize h2 = _h2;
@synthesize h3 = _h3;
@synthesize h4 = _h4;
@synthesize h5 = _h5;
@synthesize h6 = _h6;
@synthesize h7 = _h7;
@synthesize h8 = _h8;
@synthesize x = _x;
@synthesize xOff = _xOff;

static const int DigestLength = 32;

/* SHA-256 Constants
 * (represent the first 32 bits of the fractional parts of the
 * cube roots of the first sixty-four prime numbers)
 */
+ (NSMutableArray*)K {
    static NSMutableArray *_k = nil;
    @synchronized(self) {
        if (_k == nil) {
            @autoreleasepool {
                _k = [@[@((uint)0x428a2f98), @((uint)0x71374491), @((uint)0xb5c0fbcf), @((uint)0xe9b5dba5),
                        @((uint)0x3956c25b), @((uint)0x59f111f1), @((uint)0x923f82a4), @((uint)0xab1c5ed5),
                        @((uint)0xd807aa98), @((uint)0x12835b01), @((uint)0x243185be), @((uint)0x550c7dc3),
                        @((uint)0x72be5d74), @((uint)0x80deb1fe), @((uint)0x9bdc06a7), @((uint)0xc19bf174),
                        @((uint)0xe49b69c1), @((uint)0xefbe4786), @((uint)0x0fc19dc6), @((uint)0x240ca1cc),
                        @((uint)0x2de92c6f), @((uint)0x4a7484aa), @((uint)0x5cb0a9dc), @((uint)0x76f988da),
                        @((uint)0x983e5152), @((uint)0xa831c66d), @((uint)0xb00327c8), @((uint)0xbf597fc7),
                        @((uint)0xc6e00bf3), @((uint)0xd5a79147), @((uint)0x06ca6351), @((uint)0x14292967),
                        @((uint)0x27b70a85), @((uint)0x2e1b2138), @((uint)0x4d2c6dfc), @((uint)0x53380d13),
                        @((uint)0x650a7354), @((uint)0x766a0abb), @((uint)0x81c2c92e), @((uint)0x92722c85),
                        @((uint)0xa2bfe8a1), @((uint)0xa81a664b), @((uint)0xc24b8b70), @((uint)0xc76c51a3),
                        @((uint)0xd192e819), @((uint)0xd6990624), @((uint)0xf40e3585), @((uint)0x106aa070),
                        @((uint)0x19a4c116), @((uint)0x1e376c08), @((uint)0x2748774c), @((uint)0x34b0bcb5),
                        @((uint)0x391c0cb3), @((uint)0x4ed8aa4a), @((uint)0x5b9cca4f), @((uint)0x682e6ff3),
                        @((uint)0x748f82ee), @((uint)0x78a5636f), @((uint)0x84c87814), @((uint)0x8cc70208),
                        @((uint)0x90befffa), @((uint)0xa4506ceb), @((uint)0xbef9a3f7), @((uint)0xc67178f2)] mutableCopy];
            }
        }
    }
    return _k;
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpX = [[NSMutableArray alloc] initWithSize:64];
            [self setX:tmpX];
#if !__has_feature(objc_arc)
            if (tmpX != nil) [tmpX release]; tmpX = nil;
#endif
            [self initHs];            
        }
        return self;
    } else {
        return nil;
    }
}

/**
 * Copy constructor.  This will copy the state of the provided
 * message digest.
 */
- (id)initWithSha256Digest:(Sha256Digest*)t {
    if (self = [super initWithGeneralDigest:t]) {
        @autoreleasepool {
            NSMutableArray *tmpX = [[NSMutableArray alloc] initWithSize:64];
            [self setX:tmpX];
#if !__has_feature(objc_arc)
            if (tmpX != nil) [tmpX release]; tmpX = nil;
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
    [self setX:nil];
    [super dealloc];
#endif
}

- (void)copyIn:(Sha256Digest*)t {
    [super copyIn:t];
    
    [self setH1:t.h1];
    [self setH2:t.h2];
    [self setH3:t.h3];
    [self setH4:t.h4];
    [self setH5:t.h5];
    [self setH6:t.h6];
    [self setH7:t.h7];
    [self setH8:t.h8];
    
    [[self x] copyFromIndex:0 withSource:[t x] withSourceIndex:0 withLength:(int)([t x].count)];
    [self setXOff:t.xOff];
}

- (NSString*)algorithmName {
    return @"SHA-256";
}

- (int)getDigestSize {
    return DigestLength;
}

- (void)processWord:(NSMutableData*)input withInOff:(int)inOff {
    [self x][self.xOff] = @([Pack BE_To_UInt32:input withOff:inOff]);
    
    if (++self.xOff == 16) {
        [self processBlock];
    }
}

- (void)processLength:(int64_t)bitLength {
    if (self.xOff > 14) {
        [self processBlock];
    }
    
    @autoreleasepool {
        [self x][14] = @((uint)((uint64_t)bitLength >> 32));
        [self x][15] = @((uint)((uint64_t)bitLength));
    }
}

- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    [self finish];
    
    [Pack UInt32_To_BE:self.h1 withBs:output withOff:outOff];
    [Pack UInt32_To_BE:self.h2 withBs:output withOff:(outOff + 4)];
    [Pack UInt32_To_BE:self.h3 withBs:output withOff:(outOff + 8)];
    [Pack UInt32_To_BE:self.h4 withBs:output withOff:(outOff + 12)];
    [Pack UInt32_To_BE:self.h5 withBs:output withOff:(outOff + 16)];
    [Pack UInt32_To_BE:self.h6 withBs:output withOff:(outOff + 20)];
    [Pack UInt32_To_BE:self.h7 withBs:output withOff:(outOff + 24)];
    [Pack UInt32_To_BE:self.h8 withBs:output withOff:(outOff + 28)];
    
    [self reset];
    
    return DigestLength;
}

/**
 * reset the chaining variables
 */
- (void)reset {
    @autoreleasepool {
        [super reset];
        
        [self initHs];
        
        self.xOff = 0;
        [[self x] clearFromIndex:0 withLength:(int)([self x].count)];
    }
}

- (void)initHs {
    /* SHA-256 initial hash value
     * The first 32 bits of the fractional parts of the square roots
     * of the first eight prime numbers
     */
    [self setH1:0x6a09e667];
    [self setH2:0xbb67ae85];
    [self setH3:0x3c6ef372];
    [self setH4:0xa54ff53a];
    [self setH5:0x510e527f];
    [self setH6:0x9b05688c];
    [self setH7:0x1f83d9ab];
    [self setH8:0x5be0cd19];
}

- (void)processBlock {
    @autoreleasepool {
        // expand 16 word block into 64 word blocks.
        for (int ti = 16; ti <= 63; ti++) {
            [self x][ti] = @([Sha256Digest theta1:[([self x][ti -2]) unsignedIntValue]] + [([self x][ti - 7]) unsignedIntValue] + [Sha256Digest theta0:[([self x][ti - 15]) unsignedIntValue]] + [([self x][ti - 16]) unsignedIntValue]);
        }
        
        // set up working variables.
        uint a = self.h1;
        uint b = self.h2;
        uint c = self.h3;
        uint d = self.h4;
        uint e = self.h5;
        uint f = self.h6;
        uint g = self.h7;
        uint h = self.h8;
        
        int t = 0;
        for(int i = 0; i < 8; ++i) {
            // t = 8 * i
            h += [Sha256Digest sum1Ch:e withY:f withZ:g] + [([Sha256Digest K][t]) unsignedIntValue] + [([self x][t]) unsignedIntValue];
            d += h;
            h += [Sha256Digest sum0Maj:a withY:b withZ:c];
            ++t;
            
            // t = 8 * i + 1
            g += [Sha256Digest sum1Ch:d withY:e withZ:f] + [([Sha256Digest K][t]) unsignedIntValue] + [([self x][t]) unsignedIntValue];
            c += g;
            g += [Sha256Digest sum0Maj:h withY:a withZ:b];
            ++t;
            
            // t = 8 * i + 2
            f += [Sha256Digest sum1Ch:c withY:d withZ:e] + [([Sha256Digest K][t]) unsignedIntValue] + [([self x][t]) unsignedIntValue];
            b += f;
            f += [Sha256Digest sum0Maj:g withY:h withZ:a];
            ++t;
            
            // t = 8 * i + 3
            e += [Sha256Digest sum1Ch:b withY:c withZ:d] + [([Sha256Digest K][t]) unsignedIntValue] + [([self x][t]) unsignedIntValue];
            a += e;
            e += [Sha256Digest sum0Maj:f withY:g withZ:h];
            ++t;
            
            // t = 8 * i + 4
            d += [Sha256Digest sum1Ch:a withY:b withZ:c] + [([Sha256Digest K][t]) unsignedIntValue] + [([self x][t]) unsignedIntValue];
            h += d;
            d += [Sha256Digest sum0Maj:e withY:f withZ:g];
            ++t;
            
            // t = 8 * i + 5
            c += [Sha256Digest sum1Ch:h withY:a withZ:b] + [([Sha256Digest K][t]) unsignedIntValue] + [([self x][t]) unsignedIntValue];
            g += c;
            c += [Sha256Digest sum0Maj:d withY:e withZ:f];
            ++t;
            
            // t = 8 * i + 6
            b += [Sha256Digest sum1Ch:g withY:h withZ:a] + [([Sha256Digest K][t]) unsignedIntValue] + [([self x][t]) unsignedIntValue];
            f += b;
            b += [Sha256Digest sum0Maj:c withY:d withZ:e];
            ++t;
            
            // t = 8 * i + 7
            a += [Sha256Digest sum1Ch:f withY:g withZ:h] + [([Sha256Digest K][t]) unsignedIntValue] + [([self x][t]) unsignedIntValue];
            e += a;
            a += [Sha256Digest sum0Maj:b withY:c withZ:d];
            ++t;
        }
        
        self.h1 += a;
        self.h2 += b;
        self.h3 += c;
        self.h4 += d;
        self.h5 += e;
        self.h6 += f;
        self.h7 += g;
        self.h8 += h;
        
        // reset the offset and clean out the word buffer.
        self.xOff = 0;
        [[self x] clearFromIndex:0 withLength:16];
    }
}

+ (uint)sum1Ch:(uint)x withY:(uint)y withZ:(uint)z {
    // return [Sha256Digest sum1:x] + [Sha256Digest ch:x withY:y withZ:z];
    return (((x >> 6) | (x << 26)) ^ ((x >> 11) | (x << 21)) ^ ((x >> 25) | (x << 7))) + ((x & y) ^ ((~x) & z));
}

+ (uint)sum0Maj:(uint)x withY:(uint)y withZ:(uint)z {
    // return [Sha256Digest sum0:x] + [Sha256Digest maj:x withY:y withZ:z];
    return (((x >> 2) | (x << 30)) ^ ((x >> 13) | (x << 19)) ^ ((x >> 22) | (x << 10))) + ((x & y) ^ (x & z) ^ (y & z));
}

/* SHA-256 functions */
//+ (uint)ch:(uint)x withY:(uint)y withZ:(uint)z {
//    return ((x & y) ^ ((~x) & z));
//}
//
//+ (uint)maj:(uint)x withY:(uint)y withZ:(uint)z {
//    return ((x & y) ^ (x & z) ^ (y & z));
//}
//
//+ (uint)sum0:(uint)x {
//    return ((x >> 2) | (x << 30)) ^ ((x >> 13) | (x << 19)) ^ ((x >> 22) | (x << 10));
//}
//
//+ (uint)sum1:(uint)x {
//    return ((x >> 6) | (x << 26)) ^ ((x >> 11) | (x << 21)) ^ ((x >> 25) | (x << 7));
//}

+ (uint)theta0:(uint)x {
    return ((x >> 7) | (x << 25)) ^ ((x >> 18) | (x << 14)) ^ (x >> 3);
}

+ (uint)theta1:(uint)x {
    return ((x >> 17) | (x << 15)) ^ ((x >> 19) | (x << 13)) ^ (x >> 10);
}

- (Memoable*)copy {
    return [[[Sha256Digest alloc] initWithSha256Digest:self] autorelease];
}

- (void)reset:(Memoable*)other {
    Sha256Digest *d = (Sha256Digest*)other;
    
    [self copyIn:d];
}

@end

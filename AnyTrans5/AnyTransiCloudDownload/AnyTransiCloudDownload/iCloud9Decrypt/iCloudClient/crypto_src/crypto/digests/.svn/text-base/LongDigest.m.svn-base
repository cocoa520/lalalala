//
//  LongDigest.m
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "LongDigest.h"
#import "CategoryExtend.h"
#import "Pack.h"

@interface LongDigest ()

@property (nonatomic, readwrite, assign) int myByteLength;
@property (nonatomic, readwrite, retain) NSMutableData *xBuf;
@property (nonatomic, readwrite, assign) int xBufOff;
@property (nonatomic, readwrite, assign) int64_t byteCount1;
@property (nonatomic, readwrite, assign) int64_t byteCount2;
@property (nonatomic, readwrite, retain) NSMutableArray *w;
@property (nonatomic, readwrite, assign) int wOff;

@end

@implementation LongDigest
@synthesize myByteLength = _myByteLength;
@synthesize xBuf = _xBuf;
@synthesize xBufOff = _xBufOff;
@synthesize byteCount1 = _byteCount1;
@synthesize byteCount2 = _byteCount2;
@synthesize h1 = _h1;
@synthesize h2 = _h2;
@synthesize h3 = _h3;
@synthesize h4 = _h4;
@synthesize h5 = _h5;
@synthesize h6 = _h6;
@synthesize h7 = _h7;
@synthesize h8 = _h8;
@synthesize w = _w;
@synthesize wOff = _wOff;

/* SHA-384 and SHA-512 Constants
 * (represent the first 64 bits of the fractional parts of the
 * cube roots of the first sixty-four prime numbers)
 */
// return == uint64_t[]
+ (NSMutableArray*)K {
    static NSMutableArray *_k = nil;
    @synchronized(self) {
        if (_k == nil) {
            @autoreleasepool {
                _k = [@[@((uint64_t)0x428a2f98d728ae22), @((uint64_t)0x7137449123ef65cd), @((uint64_t)0xb5c0fbcfec4d3b2f), @((uint64_t)0xe9b5dba58189dbbc),
                        @((uint64_t)0x3956c25bf348b538), @((uint64_t)0x59f111f1b605d019), @((uint64_t)0x923f82a4af194f9b), @((uint64_t)0xab1c5ed5da6d8118),
                        @((uint64_t)0xd807aa98a3030242), @((uint64_t)0x12835b0145706fbe), @((uint64_t)0x243185be4ee4b28c), @((uint64_t)0x550c7dc3d5ffb4e2),
                        @((uint64_t)0x72be5d74f27b896f), @((uint64_t)0x80deb1fe3b1696b1), @((uint64_t)0x9bdc06a725c71235), @((uint64_t)0xc19bf174cf692694),
                        @((uint64_t)0xe49b69c19ef14ad2), @((uint64_t)0xefbe4786384f25e3), @((uint64_t)0x0fc19dc68b8cd5b5), @((uint64_t)0x240ca1cc77ac9c65),
                        @((uint64_t)0x2de92c6f592b0275), @((uint64_t)0x4a7484aa6ea6e483), @((uint64_t)0x5cb0a9dcbd41fbd4), @((uint64_t)0x76f988da831153b5),
                        @((uint64_t)0x983e5152ee66dfab), @((uint64_t)0xa831c66d2db43210), @((uint64_t)0xb00327c898fb213f), @((uint64_t)0xbf597fc7beef0ee4),
                        @((uint64_t)0xc6e00bf33da88fc2), @((uint64_t)0xd5a79147930aa725), @((uint64_t)0x06ca6351e003826f), @((uint64_t)0x142929670a0e6e70),
                        @((uint64_t)0x27b70a8546d22ffc), @((uint64_t)0x2e1b21385c26c926), @((uint64_t)0x4d2c6dfc5ac42aed), @((uint64_t)0x53380d139d95b3df),
                        @((uint64_t)0x650a73548baf63de), @((uint64_t)0x766a0abb3c77b2a8), @((uint64_t)0x81c2c92e47edaee6), @((uint64_t)0x92722c851482353b),
                        @((uint64_t)0xa2bfe8a14cf10364), @((uint64_t)0xa81a664bbc423001), @((uint64_t)0xc24b8b70d0f89791), @((uint64_t)0xc76c51a30654be30),
                        @((uint64_t)0xd192e819d6ef5218), @((uint64_t)0xd69906245565a910), @((uint64_t)0xf40e35855771202a), @((uint64_t)0x106aa07032bbd1b8),
                        @((uint64_t)0x19a4c116b8d2d0c8), @((uint64_t)0x1e376c085141ab53), @((uint64_t)0x2748774cdf8eeb99), @((uint64_t)0x34b0bcb5e19b48a8),
                        @((uint64_t)0x391c0cb3c5c95a63), @((uint64_t)0x4ed8aa4ae3418acb), @((uint64_t)0x5b9cca4f7763e373), @((uint64_t)0x682e6ff3d6b2b8a3),
                        @((uint64_t)0x748f82ee5defb2fc), @((uint64_t)0x78a5636f43172f60), @((uint64_t)0x84c87814a1f0ab72), @((uint64_t)0x8cc702081a6439ec),
                        @((uint64_t)0x90befffa23631e28), @((uint64_t)0xa4506cebde82bde9), @((uint64_t)0xbef9a3f7b2c67915), @((uint64_t)0xc67178f2e372532b),
                        @((uint64_t)0xca273eceea26619c), @((uint64_t)0xd186b8c721c0c207), @((uint64_t)0xeada7dd6cde0eb1e), @((uint64_t)0xf57d4f7fee6ed178),
                        @((uint64_t)0x06f067aa72176fba), @((uint64_t)0x0a637dc5a2c898a6), @((uint64_t)0x113f9804bef90dae), @((uint64_t)0x1b710b35131c471b),
                        @((uint64_t)0x28db77f523047d84), @((uint64_t)0x32caab7b40c72493), @((uint64_t)0x3c9ebe0a15c9bebc), @((uint64_t)0x431d67c49c100d4c),
                        @((uint64_t)0x4cc5d4becb3e42b6), @((uint64_t)0x597f299cfc657e2a), @((uint64_t)0x5fcb6fab3ad6faec), @((uint64_t)0x6c44198c4a475817)] mutableCopy];                
            }
        }
    }
    return _k;
}

/**
 * Constructor for variable length word
 */
- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            [self setMyByteLength:128];
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:8];
            [self setXBuf:tmpData];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithSize:80];
            [self setW:tmpArray];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
            if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
            [self reset];
        }
        return self;
    } else {
        return nil;
    }
}

/**
 * Copy constructor.  We are using copy constructors in place
 * of the object.Clone() interface as this interface is not
 * supported by J2ME.
 */
- (id)initWithLongDigest:(LongDigest*)t {
    if (self = [super init]) {
        @autoreleasepool {
            [self setMyByteLength:128];
            int length = (int)([t xBuf].length);
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:length];
            [self setXBuf:tmpData];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithSize:80];
            [self setW:tmpArray];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
            if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
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
    [self setW:nil];
    [super dealloc];
#endif
}

- (void)copyIn:(LongDigest*)t {
    [[self xBuf] copyFromIndex:0 withSource:[t xBuf] withSourceIndex:0 withLength:(int)([t xBuf].length)];
    
    [self setXBufOff:t.xBufOff];
    [self setByteCount1:t.byteCount1];
    [self setByteCount2:t.byteCount2];
    
    [self setH1:t.h1];
    [self setH2:t.h2];
    [self setH3:t.h3];
    [self setH4:t.h4];
    [self setH5:t.h5];
    [self setH6:t.h6];
    [self setH7:t.h7];
    [self setH8:t.h8];
    
    [[self w] copyFromIndex:0 withSource:[t w] withSourceIndex:0 withLength:(int)([t w].count)];
    [self setWOff:t.wOff];
}

- (void)update:(Byte)input {
    ((Byte*)([self xBuf].bytes))[self.xBufOff++] = input;
    
    if (self.xBufOff == (int)([self xBuf].length)) {
        [self processWord:[self xBuf] withInOff:0];
        self.xBufOff = 0;
    }
    
    self.byteCount1++;
}

- (void)blockUpdate:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    // fill the current word
    while ((self.xBufOff != 0) && (length > 0)) {
        [self update:((Byte*)(input.bytes))[inOff]];
        
        inOff++;
        length--;
    }
    
    // process whole words.
    while (length > (int)([self xBuf].length)) {
        [self processWord:input withInOff:inOff];
        
        inOff += (int)([self xBuf].length);
        length -= (int)([self xBuf].length);
        self.byteCount1 += (int)([self xBuf].length);
    }
    
    // load in the remainder.
    while (length > 0) {
        [self update:(((Byte*)(input.bytes))[inOff])];
        
        inOff++;
        length--;
    }
}

- (void)finish {
    [self adjustByteCounts];
    
    int64_t lowBitLength = self.byteCount1 << 3;
    int64_t hiBitLength = self.byteCount2;
    
    // add the pad bytes.
    [self update:(Byte)128];
    
    while (self.xBufOff != 0) {
        [self update:(Byte)0];
    }
    
    [self processLength:lowBitLength withHiw:hiBitLength];
    
    [self processBlock];
}

- (void)reset {
    self.byteCount1 = 0;
    self.byteCount2 = 0;
    
    self.xBufOff = 0;
    for (int i = 0; i < (int)([self xBuf].length); i++) {
        ((Byte*)([self xBuf].bytes))[i] = (Byte)0;
    }
    
    self.wOff = 0;
    [[self w] clearFromIndex:0 withLength:(int)([self w].count)];
}

- (void)processWord:(NSMutableData*)input withInOff:(int)inOff {
    [self w][self.wOff] = @([Pack BE_To_UInt64:input withOff:inOff]);
    
    if (++self.wOff == 16) {
        [self processBlock];
    }
}

/**
 * adjust the byte counts so that byteCount2 represents the
 * upper long (less 3 bits) word of the byte count.
 */
- (void)adjustByteCounts {
    if (self.byteCount1 > 0x1fffffffffffffffL) {
        self.byteCount2 += (int64_t)((uint64_t)(self.byteCount1) >> 61);
        self.byteCount1 &= 0x1fffffffffffffffL;
    }
}

- (void)processLength:(int64_t)lowW withHiw:(int64_t)hiW {
    if (self.wOff > 14) {
        [self processBlock];
    }
    
    @autoreleasepool {
        [self w][14] = @((uint64_t)hiW);
        [self w][15] = @((uint64_t)lowW);
    }
}

- (void)processBlock {
    @autoreleasepool {
        [self adjustByteCounts];
        
        // expand 16 word block into 80 word blocks.
        for (int ti = 16; ti <= 79; ++ti) {
            [self w][ti] = @([LongDigest sigma1:[([self w][ti - 2]) unsignedLongLongValue]] + [([self w][ti - 7]) unsignedLongLongValue] + [LongDigest sigma0:[([self w][ti - 15]) unsignedLongLongValue]] + [([self w][ti - 16]) unsignedLongLongValue]);
        }
        
        // set up working variables.
        uint64_t a = self.h1;
        uint64_t b = self.h2;
        uint64_t c = self.h3;
        uint64_t d = self.h4;
        uint64_t e = self.h5;
        uint64_t f = self.h6;
        uint64_t g = self.h7;
        uint64_t h = self.h8;
        
        int t = 0;
        for(int i = 0; i < 10; i ++) {
            // t = 8 * i
            h += [LongDigest sum1:e] + [LongDigest ch:e withY:f withZ:g] + [([LongDigest K][t]) unsignedLongLongValue] + [([self w][t++]) unsignedLongLongValue];
            d += h;
            h += [LongDigest sum0:a] + [LongDigest maj:a withY:b withZ:c];
            
            // t = 8 * i + 1
            g += [LongDigest sum1:d] + [LongDigest ch:d withY:e withZ:f] + [([LongDigest K][t]) unsignedLongLongValue] + [([self w][t++]) unsignedLongLongValue];
            c += g;
            g += [LongDigest sum0:h] + [LongDigest maj:h withY:a withZ:b];
            
            // t = 8 * i + 2
            f += [LongDigest sum1:c] + [LongDigest ch:c withY:d withZ:e] + [([LongDigest K][t]) unsignedLongLongValue] + [([self w][t++]) unsignedLongLongValue];
            b += f;
            f += [LongDigest sum0:g] + [LongDigest maj:g withY:h withZ:a];
            
            // t = 8 * i + 3
            e += [LongDigest sum1:b] + [LongDigest ch:b withY:c withZ:d] + [([LongDigest K][t]) unsignedLongLongValue] + [([self w][t++]) unsignedLongLongValue];
            a += e;
            e += [LongDigest sum0:f] + [LongDigest maj:f withY:g withZ:h];
            
            // t = 8 * i + 4
            d += [LongDigest sum1:a] + [LongDigest ch:a withY:b withZ:c] + [([LongDigest K][t]) unsignedLongLongValue] + [([self w][t++]) unsignedLongLongValue];
            h += d;
            d += [LongDigest sum0:e] + [LongDigest maj:e withY:f withZ:g];
            
            // t = 8 * i + 5
            c += [LongDigest sum1:h] + [LongDigest ch:h withY:a withZ:b] + [([LongDigest K][t]) unsignedLongLongValue] + [([self w][t++]) unsignedLongLongValue];
            g += c;
            c += [LongDigest sum0:d] + [LongDigest maj:d withY:e withZ:f];
            
            // t = 8 * i + 6
            b += [LongDigest sum1:g] + [LongDigest ch:g withY:h withZ:a] + [([LongDigest K][t]) unsignedLongLongValue] + [([self w][t++]) unsignedLongLongValue];
            f += b;
            b += [LongDigest sum0:c] + [LongDigest maj:c withY:d withZ:e];
            
            // t = 8 * i + 7
            a += [LongDigest sum1:f] + [LongDigest ch:f withY:g withZ:h] + [([LongDigest K][t]) unsignedLongLongValue] + [([self w][t++]) unsignedLongLongValue];
            e += a;
            a += [LongDigest sum0:b] + [LongDigest maj:b withY:c withZ:d];
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
        self.wOff = 0;
        [[self w] clearFromIndex:0 withLength:16];
        
    }
}

/* SHA-384 and SHA-512 functions (as for SHA-256 but for longs) */
+ (uint64_t)ch:(uint64_t)x withY:(uint64_t)y withZ:(uint64_t)z {
    return (x & y) ^ (~x & z);
}

+ (uint64_t)maj:(uint64_t)x withY:(uint64_t)y withZ:(uint64_t)z {
    return (x & y) ^ (x & z) ^ (y & z);
}

+ (uint64_t)sum0:(uint64_t)x {
    return ((x << 36) | (x >> 28)) ^ ((x << 30) | (x >> 34)) ^ ((x << 25) | (x >> 39));
}

+ (uint64_t)sum1:(uint64_t)x {
    return ((x << 50) | (x >> 14)) ^ ((x << 46) | (x >> 18)) ^ ((x << 23) | (x >> 41));
}

+ (uint64_t)sigma0:(uint64_t)x {
    return ((x << 63) | (x >> 1)) ^ ((x << 56) | (x >> 8)) ^ (x >> 7);
}

+ (uint64_t)sigma1:(uint64_t)x {
    return ((x << 45) | (x >> 19)) ^ ((x << 3) | (x >> 61)) ^ (x >> 6);
}

- (int)getByteLength {
    return [self myByteLength];
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

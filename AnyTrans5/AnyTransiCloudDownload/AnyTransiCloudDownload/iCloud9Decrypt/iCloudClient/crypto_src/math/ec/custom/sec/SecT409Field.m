//
//  SecT409Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT409Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat448.h"
#import "Nat.h"
#import "Interleave.h"

@implementation SecT409Field

static const uint64_t M25 = UINT64_MAX >> 39;
static const uint64_t M59 = UINT64_MAX >> 5;

// NSMutableArray == uint64_t[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ [y[0] unsignedLongLongValue]);
        z[1] = @([x[1] unsignedLongLongValue] ^ [y[1] unsignedLongLongValue]);
        z[2] = @([x[2] unsignedLongLongValue] ^ [y[2] unsignedLongLongValue]);
        z[3] = @([x[3] unsignedLongLongValue] ^ [y[3] unsignedLongLongValue]);
        z[4] = @([x[4] unsignedLongLongValue] ^ [y[4] unsignedLongLongValue]);
        z[5] = @([x[5] unsignedLongLongValue] ^ [y[5] unsignedLongLongValue]);
        z[6] = @([x[6] unsignedLongLongValue] ^ [y[6] unsignedLongLongValue]);
    }
}

// NSMutableArray == uint64_t[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        for (int i = 0; i < 13; ++i) {
            zz[i] = @([xx[i] unsignedLongLongValue] ^ [yy[i] unsignedLongLongValue]);
        }
    }
}

// NSMutableArray == uint64_t[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ 1UL);
        z[1] = x[1];
        z[2] = x[2];
        z[3] = x[3];
        z[4] = x[4];
        z[5] = x[5];
        z[6] = x[6];
    }
}

// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat448 fromBigInteger64:x];
    [SecT409Field reduce39:z withZoff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat448 isZero64:x]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
    }
    
    @autoreleasepool {
        // Itoh-Tsujii inversion with bases { 2, 3 }
        
        NSMutableArray *t0 = [Nat448 create64];
        NSMutableArray *t1 = [Nat448 create64];
        NSMutableArray *t2 = [Nat448 create64];
        
        [SecT409Field square:x withZ:t0];
        
        // 3 | 408
        [SecT409Field squareN:t0 withN:1 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t0];
        [SecT409Field squareN:t1 withN:1 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 136
        [SecT409Field squareN:t0 withN:3 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 68
        [SecT409Field squareN:t0 withN:6 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 34
        [SecT409Field squareN:t0 withN:12 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t2];
        
        // ! {2,3} | 17
        [SecT409Field squareN:t2 withN:24 withZ:t0];
        [SecT409Field squareN:t0 withN:24 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 8
        [SecT409Field squareN:t0 withN:48 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 4
        [SecT409Field squareN:t0 withN:96 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 2
        [SecT409Field squareN:t0 withN:192 withZ:t1];
        [SecT409Field multiply:t0 withY:t1 withZ:t0];
        
        [SecT409Field multiply:t0 withY:t2 withZ:z];
        
#if !__has_feature(objc_arc)
        if (t0) [t0 release]; t0 = nil;
        if (t1) [t1 release]; t1 = nil;
        if (t2) [t2 release]; t2 = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat448 createExt64];
        [SecT409Field implMultiply:x withY:y withZZ:tt];
        [SecT409Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat448 createExt64];
        [SecT409Field implMultiply:x withY:y withZZ:tt];
        [SecT409Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x00 = [xx[0] unsignedLongLongValue], x01 = [xx[1] unsignedLongLongValue], x02 = [xx[2] unsignedLongLongValue], x03 = [xx[3] unsignedLongLongValue];
        uint64_t x04 = [xx[4] unsignedLongLongValue], x05 = [xx[5] unsignedLongLongValue], x06 = [xx[6] unsignedLongLongValue], x07 = [xx[7] unsignedLongLongValue];
        
        uint64_t u = [xx[12] unsignedLongLongValue];
        x05 ^= (u << 39);
        x06 ^= (u >> 25) ^ (u << 62);
        x07 ^= (u >>  2);
        
        u = [xx[11] unsignedLongLongValue];
        x04 ^= (u << 39);
        x05 ^= (u >> 25) ^ (u << 62);
        x06 ^= (u >>  2);
        
        u = [xx[10] unsignedLongLongValue];
        x03 ^= (u << 39);
        x04 ^= (u >> 25) ^ (u << 62);
        x05 ^= (u >>  2);
        
        u = [xx[9] unsignedLongLongValue];
        x02 ^= (u << 39);
        x03 ^= (u >> 25) ^ (u << 62);
        x04 ^= (u >>  2);
        
        u = [xx[8] unsignedLongLongValue];
        x01 ^= (u << 39);
        x02 ^= (u >> 25) ^ (u << 62);
        x03 ^= (u >>  2);
        
        u = x07;
        x00 ^= (u << 39);
        x01 ^= (u >> 25) ^ (u << 62);
        x02 ^= (u >>  2);
        
        uint64_t t = x06 >> 25;
        z[0] = @(x00 ^ t);
        z[1] = @(x01 ^ (t << 23));
        z[2] = @(x02);
        z[3] = @(x03);
        z[4] = @(x04);
        z[5] = @(x05);
        z[6] = @(x06 & M25);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce39:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z6 = [z[zOff + 6] unsignedLongLongValue], t = z6 >> 25;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ t);
        z[zOff + 1] = @([z[zOff + 1] unsignedLongLongValue] ^ (t << 23));
        z[zOff + 6] = @(z6 & M25);
    }
}

// NSMutableArray == uint64_t[]
+ (void)sqrt:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t u0, u1;
        u0 = [Interleave unshuffle:[x[0] unsignedLongLongValue]]; u1 = [Interleave unshuffle:[x[1] unsignedLongLongValue]];
        uint64_t e0 = (u0 & 0x00000000FFFFFFFFUL) | (u1 << 32);
        uint64_t c0 = (u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL);
        
        u0 = [Interleave unshuffle:[x[2] unsignedLongLongValue]]; u1 = [Interleave unshuffle:[x[3] unsignedLongLongValue]];
        uint64_t e1 = (u0 & 0x00000000FFFFFFFFUL) | (u1 << 32);
        uint64_t c1 = (u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL);
        
        u0 = [Interleave unshuffle:[x[4] unsignedLongLongValue]]; u1 = [Interleave unshuffle:[x[5] unsignedLongLongValue]];
        uint64_t e2 = (u0 & 0x00000000FFFFFFFFUL) | (u1 << 32);
        uint64_t c2 = (u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL);
        
        u0 = [Interleave unshuffle:[x[6] unsignedLongLongValue]];
        uint64_t e3 = (u0 & 0x00000000FFFFFFFFUL);
        uint64_t c3 = (u0 >> 32);
        
        z[0] = @(e0 ^ (c0 << 44));
        z[1] = @(e1 ^ (c1 << 44) ^ (c0 >> 20));
        z[2] = @(e2 ^ (c2 << 44) ^ (c1 >> 20));
        z[3] = @(e3 ^ (c3 << 44) ^ (c2 >> 20) ^ (c0 << 13));
        z[4] = @((c3 >> 20) ^ (c1 << 13) ^ (c0 >> 51));
        z[5] = @((c2 << 13) ^ (c1 >> 51));
        z[6] = @((c3 << 13) ^ (c2 >> 51));
    }
}

// NSMutableArray == uint64_t[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:13];
        [SecT409Field implSquare:x withZZ:tt];
        [SecT409Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:13];
        [SecT409Field implSquare:x withZZ:tt];
        [SecT409Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:13];
        [SecT409Field implSquare:x withZZ:tt];
        [SecT409Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT409Field implSquare:z withZZ:tt];
            [SecT409Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (uint)trace:(NSMutableArray*)x {
    // Non-zero-trace bits: 0
    return (uint)([x[0] unsignedLongLongValue]) & 1U;
}

// NSMutableArray == uint64_t[]
+ (void)implCompactExt:(NSMutableArray*)zz {
    @autoreleasepool {
        uint64_t z00 = [zz[0] unsignedLongLongValue], z01 = [zz[1] unsignedLongLongValue], z02 = [zz[2] unsignedLongLongValue], z03 = [zz[3] unsignedLongLongValue], z04 = [zz[4] unsignedLongLongValue], z05 = [zz[5] unsignedLongLongValue], z06 = [zz[6] unsignedLongLongValue];
        uint64_t z07 = [zz[7] unsignedLongLongValue], z08 = [zz[8] unsignedLongLongValue], z09 = [zz[9] unsignedLongLongValue], z10 = [zz[10] unsignedLongLongValue], z11 = [zz[11] unsignedLongLongValue], z12 = [zz[12] unsignedLongLongValue], z13 = [zz[13] unsignedLongLongValue];
        zz[0] = @(z00 ^ (z01 << 59));
        zz[1] = @((z01 >>  5) ^ (z02 << 54));
        zz[2] = @((z02 >> 10) ^ (z03 << 49));
        zz[3] = @((z03 >> 15) ^ (z04 << 44));
        zz[4] = @((z04 >> 20) ^ (z05 << 39));
        zz[5] = @((z05 >> 25) ^ (z06 << 34));
        zz[6] = @((z06 >> 30) ^ (z07 << 29));
        zz[7] = @((z07 >> 35) ^ (z08 << 24));
        zz[8] = @((z08 >> 40) ^ (z09 << 19));
        zz[9] = @((z09 >> 45) ^ (z10 << 14));
        zz[10] = @((z10 >> 50) ^ (z11 <<  9));
        zz[11] = @((z11 >> 55) ^ (z12 <<  4) ^ (z13 << 63));
        zz[12] = @((z12 >> 60) ^ (z13 >> 1));
        zz[13] = @(0);
    }
}

// NSMutableArray == uint64_t[]
+ (void)implExpand:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [x[0] unsignedLongLongValue], x1 = [x[1] unsignedLongLongValue], x2 = [x[2] unsignedLongLongValue], x3 = [x[3] unsignedLongLongValue], x4 = [x[4] unsignedLongLongValue], x5 = [x[5] unsignedLongLongValue], x6 = [x[6] unsignedLongLongValue];
        z[0] = @(x0 & M59);
        z[1] = @(((x0 >> 59) ^ (x1 <<  5)) & M59);
        z[2] = @(((x1 >> 54) ^ (x2 << 10)) & M59);
        z[3] = @(((x2 >> 49) ^ (x3 << 15)) & M59);
        z[4] = @(((x3 >> 44) ^ (x4 << 20)) & M59);
        z[5] = @(((x4 >> 39) ^ (x5 << 25)) & M59);
        z[6] = @(((x5 >> 34) ^ (x6 << 30)));
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *a = [[NSMutableArray alloc] initWithSize:7], *b = [[NSMutableArray alloc] initWithSize:7];
        [SecT409Field implExpand:x withZ:a];
        [SecT409Field implExpand:y withZ:b];
        
        for (int i = 0; i < 7; ++i) {
            [SecT409Field implMulwAcc:a withY:[b[i] unsignedLongLongValue] withZ:zz withZoff:i];
        }
        
#if !__has_feature(objc_arc)
        if (a != nil) [a release]; a = nil;
        if (b != nil) [b release]; b = nil;
#endif
        [SecT409Field implCompactExt:zz];
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMulwAcc:(NSMutableArray*)xs withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        NSMutableArray *u = [[NSMutableArray alloc] initWithSize:8];
        //u[0] = 0;
        u[1] = @(y);
        u[2] = @([u[1] unsignedLongLongValue] << 1);
        u[3] = @([u[2] unsignedLongLongValue] ^  y);
        u[4] = @([u[2] unsignedLongLongValue] << 1);
        u[5] = @([u[4] unsignedLongLongValue] ^  y);
        u[6] = @([u[3] unsignedLongLongValue] << 1);
        u[7] = @([u[6] unsignedLongLongValue] ^  y);
        
        for (int i = 0; i < 7; ++i) {
            uint64_t x = [xs[i] unsignedLongLongValue];
            
            uint j = (uint)x;
            uint64_t g, h = 0, l = [u[j & 7] unsignedLongLongValue] ^ ([u[(j >> 3) & 7] unsignedLongLongValue] << 3);
            int k = 54;
            do {
                j  = (uint)(x >> k);
                g  = [u[j & 7] unsignedLongLongValue] ^ [u[(j >> 3) & 7] unsignedLongLongValue] << 3;
                l ^= (g <<  k);
                h ^= (g >> -k);
            } while ((k -= 6) > 0);
            
            z[zOff + i] = @([z[zOff + i] unsignedLongLongValue] ^ (l & M59));
            z[zOff + i + 1] = @([z[zOff + i + 1] unsignedLongLongValue] ^ ((l >> 59) ^ (h << 5)));
        }
#if !__has_feature(objc_arc)
        if (u != nil) [u release]; u = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        for (int i = 0; i < 6; ++i) {
            [Interleave expand64To128:[x[i] unsignedLongLongValue] withZ:zz withZ0ff:(i << 1)];
        }
        zz[12] = @([Interleave expand32to64:(uint)[x[6] unsignedLongLongValue]]);
    }
}

@end

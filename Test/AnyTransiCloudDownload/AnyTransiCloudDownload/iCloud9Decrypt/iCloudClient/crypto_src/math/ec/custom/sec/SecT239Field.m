//
//  SecT239Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT239Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat256.h"
#import "Interleave.h"

@implementation SecT239Field

static const uint64_t M47 = UINT64_MAX >> 17;
static const uint64_t M60 = UINT64_MAX >> 4;

// NSMutableArray == uint64_t[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ [y[0] unsignedLongLongValue]);
        z[1] = @([x[1] unsignedLongLongValue] ^ [y[1] unsignedLongLongValue]);
        z[2] = @([x[2] unsignedLongLongValue] ^ [y[2] unsignedLongLongValue]);
        z[3] = @([x[3] unsignedLongLongValue] ^ [y[3] unsignedLongLongValue]);
    }
}

// NSMutableArray == uint64_t[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        zz[0] = @([xx[0] unsignedLongLongValue] ^ [yy[0] unsignedLongLongValue]);
        zz[1] = @([xx[1] unsignedLongLongValue] ^ [yy[1] unsignedLongLongValue]);
        zz[2] = @([xx[2] unsignedLongLongValue] ^ [yy[2] unsignedLongLongValue]);
        zz[3] = @([xx[3] unsignedLongLongValue] ^ [yy[3] unsignedLongLongValue]);
        zz[4] = @([xx[4] unsignedLongLongValue] ^ [yy[4] unsignedLongLongValue]);
        zz[5] = @([xx[5] unsignedLongLongValue] ^ [yy[5] unsignedLongLongValue]);
        zz[6] = @([xx[6] unsignedLongLongValue] ^ [yy[6] unsignedLongLongValue]);
        zz[7] = @([xx[7] unsignedLongLongValue] ^ [yy[7] unsignedLongLongValue]);
    }
}

// NSMutableArray == uint64_t[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ 1UL);
        z[1] = x[1];
        z[2] = x[2];
        z[3] = x[3];        
    }
}

// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat256 fromBigInteger64:x];
    [SecT239Field reduce17:z withZoff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat256 isZero64:x]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
    }
    
    @autoreleasepool {
        // Itoh-Tsujii inversion
        
        NSMutableArray *t0 = [Nat256 create64];
        NSMutableArray *t1 = [Nat256 create64];
        
        [SecT239Field square:x withZ:t0];
        [SecT239Field multiply:t0 withY:x withZ:t0];
        [SecT239Field square:t0 withZ:t0];
        [SecT239Field multiply:t0 withY:x withZ:t0];
        [SecT239Field squareN:t0 withN:3 withZ:t1];
        [SecT239Field multiply:t1 withY:t0 withZ:t1];
        [SecT239Field square:t1 withZ:t1];
        [SecT239Field multiply:t1 withY:x withZ:t1];
        [SecT239Field squareN:t1 withN:7 withZ:t0];
        [SecT239Field multiply:t0 withY:t1 withZ:t0];
        [SecT239Field squareN:t0 withN:14 withZ:t1];
        [SecT239Field multiply:t1 withY:t0 withZ:t1];
        [SecT239Field square:t1 withZ:t1];
        [SecT239Field multiply:t1 withY:x withZ:t1];
        [SecT239Field squareN:t1 withN:29 withZ:t0];
        [SecT239Field multiply:t0 withY:t1 withZ:t0];
        [SecT239Field square:t0 withZ:t0];
        [SecT239Field multiply:t0 withY:x withZ:t0];
        [SecT239Field squareN:t0 withN:59 withZ:t1];
        [SecT239Field multiply:t1 withY:t0 withZ:t1];
        [SecT239Field square:t1 withZ:t1];
        [SecT239Field multiply:t1 withY:x withZ:t1];
        [SecT239Field squareN:t1 withN:119 withZ:t0];
        [SecT239Field multiply:t0 withY:t1 withZ:t0];
        [SecT239Field square:t0 withZ:z];
#if !__has_feature(objc_arc)
        if (t0) [t0 release]; t0 = nil;
        if (t1) [t1 release]; t1 = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT239Field implMultiply:x withY:y withZZ:tt];
        [SecT239Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT239Field implMultiply:x withY:y withZZ:tt];
        [SecT239Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [xx[0] unsignedLongLongValue], x1 = [xx[1] unsignedLongLongValue], x2 = [xx[2] unsignedLongLongValue], x3 = [xx[3] unsignedLongLongValue];
        uint64_t x4 = [xx[4] unsignedLongLongValue], x5 = [xx[5] unsignedLongLongValue], x6 = [xx[6] unsignedLongLongValue], x7 = [xx[7] unsignedLongLongValue];
        
        x3 ^= (x7 << 17);
        x4 ^= (x7 >> 47);
        x5 ^= (x7 << 47);
        x6 ^= (x7 >> 17);
        
        x2 ^= (x6 << 17);
        x3 ^= (x6 >> 47);
        x4 ^= (x6 << 47);
        x5 ^= (x6 >> 17);
        
        x1 ^= (x5 << 17);
        x2 ^= (x5 >> 47);
        x3 ^= (x5 << 47);
        x4 ^= (x5 >> 17);
        
        x0 ^= (x4 << 17);
        x1 ^= (x4 >> 47);
        x2 ^= (x4 << 47);
        x3 ^= (x4 >> 17);
        
        uint64_t t = x3 >> 47;
        z[0] = @(x0 ^ t);
        z[1] = @(x1);
        z[2] = @(x2 ^ (t << 30));
        z[3] = @(x3 & M47);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce17:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z3 = [z[zOff + 3] unsignedLongLongValue], t = z3 >> 47;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ t);
        z[zOff + 2] = @([z[zOff + 2] unsignedLongLongValue] ^ (t << 30));
        z[zOff + 3] = @(z3 & M47);
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
        
        uint64_t c2, c3;
        c3 = (c1 >> 49);
        c2 = (c0 >> 49) | (c1 << 15);
        c1 ^= (c0 << 15);
        
        NSMutableArray *tt = [Nat256 createExt64];
        
        NSMutableArray *shifts = [[NSMutableArray alloc] initWithObjects:@((int)39), @((int)120), nil];
        for (int i = 0; i < shifts.count; ++i) {
            int w = [shifts[i] intValue] >> 6, s = [shifts[i] intValue] & 63;
            tt[w] = @(([tt[w] unsignedLongLongValue] ^ (c0 << s)));
            tt[w + 1] = @([tt[w + 1] unsignedLongLongValue] ^ ((c1 << s) | (c0 >> -s)));
            tt[w + 2] = @([tt[w + 2] unsignedLongLongValue] ^ ((c2 << s) | (c1 >> -s)));
            tt[w + 3] = @([tt[w + 3] unsignedLongLongValue] ^ ((c3 << s) | (c2 >> -s)));
            tt[w + 4] = @([tt[w + 4] unsignedLongLongValue] ^ (c3 >> -s));
        }
#if !__has_feature(objc_arc)
        if (shifts != nil) [shifts release]; shifts = nil;
#endif
        
        [SecT239Field reduce:tt withZ:z];
        
        z[0] = @([z[0] unsignedLongLongValue] ^ e0);
        z[1] = @([z[1] unsignedLongLongValue] ^ e1);
        
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT239Field implSquare:x withZZ:tt];
        [SecT239Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT239Field implSquare:x withZZ:tt];
        [SecT239Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT239Field implSquare:x withZZ:tt];
        [SecT239Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT239Field implSquare:z withZZ:tt];
            [SecT239Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (uint)trace:(NSMutableArray*)x {
    // Non-zero-trace bits: 0, 81, 162
    return (uint)([x[0] unsignedLongLongValue] ^ ([x[1] unsignedLongLongValue] >> 17) ^ ([x[2] unsignedLongLongValue] >> 34)) & 1U;
}

// NSMutableArray == uint64_t[]
+ (void)implCompactExt:(NSMutableArray*)zz {
    @autoreleasepool {
        uint64_t z0 = [zz[0] unsignedLongLongValue], z1 = [zz[1] unsignedLongLongValue], z2 = [zz[2] unsignedLongLongValue], z3 = [zz[3] unsignedLongLongValue], z4 = [zz[4] unsignedLongLongValue], z5 = [zz[5] unsignedLongLongValue], z6 = [zz[6] unsignedLongLongValue], z7 = [zz[7] unsignedLongLongValue];
        zz[0] = @(z0 ^ (z1 << 60));
        zz[1] = @((z1 >>  4) ^ (z2 << 56));
        zz[2] = @((z2 >>  8) ^ (z3 << 52));
        zz[3] = @((z3 >> 12) ^ (z4 << 48));
        zz[4] = @((z4 >> 16) ^ (z5 << 44));
        zz[5] = @((z5 >> 20) ^ (z6 << 40));
        zz[6] = @((z6 >> 24) ^ (z7 << 36));
        zz[7] = @(z7 >> 28);
    }
}

// NSMutableArray == uint64_t[]
+ (void)implExpand:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [x[0] unsignedLongLongValue], x1 = [x[1] unsignedLongLongValue], x2 = [x[2] unsignedLongLongValue], x3 = [x[3] unsignedLongLongValue];
        z[0] = @(x0 & M60);
        z[1] = @(((x0 >> 60) ^ (x1 <<  4)) & M60);
        z[2] = @(((x1 >> 56) ^ (x2 <<  8)) & M60);
        z[3] = @(((x2 >> 52) ^ (x3 << 12)));
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        /*
         * "Two-level seven-way recursion" as described in "Batch binary Edwards", Daniel J. Bernstein.
         */
        
        NSMutableArray *f = [[NSMutableArray alloc] initWithSize:4], *g = [[NSMutableArray alloc] initWithSize:4];
        [SecT239Field implExpand:x withZ:f];
        [SecT239Field implExpand:y withZ:g];
        
        [SecT239Field implMulwAcc:[f[0] unsignedLongLongValue] withY:[g[0] unsignedLongLongValue] withZ:zz withZoff:0];
        [SecT239Field implMulwAcc:[f[1] unsignedLongLongValue] withY:[g[1] unsignedLongLongValue] withZ:zz withZoff:1];
        [SecT239Field implMulwAcc:[f[2] unsignedLongLongValue] withY:[g[2] unsignedLongLongValue] withZ:zz withZoff:2];
        [SecT239Field implMulwAcc:[f[3] unsignedLongLongValue] withY:[g[3] unsignedLongLongValue] withZ:zz withZoff:3];
        
        // U *= (1 - t^n)
        for (int i = 5; i > 0; --i) {
            zz[i] = @([zz[i] unsignedLongLongValue] ^ [zz[i - 1] unsignedLongLongValue]);
        }
        
        [SecT239Field implMulwAcc:([f[0] unsignedLongLongValue] ^ [f[1] unsignedLongLongValue]) withY:([g[0] unsignedLongLongValue] ^ [g[1] unsignedLongLongValue]) withZ:zz withZoff:1];
        [SecT239Field implMulwAcc:([f[2] unsignedLongLongValue] ^ [f[3] unsignedLongLongValue]) withY:([g[2] unsignedLongLongValue] ^ [g[3] unsignedLongLongValue]) withZ:zz withZoff:3];
        
        // V *= (1 - t^2n)
        for (int i = 7; i > 1; --i) {
            zz[i] = @([zz[i] unsignedLongLongValue] ^ [zz[i - 2] unsignedLongLongValue]);
        }
        
        // Double-length recursion
        {
            uint64_t c0 = [f[0] unsignedLongLongValue] ^ [f[2] unsignedLongLongValue], c1 = [f[1] unsignedLongLongValue] ^ [f[3] unsignedLongLongValue];
            uint64_t d0 = [g[0] unsignedLongLongValue] ^ [g[2] unsignedLongLongValue], d1 = [g[1] unsignedLongLongValue] ^ [g[3] unsignedLongLongValue];
            [SecT239Field implMulwAcc:(c0 ^ c1) withY:(d0 ^ d1) withZ:zz withZoff:3];
            NSMutableArray *t = [[NSMutableArray alloc] initWithSize:3];
            [SecT239Field implMulwAcc:c0 withY:d0 withZ:t withZoff:0];
            [SecT239Field implMulwAcc:c1 withY:d1 withZ:t withZoff:1];
            uint64_t t0 = [t[0] unsignedLongLongValue], t1 = [t[1] unsignedLongLongValue], t2 = [t[2] unsignedLongLongValue];
            zz[2] = @([zz[2] unsignedLongLongValue] ^ t0);
            zz[3] = @([zz[3] unsignedLongLongValue] ^ (t0 ^ t1));
            zz[4] = @([zz[4] unsignedLongLongValue] ^ (t2 ^ t1));
            zz[5] = @([zz[5] unsignedLongLongValue] ^ t2);
#if !__has_feature(objc_arc)
            if (t != nil) [t release]; t = nil;
#endif
        }
        
#if !__has_feature(objc_arc)
        if (f != nil) [f release]; f = nil;
        if (g != nil) [g release]; g = nil;
#endif
        [SecT239Field implCompactExt:zz];
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMulwAcc:(uint64_t)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        NSMutableArray *u = [[NSMutableArray alloc] initWithSize:8];
        //u[0] = 0;
        u[1] = @(y);
        u[2] = @([u[1] unsignedLongLongValue] << 1);
        u[3] = @([u[2] unsignedLongLongValue] ^  y);
        u[4] = @([u[2] unsignedLongLongValue] << 1);
        u[5] = @([u[4] unsignedLongLongValue] ^  y);
        u[6] = @([u[3] unsignedLongLongValue] << 1);
        u[7] = @([u[6] unsignedLongLongValue] ^ y);
        
        uint j = (uint)x;
        uint64_t g, h = 0, l = [u[j & 7] unsignedLongLongValue] ^ ([u[(j >> 3) & 7] unsignedLongLongValue] << 3);
        int k = 54;
        do {
            j  = (uint)(x >> k);
            g  = [u[j & 7] unsignedLongLongValue] ^ [u[(j >> 3) & 7] unsignedLongLongValue] << 3;
            l ^= (g <<  k);
            h ^= (g >> -k);
        } while ((k -= 6) > 0);
        
        h ^= ((x & 0x0820820820820820L) & (uint64_t)(((int64_t)y << 4) >> 63)) >> 5;
        
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (l & M60));
        z[zOff + 1] = @([z[zOff + 1] unsignedLongLongValue] ^ ((l >> 60) ^ (h << 4)));
#if !__has_feature(objc_arc)
        if (u != nil) [u release]; u = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Interleave expand64To128:[x[0] unsignedLongLongValue] withZ:zz withZ0ff:0];
        [Interleave expand64To128:[x[1] unsignedLongLongValue] withZ:zz withZ0ff:2];
        [Interleave expand64To128:[x[2] unsignedLongLongValue] withZ:zz withZ0ff:4];
        
        uint64_t x3 = [x[3] unsignedLongLongValue];
        zz[6] = @([Interleave expand32to64:(uint)x3]);
        zz[7] = @((uint64_t)[Interleave expand16to32:(uint)(x3 >> 32)]);        
    }
}

@end

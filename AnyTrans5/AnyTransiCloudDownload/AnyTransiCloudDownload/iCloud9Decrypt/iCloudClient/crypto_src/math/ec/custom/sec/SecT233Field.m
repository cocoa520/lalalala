//
//  SecT233Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT233Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat256.h"
#import "Interleave.h"

@implementation SecT233Field

static const uint64_t M41 = UINT64_MAX >> 23;
static const uint64_t M59 = UINT64_MAX >> 5;

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
    [SecT233Field reduce23:z withZoff:0];
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
        
        [SecT233Field square:x withZ:t0];
        [SecT233Field multiply:t0 withY:x withZ:t0];
        [SecT233Field square:t0 withZ:t0];
        [SecT233Field multiply:t0 withY:x withZ:t0];
        [SecT233Field squareN:t0 withN:3 withZ:t1];
        [SecT233Field multiply:t1 withY:t0 withZ:t1];
        [SecT233Field square:t1 withZ:t1];
        [SecT233Field multiply:t1 withY:x withZ:t1];
        [SecT233Field squareN:t1 withN:7 withZ:t0];
        [SecT233Field multiply:t0 withY:t1 withZ:t0];
        [SecT233Field squareN:t0 withN:14 withZ:t1];
        [SecT233Field multiply:t1 withY:t0 withZ:t1];
        [SecT233Field square:t1 withZ:t1];
        [SecT233Field multiply:t1 withY:x withZ:t1];
        [SecT233Field squareN:t1 withN:29 withZ:t0];
        [SecT233Field multiply:t0 withY:t1 withZ:t0];
        [SecT233Field squareN:t0 withN:58 withZ:t1];
        [SecT233Field multiply:t1 withY:t0 withZ:t1];
        [SecT233Field squareN:t1 withN:116 withZ:t0];
        [SecT233Field multiply:t0 withY:t1 withZ:t0];
        [SecT233Field square:t0 withZ:z];
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
        [SecT233Field implMultiply:x withY:y withZZ:tt];
        [SecT233Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT233Field implMultiply:x withY:y withZZ:tt];
        [SecT233Field addExt:zz withYY:tt withZZ:zz];
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
        
        x3 ^= (x7 << 23);
        x4 ^= (x7 >> 41) ^ (x7 << 33);
        x5 ^= (x7 >> 31);
        
        x2 ^= (x6 << 23);
        x3 ^= (x6 >> 41) ^ (x6 << 33);
        x4 ^= (x6 >> 31);
        
        x1 ^= (x5 << 23);
        x2 ^= (x5 >> 41) ^ (x5 << 33);
        x3 ^= (x5 >> 31);
        
        x0 ^= (x4 << 23);
        x1 ^= (x4 >> 41) ^ (x4 << 33);
        x2 ^= (x4 >> 31);
        
        uint64_t t = x3 >> 41;
        z[0] = @(x0 ^ t);
        z[1] = @(x1 ^ (t << 10));
        z[2] = @(x2);
        z[3] = @(x3 & M41);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce23:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z3 = [z[zOff + 3] unsignedLongLongValue], t = z3 >> 41;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ t);
        z[zOff + 1] = @([z[zOff + 1] unsignedLongLongValue] ^ (t << 10));
        z[zOff + 3]  = @(z3 & M41);
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
        
        uint64_t c2;
        c2 = (c1 >> 27);
        c1 ^= (c0 >> 27) | (c1 << 37);
        c0 ^= (c0 << 37);
        
        NSMutableArray *tt = [Nat256 createExt64];
        
        NSMutableArray *shifts = [[NSMutableArray alloc] initWithObjects:@((int)32), @((int)117), @((int)191), nil];
        for (int i = 0; i < shifts.count; ++i) {
            int w = [shifts[i] intValue] >> 6, s = [shifts[i] intValue] & 63;
            tt[w] = @([tt[w] unsignedLongLongValue] ^ (c0 << s));
            tt[w + 1] = @([tt[w + 1] unsignedLongLongValue] ^ ((c1 << s) | (c0 >> -s)));
            tt[w + 2] = @([tt[w + 2] unsignedLongLongValue] ^ ((c2 << s) | (c1 >> -s)));
            tt[w + 3] = @([tt[w + 3] unsignedLongLongValue] ^ (c2 >> -s));
        }
#if !__has_feature(objc_arc)
        if (shifts != nil) [shifts release]; shifts = nil;
#endif
        
        [SecT233Field reduce:tt withZ:z];
        
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
        [SecT233Field implSquare:x withZZ:tt];
        [SecT233Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT233Field implSquare:x withZZ:tt];
        [SecT233Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT233Field implSquare:x withZZ:tt];
        [SecT233Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT233Field implSquare:z withZZ:tt];
            [SecT233Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (uint)trace:(NSMutableArray*)x {
    // Non-zero-trace bits: 0, 159
    return (uint)([x[0] unsignedLongLongValue] ^ ([x[2] unsignedLongLongValue] >> 31)) & 1U;
}

// NSMutableArray == uint64_t[]
+ (void)implCompactExt:(NSMutableArray*)zz {
    @autoreleasepool {
        uint64_t z0 = [zz[0] unsignedLongLongValue], z1 = [zz[1] unsignedLongLongValue], z2 = [zz[2] unsignedLongLongValue], z3 = [zz[3] unsignedLongLongValue], z4 = [zz[4] unsignedLongLongValue], z5 = [zz[5] unsignedLongLongValue], z6 = [zz[6] unsignedLongLongValue], z7 = [zz[7] unsignedLongLongValue];
        zz[0] = @(z0 ^ (z1 << 59));
        zz[1] = @((z1 >>  5) ^ (z2 << 54));
        zz[2] = @((z2 >> 10) ^ (z3 << 49));
        zz[3] = @((z3 >> 15) ^ (z4 << 44));
        zz[4] = @((z4 >> 20) ^ (z5 << 39));
        zz[5] = @((z5 >> 25) ^ (z6 << 34));
        zz[6] = @((z6 >> 30) ^ (z7 << 29));
        zz[7] = @(z7 >> 35);
    }
}

// NSMutableArray == uint64_t[]
+ (void)implExpand:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [x[0] unsignedLongLongValue], x1 = [x[1] unsignedLongLongValue], x2 = [x[2] unsignedLongLongValue], x3 = [x[3] unsignedLongLongValue];
        z[0] = @(x0 & M59);
        z[1] = @(((x0 >> 59) ^ (x1 <<  5)) & M59);
        z[2] = @(((x1 >> 54) ^ (x2 << 10)) & M59);
        z[3] = @(((x2 >> 49) ^ (x3 << 15)));
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        /*
         * "Two-level seven-way recursion" as described in "Batch binary Edwards", Daniel J. Bernstein.
         */
        NSMutableArray *f = [[NSMutableArray alloc] initWithSize:4], *g = [[NSMutableArray alloc] initWithSize:4];
        [SecT233Field implExpand:x withZ:f];
        [SecT233Field implExpand:y withZ:g];
        
        [SecT233Field implMulwAcc:[f[0] unsignedLongLongValue] withY:[g[0] unsignedLongLongValue] withZ:zz withZoff:0];
        [SecT233Field implMulwAcc:[f[1] unsignedLongLongValue] withY:[g[1] unsignedLongLongValue] withZ:zz withZoff:1];
        [SecT233Field implMulwAcc:[f[2] unsignedLongLongValue] withY:[g[2] unsignedLongLongValue] withZ:zz withZoff:2];
        [SecT233Field implMulwAcc:[f[3] unsignedLongLongValue] withY:[g[3] unsignedLongLongValue] withZ:zz withZoff:3];
        
        // U *= (1 - t^n)
        for (int i = 5; i > 0; --i) {
            zz[i] = @([zz[i] unsignedLongLongValue] ^ [zz[i - 1] unsignedLongLongValue]);
        }
        
        [SecT233Field implMulwAcc:([f[0] unsignedLongLongValue] ^ [f[1] unsignedLongLongValue]) withY:([g[0] unsignedLongLongValue] ^ [g[1] unsignedLongLongValue]) withZ:zz withZoff:1];
        [SecT233Field implMulwAcc:([f[2] unsignedLongLongValue] ^ [f[3] unsignedLongLongValue]) withY:([g[2] unsignedLongLongValue] ^ [g[3] unsignedLongLongValue]) withZ:zz withZoff:3];
        
        // V *= (1 - t^2n)
        for (int i = 7; i > 1; --i) {
            zz[i] = @([zz[i] unsignedLongLongValue] ^ [zz[i - 2] unsignedLongLongValue]);
        }
        
        // Double-length recursion
        {
            uint64_t c0 = [f[0] unsignedLongLongValue] ^ [f[2] unsignedLongLongValue], c1 = [f[1] unsignedLongLongValue] ^ [f[3] unsignedLongLongValue];
            uint64_t d0 = [g[0] unsignedLongLongValue] ^ [g[2] unsignedLongLongValue], d1 = [g[1] unsignedLongLongValue] ^ [g[3] unsignedLongLongValue];
            [SecT233Field implMulwAcc:(c0 ^ c1) withY:(d0 ^ d1) withZ:zz withZoff:3];
            NSMutableArray *t = [[NSMutableArray alloc] initWithSize:3];
            [SecT233Field implMulwAcc:c0 withY:d0 withZ:t withZoff:0];
            [SecT233Field implMulwAcc:c1 withY:d1 withZ:t withZoff:1];
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
        [SecT233Field implCompactExt:zz];
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
        
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (l & M59));
        z[zOff + 1] = @([z[zOff + 1] unsignedLongLongValue] ^ ((l >> 59) ^ (h << 5)));
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

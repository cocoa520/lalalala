//
//  SecT193Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT193Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat256.h"
#import "Interleave.h"

@implementation SecT193Field

static const uint64_t M01 = 1UL;
static const uint64_t M49 = UINT64_MAX >> 15;

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
    [SecT193Field reduce63:z withZoff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat256 isZero64:x]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
    }
    
    @autoreleasepool {
        // Itoh-Tsujii inversion with bases { 2, 3 }
        
        NSMutableArray *t0 = [Nat256 create64];
        NSMutableArray *t1 = [Nat256 create64];
        
        [SecT193Field square:x withZ:t0];
        
        // 3 | 192
        [SecT193Field squareN:t0 withN:1 withZ:t1];
        [SecT193Field multiply:t0 withY:t1 withZ:t0];
        [SecT193Field squareN:t1 withN:1 withZ:t1];
        [SecT193Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 64
        [SecT193Field squareN:t0 withN:3 withZ:t1];
        [SecT193Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 32
        [SecT193Field squareN:t0 withN:6 withZ:t1];
        [SecT193Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 16
        [SecT193Field squareN:t0 withN:12 withZ:t1];
        [SecT193Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 8
        [SecT193Field squareN:t0 withN:24 withZ:t1];
        [SecT193Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 4
        [SecT193Field squareN:t0 withN:48 withZ:t1];
        [SecT193Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 2
        [SecT193Field squareN:t0 withN:96 withZ:t1];
        [SecT193Field multiply:t0 withY:t1 withZ:z];
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
        [SecT193Field implMultiply:x withY:y withZZ:tt];
        [SecT193Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT193Field implMultiply:x withY:y withZZ:tt];
        [SecT193Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [xx[0] unsignedLongLongValue], x1 = [xx[1] unsignedLongLongValue], x2 = [xx[2] unsignedLongLongValue], x3 = [xx[3] unsignedLongLongValue], x4 = [xx[4] unsignedLongLongValue], x5 = [xx[5] unsignedLongLongValue], x6 = [xx[6] unsignedLongLongValue];
        
        x2 ^= (x6 << 63);
        x3 ^= (x6 >>  1) ^ (x6 << 14);
        x4 ^= (x6 >> 50);
        
        x1 ^= (x5 << 63);
        x2 ^= (x5 >>  1) ^ (x5 << 14);
        x3 ^= (x5 >> 50);
        
        x0 ^= (x4 << 63);
        x1 ^= (x4 >>  1) ^ (x4 << 14);
        x2 ^= (x4 >> 50);
        
        uint64_t t = x3 >> 1;
        z[0] = @(x0 ^ t ^ (t << 15));
        z[1] = @(x1 ^ (t >> 49));
        z[2] = @(x2);
        z[3] = @(x3 & M01);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce63:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z3 = [z[zOff + 3] unsignedLongLongValue], t = z3 >> 1;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (t ^ (t << 15)));
        z[zOff + 1] = @([z[zOff + 1] unsignedLongLongValue] ^ (t >> 49));
        z[zOff + 3] = @(z3 & M01);
    }
}

// NSMutableArray == uint64_t[]
+ (void)sqrt:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t u0, u1;
        u0 = [Interleave unshuffle:[x[0] unsignedLongLongValue]]; u1 = [Interleave unshuffle:[x[1] unsignedLongLongValue]];
        uint64_t e0 = (u0 & 0x00000000FFFFFFFFUL) | (u1 << 32);
        uint64_t c0 = (u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL);
        
        u0 = [Interleave unshuffle:[x[2] unsignedLongLongValue]];
        uint64_t e1 = (u0 & 0x00000000FFFFFFFFUL) ^ ([x[3] unsignedLongLongValue] << 32);
        uint64_t c1 = (u0 >> 32);
        
        z[0] = @(e0 ^ (c0 << 8));
        z[1] = @(e1 ^ (c1 << 8) ^ (c0 >> 56) ^ (c0 << 33));
        z[2] = @((c1 >> 56) ^ (c1 << 33) ^ (c0 >> 31));
        z[3] = @(c1 >> 31);
    }
}

// NSMutableArray == uint64_t[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT193Field implSquare:x withZZ:tt];
        [SecT193Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT193Field implSquare:x withZZ:tt];
        [SecT193Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT193Field implSquare:x withZZ:tt];
        [SecT193Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT193Field implSquare:z withZZ:tt];
            [SecT193Field reduce:tt withZ:z];
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
        uint64_t z0 = [zz[0] unsignedLongLongValue], z1 = [zz[1] unsignedLongLongValue], z2 = [zz[2] unsignedLongLongValue], z3 = [zz[3] unsignedLongLongValue], z4 = [zz[4] unsignedLongLongValue], z5 = [zz[5] unsignedLongLongValue], z6 = [zz[6] unsignedLongLongValue], z7 = [zz[7] unsignedLongLongValue];
        zz[0] = @(z0 ^ (z1 << 49));
        zz[1] = @((z1 >> 15) ^ (z2 << 34));
        zz[2] = @((z2 >> 30) ^ (z3 << 19));
        zz[3] = @((z3 >> 45) ^ (z4 <<  4) ^ (z5 << 53));
        zz[4] = @((z4 >> 60) ^ (z6 << 38) ^ (z5 >> 11));
        zz[5] = @((z6 >> 26) ^ (z7 << 23));
        zz[6] = @(z7 >> 41);
        zz[7] = @(0);
    }
}

// NSMutableArray == uint64_t[]
+ (void)implExpand:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [x[0] unsignedLongLongValue], x1 = [x[1] unsignedLongLongValue], x2 = [x[2] unsignedLongLongValue], x3 = [x[3] unsignedLongLongValue];
        z[0] = @(x0 & M49);
        z[1] = @(((x0 >> 49) ^ (x1 << 15)) & M49);
        z[2] = @(((x1 >> 34) ^ (x2 << 30)) & M49);
        z[3] = @((x2 >> 19) ^ (x3 << 45));
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        /*
         * "Two-level seven-way recursion" as described in "Batch binary Edwards", Daniel J. Bernstein.
         */
        
        NSMutableArray *f = [[NSMutableArray alloc] initWithSize:4], *g = [[NSMutableArray alloc] initWithSize:4];
        [SecT193Field implExpand:x withZ:f];
        [SecT193Field implExpand:y withZ:g];
        
        [SecT193Field implMulwAcc:[f[0] unsignedLongLongValue] withY:[g[0] unsignedLongLongValue] withZ:zz withZoff:0];
        [SecT193Field implMulwAcc:[f[1] unsignedLongLongValue] withY:[g[1] unsignedLongLongValue] withZ:zz withZoff:1];
        [SecT193Field implMulwAcc:[f[2] unsignedLongLongValue] withY:[g[2] unsignedLongLongValue] withZ:zz withZoff:2];
        [SecT193Field implMulwAcc:[f[3] unsignedLongLongValue] withY:[g[3] unsignedLongLongValue] withZ:zz withZoff:3];
        
        // U *= (1 - t^n)
        for (int i = 5; i > 0; --i) {
            zz[i] = @([zz[i] unsignedLongLongValue] ^ [zz[i - 1] unsignedLongLongValue]);
        }
        
        [SecT193Field implMulwAcc:([f[0] unsignedLongLongValue] ^ [f[1] unsignedLongLongValue]) withY:([g[0] unsignedLongLongValue] ^ [g[1] unsignedLongLongValue]) withZ:zz withZoff:1];
        [SecT193Field implMulwAcc:([f[2] unsignedLongLongValue] ^ [f[3] unsignedLongLongValue]) withY:([g[2] unsignedLongLongValue] ^ [g[3] unsignedLongLongValue]) withZ:zz withZoff:3];
        
        // V *= (1 - t^2n)
        for (int i = 7; i > 1; --i) {
            zz[i] = @([zz[i] unsignedLongLongValue] ^ [zz[i - 2] unsignedLongLongValue]);
        }
        
        // Double-length recursion
        {
            uint64_t c0 = [f[0] unsignedLongLongValue] ^ [f[2] unsignedLongLongValue], c1 = [f[1] unsignedLongLongValue] ^ [f[3] unsignedLongLongValue];
            uint64_t d0 = [g[0] unsignedLongLongValue] ^ [g[2] unsignedLongLongValue], d1 = [g[1] unsignedLongLongValue] ^ [g[3] unsignedLongLongValue];
            [SecT193Field implMulwAcc:(c0 ^ c1) withY:(d0 ^ d1) withZ:zz withZoff:3];
            NSMutableArray *t = [[NSMutableArray alloc] initWithSize:3];
            [SecT193Field implMulwAcc:c0 withY:d0 withZ:t withZoff:0];
            [SecT193Field implMulwAcc:c1 withY:d1 withZ:t withZoff:1];
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
        [SecT193Field implCompactExt:zz];
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
        int k = 36;
        do {
            j  = (uint)(x >> k);
            g  = [u[j & 7] unsignedLongLongValue] ^ [u[(j >> 3) & 7] unsignedLongLongValue] << 3 ^ [u[(j >> 6) & 7] unsignedLongLongValue] << 6 ^ [u[(j >> 9) & 7] unsignedLongLongValue] << 9 ^ [u[(j >> 12) & 7] unsignedLongLongValue] << 12;
            l ^= (g <<  k);
            h ^= (g >> -k);
        } while ((k -= 15) > 0);
        
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (l & M49));
        z[zOff + 1] = @([z[zOff + 1] unsignedLongLongValue] ^ ((l >> 49) ^ (h << 15)));
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
        zz[6] = @([x[3] unsignedLongLongValue] & M01);
    }
}

@end

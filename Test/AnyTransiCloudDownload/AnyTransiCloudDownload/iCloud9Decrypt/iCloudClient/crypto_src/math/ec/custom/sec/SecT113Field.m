//
//  SecT113Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT113Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat128.h"
#import "Interleave.h"

@implementation SecT113Field

static const uint64_t M49 = UINT64_MAX >> 15;
static const uint64_t M57 = UINT64_MAX >> 7;

// NSMutableArray == uint64_t[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ [y[0] unsignedLongLongValue]);
        z[1] = @([x[1] unsignedLongLongValue] ^ [y[1] unsignedLongLongValue]);
    }
}

// NSMutableArray == uint64_t[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        zz[0] = @([xx[0] unsignedLongLongValue] ^ [yy[0] unsignedLongLongValue]);
        zz[1] = @([xx[1] unsignedLongLongValue] ^ [yy[1] unsignedLongLongValue]);
        zz[2] = @([xx[2] unsignedLongLongValue] ^ [yy[2] unsignedLongLongValue]);
        zz[3] = @([xx[3] unsignedLongLongValue] ^ [yy[3] unsignedLongLongValue]);
    }
}

// NSMutableArray == uint64_t[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ 1UL);
        z[1] = x[1];        
    }
}

// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat128 fromBigInteger64:x];
    [SecT113Field reduce15:z withZoff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat128 isZero64:x]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
    }
    
    @autoreleasepool {
        // Itoh-Tsujii inversion
        
        NSMutableArray *t0 = [Nat128 create64];
        NSMutableArray *t1 = [Nat128 create64];
        
        [SecT113Field square:x withZ:t0];
        [SecT113Field multiply:t0 withY:x withZ:t0];
        [SecT113Field square:t0 withZ:t0];
        [SecT113Field multiply:t0 withY:x withZ:t0];
        [SecT113Field squareN:t0 withN:3 withZ:t1];
        [SecT113Field multiply:t1 withY:t0 withZ:t1];
        [SecT113Field square:t1 withZ:t1];
        [SecT113Field multiply:t1 withY:x withZ:t1];
        [SecT113Field squareN:t1 withN:7 withZ:t0];
        [SecT113Field multiply:t0 withY:t1 withZ:t0];
        [SecT113Field squareN:t0 withN:14 withZ:t1];
        [SecT113Field multiply:t1 withY:t0 withZ:t1];
        [SecT113Field squareN:t1 withN:28 withZ:t0];
        [SecT113Field multiply:t0 withY:t1 withZ:t0];
        [SecT113Field squareN:t0 withN:56 withZ:t1];
        [SecT113Field multiply:t1 withY:t0 withZ:t1];
        [SecT113Field square:t1 withZ:z];
#if !__has_feature(objc_arc)
        if (t0) [t0 release]; t0 = nil;
        if (t1) [t1 release]; t1 = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat128 createExt64];
        [SecT113Field implMultiply:x withY:y withZZ:tt];
        [SecT113Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat128 createExt64];
        [SecT113Field implMultiply:x withY:y withZZ:tt];
        [SecT113Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [xx[0] unsignedLongLongValue], x1 = [xx[1] unsignedLongLongValue], x2 = [xx[2] unsignedLongLongValue], x3 = [xx[3] unsignedLongLongValue];
        
        x1 ^= (x3 << 15) ^ (x3 << 24);
        x2 ^= (x3 >> 49) ^ (x3 >> 40);
        
        x0 ^= (x2 << 15) ^ (x2 << 24);
        x1 ^= (x2 >> 49) ^ (x2 >> 40);
        
        uint64_t t = x1 >> 49;
        z[0] = @(x0 ^ t ^ (t << 9));
        z[1] = @(x1 & M49);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce15:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z1 = [z[zOff + 1] unsignedLongLongValue], t = z1 >> 49;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (t ^ (t << 9)));
        z[zOff + 1]  = @(z1 & M49);
    }
}

// NSMutableArray == uint64_t[]
+ (void)sqrt:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t u0 = [Interleave unshuffle:[x[0] unsignedLongLongValue]], u1 = [Interleave unshuffle:[x[1] unsignedLongLongValue]];
        uint64_t e0 = (u0 & 0x00000000FFFFFFFFUL) | (u1 << 32);
        uint64_t c0  = (u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL);
        
        z[0] = @(e0 ^ (c0 << 57) ^ (c0 <<  5));
        z[1] = @((c0 >>  7) ^ (c0 >> 59));
    }
}

// NSMutableArray == uint64_t[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat128 createExt64];
        [SecT113Field implSquare:x withZZ:tt];
        [SecT113Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat128 createExt64];
        [SecT113Field implSquare:x withZZ:tt];
        [SecT113Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat128 createExt64];
        [SecT113Field implSquare:x withZZ:tt];
        [SecT113Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT113Field implSquare:z withZZ:tt];
            [SecT113Field reduce:tt withZ:z];
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
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        /*
         * "Three-way recursion" as described in "Batch binary Edwards", Daniel J. Bernstein.
         */
        
        uint64_t f0 = [x[0] unsignedLongLongValue], f1 = [x[1] unsignedLongLongValue];
        f1  = ((f0 >> 57) ^ (f1 << 7)) & M57;
        f0 &= M57;
        
        uint64_t g0 = [y[0] unsignedLongLongValue], g1 = [y[1] unsignedLongLongValue];
        g1  = ((g0 >> 57) ^ (g1 << 7)) & M57;
        g0 &= M57;
        
        NSMutableArray *H = [[NSMutableArray alloc] initWithSize:6];
        
        [SecT113Field implMulw:f0 withY:g0 withZ:H withZoff:0];                     // H(0)       57/56 bits
        [SecT113Field implMulw:f1 withY:g1 withZ:H withZoff:2];                     // H(INF)     57/54 bits
        [SecT113Field implMulw:(f0 ^ f1) withY:(g0 ^ g1) withZ:H withZoff:4];       // H(1)       57/56 bits
        
        uint64_t r  = [H[1] unsignedLongLongValue] ^ [H[2] unsignedLongLongValue];
        uint64_t z0 = [H[0] unsignedLongLongValue],
        z3 = [H[3] unsignedLongLongValue],
        z1 = [H[4] unsignedLongLongValue] ^ z0 ^ r,
        z2 = [H[5] unsignedLongLongValue] ^ z3 ^ r;
        
        zz[0] = @(z0 ^ (z1 << 57));
        zz[1] = @((z1 >>  7) ^ (z2 << 50));
        zz[2] = @((z2 >> 14) ^ (z3 << 43));
        zz[3] = @(z3 >> 21);
#if !__has_feature(objc_arc)
        if (H != nil) [H release]; H = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMulw:(uint64_t)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        NSMutableArray *u = [[NSMutableArray alloc] initWithSize:8];
        //u[0] = 0;
        u[1] = @(y);
        u[2] = @([u[1] unsignedLongLongValue] << 1);
        u[3] = @([u[2] unsignedLongLongValue] ^ y);
        u[4] = @([u[2] unsignedLongLongValue] << 1);
        u[5] = @([u[4] unsignedLongLongValue] ^ y);
        u[6] = @([u[3] unsignedLongLongValue] << 1);
        u[7] = @([u[6] unsignedLongLongValue] ^ y);
        
        uint j = (uint)x;
        uint64_t g, h = 0, l = [u[j & 7] unsignedLongLongValue];
        int k = 48;
        do {
            j  = (uint)(x >> k);
            g  = [u[j & 7] unsignedLongLongValue] ^ [u[(j >> 3) & 7] unsignedLongLongValue] << 3 ^ [u[(j >> 6) & 7] unsignedLongLongValue] << 6;
            l ^= (g << k);
            h ^= (g >> -k);
        } while ((k -= 9) > 0);
        
        h ^= ((x & 0x0100804020100800UL) & (uint64_t)(((int64_t)y << 7) >> 63)) >> 8;
        
        z[zOff] = @(l & M57);
        z[zOff + 1] = @((l >> 57) ^ (h << 7));
#if !__has_feature(objc_arc)
        if (u != nil) [u release]; u = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    [Interleave expand64To128:[x[0] unsignedLongLongValue] withZ:zz withZ0ff:0];
    [Interleave expand64To128:[x[1] unsignedLongLongValue] withZ:zz withZ0ff:2];
}

@end

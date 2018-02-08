//
//  SecT131Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT131Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat192.h"
#import "Nat.h"
#import "Interleave.h"

@implementation SecT131Field

static const uint64_t M03 = UINT64_MAX >> 61;
static const uint64_t M44 = UINT64_MAX >> 20;

// return == uint64_t[]
+ (NSMutableArray*)ROOT_Z {
    static NSMutableArray *_root_z = nil;
    @synchronized(self) {
        if (_root_z == nil) {
            @autoreleasepool {
                _root_z = [@[@((uint64_t)0x26BC4D789AF13523UL), @((uint64_t)0x26BC4D789AF135E2UL), @((uint64_t)0x6UL)] mutableCopy];
            }
        }
    }
    return _root_z;
}

// NSMutableArray == uint64_t[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ [y[0] unsignedLongLongValue]);
        z[1] = @([x[1] unsignedLongLongValue] ^ [y[1] unsignedLongLongValue]);
        z[2] = @([x[2] unsignedLongLongValue] ^ [y[2] unsignedLongLongValue]);
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
    }
}

// NSMutableArray == uint64_t[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ 1UL);
        z[1] = x[1];
        z[2] = x[2];        
    }
}

// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat192 fromBigInteger64:x];
    [SecT131Field reduce61:z withZoff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat192 isZero64:x]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
    }
    
    @autoreleasepool {
        // Itoh-Tsujii inversion
        
        NSMutableArray *t0 = [Nat192 create64];
        NSMutableArray *t1 = [Nat192 create64];
        
        [SecT131Field square:x withZ:t0];
        [SecT131Field multiply:t0 withY:x withZ:t0];
        [SecT131Field squareN:t0 withN:2 withZ:t1];
        [SecT131Field multiply:t1 withY:t0 withZ:t1];
        [SecT131Field squareN:t1 withN:4 withZ:t0];
        [SecT131Field multiply:t0 withY:t1 withZ:t0];
        [SecT131Field squareN:t0 withN:8 withZ:t1];
        [SecT131Field multiply:t1 withY:t0 withZ:t1];
        [SecT131Field squareN:t1 withN:16 withZ:t0];
        [SecT131Field multiply:t0 withY:t1 withZ:t0];
        [SecT131Field squareN:t0 withN:32 withZ:t1];
        [SecT131Field multiply:t1 withY:t0 withZ:t1];
        [SecT131Field square:t1 withZ:t1];
        [SecT131Field multiply:t1 withY:x withZ:t1];
        [SecT131Field squareN:t1 withN:65 withZ:t0];
        [SecT131Field multiply:t0 withY:t1 withZ:t0];
        [SecT131Field square:t0 withZ:z];
#if !__has_feature(objc_arc)
        if (t0) [t0 release]; t0 = nil;
        if (t1) [t1 release]; t1 = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt64];
        [SecT131Field implMultiply:x withY:y withZZ:tt];
        [SecT131Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt64];
        [SecT131Field implMultiply:x withY:y withZZ:tt];
        [SecT131Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [xx[0] unsignedLongLongValue], x1 = [xx[1] unsignedLongLongValue], x2 = [xx[2] unsignedLongLongValue], x3 = [xx[3] unsignedLongLongValue], x4 = [xx[4] unsignedLongLongValue];
        
        x1 ^= (x4 << 61) ^ (x4 << 63);
        x2 ^= (x4 >>  3) ^ (x4 >>  1) ^ x4 ^ (x4 <<  5);
        x3 ^= (x4 >> 59);
        
        x0 ^= (x3 << 61) ^ (x3 << 63);
        x1 ^= (x3 >>  3) ^ (x3 >>  1) ^ x3 ^ (x3 <<  5);
        x2 ^= (x3 >> 59);
        
        uint64_t t = x2 >> 3;
        z[0] = @(x0 ^ t ^ (t << 2) ^ (t << 3) ^ (t <<  8));
        z[1] = @(x1 ^ (t >> 56));
        z[2] = @(x2 & M03);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce61:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z2 = [z[zOff + 2] unsignedLongLongValue], t = z2 >> 3;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (t ^ (t << 2) ^ (t << 3) ^ (t <<  8)));
        z[zOff + 1] = @([z[zOff + 1] unsignedLongLongValue] ^ (t >> 56));
        z[zOff + 2]  = @(z2 & M03);
    }
}

// NSMutableArray == uint64_t[]
+ (void)sqrt:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *odd = [Nat192 create64];
        
        uint64_t u0, u1;
        u0 = [Interleave unshuffle:[x[0] unsignedLongLongValue]]; u1 = [Interleave unshuffle:[x[1] unsignedLongLongValue]];
        uint64_t e0 = (u0 & 0x00000000FFFFFFFFUL) | (u1 << 32);
        odd[0] = @((u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL));
        
        u0 = [Interleave unshuffle:[x[2] unsignedLongLongValue]];
        uint64_t e1 = (u0 & 0x00000000FFFFFFFFUL);
        odd[1] = @(u0 >> 32);
        
        [SecT131Field multiply:odd withY:[SecT131Field ROOT_Z] withZ:z];
        
        z[0] = @([z[0] unsignedLongLongValue] ^ e0);
        z[1] = @([z[1] unsignedLongLongValue] ^ e1);
#if !__has_feature(objc_arc)
        if (odd) [odd release]; odd = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:5];
        [SecT131Field implSquare:x withZZ:tt];
        [SecT131Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
    if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:5];
        [SecT131Field implSquare:x withZZ:tt];
        [SecT131Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:5];
        [SecT131Field implSquare:x withZZ:tt];
        [SecT131Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT131Field implSquare:z withZZ:tt];
            [SecT131Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (uint)trace:(NSMutableArray*)x {
    // Non-zero-trace bits: 0, 123, 129
    return (uint)([x[0] unsignedLongLongValue] ^ ([x[1] unsignedLongLongValue] >> 59) ^ ([x[2] unsignedLongLongValue] >> 1)) & 1U;
}

// NSMutableArray == uint64_t[]
+ (void)implCompactExt:(NSMutableArray*)zz {
    @autoreleasepool {
        uint64_t z0 = [zz[0] unsignedLongLongValue], z1 = [zz[1] unsignedLongLongValue], z2 = [zz[2] unsignedLongLongValue], z3 = [zz[3] unsignedLongLongValue], z4 = [zz[4] unsignedLongLongValue], z5 = [zz[5] unsignedLongLongValue];
        zz[0] = @(z0 ^ (z1 << 44));
        zz[1] = @((z1 >> 20) ^ (z2 << 24));
        zz[2] = @((z2 >> 40) ^ (z3 <<  4) ^ (z4 << 48));
        zz[3] = @((z3 >> 60) ^ (z5 << 28) ^ (z4 >> 16));
        zz[4] = @(z5 >> 36);
        zz[5] = @(0);
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        /*
         * "Five-way recursion" as described in "Batch binary Edwards", Daniel J. Bernstein.
         */
        
        uint64_t f0 = [x[0] unsignedLongLongValue], f1 = [x[1] unsignedLongLongValue], f2 = [x[2] unsignedLongLongValue];
        f2  = ((f1 >> 24) ^ (f2 << 40)) & M44;
        f1  = ((f0 >> 44) ^ (f1 << 20)) & M44;
        f0 &= M44;
        
        uint64_t g0 = [y[0] unsignedLongLongValue], g1 = [y[1] unsignedLongLongValue], g2 = [y[2] unsignedLongLongValue];
        g2  = ((g1 >> 24) ^ (g2 << 40)) & M44;
        g1  = ((g0 >> 44) ^ (g1 << 20)) & M44;
        g0 &= M44;
        
        NSMutableArray *H = [[NSMutableArray alloc] initWithSize:10];
        
        [SecT131Field implMulw:f0 withY:g0 withZ:H withZoff:0];               // H(0)       44/43 bits
        [SecT131Field implMulw:f2 withY:g2 withZ:H withZoff:2];               // H(INF)     44/41 bits
        
        uint64_t t0 = f0 ^ f1 ^ f2;
        uint64_t t1 = g0 ^ g1 ^ g2;
        
        [SecT131Field implMulw:t0 withY:t1 withZ:H withZoff:4];               // H(1)       44/43 bits
        
        uint64_t t2 = (f1 << 1) ^ (f2 << 2);
        uint64_t t3 = (g1 << 1) ^ (g2 << 2);
        
        [SecT131Field implMulw:(f0 ^ t2) withY:(g0 ^ t3) withZ:H withZoff:6];     // H(t)       44/45 bits
        [SecT131Field implMulw:(t0 ^ t2) withY:(t1 ^ t3) withZ:H withZoff:8];     // H(t + 1)   44/45 bits
        
        uint64_t t4 = [H[6] unsignedLongLongValue] ^ [H[8] unsignedLongLongValue];
        uint64_t t5 = [H[7] unsignedLongLongValue] ^ [H[9] unsignedLongLongValue];
        
        // Calculate V
        uint64_t v0 = (t4 << 1) ^ [H[6] unsignedLongLongValue];
        uint64_t v1 = t4 ^ (t5 << 1) ^ [H[7] unsignedLongLongValue];
        uint64_t v2 = t5;
        
        // Calculate U
        uint64_t u0 = [H[0] unsignedLongLongValue];
        uint64_t u1 = [H[1] unsignedLongLongValue] ^ [H[0] unsignedLongLongValue] ^ [H[4] unsignedLongLongValue];
        uint64_t u2 = [H[1] unsignedLongLongValue] ^ [H[5] unsignedLongLongValue];
        
        // Calculate W
        uint64_t w0 = u0 ^ v0 ^ ([H[2] unsignedLongLongValue] << 4) ^ ([H[2] unsignedLongLongValue] << 1);
        uint64_t w1 = u1 ^ v1 ^ ([H[3] unsignedLongLongValue] << 4) ^ ([H[3] unsignedLongLongValue] << 1);
        uint64_t w2 = u2 ^ v2;
        
        // Propagate carries
        w1 ^= (w0 >> 44); w0 &= M44;
        w2 ^= (w1 >> 44); w1 &= M44;
        
        // Divide W by t
        w0 = (w0 >> 1) ^ ((w1 & 1UL) << 43);
        w1 = (w1 >> 1) ^ ((w2 & 1UL) << 43);
        w2 = (w2 >> 1);
        
        // Divide W by (t + 1)
        
        w0 ^= (w0 << 1);
        w0 ^= (w0 << 2);
        w0 ^= (w0 << 4);
        w0 ^= (w0 << 8);
        w0 ^= (w0 << 16);
        w0 ^= (w0 << 32);
        
        w0 &= M44; w1 ^= (w0 >> 43);
        
        w1 ^= (w1 << 1);
        w1 ^= (w1 << 2);
        w1 ^= (w1 << 4);
        w1 ^= (w1 << 8);
        w1 ^= (w1 << 16);
        w1 ^= (w1 << 32);
        
        w1 &= M44; w2 ^= (w1 >> 43);
        
        w2 ^= (w2 << 1);
        w2 ^= (w2 << 2);
        w2 ^= (w2 << 4);
        w2 ^= (w2 << 8);
        w2 ^= (w2 << 16);
        w2 ^= (w2 << 32);
        
        zz[0] = @(u0);
        zz[1] = @(u1 ^ w0 ^ [H[2] unsignedLongLongValue]);
        zz[2] = @(u2 ^ w1 ^ w0 ^ [H[3] unsignedLongLongValue]);
        zz[3] = @(w2 ^ w1);
        zz[4] = @(w2 ^ [H[2] unsignedLongLongValue]);
        zz[5] = H[3];
        
#if !__has_feature(objc_arc)
        if (H != nil) [H release]; H = nil;
#endif
        [SecT131Field implCompactExt:zz];
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMulw:(uint64_t)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
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
        
        uint j = (uint)x;
        uint64_t g, h = 0, l = [u[j & 7] unsignedLongLongValue] ^ [u[(j >> 3) & 7] unsignedLongLongValue] << 3 ^ [u[(j >> 6) & 7] unsignedLongLongValue] << 6;
        int k = 33;
        do {
            j  = (uint)(x >> k);
            g  = [u[j & 7] unsignedLongLongValue] ^ [u[(j >> 3) & 7] unsignedLongLongValue] << 3 ^ [u[(j >> 6) & 7] unsignedLongLongValue] << 6 ^ [u[(j >> 9) & 7] unsignedLongLongValue] << 9;
            l ^= (g <<  k);
            h ^= (g >> -k);
        } while ((k -= 12) > 0);
        
#if !__has_feature(objc_arc)
        if (u != nil) [u release]; u = nil;
#endif
        z[zOff] = @(l & M44);
        z[zOff + 1] = @((l >> 44) ^ (h << 20));
    }
}

// NSMutableArray == uint64_t[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Interleave expand64To128:[x[0] unsignedLongLongValue] withZ:zz withZ0ff:0];
        [Interleave expand64To128:[x[1] unsignedLongLongValue] withZ:zz withZ0ff:2];
        
        zz[4] = @((uint64_t)[Interleave expand8to16:[x[2] unsignedIntValue]]);        
    }
}

@end

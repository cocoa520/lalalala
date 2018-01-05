//
//  SecT163Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT163Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat192.h"
#import "Interleave.h"

@implementation SecT163Field

static const uint64_t M35 = UINT64_MAX >> 29;
static const uint64_t M55 = UINT64_MAX >> 9;

// return == uint64_t[]
+ (NSMutableArray*)ROOT_Z {
    static NSMutableArray *_root_z = nil;
    @synchronized(self) {
        if (_root_z == nil) {
            @autoreleasepool {
                _root_z = [@[@((uint64_t)0xB6DB6DB6DB6DB6B0UL), @((uint64_t)0x492492492492DB6DUL), @((uint64_t)0x492492492UL)] mutableCopy];
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
        zz[5] = @([xx[5] unsignedLongLongValue] ^ [yy[5] unsignedLongLongValue]);
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
    [SecT163Field reduce29:z withZoff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat192 isZero64:x]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
    }
    
    @autoreleasepool {
        // Itoh-Tsujii inversion with bases { 2, 3 }
        
        NSMutableArray *t0 = [Nat192 create64];
        NSMutableArray *t1 = [Nat192 create64];
        
        [SecT163Field square:x withZ:t0];
        
        // 3 | 162
        [SecT163Field squareN:t0 withN:1 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:t0];
        [SecT163Field squareN:t1 withN:1 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:t0];
        
        // 3 | 54
        [SecT163Field squareN:t0 withN:3 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:t0];
        [SecT163Field squareN:t1 withN:3 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:t0];
        
        // 3 | 18
        [SecT163Field squareN:t0 withN:9 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:t0];
        [SecT163Field squareN:t1 withN:9 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:t0];
        
        // 3 | 6
        [SecT163Field squareN:t0 withN:27 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:t0];
        [SecT163Field squareN:t1 withN:27 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 2
        [SecT163Field squareN:t0 withN:81 withZ:t1];
        [SecT163Field multiply:t0 withY:t1 withZ:z];
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
        [SecT163Field implMultiply:x withY:y withZZ:tt];
        [SecT163Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt64];
        [SecT163Field implMultiply:x withY:y withZZ:tt];
        [SecT163Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [xx[0] unsignedLongLongValue], x1 = [xx[1] unsignedLongLongValue], x2 = [xx[2] unsignedLongLongValue], x3 = [xx[3] unsignedLongLongValue], x4 = [xx[4] unsignedLongLongValue], x5 = [xx[5] unsignedLongLongValue];
        
        x2 ^= (x5 << 29) ^ (x5 << 32) ^ (x5 << 35) ^ (x5 << 36);
        x3 ^= (x5 >> 35) ^ (x5 >> 32) ^ (x5 >> 29) ^ (x5 >> 28);
        
        x1 ^= (x4 << 29) ^ (x4 << 32) ^ (x4 << 35) ^ (x4 << 36);
        x2 ^= (x4 >> 35) ^ (x4 >> 32) ^ (x4 >> 29) ^ (x4 >> 28);
        
        x0 ^= (x3 << 29) ^ (x3 << 32) ^ (x3 << 35) ^ (x3 << 36);
        x1 ^= (x3 >> 35) ^ (x3 >> 32) ^ (x3 >> 29) ^ (x3 >> 28);
        
        uint64_t t = x2 >> 35;
        z[0] = @(x0 ^ t ^ (t << 3) ^ (t << 6) ^ (t << 7));
        z[1] = @(x1);
        z[2] = @(x2 & M35);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce29:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z2 = [z[zOff + 2] unsignedLongLongValue], t = z2 >> 35;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (t ^ (t << 3) ^ (t << 6) ^ (t << 7)));
        z[zOff + 2] = @(z2 & M35);
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
        
        [SecT163Field multiply:odd withY:[SecT163Field ROOT_Z] withZ:z];
        
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
        NSMutableArray *tt = [Nat192 createExt64];
        [SecT163Field implSquare:x withZZ:tt];
        [SecT163Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt64];
        [SecT163Field implSquare:x withZZ:tt];
        [SecT163Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt64];
        [SecT163Field implSquare:x withZZ:tt];
        [SecT163Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT163Field implSquare:z withZZ:tt];
            [SecT163Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (uint)trace:(NSMutableArray*)x {
    // Non-zero-trace bits: 0, 157
    return (uint)([x[0] unsignedLongLongValue] ^ ([x[2] unsignedLongLongValue] >> 29)) & 1U;
}

// NSMutableArray == uint64_t[]
+ (void)implCompactExt:(NSMutableArray*)zz {
    @autoreleasepool {
        uint64_t z0 = [zz[0] unsignedLongLongValue], z1 = [zz[1] unsignedLongLongValue], z2 = [zz[2] unsignedLongLongValue], z3 = [zz[3] unsignedLongLongValue], z4 = [zz[4] unsignedLongLongValue], z5 = [zz[5] unsignedLongLongValue];
        zz[0] = @(z0 ^ (z1 << 55));
        zz[1] = @((z1 >>  9) ^ (z2 << 46));
        zz[2] = @((z2 >> 18) ^ (z3 << 37));
        zz[3] = @((z3 >> 27) ^ (z4 << 28));
        zz[4] = @((z4 >> 36) ^ (z5 << 19));
        zz[5] = @(z5 >> 45);
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        /*
         * "Five-way recursion" as described in "Batch binary Edwards", Daniel J. Bernstein.
         */
        
        uint64_t f0 = [x[0] unsignedLongLongValue], f1 = [x[1] unsignedLongLongValue], f2 = [x[2] unsignedLongLongValue];
        f2  = ((f1 >> 46) ^ (f2 << 18));
        f1  = ((f0 >> 55) ^ (f1 <<  9)) & M55;
        f0 &= M55;
        
        uint64_t g0 = [y[0] unsignedLongLongValue], g1 = [y[1] unsignedLongLongValue], g2 = [y[2] unsignedLongLongValue];
        g2  = ((g1 >> 46) ^ (g2 << 18));
        g1  = ((g0 >> 55) ^ (g1 <<  9)) & M55;
        g0 &= M55;
        
        NSMutableArray *H = [[NSMutableArray alloc] initWithSize:10];
        
        [SecT163Field implMulw:f0 withY:g0 withZ:H withZoff:0];               // H(0)       55/54 bits
        [SecT163Field implMulw:f2 withY:g2 withZ:H withZoff:2];               // H(INF)     55/50 bits
        
        uint64_t t0 = f0 ^ f1 ^ f2;
        uint64_t t1 = g0 ^ g1 ^ g2;
        
        [SecT163Field implMulw:t0 withY:t1 withZ:H withZoff:4];               // H(1)       55/54 bits
        
        uint64_t t2 = (f1 << 1) ^ (f2 << 2);
        uint64_t t3 = (g1 << 1) ^ (g2 << 2);
        
        [SecT163Field implMulw:(f0 ^ t2) withY:(g0 ^ t3) withZ:H withZoff:6];     // H(t)       55/56 bits
        [SecT163Field implMulw:(t0 ^ t2) withY:(t1 ^ t3) withZ:H withZoff:8];     // H(t + 1)   55/56 bits
        
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
        w1 ^= (w0 >> 55); w0 &= M55;
        w2 ^= (w1 >> 55); w1 &= M55;
        
        // Divide W by t
        
        w0 = (w0 >> 1) ^ ((w1 & 1UL) << 54);
        w1 = (w1 >> 1) ^ ((w2 & 1UL) << 54);
        w2 = (w2 >> 1);
        
        // Divide W by (t + 1)
        
        w0 ^= (w0 << 1);
        w0 ^= (w0 << 2);
        w0 ^= (w0 << 4);
        w0 ^= (w0 << 8);
        w0 ^= (w0 << 16);
        w0 ^= (w0 << 32);
        
        w0 &= M55; w1 ^= (w0 >> 54);
        
        w1 ^= (w1 << 1);
        w1 ^= (w1 << 2);
        w1 ^= (w1 << 4);
        w1 ^= (w1 << 8);
        w1 ^= (w1 << 16);
        w1 ^= (w1 << 32);
        
        w1 &= M55; w2 ^= (w1 >> 54);
        
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
        [SecT163Field implCompactExt:zz];
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
        uint64_t g, h = 0, l = [u[j & 3] unsignedLongLongValue];
        int k = 47;
        do {
            j  = (uint)(x >> k);
            g  = [u[j & 7] unsignedLongLongValue] ^ [u[(j >> 3) & 7] unsignedLongLongValue] << 3 ^ [u[(j >> 6) & 7] unsignedLongLongValue] << 6;
            l ^= (g <<  k);
            h ^= (g >> -k);
        } while ((k -= 9) > 0);
        
#if !__has_feature(objc_arc)
        if (u != nil) [u release]; u = nil;
#endif
        z[zOff] = @(l & M55);
        z[zOff + 1] = @((l >> 55) ^ (h << 9));
    }
}

// NSMutableArray == uint64_t[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Interleave expand64To128:[x[0] unsignedLongLongValue] withZ:zz withZ0ff:0];
        [Interleave expand64To128:[x[1] unsignedLongLongValue] withZ:zz withZ0ff:2];
        
        uint64_t x2 = [x[2] unsignedLongLongValue];
        zz[4] = @((uint64_t)[Interleave expand32to64:(uint)x2]);
        zz[5] = @((uint64_t)[Interleave expand8to16:(uint)(x2 >> 32)]);        
    }
}

@end

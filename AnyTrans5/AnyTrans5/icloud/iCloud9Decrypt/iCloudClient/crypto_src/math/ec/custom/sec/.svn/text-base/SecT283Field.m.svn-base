//
//  SecT283Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT283Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat320.h"
#import "Nat.h"
#import "Interleave.h"

@implementation SecT283Field

static const uint64_t M27 = UINT64_MAX >> 37;
static const uint64_t M57 = UINT64_MAX >> 7;

// return == uint64_t[]
+ (NSMutableArray*)ROOT_Z {
    static NSMutableArray *_root_z = nil;
    @synchronized(self) {
        if (_root_z == nil) {
            @autoreleasepool {
                _root_z = [@[@((uint64_t)0x0C30C30C30C30808ULL), @((uint64_t)0x30C30C30C30C30C3ULL), @((uint64_t)0x820820820820830CULL), @((uint64_t)0x0820820820820820ULL), @((uint64_t)0x2082082ULL)] mutableCopy];
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
        z[3] = @([x[3] unsignedLongLongValue] ^ [y[3] unsignedLongLongValue]);
        z[4] = @([x[4] unsignedLongLongValue] ^ [y[4] unsignedLongLongValue]);
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
        zz[8] = @([xx[8] unsignedLongLongValue] ^ [yy[8] unsignedLongLongValue]);
    }
}

// NSMutableArray == uint64_t[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ 1ULL);
        z[1] = x[1];
        z[2] = x[2];
        z[3] = x[3];
        z[4] = x[4];
    }
}

// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat320 fromBigInteger64:x];
    [SecT283Field reduce37:z withZoff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat320 isZero64:x]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
    }
    
    @autoreleasepool {
        // Itoh-Tsujii inversion
        
        NSMutableArray *t0 = [Nat320 create64];
        NSMutableArray *t1 = [Nat320 create64];
        
        [SecT283Field square:x withZ:t0];
        [SecT283Field multiply:t0 withY:x withZ:t0];
        [SecT283Field squareN:t0 withN:2 withZ:t1];
        [SecT283Field multiply:t1 withY:t0 withZ:t1];
        [SecT283Field squareN:t1 withN:4 withZ:t0];
        [SecT283Field multiply:t0 withY:t1 withZ:t0];
        [SecT283Field squareN:t0 withN:8 withZ:t1];
        [SecT283Field multiply:t1 withY:t0 withZ:t1];
        [SecT283Field square:t1 withZ:t1];
        [SecT283Field multiply:t1 withY:x withZ:t1];
        [SecT283Field squareN:t1 withN:17 withZ:t0];
        [SecT283Field multiply:t0 withY:t1 withZ:t0];
        [SecT283Field square:t0 withZ:t0];
        [SecT283Field multiply:t0 withY:x withZ:t0];
        [SecT283Field squareN:t0 withN:35 withZ:t1];
        [SecT283Field multiply:t1 withY:t0 withZ:t1];
        [SecT283Field squareN:t1 withN:70 withZ:t0];
        [SecT283Field multiply:t0 withY:t1 withZ:t0];
        [SecT283Field square:t0 withZ:t0];
        [SecT283Field multiply:t0 withY:x withZ:t0];
        [SecT283Field squareN:t0 withN:141 withZ:t1];
        [SecT283Field multiply:t1 withY:t0 withZ:t1];
        [SecT283Field square:t1 withZ:z];
#if !__has_feature(objc_arc)
        if (t0) [t0 release]; t0 = nil;
        if (t1) [t1 release]; t1 = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat320 createExt64];
        [SecT283Field implMultiply:x withY:y withZZ:tt];
        [SecT283Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat320 createExt64];
        [SecT283Field implMultiply:x withY:y withZZ:tt];
        [SecT283Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [xx[0] unsignedLongLongValue], x1 = [xx[1] unsignedLongLongValue], x2 = [xx[2] unsignedLongLongValue], x3 = [xx[3] unsignedLongLongValue], x4 = [xx[4] unsignedLongLongValue];
        uint64_t x5 = [xx[5] unsignedLongLongValue], x6 = [xx[6] unsignedLongLongValue], x7 = [xx[7] unsignedLongLongValue], x8 = [xx[8] unsignedLongLongValue];
        
        x3 ^= (x8 << 37) ^ (x8 << 42) ^ (x8 << 44) ^ (x8 << 49);
        x4 ^= (x8 >> 27) ^ (x8 >> 22) ^ (x8 >> 20) ^ (x8 >> 15);
        
        x2 ^= (x7 << 37) ^ (x7 << 42) ^ (x7 << 44) ^ (x7 << 49);
        x3 ^= (x7 >> 27) ^ (x7 >> 22) ^ (x7 >> 20) ^ (x7 >> 15);
        
        x1 ^= (x6 << 37) ^ (x6 << 42) ^ (x6 << 44) ^ (x6 << 49);
        x2 ^= (x6 >> 27) ^ (x6 >> 22) ^ (x6 >> 20) ^ (x6 >> 15);
        
        x0 ^= (x5 << 37) ^ (x5 << 42) ^ (x5 << 44) ^ (x5 << 49);
        x1 ^= (x5 >> 27) ^ (x5 >> 22) ^ (x5 >> 20) ^ (x5 >> 15);
        
        uint64_t t = x4 >> 27;
        z[0] = @(x0 ^ t ^ (t << 5) ^ (t << 7) ^ (t << 12));
        z[1] = @(x1);
        z[2] = @(x2);
        z[3] = @(x3);
        z[4] = @(x4 & M27);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce37:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z4 = [z[zOff + 4] unsignedLongLongValue], t = z4 >> 27;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (t ^ (t << 5) ^ (t << 7) ^ (t << 12)));
        z[zOff + 4] = @(z4 & M27);
    }
}

// NSMutableArray == uint64_t[]
+ (void)sqrt:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *odd = [Nat320 create64];
        
        uint64_t u0, u1;
        u0 = [Interleave unshuffle:[x[0] unsignedLongLongValue]]; u1 = [Interleave unshuffle:[x[1] unsignedLongLongValue]];
        uint64_t e0 = (u0 & 0x00000000FFFFFFFFUL) | (u1 << 32);
        odd[0] = @((u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL));
        
        u0 = [Interleave unshuffle:[x[2] unsignedLongLongValue]]; u1 = [Interleave unshuffle:[x[3] unsignedLongLongValue]];
        uint64_t e1 = (u0 & 0x00000000FFFFFFFFUL) | (u1 << 32);
        odd[1] = @((u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL));
        
        u0 = [Interleave unshuffle:[x[4] unsignedLongLongValue]];
        uint64_t e2 = (u0 & 0x00000000FFFFFFFFUL);
        odd[2] = @(u0 >> 32);
        
        [SecT283Field multiply:odd withY:[SecT283Field ROOT_Z] withZ:z];
        
        z[0] = @([z[0] unsignedLongLongValue] ^ e0);
        z[1] = @([z[1] unsignedLongLongValue] ^ e1);
        z[2] = @([z[2] unsignedLongLongValue] ^ e2);
#if !__has_feature(objc_arc)
        if (odd) [odd release]; odd = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:9];
        [SecT283Field implSquare:x withZZ:tt];
        [SecT283Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:9];
        [SecT283Field implSquare:x withZZ:tt];
        [SecT283Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create64:9];
        [SecT283Field implSquare:x withZZ:tt];
        [SecT283Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT283Field implSquare:z withZZ:tt];
            [SecT283Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (uint)trace:(NSMutableArray*)x {
    // Non-zero-trace bits: 0, 271
    return (uint)([x[0] unsignedLongLongValue] ^ ([x[4] unsignedLongLongValue] >> 15)) & 1U;
}

// NSMutableArray == uint64_t[]
+ (void)implCompactExt:(NSMutableArray*)zz {
    @autoreleasepool {
        uint64_t z0 = [zz[0] unsignedLongLongValue], z1 = [zz[1] unsignedLongLongValue], z2 = [zz[2] unsignedLongLongValue], z3 = [zz[3] unsignedLongLongValue], z4 = [zz[4] unsignedLongLongValue];
        uint64_t z5 = [zz[5] unsignedLongLongValue], z6 = [zz[6] unsignedLongLongValue], z7 = [zz[7] unsignedLongLongValue], z8 = [zz[8] unsignedLongLongValue], z9 = [zz[9] unsignedLongLongValue];
        zz[0] = @(z0 ^ (z1 << 57));
        zz[1] = @((z1 >>  7) ^ (z2 << 50));
        zz[2] = @((z2 >> 14) ^ (z3 << 43));
        zz[3] = @((z3 >> 21) ^ (z4 << 36));
        zz[4] = @((z4 >> 28) ^ (z5 << 29));
        zz[5] = @((z5 >> 35) ^ (z6 << 22));
        zz[6] = @((z6 >> 42) ^ (z7 << 15));
        zz[7] = @((z7 >> 49) ^ (z8 <<  8));
        zz[8] = @((z8 >> 56) ^ (z9 <<  1));
        zz[9] = @(z9 >> 63); // Zero!
    }
}

// NSMutableArray == uint64_t[]
+ (void)implExpand:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [x[0] unsignedLongLongValue], x1 = [x[1] unsignedLongLongValue], x2 = [x[2] unsignedLongLongValue], x3 = [x[3] unsignedLongLongValue], x4 = [x[4] unsignedLongLongValue];
        z[0] = @(x0 & M57);
        z[1] = @(((x0 >> 57) ^ (x1 <<  7)) & M57);
        z[2] = @(((x1 >> 50) ^ (x2 << 14)) & M57);
        z[3] = @(((x2 >> 43) ^ (x3 << 21)) & M57);
        z[4] = @((x3 >> 36) ^ (x4 << 28));
    }
}

// NSMutableArray == uint64_t[], ms == uint[]
//+ (void)addMs:(NSMutableArray*)zz withZoff:(int)zOff withP:(NSMutableArray*)p withMs:(int)ms,... {
//    uint64_t t0 = 0, t1 = 0;
//    va_list argList;
//    int arg;
//    if (ms) {
//        va_start(argList, ms);
//        int i = (ms - 1) << 1;
//        t0 ^= [p[i] unsignedLongLongValue];
//        t1 ^= [p[i + 1] unsignedLongLongValue];
//        while((arg = va_arg(argList, int))) {
//            i = (arg - 1) << 1;
//            t0 ^= [p[i] unsignedLongLongValue];
//            t1 ^= [p[i + 1] unsignedLongLongValue];
//        }
//        va_end(argList);
//    }
//    zz[zOff] = @([zz[zOff] unsignedLongLongValue] ^ t0);
//    zz[zOff + 1] = @([zz[zOff + 1] unsignedLongLongValue] ^ t1);
//}

// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        /*
         * Formula (17) from "Some New Results on Binary Polynomial Multiplication",
         * Murat Cenk and M. Anwar Hasan.
         *
         * The formula as given contained an error in the term t25, as noted below
         */
        NSMutableArray *a = [[NSMutableArray alloc] initWithSize:5], *b = [[NSMutableArray alloc] initWithSize:5];
        [SecT283Field implExpand:x withZ:a];
        [SecT283Field implExpand:y withZ:b];
        
        NSMutableArray *p = [[NSMutableArray alloc] initWithSize:26];
        
        [SecT283Field implMulw:[a[0] unsignedLongLongValue] withY:[b[0] unsignedLongLongValue] withZ:p withZoff:0]; // m1
        [SecT283Field implMulw:[a[1] unsignedLongLongValue] withY:[b[1] unsignedLongLongValue] withZ:p withZoff:2]; // m2
        [SecT283Field implMulw:[a[2] unsignedLongLongValue] withY:[b[2] unsignedLongLongValue] withZ:p withZoff:4]; // m3
        [SecT283Field implMulw:[a[3] unsignedLongLongValue] withY:[b[3] unsignedLongLongValue] withZ:p withZoff:6]; // m4
        [SecT283Field implMulw:[a[4] unsignedLongLongValue] withY:[b[4] unsignedLongLongValue] withZ:p withZoff:8]; // m5
        
        uint64_t u0 = [a[0] unsignedLongLongValue] ^ [a[1] unsignedLongLongValue], v0 = [b[0] unsignedLongLongValue] ^ [b[1] unsignedLongLongValue];
        uint64_t u1 = [a[0] unsignedLongLongValue] ^ [a[2] unsignedLongLongValue], v1 = [b[0] unsignedLongLongValue] ^ [b[2] unsignedLongLongValue];
        uint64_t u2 = [a[2] unsignedLongLongValue] ^ [a[4] unsignedLongLongValue], v2 = [b[2] unsignedLongLongValue] ^ [b[4] unsignedLongLongValue];
        uint64_t u3 = [a[3] unsignedLongLongValue] ^ [a[4] unsignedLongLongValue], v3 = [b[3] unsignedLongLongValue] ^ [b[4] unsignedLongLongValue];
        
        [SecT283Field implMulw:(u1 ^ [a[3] unsignedLongLongValue]) withY:(v1 ^ [b[3] unsignedLongLongValue]) withZ:p withZoff:18]; // m10
        [SecT283Field implMulw:(u2 ^ [a[1] unsignedLongLongValue]) withY:(v2 ^ [b[1] unsignedLongLongValue]) withZ:p withZoff:20]; // m11
        
        uint64_t A4 = u0 ^ u3  , B4 = v0 ^ v3;
        uint64_t A5 = A4 ^ [a[2] unsignedLongLongValue], B5 = B4 ^ [b[2] unsignedLongLongValue];
        
        [SecT283Field implMulw:A4 withY:B4 withZ:p withZoff:22]; // m12
        [SecT283Field implMulw:A5 withY:B5 withZ:p withZoff:24]; // m13
        
        [SecT283Field implMulw:u0 withY:v0 withZ:p withZoff:10]; // m6
        [SecT283Field implMulw:u1 withY:v1 withZ:p withZoff:12]; // m7
        [SecT283Field implMulw:u2 withY:v2 withZ:p withZoff:14]; // m8
        [SecT283Field implMulw:u3 withY:v3 withZ:p withZoff:16]; // m9
        
        
        // Original method, corresponding to formula (16)
        // [SecT283Field addMs:zz withZoff:0 withP:p withMs:1];
        // [SecT283Field addMs:zz withZoff:1 withP:p withMs:1, 2, 6];
        // [SecT283Field addMs:zz withZoff:2 withP:p withMs:1, 2, 3, 7];
        // [SecT283Field addMs:zz withZoff:3 withP:p withMs:1, 3, 4, 5, 8, 10, 12, 13];
        // [SecT283Field addMs:zz withZoff:4 withP:p withMs:1, 2, 4, 5, 6, 9, 10, 11, 13];
        // [SecT283Field addMs:zz withZoff:5 withP:p withMs:1, 2, 3, 5, 7, 11, 12, 13];
        // [SecT283Field addMs:zz withZoff:6 withP:p withMs:3, 4, 5, 8];
        // [SecT283Field addMs:zz withZoff:7 withP:p withMs:4, 5, 9];
        // [SecT283Field addMs:zz withZoff:8 withP:p withMs:5];
        
        // Improved method factors out common single-word terms
        // NOTE: p1,...,p26 in the paper maps to p[0],...,p[25] here
        
        zz[0] = p[0];
        zz[9] = p[9];
        
        uint64_t t1 = [p[0] unsignedLongLongValue] ^ [p[1] unsignedLongLongValue];
        uint64_t t2 = t1 ^ [p[2] unsignedLongLongValue];
        uint64_t t3 = t2 ^ [p[10] unsignedLongLongValue];
        
        zz[1] = @(t3);
        
        uint64_t t4 = [p[3] unsignedLongLongValue] ^ [p[4] unsignedLongLongValue];
        uint64_t t5 = [p[11] unsignedLongLongValue] ^ [p[12] unsignedLongLongValue];
        uint64_t t6 = t4 ^ t5;
        uint64_t t7 = t2 ^ t6;
        
        zz[2] = @(t7);
        
        uint64_t t8 = t1 ^ t4;
        uint64_t t9 = [p[5] unsignedLongLongValue] ^ [p[6] unsignedLongLongValue];
        uint64_t t10 = t8 ^ t9;
        uint64_t t11 = t10 ^ [p[8] unsignedLongLongValue];
        uint64_t t12 = [p[13] unsignedLongLongValue] ^ [p[14] unsignedLongLongValue];
        uint64_t t13 = t11 ^ t12;
        uint64_t t14 = [p[18] unsignedLongLongValue] ^ [p[22] unsignedLongLongValue];
        uint64_t t15 = t14 ^ [p[24] unsignedLongLongValue];
        uint64_t t16 = t13 ^ t15;
        
        zz[3] = @(t16);
        
        uint64_t t17 = [p[7] unsignedLongLongValue] ^ [p[8] unsignedLongLongValue];
        uint64_t t18 = t17 ^ [p[9] unsignedLongLongValue];
        uint64_t t19 = t18 ^ [p[17] unsignedLongLongValue];
        
        zz[8] = @(t19);
        
        uint64_t t20 = t18 ^ t9;
        uint64_t t21 = [p[15] unsignedLongLongValue] ^ [p[16] unsignedLongLongValue];
        uint64_t t22 = t20 ^ t21;
        
        zz[7] = @(t22);
        
        uint64_t t23 = t22 ^ t3;
        uint64_t t24 = [p[19] unsignedLongLongValue] ^ [p[20] unsignedLongLongValue];
        // uint64_t t25 = [p[23] unsignedLongLongValue] ^ [p[24] unsignedLongLongValue];
        uint64_t t25 = [p[25] unsignedLongLongValue] ^ [p[24] unsignedLongLongValue]; // Fixes an error in the paper: p[23] -> p{25]
        uint64_t t26 = [p[18] unsignedLongLongValue] ^ [p[23] unsignedLongLongValue];
        uint64_t t27 = t24 ^ t25;
        uint64_t t28 = t27 ^ t26;
        uint64_t t29 = t28 ^ t23;
        
        zz[4] = @(t29);
        
        uint64_t t30 = t7 ^ t19;
        uint64_t t31 = t27 ^ t30;
        uint64_t t32 = [p[21] unsignedLongLongValue] ^ [p[22] unsignedLongLongValue];
        uint64_t t33 = t31 ^ t32;
        
        zz[5] = @(t33);
        
        uint64_t t34 = t11 ^ [p[0] unsignedLongLongValue];
        uint64_t t35 = t34 ^ [p[9] unsignedLongLongValue];
        uint64_t t36 = t35 ^ t12;
        uint64_t t37 = t36 ^ [p[21] unsignedLongLongValue];
        uint64_t t38 = t37 ^ [p[23] unsignedLongLongValue];
        uint64_t t39 = t38 ^ [p[25] unsignedLongLongValue];
        
        zz[6] = @(t39);
        
#if !__has_feature(objc_arc)
        if (a != nil) [a release]; a = nil;
        if (b != nil) [b release]; b = nil;
        if (p != nil) [p release]; p = nil;
#endif
        
        [SecT283Field implCompactExt:zz];
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
        uint64_t g, h = 0, l = [u[j & 7] unsignedLongLongValue];
        int k = 48;
        do {
            j  = (uint)(x >> k);
            g  = [u[j & 7] unsignedLongLongValue] ^ [u[(j >> 3) & 7] unsignedLongLongValue] << 3 ^ [u[(j >> 6) & 7] unsignedLongLongValue] << 6;
            l ^= (g <<  k);
            h ^= (g >> -k);
        } while ((k -= 9) > 0);
        
        h ^= ((x & 0x0100804020100800L) & (uint64_t)(((int64_t)y << 7) >> 63)) >> 8;
        
#if !__has_feature(objc_arc)
        if (u != nil) [u release]; u = nil;
#endif
        z[zOff] = @(l & M57);
        z[zOff + 1] = @((l >> 57) ^ (h << 7));
    }
}

// NSMutableArray == uint64_t[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        for (int i = 0; i < 4; ++i) {
            [Interleave expand64To128:[x[i] unsignedLongLongValue] withZ:zz withZ0ff:(i << 1)];
        }
        zz[8] = @([Interleave expand32to64:(uint)[x[4] unsignedLongLongValue]]);
    }
}

@end

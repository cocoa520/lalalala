//
//  SecT571Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT571Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat576.h"
#import "Nat.h"
#import "Interleave.h"

@implementation SecT571Field

static const uint64_t M59 = UINT64_MAX >> 5;
static const uint64_t RM = 0xEF7BDEF7BDEF7BDEUL;

// return == uint64_t[]
+ (NSMutableArray*)ROOT_Z {
    static NSMutableArray *_root_z = nil;
    @synchronized(self) {
        if (_root_z == nil) {
            @autoreleasepool {
                _root_z = [@[@((uint64_t)0x2BE1195F08CAFB99ULL), @((uint64_t)0x95F08CAF84657C23ULL), @((uint64_t)0xCAF84657C232BE11ULL), @((uint64_t)0x657C232BE1195F08ULL), @((uint64_t)0xF84657C2308CAF84ULL), @((uint64_t)0x7C232BE1195F08CAULL), @((uint64_t)0xBE1195F08CAF8465ULL), @((uint64_t)0x5F08CAF84657C232ULL), @((uint64_t)0x784657C232BE119ULL)] mutableCopy];
            }
        }
    }
    return _root_z;
}

// NSMutableArray == uint64_t[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        for (int i = 0; i < 9; ++i) {
            z[i] = @([x[i] unsignedLongLongValue] ^ [y[i] unsignedLongLongValue]);
        }
    }
}

// NSMutableArray == uint64_t[]
+ (void)add:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        for (int i = 0; i < 9; ++i) {
            z[zOff + i] = @([x[xOff + i] unsignedLongLongValue] ^ [y[yOff + i] unsignedLongLongValue]);
        }
    }
}

// NSMutableArray == uint64_t[]
+ (void)addBothTo:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        for (int i = 0; i < 9; ++i) {
            z[zOff + i] = @([z[zOff + i] unsignedLongLongValue] ^ ([x[xOff + i] unsignedLongLongValue] ^ [y[yOff + i] unsignedLongLongValue]));
        }
    }
}

// NSMutableArray == uint64_t[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        for (int i = 0; i < 18; ++i) {
            zz[i] = @([xx[i] unsignedLongLongValue] ^ [yy[i] unsignedLongLongValue]);
        }
    }
}

// NSMutableArray == uint64_t[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ 1ULL);
        for (int i = 1; i < 9; ++i) {
            z[i] = x[i];
        }
    }
}

// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat576 fromBigInteger64:x];
    [SecT571Field reduce5:z withZoff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat576 isZero64:x]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
    }
    
    @autoreleasepool {
        // Itoh-Tsujii inversion with bases { 2, 3, 5 }
        
        NSMutableArray *t0 = [Nat576 create64];
        NSMutableArray *t1 = [Nat576 create64];
        NSMutableArray *t2 = [Nat576 create64];
        
        [SecT571Field square:x withZ:t2];
        
        // 5 | 570
        [SecT571Field square:t2 withZ:t0];
        [SecT571Field square:t0 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        [SecT571Field squareN:t0 withN:2 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        [SecT571Field multiply:t0 withY:t2 withZ:t0];
        
        // 3 | 114
        [SecT571Field squareN:t0 withN:5 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        [SecT571Field squareN:t1 withN:5 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        
        // 2 | 38
        [SecT571Field squareN:t0 withN:15 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t2];
        
        // ! {2,3,5} | 19
        [SecT571Field squareN:t2 withN:30 withZ:t0];
        [SecT571Field squareN:t0 withN:30 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        
        // 3 | 9
        [SecT571Field squareN:t0 withN:60 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        [SecT571Field squareN:t1 withN:60 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        
        // 3 | 3
        [SecT571Field squareN:t0 withN:180 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        [SecT571Field squareN:t1 withN:180 withZ:t1];
        [SecT571Field multiply:t0 withY:t1 withZ:t0];
        
        [SecT571Field multiply:t0 withY:t2 withZ:z];
        
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
        NSMutableArray *tt = [Nat576 createExt64];
        [SecT571Field implMultiply:x withY:y withZZ:tt];
        [SecT571Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat576 createExt64];
        [SecT571Field implMultiply:x withY:y withZZ:tt];
        [SecT571Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t xx09 = [xx[9] unsignedLongLongValue];
        uint64_t u = [xx[17] unsignedLongLongValue], v = xx09;
        
        xx09 = v ^ (u >> 59) ^ (u >> 57) ^ (u >> 54) ^ (u >> 49);
        v = [xx[8] unsignedLongLongValue] ^ (u <<  5) ^ (u <<  7) ^ (u << 10) ^ (u << 15);
        
        for (int i = 16; i >= 10; --i) {
            u = [xx[i] unsignedLongLongValue];
            z[i - 8] = @(v ^ (u >> 59) ^ (u >> 57) ^ (u >> 54) ^ (u >> 49));
            v = [xx[i - 9] unsignedLongLongValue] ^ (u <<  5) ^ (u <<  7) ^ (u << 10) ^ (u << 15);
        }
        
        u = xx09;
        z[1] = @(v ^ (u >> 59) ^ (u >> 57) ^ (u >> 54) ^ (u >> 49));
        v = [xx[0] unsignedLongLongValue] ^ (u <<  5) ^ (u <<  7) ^ (u << 10) ^ (u << 15);
        
        uint64_t x08 = [z[8] unsignedLongLongValue];
        uint64_t t = x08 >> 59;
        z[0] = @(v ^ t ^ (t << 2) ^ (t << 5) ^ (t << 10));
        z[8] = @(x08 & M59);
    }
}

// NSMutableArray == uint64_t[]
+ (void)reduce5:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        uint64_t z8 = [z[zOff + 8] unsignedLongLongValue], t = z8 >> 59;
        z[zOff] = @([z[zOff] unsignedLongLongValue] ^ (t ^ (t << 2) ^ (t << 5) ^ (t << 10)));
        z[zOff + 8] = @(z8 & M59);
    }
}

// NSMutableArray == uint64_t[]
+ (void)sqrt:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *evn = [Nat576 create64], *odd = [Nat576 create64];
        int pos = 0;
        for (int i = 0; i < 4; ++i) {
            uint64_t u0 = [Interleave unshuffle:[x[pos++] unsignedLongLongValue]];
            uint64_t u1 = [Interleave unshuffle:[x[pos++] unsignedLongLongValue]];
            evn[i] = @((u0 & 0x00000000FFFFFFFFUL) | (u1 << 32));
            odd[i] = @((u0 >> 32) | (u1 & 0xFFFFFFFF00000000UL));
        }
        {
            uint64_t u0 = [Interleave unshuffle:[x[pos] unsignedLongLongValue]];
            evn[4] = @(u0 & 0x00000000FFFFFFFFUL);
            odd[4] = @(u0 >> 32);
        }
        
        [SecT571Field multiply:odd withY:[SecT571Field ROOT_Z] withZ:z];
        [SecT571Field add:z withY:evn withZ:z];
        
#if !__has_feature(objc_arc)
        if (evn) [evn release]; evn = nil;
        if (odd) [odd release]; odd = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat576 createExt64];
        [SecT571Field implSquare:x withZZ:tt];
        [SecT571Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        NSMutableArray *tt = [Nat576 createExt64];
        [SecT571Field implSquare:x withZZ:tt];
        [SecT571Field addExt:zz withYY:tt withZZ:zz];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat576 createExt64];
        [SecT571Field implSquare:x withZZ:tt];
        [SecT571Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecT571Field implSquare:z withZZ:tt];
            [SecT571Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (uint)trace:(NSMutableArray*)x {
    // Non-zero-trace bits: 0, 561, 569
    return (uint)([x[0] unsignedLongLongValue] ^ ([x[8] unsignedLongLongValue] >> 49) ^ ([x[8] unsignedLongLongValue] >> 57)) & 1U;
}

// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        //for (int i = 0; i < 9; ++i) {
        //    [SecT571Field implMulwAcc:x withY:[y[i] unsignedLongLongValue] withZ:zz withZoff:i];
        //}
        
        /*
         * Precompute table of all 4-bit products of y
         */
        NSMutableArray *T0 = [[NSMutableArray alloc] initWithSize:(9 << 4)];
        
        [T0 copyFromIndex:9 withSource:y withSourceIndex:0 withLength:9];
        // [SecT571Field reduce5:T0 withZoff:9];
        int tOff = 0;
        for (int i = 7; i > 0; --i) {
            tOff += 18;
            [Nat shiftUpBit64:9 withX:T0 withXoff:(tOff >> 1) withC:0UL withZ:T0 withZoff:tOff];
            [SecT571Field reduce5:T0 withZoff:tOff];
            [SecT571Field add:T0 withXoff:9 withY:T0 withYoff:tOff withZ:T0 withZoff:(tOff + 9)];
        }
        
        /*
         * Second table with all 4-bit products of B shifted 4 bits
         */
        NSMutableArray *T1 = [[NSMutableArray alloc] initWithSize:(int)(T0.count)];
        [Nat shiftUpBits64:(int)(T0.count) withX:T0 withXoff:0 withBits:4 withC:0L withZ:T1 withZoff:0];
        
        uint MASK = 0xF;
        
        /*
         * Lopez-Dahab algorithm
         */
        for (int k = 56; k >= 0; k -= 8) {
            for (int j = 1; j < 9; j += 2) {
                uint aVal = (uint)([x[j] unsignedLongLongValue] >> k);
                uint u = aVal & MASK;
                uint v = (aVal >> 4) & MASK;
                [SecT571Field addBothTo:T0 withXoff:(int)(9 * u) withY:T1 withYoff:(int)(9 * v) withZ:zz withZoff:(j - 1)];
            }
            [Nat shiftUpBits64:16 withZ:zz withZoff:0 withBits:8 withC:0L];
        }
        
        for (int k = 56; k >= 0; k -= 8) {
            for (int j = 0; j < 9; j += 2) {
                uint aVal = (uint)([x[j] unsignedLongLongValue] >> k);
                uint u = aVal & MASK;
                uint v = (aVal >> 4) & MASK;
                [SecT571Field addBothTo:T0 withXoff:(int)(9 * u) withY:T1 withYoff:(int)(9 * v) withZ:zz withZoff:j];
            }
            if (k > 0) {
                [Nat shiftUpBits64:18 withZ:zz withZoff:0 withBits:8 withC:0L];
            }
        }
        
#if !__has_feature(objc_arc)
        if (T0 != nil) [T0 release]; T0 = nil;
        if (T1 != nil) [T1 release]; T1 = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)implMulwAcc:(NSMutableArray*)xs withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        NSMutableArray *u = [[NSMutableArray alloc] initWithSize:32];
        //u[0] = 0;
        u[1] = @(y);
        for (int i = 2; i < 32; i += 2) {
            u[i] = @([u[i >> 1] unsignedLongLongValue] << 1);
            u[i + 1] = @([u[i] unsignedLongLongValue] ^  y);
        }
        
        uint64_t l = 0;
        for (int i = 0; i < 9; ++i) {
            uint64_t x = [xs[i] unsignedLongLongValue];
            
            uint j = (uint)x;
            
            l ^= [u[j & 31] unsignedLongLongValue];
            
            uint64_t g, h = 0;
            int k = 60;
            do {
                j = (uint)(x >> k);
                g = [u[j & 31] unsignedLongLongValue];
                l ^= (g <<  k);
                h ^= (g >> -k);
            } while ((k -= 5) > 0);
            
            for (int p = 0; p < 4; ++p) {
                x = (x & RM) >> 1;
                h ^= x & (uint64_t)(((int64_t)y << p) >> 63);
            }
            
            z[zOff + i] = @([z[zOff + i] unsignedLongLongValue] ^ l);
            
            l = h;
        }
        z[zOff + 9] = @([z[zOff + 9] unsignedLongLongValue] ^ l);
#if !__has_feature(objc_arc)
        if (u != nil) [u release]; u = nil;
#endif
    }
}

// NSMutableArray == uint64_t[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    for (int i = 0; i < 9; ++i) {
        [Interleave expand64To128:[x[i] unsignedLongLongValue] withZ:zz withZ0ff:(i << 1)];
    }
}

@end

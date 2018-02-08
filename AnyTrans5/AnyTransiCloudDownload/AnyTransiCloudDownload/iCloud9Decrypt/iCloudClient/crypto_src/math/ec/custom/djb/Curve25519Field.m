//
//  Curve25519Field.m
//  
//
//  Created by Pallas on 5/25/16.
//
//  Complete

#import "Curve25519Field.h"
#import "BigInteger.h"
#import "Nat256.h"
#import "Nat.h"

@implementation Curve25519Field

// 2^255 - 2^4 - 2^1 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFFFED), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x7FFFFFFF)] mutableCopy];
            }
        }
    }
    return _p;
}

static uint const P7 = 0x7FFFFFFF;

// return == uint[]
+ (NSMutableArray*)PExt {
    static NSMutableArray *_pExt = nil;
    @synchronized(self) {
        if (_pExt == nil) {
            @autoreleasepool {
                _pExt = [@[@((uint)0x00000169), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFED), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x3FFFFFFF)] mutableCopy];
            }
        }
    }
    return _pExt;
}

static uint const PInv = 0x13;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        [Nat256 add:x withY:y withZ:z];
        if ([Nat256 gte:z withY:[Curve25519Field P]]) {
            [Curve25519Field subPFrom:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Nat add:16 withX:xx withY:yy withZ:zz];
        if ([Nat gte:16 withX:zz withY:[Curve25519Field PExt]]) {
            [Curve25519Field subPExtFrom:zz];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        [Nat inc:8 withX:x withZ:z];
        if ([Nat256 gte:z withY:[Curve25519Field P]]) {
            [Curve25519Field subPFrom:z];
        }
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = nil;
    @autoreleasepool {
        z = [Nat256 fromBigInteger:x];
        while ([Nat256 gte:z withY:[Curve25519Field P]]) {
            [Nat256 subFrom:[Curve25519Field P] withZ:z];
        }
        [z retain];
    }
    return (z ? [z autorelease] : nil);
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        if (([x[0] unsignedIntValue] & 1) == 0) {
            [Nat shiftDownBit:8 withX:x withC:0 withZ:z];
        } else {
            [Nat256 add:x withY:[Curve25519Field P] withZ:z];
            [Nat shiftDownBit:8 withZ:z withC:0];
        }
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt];
        [Nat256 mul:x withY:y withZZ:tt];
        [Curve25519Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Nat256 mulAddTo:x withY:y withZZ:zz];
        if ([Nat gte:16 withX:zz withY:[Curve25519Field PExt]]) {
            [Curve25519Field subPExtFrom:zz];
        }
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        if ([Nat256 isZero:x]) {
            [Nat256 zero:z];
        } else {
            [Nat256 sub:[Curve25519Field P] withY:x withZ:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint xx07 = [xx[7] unsignedIntValue];
        [Nat shiftUpBit:8 withX:xx withXoff:8 withC:xx07 withZ:z withZoff:0];
        uint c = [Nat256 mulByWordAddTo:PInv withY:xx withZ:z] << 1;
        uint z7 = [z[7] unsignedIntValue];
        c += (z7 >> 31) - (xx07 >> 31);
        z7 &= P7;
        z7 += [Nat addWordTo:7 withX:(c * PInv) withZ:z];
        z[7] = @(z7);
        if (z7 >= P7 && [Nat256 gte:z withY:[Curve25519Field P]]) {
            [Curve25519Field subPFrom:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)reduce27:(uint)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint z7 = [z[7] unsignedIntValue];
        uint c = (x << 1 | z7 >> 31);
        z7 &= P7;
        z7 += [Nat addWordTo:7 withX:(c * PInv) withZ:z];
        z[7] = @(z7);
        if (z7 >= P7 && [Nat256 gte:z withY:[Curve25519Field P]]) {
            [Curve25519Field subPFrom:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt];
        [Nat256 square:x withZZ:tt];
        [Curve25519Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt];
        [Nat256 square:x withZZ:tt];
        [Curve25519Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat256 square:z withZZ:tt];
            [Curve25519Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int c = [Nat256 sub:x withY:y withZ:z];
        if (c != 0) {
            [Curve25519Field addPTo:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        int c = [Nat sub:16 withX:xx withY:yy withZ:zz];
        if (c != 0) {
            [Curve25519Field addPExtTo:zz];
        }
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        [Nat shiftUpBit:8 withX:x withC:0 withZ:z];
        if ([Nat256 gte:z withY:[Curve25519Field P]]) {
            [Curve25519Field subPFrom:z];
        }
    }
}

// NSMutableArray == uint[]
+ (uint)addPTo:(NSMutableArray*)z {
    int64_t c = 0;
    @autoreleasepool {
        c = [z[0] longLongValue] - PInv;
        z[0] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c = [Nat decAt:7 withZ:z withZpos:1];
        }
        c += [z[7] longLongValue] + (P7 + 1);
        z[7] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)addPExtTo:(NSMutableArray*)zz {
    int64_t c = 0;
    @autoreleasepool {
        c = [zz[0] longLongValue] + [[Curve25519Field PExt][0] unsignedIntValue];
        zz[0] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c = [Nat incAt:8 withZ:zz withZpos:1];
        }
        c += [zz[8] longLongValue] - PInv;
        zz[8] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c = [Nat decAt:15 withZ:zz withZpos:9];
        }
        c += [zz[15] longLongValue] + ([[Curve25519Field PExt][15] unsignedIntValue] + 1);
        zz[15] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (int)subPFrom:(NSMutableArray*)z {
    int64_t c = 0;
    @autoreleasepool {
        c = [z[0] longLongValue] + PInv;
        z[0] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c = [Nat incAt:7 withZ:z withZpos:1];
        }
        c += [z[7] longLongValue] - (P7 + 1);
        z[7] = @((uint)c);
        c >>= 32;
    }
    return (int)c;
}

// NSMutableArray == uint[]
+ (int)subPExtFrom:(NSMutableArray*)zz {
    int64_t c = 0;
    @autoreleasepool {
        c = [zz[0] longLongValue] - [[Curve25519Field PExt][0] unsignedIntValue];
        zz[0] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c = [Nat decAt:8 withZ:zz withZpos:1];
        }
        c += [zz[8] longLongValue] + PInv;
        zz[8] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c = [Nat incAt:15 withZ:zz withZpos:9];
        }
        c += [zz[15] longLongValue] - ([[Curve25519Field PExt][15] unsignedIntValue] + 1);
        zz[15] = @((uint)c);
        c >>= 32;        
    }
    return (int)c;
}

@end

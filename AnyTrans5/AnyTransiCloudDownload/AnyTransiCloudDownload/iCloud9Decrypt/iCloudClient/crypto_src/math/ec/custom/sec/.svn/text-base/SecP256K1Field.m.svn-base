//
//  SecP256K1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP256K1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat256.h"
#import "Nat.h"

@implementation SecP256K1Field

// 2^256 - 2^32 - 2^9 - 2^8 - 2^7 - 2^6 - 2^4 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFFC2F), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
            }
        }
    }
    return _p;
}

// return == uint[]
+ (NSMutableArray*)PExt {
    static NSMutableArray *_pext = nil;
    @synchronized(self) {
        if (_pext == nil) {
            @autoreleasepool {
                _pext = [@[@((uint)0x000E90A1), @((uint)0x000007A2), @((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFF85E), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
            }
        }
    }
    return _pext;
}

// return == uint[]
+ (NSMutableArray*)PExtInv {
    static NSMutableArray *_pextinv = nil;
    @synchronized(self) {
        if (_pextinv == nil) {
            @autoreleasepool {
                _pextinv = [@[@((uint)0xFFF16F5F), @((uint)0xFFFFF85D), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x000007A1), @((uint)0x00000002)] mutableCopy];
            }
        }
    }
    return _pextinv;
}

static uint const P7 = 0xFFFFFFFF;
static uint const PExt15 = 0xFFFFFFFF;
static uint const PInv33 = 0x3D1;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat256 add:x withY:y withZ:z];
    if (c != 0 || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256K1Field P]])) {
        [Nat add33To:8 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat add:16 withX:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[15] unsignedIntValue] == PExt15 && [Nat gte:16 withX:zz withY:[SecP256K1Field PExt]])) {
        if ([Nat addTo:(int)([SecP256K1Field PExtInv].count) withX:[SecP256K1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:16 withZ:zz withZpos:(int)([SecP256K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:8 withX:x withZ:z];
    if (c != 0 || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256K1Field P]])) {
        [Nat add33To:8 withX:PInv33 withZ:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat256 fromBigInteger:x];
    if ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256K1Field P]]) {
        [Nat256 subFrom:[SecP256K1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:8 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat256 add:x withY:[SecP256K1Field P] withZ:z];
        [Nat shiftDownBit:8 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt];
        [Nat256 mul:x withY:y withZZ:tt];
        [SecP256K1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint c = [Nat256 mulAddTo:x withY:y withZZ:zz];
    if (c != 0 || ([zz[15] unsignedIntValue] == PExt15 && [Nat gte:16 withX:zz withY:[SecP256K1Field PExt]])) {
        if ([Nat addTo:(int)([SecP256K1Field PExtInv].count) withX:[SecP256K1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:16 withZ:zz withZpos:(int)([SecP256K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat256 isZero:x]) {
        [Nat256 zero:z];
    } else {
        [Nat256 sub:[SecP256K1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    uint64_t cc = [Nat256 mul33Add:PInv33 withX:xx withXoff:8 withY:xx withYoff:0 withZ:z withZoff:0];
    uint c = [Nat256 mul33DWordAdd:PInv33 withY:cc withZ:z withZoff:0];
    
    if (c != 0 || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256K1Field P]])) {
        [Nat add33To:8 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    if ((x != 0 && [Nat256 mul33WordAdd:PInv33 withY:x withZ:z withZoff:0] != 0) || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256K1Field P]])) {
        [Nat add33To:8 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt];
        [Nat256 square:x withZZ:tt];
        [SecP256K1Field reduce:tt withZ:z];
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
        [SecP256K1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat256 square:z withZZ:tt];
            [SecP256K1Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int c = [Nat256 sub:x withY:y withZ:z];
    if (c != 0) {
        [Nat sub33From:8 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:16 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        if ([Nat subFrom:(int)([SecP256K1Field PExtInv].count) withX:[SecP256K1Field PExtInv] withZ:zz] != 0) {
            [Nat decAt:16 withZ:zz withZpos:(int)([SecP256K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:8 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256K1Field P]])) {
        [Nat add33To:8 withX:PInv33 withZ:z];
    }
}

@end

//
//  SecP192K1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP192K1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat192.h"
#import "Nat.h"

@implementation SecP192K1Field

// 2^192 - 2^32 - 2^12 - 2^8 - 2^7 - 2^6 - 2^3 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFEE37), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pext = [@[@((uint)0x013C4FD1), @((uint)0x00002392), @((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFDC6E), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pextinv = [@[@((uint)0xFEC3B02F), @((uint)0xFFFFDC6D), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x00002391), @((uint)0x00000002)] mutableCopy];
            }
        }
    }
    return _pextinv;
}


static uint const P5 = 0xFFFFFFFF;
static uint const PExt11 = 0xFFFFFFFF;
static uint const PInv33 = 0x11C9;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat192 add:x withY:y withZ:z];
    if (c != 0 || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192K1Field P]])) {
        [Nat add33To:6 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat add:12 withX:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[11] unsignedIntValue] == PExt11 && [Nat gte:12 withX:zz withY:[SecP192K1Field PExt]])) {
        if ([Nat addTo:(int)([SecP192K1Field PExtInv].count) withX:[SecP192K1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:12 withZ:zz withZpos:(int)([SecP192K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:6 withX:x withZ:z];
    if (c != 0 || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192K1Field P]])) {
        [Nat add33To:6 withX:PInv33 withZ:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat192 fromBigInteger:x];
    if ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192K1Field P]]) {
        [Nat192 subFrom:[SecP192K1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:6 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat192 add:x withY:[SecP192K1Field P] withZ:z];
        [Nat shiftDownBit:6 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt];
        [Nat192 mul:x withY:y withZZ:tt];
        [SecP192K1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint c = [Nat192 mulAddTo:x withY:y withZZ:zz];
    if (c != 0 || ([zz[11] unsignedIntValue] == PExt11 && [Nat gte:12 withX:zz withY:[SecP192K1Field PExt]])) {
        if ([Nat addTo:(int)([SecP192K1Field PExtInv].count) withX:[SecP192K1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:12 withZ:zz withZpos:(int)([SecP192K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat192 isZero:x]) {
        [Nat192 zero:z];
    } else {
        [Nat192 sub:[SecP192K1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    uint64_t cc = [Nat192 mul33Add:PInv33 withX:xx withXoff:6 withY:xx withYoff:0 withZ:z withZoff:0];
    uint c = [Nat192 mul33DWordAdd:PInv33 withY:cc withZ:z withZoff:0];
    
    if (c != 0 || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192K1Field P]])) {
        [Nat add33To:6 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    if ((x != 0 && [Nat192 mul33WordAdd:PInv33 withY:x withZ:z withZoff:0] != 0) || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192K1Field P]])) {
        [Nat add33To:6 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt];
        [Nat192 square:x withZZ:tt];
        [SecP192K1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt];
        [Nat192 square:x withZZ:tt];
        [SecP192K1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat192 square:z withZZ:tt];
            [SecP192K1Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int c = [Nat192 sub:x withY:y withZ:z];
    if (c != 0) {
        [Nat sub33From:6 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:12 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        if ([Nat subFrom:(int)([SecP192K1Field PExtInv].count) withX:[SecP192K1Field PExtInv] withZ:zz] != 0) {
            [Nat decAt:12 withZ:zz withZpos:(int)([SecP192K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:6 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192K1Field P]])) {
        [Nat add33To:6 withX:PInv33 withZ:z];
    }
}

@end

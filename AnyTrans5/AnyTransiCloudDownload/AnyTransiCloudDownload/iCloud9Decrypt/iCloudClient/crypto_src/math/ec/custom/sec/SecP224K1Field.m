//
//  SecP224K1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP224K1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat224.h"
#import "Nat.h"

@implementation SecP224K1Field

// 2^224 - 2^32 - 2^12 - 2^11 - 2^9 - 2^7 - 2^4 - 2 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFE56D), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pext = [@[@((uint)0x02C23069), @((uint)0x00003526), @((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFCADA), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pextinv = [@[@((uint)0xFD3DCF97), @((uint)0xFFFFCAD9), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x00003525), @((uint)0x00000002)] mutableCopy];
            }
        }
    }
    return _pextinv;
}

static uint const P6 = 0xFFFFFFFF;
static uint const PExt13 = 0xFFFFFFFF;
static uint const PInv33 = 0x1A93;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat224 add:x withY:y withZ:z];
    if (c != 0 || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224K1Field P]])) {
        [Nat add33To:7 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat add:14 withX:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[13] unsignedIntValue] == PExt13 && [Nat gte:14 withX:zz withY:[SecP224K1Field PExt]])) {
        if ([Nat addTo:(int)([SecP224K1Field PExtInv].count) withX:[SecP224K1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:14 withZ:zz withZpos:(int)([SecP224K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:7 withX:x withZ:z];
    if (c != 0 || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224K1Field P]])) {
        [Nat add33To:7 withX:PInv33 withZ:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat224 fromBigInteger:x];
    if ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224K1Field P]]) {
        [Nat224 subFrom:[SecP224K1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:7 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat224 add:x withY:[SecP224K1Field P] withZ:z];
        [Nat shiftDownBit:7 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat224 createExt];
        [Nat224 mul:x withY:y withZZ:tt];
        [SecP224K1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint c = [Nat224 mulAddTo:x withY:y withZZ:zz];
    if (c != 0 || ([zz[13] unsignedIntValue] == PExt13 && [Nat gte:14 withX:zz withY:[SecP224K1Field PExt]])) {
        if ([Nat addTo:(int)([SecP224K1Field PExtInv].count) withX:[SecP224K1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:14 withZ:zz withZpos:(int)([SecP224K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat224 isZero:x]) {
        [Nat224 zero:z];
    } else {
        [Nat224 sub:[SecP224K1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    uint64_t cc = [Nat224 mul33Add:PInv33 withX:xx withXoff:7 withY:xx withYoff:0 withZ:z withZoff:0];
    uint c = [Nat224 mul33DWordAdd:PInv33 withY:cc withZ:z withZoff:0];
    
    if (c != 0 || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224K1Field P]])) {
        [Nat add33To:7 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    if ((x != 0 && [Nat224 mul33WordAdd:PInv33 withY:x withZ:z withZoff:0] != 0) || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224K1Field P]])) {
        [Nat add33To:7 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat224 createExt];
        [Nat224 square:x withZZ:tt];
        [SecP224K1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat224 createExt];
        [Nat224 square:x withZZ:tt];
        [SecP224K1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat224 square:z withZZ:tt];
            [SecP224K1Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int c = [Nat224 sub:x withY:y withZ:z];
    if (c != 0) {
        [Nat sub33From:7 withX:PInv33 withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:14 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        if ([Nat subFrom:(int)([SecP224K1Field PExtInv].count) withX:[SecP224K1Field PExtInv] withZ:zz] != 0) {
            [Nat decAt:14 withZ:zz withZpos:(int)([SecP224K1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:7 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224K1Field P]])) {
        [Nat add33To:7 withX:PInv33 withZ:z];
    }
}

@end

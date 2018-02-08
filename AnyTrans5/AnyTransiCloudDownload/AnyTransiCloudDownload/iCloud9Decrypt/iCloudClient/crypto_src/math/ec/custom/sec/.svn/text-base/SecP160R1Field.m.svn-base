//
//  SecP160R1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP160R1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat160.h"
#import "Nat.h"

@implementation SecP160R1Field

// 2^160 - 2^31 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0x7FFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pext = [@[@((uint)0x00000001), @((uint)0x40000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pextinv = [@[@((uint)0xFFFFFFFF), @((uint)0xBFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x00000001), @((uint)0x00000001)] mutableCopy];
            }
        }
    }
    return _pextinv;
}

static uint const P4 = 0xFFFFFFFF;
static uint const PExt9 = 0xFFFFFFFF;
static uint const PInv = 0x80000001;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat160 add:x withY:y withZ:z];
    if (c != 0 || ([z[4] unsignedIntValue] == P4 && [Nat160 gte:z withY:[SecP160R1Field P]])) {
        [Nat addWordTo:5 withX:PInv withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat add:10 withX:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[9] unsignedIntValue] == PExt9 && [Nat gte:10 withX:zz withY:[SecP160R1Field PExt]])) {
        if ([Nat addTo:(int)([SecP160R1Field PExtInv].count) withX:[SecP160R1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:10 withZ:zz withZpos:(int)([SecP160R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:5 withX:x withZ:z];
    if (c != 0 || ([z[4] unsignedIntValue] == P4 && [Nat160 gte:z withY:[SecP160R1Field P]])) {
        [Nat addWordTo:5 withX:PInv withZ:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat160 fromBigInteger:x];
    if ([z[4] unsignedIntValue] == P4 && [Nat160 gte:z withY:[SecP160R1Field P]]) {
        [Nat160 subFrom:[SecP160R1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:5 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat160 add:x withY:[SecP160R1Field P] withZ:z];
        [Nat shiftDownBit:5 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat160 createExt];
        [Nat160 mul:x withY:y withZZ:tt];
        [SecP160R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint c = [Nat160 mulAddTo:x withY:y withZZ:zz];
    if (c != 0 || ([zz[9] unsignedIntValue] == PExt9 && [Nat gte:10 withX:zz withY:[SecP160R1Field PExt]])) {
        if ([Nat addTo:(int)([SecP160R1Field PExtInv].count) withX:[SecP160R1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:10 withZ:zz withZpos:(int)([SecP160R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat160 isZero:x]) {
        [Nat160 zero:z];
    } else {
        [Nat160 sub:[SecP160R1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x5 = [xx[5] unsignedLongLongValue], x6 = [xx[6] unsignedLongLongValue], x7 = [xx[7] unsignedLongLongValue], x8 = [xx[8] unsignedLongLongValue], x9 = [xx[9] unsignedLongLongValue];
        
        uint64_t c = 0;
        c += [xx[0] unsignedLongLongValue] + x5 + (x5 << 31);
        z[0] = @((uint)c); c >>= 32;
        c += [xx[1] unsignedLongLongValue] + x6 + (x6 << 31);
        z[1] = @((uint)c); c >>= 32;
        c += [xx[2] unsignedLongLongValue] + x7 + (x7 << 31);
        z[2] = @((uint)c); c >>= 32;
        c += [xx[3] unsignedLongLongValue] + x8 + (x8 << 31);
        z[3] = @((uint)c); c >>= 32;
        c += [xx[4] unsignedLongLongValue] + x9 + (x9 << 31);
        z[4] = @((uint)c); c >>= 32;
        
        [SecP160R1Field reduce32:(uint)c withZ:z];        
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    if ((x != 0 && [Nat160 mulWordsAdd:PInv withY:x withZ:z withZoff:0] != 0) || ([z[4] unsignedIntValue] == P4 && [Nat160 gte:z withY:[SecP160R1Field P]])) {
        [Nat addWordTo:5 withX:PInv withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat160 createExt];
        [Nat160 square:x withZZ:tt];
        [SecP160R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat160 createExt];
        [Nat160 square:x withZZ:tt];
        [SecP160R1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat160 square:z withZZ:tt];
            [SecP160R1Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int c = [Nat160 sub:x withY:y withZ:z];
    if (c != 0) {
        [Nat subWordFrom:5 withX:PInv withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:10 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        if ([Nat subFrom:(int)([SecP160R1Field PExtInv].count) withX:[SecP160R1Field PExtInv] withZ:zz] != 0) {
            [Nat decAt:10 withZ:zz withZpos:(int)([SecP160R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:5 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[4] unsignedIntValue] == P4 && [Nat160 gte:z withY:[SecP160R1Field P]])) {
        [Nat addWordTo:5 withX:PInv withZ:z];
    }
}

@end

//
//  SecP128R1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP128R1Field.h"
#import "Nat128.h"
#import "Nat256.h"
#import "Nat.h"

@implementation SecP128R1Field

// 2^128 - 2^97 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFD)] mutableCopy];
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
                _pext = [@[@((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000004), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0x00000003), @((uint)0xFFFFFFFC)] mutableCopy];
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
                _pextinv = [@[@((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFB), @((uint)0x00000001), @((uint)0x00000000), @((uint)0xFFFFFFFC), @((uint)0x00000003)] mutableCopy];
            }
        }
    }
    return _pextinv;
}

static uint const P3 = 0xFFFFFFFD;
static uint const PExt7 = 0xFFFFFFFC;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat128 add:x withY:y withZ:z];
    if (c != 0 || ([z[3] unsignedIntValue] == P3 && [Nat128 gte:z withY:[SecP128R1Field P]])) {
        [SecP128R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat256 add:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[7] unsignedIntValue] == PExt7 && [Nat256 gte:zz withY:[SecP128R1Field PExt]])) {
        [Nat addTo:(int)([SecP128R1Field PExtInv].count) withX:[SecP128R1Field PExtInv] withZ:zz];
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:4 withX:x withZ:z];
    if (c != 0 || ([z[3] unsignedIntValue] == P3 && [Nat128 gte:z withY:[SecP128R1Field P]])) {
        [SecP128R1Field addPInvTo:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat128 fromBigInteger:x];
    if ([z[3] unsignedIntValue] == P3 && [Nat128 gte:z withY:[SecP128R1Field P]]) {
        [Nat128 subFrom:[SecP128R1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:4 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat128 add:x withY:[SecP128R1Field P] withZ:z];
        [Nat shiftDownBit:4 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat128 createExt];
        [Nat128 mul:x withY:y withZZ:tt];
        [SecP128R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint c = [Nat128 mulAddTo:x withY:y withZZ:zz];
    if (c != 0 || ([zz[7] unsignedIntValue] == PExt7 && [Nat256 gte:zz withY:[SecP128R1Field PExt]])) {
        [Nat addTo:(int)([SecP128R1Field PExtInv].count) withX:[SecP128R1Field PExtInv] withZ:zz];
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat128 isZero:x]) {
        [Nat128 zero:z];
    } else {
        [Nat128 sub:[SecP128R1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t x0 = [xx[0] unsignedLongLongValue], x1 = [xx[1] unsignedLongLongValue], x2 = [xx[2] unsignedLongLongValue], x3 = [xx[3] unsignedLongLongValue];
        uint64_t x4 = [xx[4] unsignedLongLongValue], x5 = [xx[5] unsignedLongLongValue], x6 = [xx[6] unsignedLongLongValue], x7 = [xx[7] unsignedLongLongValue];
        
        x3 += x7; x6 += (x7 << 1);
        x2 += x6; x5 += (x6 << 1);
        x1 += x5; x4 += (x5 << 1);
        x0 += x4; x3 += (x4 << 1);
        
        z[0] = @((uint)x0); x1 += (x0 >> 32);
        z[1] = @((uint)x1); x2 += (x1 >> 32);
        z[2] = @((uint)x2); x3 += (x2 >> 32);
        z[3] = @((uint)x3);
        
        [SecP128R1Field reduce32:(uint)(x3 >> 32) withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        while (x != 0) {
            uint64_t c, x4 = x;
            
            c = [z[0] unsignedLongLongValue] + x4;
            z[0] = @((uint)c); c >>= 32;
            if (c != 0) {
                c += [z[1] unsignedLongLongValue];
                z[1] = @((uint)c); c >>= 32;
                c += [z[2] unsignedLongLongValue];
                z[2] = @((uint)c); c >>= 32;
            }
            c += [z[3] unsignedLongLongValue] + (x4 << 1);
            z[3] = @((uint)c); c >>= 32;
            
            x = (uint)c;
        }
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat128 createExt];
        [Nat128 square:x withZZ:tt];
        [SecP128R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat128 createExt];
        [Nat128 square:x withZZ:tt];
        [SecP128R1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat128 square:z withZZ:tt];
            [SecP128R1Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int c = [Nat128 sub:x withY:y withZ:z];
    if (c != 0) {
        [SecP128R1Field subPInvFrom:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:10 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        [Nat subFrom:(int)([SecP128R1Field PExtInv].count) withX:[SecP128R1Field PExtInv] withZ:zz];
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:4 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[3] unsignedIntValue] == P3 && [Nat128 gte:z withY:[SecP128R1Field P]])) {
        [SecP128R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addPInvTo:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] + 1;
        z[0] = @((uint)c); c >>= 32;
        if (c != 0) {
            c += [z[1] longLongValue];
            z[1] = @((uint)c); c >>= 32;
            c += [z[2] longLongValue];
            z[2] = @((uint)c); c >>= 32;
        }
        c += [z[3] longLongValue] + 2;
        z[3] = @((uint)c);
    }
}

// NSMutableArray == uint[]
+ (void)subPInvFrom:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] - 1;
        z[0] = @((uint)c); c >>= 32;
        if (c != 0) {
            c += [z[1] longLongValue];
            z[1] = @((uint)c); c >>= 32;
            c += [z[2] longLongValue];
            z[2] = @((uint)c); c >>= 32;
        }
        c += [z[3] longLongValue] - 2;
        z[3] = @((uint)c);
    }
}

@end

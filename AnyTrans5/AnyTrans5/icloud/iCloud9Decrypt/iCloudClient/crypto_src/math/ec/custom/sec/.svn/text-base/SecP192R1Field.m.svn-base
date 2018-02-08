//
//  SecP192R1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP192R1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat192.h"
#import "Nat.h"

@implementation SecP192R1Field

// 2^192 - 2^64 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pext = [@[@((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000002), @((uint)0x00000000), @((uint)0x00000001), @((uint)0x00000000), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pextinv = [@[@((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000002)] mutableCopy];
            }
        }
    }
    return _pextinv;
}

static uint const P5 = 0xFFFFFFFF;
static uint const PExt11 = 0xFFFFFFFF;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat192 add:x withY:y withZ:z];
    if (c != 0 || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192R1Field P]])) {
        [SecP192R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat add:12 withX:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[11] unsignedIntValue] == PExt11 && [Nat gte:12 withX:zz withY:[SecP192R1Field PExt]])) {
        if ([Nat addTo:(int)([SecP192R1Field PExtInv].count) withX:[SecP192R1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:12 withZ:zz withZpos:(int)([SecP192R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:6 withX:x withZ:z];
    if (c != 0 || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192R1Field P]])) {
        [SecP192R1Field addPInvTo:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat192 fromBigInteger:x];
    if ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192R1Field P]]) {
        [Nat192 subFrom:[SecP192R1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:6 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat192 add:x withY:[SecP192R1Field P] withZ:z];
        [Nat shiftDownBit:6 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt];
        [Nat192 mul:x withY:y withZZ:tt];
        [SecP192R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif        
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint c = [Nat192 mulAddTo:x withY:y withZZ:zz];
    if (c != 0 || ([zz[11] unsignedIntValue] == PExt11 && [Nat gte:12 withX:zz withY:[SecP192R1Field PExt]])) {
        if ([Nat addTo:(int)([SecP192R1Field PExtInv].count) withX:[SecP192R1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:12 withZ:zz withZpos:(int)([SecP192R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat192 isZero:x]) {
        [Nat192 zero:z];
    } else {
        [Nat192 sub:[SecP192R1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t xx06 = [xx[6] unsignedLongLongValue], xx07 = [xx[7] unsignedLongLongValue], xx08 = [xx[8] unsignedLongLongValue];
        uint64_t xx09 = [xx[9] unsignedLongLongValue], xx10 = [xx[10] unsignedLongLongValue], xx11 = [xx[11] unsignedLongLongValue];
        
        uint64_t t0 = xx06 + xx10;
        uint64_t t1 = xx07 + xx11;
        
        uint64_t cc = 0;
        cc += [xx[0] unsignedLongLongValue] + t0;
        uint z0 = (uint)cc;
        cc >>= 32;
        cc += [xx[1] unsignedLongLongValue] + t1;
        z[1] = @((uint)cc);
        cc >>= 32;
        
        t0 += xx08;
        t1 += xx09;
        
        cc += [xx[2] unsignedLongLongValue] + t0;
        uint64_t z2 = (uint)cc;
        cc >>= 32;
        cc += [xx[3] unsignedLongLongValue] + t1;
        z[3] = @((uint)cc);
        cc >>= 32;
        
        t0 -= xx06;
        t1 -= xx07;
        
        cc += [xx[4] unsignedLongLongValue] + t0;
        z[4] = @((uint)cc);
        cc >>= 32;
        cc += [xx[5] unsignedLongLongValue] + t1;
        z[5] = @((uint)cc);
        cc >>= 32;
        
        z2 += cc;
        
        cc += z0;
        z[0] = @((uint)cc);
        cc >>= 32;
        if (cc != 0) {
            cc += [z[1] unsignedIntValue];
            z[1] = @((uint)cc);
            z2 += cc >> 32;
        }
        z[2] = @((uint)z2);
        cc  = z2 >> 32;
        
        if ((cc != 0 && [Nat incAt:6 withZ:z withZpos:3] != 0) || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192R1Field P]])) {
            [SecP192R1Field addPInvTo:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint64_t cc = 0;
        
        if (x != 0) {
            cc += [z[0] unsignedLongLongValue] + x;
            z[0] = @((uint)cc);
            cc >>= 32;
            if (cc != 0) {
                cc += [z[1] unsignedLongLongValue];
                z[1] = @((uint)cc);
                cc >>= 32;
            }
            cc += [z[2] unsignedLongLongValue] + x;
            z[2] = @((uint)cc);
            cc >>= 32;
        }
        
        if ((cc != 0 && [Nat incAt:6 withZ:z withZpos:3] != 0) || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192R1Field P]])) {
            [SecP192R1Field addPInvTo:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat192 createExt];
        [Nat192 square:x withZZ:tt];
        [SecP192R1Field reduce:tt withZ:z];
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
        [SecP192R1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat192 square:z withZZ:tt];
            [SecP192R1Field reduce:tt withZ:z];
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
        [SecP192R1Field subPInvFrom:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:12 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        if ([Nat subFrom:(int)([SecP192R1Field PExtInv].count) withX:[SecP192R1Field PExtInv] withZ:zz] != 0) {
            [Nat decAt:12 withZ:zz withZpos:(int)([SecP192R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:6 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[5] unsignedIntValue] == P5 && [Nat192 gte:z withY:[SecP192R1Field P]])) {
        [SecP192R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addPInvTo:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] + 1;
        z[0] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c += [z[1] longLongValue];
            z[1] = @((uint)c);
            c >>= 32;
        }
        c += [z[2] longLongValue] + 1;
        z[2] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            [Nat incAt:6 withZ:z withZpos:3];
        }
    }
}

// NSMutableArray == uint[]
+ (void)subPInvFrom:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] - 1;
        z[0] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c += [z[1] longLongValue];
            z[1] = @((uint)c);
            c >>= 32;
        }
        c += [z[2] longLongValue] - 1;
        z[2] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            [Nat decAt:6 withZ:z withZpos:3];
        }
    }
}

@end

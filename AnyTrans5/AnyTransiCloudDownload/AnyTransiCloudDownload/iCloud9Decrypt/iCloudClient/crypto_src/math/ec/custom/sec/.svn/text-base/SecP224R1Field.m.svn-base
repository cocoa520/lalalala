//
//  SecP224R1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP224R1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat224.h"
#import "Nat.h"

@implementation SecP224R1Field

// 2^224 - 2^96 + 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pext = [@[@((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x00000000), @((uint)0x00000002), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pextinv = [@[@((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x00000001)] mutableCopy];
            }
        }
    }
    return _pextinv;
}

static uint const P6 = 0xFFFFFFFF;
static uint const PExt13 = 0xFFFFFFFF;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat224 add:x withY:y withZ:z];
    if (c != 0 || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224R1Field P]])) {
        [SecP224R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat add:14 withX:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[13] unsignedIntValue] == PExt13 && [Nat gte:14 withX:zz withY:[SecP224R1Field PExt]])) {
        if ([Nat addTo:(int)([SecP224R1Field PExtInv].count) withX:[SecP224R1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:14 withZ:zz withZpos:(int)([SecP224R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:7 withX:x withZ:z];
    if (c != 0 || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224R1Field P]])) {
        [SecP224R1Field addPInvTo:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat224 fromBigInteger:x];
    if ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224R1Field P]]) {
        [Nat224 subFrom:[SecP224R1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:7 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat224 add:x withY:[SecP224R1Field P] withZ:z];
        [Nat shiftDownBit:7 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat224 createExt];
        [Nat224 mul:x withY:y withZZ:tt];
        [SecP224R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif        
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint c = [Nat224 mulAddTo:x withY:y withZZ:zz];
    if (c != 0 || ([zz[13] unsignedIntValue] == PExt13 && [Nat gte:14 withX:zz withY:[SecP224R1Field PExt]])) {
        if ([Nat addTo:(int)([SecP224R1Field PExtInv].count) withX:[SecP224R1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:14 withZ:zz withZpos:(int)([SecP224R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat224 isZero:x]) {
        [Nat224 zero:z];
    } else {
        [Nat224 sub:[SecP224R1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t xx10 = [xx[10] longLongValue], xx11 = [xx[11] longLongValue], xx12 = [xx[12] longLongValue], xx13 = [xx[13] longLongValue];
        
        const int64_t n = 1;
        
        int64_t t0 = [xx[7] longLongValue] + xx11 - n;
        int64_t t1 = [xx[8] longLongValue] + xx12;
        int64_t t2 = [xx[9] longLongValue] + xx13;
        
        int64_t cc = 0;
        cc += [xx[0] longLongValue] - t0;
        int64_t z0 = (uint)cc;
        cc >>= 32;
        cc += [xx[1] longLongValue] - t1;
        z[1] = @((uint)cc);
        cc >>= 32;
        cc += [xx[2] longLongValue] - t2;
        z[2] = @((uint)cc);
        cc >>= 32;
        cc += [xx[3] longLongValue] + t0 - xx10;
        int64_t z3 = (uint)cc;
        cc >>= 32;
        cc += [xx[4] longLongValue] + t1 - xx11;
        z[4] = @((uint)cc);
        cc >>= 32;
        cc += [xx[5] longLongValue] + t2 - xx12;
        z[5] = @((uint)cc);
        cc >>= 32;
        cc += [xx[6] longLongValue] + xx10 - xx13;
        z[6] = @((uint)cc);
        cc >>= 32;
        cc += n;
        
        z3 += cc;
        
        z0 -= cc;
        z[0] = @((uint)z0);
        cc = z0 >> 32;
        if (cc != 0) {
            cc += [z[1] longLongValue];
            z[1] = @((uint)cc);
            cc >>= 32;
            cc += [z[2] longLongValue];
            z[2] = @((uint)cc);
            z3 += cc >> 32;
        }
        z[3] = @((uint)z3);
        cc = z3 >> 32;
        
        if ((cc != 0 && [Nat incAt:7 withZ:z withZpos:4] != 0 != 0) || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224R1Field P]])) {
            [SecP224R1Field addPInvTo:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t cc = 0;
        
        if (x != 0) {
            int64_t xx07 = x;
            
            cc += [z[0] longLongValue] - xx07;
            z[0] = @((uint)cc);
            cc >>= 32;
            if (cc != 0) {
                cc += [z[1] longLongValue];
                z[1] = @((uint)cc);
                cc >>= 32;
                cc += [z[2] longLongValue];
                z[2] = @((uint)cc);
                cc >>= 32;
            }
            cc += [z[3] longLongValue] + xx07;
            z[3] = @((uint)cc);
            cc >>= 32;
        }
        
        if ((cc != 0 && [Nat incAt:7 withZ:z withZpos:4] != 0) || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224R1Field P]])) {
            [SecP224R1Field addPInvTo:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat224 createExt];
        [Nat224 square:x withZZ:tt];
        [SecP224R1Field reduce:tt withZ:z];
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
        [SecP224R1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat224 square:z withZZ:tt];
            [SecP224R1Field reduce:tt withZ:z];
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
        [SecP224R1Field subPInvFrom:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:14 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        if ([Nat subFrom:(int)([SecP224R1Field PExtInv].count) withX:[SecP224R1Field PExtInv] withZ:zz] != 0) {
            [Nat decAt:14 withZ:zz withZpos:(int)([SecP224R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:7 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[6] unsignedIntValue] == P6 && [Nat224 gte:z withY:[SecP224R1Field P]])) {
        [SecP224R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addPInvTo:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] - 1;
        z[0] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c += [z[1] longLongValue];
            z[1] = @((uint)c);
            c >>= 32;
            c += [z[2] longLongValue];
            z[2] = @((uint)c);
            c >>= 32;
        }
        c += [z[3] longLongValue] + 1;
        z[3] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            [Nat incAt:7 withZ:z withZpos:4];
        }
    }
}

// NSMutableArray == uint[]
+ (void)subPInvFrom:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] + 1;
        z[0] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c += [z[1] longLongValue];
            z[1] = @((uint)c);
            c >>= 32;
            c += [z[2] longLongValue];
            z[2] = @((uint)c);
            c >>= 32;
        }
        c += [z[3] longLongValue] - 1;
        z[3] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            [Nat incAt:7 withZ:z withZpos:4];
        }        
    }
}

@end

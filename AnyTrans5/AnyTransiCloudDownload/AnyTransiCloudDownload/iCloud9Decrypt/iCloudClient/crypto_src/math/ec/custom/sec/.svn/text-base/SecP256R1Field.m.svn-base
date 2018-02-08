//
//  SecP256R1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP256R1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat256.h"
#import "Nat.h"

@implementation SecP256R1Field

// 2^256 - 2^224 + 2^192 + 2^96 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000001), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pext = [@[@((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFE), @((uint)0x00000001), @((uint)0xFFFFFFFE), @((uint)0x00000001), @((uint)0xFFFFFFFE), @((uint)0x00000001), @((uint)0x00000001), @((uint)0xFFFFFFFE), @((uint)0x00000002), @((uint)0xFFFFFFFE)] mutableCopy];
            }
        }
    }
    return _pext;
}

static uint const P7 = 0xFFFFFFFF;
static uint const PExt15 = 0xFFFFFFFE;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat256 add:x withY:y withZ:z];
    if (c != 0 || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256R1Field P]])) {
        [SecP256R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat add:16 withX:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[15] unsignedIntValue] == PExt15 && [Nat gte:16 withX:zz withY:[SecP256R1Field PExt]])) {
        [Nat subFrom:16 withX:[SecP256R1Field PExt] withZ:zz];
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:8 withX:x withZ:z];
    if (c != 0 || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256R1Field P]])) {
        [SecP256R1Field addPInvTo:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat256 fromBigInteger:x];
    if ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256R1Field P]]) {
        [Nat256 subFrom:[SecP256R1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:8 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat256 add:x withY:[SecP256R1Field P] withZ:z];
        [Nat shiftDownBit:8 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt];
        [Nat256 mul:x withY:y withZZ:tt];
        [SecP256R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint c = [Nat256 mulAddTo:x withY:y withZZ:zz];
    if (c != 0 || ([zz[15] unsignedIntValue] == PExt15 && [Nat gte:16 withX:zz withY:[SecP256R1Field PExt]])) {
        [Nat subFrom:16 withX:[SecP256R1Field PExt] withZ:zz];
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat256 isZero:x]) {
        [Nat256 zero:z];
    } else {
        [Nat256 sub:[SecP256R1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t xx08 = [xx[8] longLongValue], xx09 = [xx[9] longLongValue], xx10 = [xx[10] longLongValue], xx11 = [xx[11] longLongValue];
        int64_t xx12 = [xx[12] longLongValue], xx13 = [xx[13] longLongValue], xx14 = [xx[14] longLongValue], xx15 = [xx[15] longLongValue];
        
        const int64_t n = 6;
        
        xx08 -= n;
        
        int64_t t0 = xx08 + xx09;
        int64_t t1 = xx09 + xx10;
        int64_t t2 = xx10 + xx11 - xx15;
        int64_t t3 = xx11 + xx12;
        int64_t t4 = xx12 + xx13;
        int64_t t5 = xx13 + xx14;
        int64_t t6 = xx14 + xx15;
        
        int64_t cc = 0;
        cc += [xx[0] longLongValue] + t0 - t3 - t5;
        z[0] = @((uint)cc);
        cc >>= 32;
        cc += [xx[1] longLongValue] + t1 - t4 - t6;
        z[1] = @((uint)cc);
        cc >>= 32;
        cc += [xx[2] longLongValue] + t2 - t5;
        z[2] = @((uint)cc);
        cc >>= 32;
        cc += [xx[3] longLongValue] + (t3 << 1) + xx13 - xx15 - t0;
        z[3] = @((uint)cc);
        cc >>= 32;
        cc += [xx[4] longLongValue] + (t4 << 1) + xx14 - t1;
        z[4] = @((uint)cc);
        cc >>= 32;
        cc += [xx[5] longLongValue] + (t5 << 1) - t2;
        z[5] = @((uint)cc);
        cc >>= 32;
        cc += [xx[6] longLongValue] + (t6 << 1) + t5 - t0;
        z[6] = @((uint)cc);
        cc >>= 32;
        cc += [xx[7] longLongValue] + (xx15 << 1) + xx08 - t2 - t4;
        z[7] = @((uint)cc);
        cc >>= 32;
        cc += n;
        
        [SecP256R1Field reduce32:(uint)cc withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t cc = 0;
        
        if (x != 0) {
            int64_t xx08 = x;
            
            cc += [z[0] longLongValue] + xx08;
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
            cc += [z[3] longLongValue] - xx08;
            z[3] = @((uint)cc);
            cc >>= 32;
            if (cc != 0) {
                cc += [z[4] longLongValue];
                z[4] = @((uint)cc);
                cc >>= 32;
                cc += [z[5] longLongValue];
                z[5] = @((uint)cc);
                cc >>= 32;
            }
            cc += [z[6] longLongValue] - xx08;
            z[6] = @((uint)cc);
            cc >>= 32;
            cc += [z[7] longLongValue] + xx08;
            z[7] = @((uint)cc);
            cc >>= 32;
        }
        
        if (cc != 0 || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256R1Field P]])) {
            [SecP256R1Field addPInvTo:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat256 createExt];
        [Nat256 square:x withZZ:tt];
        [SecP256R1Field reduce:tt withZ:z];
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
        [SecP256R1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat256 square:z withZZ:tt];
            [SecP256R1Field reduce:tt withZ:z];
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
        [SecP256R1Field subPInvFrom:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:16 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        [Nat addTo:16 withX:[SecP256R1Field PExt] withZ:zz];
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:8 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[7] unsignedIntValue] == P7 && [Nat256 gte:z withY:[SecP256R1Field P]])) {
        [SecP256R1Field addPInvTo:z];
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
            c += [z[2] longLongValue];
            z[2] = @((uint)c);
            c >>= 32;
        }
        c += [z[3] longLongValue] - 1;
        z[3] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c += [z[4] longLongValue];
            z[4] = @((uint)c);
            c >>= 32;
            c += [z[5] longLongValue];
            z[5] = @((uint)c);
            c >>= 32;
        }
        c += [z[6] longLongValue] - 1;
        z[6] = @((uint)c);
        c >>= 32;
        c += [z[7] longLongValue] + 1;
        z[7] = @((uint)c);
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
            c += [z[2] longLongValue];
            z[2] = @((uint)c);
            c >>= 32;
        }
        c += [z[3] longLongValue] + 1;
        z[3] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c += [z[4] longLongValue];
            z[4] = @((uint)c);
            c >>= 32;
            c += [z[5] longLongValue];
            z[5] = @((uint)c);
            c >>= 32;
        }
        c += [z[6] longLongValue] + 1;
        z[6] = @((uint)c);
        c >>= 32;
        c += [z[7] longLongValue] - 1;
        z[7] = @((uint)c);
    }
}

@end

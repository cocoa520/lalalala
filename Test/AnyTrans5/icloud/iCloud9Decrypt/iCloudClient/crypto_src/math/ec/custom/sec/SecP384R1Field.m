//
//  SecP384R1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP384R1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat384.h"
#import "Nat.h"

@implementation SecP384R1Field

// 2^384 - 2^128 - 2^96 + 2^32 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFFFFF), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pext = [@[@((uint)0x00000001), @((uint)0xFFFFFFFE), @((uint)0x00000000), @((uint)0x00000002), @((uint)0x00000000), @((uint)0xFFFFFFFE), @((uint)0x00000000), @((uint)0x00000002), @((uint)0x00000001), @((uint)0x00000000), @((uint)0x00000000), @((uint)0x00000000), @((uint)0xFFFFFFFE), @((uint)0x00000001), @((uint)0x00000000), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF)] mutableCopy];
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
                _pextinv = [@[@((uint)0xFFFFFFFF), @((uint)0x00000001), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFF), @((uint)0x00000001), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFD), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x00000001), @((uint)0xFFFFFFFE), @((uint)0xFFFFFFFF), @((uint)0x00000001), @((uint)0x00000002)] mutableCopy];
            }
        }
    }
    return _pextinv;
}

static uint const P11 = 0xFFFFFFFF;
static uint const PExt23 = 0xFFFFFFFF;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint c = [Nat add:12 withX:x withY:y withZ:z];
    if (c != 0 || ([z[11] unsignedIntValue] == P11 && [Nat gte:12 withX:z withY:[SecP384R1Field P]])) {
        [SecP384R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    uint c = [Nat add:24 withX:xx withY:yy withZ:zz];
    if (c != 0 || ([zz[23] unsignedIntValue] == PExt23 && [Nat gte:24 withX:zz withY:[SecP384R1Field PExt]])) {
        if ([Nat addTo:(int)([SecP384R1Field PExtInv].count) withX:[SecP384R1Field PExtInv] withZ:zz] != 0) {
            [Nat incAt:24 withZ:zz withZpos:(int)([SecP384R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat inc:12 withX:x withZ:z];
    if (c != 0 || ([z[11] unsignedIntValue] == P11 && [Nat gte:12 withX:z withY:[SecP384R1Field P]])) {
        [SecP384R1Field addPInvTo:z];
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat fromBigInteger:384 withX:x];
    if ([z[11] unsignedIntValue] == P11 && [Nat gte:12 withX:z withY:[SecP384R1Field P]]) {
        [Nat subFrom:12 withX:[SecP384R1Field P] withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if (([x[0] unsignedIntValue] & 1) == 0) {
        [Nat shiftDownBit:12 withX:x withC:0 withZ:z];
    } else {
        uint c = [Nat add:12 withX:x withY:[SecP384R1Field P] withZ:z];
        [Nat shiftDownBit:12 withZ:z withC:c];
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create:24];
        [Nat384 mul:x withY:y withZZ:tt];
        [SecP384R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat isZero:12 withX:x]) {
        [Nat zero:12 withZ:z];
    } else {
        [Nat sub:12 withX:[SecP384R1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t xx16 = [xx[16] longLongValue], xx17 = [xx[17] longLongValue], xx18 = [xx[18] longLongValue], xx19 = [xx[19] longLongValue];
        int64_t xx20 = [xx[20] longLongValue], xx21 = [xx[21] longLongValue], xx22 = [xx[22] longLongValue], xx23 = [xx[23] longLongValue];
        
        const int64_t n = 1;
        
        int64_t t0 = [xx[12] longLongValue] + xx20 - n;
        int64_t t1 = [xx[13] longLongValue] + xx22;
        int64_t t2 = [xx[14] longLongValue] + xx22 + xx23;
        int64_t t3 = [xx[15] longLongValue] + xx23;
        int64_t t4 = xx17 + xx21;
        int64_t t5 = xx21 - xx23;
        int64_t t6 = xx22 - xx23;
        
        int64_t cc = 0;
        cc += [xx[0] longLongValue] + t0 + t5;
        z[0] = @((uint)cc);
        cc >>= 32;
        cc += [xx[1] longLongValue] + xx23 - t0 + t1;
        z[1] = @((uint)cc);
        cc >>= 32;
        cc += [xx[2] longLongValue] - xx21 - t1 + t2;
        z[2] = @((uint)cc);
        cc >>= 32;
        cc += [xx[3] longLongValue] + t0 - t2 + t3 + t5;
        z[3] = @((uint)cc);
        cc >>= 32;
        cc += [xx[4] longLongValue] + xx16 + xx21 + t0 + t1 - t3 + t5;
        z[4] = @((uint)cc);
        cc >>= 32;
        cc += [xx[5] longLongValue] - xx16 + t1 + t2 + t4;
        z[5] = @((uint)cc);
        cc >>= 32;
        cc += [xx[6] longLongValue] + xx18 - xx17 + t2 + t3;
        z[6] = @((uint)cc);
        cc >>= 32;
        cc += [xx[7] longLongValue] + xx16 + xx19 - xx18 + t3;
        z[7] = @((uint)cc);
        cc >>= 32;
        cc += [xx[8] longLongValue] + xx16 + xx17 + xx20 - xx19;
        z[8] = @((uint)cc);
        cc >>= 32;
        cc += [xx[9] longLongValue] + xx18 - xx20 + t4;
        z[9] = @((uint)cc);
        cc >>= 32;
        cc += [xx[10] longLongValue] + xx18 + xx19 - t5 + t6;
        z[10] = @((uint)cc);
        cc >>= 32;
        cc += [xx[11] longLongValue] + xx19 + xx20 - t6;
        z[11] = @((uint)cc);
        cc >>= 32;
        cc += n;
        
        [SecP384R1Field reduce32:(uint)cc withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce32:(uint)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t cc = 0;
        
        if (x != 0) {
            int64_t xx12 = x;
            
            cc += [z[0] longLongValue] + xx12;
            z[0] = @((uint)cc);
            cc >>= 32;
            cc += [z[1] longLongValue] - xx12;
            z[1] = @((uint)cc);
            cc >>= 32;
            if (cc != 0) {
                cc += [z[2] longLongValue];
                z[2] = @((uint)cc);
                cc >>= 32;
            }
            cc += [z[3] longLongValue] + xx12;
            z[3] = @((uint)cc);
            cc >>= 32;
            cc += [z[4] longLongValue] + xx12;
            z[4] = @((uint)cc);
            cc >>= 32;
        }
        
        if ((cc != 0 && [Nat incAt:12 withZ:z withZpos:5] != 0) || ([z[11] unsignedIntValue] == P11 && [Nat gte:12 withX:z withY:[SecP384R1Field P]])) {
            [SecP384R1Field addPInvTo:z];
        }
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create:24];
        [Nat384 square:x withZZ:tt];
        [SecP384R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create:24];
        [Nat384 square:x withZZ:tt];
        [SecP384R1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [Nat384 square:z withZZ:tt];
            [SecP384R1Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int c = [Nat sub:12 withX:x withY:y withZ:z];
    if (c != 0) {
        [SecP384R1Field subPInvFrom:z];
    }
}

// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz {
    int c = [Nat sub:24 withX:xx withY:yy withZ:zz];
    if (c != 0) {
        if ([Nat subFrom:(int)([SecP384R1Field PExtInv].count) withX:[SecP384R1Field PExtInv] withZ:zz] != 0) {
            [Nat decAt:24 withZ:zz withZpos:(int)([SecP384R1Field PExtInv].count)];
        }
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint c = [Nat shiftUpBit:12 withX:x withC:0 withZ:z];
    if (c != 0 || ([z[11] unsignedIntValue] == P11 && [Nat gte:12 withX:z withY:[SecP384R1Field P]])) {
        [SecP384R1Field addPInvTo:z];
    }
}

// NSMutableArray == uint[]
+ (void)addPInvTo:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] + 1;
        z[0] = @((uint)c);
        c >>= 32;
        c += [z[1] longLongValue] - 1;
        z[1] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c += [z[2] longLongValue];
            z[2] = @((uint)c);
            c >>= 32;
        }
        c += [z[3] longLongValue] + 1;
        z[3] = @((uint)c);
        c >>= 32;
        c += [z[4] longLongValue] + 1;
        z[4] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            [Nat incAt:12 withZ:z withZpos:5];
        }
    }
}

// NSMutableArray == uint[]
+ (void)subPInvFrom:(NSMutableArray*)z {
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] - 1;
        z[0] = @((uint)c);
        c >>= 32;
        c += [z[1] longLongValue] + 1;
        z[1] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            c += [z[2] longLongValue];
            z[2] = @((uint)c);
            c >>= 32;
        }
        c += [z[3] longLongValue] - 1;
        z[3] = @((uint)c);
        c >>= 32;
        c += [z[4] longLongValue] - 1;
        z[4] = @((uint)c);
        c >>= 32;
        if (c != 0) {
            [Nat decAt:12 withZ:z withZpos:5];
        }
    }
}

@end

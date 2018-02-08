//
//  SecP521R1Field.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP521R1Field.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat512.h"
#import "Nat.h"

@implementation SecP521R1Field

// 2^521 - 1
// return == uint[]
+ (NSMutableArray*)P {
    static NSMutableArray *_p = nil;
    @synchronized(self) {
        if (_p == nil) {
            @autoreleasepool {
                _p = [@[@((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0xFFFFFFFF), @((uint)0x1FF)] mutableCopy];
            }
        }
    }
    return _p;
}

static int const P16 = 0x1FF;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint c = [Nat add:16 withX:x withY:y withZ:z] + [x[16] unsignedIntValue] + [y[16] unsignedIntValue];
        if (c > P16 || (c == P16 && [Nat eq:16 withX:z withY:[SecP521R1Field P]])) {
            c += [Nat inc:16 withZ:z];
            c &= P16;
        }
        z[16] = @(c);
    }
}

// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint c = [Nat inc:16 withX:x withZ:z] + [x[16] unsignedIntValue];
        if (c > P16 || (c == P16 && [Nat eq:16 withX:z withY:[SecP521R1Field P]])) {
            c += [Nat inc:16 withZ:z];
            c &= P16;
        }
        z[16] = @(c);
    }
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    NSMutableArray *z = [Nat fromBigInteger:521 withX:x];
    if ([Nat eq:17 withX:z withY:[SecP521R1Field P]]) {
        [Nat zero:17 withZ:z];
    }
    return z;
}

// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint x16 = [x[16] unsignedIntValue];
        uint c = [Nat shiftDownBit:16 withX:x withC:x16 withZ:z];
        z[16] = @((uint)((x16 >> 1) | (c >> 23)));
    }
}

// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create:33];
        [SecP521R1Field implMultiply:x withY:y withZZ:tt];
        [SecP521R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt != nil) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    if ([Nat isZero:17 withX:x]) {
        [Nat zero:17 withZ:z];
    } else {
        [Nat sub:17 withX:[SecP521R1Field P] withY:x withZ:z];
    }
}

// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint xx32 = [xx[32] unsignedIntValue];
        uint c = [Nat shiftDownBits:16 withX:xx withXoff:16 withBits:9 withC:xx32 withZ:z withZoff:0] >> 23;
        c += xx32 >> 9;
        c += [Nat addTo:16 withX:xx withZ:z];
        if (c > P16 || (c == P16 && [Nat eq:16 withX:z withY:[SecP521R1Field P]])) {
            c += [Nat inc:16 withZ:z];
            c &= P16;
        }
        z[16] = @(c);
    }
}

// NSMutableArray == uint[]
+ (void)reduce23:(NSMutableArray*)z {
    @autoreleasepool {
        uint z16 = [z[16] unsignedIntValue];
        uint c = [Nat addWordTo:16 withX:(z16 >> 9) withZ:z] + (z16 & P16);
        if (c > P16 || (c == P16 && [Nat eq:16 withX:z withY:[SecP521R1Field P]])) {
            c += [Nat inc:16 withZ:z];
            c &= P16;
        }
        z[16] = @(c);
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create:33];
        [SecP521R1Field implSquare:x withZZ:tt];
        [SecP521R1Field reduce:tt withZ:z];
#if !__has_feature(objc_arc)
        if (tt != nil) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    @autoreleasepool {
        NSMutableArray *tt = [Nat create:33];
        [SecP521R1Field implSquare:x withZZ:tt];
        [SecP521R1Field reduce:tt withZ:z];
        
        while (--n > 0) {
            [SecP521R1Field implSquare:z withZZ:tt];
            [SecP521R1Field reduce:tt withZ:z];
        }
#if !__has_feature(objc_arc)
        if (tt != nil) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int c = [Nat sub:16 withX:x withY:y withZ:z] + (int)([x[16] unsignedIntValue] - [y[16] unsignedIntValue]);
        if (c < 0) {
            c += [Nat dec:16 withZ:z];
            c &= P16;
        }
        z[16] = @((uint)c);
    }
}

// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint x16 = [x[16] unsignedIntValue];
        uint c = [Nat shiftUpBit:16 withX:x withC:(x16 << 23) withZ:z] | (x16 << 1);
        z[16] = @((uint)(c & P16));
    }
}

// NSMutableArray == uint[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Nat512 mul:x withY:y withZZ:zz];
        
        uint x16 = [x[16] unsignedIntValue], y16 = [y[16] unsignedIntValue];
        zz[32] = @([Nat mul31BothAdd:16 withA:x16 withX:y withB:y16 withY:x withZ:zz withZoff:16] + (x16 * y16));
    }
}

// NSMutableArray == uint[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Nat512 square:x withZZ:zz];
        
        uint x16 = [x[16] unsignedIntValue];
        zz[32] = @([Nat mulWordAddTo:16 withX:(x16 << 1) withY:x withYoff:0 withZ:zz withZoff:16] + (x16 * x16));
    }
}

@end

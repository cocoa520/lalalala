//
//  SecP224K1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP224K1FieldElement.h"
#import "BigInteger.h"
#import "SecP224K1Curve.h"
#import "SecP224K1Field.h"
#import "Nat224.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP224K1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP224K1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP224K1Curve q] retain];
        }
    }
    return _q;
}

// Calculated as BigInteger.Two.ModPow(Q.ShiftRight(2), Q)
+ (NSMutableArray*)PRECOMP_POW2 {
    static NSMutableArray *_precomp_pow2 = nil;
    @synchronized(self) {
        if (_precomp_pow2 == nil) {
            @autoreleasepool {
                _precomp_pow2 = [@[@((uint)0x33bfd202), @((uint)0xdcfad133), @((uint)0x2287624a), @((uint)0xc3811ba8), @((uint)0xa85558fc), @((uint)0x1eaef5d7), @((uint)0x8edf154c)] mutableCopy];
            }
        }
    }
    return _precomp_pow2;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP224K1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP224K1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP224K1Field fromBigInteger:x]];            
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat224 create];
            [self setX:tmpArray];
#if !__has_feature(objc_arc)
            if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithUintArray:(NSMutableArray*)x {
    if (self = [super init]) {
        [self setX:x];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setX:nil];
    [super dealloc];
#endif
}

- (BOOL)isZero {
    return [Nat224 isZero:[self x]];
}

- (BOOL)isOne {
    return [Nat224 isOne:[self x]];
}

- (BOOL)testBitZero {
    return [Nat224 getBit:[self x] withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat224 toBigInteger:[self x]];
}

- (NSString*)fieldName {
    return @"SecP224K1Field";
}

- (int)fieldSize {
    return [[SecP224K1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP224K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224K1Field add:[self x] withY:[((SecP224K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP224K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP224K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224K1Field addOne:[self x] withZ:z];
        retVal = [[SecP224K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP224K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224K1Field subtract:[self x] withY:[((SecP224K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP224K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP224K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224K1Field multiply:[self x] withY:[((SecP224K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP224K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP224K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [Mod invert:[SecP224K1Field P] withX:[((SecP224K1FieldElement*)b) x] withZ:z];
        [SecP224K1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP224K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP224K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224K1Field negate:[self x] withZ:z];
        retVal = [[SecP224K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP224K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224K1Field square:[self x] withZ:z];
        retVal = [[SecP224K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP224K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [Mod invert:[SecP224K1Field P] withX:[self x] withZ:z];
        retVal = [[SecP224K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * return a sqrt root - the routine verifies that the calculation returns the right value - if
 * none exists it returns null.
 */
- (ECFieldElement*)sqrt {
    /*
     * Q == 8m + 5, so we use Pocklington's method for this case.
     *
     * First, raise this element to the exponent 2^221 - 2^29 - 2^9 - 2^8 - 2^6 - 2^4 - 2^1 (i.e. m + 1)
     *
     * Breaking up the exponent's binary representation into "repunits", we get:
     * { 191 1s } { 1 0s } { 19 1s } { 2 0s } { 1 1s } { 1 0s} { 1 1s } { 1 0s} { 3 1s } { 1 0s}
     *
     * Therefore we need an addition chain containing 1, 3, 19, 191 (the lengths of the repunits)
     * We use: [1], 2, [3], 4, 8, 11, [19], 23, 42, 84, 107, [191]
     */
    
    NSMutableArray *x1 = [self x];
    if ([Nat224 isZero:x1] || [Nat224 isOne:x1]) {
        return self;
    }
    
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *x2 = [Nat224 create];
        [SecP224K1Field square:x1 withZ:x2];
        [SecP224K1Field multiply:x2 withY:x1 withZ:x2];
        NSMutableArray *x3 = x2;
        [SecP224K1Field square:x2 withZ:x3];
        [SecP224K1Field multiply:x3 withY:x1 withZ:x3];
        NSMutableArray *x4 = [Nat224 create];
        [SecP224K1Field square:x3 withZ:x4];
        [SecP224K1Field multiply:x4 withY:x1 withZ:x4];
        NSMutableArray *x8 = [Nat224 create];
        [SecP224K1Field squareN:x4 withN:4 withZ:x8];
        [SecP224K1Field multiply:x8 withY:x4 withZ:x8];
        NSMutableArray *x11 = [Nat224 create];
        [SecP224K1Field squareN:x8 withN:3 withZ:x11];
        [SecP224K1Field multiply:x11 withY:x3 withZ:x11];
        NSMutableArray *x19 = x11;
        [SecP224K1Field squareN:x11 withN:8 withZ:x19];
        [SecP224K1Field multiply:x19 withY:x8 withZ:x19];
        NSMutableArray *x23 = x8;
        [SecP224K1Field squareN:x19 withN:4 withZ:x23];
        [SecP224K1Field multiply:x23 withY:x4 withZ:x23];
        NSMutableArray *x42 = x4;
        [SecP224K1Field squareN:x23 withN:19 withZ:x42];
        [SecP224K1Field multiply:x42 withY:x19 withZ:x42];
        NSMutableArray *x84 = [Nat224 create];
        [SecP224K1Field squareN:x42 withN:42 withZ:x84];
        [SecP224K1Field multiply:x84 withY:x42 withZ:x84];
        NSMutableArray *x107 = x42;
        [SecP224K1Field squareN:x84 withN:23 withZ:x107];
        [SecP224K1Field multiply:x107 withY:x23 withZ:x107];
        NSMutableArray *x191 = x23;
        [SecP224K1Field squareN:x107 withN:84 withZ:x191];
        [SecP224K1Field multiply:x191 withY:x84 withZ:x191];
        
        NSMutableArray *t1 = x191;
        [SecP224K1Field squareN:t1 withN:20 withZ:t1];
        [SecP224K1Field multiply:t1 withY:x19 withZ:t1];
        [SecP224K1Field squareN:t1 withN:3 withZ:t1];
        [SecP224K1Field multiply:t1 withY:x1 withZ:t1];
        [SecP224K1Field squareN:t1 withN:2 withZ:t1];
        [SecP224K1Field multiply:t1 withY:x1 withZ:t1];
        [SecP224K1Field squareN:t1 withN:4 withZ:t1];
        [SecP224K1Field multiply:t1 withY:x3 withZ:t1];
        [SecP224K1Field square:t1 withZ:t1];
        
        NSMutableArray *t2 = x84;
        [SecP224K1Field square:t1 withZ:t2];
        
        if ([Nat224 eq:x1 withY:t2]) {
            retVal = [[SecP224K1FieldElement alloc] initWithUintArray:t1];
#if !__has_feature(objc_arc)
            if (x2) [x2 release]; x2 = nil;
            if (x4) [x4 release]; x4 = nil;
            if (x8) [x8 release]; x8 = nil;
            if (x11) [x11 release]; x11 = nil;
            if (x84) [x84 release]; x84 = nil;
#endif
        } else {
            /*
             * If the first guess is incorrect, we multiply by a precomputed power of 2 to get the second guess,
             * which is ((4x)^(m + 1))/2 mod Q
             */
            [SecP224K1Field multiply:t1 withY:[SecP224K1FieldElement PRECOMP_POW2] withZ:t1];
            
            [SecP224K1Field square:t1 withZ:t2];
            
            
            if ([Nat224 eq:x1 withY:t2]) {
                retVal = [[SecP224K1FieldElement alloc] initWithUintArray:t1];
#if !__has_feature(objc_arc)
                if (x2) [x2 release]; x2 = nil;
                if (x4) [x4 release]; x4 = nil;
                if (x8) [x8 release]; x8 = nil;
                if (x11) [x11 release]; x11 = nil;
                if (x84) [x84 release]; x84 = nil;
#endif
            } else {
#if !__has_feature(objc_arc)
                if (x2) [x2 release]; x2 = nil;
                if (x4) [x4 release]; x4 = nil;
                if (x8) [x8 release]; x8 = nil;
                if (x11) [x11 release]; x11 = nil;
                if (x84) [x84 release]; x84 = nil;
#endif
            }
        }
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP224K1FieldElement class]] ) {
        return [self equalsWithSecP224K1FieldElement:(SecP224K1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP224K1FieldElement class]] ) {
        return [self equalsWithSecP224K1FieldElement:(SecP224K1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP224K1FieldElement:(SecP224K1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return false;
    }
    return [Nat224 eq:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP224K1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:7];
}

@end

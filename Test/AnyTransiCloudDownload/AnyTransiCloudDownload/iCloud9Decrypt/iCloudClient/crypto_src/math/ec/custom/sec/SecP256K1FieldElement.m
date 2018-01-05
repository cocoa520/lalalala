//
//  SecP256K1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP256K1FieldElement.h"
#import "BigInteger.h"
#import "SecP256K1Curve.h"
#import "SecP256K1Field.h"
#import "Nat256.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP256K1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP256K1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP256K1Curve q] retain];
        }
    }
    return _q;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP256K1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP256K1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP256K1Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat256 create];
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
    return [Nat256 isZero:[self x]];
}

- (BOOL)isOne {
    return [Nat256 isOne:[self x]];
}

- (BOOL)testBitZero {
    return [Nat256 getBit:[self x] withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat256 toBigInteger:[self x]];
}

- (NSString*)fieldName {
    return @"SecP256K1Field";
}

- (int)fieldSize {
    return [[SecP256K1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256K1Field add:[self x] withY:[((SecP256K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP256K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256K1Field addOne:[self x] withZ:z];
        retVal = [[SecP256K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256K1Field subtract:[self x] withY:[((SecP256K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP256K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256K1Field multiply:[self x] withY:[((SecP256K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP256K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Mod invert:[SecP256K1Field P] withX:[((SecP256K1FieldElement*)b) x] withZ:z];
        [SecP256K1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP256K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256K1Field negate:[self x] withZ:z];
        retVal = [[SecP256K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256K1Field square:[self x] withZ:z];
        retVal = [[SecP256K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Mod invert:[SecP256K1Field P] withX:[self x] withZ:z];
        retVal = [[SecP256K1FieldElement alloc] initWithUintArray:z];
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
     * Raise this element to the exponent 2^254 - 2^30 - 2^7 - 2^6 - 2^5 - 2^4 - 2^2
     *
     * Breaking up the exponent's binary representation into "repunits", we get:
     * { 223 1s } { 1 0s } { 22 1s } { 4 0s } { 2 1s } { 2 0s}
     *
     * Therefore we need an addition chain containing 2, 22, 223 (the lengths of the repunits)
     * We use: 1, [2], 3, 6, 9, 11, [22], 44, 88, 176, 220, [223]
     */
    
    NSMutableArray *x1 = [self x];
    if ([Nat256 isZero:x1] || [Nat256 isOne:x1]) {
        return self;
    }
    
    SecP256K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *x2 = [Nat256 create];
        [SecP256K1Field square:x1 withZ:x2];
        [SecP256K1Field multiply:x2 withY:x1 withZ:x2];
        NSMutableArray *x3 = [Nat256 create];
        [SecP256K1Field square:x2 withZ:x3];
        [SecP256K1Field multiply:x3 withY:x1 withZ:x3];
        NSMutableArray *x6 = [Nat256 create];
        [SecP256K1Field squareN:x3 withN:3 withZ:x6];
        [SecP256K1Field multiply:x6 withY:x3 withZ:x6];
        NSMutableArray *x9 = x6;
        [SecP256K1Field squareN:x6 withN:3 withZ:x9];
        [SecP256K1Field multiply:x9 withY:x3 withZ:x9];
        NSMutableArray *x11 = x9;
        [SecP256K1Field squareN:x9 withN:2 withZ:x11];
        [SecP256K1Field multiply:x11 withY:x2 withZ:x11];
        NSMutableArray *x22 = [Nat256 create];
        [SecP256K1Field squareN:x11 withN:11 withZ:x22];
        [SecP256K1Field multiply:x22 withY:x11 withZ:x22];
        NSMutableArray *x44 = x11;
        [SecP256K1Field squareN:x22 withN:22 withZ:x44];
        [SecP256K1Field multiply:x44 withY:x22 withZ:x44];
        NSMutableArray *x88 = [Nat256 create];
        [SecP256K1Field squareN:x44 withN:44 withZ:x88];
        [SecP256K1Field multiply:x88 withY:x44 withZ:x88];
        NSMutableArray *x176 = [Nat256 create];
        [SecP256K1Field squareN:x88 withN:88 withZ:x176];
        [SecP256K1Field multiply:x176 withY:x88 withZ:x176];
        NSMutableArray *x220 = x88;
        [SecP256K1Field squareN:x176 withN:44 withZ:x220];
        [SecP256K1Field multiply:x220 withY:x44 withZ:x220];
        NSMutableArray *x223 = x44;
        [SecP256K1Field squareN:x220 withN:3 withZ:x223];
        [SecP256K1Field multiply:x223 withY:x3 withZ:x223];
        
        NSMutableArray *t1 = x223;
        [SecP256K1Field squareN:t1 withN:23 withZ:t1];
        [SecP256K1Field multiply:t1 withY:x22 withZ:t1];
        [SecP256K1Field squareN:t1 withN:6 withZ:t1];
        [SecP256K1Field multiply:t1 withY:x2 withZ:t1];
        [SecP256K1Field squareN:t1 withN:2 withZ:t1];
        
        NSMutableArray *t2 = x2;
        [SecP256K1Field square:t1 withZ:t2];
        
        retVal = ([Nat256 eq:x1 withY:t2] ? [[SecP256K1FieldElement alloc] initWithUintArray:t1] : nil);
#if !__has_feature(objc_arc)
        if (x2) [x2 release]; x2 = nil;
        if (x3) [x3 release]; x3 = nil;
        if (x6) [x6 release]; x6 = nil;
        if (x22) [x22 release]; x22 = nil;
        if (x88) [x88 release]; x88 = nil;
        if (x176) [x176 release]; x176 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP256K1FieldElement class]] ) {
        return [self equalsWithSecP256K1FieldElement:(SecP256K1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP256K1FieldElement class]] ) {
        return [self equalsWithSecP256K1FieldElement:(SecP256K1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP256K1FieldElement:(SecP256K1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat256 eq:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP256K1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:8];
}

@end

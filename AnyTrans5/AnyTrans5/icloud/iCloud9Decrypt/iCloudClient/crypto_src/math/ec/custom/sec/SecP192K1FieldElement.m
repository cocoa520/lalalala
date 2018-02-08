//
//  SecP192K1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP192K1FieldElement.h"
#import "BigInteger.h"
#import "SecP192K1Curve.h"
#import "SecP192K1Field.h"
#import "Nat192.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP192K1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP192K1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP192K1Curve q] retain];
        }
    }
    return _q;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP192K1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP192K1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP192K1Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat192 create];
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
    return [Nat192 isZero:[self x]];
}

- (BOOL)isOne {
    return [Nat192 isOne:[self x]];
}

- (BOOL)testBitZero {
    return [Nat192 getBit:self.x withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat192 toBigInteger:[self x]];
}

- (NSString*)fieldName {
    return @"SecP192K1Field";
}

- (int)fieldSize {
    return [[SecP192K1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192K1Field add:[self x] withY:[((SecP192K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP192K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192K1Field addOne:[self x] withZ:z];
        retVal = [[SecP192K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192K1Field subtract:[self x] withY:[((SecP192K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP192K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192K1Field multiply:[self x] withY:[((SecP192K1FieldElement*)b) x] withZ:z];
        retVal = [[SecP192K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [Mod invert:[SecP192K1Field P] withX:[((SecP192K1FieldElement*)b) x] withZ:z];
        [SecP192K1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP192K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192K1Field negate:[self x] withZ:z];
        retVal = [[SecP192K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192K1Field square:[self x] withZ:z];
        retVal = [[SecP192K1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [Mod invert:[SecP192K1Field P] withX:[self x] withZ:z];
        retVal = [[SecP192K1FieldElement alloc] initWithUintArray:z];
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
     * Raise this element to the exponent 2^190 - 2^30 - 2^10 - 2^6 - 2^5 - 2^4 - 2^1
     *
     * Breaking up the exponent's binary representation into "repunits", we get:
     * { 159 1s } { 1 0s } { 19 1s } { 1 0s } { 3 1s } { 3 0s} { 3 1s } { 1 0s }
     *
     * Therefore we need an addition chain containing 3, 19, 159 (the lengths of the repunits)
     * We use: 1, 2, [3], 6, 8, 16, [19], 35, 70, 140, [159]
     */
    
    NSMutableArray *x1 = [self x];
    if ([Nat192 isZero:x1] || [Nat192 isOne:x1]) {
        return self;
    }
    
    SecP192K1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *x2 = [Nat192 create];
        [SecP192K1Field square:x1 withZ:x2];
        [SecP192K1Field multiply:x2 withY:x1 withZ:x2];
        NSMutableArray *x3 = [Nat192 create];
        [SecP192K1Field square:x2 withZ:x3];
        [SecP192K1Field multiply:x3 withY:x1 withZ:x3];
        NSMutableArray *x6 = [Nat192 create];
        [SecP192K1Field squareN:x3 withN:3 withZ:x6];
        [SecP192K1Field multiply:x6 withY:x3 withZ:x6];
        NSMutableArray *x8 = x6;
        [SecP192K1Field squareN:x6 withN:2 withZ:x8];
        [SecP192K1Field multiply:x8 withY:x2 withZ:x8];
        NSMutableArray *x16 = x2;
        [SecP192K1Field squareN:x8 withN:8 withZ:x16];
        [SecP192K1Field multiply:x16 withY:x8 withZ:x16];
        NSMutableArray *x19 = x8;
        [SecP192K1Field squareN:x16 withN:3 withZ:x19];
        [SecP192K1Field multiply:x19 withY:x3 withZ:x19];
        NSMutableArray *x35 = [Nat192 create];
        [SecP192K1Field squareN:x19 withN:16 withZ:x35];
        [SecP192K1Field multiply:x35 withY:x16 withZ:x35];
        NSMutableArray *x70 = x16;
        [SecP192K1Field squareN:x35 withN:35 withZ:x70];
        [SecP192K1Field multiply:x70 withY:x35 withZ:x70];
        NSMutableArray *x140 = x35;
        [SecP192K1Field squareN:x70 withN:70 withZ:x140];
        [SecP192K1Field multiply:x140 withY:x70 withZ:x140];
        NSMutableArray *x159 = x70;
        [SecP192K1Field squareN:x140 withN:19 withZ:x159];
        [SecP192K1Field multiply:x159 withY:x19 withZ:x159];
        
        NSMutableArray *t1 = x159;
        [SecP192K1Field squareN:t1 withN:20 withZ:t1];
        [SecP192K1Field multiply:t1 withY:x19 withZ:t1];
        [SecP192K1Field squareN:t1 withN:4 withZ:t1];
        [SecP192K1Field multiply:t1 withY:x3 withZ:t1];
        [SecP192K1Field squareN:t1 withN:6 withZ:t1];
        [SecP192K1Field multiply:t1 withY:x3 withZ:t1];
        [SecP192K1Field square:t1 withZ:t1];
        
        NSMutableArray *t2 = x3;
        [SecP192K1Field square:t1 withZ:t2];
        
        retVal = ([Nat192 eq:x1 withY:t2] ? [[SecP192K1FieldElement alloc] initWithUintArray:t1] : nil);
#if !__has_feature(objc_arc)
        if (x2) [x2 release]; x2 = nil;
        if (x3) [x3 release]; x3 = nil;
        if (x6) [x6 release]; x6 = nil;
        if (x35) [x35 release]; x35 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP192K1FieldElement class]] ) {
        return [self equalsWithSecP192K1FieldElement:(SecP192K1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP192K1FieldElement class]] ) {
        return [self equalsWithSecP192K1FieldElement:(SecP192K1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP192K1FieldElement:(SecP192K1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat192 eq:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP192K1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:6];
}

@end

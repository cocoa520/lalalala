//
//  SecP160R2FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP160R2FieldElement.h"
#import "BigInteger.h"
#import "SecP160R2Curve.h"
#import "SecP160R2Field.h"
#import "Nat160.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP160R2FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP160R2FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP160R2Curve q] retain];
        }
    }
    return _q;
    
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP160R2FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP160R1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP160R2Field fromBigInteger:x]];            
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat160 create];
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
    return [Nat160 isZero:[self x]];
}

- (BOOL)isOne {
    return [Nat160 isOne:[self x]];
}

- (BOOL)testBitZero {
    return [Nat160 getBit:self.x withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat160 toBigInteger:self.x];
}

- (NSString*)fieldName {
    return @"SecP160R2Field";
}

- (int)fieldSize {
    return [[SecP160R2FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R2Field add:[self x] withY:[((SecP160R2FieldElement*)b) x] withZ:z];
        retVal = [[SecP160R2FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R2Field addOne:[self x] withZ:z];
        retVal = [[SecP160R2FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R2Field subtract:[self x] withY:[((SecP160R2FieldElement*)b) x] withZ:z];
        retVal = [[SecP160R2FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R2Field multiply:[self x] withY:[((SecP160R2FieldElement*)b) x] withZ:z];
        retVal = [[SecP160R2FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [Mod invert:[SecP160R2Field P] withX:[((SecP160R2FieldElement*)b) x] withZ:z];
        [SecP160R2Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP160R2FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R2Field negate:[self x] withZ:z];
        retVal = [[SecP160R2FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R2Field square:[self x] withZ:z];
        retVal = [[SecP160R2FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [Mod invert:[SecP160R2Field P] withX:[self x] withZ:z];
        retVal = [[SecP160R2FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

// D.1.4 91
/**
 * return a sqrt root - the routine verifies that the calculation returns the right value - if
 * none exists it returns null.
 */
- (ECFieldElement*)sqrt {
    /*
     * Raise this element to the exponent 2^158 - 2^30 - 2^12 - 2^10 - 2^7 - 2^6 - 2^5 - 2^1 - 2^0
     *
     * Breaking up the exponent's binary representation into "repunits", we get: { 127 1s } { 1
     * 0s } { 17 1s } { 1 0s } { 1 1s } { 1 0s } { 2 1s } { 3 0s } { 3 1s } { 1 0s } { 1 1s }
     *
     * Therefore we need an Addition chain containing 1, 2, 3, 17, 127 (the lengths of the repunits)
     * We use: [1], [2], [3], 4, 7, 14, [17], 31, 62, 124, [127]
     */
    
    NSMutableArray *x1 = [self x];
    if ([Nat160 isZero:x1] || [Nat160 isOne:x1]) {
        return self;
    }
    
    SecP160R2FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *x2 = [Nat160 create];
        [SecP160R2Field square:x1 withZ:x2];
        [SecP160R2Field multiply:x2 withY:x1 withZ:x2];
        NSMutableArray *x3 = [Nat160 create];
        [SecP160R2Field square:x2 withZ:x3];
        [SecP160R2Field multiply:x3 withY:x1 withZ:x3];
        NSMutableArray *x4 = [Nat160 create];
        [SecP160R2Field square:x3 withZ:x4];
        [SecP160R2Field multiply:x4 withY:x1 withZ:x4];
        NSMutableArray *x7 = [Nat160 create];
        [SecP160R2Field squareN:x4 withN:3 withZ:x7];
        [SecP160R2Field multiply:x7 withY:x3 withZ:x7];
        NSMutableArray *x14 = x4;
        [SecP160R2Field squareN:x7 withN:7 withZ:x14];
        [SecP160R2Field multiply:x14 withY:x7 withZ:x14];
        NSMutableArray *x17 = x7;
        [SecP160R2Field squareN:x14 withN:3 withZ:x17];
        [SecP160R2Field multiply:x17 withY:x3 withZ:x17];
        NSMutableArray *x31 = [Nat160 create];
        [SecP160R2Field squareN:x17 withN:14 withZ:x31];
        [SecP160R2Field multiply:x31 withY:x14 withZ:x31];
        NSMutableArray *x62 = x14;
        [SecP160R2Field squareN:x31 withN:31 withZ:x62];
        [SecP160R2Field multiply:x62 withY:x31 withZ:x62];
        NSMutableArray *x124 = x31;
        [SecP160R2Field squareN:x62 withN:62 withZ:x124];
        [SecP160R2Field multiply:x124 withY:x62 withZ:x124];
        NSMutableArray *x127 = x62;
        [SecP160R2Field squareN:x124 withN:3 withZ:x127];
        [SecP160R2Field multiply:x127 withY:x3 withZ:x127];
        
        NSMutableArray *t1 = x127;
        [SecP160R2Field squareN:t1 withN:18 withZ:t1];
        [SecP160R2Field multiply:t1 withY:x17 withZ:t1];
        [SecP160R2Field squareN:t1 withN:2 withZ:t1];
        [SecP160R2Field multiply:t1 withY:x1 withZ:t1];
        [SecP160R2Field squareN:t1 withN:3 withZ:t1];
        [SecP160R2Field multiply:t1 withY:x2 withZ:t1];
        [SecP160R2Field squareN:t1 withN:6 withZ:t1];
        [SecP160R2Field multiply:t1 withY:x3 withZ:t1];
        [SecP160R2Field squareN:t1 withN:2 withZ:t1];
        [SecP160R2Field multiply:t1 withY:x1 withZ:t1];
        
        NSMutableArray *t2 = x2;
        [SecP160R2Field square:t1 withZ:t2];
        
        retVal = ([Nat160 eq:x1 withY:t2] ? [[SecP160R2FieldElement alloc] initWithUintArray:t1] : nil);
#if !__has_feature(objc_arc)
        if (x2) [x2 release]; x2 = nil;
        if (x3) [x3 release]; x3 = nil;
        if (x4) [x4 release]; x4 = nil;
        if (x7) [x7 release]; x7 = nil;
        if (x31) [x31 release]; x31 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP160R2FieldElement class]] ) {
        return [self equalsWithSecP160R2FieldElement:(SecP160R2FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP160R2FieldElement class]] ) {
        return [self equalsWithSecP160R2FieldElement:(SecP160R2FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP160R2FieldElement:(SecP160R2FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat160 eq:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP160R2FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:5];
}

@end

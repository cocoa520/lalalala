//
//  SecP521R1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP521R1FieldElement.h"
#import "BigInteger.h"
#import "SecP521R1Curve.h"
#import "SecP521R1Field.h"
#import "Nat.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP521R1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP521R1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP521R1Curve q] retain];
        }
    }
    return _q;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP521R1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP521R1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP521R1Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat create:17];
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
    return [Nat isZero:17 withX:[self x]];
}

- (BOOL)isOne {
    return [Nat isOne:17 withX:[self x]];
}

- (BOOL)testBitZero {
    return [Nat getBit:[self x] withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat toBigInteger:17 withX:[self x]];
}

- (NSString*)fieldName {
    return @"SecP521R1Field";
}

- (int)fieldSize {
    return [[SecP521R1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:17];
        [SecP521R1Field add:[self x] withY:[((SecP521R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP521R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:17];
        [SecP521R1Field addOne:[self x] withZ:z];
        retVal = [[SecP521R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:17];
        [SecP521R1Field subtract:[self x] withY:[((SecP521R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP521R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:17];
        [SecP521R1Field multiply:[self x] withY:[((SecP521R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP521R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:17];
        [Mod invert:[SecP521R1Field P] withX:[((SecP521R1FieldElement*)b) x] withZ:z];
        [SecP521R1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP521R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:17];
        [SecP521R1Field negate:[self x] withZ:z];
        retVal = [[SecP521R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:17];
        [SecP521R1Field square:[self x] withZ:z];
        retVal = [[SecP521R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:17];
        [Mod invert:[SecP521R1Field P] withX:[self x] withZ:z];
        retVal = [[SecP521R1FieldElement alloc] initWithUintArray:z];
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
    // Raise this element to the exponent 2^519
    
    NSMutableArray *x1 = [self x];
    if ([Nat isZero:17 withX:x1] || [Nat isOne:17 withX:x1]) {
        return self;
    }
    
    SecP521R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *t1 = [Nat create:17];
        NSMutableArray *t2 = [Nat create:17];
        
        [SecP521R1Field squareN:x1 withN:519 withZ:t1];
        [SecP521R1Field square:t1 withZ:t2];
        
        retVal = [Nat eq:17 withX:x1 withY:t2] ? [[SecP521R1FieldElement alloc] initWithUintArray:t1] : nil;
#if !__has_feature(objc_arc)
        if (t1) [t1 release]; t1 = nil;
        if (t2) [t2 release]; t2 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP521R1FieldElement class]] ) {
        return [self equalsWithSecP521R1FieldElement:(SecP521R1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP521R1FieldElement class]] ) {
        return [self equalsWithSecP521R1FieldElement:(SecP521R1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP521R1FieldElement:(SecP521R1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat eq:17 withX:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP521R1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:17];
}

@end

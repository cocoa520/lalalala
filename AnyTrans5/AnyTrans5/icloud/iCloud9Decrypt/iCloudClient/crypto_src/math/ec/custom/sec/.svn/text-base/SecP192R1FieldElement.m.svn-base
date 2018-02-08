//
//  SecP192R1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP192R1FieldElement.h"
#import "BigInteger.h"
#import "SecP192R1Curve.h"
#import "SecP192R1Field.h"
#import "Nat192.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP192R1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP192R1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP192R1Curve q] retain];
        }
    }
    return _q;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP192R1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP192R1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP192R1Field fromBigInteger:x]];
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
    return [Nat192 getBit:[self x] withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat192 toBigInteger:[self x]];
}

- (NSString*)fieldName {
    return @"SecP192R1Field";
}

- (int)fieldSize {
    return [[SecP192R1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192R1Field add:[self x] withY:[((SecP192R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP192R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192R1Field addOne:[self x] withZ:z];
        retVal = [[SecP192R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192R1Field subtract:[self x] withY:[((SecP192R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP192R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192R1Field multiply:[self x] withY:[((SecP192R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP192R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [Mod invert:[SecP192R1Field P] withX:[((SecP192R1FieldElement*)b) x] withZ:z];
        [SecP192R1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP192R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192R1Field negate:[self x] withZ:z];
        retVal = [[SecP192R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [SecP192R1Field square:[self x] withZ:z];
        retVal = [[SecP192R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create];
        [Mod invert:[SecP192R1Field P] withX:[self x] withZ:z];
        retVal = [[SecP192R1FieldElement alloc] initWithUintArray:z];
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
    // Raise this element to the exponent 2^190 - 2^62
    
    NSMutableArray *x1 = [self x];
    if ([Nat192 isZero:x1] || [Nat192 isOne:x1]) {
        return self;
    }
    
    SecP192R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *t1 = [Nat192 create];
        NSMutableArray *t2 = [Nat192 create];
        
        [SecP192R1Field square:x1 withZ:t1];
        [SecP192R1Field multiply:t1 withY:x1 withZ:t1];
        
        [SecP192R1Field squareN:t1 withN:2 withZ:t2];
        [SecP192R1Field multiply:t2 withY:t1 withZ:t2];
        
        [SecP192R1Field squareN:t2 withN:4 withZ:t1];
        [SecP192R1Field multiply:t1 withY:t2 withZ:t1];
        
        [SecP192R1Field squareN:t1 withN:8 withZ:t2];
        [SecP192R1Field multiply:t2 withY:t1 withZ:t2];
        
        [SecP192R1Field squareN:t2 withN:16 withZ:t1];
        [SecP192R1Field multiply:t1 withY:t2 withZ:t1];
        
        [SecP192R1Field squareN:t1 withN:32 withZ:t2];
        [SecP192R1Field multiply:t2 withY:t1 withZ:t2];
        
        [SecP192R1Field squareN:t2 withN:64 withZ:t1];
        [SecP192R1Field multiply:t1 withY:t2 withZ:t1];
        
        [SecP192R1Field squareN:t1 withN:62 withZ:t1];
        [SecP192R1Field square:t1 withZ:t2];
        
        retVal = ([Nat192 eq:x1 withY:t2] ? [[SecP192R1FieldElement alloc] initWithUintArray:t1] : nil);
#if !__has_feature(objc_arc)
        if (t1) [t1 release]; t1 = nil;
        if (t2) [t2 release]; t2 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP192R1FieldElement class]] ) {
        return [self equalsWithSecP192R1FieldElement:(SecP192R1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP192R1FieldElement class]] ) {
        return [self equalsWithSecP192R1FieldElement:(SecP192R1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP192R1FieldElement:(SecP192R1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat192 eq:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP192R1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:6];
}

@end

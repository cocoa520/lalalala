//
//  SecP256R1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP256R1FieldElement.h"
#import "BigInteger.h"
#import "SecP256R1Curve.h"
#import "SecP256R1Field.h"
#import "Nat256.h"
#import "Nat.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP256R1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP256R1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP256R1Curve q] retain];
        }
    }
    return _q;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP256R1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP256R1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP256R1Field fromBigInteger:x]];
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
    return @"SecP256R1Field";
}

- (int)fieldSize {
    return [[SecP256R1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256R1Field add:[self x] withY:[((SecP256R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP256R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256R1Field addOne:[self x] withZ:z];
        retVal = [[SecP256R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256R1Field subtract:[self x] withY:[((SecP256R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP256R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256R1Field multiply:[self x] withY:[((SecP256R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP256R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Mod invert:[SecP256R1Field P] withX:[((SecP256R1FieldElement*)b) x] withZ:z];
        [SecP256R1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP256R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256R1Field negate:[self x] withZ:z];
        retVal = [[SecP256R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [SecP256R1Field square:[self x] withZ:z];
        retVal = [[SecP256R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Mod invert:[SecP256R1Field P] withX:[self x] withZ:z];
        retVal = [[SecP256R1FieldElement alloc] initWithUintArray:z];
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
    // Raise this element to the exponent 2^254 - 2^222 + 2^190 + 2^94
    
    NSMutableArray *x1 = [self x];
    if ([Nat256 isZero:x1] || [Nat256 isOne:x1]) {
        return self;
    }
    
    SecP256R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *t1 = [Nat256 create];
        NSMutableArray *t2 = [Nat256 create];
        
        [SecP256R1Field square:x1 withZ:t1];
        [SecP256R1Field multiply:t1 withY:x1 withZ:t1];
        
        [SecP256R1Field squareN:t1 withN:2 withZ:t2];
        [SecP256R1Field multiply:t2 withY:t1 withZ:t2];
        
        [SecP256R1Field squareN:t2 withN:4 withZ:t1];
        [SecP256R1Field multiply:t1 withY:t2 withZ:t1];
        
        [SecP256R1Field squareN:t1 withN:8 withZ:t2];
        [SecP256R1Field multiply:t2 withY:t1 withZ:t2];
        
        [SecP256R1Field squareN:t2 withN:16 withZ:t1];
        [SecP256R1Field multiply:t1 withY:t2 withZ:t1];
        
        [SecP256R1Field squareN:t1 withN:32 withZ:t1];
        [SecP256R1Field multiply:t1 withY:x1 withZ:t1];
        
        [SecP256R1Field squareN:t1 withN:96 withZ:t1];
        [SecP256R1Field multiply:t1 withY:x1 withZ:t1];
        
        [SecP256R1Field squareN:t1 withN:94 withZ:t1];
        [SecP256R1Field multiply:t1 withY:t1 withZ:t2];
        
        retVal = ([Nat256 eq:x1 withY:t2] ? [[SecP256R1FieldElement alloc] initWithUintArray:t1] : nil);
#if !__has_feature(objc_arc)
        if (t1) [t1 release]; t1 = nil;
        if (t2) [t2 release]; t2 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP256R1FieldElement class]] ) {
        return [self equalsWithSecP256R1FieldElement:(SecP256R1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP256R1FieldElement class]] ) {
        return [self equalsWithSecP256R1FieldElement:(SecP256R1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP256R1FieldElement:(SecP256R1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat256 eq:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP256R1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:8];
}

@end

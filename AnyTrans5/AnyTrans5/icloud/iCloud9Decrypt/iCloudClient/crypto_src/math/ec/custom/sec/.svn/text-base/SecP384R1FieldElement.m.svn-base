//
//  SecP384R1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP384R1FieldElement.h"
#import "BigInteger.h"
#import "SecP384R1Curve.h"
#import "SecP384R1Field.h"
#import "Nat.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP384R1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP384R1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP384R1Curve q] retain];
        }
    }
    return _q;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP384R1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP384R1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP384R1Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat create:12];
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
    return [Nat isZero:12 withX:[self x]];
}

- (BOOL)isOne {
    return [Nat isOne:12 withX:[self x]];
}

- (BOOL)testBitZero {
    return [Nat getBit:[self x] withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat toBigInteger:12 withX:[self x]];
}

- (NSString*)fieldName {
    return @"SecP384R1Field";
}

- (int)fieldSize {
    return [[SecP384R1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:12];
        [SecP384R1Field add:[self x] withY:[((SecP384R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP384R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:12];
        [SecP384R1Field addOne:[self x] withZ:z];
        retVal = [[SecP384R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:12];
        [SecP384R1Field subtract:[self x] withY:[((SecP384R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP384R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:12];
        [SecP384R1Field multiply:[self x] withY:[((SecP384R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP384R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:12];
        [Mod invert:[SecP384R1Field P] withX:[((SecP384R1FieldElement*)b) x] withZ:z];
        [SecP384R1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP384R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:12];
        [SecP384R1Field negate:[self x] withZ:z];
        retVal = [[SecP384R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:12];
        [SecP384R1Field square:[self x] withZ:z];
        retVal = [[SecP384R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat create:12];
        [Mod invert:[SecP384R1Field P] withX:[self x] withZ:z];
        retVal = [[SecP384R1FieldElement alloc] initWithUintArray:z];
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
    // Raise this element to the exponent 2^382 - 2^126 - 2^94 + 2^30
    
    NSMutableArray *x1 = [self x];
    if ([Nat isZero:12 withX:x1] || [Nat isOne:12 withX:x1]) {
        return self;
    }
    
    SecP384R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *t1 = [Nat create:12];
        NSMutableArray *t2 = [Nat create:12];
        NSMutableArray *t3 = [Nat create:12];
        NSMutableArray *t4 = [Nat create:12];
        
        [SecP384R1Field square:x1 withZ:t1];
        [SecP384R1Field multiply:t1 withY:x1 withZ:t1];
        
        [SecP384R1Field squareN:t1 withN:2 withZ:t2];
        [SecP384R1Field multiply:t2 withY:t1 withZ:t2];
        
        [SecP384R1Field square:t2 withZ:t2];
        [SecP384R1Field multiply:t2 withY:x1 withZ:t2];
        
        [SecP384R1Field squareN:t2 withN:5 withZ:t3];
        [SecP384R1Field multiply:t3 withY:t2 withZ:t3];
        
        [SecP384R1Field squareN:t3 withN:5 withZ:t4];
        [SecP384R1Field multiply:t4 withY:t2 withZ:t4];
        
        [SecP384R1Field squareN:t4 withN:15 withZ:t2];
        [SecP384R1Field multiply:t2 withY:t4 withZ:t2];
        
        [SecP384R1Field squareN:t2 withN:2 withZ:t3];
        [SecP384R1Field multiply:t1 withY:t3 withZ:t1];
        
        [SecP384R1Field squareN:t3 withN:28 withZ:t3];
        [SecP384R1Field multiply:t2 withY:t3 withZ:t2];
        
        [SecP384R1Field squareN:t2 withN:60 withZ:t3];
        [SecP384R1Field multiply:t3 withY:t2 withZ:t3];
        
        NSMutableArray *r = t2;
        
        [SecP384R1Field squareN:t3 withN:120 withZ:r];
        [SecP384R1Field multiply:r withY:t3 withZ:r];
        
        [SecP384R1Field squareN:r withN:15 withZ:r];
        [SecP384R1Field multiply:r withY:t4 withZ:r];
        
        [SecP384R1Field squareN:r withN:33 withZ:r];
        [SecP384R1Field multiply:r withY:t1 withZ:r];
        
        [SecP384R1Field squareN:r withN:64 withZ:r];
        [SecP384R1Field multiply:r withY:x1 withZ:r];
        
        [SecP384R1Field squareN:r withN:30 withZ:t1];
        [SecP384R1Field square:t1 withZ:t2];
        
        retVal = [Nat eq:12 withX:x1 withY:t2] ? [[SecP384R1FieldElement alloc] initWithUintArray:t1] : nil;
#if !__has_feature(objc_arc)
        if (t1) [t1 release]; t1 = nil;
        if (t2) [t2 release]; t2 = nil;
        if (t3) [t3 release]; t3 = nil;
        if (t4) [t4 release]; t4 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP384R1FieldElement class]] ) {
        return [self equalsWithSecP384R1FieldElement:(SecP384R1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP384R1FieldElement class]] ) {
        return [self equalsWithSecP384R1FieldElement:(SecP384R1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP384R1FieldElement:(SecP384R1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat eq:12 withX:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP384R1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:12];
}

@end

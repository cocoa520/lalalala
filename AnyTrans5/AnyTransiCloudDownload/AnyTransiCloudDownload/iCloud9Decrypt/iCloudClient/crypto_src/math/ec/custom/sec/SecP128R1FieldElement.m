//
//  SecP128R1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP128R1FieldElement.h"
#import "BigInteger.h"
#import "SecP128R1Curve.h"
#import "SecP128R1Field.h"
#import "Nat128.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP128R1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP128R1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP128R1Curve q] retain];
        }
    }
    return _q;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP128R1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP128R1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP128R1Field fromBigInteger:x]];            
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat128 create];
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
    return [Nat128 isZero:self.x];
}

- (BOOL)isOne {
    return [Nat128 isOne:self.x];
}

- (BOOL)testBitZero {
    return [Nat128 getBit:self.x withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat128 toBigInteger:self.x];
}

- (NSString*)fieldName {
    return @"SecP128R1Field";
}

- (int)fieldSize {
    return [[SecP128R1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create];
        [SecP128R1Field add:self.x withY:((SecP128R1FieldElement*)b).x withZ:z];
        retVal = [[SecP128R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create];
        [SecP128R1Field addOne:self.x withZ:z];
        retVal = [[SecP128R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create];
        [SecP128R1Field subtract:self.x withY:((SecP128R1FieldElement*)b).x withZ:z];
        retVal = [[SecP128R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create];
        [SecP128R1Field multiply:self.x withY:((SecP128R1FieldElement*)b).x withZ:z];
        retVal = [[SecP128R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create];
        [Mod invert:[SecP128R1Field P] withX:((SecP128R1FieldElement*)b).x withZ:z];
        [SecP128R1Field multiply:z withY:self.x withZ:z];
        retVal = [[SecP128R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create];
        [SecP128R1Field negate:self.x withZ:z];
        retVal = [[SecP128R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create];
        [SecP128R1Field square:self.x withZ:z];
        retVal = [[SecP128R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create];
        [Mod invert:[SecP128R1Field P] withX:self.x withZ:z];
        retVal = [[SecP128R1FieldElement alloc] initWithUintArray:z];
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
     * Raise this element to the exponent 2^126 - 2^95
     *
     * Breaking up the exponent's binary representation into "repunits", we get:
     *     { 31 1s } { 95 0s }
     *
     * Therefore we need an addition chain containing 31 (the length of the repunit) We use:
     *     1, 2, 4, 8, 10, 20, 30, [31]
     */
    
    NSMutableArray *x1 = self.x;
    if ([Nat128 isZero:x1] || [Nat128 isOne:x1]) {
        return self;
    }
    
    SecP128R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *x2 = [Nat128 create];
        [SecP128R1Field square:x1 withZ:x2];
        [SecP128R1Field multiply:x2 withY:x1 withZ:x2];
        NSMutableArray *x4 = [Nat128 create];
        [SecP128R1Field squareN:x2 withN:2 withZ:x4];
        [SecP128R1Field multiply:x4 withY:x2 withZ:x4];
        NSMutableArray *x8 = [Nat128 create];
        [SecP128R1Field squareN:x4 withN:4 withZ:x8];
        [SecP128R1Field multiply:x8 withY:x4 withZ:x8];
        NSMutableArray *x10 = x4;
        [SecP128R1Field squareN:x8 withN:2 withZ:x10];
        [SecP128R1Field multiply:x10 withY:x2 withZ:x10];
        NSMutableArray *x20 = x2;
        [SecP128R1Field squareN:x10 withN:10 withZ:x20];
        [SecP128R1Field multiply:x20 withY:x10 withZ:x20];
        NSMutableArray *x30 = x8;
        [SecP128R1Field squareN:x20 withN:10 withZ:x30];
        [SecP128R1Field multiply:x30 withY:x10 withZ:x30];
        NSMutableArray *x31 = x10;
        [SecP128R1Field square:x30 withZ:x31];
        [SecP128R1Field multiply:x31 withY:x1 withZ:x31];
        
        NSMutableArray *t1 = x31;
        [SecP128R1Field squareN:t1 withN:95 withZ:t1];
        
        NSMutableArray *t2 = x30;
        [SecP128R1Field square:t1 withZ:t2];
        
        retVal = ([Nat128 eq:x1 withY:t2] ? [[SecP128R1FieldElement alloc] initWithUintArray:t1] : nil);
#if !__has_feature(objc_arc)
        if (x2) [x2 release]; x2 = nil;
        if (x4) [x4 release]; x4 = nil;
        if (x8) [x8 release]; x8 = nil;
#endif
        
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP128R1FieldElement class]] ) {
        return [self equalsWithSecP128R1FieldElement:(SecP128R1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP128R1FieldElement class]] ) {
        return [self equalsWithSecP128R1FieldElement:(SecP128R1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP128R1FieldElement:(SecP128R1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat128 eq:self.x withY:other.x];
}

- (NSUInteger)hash {
    return [[SecP128R1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:self.x withOff:0 withLen:4];
}

@end

//
//  SecP160R1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP160R1FieldElement.h"
#import "BigInteger.h"
#import "SecP160R1Curve.h"
#import "SecP160R1Field.h"
#import "Nat160.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP160R1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP160R1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP160R1Curve q] retain];
        }
    }
    return _q;

}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP160R1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP160R1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP160R1Field fromBigInteger:x]];            
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        NSMutableArray *tmpArray = [Nat160 create];
        [self setX:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
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
    return [Nat160 isZero:self.x];
}

- (BOOL)isOne {
    return [Nat160 isOne:self.x];
}

- (BOOL)testBitZero {
    return [Nat160 getBit:self.x withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat160 toBigInteger:self.x];
}

- (NSString*)fieldName {
    return @"SecP160R1Field";
}

- (int)fieldSize {
    return [[SecP160R1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        
        [SecP160R1Field add:[self x] withY:[((SecP160R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP160R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R1Field addOne:[self x] withZ:z];
        retVal = [[SecP160R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R1Field subtract:[self x] withY:[((SecP160R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP160R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R1Field multiply:[self x] withY:[((SecP160R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP160R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
        
    }
    return retVal;
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [Mod invert:[SecP160R1Field P] withX:[((SecP160R1FieldElement*)b) x] withZ:z];
        [SecP160R1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP160R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R1Field negate:[self x] withZ:z];
        retVal = [[SecP160R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [SecP160R1Field square:[self x] withZ:z];
        retVal = [[SecP160R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat160 create];
        [Mod invert:[SecP160R1Field P] withX:[self x] withZ:z];
        retVal = [[SecP160R1FieldElement alloc] initWithUintArray:z];
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
     * Raise this element to the exponent 2^158 - 2^29
     *
     * Breaking up the exponent's binary representation into "repunits", we get:
     *     { 129 1s } { 29 0s }
     *
     * Therefore we need an addition chain containing 129 (the length of the repunit) We use:
     *     1, 2, 4, 8, 16, 32, 64, 128, [129]
     */
    
    NSMutableArray *x1 = [self x];
    if ([Nat160 isZero:x1] || [Nat160 isOne:x1]) {
        return self;
    }
    
    SecP160R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *x2 = [Nat160 create];
        [SecP160R1Field square:x1 withZ:x2];
        [SecP160R1Field multiply:x2 withY:x1 withZ:x2];
        NSMutableArray *x4 = [Nat160 create];
        [SecP160R1Field squareN:x2 withN:2 withZ:x4];
        [SecP160R1Field multiply:x4 withY:x2 withZ:x4];
        NSMutableArray *x8 = x2;
        [SecP160R1Field squareN:x4 withN:4 withZ:x8];
        [SecP160R1Field multiply:x8 withY:x4 withZ:x8];
        NSMutableArray *x16 = x4;
        [SecP160R1Field squareN:x8 withN:8 withZ:x16];
        [SecP160R1Field multiply:x16 withY:x8 withZ:x16];
        NSMutableArray *x32 = x8;
        [SecP160R1Field squareN:x16 withN:16 withZ:x32];
        [SecP160R1Field multiply:x32 withY:x16 withZ:x32];
        NSMutableArray *x64 = x16;
        [SecP160R1Field squareN:x32 withN:32 withZ:x64];
        [SecP160R1Field multiply:x64 withY:x32 withZ:x64];
        NSMutableArray *x128 = x32;
        [SecP160R1Field squareN:x64 withN:64 withZ:x128];
        [SecP160R1Field multiply:x128 withY:x64 withZ:x128];
        NSMutableArray *x129 = x64;
        [SecP160R1Field square:x128 withZ:x129];
        [SecP160R1Field multiply:x129 withY:x1 withZ:x129];
        
        NSMutableArray *t1 = x129;
        [SecP160R1Field squareN:t1 withN:29 withZ:t1];
        
        NSMutableArray *t2 = x128;
        [SecP160R1Field square:t1 withZ:t2];
        
        retVal = ([Nat160 eq:x1 withY:t2] ? [[SecP160R1FieldElement alloc] initWithUintArray:t1] : nil);
#if !__has_feature(objc_arc)
        if (x2) [x2 release]; x2 = nil;
        if (x4) [x4 release]; x4 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP160R1FieldElement class]] ) {
        return [self equalsWithSecP160R1FieldElement:(SecP160R1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP160R1FieldElement class]] ) {
        return [self equalsWithSecP160R1FieldElement:(SecP160R1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP160R1FieldElement:(SecP160R1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat160 eq:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return  [[SecP160R1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:5];
}

@end

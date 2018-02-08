//
//  SecT113FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT113FieldElement.h"
#import "BigInteger.h"
#import "SecT113R1Curve.h"
#import "SecT113Field.h"
#import "Nat128.h"
#import "Mod.h"
#import "ECFieldElement.h"
#import "Arrays.h"

@interface SecT113FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecT113FieldElement
@synthesize x = _x;

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x bitLength] > 113) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecT113FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecT113Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat128 create64];
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

- (BOOL)isOne {
    return [Nat128 isOne64:[self x]];
}

- (BOOL)isZero {
    return [Nat128 isZero64:[self x]];
}

- (BOOL)testBitZero {
    return ([[self x][0] unsignedLongLongValue] & 1L) != 0L;
}

- (BigInteger*)toBigInteger {
    return [Nat128 toBigInteger64:[self x]];
}

- (NSString*)fieldName {
    return @"SecT113Field";
}

- (int)fieldSize {
    return 113;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field add:[self x] withY:[((SecT113FieldElement*)b) x] withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field addOne:[self x] withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    // Addition and Subtraction are the same in F2m
    return [self add:b];
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field multiply:[self x] withY:[((SecT113FieldElement*)b) x] withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiplyMinusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    return [self multiplyPlusProduct:b withX:x withY:y];
}

- (ECFieldElement*)multiplyPlusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x], *bx = [((SecT113FieldElement*)b) x];
        NSMutableArray *xx = [((SecT113FieldElement*)x) x], *yx = [((SecT113FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat128 createExt64];
        [SecT113Field multiplyAddToExt:ax withY:bx withZZ:tt];
        [SecT113Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field reduce:tt withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
        if (tt) [tt release]; tt = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    return [self multiply:[b invert]];
}

- (ECFieldElement*)negate {
    return self;
}

- (ECFieldElement*)square {
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field square:[self x] withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)squareMinusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y {
    return [self squarePlusProduct:x withY:y];
}

- (ECFieldElement*)squarePlusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y {
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x];
        NSMutableArray *xx = [((SecT113FieldElement*)x) x], *yx = [((SecT113FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat128 createExt64];
        [SecT113Field squareAddToExt:ax withZZ:tt];
        [SecT113Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field reduce:tt withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
        if (tt) [tt release]; tt = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)squarePow:(int)pow {
    if (pow < 1) {
        return self;
    }
    
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field squareN:[self x] withN:pow withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field invert:[self x] withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)sqrt {
    SecT113FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat128 create64];
        [SecT113Field sqrt:[self x] withZ:z];
        retVal = [[SecT113FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (int)representation {
    return Tpb;
}

- (int)M {
    return 113;
}

- (int)K1 {
    return 9;
}

- (int)K2 {
    return 0;
}

- (int)K3 {
    return 0;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecT113FieldElement class]] ) {
        return [self equalsWithSecT113FieldElement:(SecT113FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement *)other {
    if (other != nil && [other isKindOfClass:[SecT113FieldElement class]] ) {
        return [self equalsWithSecT113FieldElement:(SecT113FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecT113FieldElement:(SecT113FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat128 eq64:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return 113009 ^ [Arrays getHashCodeWithUInt64Array:[self x] withOff:0 withLen:2];
}

@end

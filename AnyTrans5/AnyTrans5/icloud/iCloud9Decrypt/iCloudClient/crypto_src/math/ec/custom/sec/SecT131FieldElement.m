//
//  SecT131FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT131FieldElement.h"
#import "BigInteger.h"
#import "SecT131Field.h"
#import "Nat192.h"
#import "Nat.h"
#import "Arrays.h"

@interface SecT131FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecT131FieldElement
@synthesize x = _x;

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x bitLength] > 131) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecT131FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecT131Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat192 create64];
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
    return [Nat192 isOne64:[self x]];
}

- (BOOL)isZero {
    return [Nat192 isZero64:[self x]];
}

- (BOOL)testBitZero {
    return ([[self x][0] unsignedLongLongValue] & 1UL) != 0UL;
}

- (BigInteger*)toBigInteger {
    return [Nat192 toBigInteger64:[self x]];
}

- (NSString*)fieldName {
    return @"SecT131Field";
}

- (int)fieldSize {
    return 131;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field add:[self x] withY:[((SecT131FieldElement*)b) x] withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field addOne:[self x] withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
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
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field multiply:[self x] withY:[((SecT131FieldElement*)b) x] withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
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
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x], *bx = [((SecT131FieldElement*)b) x];
        NSMutableArray *xx = [((SecT131FieldElement*)x) x], *yx = [((SecT131FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat create64:5];
        [SecT131Field multiplyAddToExt:ax withY:bx withZZ:tt];
        [SecT131Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field reduce:tt withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
        if (tt) [tt release]; tt = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [self multiply:[b invert]];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    return self;
}

- (ECFieldElement*)square {
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field square:[self x] withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
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
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x];
        NSMutableArray *xx = [((SecT131FieldElement*)x) x], *yx = [((SecT131FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat create64:5];
        [SecT131Field squareAddToExt:ax withZZ:tt];
        [SecT131Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field reduce:tt withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
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
    
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field squareN:[self x] withN:pow withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field invert:[self x] withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)sqrt {
    SecT131FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT131Field sqrt:[self x] withZ:z];
        retVal = [[SecT131FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (int)representation {
    return Ppb;
}

- (int)M {
    return 131;
}

- (int)K1 {
    return 2;
}

- (int)K2 {
    return 3;
}

- (int)K3 {
    return 8;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecT131FieldElement class]] ) {
        return [self equalsWithSecT131FieldElement:(SecT131FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement *)other {
    if (other != nil && [other isKindOfClass:[SecT131FieldElement class]] ) {
        return [self equalsWithSecT131FieldElement:(SecT131FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecT131FieldElement:(SecT131FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat192 eq64:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return 131832 ^ [Arrays getHashCodeWithUInt64Array:[self x] withOff:0 withLen:3];
}

@end

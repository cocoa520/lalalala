//
//  SecT571FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT571FieldElement.h"
#import "BigInteger.h"
#import "SecT571Field.h"
#import "Nat576.h"
#import "Nat.h"
#import "Arrays.h"

@interface SecT571FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecT571FieldElement
@synthesize x = _x;

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x bitLength] > 571) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecT571FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecT571Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat576 create64];
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
    return [Nat576 isOne64:[self x]];
}

- (BOOL)isZero {
    return [Nat576 isZero64:[self x]];
}

- (BOOL)testBitZero {
    return ([[self x][0] unsignedLongLongValue] & 1UL) != 0UL;
}

- (BigInteger*)toBigInteger {
    return [Nat576 toBigInteger64:[self x]];
}

- (NSString*)fieldName {
    return @"SecT571Field";
}

- (int)fieldSize {
    return 571;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field add:[self x] withY:[((SecT571FieldElement*)b) x] withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field addOne:[self x] withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
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
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field multiply:[self x] withY:[((SecT571FieldElement*)b) x] withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
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
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x], *bx = [((SecT571FieldElement*)b) x];
        NSMutableArray *xx = [((SecT571FieldElement*)x) x], *yx = [((SecT571FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat576 createExt64];
        [SecT571Field multiplyAddToExt:ax withY:bx withZZ:tt];
        [SecT571Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field reduce:tt withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
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
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field square:[self x] withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
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
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x];
        NSMutableArray *xx = [((SecT571FieldElement*)x) x], *yx = [((SecT571FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat576 createExt64];
        [SecT571Field squareAddToExt:ax withZZ:tt];
        [SecT571Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field reduce:tt withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
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
    
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field squareN:[self x] withN:pow withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field invert:[self x] withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)sqrt {
    SecT571FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat576 create64];
        [SecT571Field sqrt:[self x] withZ:z];
        retVal = [[SecT571FieldElement alloc] initWithUintArray:z];
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
    return 571;
}

- (int)K1 {
    return 2;
}

- (int)K2 {
    return 5;
}

- (int)K3 {
    return 10;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecT571FieldElement class]] ) {
        return [self equalsWithSecT571FieldElement:(SecT571FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecT571FieldElement class]] ) {
        return [self equalsWithSecT571FieldElement:(SecT571FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecT571FieldElement:(SecT571FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat576 eq64:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return 5711052 ^ [Arrays getHashCodeWithUInt64Array:[self x] withOff:0 withLen:9];
}

@end

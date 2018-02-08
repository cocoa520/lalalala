//
//  SecT283FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT283FieldElement.h"
#import "BigInteger.h"
#import "SecT283Field.h"
#import "Nat320.h"
#import "Nat.h"
#import "Arrays.h"

@interface SecT283FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecT283FieldElement
@synthesize x = _x;

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x bitLength] > 283) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecT283FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecT283Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat320 create64];
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
    return [Nat320 isOne64:[self x]];
}

- (BOOL)isZero {
    return [Nat320 isZero64:[self x]];
}

- (BOOL)testBitZero {
    return ([[self x][0] unsignedLongLongValue] & 1UL) != 0UL;
}

- (BigInteger*)toBigInteger {
    return [Nat320 toBigInteger64:[self x]];
}

- (NSString*)fieldName {
    return @"SecT283Field";
}

- (int)fieldSize {
    return 283;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field add:[self x] withY:[((SecT283FieldElement*)b) x] withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field addOne:[self x] withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
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
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field multiply:[self x] withY:[((SecT283FieldElement*)b) x] withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
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
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x], *bx = [((SecT283FieldElement*)b) x];
        NSMutableArray *xx = [((SecT283FieldElement*)x) x], *yx = [((SecT283FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat create64:9];
        [SecT283Field multiplyAddToExt:ax withY:bx withZZ:tt];
        [SecT283Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field reduce:tt withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
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
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field square:[self x] withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
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
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x];
        NSMutableArray *xx = [((SecT283FieldElement*)x) x], *yx = [((SecT283FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat create64:9];
        [SecT283Field squareAddToExt:ax withZZ:tt];
        [SecT283Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field reduce:tt withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
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
    
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field squareN:[self x] withN:pow withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field invert:[self x] withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)sqrt {
    SecT283FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat320 create64];
        [SecT283Field sqrt:[self x] withZ:z];
        retVal = [[SecT283FieldElement alloc] initWithUintArray:z];
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
    return 283;
}

- (int)K1 {
    return 5;
}

- (int)K2 {
    return 7;
}

- (int)K3 {
    return 12;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecT283FieldElement class]] ) {
        return [self equalsWithSecT283FieldElement:(SecT283FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecT283FieldElement class]] ) {
        return [self equalsWithSecT283FieldElement:(SecT283FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecT283FieldElement:(SecT283FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat320 eq64:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return 2831275 ^ [Arrays getHashCodeWithUInt64Array:[self x] withOff:0 withLen:5];
}

@end

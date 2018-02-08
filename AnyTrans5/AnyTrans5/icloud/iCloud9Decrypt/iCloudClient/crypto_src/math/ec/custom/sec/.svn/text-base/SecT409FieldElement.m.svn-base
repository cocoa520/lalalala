//
//  SecT409FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT409FieldElement.h"
#import "BigInteger.h"
#import "SecT409Field.h"
#import "Nat448.h"
#import "Nat.h"
#import "Arrays.h"

@interface SecT409FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecT409FieldElement
@synthesize x = _x;

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x bitLength] > 409) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecT409FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecT409Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat448 create64];
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
    return [Nat448 isOne64:[self x]];
}

- (BOOL)isZero {
    return [Nat448 isZero64:[self x]];
}

- (BOOL)testBitZero {
    return ([[self x][0] unsignedLongLongValue] & 1UL) != 0UL;
}

- (BigInteger*)toBigInteger {
    return [Nat448 toBigInteger64:[self x]];
}

- (NSString*)fieldName {
    return @"SecT409Field";
}

- (int)fieldSize {
    return 409;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field add:[self x] withY:[((SecT409FieldElement*)b) x] withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field addOne:[self x] withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
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
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field multiply:[self x] withY:[((SecT409FieldElement*)b) x] withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
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
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x], *bx = [((SecT409FieldElement*)b) x];
        NSMutableArray *xx = [((SecT409FieldElement*)x) x], *yx = [((SecT409FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat create64:13];
        [SecT409Field multiplyAddToExt:ax withY:bx withZZ:tt];
        [SecT409Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field reduce:tt withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
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
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field square:[self x] withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
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
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x];
        NSMutableArray *xx = [((SecT409FieldElement*)x) x], *yx = [((SecT409FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat create64:13];
        [SecT409Field squareAddToExt:ax withZZ:tt];
        [SecT409Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field reduce:tt withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
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
    
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field squareN:[self x] withN:pow withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field invert:[self x] withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)sqrt {
    SecT409FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat448 create64];
        [SecT409Field sqrt:[self x] withZ:z];
        retVal = [[SecT409FieldElement alloc] initWithUintArray:z];
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
    return 409;
}

- (int)K1 {
    return 87;
}

- (int)K2 {
    return 0;
}

- (int)K3 {
    return 0;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecT409FieldElement class]] ) {
        return [self equalsWithSecT409FieldElement:(SecT409FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecT409FieldElement class]] ) {
        return [self equalsWithSecT409FieldElement:(SecT409FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecT409FieldElement:(SecT409FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat448 eq64:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return 4090087 ^ [Arrays getHashCodeWithUInt64Array:[self x] withOff:0 withLen:7];
}

@end

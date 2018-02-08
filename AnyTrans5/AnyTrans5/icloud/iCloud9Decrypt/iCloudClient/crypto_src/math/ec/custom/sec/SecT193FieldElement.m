//
//  SecT193FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT193FieldElement.h"
#import "BigInteger.h"
#import "SecT193Field.h"
#import "Nat256.h"
#import "Arrays.h"

@interface SecT193FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecT193FieldElement
@synthesize x = _x;

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x bitLength] > 193) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecT193FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecT193Field fromBigInteger:x]];            
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat256 create64];
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
    return [Nat256 isOne64:[self x]];
}

- (BOOL)isZero {
    return [Nat256 isZero64:[self x]];
}

- (BOOL)testBitZero {
    return ([[self x][0] unsignedLongLongValue] & 1UL) != 0UL;
}

- (BigInteger*)toBigInteger {
    return [Nat256 toBigInteger64:[self x]];
}

- (NSString*)fieldName {
    return @"SecT193Field";
}

- (int)fieldSize {
    return 193;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field add:[self x] withY:[((SecT193FieldElement*)b) x] withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field addOne:[self x] withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
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
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field multiply:[self x] withY:[((SecT193FieldElement*)b) x] withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
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
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x], *bx = [((SecT193FieldElement*)b) x];
        NSMutableArray *xx = [((SecT193FieldElement*)x) x], *yx = [((SecT193FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT193Field multiplyAddToExt:ax withY:bx withZZ:tt];
        [SecT193Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field reduce:tt withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
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
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field square:[self x] withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
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
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x];
        NSMutableArray *xx = [((SecT193FieldElement*)x) x], *yx = [((SecT193FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT193Field squareAddToExt:ax withZZ:tt];
        [SecT193Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field reduce:tt withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
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
    
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field squareN:[self x] withN:pow withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field invert:[self x] withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)sqrt {
    SecT193FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT193Field sqrt:[self x] withZ:z];
        retVal = [[SecT193FieldElement alloc] initWithUintArray:z];
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
    return 193;
}

- (int)K1 {
    return 15;
}

- (int)K2 {
    return 0;
}

- (int)K3 {
    return 0;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecT193FieldElement class]] ) {
        return [self equalsWithSecT193FieldElement:(SecT193FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement *)other {
    if (other != nil && [other isKindOfClass:[SecT193FieldElement class]] ) {
        return [self equalsWithSecT193FieldElement:(SecT193FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecT193FieldElement:(SecT193FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat256 eq64:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return 1930015 ^ [Arrays getHashCodeWithUInt64Array:[self x] withOff:0 withLen:4];
}

@end

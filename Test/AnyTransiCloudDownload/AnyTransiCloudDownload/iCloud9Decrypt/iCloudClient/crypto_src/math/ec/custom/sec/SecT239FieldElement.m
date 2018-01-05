//
//  SecT239FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT239FieldElement.h"
#import "BigInteger.h"
#import "SecT239Field.h"
#import "Nat256.h"
#import "Arrays.h"

@interface SecT239FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecT239FieldElement
@synthesize x = _x;

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x bitLength] > 239) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecT239FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecT239Field fromBigInteger:x]];
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
    return ([[self x][0] unsignedLongLongValue] & 1L) != 0L;
}

- (BigInteger*)toBigInteger {
    return [Nat256 toBigInteger64:[self x]];
}

- (NSString*)fieldName {
    return @"SecT239Field";
}

- (int)fieldSize {
    return 239;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field add:[self x] withY:[((SecT239FieldElement*)b) x] withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field addOne:[self x] withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
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
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field multiply:[self x] withY:[((SecT239FieldElement*)b) x] withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
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
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x], *bx = [((SecT239FieldElement*)b) x];
        NSMutableArray *xx = [((SecT239FieldElement*)x) x], *yx = [((SecT239FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT239Field multiplyAddToExt:ax withY:bx withZZ:tt];
        [SecT239Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field reduce:tt withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
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
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field square:[self x] withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
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
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x];
        NSMutableArray *xx = [((SecT239FieldElement*)x) x], *yx = [((SecT239FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat256 createExt64];
        [SecT239Field squareAddToExt:ax withZZ:tt];
        [SecT239Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field reduce:tt withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
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
    
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field squareN:[self x] withN:pow withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field invert:[self x] withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)sqrt {
    SecT239FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create64];
        [SecT239Field sqrt:[self x] withZ:z];
        retVal = [[SecT239FieldElement alloc] initWithUintArray:z];
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
    return 239;
}

- (int)K1 {
    return 158;
}

- (int)K2 {
    return 0;
}

- (int)K3 {
    return 0;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecT239FieldElement class]] ) {
        return [self equalsWithSecT239FieldElement:(SecT239FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement *)other {
    if (other != nil && [other isKindOfClass:[SecT239FieldElement class]] ) {
        return [self equalsWithSecT239FieldElement:(SecT239FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecT239FieldElement:(SecT239FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat256 eq64:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return 23900158 ^ [Arrays getHashCodeWithUInt64Array:[self x] withOff:0 withLen:4];
}

@end

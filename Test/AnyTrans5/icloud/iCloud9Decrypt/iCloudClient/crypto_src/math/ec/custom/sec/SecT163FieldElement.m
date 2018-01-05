//
//  SecT163FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT163FieldElement.h"
#import "BigInteger.h"
#import "SecT163Field.h"
#import "Nat192.h"
#import "Arrays.h"

@interface SecT163FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecT163FieldElement
@synthesize x = _x;

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x bitLength] > 163) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecT163FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecT163Field fromBigInteger:x]];
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
    return ([[self x][0] unsignedLongLongValue] & 1L) != 0L;
}

- (BigInteger*)toBigInteger {
    return [Nat192 toBigInteger64:[self x]];
}

- (NSString*)fieldName {
    return @"SecT163Field";
}

- (int)fieldSize {
    return 163;
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field add:[self x] withY:[((SecT163FieldElement*)b) x] withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field addOne:[self x] withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
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
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field multiply:[self x] withY:[((SecT163FieldElement*)b) x] withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
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
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x], *bx = [((SecT163FieldElement*)b) x];
        NSMutableArray *xx = [((SecT163FieldElement*)x) x], *yx = [((SecT163FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat192 createExt64];
        [SecT163Field multiplyAddToExt:ax withY:bx withZZ:tt];
        [SecT163Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field reduce:tt withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
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
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field square:[self x] withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
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
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ax = [self x];
        NSMutableArray *xx = [((SecT163FieldElement*)x) x], *yx = [((SecT163FieldElement*)y) x];
        
        NSMutableArray *tt = [Nat192 createExt64];
        [SecT163Field squareAddToExt:ax withZZ:tt];
        [SecT163Field multiplyAddToExt:xx withY:yx withZZ:tt];
        
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field reduce:tt withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
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
    
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field squareN:[self x] withN:pow withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field invert:[self x] withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)sqrt {
    SecT163FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat192 create64];
        [SecT163Field sqrt:[self x] withZ:z];
        retVal = [[SecT163FieldElement alloc] initWithUintArray:z];
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
    return 163;
}

- (int)K1 {
    return 3;
}

- (int)K2 {
    return 6;
}

- (int)K3 {
    return 7;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecT163FieldElement class]] ) {
        return [self equalsWithSecT163FieldElement:(SecT163FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement *)other {
    if (other != nil && [other isKindOfClass:[SecT163FieldElement class]] ) {
        return [self equalsWithSecT163FieldElement:(SecT163FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecT163FieldElement:(SecT163FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat192 eq64:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return 163763 ^ [Arrays getHashCodeWithUInt64Array:[self x] withOff:0 withLen:3];
}

@end

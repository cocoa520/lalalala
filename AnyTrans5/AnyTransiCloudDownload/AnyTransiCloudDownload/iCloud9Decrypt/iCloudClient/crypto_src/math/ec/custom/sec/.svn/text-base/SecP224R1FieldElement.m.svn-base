//
//  SecP224R1FieldElement.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP224R1FieldElement.h"
#import "BigInteger.h"
#import "SecP224R1Curve.h"
#import "SecP224R1Field.h"
#import "Nat224.h"
#import "Nat.h"
#import "Mod.h"
#import "Arrays.h"

@interface SecP224R1FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation SecP224R1FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP224R1Curve q] retain];
        }
    }
    return _q;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[SecP224R1FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for SecP224R1FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[SecP224R1Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat224 create];
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
    return [Nat224 isZero:[self x]];
}

- (BOOL)isOne {
    return [Nat224 isOne:[self x]];
}

- (BOOL)testBitZero {
    return [Nat224 getBit:[self x] withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat224 toBigInteger:[self x]];
}

- (NSString*)fieldName {
    return @"SecP224R1Field";
}

- (int)fieldSize {
    return [[SecP224R1FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    SecP224R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224R1Field add:[self x] withY:[((SecP224R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP224R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    SecP224R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224R1Field addOne:[self x] withZ:z];
        retVal = [[SecP224R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    SecP224R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224R1Field subtract:[self x] withY:[((SecP224R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP224R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    SecP224R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224R1Field multiply:[self x] withY:[((SecP224R1FieldElement*)b) x] withZ:z];
        retVal = [[SecP224R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    SecP224R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [Mod invert:[SecP224R1Field P] withX:[((SecP224R1FieldElement*)b) x] withZ:z];
        [SecP224R1Field multiply:z withY:[self x] withZ:z];
        retVal = [[SecP224R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    SecP224R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224R1Field negate:[self x] withZ:z];
        retVal = [[SecP224R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    SecP224R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [SecP224R1Field square:[self x] withZ:z];
        retVal = [[SecP224R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    SecP224R1FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat224 create];
        [Mod invert:[SecP224R1Field P] withX:[self x] withZ:z];
        retVal = [[SecP224R1FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * return a sqrt root - the routine verifies that the calculation returns the right value - if
 * none exists it returns null.
 */
- (ECFieldElement*)sqrt {
    NSMutableArray *c = [self x];
    if ([Nat224 isZero:c] || [Nat224 isOne:c]) {
        return self;
    }
    
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *nc = [Nat224 create];
        [SecP224R1Field negate:c withZ:nc];
        
        NSMutableArray *r = [Mod random:[SecP224R1Field P]];
        NSMutableArray *t = [Nat224 create];
        
        if ([SecP224R1FieldElement isSquare:c]) {
            while (![SecP224R1FieldElement trySqrt:nc withR:r withT:t]) {
                [SecP224R1Field addOne:r withZ:r];
            }
            
            [SecP224R1Field square:t withZ:r];
            
            retVal = ([Nat224 eq:c withY:r] ? [[SecP224R1FieldElement alloc] initWithUintArray:t] : nil);
        }
#if !__has_feature(objc_arc)
        if (nc) [nc release]; nc = nil;
        if (t) [t release]; t = nil;
#endif
    }
    
    return retVal;
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[SecP224R1FieldElement class]] ) {
        return [self equalsWithSecP224R1FieldElement:(SecP224R1FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[SecP224R1FieldElement class]] ) {
        return [self equalsWithSecP224R1FieldElement:(SecP224R1FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithSecP224R1FieldElement:(SecP224R1FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat224 eq:[self x] withY:[other x]];
}

- (NSUInteger)hash {
    return [[SecP224R1FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:[self x] withOff:0 withLen:7];
}

// NSMutableArray = uint[]
+ (BOOL)isSquare:(NSMutableArray*)x {
    BOOL retVal = NO;
    @autoreleasepool {
        NSMutableArray *t1 = [Nat224 create];
        NSMutableArray *t2 = [Nat224 create];
        [Nat224 copy:x withZ:t1];
        
        for (int i = 0; i < 7; ++i) {
            [Nat224 copy:t1 withZ:t2];
            [SecP224R1Field squareN:t1 withN:(1 << i) withZ:t1];
            [SecP224R1Field multiply:t1 withY:t2 withZ:t1];
        }
        
        [SecP224R1Field squareN:t1 withN:95 withZ:t1];
        retVal = [Nat224 isOne:t1];
#if !__has_feature(objc_arc)
        if (t1) [t1 release]; t1 = nil;
        if (t2) [t2 release]; t2 = nil;
#endif
    }
    return retVal;
}

// NSMutableArray = uint[]
+ (void)rm:(NSMutableArray*)nc withD0:(NSMutableArray*)d0 withE0:(NSMutableArray*)e0 withD1:(NSMutableArray*)d1 withE1:(NSMutableArray*)e1 withF1:(NSMutableArray*)f1 withT:(NSMutableArray*)t {
    @autoreleasepool {
        [SecP224R1Field multiply:e1 withY:e0 withZ:t];
        [SecP224R1Field multiply:t withY:nc withZ:t];
        [SecP224R1Field multiply:d1 withY:d0 withZ:f1];
        [SecP224R1Field add:f1 withY:t withZ:f1];
        [SecP224R1Field multiply:d1 withY:e0 withZ:t];
        [Nat224 copy:f1 withZ:d1];
        [SecP224R1Field multiply:e1 withY:d0 withZ:e1];
        [SecP224R1Field add:e1 withY:t withZ:e1];
        [SecP224R1Field square:e1 withZ:f1];
        [SecP224R1Field multiply:f1 withY:nc withZ:f1];
    }
}

// NSMutableArray = uint[]
+ (void)rp:(NSMutableArray*)nc withD1:(NSMutableArray*)d1 withE1:(NSMutableArray*)e1 withF1:(NSMutableArray*)f1 withT:(NSMutableArray*)t {
    @autoreleasepool {
        [Nat224 copy:nc withZ:f1];
        
        NSMutableArray *d0 = [Nat224 create];
        NSMutableArray *e0 = [Nat224 create];
        
        for (int i = 0; i < 7; ++i) {
            [Nat224 copy:d1 withZ:d0];
            [Nat224 copy:e1 withZ:e0];
            
            int j = 1 << i;
            while (--j >= 0) {
                [SecP224R1FieldElement rs:d1 withE:e1 withF:f1 withT:t];
            }
            
            [SecP224R1FieldElement rm:nc withD0:d0 withE0:e0 withD1:d1 withE1:e1 withF1:f1 withT:t];
        }
#if !__has_feature(objc_arc)
        if (d0) [d0 release]; d0 = nil;
        if (e0) [e0 release]; e0 = nil;
#endif
    }
}

// NSMutableArray = uint[]
+ (void)rs:(NSMutableArray*)d withE:(NSMutableArray*)e withF:(NSMutableArray*)f withT:(NSMutableArray*)t {
    @autoreleasepool {
        [SecP224R1Field multiply:e withY:d withZ:e];
        [SecP224R1Field twice:e withZ:e];
        [SecP224R1Field square:d withZ:t];
        [SecP224R1Field add:f withY:t withZ:d];
        [SecP224R1Field multiply:f withY:t withZ:f];
        uint c = [Nat shiftUpBits:7 withZ:f withBits:2 withC:0];
        [SecP224R1Field reduce32:c withZ:f];
    }
}

// NSMutableArray = uint[]
+ (BOOL)trySqrt:(NSMutableArray*)nc withR:(NSMutableArray*)r withT:(NSMutableArray*)t {
    BOOL retVal = NO;
    @autoreleasepool {
        NSMutableArray *d1 = [Nat224 create];
        [Nat224 copy:r withZ:d1];
        NSMutableArray *e1 = [Nat224 create];
        e1[0] = @((uint)1);
        NSMutableArray *f1 = [Nat224 create];
        [SecP224R1FieldElement rp:nc withD1:d1 withE1:e1 withF1:f1 withT:t];
        
        NSMutableArray *d0 = [Nat224 create];
        NSMutableArray *e0 = [Nat224 create];
        
        for (int k = 1; k < 96; ++k) {
            [Nat224 copy:d1 withZ:d0];
            [Nat224 copy:e1 withZ:e0];
            
            [SecP224R1FieldElement rs:d1 withE:e1 withF:f1 withT:t];
            
            if ([Nat224 isZero:d1]) {
                [Mod invert:[SecP224R1Field P] withX:e0 withZ:t];
                [SecP224R1Field multiply:t withY:d0 withZ:t];
                retVal = YES;
                break;
            }
        }
#if !__has_feature(objc_arc)
        if (d1) [d1 release]; d1 = nil;
        if (e1) [e1 release]; e1 = nil;
        if (f1) [f1 release]; f1 = nil;
        if (d0) [d0 release]; d0 = nil;
        if (e0) [e0 release]; e0 = nil;
#endif
    }
    return retVal;
}

@end

//
//  Curve25519FieldElement.m
//  
//
//  Created by Pallas on 5/25/16.
//
//  Complete

#import "Curve25519FieldElement.h"
#import "Curve25519.h"
#import "Curve25519Field.h"
#import "BigInteger.h"
#import "Nat256.h"
#import "Mod.h"
#import "Arrays.h"

@interface Curve25519FieldElement ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation Curve25519FieldElement
@synthesize x = _x;

+ (BigInteger*)Q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[Curve25519 q] retain];
        }
    }
    return _q;
}

// Calculated as ECConstants.TWO.modPow(Q.shiftRight(2), Q)
// return == uint[]
+ (NSMutableArray*)PRECOMP_POW2 {
    static NSMutableArray *_precomp_pow2 = nil;
    @synchronized(self) {
        if (_precomp_pow2 == nil) {
            @autoreleasepool {
                _precomp_pow2 = [@[@((uint)0x4a0ea0b0), @((uint)0xc4ee1b27), @((uint)0xad2fe478), @((uint)0x2f431806), @((uint)0x3dfbd7a7), @((uint)0x2b4d0099), @((uint)0x4fc1df0b), @((uint)0x2b832480)] mutableCopy];
            }
        }
    }
    return _precomp_pow2;
}

- (id)initWithBigInteger:(BigInteger*)x {
    if (self = [super init]) {
        @autoreleasepool {
            if (x == nil || [x signValue] < 0 || [x compareToWithValue:[Curve25519FieldElement Q]] >= 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"value of x invalid for Curve25519FieldElement" userInfo:nil];
#if !__has_feature(objc_arc)
                [self release];
#endif
                return nil;
            }
            [self setX:[Curve25519Field fromBigInteger:x]];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpArray = [Nat256 create];
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
    return [Nat256 isZero:self.x];
}

- (BOOL)isOne {
    return [Nat256 isOne:self.x];
}

- (BOOL)testBitZero {
    return [Nat256 getBit:self.x withBit:0] == 1;
}

- (BigInteger*)toBigInteger {
    return [Nat256 toBigInteger:self.x];
}

- (NSString*)fieldName {
    return @"Curve25519Field";
}

- (int)fieldSize {
    return [[Curve25519FieldElement Q] bitLength];
}

- (ECFieldElement*)add:(ECFieldElement*)b {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Curve25519Field add:self.x withY:((Curve25519FieldElement*)b).x withZ:z];
        retVal = [[Curve25519FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)addOne {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Curve25519Field addOne:self.x withZ:z];
        retVal = [[Curve25519FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)subtract:(ECFieldElement*)b {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Curve25519Field subtract:self.x withY:((Curve25519FieldElement*)b).x withZ:z];
        retVal = [[Curve25519FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)multiply:(ECFieldElement*)b {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Curve25519Field multiply:self.x withY:((Curve25519FieldElement*)b).x withZ:z];
        retVal = [[Curve25519FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)divide:(ECFieldElement*)b {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Mod invert:[Curve25519Field P] withX:((Curve25519FieldElement*)b).x withZ:z];
        [Curve25519Field multiply:z withY:self.x withZ:z];
        retVal = [[Curve25519FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)negate {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Curve25519Field negate:self.x withZ:z];
        retVal = [[Curve25519FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)square {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Curve25519Field square:self.x withZ:z];
        retVal = [[Curve25519FieldElement alloc] initWithUintArray:z];
#if !__has_feature(objc_arc)
        if (z) [z release]; z = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)invert {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *z = [Nat256 create];
        [Mod invert:[Curve25519Field P] withX:self.x withZ:z];
        retVal = [[Curve25519FieldElement alloc] initWithUintArray:z];
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
    /*
     * Q == 8m + 5, so we use Pocklington's method for this case.
     *
     * First, raise this element to the exponent 2^252 - 2^1 (i.e. m + 1)
     *
     * Breaking up the exponent's binary representation into "repunits", we get:
     * { 251 1s } { 1 0s }
     *
     * Therefore we need an addition chain containing 251 (the lengths of the repunits)
     * We use: 1, 2, 3, 4, 7, 11, 15, 30, 60, 120, 131, [251]
     */
    
    // NSMutableArray == uint[]
    NSMutableArray *x1 = self.x;
    if ([Nat256 isZero:x1] || [Nat256 isOne:x1]) {
        return self;
    } else {
        Curve25519FieldElement *retVal = nil;
        @autoreleasepool {
            NSMutableArray *x2 = [Nat256 create];
            [Curve25519Field square:x1 withZ:x2];
            [Curve25519Field multiply:x2 withY:x1 withZ:x2];
            NSMutableArray *x3 = x2;
            [Curve25519Field square:x2 withZ:x3];
            [Curve25519Field multiply:x3 withY:x1 withZ:x3];
            NSMutableArray *x4 = [Nat256 create];
            [Curve25519Field square:x3 withZ:x4];
            [Curve25519Field multiply:x4 withY:x1 withZ:x4];
            NSMutableArray *x7 = [Nat256 create];
            [Curve25519Field squareN:x4 withN:3 withZ:x7];
            [Curve25519Field multiply:x7 withY:x3 withZ:x7];
            NSMutableArray *x11 = x3;
            [Curve25519Field squareN:x7 withN:4 withZ:x11];
            [Curve25519Field multiply:x11 withY:x4 withZ:x11];
            NSMutableArray *x15 = x7;
            [Curve25519Field squareN:x11 withN:4 withZ:x15];
            [Curve25519Field multiply:x15 withY:x4 withZ:x15];
            NSMutableArray *x30 = x4;
            [Curve25519Field squareN:x15 withN:15 withZ:x30];
            [Curve25519Field multiply:x30 withY:x15 withZ:x30];
            NSMutableArray *x60 = x15;
            [Curve25519Field squareN:x30 withN:30 withZ:x60];
            [Curve25519Field multiply:x60 withY:x30 withZ:x60];
            NSMutableArray *x120 = x30;
            [Curve25519Field squareN:x60 withN:60 withZ:x120];
            [Curve25519Field multiply:x120 withY:x60 withZ:x120];
            NSMutableArray *x131 = x60;
            [Curve25519Field squareN:x120 withN:11 withZ:x131];
            [Curve25519Field multiply:x131 withY:x11 withZ:x131];
            NSMutableArray *x251 = x11;
            [Curve25519Field squareN:x131 withN:120 withZ:x251];
            [Curve25519Field multiply:x251 withY:x120 withZ:x251];
            
            NSMutableArray *t1 = x251;
            [Curve25519Field square:t1 withZ:t1];
            
            NSMutableArray *t2 = x120;
            [Curve25519Field square:t1 withZ:t2];
            
            if ([Nat256 eq:x1 withY:t2]) {
                retVal = [[Curve25519FieldElement alloc] initWithUintArray:t1];
#if !__has_feature(objc_arc)
                if (x2) [x2 release]; x2 = nil;
                if (x4) [x4 release]; x4 = nil;
                if (x7) [x7 release]; x7 = nil;
#endif
            } else {
                /*
                 * If the first guess is incorrect, we multiply by a precomputed power of 2 to get the second guess,
                 * which is ((4x)^(m + 1))/2 mod Q
                 */
                [Curve25519Field multiply:t1 withY:[Curve25519FieldElement PRECOMP_POW2] withZ:t1];
                
                [Curve25519Field square:t1 withZ:t2];
                
                if ([Nat256 eq:x1 withY:t2]) {
                    retVal = [[Curve25519FieldElement alloc] initWithUintArray:t1];
#if !__has_feature(objc_arc)
                    if (x2) [x2 release]; x2 = nil;
                    if (x4) [x4 release]; x4 = nil;
                    if (x7) [x7 release]; x7 = nil;
#endif
                    return retVal;
                } else {
#if !__has_feature(objc_arc)
                    if (x2) [x2 release]; x2 = nil;
                    if (x4) [x4 release]; x4 = nil;
                    if (x7) [x7 release]; x7 = nil;
#endif
                }
            }
        }
        
        return (retVal ? [retVal autorelease] : nil);
    }
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[Curve25519FieldElement class]] ) {
        return [self equalsWithCurve25519FieldElement:(Curve25519FieldElement*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECFieldElement*)other {
    if (other != nil && [other isKindOfClass:[Curve25519FieldElement class]] ) {
        return [self equalsWithCurve25519FieldElement:(Curve25519FieldElement*)other];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithCurve25519FieldElement:(Curve25519FieldElement*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [Nat256 eq:self.x withY:other.x];
}

- (NSUInteger)hash {
    return [[Curve25519FieldElement Q] hash] ^ [Arrays getHashCodeWithUIntArray:self.x withOff:0 withLen:8];
}

@end

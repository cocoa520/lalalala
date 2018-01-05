//
//  SecP256K1Point.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP256K1Point.h"
#import "ECCurve.h"
#import "SecP256K1Field.h"
#import "SecP256K1FieldElement.h"
#import "Nat256.h"
#import "Nat.h"

@implementation SecP256K1Point

/**
 * Create a point which encodes with point compression.
 *
 * @param curve
 *            the curve to use
 * @param x
 *            affine x co-ordinate
 * @param y
 *            affine y co-ordinate
 *
 * @deprecated Use ECCurve.createPoint to construct points
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    if (self = [super initWithCurve:curve withX:x withY:y withCompression:NO]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * Create a point that encodes with or without point compresion.
 *
 * @param curve
 *            the curve to use
 * @param x
 *            affine x co-ordinate
 * @param y
 *            affine y co-ordinate
 * @param withCompression
 *            if true encode with point compression
 *
 * @deprecated per-point compression property will be removed, refer
 *             {@link #getEncoded(bool)}
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withCompression:withCompression]) {
        if ((x == nil) != (y == nil)) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Exactly one of the field elements is nil" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withZS:zs withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

- (ECPoint*)detach {
    return [[[SecP256K1Point alloc] initWithCurve:nil withX:[self affineXCoord] withY:[self affineYCoord]] autorelease];
}


- (ECPoint*)add:(ECPoint*)b {
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return self;
    }
    if (self == b) {
        return [self twice];
    }
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        ECCurve *curve = [self curve];
        
        SecP256K1FieldElement *X1 = (SecP256K1FieldElement*)[self rawXCoord], *Y1 = (SecP256K1FieldElement*)[self rawYCoord];
        SecP256K1FieldElement *X2 = (SecP256K1FieldElement*)[b rawXCoord], *Y2 = (SecP256K1FieldElement*)[b rawYCoord];
        
        SecP256K1FieldElement *Z1 = (SecP256K1FieldElement*)([self rawZCoords][0]);
        SecP256K1FieldElement *Z2 = (SecP256K1FieldElement*)([b rawZCoords][0]);
        
        uint c;
        NSMutableArray *tt1 = [Nat256 createExt];
        NSMutableArray *t2 = [Nat256 create];
        NSMutableArray *t3 = [Nat256 create];
        NSMutableArray *t4 = [Nat256 create];
        
        BOOL Z1IsOne = [Z1 isOne];
        NSMutableArray *U2, *S2;
        if (Z1IsOne) {
            U2 = [X2 x];
            S2 = [Y2 x];
        } else {
            S2 = t3;
            [SecP256K1Field square:[Z1 x] withZ:S2];
            
            U2 = t2;
            [SecP256K1Field multiply:S2 withY:[X2 x] withZ:U2];
            
            [SecP256K1Field multiply:S2 withY:[Z1 x] withZ:S2];
            [SecP256K1Field multiply:S2 withY:[Y2 x] withZ:S2];
        }
        
        BOOL Z2IsOne = [Z2 isOne];
        NSMutableArray *U1, *S1;
        if (Z2IsOne) {
            U1 = [X1 x];
            S1 = [Y1 x];
        } else {
            S1 = t4;
            [SecP256K1Field square:[Z2 x] withZ:S1];
            
            U1 = tt1;
            [SecP256K1Field multiply:S1 withY:[X1 x] withZ:U1];
            
            [SecP256K1Field multiply:S1 withY:[Z2 x] withZ:S1];
            [SecP256K1Field multiply:S1 withY:[Y1 x] withZ:S1];
        }
        
        NSMutableArray *H = [Nat256 create];
        [SecP256K1Field subtract:U1 withY:U2 withZ:H];
        
        NSMutableArray *R = t2;
        [SecP256K1Field subtract:S1 withY:S2 withZ:R];
        
        // Check if b == this or b == -this
        if ([Nat256 isZero:H]) {
            if ([Nat256 isZero:R]) {
                // this == b, i.e. this must be doubled
#if !__has_feature(objc_arc)
                if (tt1) [tt1 release]; tt1 = nil;
                if (t2) [t2 release]; t2 = nil;
                if (t3) [t3 release]; t3 = nil;
                if (t4) [t4 release]; t4 = nil;
                if (H) [H release]; H = nil;
#endif
                retVal = [self twice];
            } else {
                // this == -b, i.e. the result is the point at infinity
#if !__has_feature(objc_arc)
                if (tt1) [tt1 release]; tt1 = nil;
                if (t2) [t2 release]; t2 = nil;
                if (t3) [t3 release]; t3 = nil;
                if (t4) [t4 release]; t4 = nil;
                if (H) [H release]; H = nil;
#endif
                retVal = [curve infinity];
            }
        } else {
            NSMutableArray *HSquared = t3;
            [SecP256K1Field square:H withZ:HSquared];
            
            NSMutableArray *G = [Nat256 create];
            [SecP256K1Field multiply:HSquared withY:H withZ:G];
            
            NSMutableArray *V = t3;
            [SecP256K1Field multiply:HSquared withY:U1 withZ:V];
            
            [SecP256K1Field negate:G withZ:G];
            [Nat256 mul:S1 withY:G withZZ:tt1];
            
            c = [Nat256 addBothTo:V withY:V withZ:G];
            [SecP256K1Field reduce32:c withZ:G];
            
            SecP256K1FieldElement *X3 = [[SecP256K1FieldElement alloc] initWithUintArray:t4];
            [SecP256K1Field square:R withZ:[X3 x]];
            [SecP256K1Field subtract:[X3 x] withY:G withZ:[X3 x]];
            
            SecP256K1FieldElement *Y3 = [[SecP256K1FieldElement alloc] initWithUintArray:G];
            [SecP256K1Field subtract:V withY:[X3 x] withZ:[Y3 x]];
            [SecP256K1Field multiplyAddToExt:[Y3 x] withY:R withZZ:tt1];
            [SecP256K1Field reduce:tt1 withZ:[Y3 x]];
            
            SecP256K1FieldElement *Z3 = [[SecP256K1FieldElement alloc] initWithUintArray:H];
            if (!Z1IsOne) {
                [SecP256K1Field multiply:[Z3 x] withY:[Z1 x] withZ:[Z3 x]];
            }
            if (!Z2IsOne) {
                [SecP256K1Field multiply:[Z3 x] withY:[Z2 x] withZ:[Z3 x]];
            }
            
            NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z3, nil];
            retVal = [[[SecP256K1Point alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:zs withCompression:self.isCompressed] autorelease];
#if !__has_feature(objc_arc)
            if (X3 != nil) [X3 release]; X3 = nil;
            if (Y3 != nil) [Y3 release]; Y3 = nil;
            if (Z3 != nil) [Z3 release]; Z3 = nil;
            if (zs != nil) [zs release]; zs = nil;
            if (tt1) [tt1 release]; tt1 = nil;
            if (t2) [t2 release]; t2 = nil;
            if (t3) [t3 release]; t3 = nil;
            if (t4) [t4 release]; t4 = nil;
            if (H) [H release]; H = nil;
            if (G) [G release]; G = nil;
#endif
        }
        
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)twice {
    if ([self isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    
    SecP256K1FieldElement *Y1 = (SecP256K1FieldElement*)[self rawYCoord];
    if ([Y1 isZero]) {
        return [curve infinity];
    }
    
    SecP256K1Point *retVal = nil;
    @autoreleasepool {
        SecP256K1FieldElement *X1 = (SecP256K1FieldElement*)[self rawXCoord], *Z1 = (SecP256K1FieldElement*)([self rawZCoords][0]);
        
        uint c;
        
        NSMutableArray *Y1Squared = [Nat256 create];
        [SecP256K1Field square:[Y1 x] withZ:Y1Squared];
        
        NSMutableArray *T = [Nat256 create];
        [SecP256K1Field square:Y1Squared withZ:T];
        
        NSMutableArray *M = [Nat256 create];
        [SecP256K1Field square:[X1 x] withZ:M];
        c = [Nat256 addBothTo:M withY:M withZ:M];
        [SecP256K1Field reduce32:c withZ:M];
        
        NSMutableArray *S = Y1Squared;
        [SecP256K1Field multiply:Y1Squared withY:[X1 x] withZ:S];
        c = [Nat shiftUpBits:8 withZ:S withBits:2 withC:0];
        [SecP256K1Field reduce32:c withZ:S];
        
        NSMutableArray *t1 = [Nat256 create];
        c = [Nat shiftUpBits:8 withX:T withBits:3 withC:0 withZ:t1];
        [SecP256K1Field reduce32:c withZ:t1];
        
        SecP256K1FieldElement *X3 = [[SecP256K1FieldElement alloc] initWithUintArray:T];
        [SecP256K1Field square:M withZ:[X3 x]];
        [SecP256K1Field subtract:[X3 x] withY:S withZ:[X3 x]];
        [SecP256K1Field subtract:[X3 x] withY:S withZ:[X3 x]];
        
        SecP256K1FieldElement *Y3 = [[SecP256K1FieldElement alloc] initWithUintArray:S];
        [SecP256K1Field subtract:S withY:[X3 x] withZ:[Y3 x]];
        [SecP256K1Field multiply:[Y3 x] withY:M withZ:[Y3 x]];
        [SecP256K1Field subtract:[Y3 x] withY:t1 withZ:[Y3 x]];
        
        SecP256K1FieldElement *Z3 = [[SecP256K1FieldElement alloc] initWithUintArray:M];
        [SecP256K1Field twice:[Y1 x] withZ:[Z3 x]];
        if (![Z1 isOne]) {
            [SecP256K1Field multiply:[Z3 x] withY:[Z1 x] withZ:[Z3 x]];
        }
        
        NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z3, nil];
        retVal = [[SecP256K1Point alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:zs withCompression:self.isCompressed];
#if !__has_feature(objc_arc)
        if (X3 != nil) [X3 release]; X3 = nil;
        if (Y3 != nil) [Y3 release]; Y3 = nil;
        if (Z3 != nil) [Z3 release]; Z3 = nil;
        if (zs != nil) [zs release]; zs = nil;
        if (Y1Squared) [Y1Squared release]; Y1Squared = nil;
        if (T) [T release]; T = nil;
        if (M) [M release]; M = nil;
        if (t1) [t1 release]; t1 = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)twicePlus:(ECPoint*)b {
    if (self == b) {
        return [self threeTimes];
    }
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return [self twice];
    }
    
    ECFieldElement *Y1 = [self rawYCoord];
    if ([Y1 isZero]) {
        return b;
    }
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        retVal = [[self twice] add:b];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)threeTimes {
    if ([self isInfinity] || [[self rawYCoord] isZero]) {
        return self;
    }
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        // NOTE: Be careful about recursions between TwicePlus and ThreeTimes
        retVal = [[self twice] add:self];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)negate {
    if ([self isInfinity]) {
        return self;
    }
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        retVal = [[SecP256K1Point alloc] initWithCurve:[self curve] withX:[self rawXCoord] withY:[[self rawYCoord] negate] withZS:[self rawZCoords] withCompression:[self isCompressed]];
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end

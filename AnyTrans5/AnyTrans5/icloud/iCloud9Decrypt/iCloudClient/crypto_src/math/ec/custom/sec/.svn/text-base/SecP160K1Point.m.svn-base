//
//  SecP160K1Point.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP160K1Point.h"
#import "ECCurve.h"
#import "SecP160R2Field.h"
#import "SecP160R2FieldElement.h"
#import "Nat160.h"
#import "Nat.h"

@implementation SecP160K1Point

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
 * @deprecated Use ECCurve.CreatePoint to construct points
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
    return [[[SecP160K1Point alloc] initWithCurve:nil withX:[self affineXCoord] withY:[self affineYCoord]] autorelease];
}

// B.3 pg 62
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
        
        SecP160R2FieldElement *X1 = (SecP160R2FieldElement*)[self rawXCoord], *Y1 = (SecP160R2FieldElement*)[self rawYCoord];
        SecP160R2FieldElement *X2 = (SecP160R2FieldElement*)[b rawXCoord], *Y2 = (SecP160R2FieldElement*)[b rawYCoord];
        
        SecP160R2FieldElement *Z1 = (SecP160R2FieldElement*)([self rawZCoords][0]);
        SecP160R2FieldElement *Z2 = (SecP160R2FieldElement*)([b rawZCoords][0]);
        
        uint c;
        NSMutableArray *tt1 = [Nat160 createExt];
        NSMutableArray *t2 = [Nat160 create];
        NSMutableArray *t3 = [Nat160 create];
        NSMutableArray *t4 = [Nat160 create];
        
        BOOL Z1IsOne = [Z1 isOne];
        NSMutableArray *U2, *S2;
        if (Z1IsOne) {
            U2 = [X2 x];
            S2 = [Y2 x];
        } else {
            S2 = t3;
            [SecP160R2Field square:[Z1 x] withZ:S2];
            
            U2 = t2;
            [SecP160R2Field multiply:S2 withY:[X2 x] withZ:U2];
            
            [SecP160R2Field multiply:S2 withY:[Z1 x] withZ:S2];
            [SecP160R2Field multiply:S2 withY:[Y2 x] withZ:S2];
        }
        
        BOOL Z2IsOne = [Z2 isOne];
        NSMutableArray *U1, *S1;
        if (Z2IsOne) {
            U1 = [X1 x];
            S1 = [Y1 x];
        } else {
            S1 = t4;
            [SecP160R2Field square:[Z2 x] withZ:S1];
            
            U1 = tt1;
            [SecP160R2Field multiply:S1 withY:[X1 x] withZ:U1];
            
            [SecP160R2Field multiply:S1 withY:[Z2 x] withZ:S1];
            [SecP160R2Field multiply:S1 withY:[Y1 x] withZ:S1];
        }
        
        NSMutableArray *H = [Nat160 create];
        [SecP160R2Field subtract:U1 withY:U2 withZ:H];
        
        NSMutableArray *R = t2;
        [SecP160R2Field subtract:S1 withY:S2 withZ:R];
        
        // Check if b == this or b == -this
        if ([Nat160 isZero:H]) {
            if ([Nat160 isZero:R]) {
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
            [SecP160R2Field square:H withZ:HSquared];
            
            NSMutableArray *G = [Nat160 create];
            [SecP160R2Field multiply:HSquared withY:H withZ:G];
            
            NSMutableArray *V = t3;
            [SecP160R2Field multiply:HSquared withY:U1 withZ:V];
            
            [SecP160R2Field negate:G withZ:G];
            [Nat160 mul:S1 withY:G withZZ:tt1];
            
            c = [Nat160 addBothTo:V withY:V withZ:G];
            [SecP160R2Field reduce32:c withZ:G];
            
            SecP160R2FieldElement *X3 = [[SecP160R2FieldElement alloc] initWithUintArray:t4];
            [SecP160R2Field square:R withZ:[X3 x]];
            [SecP160R2Field subtract:[X3 x] withY:G withZ:[X3 x]];
            
            SecP160R2FieldElement *Y3 = [[SecP160R2FieldElement alloc] initWithUintArray:G];
            [SecP160R2Field subtract:V withY:[X3 x] withZ:[Y3 x]];
            [SecP160R2Field multiplyAddToExt:[Y3 x] withY:R withZZ:tt1];
            [SecP160R2Field reduce:tt1 withZ:[Y3 x]];
            
            SecP160R2FieldElement *Z3 = [[SecP160R2FieldElement alloc] initWithUintArray:H];
            if (!Z1IsOne) {
                [SecP160R2Field multiply:[Z3 x] withY:[Z1 x] withZ:[Z3 x]];
            }
            if (!Z2IsOne) {
                [SecP160R2Field multiply:[Z3 x] withY:[Z2 x] withZ:[Z3 x]];
            }
            
            NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z3, nil];
            retVal = [[[SecP160K1Point alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:zs withCompression:self.isCompressed] autorelease];
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

// B.3 pg 62
- (ECPoint*)twice {
    if ([self isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    
    SecP160R2FieldElement *Y1 = (SecP160R2FieldElement*)[self rawYCoord];
    if ([Y1 isZero]) {
        return [curve infinity];
    }
    
    SecP160K1Point *retVal = nil;
    @autoreleasepool {
        SecP160R2FieldElement *X1 = (SecP160R2FieldElement*)[self rawXCoord], *Z1 = (SecP160R2FieldElement*)([self rawZCoords][0]);
        
        uint c;
        
        NSMutableArray *Y1Squared = [Nat160 create];
        [SecP160R2Field square:[Y1 x] withZ:Y1Squared];
        
        NSMutableArray *T = [Nat160 create];
        [SecP160R2Field square:Y1Squared withZ:T];
        
        NSMutableArray *M = [Nat160 create];
        [SecP160R2Field square:[X1 x] withZ:M];
        c = [Nat160 addBothTo:M withY:M withZ:M];
        [SecP160R2Field reduce32:c withZ:M];
        
        NSMutableArray *S = Y1Squared;
        [SecP160R2Field multiply:Y1Squared withY:[X1 x] withZ:S];
        c = [Nat shiftUpBits:5 withZ:S withBits:2 withC:0];
        [SecP160R2Field reduce32:c withZ:S];
        
        NSMutableArray *t1 = [Nat160 create];
        c = [Nat shiftUpBits:5 withX:T withBits:3 withC:0 withZ:t1];
        [SecP160R2Field reduce32:c withZ:t1];
        
        SecP160R2FieldElement *X3 = [[SecP160R2FieldElement alloc] initWithUintArray:T];
        [SecP160R2Field square:M withZ:[X3 x]];
        [SecP160R2Field subtract:[X3 x] withY:S withZ:[X3 x]];
        [SecP160R2Field subtract:[X3 x] withY:S withZ:[X3 x]];
        
        SecP160R2FieldElement *Y3 = [[SecP160R2FieldElement alloc] initWithUintArray:S];
        [SecP160R2Field subtract:S withY:[X3 x] withZ:[Y3 x]];
        [SecP160R2Field multiply:[Y3 x] withY:M withZ:[Y3 x]];
        [SecP160R2Field subtract:[Y3 x] withY:t1 withZ:[Y3 x]];
        
        SecP160R2FieldElement *Z3 = [[SecP160R2FieldElement alloc] initWithUintArray:M];
        [SecP160R2Field twice:[Y1 x] withZ:[Z3 x]];
        if (![Z1 isOne]) {
            [SecP160R2Field multiply:[Z3 x] withY:[Z1 x] withZ:[Z3 x]];
        }
        
        NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z3, nil];
        retVal = [[SecP160K1Point alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:zs withCompression:self.isCompressed];
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
    ECPoint *retPoint = nil;
    @autoreleasepool {
        retPoint = [[self twice] add:b];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)threeTimes {
    if ([self isInfinity] || [[self rawYCoord] isZero]) {
        return self;
    }
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        // NOTE: Be careful about recursions between TwicePlus and threeTimes
        retPoint = [[self twice] add:self];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)negate {
    if ([self isInfinity]) {
        return self;
    }
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        retPoint = [[SecP160K1Point alloc] initWithCurve:[self curve] withX:[self rawXCoord] withY:[[self rawYCoord] negate] withZS:[self rawZCoords] withCompression:[self isCompressed]];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end

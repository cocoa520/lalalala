//
//  Curve25519Point.m
//  
//
//  Created by Pallas on 5/25/16.
//
//  Complete

#import "Curve25519Point.h"
#import "ECCurve.h"
#import "Curve25519Field.h"
#import "Curve25519FieldElement.h"
#import "Nat256.h"

@implementation Curve25519Point

/**
 * Create a point which encodes with point compression.
 *
 * @param curve the curve to use
 * @param x affine x co-ordinate
 * @param y affine y co-ordinate
 *
 * @deprecated Use ECCurve.CreatePoint to construct points
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    if (self = [self initWithCurve:curve withX:x withY:y withCompression:NO]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * Create a point that encodes with or without point compresion.
 *
 * @param curve the curve to use
 * @param x affine x co-ordinate
 * @param y affine y co-ordinate
 * @param withCompression if true encode with point compression
 *
 * @deprecated per-point compression property will be removed, refer {@link #getEncoded(bool)}
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
    return [[[Curve25519Point alloc] initWithCurve:nil withX:[self affineXCoord] withY:[self affineYCoord]] autorelease];
}

- (ECFieldElement*)getZCoord:(int)index {
    if (index == 1) {
        return [self getJacobianModifiedW];
    }
    
    return [super getZCoord:index];
}

- (ECPoint*)add:(ECPoint*)b {
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return self;
    }
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        if (self == b) {
            retPoint = [self twice];
        } else {
            ECCurve *curve = [self curve];
            
            Curve25519FieldElement *X1 = (Curve25519FieldElement*)[self rawXCoord], *Y1 = (Curve25519FieldElement*)[self rawYCoord], *Z1 = (Curve25519FieldElement*)([self rawZCoords][0]);
            Curve25519FieldElement *X2 = (Curve25519FieldElement*)[b rawXCoord], *Y2 = (Curve25519FieldElement*)[b rawYCoord], *Z2 = (Curve25519FieldElement*)([b rawZCoords][0]);
            
            uint c;
            // NSMutableArray == uint[]
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
                [Curve25519Field square:Z1.x withZ:S2];
                
                U2 = t2;
                [Curve25519Field multiply:S2 withY:X2.x withZ:U2];
                
                [Curve25519Field multiply:S2 withY:Z1.x withZ:S2];
                [Curve25519Field multiply:S2 withY:Y2.x withZ:S2];
            }
            
            BOOL Z2IsOne = [Z2 isOne];
            NSMutableArray *U1, *S1;
            if (Z2IsOne) {
                U1 = X1.x;
                S1 = Y1.x;
            } else {
                S1 = t4;
                [Curve25519Field square:Z2.x withZ:S1];
                
                U1 = tt1;
                [Curve25519Field multiply:S1 withY:X1.x withZ:U1];
                
                [Curve25519Field multiply:S1 withY:Z2.x withZ:S1];
                [Curve25519Field multiply:S1 withY:Y1.x withZ:S1];
            }
            
            NSMutableArray *H = [Nat256 create];
            [Curve25519Field subtract:U1 withY:U2 withZ:H];
            
            NSMutableArray *R = t2;
            [Curve25519Field subtract:S1 withY:S2 withZ:R];
            
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
                    retPoint = [self twice];
                } else {
                    // this == -b, i.e. the result is the point at infinity
#if !__has_feature(objc_arc)
                    if (tt1) [tt1 release]; tt1 = nil;
                    if (t2) [t2 release]; t2 = nil;
                    if (t3) [t3 release]; t3 = nil;
                    if (t4) [t4 release]; t4 = nil;
                    if (H) [H release]; H = nil;
#endif
                    retPoint = [curve infinity];
                }
            } else {
                NSMutableArray *HSquared = [Nat256 create];
                [Curve25519Field square:H withZ:HSquared];
                
                NSMutableArray *G = [Nat256 create];
                [Curve25519Field multiply:HSquared withY:H withZ:G];
                
                NSMutableArray *V = t3;
                [Curve25519Field multiply:HSquared withY:U1 withZ:V];
                
                [Curve25519Field negate:G withZ:G];
                [Nat256 mul:S1 withY:G withZZ:tt1];
                
                c = [Nat256 addBothTo:V withY:V withZ:G];
                [Curve25519Field reduce27:c withZ:G];
                
                Curve25519FieldElement *X3 = [[Curve25519FieldElement alloc] initWithUintArray:t4];
                [Curve25519Field square:R withZ:X3.x];
                [Curve25519Field subtract:X3.x withY:G withZ:X3.x];
                
                Curve25519FieldElement *Y3 = [[Curve25519FieldElement alloc] initWithUintArray:G];
                [Curve25519Field subtract:V withY:X3.x withZ:Y3.x];
                [Curve25519Field multiplyAddToExt:Y3.x withY:R withZZ:tt1];
                [Curve25519Field reduce:tt1 withZ:Y3.x];
                
                Curve25519FieldElement *Z3 = [[Curve25519FieldElement alloc] initWithUintArray:H];
                if (!Z1IsOne) {
                    [Curve25519Field multiply:Z3.x withY:Z1.x withZ:Z3.x];
                }
                if (!Z2IsOne) {
                    [Curve25519Field multiply:Z3.x withY:Z2.x withZ:Z3.x];
                }
                
                NSMutableArray *Z3Squared = (Z1IsOne && Z2IsOne) ? HSquared : nil;
                
                // TODO If the result will only be used in a subsequent addition, we don't need W3
                Curve25519FieldElement *W3 = [self calculateJacobianModifiedW:(Curve25519FieldElement*)Z3 withUintArray:Z3Squared];
                
                NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z3, W3, nil];
                retPoint = [[[Curve25519Point alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:zs withCompression:self.isCompressed] autorelease];
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
                if (HSquared) [HSquared release]; HSquared = nil;
                if (G) [G release]; G = nil;
#endif
            }
        }
        
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)twice {
    if ([self isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    
    ECFieldElement *Y1 = [self rawYCoord];
    if ([Y1 isZero]) {
        return [curve infinity];
    }
    
    return [self twiceJacobianModified:YES];
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
    
    return [[self twiceJacobianModified:NO] add:b];
}

- (ECPoint*)threeTimes {
    if ([self isInfinity] || [[self rawYCoord] isZero]) {
        return self;
    }
    
    return [[self twiceJacobianModified:NO] add:self];
}

- (ECPoint*)negate {
    if ([self isInfinity]) {
        return self;
    }
    
    return [[[Curve25519Point alloc] initWithCurve:[self curve] withX:[self rawXCoord] withY:[[self rawYCoord] negate] withZS:[self rawZCoords] withCompression:[self isCompressed]] autorelease];
}

// NSMutableArray == uint[]
- (Curve25519FieldElement*)calculateJacobianModifiedW:(Curve25519FieldElement*)z withUintArray:(NSMutableArray*)ZSquared {
    Curve25519FieldElement *a4 = (Curve25519FieldElement*)[[self curve] a];
    if ([z isOne]) {
        return a4;
    }
    
    Curve25519FieldElement *W = nil;
    @autoreleasepool {
        W = [[Curve25519FieldElement alloc] init];
        if (ZSquared == nil) {
            ZSquared = W.x;
            [Curve25519Field square:z.x withZ:ZSquared];
        }
        [Curve25519Field square:ZSquared withZ:W.x];
        [Curve25519Field multiply:W.x withY:a4.x withZ:W.x];
    }
    return (W ? [W autorelease] : nil);
}

- (Curve25519FieldElement*)getJacobianModifiedW {
    Curve25519FieldElement *retVal = nil;
    @autoreleasepool {
        NSMutableArray *ZZ = [self rawZCoords];
        Curve25519FieldElement *W = (Curve25519FieldElement*)(ZZ[1]);
        if (W == nil) {
            // NOTE: Rarely, TwicePlus will result in the need for a lazy W1 calculation here
            ZZ[1] = W = [self calculateJacobianModifiedW:(Curve25519FieldElement*)(ZZ[0]) withUintArray:nil];
        }
        retVal = W;
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (Curve25519Point*)twiceJacobianModified:(BOOL)calculateW {
    Curve25519Point *retVal = nil;
    @autoreleasepool {
        Curve25519FieldElement *X1 = (Curve25519FieldElement*)[self rawXCoord], *Y1 = (Curve25519FieldElement*)[self rawYCoord], *Z1 = (Curve25519FieldElement*)([self rawZCoords][0]), *W1 = [self getJacobianModifiedW];
        
        uint c;
        
        NSMutableArray *M = [Nat256 create];
        [Curve25519Field square:X1.x withZ:M];
        c = [Nat256 addBothTo:M withY:M withZ:M];
        c += [Nat256 addTo:W1.x withZ:M];
        [Curve25519Field reduce27:c withZ:M];
        
        NSMutableArray *_2Y1 = [Nat256 create];
        [Curve25519Field twice:Y1.x withZ:_2Y1];
        
        NSMutableArray *_2Y1Squared = [Nat256 create];
        [Curve25519Field multiply:_2Y1 withY:Y1.x withZ:_2Y1Squared];
        
        NSMutableArray *S = [Nat256 create];
        [Curve25519Field multiply:_2Y1Squared withY:X1.x withZ:S];
        [Curve25519Field twice:S withZ:S];
        
        NSMutableArray *_8T = [Nat256 create];
        [Curve25519Field square:_2Y1Squared withZ:_8T];
        [Curve25519Field twice:_8T withZ:_8T];
        
        Curve25519FieldElement *X3 = [[Curve25519FieldElement alloc] initWithUintArray:_2Y1Squared];
        [Curve25519Field square:M withZ:X3.x];
        [Curve25519Field subtract:X3.x withY:S withZ:X3.x];
        [Curve25519Field subtract:X3.x withY:S withZ:X3.x];
        
        Curve25519FieldElement *Y3 = [[Curve25519FieldElement alloc] initWithUintArray:S];
        [Curve25519Field subtract:S withY:X3.x withZ:Y3.x];
        [Curve25519Field multiply:Y3.x withY:M withZ:Y3.x];
        [Curve25519Field subtract:Y3.x withY:_8T withZ:Y3.x];
        
        Curve25519FieldElement *Z3 = [[Curve25519FieldElement alloc] initWithUintArray:_2Y1];
        if (![Nat256 isOne:Z1.x]) {
            [Curve25519Field multiply:Z3.x withY:Z1.x withZ:Z3.x];
        }
        
        Curve25519FieldElement *W3 = nil;
        if (calculateW) {
            W3 = [[Curve25519FieldElement alloc] initWithUintArray:_8T];
            [Curve25519Field multiply:W3.x withY:W1.x withZ:W3.x];
            [Curve25519Field twice:W3.x withZ:W3.x];
        }
        
        NSMutableArray *T3 = [[NSMutableArray alloc] initWithObjects:Z3, W3, nil];
        retVal = [[Curve25519Point alloc] initWithCurve:[self curve] withX:X3 withY:Y3 withZS:T3 withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
        if (X3 != nil) [X3 release]; X3 = nil;
        if (Y3 != nil) [Y3 release]; Y3 = nil;
        if (Z3 != nil) [Z3 release]; Z3 = nil;
        if (W3 != nil) [W3 release]; W3 = nil;
        if (T3 != nil) [T3 release]; T3 = nil;
        if (M) [M release]; M = nil;
        if (_2Y1) [_2Y1 release]; _2Y1 = nil;
        if (_2Y1Squared) [_2Y1Squared release]; _2Y1Squared = nil;
        if (S) [S release]; S = nil;
        if (_8T) [_8T release]; _8T = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end

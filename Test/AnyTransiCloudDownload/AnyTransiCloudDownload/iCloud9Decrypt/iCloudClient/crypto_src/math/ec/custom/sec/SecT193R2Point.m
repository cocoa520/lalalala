//
//  SecT193R2Point.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT193R2Point.h"
#import "ECCurve.h"
#import "ECFieldElement.h"
#import "BigInteger.h"

@implementation SecT193R2Point

/**
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
    return [[[SecT193R2Point alloc] initWithCurve:nil withX:[self affineXCoord] withY:[self affineYCoord]] autorelease];
}

- (ECFieldElement*)yCoord {
    ECFieldElement *X = [self rawXCoord], *L = [self rawYCoord];
    
    if ([self isInfinity] || [X isZero]) {
        return L;
    }
    
    ECFieldElement *Y = nil;
    @autoreleasepool {
        // Y is actually Lambda (X + Y/X) here; convert to affine value on the fly
        Y = [[L add:X] multiply:X];
        
        ECFieldElement *Z = (ECFieldElement*)([self rawZCoords][0]);
        if (![Z isOne]) {
            Y = [Y divide:Z];
        }
        [Y retain];
    }
    return (Y ? [Y autorelease] : nil);
}

- (BOOL)compressionYTilde {
    ECFieldElement *X = [self rawXCoord];
    if ([X isZero]) {
        return NO;
    }
    
    ECFieldElement *Y = [self rawYCoord];
    
    // Y is actually Lambda (X + Y/X) here
    return [Y testBitZero] != [X testBitZero];
}

- (ECPoint*)add:(ECPoint*)b {
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    
    ECFieldElement *X1 = [self rawXCoord];
    ECFieldElement *X2 = [b rawXCoord];
    
    if ([X1 isZero]) {
        if ([X2 isZero]) {
            return [curve infinity];
        }
        
        return [b add:self];
    }
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        ECFieldElement *L1 = [self rawYCoord], *Z1 = (ECFieldElement*)([self rawZCoords][0]);
        ECFieldElement *L2 = [b rawYCoord], *Z2 = (ECFieldElement*)([b rawZCoords][0]);
        
        BOOL Z1IsOne = [Z1 isOne];
        ECFieldElement *U2 = X2, *S2 = L2;
        if (!Z1IsOne) {
            U2 = [U2 multiply:Z1];
            S2 = [S2 multiply:Z1];
        }
        
        BOOL Z2IsOne = [Z2 isOne];
        ECFieldElement *U1 = X1, *S1 = L1;
        if (!Z2IsOne) {
            U1 = [U1 multiply:Z2];
            S1 = [S1 multiply:Z2];
        }
        
        ECFieldElement *A = [S1 add:S2];
        ECFieldElement *B = [U1 add:U2];
        
        if ([B isZero]) {
            if ([A isZero]) {
                retVal = [self twice];
            } else {
                retVal = [curve infinity];
            }
        } else {
            ECFieldElement *X3, *L3, *Z3;
            if ([X2 isZero]) {
                // TODO This can probably be optimized quite a bit
                ECPoint *p = [self normalize];
                X1 = [p xCoord];
                ECFieldElement *Y1 = [p yCoord];
                
                ECFieldElement *Y2 = L2;
                ECFieldElement *L = [[Y1 add:Y2] divide:X1];
                
                X3 = [[[[L square] add:L] add:X1] add:[curve a]];
                if ([X3 isZero]) {
                    retVal = [[[SecT193R2Point alloc] initWithCurve:curve withX:X3 withY:[[curve b] sqrt] withCompression:[self isCompressed]] autorelease];
                    goto jumpTo;
                }
                
                ECFieldElement *Y3 = [[[L multiply:[X1 add:X3]] add:X3] add:Y1];
                L3 = [[Y3 divide:X3] add:X3];
                Z3 = [curve fromBigInteger:[BigInteger One]];
            } else {
                B = [B square];
                
                ECFieldElement *AU1 = [A multiply:U1];
                ECFieldElement *AU2 = [A multiply:U2];
                
                X3 = [AU1 multiply:AU2];
                if ([X3 isZero]) {
                    retVal = [[[SecT193R2Point alloc] initWithCurve:curve withX:X3 withY:[[curve b] sqrt] withCompression:[self isCompressed]] autorelease];
                    goto jumpTo;
                }
                
                ECFieldElement *ABZ2 = [A multiply:B];
                if (!Z2IsOne) {
                    ABZ2 = [ABZ2 multiply:Z2];
                }
                
                L3 = [[AU2 add:B] squarePlusProduct:ABZ2 withY:[L1 add:Z1]];
                
                Z3 = ABZ2;
                if (!Z1IsOne) {
                    Z3 = [Z3 multiply:Z1];
                }
            }
            
            NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z3, nil];
            retVal = [[[SecT193R2Point alloc] initWithCurve:curve withX:X3 withY:L3 withZS:zs withCompression:self.isCompressed] autorelease];
#if !__has_feature(objc_arc)
            if (zs != nil) [zs release]; zs = nil;
#endif
        }
    jumpTo:;
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)twice {
    if ([self isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    
    ECFieldElement *X1 = [self rawXCoord];
    if ([X1 isZero]) {
        // A point with X == 0 is it's own Additive inverse
        return [curve infinity];
    }
    
    ECFieldElement *L1 = [self rawYCoord], *Z1 = (ECFieldElement*)([self rawZCoords][0]);
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        BOOL Z1IsOne = [Z1 isOne];
        ECFieldElement *L1Z1 = Z1IsOne ? L1 : [L1 multiply:Z1];
        ECFieldElement *Z1Sq = Z1IsOne ? Z1 : [Z1 square];
        ECFieldElement *a = [curve a];
        ECFieldElement *aZ1Sq = Z1IsOne ? a : [a multiply:Z1Sq];
        ECFieldElement *T = [[[L1 square] add:L1Z1] add:aZ1Sq];
        if ([T isZero]) {
            retVal = [[SecT193R2Point alloc] initWithCurve:curve withX:T withY:[[curve b] sqrt] withCompression:[self isCompressed]];
        } else {
            ECFieldElement *X3 = [T square];
            ECFieldElement *Z3 = Z1IsOne ? T : [T multiply:Z1Sq];
            
            ECFieldElement *X1Z1 = Z1IsOne ? X1 : [X1 multiply:Z1];
            ECFieldElement *L3 = [[[X1Z1 squarePlusProduct:T withY:L1Z1] add:X3] add:Z3];
            
            NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z3, nil];
            retVal = [[SecT193R2Point alloc] initWithCurve:curve withX:X3 withY:L3 withZS:zs withCompression:self.isCompressed];
#if !__has_feature(objc_arc)
            if (zs != nil) [zs release]; zs = nil;
#endif
        }
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)twicePlus:(ECPoint*)b {
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return [self twice];
    }
    
    ECCurve *curve = [self curve];
    
    ECFieldElement *X1 = [self rawXCoord];
    if ([X1 isZero]) {
        // A point with X == 0 is it's own Additive inverse
        return b;
    }
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        ECFieldElement *X2 = [b rawXCoord], *Z2 = (ECFieldElement*)([b rawZCoords][0]);
        if ([X2 isZero] || ![Z2 isOne]) {
            retVal = [[self twice] add:b];
        } else {
            ECFieldElement *L1 = [self rawYCoord], *Z1 = (ECFieldElement*)([self rawZCoords][0]);
            ECFieldElement *L2 = [b rawYCoord];
            
            ECFieldElement *X1Sq = [X1 square];
            ECFieldElement *L1Sq = [L1 square];
            ECFieldElement *Z1Sq = [Z1 square];
            ECFieldElement *L1Z1 = [L1 multiply:Z1];
            
            ECFieldElement *T = [[[[curve a] multiply:Z1Sq] add:L1Sq] add:L1Z1];
            ECFieldElement *L2plus1 = [L2 addOne];
            ECFieldElement *A = [[[[[curve a] add:L2plus1] multiply:Z1Sq] add:L1Sq] multiplyPlusProduct:T withX:X1Sq withY:Z1Sq];
            ECFieldElement *X2Z1Sq = [X2 multiply:Z1Sq];
            ECFieldElement *B = [[X2Z1Sq add:T] square];
            
            if ([B isZero]) {
                if ([A isZero]) {
                    retVal = [b twice];
                } else {
                    retVal = [curve infinity];
                }
            } else {
                if ([A isZero]) {
                    retVal = [[[SecT193R2Point alloc] initWithCurve:curve withX:A withY:[[curve b] sqrt] withCompression:[self isCompressed]] autorelease];
                } else {
                    ECFieldElement *X3 = [[A square] multiply:X2Z1Sq];
                    ECFieldElement *Z3 = [[A multiply:B] multiply:Z1Sq];
                    ECFieldElement *L3 = [[[A add:B] square] multiplyPlusProduct:T withX:L2plus1 withY:Z3];
                    
                    NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                    retVal = [[[SecT193R2Point alloc] initWithCurve:curve withX:X3 withY:L3 withZS:zs withCompression:self.isCompressed] autorelease];
#if !__has_feature(objc_arc)
                    if (zs != nil) [zs release]; zs = nil;
#endif
                }
            }
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)negate {
    if ([self isInfinity]) {
        return self;
    }
    
    ECFieldElement *X = [self rawXCoord];
    if ([X isZero]) {
        return self;
    }
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        // L is actually Lambda (X + Y/X) here
        ECFieldElement *L = [self rawYCoord], *Z = (ECFieldElement*)([self rawZCoords][0]);
        NSMutableArray *zs = [[NSMutableArray alloc] initWithObjects:Z, nil];
        retVal = [[SecT193R2Point alloc] initWithCurve:[self curve] withX:X withY:[L add:Z] withZS:zs withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
        if (zs != nil) [zs release]; zs = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end

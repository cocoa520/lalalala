//
//  ECPoint.h
//  
//
//  Created by Pallas on 5/5/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ECCurve;
@class ECFieldElement;
@class BigInteger;

@interface ECPoint : NSObject {
@protected
    ECCurve *                                   _m_curve;
    ECFieldElement *                            _m_x;
    ECFieldElement *                            _m_y;
    NSMutableArray *                            _m_zs;                      // ECFieldElement[]
    BOOL                                        _m_withCompression;
    
    NSMutableDictionary *                       _m_preCompTable;            // Dictionary is (string -> PreCompInfo)
}

- (NSMutableDictionary*)m_preCompTable;
- (void)setM_preCompTable:(NSMutableDictionary*)m_preCompTable;

- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression;
// zs == ECFieldElement[]
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement *)x withY:(ECFieldElement *)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression;

- (BOOL)satisfiesCofactor;
- (BOOL)satisfiesCurveEquation;
- (ECPoint*)getDetachedPoint;
- (ECCurve*)curve;
- (ECPoint*)detach;
- (int)curveCoordinateSystem;
- (ECFieldElement*)x;
- (ECFieldElement*)y;
- (ECFieldElement*)affineXCoord;
- (ECFieldElement*)affineYCoord;
- (ECFieldElement*)xCoord;
- (ECFieldElement*)yCoord;
- (ECFieldElement*)getZCoord:(int)index;
// NSMutableArray == ECFieldElement[]
- (NSMutableArray*)getZCoords;
- (ECFieldElement*)rawXCoord;
- (ECFieldElement*)rawYCoord;
// NSMutableArray == ECFieldElement[]
- (NSMutableArray*)rawZCoords;
- (void)checkNormalized;
- (BOOL)isNormalized;
- (ECPoint*)normalize;
- (ECPoint*)normalize:(ECFieldElement*)zInv;
- (ECPoint*)createScaledPoint:(ECFieldElement*)sx withSy:(ECFieldElement*)sy;
- (BOOL)isInfinity;
- (BOOL)isCompressed;
- (BOOL)isValid;
- (ECPoint*)scaleX:(ECFieldElement*)scale;
- (ECPoint*)scaleY:(ECFieldElement*)scale;
- (BOOL)equalsWithOther:(ECPoint*)other;
- (NSString*)toString;
- (NSMutableData*)getEncoded;
- (NSMutableData*)getEncodedWithCompressed:(BOOL)compressed;
- (BOOL)compressionYTilde;
- (ECPoint*)add:(ECPoint*)b;
- (ECPoint*)subtract:(ECPoint*)b;
- (ECPoint*)negate;
- (ECPoint*)timesPow2:(int)e;
- (ECPoint*)twice;
- (ECPoint*)multiply:(BigInteger*)b;
- (ECPoint*)twicePlus:(ECPoint*)b;
- (ECPoint*)threeTimes;

@end

@interface ECPointBase : ECPoint {
@private
}

@end

@interface AbstractFpPoint : ECPointBase {
@private
}

@end

@interface FpPoint : AbstractFpPoint {
@private
}

/**
 * Create a point which encodes without point compression.
 *
 * @param curve the curve to use
 * @param x affine x co-ordinate
 * @param y affine y co-ordinate
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y;

- (ECFieldElement*)two:(ECFieldElement*)x;
- (ECFieldElement*)three:(ECFieldElement*)x;
- (ECFieldElement*)four:(ECFieldElement*)x;
- (ECFieldElement*)eight:(ECFieldElement*)x;
- (ECFieldElement*)doubleProductFromSquares:(ECFieldElement*)a withB:(ECFieldElement*)b withAsquared:(ECFieldElement*)aSquared withBsquared:(ECFieldElement*)bSquared;
- (ECFieldElement*)calculateJacobianModifiedW:(ECFieldElement*)Z withZsquared:(ECFieldElement*)ZSquared;
- (ECFieldElement*)getJacobianModifiedW;
- (FpPoint*)twiceJacobianModified:(BOOL)calculateW;

@end

@interface AbstractF2mPoint : ECPointBase {
@private
}

- (AbstractF2mPoint*)tau;
- (AbstractF2mPoint*)tauPow:(int)pow;

@end

@interface F2mPoint : AbstractF2mPoint {
@private
}

/**
 * @param curve base curve
 * @param x x point
 * @param y y point
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y;
/**
 * Constructor for point at infinity
 */
- (id)initWithCurve:(ECCurve*)curve __deprecated;

@end

//
//  SecT571R1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecT571R1Point;
@class SecT571FieldElement;

@interface SecT571R1Curve : AbstractF2mCurve {
@protected
    SecT571R1Point *                        _m_infinity;
}

+ (SecT571FieldElement*)SecT571R1_B;
+ (SecT571FieldElement*)SecT571R1_B_SQRT;

- (SecT571R1Point*)m_infinity;

- (int)M;
- (BOOL)isTrinomial;
- (int)K1;
- (int)K2;
- (int)K3;

@end

//
//  SecT233K1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecT233K1Point;

@interface SecT233K1Curve : AbstractF2mCurve {
@protected
    SecT233K1Point *                        _m_infinity;
}

- (SecT233K1Point*)m_infinity;

- (int)M;
- (BOOL)isTrinomial;
- (int)K1;
- (int)K2;
- (int)K3;

@end

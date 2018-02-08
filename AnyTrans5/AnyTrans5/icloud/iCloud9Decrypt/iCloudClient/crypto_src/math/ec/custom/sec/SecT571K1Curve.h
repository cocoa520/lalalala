//
//  SecT571K1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecT571K1Point;

@interface SecT571K1Curve : AbstractF2mCurve {
@protected
    SecT571K1Point *                        _m_infinity;
}

- (SecT571K1Point*)m_infinity;

- (int)M;
- (BOOL)isTrinomial;
- (int)K1;
- (int)K2;
- (int)K3;

@end

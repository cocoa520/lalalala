//
//  SecT163R1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecT163R1Point;

@interface SecT163R1Curve : AbstractF2mCurve {
@protected
    SecT163R1Point *                        _m_infinity;
}

- (SecT163R1Point*)m_infinity;

- (int)M;
- (BOOL)isTrinomial;
- (int)K1;
- (int)K2;
- (int)K3;

@end

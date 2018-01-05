//
//  SecT163R2Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecT163R2Point;

@interface SecT163R2Curve : AbstractF2mCurve {
@protected
    SecT163R2Point *                        _m_infinity;
}

- (SecT163R2Point*)m_infinity;

- (int)M;
- (BOOL)isTrinomial;
- (int)K1;
- (int)K2;
- (int)K3;

@end

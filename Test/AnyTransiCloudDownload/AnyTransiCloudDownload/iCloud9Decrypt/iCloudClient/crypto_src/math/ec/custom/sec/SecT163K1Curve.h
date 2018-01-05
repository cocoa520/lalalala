//
//  SecT163K1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//

#import "ECCurve.h"

@class SecT163K1Point;

@interface SecT163K1Curve : AbstractF2mCurve {
@protected
    SecT163K1Point *                        _m_infinity;
}

- (SecT163K1Point*)m_infinity;

- (int)M;
- (BOOL)isTrinomial;
- (int)K1;
- (int)K2;
- (int)K3;

@end

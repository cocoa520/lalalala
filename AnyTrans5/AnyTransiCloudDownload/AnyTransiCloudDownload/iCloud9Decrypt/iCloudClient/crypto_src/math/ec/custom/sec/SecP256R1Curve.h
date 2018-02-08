//
//  SecP256R1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//

#import "ECCurve.h"

@class SecP256R1Point;
@class BigInteger;

@interface SecP256R1Curve : AbstractFpCurve {
@protected
    SecP256R1Point *                        _m_infinity;
}

- (SecP256R1Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

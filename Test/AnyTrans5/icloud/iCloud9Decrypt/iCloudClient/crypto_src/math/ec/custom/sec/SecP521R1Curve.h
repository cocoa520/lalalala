//
//  SecP521R1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecP521R1Point;
@class BigInteger;

@interface SecP521R1Curve : AbstractFpCurve {
@protected
    SecP521R1Point *                        _m_infinity;
}

- (SecP521R1Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

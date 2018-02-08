//
//  SecP128R1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecP128R1Point;
@class BigInteger;

@interface SecP128R1Curve : AbstractFpCurve {
@protected
    SecP128R1Point *                        _m_infinity;
}

+ (BigInteger*)q;

- (SecP128R1Point*)m_infinity;

- (BigInteger*)Q;

@end

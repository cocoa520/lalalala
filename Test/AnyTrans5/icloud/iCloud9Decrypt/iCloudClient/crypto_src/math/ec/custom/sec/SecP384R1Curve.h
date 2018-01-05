//
//  SecP384R1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecP384R1Point;
@class BigInteger;

@interface SecP384R1Curve : AbstractFpCurve {
@protected
    SecP384R1Point *                        _m_infinity;
}

- (SecP384R1Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

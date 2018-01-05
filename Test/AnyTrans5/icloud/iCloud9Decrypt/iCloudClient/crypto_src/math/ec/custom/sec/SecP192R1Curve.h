//
//  SecP192R1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecP192R1Point;
@class BigInteger;

@interface SecP192R1Curve : AbstractFpCurve {
@protected
    SecP192R1Point *                        _m_infinity;
}

- (SecP192R1Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

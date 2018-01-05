//
//  SecP192K1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecP192K1Point;
@class BigInteger;

@interface SecP192K1Curve : AbstractFpCurve {
@protected
    SecP192K1Point *                        _m_infinity;
}

- (SecP192K1Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

//
//  SecP256K1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecP256K1Point;
@class BigInteger;

@interface SecP256K1Curve : AbstractFpCurve {
@protected
    SecP256K1Point *                        _m_infinity;
}

- (SecP256K1Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

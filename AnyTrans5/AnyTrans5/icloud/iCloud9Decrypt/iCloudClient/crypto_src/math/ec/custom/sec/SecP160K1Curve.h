//
//  SecP160K1Curve.h
//  
//
//  Created by Pallas on 6/1/16.
//
//  Complete

#import "ECCurve.h"

@class SecP160K1Point;
@class BigInteger;

@interface SecP160K1Curve : AbstractFpCurve {
@protected
    SecP160K1Point *                        _m_infinity;
}

- (SecP160K1Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

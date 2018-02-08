//
//  SecP224R1Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecP224R1Point;
@class BigInteger;

@interface SecP224R1Curve : AbstractFpCurve {
@protected
    SecP224R1Point *                        _m_infinity;
}

- (SecP224R1Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

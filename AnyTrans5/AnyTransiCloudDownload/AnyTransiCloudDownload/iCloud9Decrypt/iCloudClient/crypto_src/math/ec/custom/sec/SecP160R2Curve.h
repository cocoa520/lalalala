//
//  SecP160R2Curve.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "ECCurve.h"

@class SecP160R2Point;
@class BigInteger;

@interface SecP160R2Curve : AbstractFpCurve {
@protected
    SecP160R2Point *                        _m_infinity;
}

- (SecP160R2Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

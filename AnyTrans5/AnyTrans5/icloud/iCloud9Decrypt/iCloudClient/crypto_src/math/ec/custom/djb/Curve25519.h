//
//  Curve25519.h
//  
//
//  Created by Pallas on 5/25/16.
//
//  Complete

#import "ECCurve.h"

@class Curve25519Point;
@class BigInteger;

@interface Curve25519 : AbstractFpCurve {
@protected
    Curve25519Point *                   _m_infinity;
}

- (Curve25519Point*)m_infinity;

+ (BigInteger*)q;

- (BigInteger*)Q;

@end

//
//  PrimeField.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "IFiniteField.h"

@class BigInteger;

@interface PrimeField : IFiniteField {
@protected
    BigInteger *                    _characteristic;
}

- (BigInteger*)characteristic;

- (id)initWithBigInteger:(BigInteger*)characteristic;

- (int)dimension;

@end

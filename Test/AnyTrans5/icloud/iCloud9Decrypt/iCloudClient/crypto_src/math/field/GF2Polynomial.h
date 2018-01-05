//
//  GF2Polynomial.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "IPolynomial.h"

@interface GF2Polynomial : IPolynomial {
@protected
    NSMutableArray *                _exponents; // int[]
}

- (NSMutableArray*)exponents;

- (id)initWithExponents:(NSMutableArray*)exponents;

@end

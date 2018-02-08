//
//  ParametersWithRandom.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "CipherParameters.h"

@class SecureRandom;

@interface ParametersWithRandom : CipherParameters {
@private
    CipherParameters *                  _parameters;
    SecureRandom *                      _random;
}

- (CipherParameters*)parameters;
- (SecureRandom*)random;

- (id)initWithParameters:(CipherParameters*)parameters withRandom:(SecureRandom*)random;
- (id)initWithParameters:(CipherParameters*)parameters;

- (SecureRandom*)getRandom __deprecated;

@end

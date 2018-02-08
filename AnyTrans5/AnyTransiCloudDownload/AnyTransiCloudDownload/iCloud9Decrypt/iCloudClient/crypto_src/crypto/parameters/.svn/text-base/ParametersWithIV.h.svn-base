//
//  ParametersWithIV.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "CipherParameters.h"

@interface ParametersWithIV : CipherParameters {
@private
    CipherParameters *                      _parameters;
    NSMutableData *                         _iv;
}

- (CipherParameters*)parameters;

- (id)initWithParameters:(CipherParameters*)parameters withIv:(NSMutableData*)iv;
- (id)initWithParameters:(CipherParameters*)parameters withIv:(NSMutableData*)iv withIvOff:(int)ivOff withIvLen:(int)ivLen;

- (NSMutableData*)getIV;

@end

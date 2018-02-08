//
//  DerivationFunction.h
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class DerivationParameters;
@class Digest;

@interface DerivationFunction : NSObject

- (void)init:(DerivationParameters*)parameters;
/**
 * return the message digest used as the basis for the function
 */
- (Digest*)digest;
- (int)generateBytes:(NSMutableData*)output withOutOff:(int)outOff withLength:(int)length;

@end

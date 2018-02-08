//
//  KDFCounterParameters.h
//  
//
//  Created by iMobie on 7/22/16.
//
//  Complete

#import "DerivationParameters.h"

@interface KDFCounterParameters : DerivationParameters {
@private
    NSMutableData *                                 _ki;
    NSMutableData *                                 _fixedInputDataCounterPrefix;
    NSMutableData *                                 _fixedInputDataCounterSuffix;
    int                                             _r;
}

/**
 * Base constructor - suffix fixed input data only.
 *
 * @param ki the KDF seed
 * @param fixedInputDataCounterSuffix  fixed input data to follow counter.
 * @param r length of the counter in bits.
 */
- (id)initWithKi:(NSMutableData*)ki withFixedInputDataCounterSuffix:(NSMutableData*)fixedInputDataCounterSuffix withR:(int)r;
/**
 * Base constructor - prefix and suffix fixed input data.
 *
 * @param ki the KDF seed
 * @param fixedInputDataCounterPrefix fixed input data to precede counter
 * @param fixedInputDataCounterSuffix fixed input data to follow counter.
 * @param r length of the counter in bits.
 */
- (id)initWithKi:(NSMutableData*)ki withFixedInputDataCounterPrefix:(NSMutableData*)fixedInputDataCounterPrefix withFixedInputDataCounterSuffix:(NSMutableData*)fixedInputDataCounterSuffix withR:(int)r;

- (NSMutableData*)getKI;
- (NSMutableData*)getFixedInputData;
- (NSMutableData*)getFixedInputDataCounterPrefix;
- (NSMutableData*)getFixedInputDataCounterSuffix;
- (int)getR;

@end

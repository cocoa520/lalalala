//
//  HKDFParameters.h
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface HKDFParameters : NSObject {
@private
    NSMutableData *                     _ikm;
    BOOL                                _skipExpand;
    NSMutableData *                     _salt;
    NSMutableData *                     _info;
}

/**
 * Generates parameters for HKDF, specifying both the optional salt and
 * optional info. Step 1: Extract won't be skipped.
 *
 * @param ikm  the input keying material or seed
 * @param salt the salt to use, may be null for a salt for hashLen zeros
 * @param info the info to use, may be null for an info field of zero bytes
 */
- (id)initWithIkm:(NSMutableData*)ikm withSalt:(NSMutableData*)salt withInfo:(NSMutableData*)info;

/**
 * Factory method that makes the HKDF skip the extract part of the key
 * derivation function.
 *
 * @param ikm  the input keying material or seed, directly used for step 2:
 *             Expand
 * @param info the info to use, may be null for an info field of zero bytes
 * @return HKDFParameters that makes the implementation skip step 1
 */
+ (HKDFParameters*)skipExtractParameters:(NSMutableData*)ikm withInfo:(NSMutableData*)info;
+ (HKDFParameters*)defaultParameters:(NSMutableData*)ikm;

/**
 * Returns the input keying material or seed.
 *
 * @return the keying material
 */
- (NSMutableData*)getIKM;

/**
 * Returns if step 1: extract has to be skipped or not
 *
 * @return true for skipping, false for no skipping of step 1
 */
- (BOOL)skipExtract;

/**
 * Returns the salt, or null if the salt should be generated as a byte array
 * of HashLen zeros.
 *
 * @return the salt, or null
 */
- (NSMutableData*)getSalt;

/**
 * Returns the info field, which may be empty (null is converted to empty).
 *
 * @return the info field, never null
 */
- (NSMutableData*)getInfo;

@end

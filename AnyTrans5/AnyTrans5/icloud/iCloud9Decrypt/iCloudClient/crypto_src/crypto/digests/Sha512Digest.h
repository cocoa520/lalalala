//
//  Sha512Digest.h
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "LongDigest.h"

@interface Sha512Digest : LongDigest

/**
 * Copy constructor.  This will copy the state of the provided
 * message digest.
 */
- (id)initWithSha512Digest:(Sha512Digest*)t;

@end

//
//  Sha512tDigest.h
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "LongDigest.h"

@interface Sha512tDigest : LongDigest {
@private
    int                                     _digestLength;
    uint64_t                                _h1t;
    uint64_t                                _h2t;
    uint64_t                                _h3t;
    uint64_t                                _h4t;
    uint64_t                                _h5t;
    uint64_t                                _h6t;
    uint64_t                                _h7t;
    uint64_t                                _h8t;
}

/**
 * Standard constructor
 */
- (id)initWithBitLength:(int)bitLength;
/**
 * Copy constructor.  This will copy the state of the provided
 * message digest.
 */
- (id)initWithSha512tDigest:(Sha512tDigest*)t;

@end

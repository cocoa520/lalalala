//
//  Sha1Digest.h
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "GeneralDigest.h"

@interface Sha1Digest : GeneralDigest {
@private
    uint                            _h1;
    uint                            _h2;
    uint                            _h3;
    uint                            _h4;
    uint                            _h5;
    
    NSMutableArray *                _x;
    int                             _xOff;
}

/**
 * Copy constructor.  This will copy the state of the provided
 * message digest.
 */
- (id)initWithSha1Digest:(Sha1Digest*)t;

@end

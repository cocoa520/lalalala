//
//  HMac.h
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "Mac.h"

@class Digest;
@class Memoable;

@interface HMac : Mac {
@private
    Digest *                        _digest;
    int                             _digestSize;
    int                             _blockLength;
    Memoable *                      _ipadState;
    Memoable *                      _opadState;
    
    NSMutableData *                 _inputPad;
    NSMutableData *                 _outputBuf;
}

- (id)initWithDigest:(Digest*)digest;

- (Digest*)getUnderlyingDigest;


@end

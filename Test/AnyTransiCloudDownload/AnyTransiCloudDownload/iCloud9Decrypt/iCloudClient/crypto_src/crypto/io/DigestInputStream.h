//
//  DigestInputStream.h
//
//
//  Created by JGehry on 8/8/16.
//
//
//  Complete

#import "CategoryExtend.h"

@class Digest;

@interface DigestInputStream : Stream {
@protected
    Stream *                                _iN;
    Digest *                                _digest;
}

- (id)initWithStream:(Stream*)stream digest:(Digest*)digest;

- (Digest*)getDigest;

@end

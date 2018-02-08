//
//  Rfc3394WrapEngine.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "Wrapper.h"

@class BlockCipher;
@class KeyParameter;

@interface Rfc3394WrapEngine : Wrapper {
@private
    BlockCipher *                   _engine;
    KeyParameter *                  _param;
    BOOL                            _forWrapping;
    NSMutableData *                 _iv;
}

- (id)initWithEngine:(BlockCipher*)engine;

@end

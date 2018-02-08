//
//  StreamBlockCipher.h
//  
//
//  Created by Pallas on 8/9/16.
//
//  Complete

#import "StreamCipher.h"

@interface StreamBlockCipher : StreamCipher {
@private
    BlockCipher *                           _cipher;
}

- (id)initWithCipher:(BlockCipher*)cipher;

- (BlockCipher*)getUnderlyingCipher;
- (Byte)calculateByte:(Byte)b;

@end

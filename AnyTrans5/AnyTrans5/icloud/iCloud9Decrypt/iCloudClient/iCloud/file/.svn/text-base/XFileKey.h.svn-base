//
//  XFileKey.h
//  
//
//  Created by Pallas on 8/29/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BlockCipher;

@interface XFileKey : NSObject {
@private
    NSMutableData *                         _key;
    BlockCipher *                           _ciphers;
    NSMutableData *                         _flags; // TODO can remove once we have figured the xts/ cbc switches
}

- (BlockCipher*)ciphers;

- (id)initWithKey:(NSMutableData*)key withCiphers:(BlockCipher*)ciphers withFlags:(NSMutableData*)flags;
- (id)initWithKey:(NSMutableData*)key withCiphers:(BlockCipher*)ciphers;

- (NSMutableData*)getKey;
- (NSMutableData*)getFlags;

@end

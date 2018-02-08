//
//  AeadParameters.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "CipherParameters.h"

@class KeyParameter;

@interface AeadParameters : CipherParameters {
@private
    NSMutableData *                 _associatedText;
    NSMutableData *                 _nonce;
    KeyParameter *                  _key;
    int                             _macSize;
}

- (KeyParameter*)key;
- (int)macSize;

/**
 * Base constructor.
 *
 * @param key key to be used by underlying cipher
 * @param macSize macSize in bits
 * @param nonce nonce to be used
 */
- (id)initWithKey:(KeyParameter*)key withMacSize:(int)macSize withNonce:(NSMutableData*)nonce;

/**
 * Base constructor.
 *
 * @param key key to be used by underlying cipher
 * @param macSize macSize in bits
 * @param nonce nonce to be used
 * @param associatedText associated text, if any
 */
- (id)initWithKey:(KeyParameter*)key withMacSize:(int)macSize withNonce:(NSMutableData*)nonce withAssociatedText:(NSMutableData*)associatedText;

- (NSMutableData*)getAssociatedText;

- (NSMutableData*)getNonce;

@end

//
//  KeyParameter.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "CipherParameters.h"

@interface KeyParameter : CipherParameters {
@private
    NSMutableData *                     _key;
}

- (id)initWithKey:(NSMutableData*)key;
- (id)initWithKey:(NSMutableData*)key withKeyOff:(int)keyOff withKeyLen:(int)keyLen;

- (NSMutableData*)getKey;

@end

//
//  KeyBag.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "KeyBagType.h"

@interface KeyBag : NSObject {
@private
    KeyBagTypeEnum                          _type;
    NSMutableData *                         _uuid;
    NSString *                              _uuidBase64;
    NSMutableDictionary *                   _publicKeys;
    NSMutableDictionary *                   _privateKeys;
}

- (KeyBagTypeEnum)type;
- (NSString*)uuidBase64;

- (id)initWithType:(KeyBagTypeEnum)type withUuid:(NSMutableData*)uuid withPublicKeys:(NSMutableDictionary*)publicKeys withPrivateKeys:(NSMutableDictionary*)privateKeys;

- (NSMutableData*)publicKey:(int)protectionClass;
- (NSMutableData*)privateKey:(int)protectionClass;
- (NSMutableData*)getUuid;

@end

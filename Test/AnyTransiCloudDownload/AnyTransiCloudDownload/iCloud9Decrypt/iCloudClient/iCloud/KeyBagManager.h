//
//  KeyBagManager.h
//  
//
//  Created by iMobie on 8/1/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class CloudKitty;
@class ProtectionZone;
@class KeyBag;

@interface KeyBagManager : NSObject {
@private
    CloudKitty *                            _kitty;
    ProtectionZone *                        _mbksync;
    NSMutableDictionary *                   _keyBagDict;
}

+ (KeyBagManager*)create:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync;

- (id)initWithKitty:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync withKeyBagDict:(NSMutableDictionary*)keyBagDict;
- (id)initWithKitty:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync;

- (KeyBagManager*)addKeyBags:(KeyBag*)keyBag,...;
- (NSMutableArray*)keyBags;
- (KeyBag*)keyBag:(NSData*)uuid;
- (KeyBag*)keyBagWithString:(NSString*)uuid;
- (KeyBagManager*)update:(NSArray*)assets withCancel:(BOOL*)cancel;

@end

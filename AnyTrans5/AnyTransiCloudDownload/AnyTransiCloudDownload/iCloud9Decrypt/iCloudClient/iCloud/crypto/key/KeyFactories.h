//
//  KeyFactories.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ECPublicKey;
@class ECPrivateKeyEx;
@class PublicKeyInfo;
@class Key;

@interface KeyFactories : NSObject

+ (Key*)createKeyECPublic:(ECPublicKey*)ecPublicKey withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact;
+ (Key*)createKeyECPrivate:(ECPrivateKeyEx*)ecPrivateKey withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact;

@end
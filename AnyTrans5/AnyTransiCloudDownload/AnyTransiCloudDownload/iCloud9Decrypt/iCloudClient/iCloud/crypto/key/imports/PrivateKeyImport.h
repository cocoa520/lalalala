//
//  PrivateKeyImport.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Key;
@class ECPrivateKeyEx;
@class PublicKeyInfo;

@interface PrivateKeyImport : NSObject

+ (Key*)importPrivateKeyData:(ECPrivateKeyEx*)privateKey withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact;

@end

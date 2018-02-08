//
//  PublicKeyImport.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Key;
@class ECPublicKey;

@interface PublicKeyImport : NSObject

+ (Key*)importPublicKeyData:(ECPublicKey*)publicKey withIsCompact:(BOOL)isCompact;

@end

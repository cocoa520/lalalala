//
//  PrivateSECKeyImport.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "PrivateSECKeyImport.h"
#import "Key.h"
#import "KeyFactories.h"
#import "PrivateKey.h"
#import "PublicKeyInfo.h"

@implementation PrivateSECKeyImport

+ (Key*)importKeyData:(ECPrivateKeyEx*)privateKey withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact {
    return [KeyFactories createKeyECPrivate:privateKey withPublicKeyInfo:publicKeyInfo withIsCompact:isCompact];
}

@end

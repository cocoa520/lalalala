//
//  PublicKeyImport.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "PublicKeyImport.h"
#import "Key.h"
#import "KeyFactories.h"
#import "ECPublicKey.h"

@implementation PublicKeyImport

+ (Key*)importPublicKeyData:(ECPublicKey*)publicKey withIsCompact:(BOOL)isCompact {
    return [KeyFactories createKeyECPublic:publicKey withPublicKeyInfo:nil withIsCompact:isCompact];
}

@end
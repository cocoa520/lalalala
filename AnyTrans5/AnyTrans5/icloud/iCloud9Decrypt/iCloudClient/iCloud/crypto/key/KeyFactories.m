//
//  KeyFactories.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "KeyFactories.h"
#import "Arrays.h"
#import "ECPublicKey.h"
#import "ECPrivateKeyEx.h"
#import "ECKeyExport.h"
#import "ECPublicKeyExportCompact.h"
#import "ECPublicKeyExportX963.h"
#import "Key.h"
#import "KeyID.h"
#import "PublicKeyInfo.h"
#import "Hex.h"

@implementation KeyFactories

+ (NSMutableData*)publicExportData:(ECPublicKey*)key withIsCompact:(BOOL)isCompact {
    ECKeyExport *export = isCompact ? [ECPublicKeyExportCompact instance] : [ECPublicKeyExportX963 instance];
    return [export exportKey:key];
}

+ (void)checkPublicExportData:(NSMutableData*)publicExportData withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo {
//    if (publicKeyInfo != nil) {
//        NSMutableData *publicInfoExportedKeyData = [publicKeyInfo getKey];
//        
//        if ([Arrays areEqualWithByteArray:publicExportData withB:publicInfoExportedKeyData]) {
//            NSLog(@"-- checkPublicExportData() - public export data match: %@", [Hex toHexString:publicExportData]);
//        } else {
//            NSLog(@"-- checkPublicExportData() - public export data mismatch, supplied: %@, public key info: %@", [Hex toHexString:publicExportData], [Hex toHexString:publicInfoExportedKeyData]);
//        }
//    }
}

+ (Key*)createKeyECPublic:(ECPublicKey*)ecPublicKey withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact {
    Key *retKey = nil;
    @try {
        NSMutableData *publicExportData = [KeyFactories publicExportData:ecPublicKey withIsCompact:isCompact];
        [KeyFactories checkPublicExportData:publicExportData withPublicKeyInfo:publicKeyInfo];
        retKey = [[Key alloc] initWithKeyID:[KeyID of:publicExportData] withKeyData:ecPublicKey withPublicExportData:publicExportData withPublicKeyInfo:publicKeyInfo withIsCompact:isCompact];
    }
    @catch (NSException *exception) {
    }
    return (retKey ? [retKey autorelease] : nil);
}

+ (Key*)createKeyECPrivate:(ECPrivateKeyEx*)ecPrivateKey withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact {
    Key *retKey = nil;
    @try {
        NSMutableData *publicExportData = [KeyFactories publicExportData:[ecPrivateKey publicKey] withIsCompact:isCompact];
        [KeyFactories checkPublicExportData:publicExportData withPublicKeyInfo:publicKeyInfo];
        retKey = [[Key alloc] initWithKeyID:[KeyID of:publicExportData] withKeyData:ecPrivateKey withPublicExportData:publicExportData withPublicKeyInfo:publicKeyInfo withIsCompact:isCompact];
    }
    @catch (NSException *exception) {
    }
    return (retKey ? [retKey autorelease] : nil);
}

@end

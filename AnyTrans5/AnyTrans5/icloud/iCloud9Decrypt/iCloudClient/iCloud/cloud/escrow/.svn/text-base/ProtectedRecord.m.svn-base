//
//  ProtectedRecord.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "ProtectedRecord.h"
#import "CategoryExtend.h"
#import "BackupEscrow.h"
#import "BigInteger.h"
#import "DERUtils.h"
#import "ECAssistant.h"
#import "ECurves.h"
#import "ECPrivateKeyEx.h"
#import "PublicKeyInfo.h"
#import "GCMDataB.h"
#import "Hex.h"
#import "Key.h"
#import "KeyID.h"
#import "KeyImports.h"
#import "PZDataUnwrap.h"
#import <objc/runtime.h>

@implementation ProtectedRecord

+ (NSMutableData*)unlockData:(NSData*)metadata withTarget:(id)target withSel:(SEL)sel withFunction:(IMP)function {
    NSMutableData *retDic = nil;
    @autoreleasepool {
        NSMutableDictionary *dictionary = [metadata dataToMutableDictionary];
        NSData *escrowedKeys = [ProtectedRecord kPCSMetadataEscrowedKeys:dictionary];
        BackupEscrow *backupEscrow = [ProtectedRecord backupEscrow:escrowedKeys];
        BigInteger *d = [ProtectedRecord d:backupEscrow withTarget:target withSel:sel withFunction:function];
        NSMutableData *key = [[PZDataUnwrap instance] apply:[backupEscrow getWrappedKey] withD:d];
        retDic = [[GCMDataB decrypt:key withData:[backupEscrow getData]] retain];
    }
    return [retDic autorelease];
}

+ (NSData*)kPCSMetadataEscrowedKeys:(NSDictionary*)metadata {
    NSDictionary *clientMetadata = nil;
    if ([metadata.allKeys containsObject:@"ClientMetadata"]) {
        id obj = [metadata objectForKey:@"ClientMetadata"];
        if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
            clientMetadata = (NSDictionary*)obj;
        }
    }
    
    NSDictionary *secureBackupiCloudDataProtection = nil;
    if (clientMetadata != nil) {
        if ([clientMetadata.allKeys containsObject:@"SecureBackupiCloudDataProtection"]) {
            id obj = [clientMetadata objectForKey:@"SecureBackupiCloudDataProtection"];
            if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
                secureBackupiCloudDataProtection = (NSDictionary*)obj;
            }
        }
    }
    
    NSData *retData = nil;
    if (secureBackupiCloudDataProtection != nil) {
        if ([secureBackupiCloudDataProtection.allKeys containsObject:@"kPCSMetadataEscrowedKeys"]) {
            id obj = [secureBackupiCloudDataProtection objectForKey:@"kPCSMetadataEscrowedKeys"];
            if (obj != nil && [obj isKindOfClass:[NSData class]]) {
                retData = (NSData*)obj;
            }
        }
    }
    
    return retData;
}

+ (BackupEscrow*)backupEscrow:(NSData*)kPCSMetadataEscrowedKeys {
    SEL selector = @selector(initWithASN1Primitive:);
    Class classType = [BackupEscrow class];
    IMP imp = class_getMethodImplementation(classType, selector);
    NSMutableData *tmpData = [kPCSMetadataEscrowedKeys mutableCopy];
    BackupEscrow *backupEscrow = [DERUtils parseWithData:tmpData withClassType:classType withSel:selector withFunction:imp];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
    if (backupEscrow == nil) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"failed to parse escrowed keys" userInfo:nil];
    }
    return backupEscrow;
}

+ (BigInteger*)d:(BackupEscrow*)backupEscrow withTarget:(id)target withSel:(SEL)sel withFunction:(IMP)function {
    KeyID *masterKeyID = nil;
    Key *key = [ProtectedRecord importPublicKey:[backupEscrow getMasterKeyPublic]];
    if (key != nil) {
        masterKeyID = [key keyID];
    }
    
    // Take master key d value if we have it in the key set.
    BigInteger *d = nil;
    if (masterKeyID != nil) {
        typedef Key* (*MethodName)(id, SEL, KeyID*);
        MethodName methodName = (MethodName)function;
        Key *k = methodName(target, sel, masterKeyID);
        if (k != nil) {
            id obj = [k keyData];
            if (obj != nil && [obj isKindOfClass:[ECPrivateKeyEx class]]) {
                d = [(ECPrivateKeyEx*)obj d];
            }
        }
    }
    if (d == nil) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"no master key for escrowed record" userInfo:nil];
    }
    return d;
}

+ (Key*)importPublicKey:(NSData*)keyData {
    // Defaults = SECPR1/ NIST curves.
    NSArray *fieldLengthToCurveName = [ECurves defaults];
    
    // Import keys based on length.
    // TODO non-partial application form
    NSMutableData *tmpData = [keyData mutableCopy];
    Key *retKey = [KeyImports importPublicKey:tmpData withFieldLengthToCurveName:fieldLengthToCurveName withUseCompactKeys:YES];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
    return retKey;
}

+ (void)describe:(NSData*)metadata {
    NSDictionary *dictionary = [metadata dataToDictionary];
    if (dictionary != nil) {
        NSLog(@"-- decryptGetRecordsResponseMetadata() - dictionary: %@", dictionary);
        
        if ([dictionary.allKeys containsObject:@"BackupKeybagDigest"]) {
            id obj = [dictionary objectForKey:@"BackupKeybagDigest"];
            if (obj != nil && [obj isKindOfClass:[NSData class]]) {
                NSLog(@"-- decryptGetRecordsResponseMetadata() - BackupKeybagDigest: 0x%@", [NSString dataToHex:(NSData*)obj]);
            }
        }
        
        if ([dictionary.allKeys containsObject:@"com.apple.securebackup.timestamp"]) {
            id obj = [dictionary objectForKey:@"com.apple.securebackup.timestamp"];
            if (obj != nil && [obj isKindOfClass:[NSString class]]) {
                NSLog(@"-- decryptGetRecordsResponseMetadata() - com.apple.securebackup.timestamp: %@", (NSString*)obj);
            }
        }
        
        NSDictionary *clientMetadata = nil;
        if ([dictionary.allKeys containsObject:@"ClientMetadata"]) {
            id obj = [dictionary objectForKey:@"ClientMetadata"];
            if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
                clientMetadata = (NSDictionary*)obj;
            }
        }
        
        NSDictionary *secureBackupiCloudDataProtection = nil;
        NSMutableData *secureBackupiCloudIdentityPublicData = nil;
        if (clientMetadata != nil) {
            if ([clientMetadata.allKeys containsObject:@"SecureBackupiCloudDataProtection"]) {
                id obj = [clientMetadata objectForKey:@"SecureBackupiCloudDataProtection"];
                if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
                    secureBackupiCloudDataProtection = (NSDictionary*)obj;
                }
            }
            
            if ([clientMetadata.allKeys containsObject:@"SecureBackupiCloudIdentityPublicData"]) {
                id obj = [clientMetadata objectForKey:@"SecureBackupiCloudIdentityPublicData"];
                if (obj != nil && [obj isKindOfClass:[NSData class]]) {
                    secureBackupiCloudIdentityPublicData = [(NSData*)obj mutableCopy];
                }
            }
        }
        
        if (secureBackupiCloudIdentityPublicData != nil) {
            SEL selector = @selector(initWithASN1Primitive:);
            Class classType = [PublicKeyInfo class];
            IMP imp = class_getMethodImplementation(classType, selector);
            id obj = [DERUtils parseWithData:secureBackupiCloudIdentityPublicData withClassType:classType withSel:selector withFunction:imp];
#if !__has_feature(objc_arc)
            if (secureBackupiCloudIdentityPublicData) [secureBackupiCloudIdentityPublicData release]; secureBackupiCloudIdentityPublicData = nil;
#endif
            if (obj != nil && [obj isKindOfClass:classType]) {
                NSLog(@"-- decryptGetRecordsResponseMetadata() - publicKeyInfo: %@", [(PublicKeyInfo*)obj description]);
            }
        }
        
        if ([secureBackupiCloudDataProtection.allKeys containsObject:@"kPCSMetadataEscrowedKeys"]) {
            id obj = [secureBackupiCloudDataProtection objectForKey:@"kPCSMetadataEscrowedKeys"];
            if (obj != nil && [obj isKindOfClass:[NSData class]]) {
                NSLog(@"-- describe() - kPCSMetadataEscrowedKeys: 0x%@", [NSString dataToHex:(NSData *)obj]);
            }
        }
    }
}

@end

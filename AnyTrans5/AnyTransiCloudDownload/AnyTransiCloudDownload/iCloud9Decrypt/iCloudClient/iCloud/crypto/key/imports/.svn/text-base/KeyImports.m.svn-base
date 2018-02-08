//
//  KeyImports.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "KeyImports.h"
#import "CategoryExtend.h"
#import "DERUtils.h"
#import "ECAssistant.h"
#import "ECurves.h"
#import "ECPublicKey.h"
#import "ECPrivateKeyEx.h"
#import "ECPublicKeyImportX963.h"
#import "ECPublicKeyImportCompact.h"
#import "ECPrivateKeyImportCompact.h"
#import "ECPrivateKeyImport.h"
#import "Key.h"
#import "SECPrivateKey.h"
#import "PublicKeyImport.h"
#import "PrivateSECKeyImport.h"
#import "PrivateKeyImport.h"
#import "PrivateKey.h"
#import <objc/runtime.h>

@implementation KeyImports

+ (Key*)importPublicX963Key:(NSMutableData*)keyData withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName {
    ECPublicKeyImportX963 *ecpublic = [ECPublicKeyImportX963 instance];
    NSString *curveName = [ECAssistant fieldLengthToCurveName:fieldLengthToCurveName withDataLength:[ecpublic fieldLength:(int)(keyData.length)]];
    if ([NSString isNilOrEmpty:curveName]) {
        return nil;
    }
    Key *key = nil;
    @autoreleasepool {
        @try {
            ECPublicKey *pubKey = [ecpublic importKey:curveName withData:keyData];
            key = [[PublicKeyImport importPublicKeyData:pubKey withIsCompact:NO] retain];
        }
        @catch (NSException *exception) {
        }
    }
    return (key ? [key autorelease] : nil);
}

+ (Key*)importPublicCompactKey:(NSMutableData*)keyData withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName {
    ECPublicKeyImportCompact *ecpublic = [ECPublicKeyImportCompact instance];
    NSString *curveName = [ECAssistant fieldLengthToCurveName:fieldLengthToCurveName withDataLength:[ecpublic fieldLength:(int)(keyData.length)]];
    if ([NSString isNilOrEmpty:curveName]) {
        return nil;
    }
    Key *key = nil;
    @autoreleasepool {
        @try {
            ECPublicKey *pubKey = [ecpublic importKey:curveName withData:keyData];
            key = [[PublicKeyImport importPublicKeyData:pubKey withIsCompact:YES] retain];
        }
        @catch (NSException *exception) {
        }
    }
    return (key ? [key autorelease] : nil);
}

+ (Key*)importPublicKey:(NSMutableData*)keyData withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName withUseCompactKeys:(BOOL)useCompactKeys {
    Key *retKey = nil;
    @try {
        if (useCompactKeys) {
            Key *key = [KeyImports importPublicCompactKey:keyData withFieldLengthToCurveName:fieldLengthToCurveName];
            if (key != nil) {
                retKey = key;
            } else {
                retKey = [KeyImports importPublicX963Key:keyData withFieldLengthToCurveName:fieldLengthToCurveName];
            }
        } else {
            retKey = [KeyImports importPublicX963Key:keyData withFieldLengthToCurveName:fieldLengthToCurveName];
        }
    }
    @catch (NSException *exception) {
    }
    return retKey;
}

+ (Key*)importPrivateSECKey:(PrivateKey*)privateKey withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName {
    Key *key = nil;
    @try {
        SEL selector = @selector(initWithASN1Primitive:);
        Class classType = [SECPrivateKey class];
        IMP imp = class_getMethodImplementation(classType, selector);
        id obj =[DERUtils parseWithData:[privateKey getPrivateKey] withClassType:classType withSel:selector withFunction:imp];
        SECPrivateKey *secPrivateKey = nil;
        if (obj != nil && [obj isKindOfClass:classType]) {
            secPrivateKey = (SECPrivateKey*)obj;
        }
        if (secPrivateKey == nil) {
            key = nil;
        } else {
            NSMutableData *keyData = [secPrivateKey getPrivateKey];
            ECPrivateKeyImport *ecprivate = [ECPrivateKeyImport instance];
            NSString *curveName = [ECAssistant fieldLengthToCurveName:fieldLengthToCurveName withDataLength:[ecprivate fieldLength:(int)(keyData.length)]];
            if ([NSString isNilOrEmpty:curveName]) {
                key = nil;
            } else {
                @autoreleasepool {
                    ECPrivateKeyEx *privKey = [ecprivate importKey:curveName withData:keyData];
                    key = [[PrivateSECKeyImport importKeyData:privKey withPublicKeyInfo:[privateKey publicKeyInfo] withIsCompact:NO] retain];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    return (key ? [key autorelease] : nil);
}

+ (Key*)importCompactPrivateKey:(PrivateKey*)privateKey withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName {
    Key *key = nil;
    @try {
        ECPrivateKeyImportCompact *ecprivate = [ECPrivateKeyImportCompact instance];
        NSMutableData *keyData = [privateKey getPrivateKey];
        NSString *curveName = [ECAssistant fieldLengthToCurveName:fieldLengthToCurveName withDataLength:[ecprivate fieldLength:(int)(keyData.length)]];
        if ([NSString isNilOrEmpty:curveName]) {
            key = nil;
        } else {
            @autoreleasepool {
                ECPrivateKeyEx *privKey = [ecprivate importKey:curveName withData:keyData];
                key = [[PrivateKeyImport importPrivateKeyData:privKey withPublicKeyInfo:[privateKey publicKeyInfo] withIsCompact:YES] retain];
            }
        }
    }
    @catch (NSException *exception) {
    }
    return (key ? [key autorelease] : nil);
}

+ (Key*)importPrivateKey:(PrivateKey*)privateKey withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName withUseCompactKeys:(BOOL)useCompactKeys {
    Key *retKey = nil;
    if (useCompactKeys) {
        Key *key = [KeyImports importCompactPrivateKey:privateKey withFieldLengthToCurveName:fieldLengthToCurveName];
        if (key != nil) {
            retKey = key;
        } else {
            retKey = [KeyImports importPrivateSECKey:privateKey withFieldLengthToCurveName:fieldLengthToCurveName];
        }
    } else {
        retKey = [KeyImports importPrivateSECKey:privateKey withFieldLengthToCurveName:fieldLengthToCurveName];
    }
    return retKey;
}

@end

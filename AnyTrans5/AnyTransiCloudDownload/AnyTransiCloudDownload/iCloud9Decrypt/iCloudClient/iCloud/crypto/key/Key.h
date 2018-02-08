//
//  Key.h
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class KeyID;
@class PublicKeyInfo;

@interface Key : NSObject<NSCopying, NSMutableCopying> {
@private
    KeyID *                 _keyID;
    id                      _keyData;
    NSMutableData *         _publicExportData;
    PublicKeyInfo *         _publicKeyInfo;
    BOOL                    _isCompact;
    BOOL                    _isTrusted;
}

- (KeyID*)keyID;
- (id)keyData;
- (BOOL)isCompact;
- (BOOL)isTrusted;
- (PublicKeyInfo*)publicKeyInfo;

- (id)initWithKeyID:(KeyID*)keyID withKeyData:(id)keyData withPublicExportData:(NSMutableData*)publicExportData withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact withIsTrusted:(BOOL)isTrusted;
- (id)initWithKeyID:(KeyID*)keyID withKeyData:(id)keyData withPublicExportData:(NSMutableData*)publicExportData withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact;

- (NSMutableData*)exportPublicData;
- (NSNumber*)service;
- (Key*)selfVerify;
- (Key*)verify:(Key*)masterKey;

@end

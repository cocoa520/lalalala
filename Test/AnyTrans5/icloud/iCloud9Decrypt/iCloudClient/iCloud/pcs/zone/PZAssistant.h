//
//  PZAssistant.h
//
//
//  Created by JGehry on 8/1/16.
//
//
//  Complete

#import <Foundation/Foundation.h>

@class ProtectionInfoEx;
@class PZDataUnwrap;
@class EncryptedKeyEx;
@class Key;
@class NOS;

@interface PZAssistant : NSObject {
@private
    NSArray *                                   _fieldLengthToCurveName;
    PZDataUnwrap *                              _dataUnwrap;
    BOOL                                        _useCompactKeys;
}

+ (PZAssistant*)instance;

- (id)initWithfFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName withDataUnwrap:(PZDataUnwrap*)dataUnwrap withUseCompactKeys:(BOOL)useCompactKeys;

- (NSMutableData*)masterKey:(ProtectionInfoEx*)protectionInfo withKeys:(NSMutableDictionary*)keys;
- (NSMutableData*)masterKeyWithEncryptedKeySet:(NSMutableSet*)encryptedKeySet withKeys:(NSMutableDictionary*)keys;
- (EncryptedKeyEx*)encryptedKey:(NSMutableSet*)encryptedKeySet;
- (NSMutableData*)unwrapKey:(EncryptedKeyEx*)encryptedKey withKeys:(NSMutableDictionary*)keys;
- (Key*)importPublicKey:(NSMutableData*)keyData;
- (NSMutableArray*)keysWithEncryptedProtectionInfoData:(NSMutableData*)encryptedProtectionInfoData withKey:(NSMutableData*)key;
- (NSMutableArray*)keysWithProtectionInfoData:(NSMutableData*)protectionInfoData;
- (NSMutableArray*)keysMasterKeySet:(NSMutableSet*)masterKeySet;
- (NSMutableArray*)keys:(NOS*)masterKey;
- (NSMutableArray*)keysWithProtectionInfo:(ProtectionInfoEx*)protectionInfo withKey:(NSMutableData*)key;

@end

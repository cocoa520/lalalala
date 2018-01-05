//
//  Asset.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>
#import "AssetExEncryptedAttributes.h"

@class Asset;

@interface AssetEx : NSObject {
@private
    int                                     _protectionClass;
    int                                     _size;
    int                                     _fileType;
    CFTimeInterval                        _downloadTokenExpiration;
    NSString *                              _dsPrsID;
    NSString *                              _contentBaseURL;
    NSMutableData *                         _fileChecksum;
    NSMutableData *                         _fileSignature;
    NSMutableData *                         _keyEncryptionKey;
    AssetExEncryptedAttributes *  _encryptedAttributes;
    Asset *                                 _asset;
}

- (instancetype)initWithProtectionClass:(int)protectionClass withSize:(int)size withFileType:(int)fileType withDownloadTokenExpiration:(CFTimeInterval)downloadTokenExpiration withDsPrsID:(NSString*)dsPrsID withContentBaseURL:(NSString*)contentBaseURL withFileChecksum:(NSMutableData*)fileChecksum withFileSignature:(NSMutableData*)fileSignature withKeyEncryptionKey:(NSMutableData*)keyEncryptionKey withEncryptedAttributes:(AssetExEncryptedAttributes*)encryptedAttributes withAsset:(Asset*)asset;

- (int)protectionClass;
- (int)size;
- (int)fileType;
- (Asset*)asset;
- (CFTimeInterval)downloadTokenExpiration;
- (NSString*)dsPrsID;
- (NSString*)contentBaseURL;

- (NSMutableData*)getFileChecksum;
- (NSMutableData*)getFileSignature;
- (NSMutableData*)getKeyEncryptionKey;
- (NSString*)domain;
- (NSString*)relativePath;
- (CFTimeInterval)modified;
- (CFTimeInterval)birth;
- (CFTimeInterval)statusChanged;
- (NSNumber*)getUserID;
- (NSNumber*)getGroupID;
- (NSNumber*)getMode;
- (NSMutableData*)getEncryptionKey;
- (NSNumber*)attributeSize;
- (NSMutableData *)attribueChecksum;
- (NSNumber*)getSizeBeforeCopy;
- (NSNumber*)getContentEncodingMethod;
- (NSNumber*)getContentCompressionMethod;

@end

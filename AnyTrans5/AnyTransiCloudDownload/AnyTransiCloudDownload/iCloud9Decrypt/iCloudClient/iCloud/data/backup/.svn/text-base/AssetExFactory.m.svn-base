//
//  AssetFactory.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "AssetExFactory.h"
#import "AssetEx.h"
#import "CategoryExtend.h"
#import "CloudKit.pb.h"
#import "ProtectionZone.h"
#import "AssetExEncryptedAttributesFactory.h"
#import "AssetExEncryptedAttributes.h"

static NSString *CONTENTS = @"contents";
static NSString *ENCRYPTED_ATTRIBUTES = @"encryptedAttributes";
static long DEFAULT_EXPIRATION_SECONDS = 60 * 60;
static long GRACE_TIME_SECONDS = 15 * 60;

@implementation AssetExFactory

+ (AssetEx*)from:(Record*)record withProtectionZone:(ProtectionZone*)protectionZone {
    NSArray *records = [record recordFieldList];
    
    int protectionClass = [self protectionClass:records];
    int fileType = [self fileType:records];
    
//    NSMutableDictionary *encryptedAttributes = nil;
    AssetExEncryptedAttributes *encryptedAttributes = nil;
    NSMutableData *encryptData = [self encryptedAttributes:records];
    if (encryptData != nil) {
        NSMutableData *decryptData = [protectionZone decrypt:encryptData identifierWithString:ENCRYPTED_ATTRIBUTES];
        if (decryptData != nil) {
//            encryptedAttributes = [decryptData dataToMutableDictionary];
            encryptedAttributes = [AssetExEncryptedAttributesFactory from:decryptData];
        }
    }
    
    Asset *asset = [self asset:records];
    
    NSMutableData *keyEncryptionKey = nil;
    NSMutableData *fileChecksum = nil;
    NSMutableData *fileSignature = nil;
    NSString *contentBaseURL = nil;
    NSString *dsPrsID = nil;
    int fileSize = 0L;
    int64_t tokenExpiration = 0LL;
    if (asset != nil) {
        NSMutableData *data = [asset hasData] ? [[[asset data] value] mutableCopy] : nil;
        if (data != nil) {
            keyEncryptionKey = [protectionZone unwrapKey:data];
#if !__has_feature(objc_arc)
            if (data != nil) [data release]; data = nil;
#endif
        }
        
        fileChecksum = [asset hasFileChecksum] ? [[asset fileChecksum] mutableCopy] : nil;
        fileSignature = [asset hasFileSignature] ? [[asset fileSignature] mutableCopy] : nil;
        contentBaseURL = [asset hasContentBaseUrl] ? [asset contentBaseUrl] : nil;
        dsPrsID = [asset hasDsPrsId] ? [asset dsPrsId] : @"";
        fileSize = (int)[asset size];
        tokenExpiration = [asset downloadTokenExpiration];
    }
    
    NSTimeInterval currentTimeSeconds = [[NSDate date] timeIntervalSince1970];
    // Adjust for bad system clocks.
    NSTimeInterval downloadTokenExpiration = tokenExpiration < (currentTimeSeconds + GRACE_TIME_SECONDS) ? (currentTimeSeconds + DEFAULT_EXPIRATION_SECONDS) : tokenExpiration;
    
    AssetEx *newAsset = [[[AssetEx alloc] initWithProtectionClass:protectionClass withSize:fileSize withFileType:fileType withDownloadTokenExpiration:downloadTokenExpiration withDsPrsID:dsPrsID withContentBaseURL:contentBaseURL withFileChecksum:fileChecksum withFileSignature:fileSignature withKeyEncryptionKey:keyEncryptionKey withEncryptedAttributes:encryptedAttributes withAsset:asset] autorelease];
#if !__has_feature(objc_arc)
    if (fileChecksum != nil) [fileChecksum release]; fileChecksum = nil;
    if (fileSignature != nil) [fileSignature release]; fileSignature = nil;
#endif
    return newAsset;
}

+ (NSMutableData *)optional:(NSMutableData *)bytes {
    return [bytes length] == 0 ? nil : bytes;
}

+ (int)protectionClass:(NSArray *)records {
    int value = 0;
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:@"protectionClass"]) {
            value = (int)[[recordField value] signedValue];
            break;
        }
//        else {
//            return -1;
//        }
    }
    return value;
}

+ (int)fileType:(NSArray *)records {
    int value = 0;
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:@"fileType"]) {
            value = (int)[[recordField value] signedValue];
            break;
        }
//        else {
//            return -1;
//        }
    }
    return value;
}

+ (Asset *)asset:(NSArray *)records {
    Asset *asset = nil;
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:CONTENTS]) {
            asset = [[recordField value] assetValue];
            break;
        }
    }
    return asset;
}

+ (NSMutableData *)encryptedAttributes:(NSArray *)records {
    NSMutableData *returnData = [[[NSMutableData alloc] init] autorelease];
    for (RecordField *recordField in records) {
        if ([[[recordField identifier] name] isEqualToString:ENCRYPTED_ATTRIBUTES]) {
            NSData *tmpData = [[recordField value] bytesValue];
            [returnData appendData:tmpData];
            break;
        }
    }
    return returnData;
}

@end

//
//  Asset.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "AssetEx.h"
#import "Arrays.h"
#import "CloudKit.pb.h"

@interface AssetEx ()

@property (nonatomic, assign) int protectionClass;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) int fileType;
@property (nonatomic, assign) CFTimeInterval downloadTokenExpiration;
@property (nonatomic, readwrite, retain) NSString *dsPrsID;
@property (nonatomic, readwrite, retain) NSString *contentBaseURL;
@property (nonatomic, readwrite, retain) NSMutableData *fileChecksum;
@property (nonatomic, readwrite, retain) NSMutableData *fileSignature;
@property (nonatomic, readwrite, retain) NSMutableData *keyEncryptionKey;
@property (nonatomic, readwrite, retain) AssetExEncryptedAttributes *encryptedAttributes;
@property (nonatomic, readwrite, retain) Asset *asset;

@end

@implementation AssetEx
@synthesize protectionClass = _protectionClass;
@synthesize size = _size;
@synthesize fileType = _fileType;
@synthesize downloadTokenExpiration = _downloadTokenExpiration;
@synthesize dsPrsID = _dsPrsID;
@synthesize contentBaseURL = _contentBaseURL;
@synthesize fileChecksum = _fileChecksum;
@synthesize fileSignature = _fileSignature;
@synthesize keyEncryptionKey = _keyEncryptionKey;
@synthesize encryptedAttributes = _encryptedAttributes;
@synthesize asset = _asset;

- (instancetype)initWithProtectionClass:(int)protectionClass withSize:(int)size withFileType:(int)fileType withDownloadTokenExpiration:(CFTimeInterval)downloadTokenExpiration withDsPrsID:(NSString*)dsPrsID withContentBaseURL:(NSString*)contentBaseURL withFileChecksum:(NSMutableData*)fileChecksum withFileSignature:(NSMutableData*)fileSignature withKeyEncryptionKey:(NSMutableData*)keyEncryptionKey withEncryptedAttributes:(AssetExEncryptedAttributes*)encryptedAttributes withAsset:(Asset*)asset {
    if (self = [super init]) {
        if (dsPrsID == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"dsPrsID" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (contentBaseURL == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"contentBaseURL" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (fileChecksum == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"fileChecksum" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (fileSignature == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"fileSignature" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (keyEncryptionKey == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"keyEncryptionKey" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (encryptedAttributes == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"encryptedAttributes" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (asset == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"asset" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setProtectionClass:protectionClass];
        [self setSize:size];
        [self setFileType:fileType];
        [self setDownloadTokenExpiration:downloadTokenExpiration];
        [self setDsPrsID:dsPrsID];
        [self setContentBaseURL:contentBaseURL];
        [self setFileChecksum:fileChecksum];
        [self setFileSignature:fileSignature];
        [self setKeyEncryptionKey:keyEncryptionKey];
        [self setEncryptedAttributes:encryptedAttributes];
        [self setAsset:asset];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_dsPrsID) [_dsPrsID release]; _dsPrsID = nil;
    if (_contentBaseURL) [_contentBaseURL release]; _contentBaseURL = nil;
    if (_fileChecksum) [_fileChecksum release]; _fileChecksum = nil;
    if (_fileSignature) [_fileSignature release]; _fileSignature = nil;
    if (_keyEncryptionKey) [_keyEncryptionKey release]; _keyEncryptionKey = nil;
    if (_encryptedAttributes) [_encryptedAttributes release]; _encryptedAttributes = nil;
    if (_asset) [_asset release]; _asset = nil;
    [super dealloc];
#endif
}

- (NSMutableData *)getFileChecksum {
    NSMutableData *retData = nil;
    if (self.fileChecksum) {
        retData = [Arrays copyOfWithData:[self fileChecksum] withNewLength:(int)[self.fileChecksum length]];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData *)getFileSignature {
    NSMutableData *retData = nil;
    if (self.fileSignature) {
        retData = [Arrays copyOfWithData:[self fileSignature] withNewLength:(int)[self.fileSignature length]];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData *)getKeyEncryptionKey {
    NSMutableData *retData = nil;
    if (self.keyEncryptionKey) {
        retData = [Arrays copyOfWithData:[self keyEncryptionKey] withNewLength:(int)[self.keyEncryptionKey length]];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSString*)domain {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes domain] ? [self.encryptedAttributes domain] : nil) ;
    }
    return nil;
}

- (NSString*)relativePath {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes relativePath] ? [self.encryptedAttributes relativePath] : nil);
    }
    return nil;
}

- (CFTimeInterval)modified {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes modified] ? [self.encryptedAttributes modified] : 0);
    }
    return 0;
}

- (CFTimeInterval)birth {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes birth] ? [self.encryptedAttributes birth] : 0);
    }
    return 0;
}

- (CFTimeInterval)statusChanged {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes statusChanged] ? [self.encryptedAttributes statusChanged] : 0);
    }
    return 0;
}

- (NSNumber*)getUserID {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes userID] ? [self.encryptedAttributes userID] : nil);
    }
    return nil;
}

- (NSNumber*)getGroupID {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes groupID] ? [self.encryptedAttributes groupID] : nil);
    }
    return nil;
}

- (NSNumber*)getMode {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes mode] ? [self.encryptedAttributes mode] : nil);
    }
    return nil;
}

- (NSMutableData *)getEncryptionKey {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes getEncryptionKey] ? [self.encryptedAttributes getEncryptionKey] : nil);
    }
    return nil;
}

- (NSNumber*)attributeSize {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes size] ? [self.encryptedAttributes size] : nil);
    }
    return nil;
}

- (NSMutableData *)attribueChecksum {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes getChecksum] ? [self.encryptedAttributes getChecksum] : nil);
    }
    return nil;
}

- (NSNumber*)getSizeBeforeCopy {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes sizeBeforeCopy] ? [self.encryptedAttributes sizeBeforeCopy] : nil);
    }
    return nil;
}

- (NSNumber*)getContentEncodingMethod {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes contentEncodingMethod] ? [self.encryptedAttributes contentEncodingMethod] : nil);
    }
    return nil;
}

- (NSNumber*)getContentCompressionMethod {
    if (self.encryptedAttributes) {
        return ([self.encryptedAttributes contentCompressionMethod] ? [self.encryptedAttributes contentCompressionMethod] : nil);
    }
    return nil;
}

@end

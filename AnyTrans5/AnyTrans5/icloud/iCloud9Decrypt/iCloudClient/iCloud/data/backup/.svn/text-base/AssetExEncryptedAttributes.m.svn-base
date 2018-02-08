//
//  AssetExEncryptedAttributes.m
//  
//
//  Created by JGehry on 6/15/17.
//
//

#import "AssetExEncryptedAttributes.h"
#import "CategoryExtend.h"
#import "Arrays.h"

@interface AssetExEncryptedAttributes ()

@property (nonatomic, readwrite, retain) NSString *domain;
@property (nonatomic, readwrite, retain) NSString *relativePath;
@property (nonatomic, assign) CFTimeInterval modified;
@property (nonatomic, assign) CFTimeInterval birth;
@property (nonatomic, assign) CFTimeInterval statusChanged;
@property (nonatomic, assign) NSNumber *userID;
@property (nonatomic, assign) NSNumber *groupID;
@property (nonatomic, assign) NSNumber *mode;
@property (nonatomic, assign) NSNumber *size;
@property (nonatomic, readwrite, retain) NSMutableData *encryptionKey;
@property (nonatomic, readwrite, retain) NSMutableData *checksum;
@property (nonatomic, assign) NSNumber *sizeBeforeCopy;
@property (nonatomic, assign) NSNumber *contentEncodingMethod;
@property (nonatomic, assign) NSNumber *contentCompressionMethod;

@end

@implementation AssetExEncryptedAttributes

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setDomain:nil];
    [self setRelativePath:nil];
    [self setEncryptionKey:nil];
    [self setChecksum:nil];
    [super dealloc];
#endif
}

- (instancetype)initWithDomain:(NSString *)domain withRelativePath:(NSString *)relativePath withModified:(CFTimeInterval)modified withBirth:(CFTimeInterval)birth
             withStatusChanged:(CFTimeInterval)statusChanged withUserID:(NSNumber *)userID withGroupID:(NSNumber *)groupID withMode:(NSNumber *)mode withSize:(NSNumber *)size withEncryptionKey:(NSMutableData *)encryptionKey withChecksum:(NSMutableData *)checkSum withSizeBeforeCopy:(NSNumber *)sizeBeforeCopy withContentEncodingMethod:(NSNumber *)contentEncodingMethod withContentCompressionMethod:(NSNumber *)contentCompressionMethod
{
    if (self = [super init]) {
        if (!domain) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"domain" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (!relativePath) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"relativePath" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        self.domain = domain;
        self.relativePath = relativePath;
        self.modified = modified;
        self.birth = birth;
        self.statusChanged = statusChanged;
        self.userID = userID;
        self.groupID = groupID;
        self.mode = mode;
        self.size = size;
        if (encryptionKey) {
            NSMutableData *tmpData = [Arrays copyOfWithData:encryptionKey withNewLength:(int)(encryptionKey.length)];
            self.encryptionKey = (tmpData ? [tmpData autorelease] : nil);
        }
        if (checkSum) {
            NSMutableData *tmpData = [Arrays copyOfWithData:checkSum withNewLength:(int)(checkSum.length)];
            self.checksum = (tmpData ? [tmpData autorelease] : nil);
        }
        self.sizeBeforeCopy = sizeBeforeCopy;
        self.contentEncodingMethod = contentEncodingMethod;
        self.contentCompressionMethod = contentCompressionMethod;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)domain {
    return _domain;
}

- (NSString *)relativePath {
    return _relativePath;
}

- (CFTimeInterval)modified {
    return _modified;
}

- (CFTimeInterval)birth {
    return _birth;
}

- (CFTimeInterval)statusChanged {
    return _statusChanged;
}

- (NSNumber *)userID {
    return _userID;
}

- (NSNumber *)groupID {
    return _groupID;
}

- (NSNumber *)mode {
    return _mode;
}

- (NSNumber *)size {
    return _size;
}

- (NSMutableData *)getEncryptionKey {
    NSMutableData *retData = nil;
    if ([self encryptionKey]) {
        retData = [Arrays copyOfWithData:[self encryptionKey] withNewLength:(int)(self.encryptionKey.length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData *)getChecksum {
    NSMutableData *retData = nil;
    if ([self checksum]) {
        retData = [Arrays copyOfWithData:[self checksum] withNewLength:(int)(self.checksum.length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSNumber *)sizeBeforeCopy {
    return _sizeBeforeCopy;
}

- (NSNumber *)contentEncodingMethod {
    return _contentEncodingMethod;
}

- (NSNumber *)contentCompressionMethod {
    return _contentCompressionMethod;
}

@end

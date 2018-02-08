//
//  AssetExEncryptedAttributes.h
//  
//
//  Created by JGehry on 6/15/17.
//
//

#import <Foundation/Foundation.h>

@interface AssetExEncryptedAttributes : NSObject {
 @private
    NSString *_domain;
    NSString *_relativePath;
    CFTimeInterval _modified;
    CFTimeInterval _birth;
    CFTimeInterval _statusChanged;
    NSNumber *_userID;
    NSNumber *_groupID;
    NSNumber *_mode;
    NSNumber *_size;
    NSMutableData *_encryptionKey;
    NSMutableData *_checksum;
}

- (instancetype)initWithDomain:(NSString *)domain withRelativePath:(NSString *)relativePath withModified:(CFTimeInterval)modified withBirth:(CFTimeInterval)birth
             withStatusChanged:(CFTimeInterval)statusChanged withUserID:(NSNumber *)userID withGroupID:(NSNumber *)groupID withMode:(NSNumber *)mode withSize:(NSNumber *)size withEncryptionKey:(NSMutableData *)encryptionKey withChecksum:(NSMutableData *)checkSum;

- (NSString *)domain;
- (NSString *)relativePath;
- (CFTimeInterval)modified;
- (CFTimeInterval)birth;
- (CFTimeInterval)statusChanged;
- (NSNumber *)userID;
- (NSNumber *)groupID;
- (NSNumber *)mode;
- (NSNumber *)size;
- (NSMutableData *)getEncryptionKey;
- (NSMutableData *)getChecksum;

@end

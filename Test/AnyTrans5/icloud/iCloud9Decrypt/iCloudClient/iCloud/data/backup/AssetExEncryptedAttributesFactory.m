//
//  AssetExEncryptedAttributesFactory.m
//  
//
//  Created by JGehry on 6/15/17.
//
//

#import "AssetExEncryptedAttributesFactory.h"
#import "CategoryExtend.h"
#import "Arrays.h"
#import "CloudKit.pb.h"

@implementation AssetExEncryptedAttributesFactory

+ (NSMutableData *)BPLIST {
    static NSMutableData *_bplist = nil;
    @synchronized(self) {
        if (!_bplist) {
            _bplist = [[NSMutableData alloc] initWithSize:6];
            ((Byte*)(_bplist.bytes))[0] = (Byte)0x62;
            ((Byte*)(_bplist.bytes))[1] = (Byte)0x70;
            ((Byte*)(_bplist.bytes))[2] = (Byte)0x6c;
            ((Byte*)(_bplist.bytes))[3] = (Byte)0x69;
            ((Byte*)(_bplist.bytes))[4] = (Byte)0x73;
            ((Byte*)(_bplist.bytes))[5] = (Byte)0x74;
        }
    }
    return _bplist;
}

+ (AssetExEncryptedAttributes *)from:(NSMutableData *)data withDomain:(NSString *)domain {
    if (data.length == 0) {
        NSLog(@"-- from() - empty data packet");
        return nil;
    }
    
    //parse BPList
    NSMutableData *header = [Arrays copyOfWithData:data withNewLength:(int)([[self BPLIST] length])];
    if ([Arrays areEqualWithByteArray:header withB:[self BPLIST]]) {
        return [self fromBPList:data withDomain:domain];
    }
    
    //Try parse Protobuf
    AssetExEncryptedAttributes *attributes = [self fromProtobuf:data withDomain:domain];
    if (attributes) {
        return attributes;
    }
    return nil;
}

+ (AssetExEncryptedAttributes *)fromProtobuf:(NSMutableData *)data withDomain:(NSString *)domain {
    EncryptedAttributes *tmpEncryptedAttributes = [self parseProtobuf:data];
    return [self fromProtobufWithCloudKit:tmpEncryptedAttributes withDomain:domain];
}

+ (EncryptedAttributes *)parseProtobuf:(NSMutableData *)data {
    @try {
        EncryptedAttributes *attributes = [EncryptedAttributes parseFromData:data];
        if (attributes) {
            return attributes;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+ (AssetExEncryptedAttributes *)fromProtobufWithCloudKit:(EncryptedAttributes *)data withDomain:(NSString *)domain {
    if ([data hasDomain] && ![[data domain] isEqualToString:domain]) {
        NSLog(@"-- fromProtobuf() - domain mismatch: %@ != %@", [data domain], domain);
    }
    NSString *relativePath = [data hasRelativePath] ? [data relativePath] : nil;
    CFTimeInterval modified = [data hasModified] ? [data modified] : 0;
    CFTimeInterval birth = [data hasBirth] ? [data birth] : 0;
    CFTimeInterval statusChanged = [data hasStatusChanged] ? [data statusChanged] : 0;
    NSNumber *userID = [data hasUserId] ? [NSNumber numberWithInt:[data userId]] : 0;
    NSNumber *groupID = [data hasGroupId] ? [NSNumber numberWithInt:[data groupId]] : 0;
    NSNumber *mode = [data hasMode] ? [NSNumber numberWithInt:[data mode]] : 0;
    NSNumber *size = [data hasSize] ? [NSNumber numberWithLongLong:[data size]] : 0;
    NSMutableData *encryptionKey = [data hasEncryptionKey] ? [[data encryptionKey] mutableCopy] : nil;
    NSMutableData *checksum = [data hasSha256Signature] ? [[data sha256Signature] mutableCopy] : nil;
    NSNumber *sizeBeforeCopy = [data hasSizeBeforeCopy] ? [NSNumber numberWithLongLong:[data sizeBeforeCopy]] : 0;
    NSNumber *contentEncodingMethod = [data hasContentEncodingMethod] ? [NSNumber numberWithInt:[data contentEncodingMethod]] : 0;
    NSNumber *contentCompressionMethod = [data hasContentCompressionMethod] ? [NSNumber numberWithInt:[data contentCompressionMethod]] : 0;
    AssetExEncryptedAttributes *attributes = [[AssetExEncryptedAttributes alloc] initWithDomain:domain withRelativePath:relativePath withModified:modified
                                                                                      withBirth:birth withStatusChanged:statusChanged withUserID:userID withGroupID:groupID
                                                                                       withMode:mode withSize:size withEncryptionKey:encryptionKey withChecksum:checksum withSizeBeforeCopy:sizeBeforeCopy withContentEncodingMethod:contentEncodingMethod withContentCompressionMethod:contentCompressionMethod];
    return attributes;
}

+ (AssetExEncryptedAttributes *)fromBPList:(NSMutableData *)data withDomain:(NSString *)domain {
    NSDictionary *dict = [data dataToDictionary];
    return [self fromDictionary:dict withDomain:domain];
}

+ (AssetExEncryptedAttributes *)fromDictionary:(NSDictionary *)data withDomain:(NSString *)domain {
    NSString *tmpDomain = nil;
    NSArray *allKey = [data allKeys];
    if ([allKey containsObject:@"domain"]) {
        id obj = [data objectForKey:@"domain"];
        if (obj && [obj isKindOfClass:[NSString class]]) {
            tmpDomain = (NSString *)obj;
            if (![tmpDomain isEqualToString:domain]) {
                NSLog(@"-- fromDictionary() - domain mismatch: %@ != %@", tmpDomain, domain);
            }
        }
    }
    NSString *relativePath = nil;
    if ([allKey containsObject:@"relativePath"]) {
        id obj = [data objectForKey:@"relativePath"];
        if (obj && [obj isKindOfClass:[NSString class]]) {
            relativePath = (NSString *)obj;
        }
    }
    CFTimeInterval modified = 0;
    if ([allKey containsObject:@"modified"]) {
        id obj = [data objectForKey:@"modified"];
        if (obj && [obj isKindOfClass:[NSDate class]]) {
            modified = (int)obj;
        }
    }
    CFTimeInterval birth = 0;
    if ([allKey containsObject:@"birth"]) {
        id obj = [data objectForKey:@"birth"];
        if (obj && [obj isKindOfClass:[NSDate class]]) {
            birth = (int)obj;
        }
    }
    CFTimeInterval statusChanged = 0;
    if ([allKey containsObject:@"statusChanged"]) {
        id obj = [data objectForKey:@"statusChanged"];
        if (obj && [obj isKindOfClass:[NSDate class]]) {
            statusChanged = (int)obj;
        }
    }
    NSNumber *userID = 0;
    if ([allKey containsObject:@"userID"]) {
        id obj = [data objectForKey:@"userID"];
        if (obj && [obj isKindOfClass:[NSNumber class]]) {
            userID  = (NSNumber *)obj;
        }
    }
    NSNumber *groupID = 0;
    if ([allKey containsObject:@"groupID"]) {
        id obj = [data objectForKey:@"groupID"];
        if (obj && [obj isKindOfClass:[NSNumber class]]) {
            groupID = (NSNumber *)obj;
        }
    }
    NSNumber *mode = 0;
    if ([allKey containsObject:@"mode"]) {
        id obj = [data objectForKey:@"mode"];
        if (obj && [obj isKindOfClass:[NSNumber class]]) {
            mode = (NSNumber *)obj;
        }
    }
    NSNumber *size = 0;
    if ([allKey containsObject:@"size"]) {
        id obj = [data objectForKey:@"size"];
        if (obj && [obj isKindOfClass:[NSNumber class]]) {
            size = (NSNumber *)obj;
        }
    }
    NSMutableData *encryptionKey = nil;
    if ([allKey containsObject:@"encryptionKey"]) {
        id obj = [data objectForKey:@"encryptionKey"];
        if (obj && [obj isKindOfClass:[NSData class]]) {
            encryptionKey = (NSMutableData *)obj;
        }
    }
    NSMutableData *checksum = nil;
    NSNumber *sizeBeforeCopy = 0;
    NSNumber *contentEncodingMethod = 0;
    NSNumber *contentCompressionMethod = 0;
    AssetExEncryptedAttributes *attributes = [[AssetExEncryptedAttributes alloc] initWithDomain:domain withRelativePath:relativePath withModified:modified
                                                                                                                       withBirth:birth withStatusChanged:statusChanged withUserID:userID withGroupID:groupID
                                                                                                                       withMode:mode withSize:size withEncryptionKey:encryptionKey withChecksum:checksum withSizeBeforeCopy:sizeBeforeCopy withContentEncodingMethod:contentEncodingMethod withContentCompressionMethod:contentCompressionMethod];
    return attributes;
}

@end

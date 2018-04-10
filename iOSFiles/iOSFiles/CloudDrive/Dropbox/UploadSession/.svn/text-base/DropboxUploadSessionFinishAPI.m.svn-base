//
//  DropboxUploadSessionFinishAPI.m
//  DriveSync
//
//  Created by JGehry on 1/12/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "DropboxUploadSessionFinishAPI.h"

@implementation DropboxUploadSessionFinishAPI

- (NSString *)baseUrl {
    return DropboxContentBaseURL;
}

- (NSString *)requestUrl {
    return DropboxUploadSessionFinish;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accestoken];
    NSString *uploadItem = nil;
    NSString *cursor = [NSString stringWithFormat:@"{\"session_id\":\"%@\", \"offset\": %lld}", _uploadSessionID, _uploadFileSize];
    if ([_parent rangeOfString:@"0"].location != NSNotFound) {
        NSString *commit = [NSString stringWithFormat:@"{\"path\":\"/%@\"}", _fileName];
        uploadItem = [NSString stringWithFormat:@"{\"cursor\": %@, \"commit\" : %@}", cursor, commit];
    }else {
        NSString *commit = [NSString stringWithFormat:@"{\"path\":\"%@/%@\"}", _parent, _fileName];
        uploadItem = [NSString stringWithFormat:@"{\"cursor\": %@, \"commit\" : %@}", cursor, commit];
    }
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Content-Type": @"application/octet-stream",
             @"Dropbox-API-Arg": uploadItem
             };
}

@end

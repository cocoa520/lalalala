//
//  DropboxUploadSessionAppendAPI.m
//  DriveSync
//
//  Created by JGehry on 1/12/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "DropboxUploadSessionAppendAPI.h"

@implementation DropboxUploadSessionAppendAPI

- (NSString *)baseUrl {
    return DropboxContentBaseURL;
}

- (NSString *)requestUrl {
    return DropboxUploadSessionAppend;
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
    NSString *cursor = [NSString stringWithFormat:@"{\"session_id\":\"%@\",\"offset\":%lld}", _uploadSessionID, _uploadFileSize];
    NSString *uploadItem = [NSString stringWithFormat:@"{\"cursor\":%@,\"close\":false}", cursor];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Content-Type": @"application/octet-stream",
             @"Dropbox-API-Arg": uploadItem,
             };
}

@end

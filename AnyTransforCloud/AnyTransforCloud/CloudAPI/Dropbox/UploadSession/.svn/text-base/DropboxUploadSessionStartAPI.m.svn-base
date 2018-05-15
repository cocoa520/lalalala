//
//  DropboxUploadSessionStartAPI.m
//  DriveSync
//
//  Created by JGehry on 1/12/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "DropboxUploadSessionStartAPI.h"

@implementation DropboxUploadSessionStartAPI

- (NSString *)baseUrl {
    return DropboxContentBaseURL;
}

- (NSString *)requestUrl {
    return DropboxUploadSessionStart;
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
    NSString *uploadItem = [NSString stringWithFormat:@"{\"close\":false}"];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Content-Type": @"application/octet-stream",
             @"Dropbox-API-Arg": uploadItem,
             };
}

@end

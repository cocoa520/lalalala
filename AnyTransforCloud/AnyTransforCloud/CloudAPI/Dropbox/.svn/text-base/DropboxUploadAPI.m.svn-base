//
//  DropboxUploadAPI.m
//  DriveSync
//
//  Created by JGehry on 12/5/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "DropboxUploadAPI.h"

@implementation DropboxUploadAPI

- (NSString *)baseUrl {
    return DropboxContentBaseURL;
}

- (NSString *)requestUrl {
    return DropboxUploadFilePath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accestoken];
    NSString *uploadItem = nil;
    NSString *range = [NSString stringWithFormat:@"bytes %lld-%lld/%lld", _uploadRangeStart, _uploadRangeEnd, _uploadFileSize];
    NSLog(@"range: %@", range);
    if ([_parent rangeOfString:@"0"].location != NSNotFound) {
        uploadItem = [NSString stringWithFormat:@"{\"path\":\"/%@\"}", [BaseDriveAPI zhAndJpToUnicode:_fileName]];
    }else {
        uploadItem = [NSString stringWithFormat:@"{\"path\":\"%@/%@\"}", _parent, _fileName];
        uploadItem = [BaseDriveAPI zhAndJpToUnicode:uploadItem];
    }
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Content-Type": @"application/octet-stream",
             @"Dropbox-API-Arg": uploadItem,
             @"Content-Range": range,
             };
}

@end

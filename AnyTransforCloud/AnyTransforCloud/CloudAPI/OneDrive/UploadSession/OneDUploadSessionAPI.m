//
//  OneDUploadSessionAPI.m
//  DriveSync
//
//  Created by JGehry on 1/9/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "OneDUploadSessionAPI.h"

@implementation OneDUploadSessionAPI

- (NSString *)baseUrl
{
    return _uploadUrl;
}

- (NSString *)requestUrl
{
    return @"";
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSString *range = [NSString stringWithFormat:@"bytes %lld-%lld/%lld", _uploadRangeStart, _uploadRangeEnd, _uploadFileSize];
    return @{
             @"Content-Range": range
             };
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPUT;
}

@end

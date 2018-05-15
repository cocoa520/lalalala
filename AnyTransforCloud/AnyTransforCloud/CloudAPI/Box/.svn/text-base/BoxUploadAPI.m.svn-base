//
//  BoxUploadAPI.m
//  DriveSync
//
//  Created by JGehry on 1/2/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxUploadAPI.h"

@implementation BoxUploadAPI

- (NSString *)baseUrl {
    return BoxAPIContentBaseURL;
}

- (NSString *)requestUrl {
    return BoxUploadFilePath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accestoken];
    NSString *range = [NSString stringWithFormat:@"bytes %lld-%lld/%lld", _uploadRangeStart, _uploadRangeEnd, _uploadFileSize];
    NSString *length = [NSString stringWithFormat:@"%lld", _uploadFileSize];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"content-range": range,
             @"content-length": length,
             @"Content-Type": @"application/octet-stream"
             };
}

@end

//
//  DropboxDownloadAPI.m
//  DriveSync
//
//  Created by JGehry on 12/5/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "DropboxDownloadAPI.h"

@implementation DropboxDownloadAPI

- (NSString *)baseUrl {
    return DropboxContentBaseURL;
}

- (NSString *)requestUrl {
    return DropboxDownloadFilePath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accestoken];
    NSString *folderName = nil;
    if (_parent) {
        folderName = [NSString stringWithFormat:@"/%@/%@", _parent, _folderName];
    }else {
        if ([_folderName rangeOfString:@"id:"].location != NSNotFound) {
            folderName = [NSString stringWithFormat:@"%@", _folderName];
        }else {
            folderName = [NSString stringWithFormat:@"/%@", _folderName];
        }
    }
    NSString *downloadItem = [NSString stringWithFormat:@"{\"path\":\"%@\"}", folderName];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Content-Type": @"application/octet-stream",
             @"Dropbox-API-Arg": downloadItem
             };
}

- (id)requestArgument {
    NSString *folderName = [NSString stringWithFormat:@"/%@/%@", _parent, _folderName];
    return @{
             @"path": folderName
             };
}

@end

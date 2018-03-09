//
//  DropboxMultipleDeleteItemsAPI.m
//  DriveSync
//
//  Created by JGehry on 12/8/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "DropboxMultipleDeleteItemsAPI.h"

@implementation DropboxMultipleDeleteItemsAPI

- (NSString *)baseUrl {
    return DropboxAPIBaseURL;
}

- (NSString *)requestUrl {
    return DropboxDeleteMultipleFolderAndFilePath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSString *folderName = [NSString stringWithFormat:@"/%@/%@", _parent, _folderName];
    return @{
             @"path": folderName
             };
}

@end

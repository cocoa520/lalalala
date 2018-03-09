//
//  DropboxCreateFolderAPI.m
//  DriveSync
//
//  Created by JGehry on 12/5/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "DropboxCreateFolderAPI.h"

@implementation DropboxCreateFolderAPI

- (NSString *)baseUrl {
    return DropboxAPIBaseURL;
}

- (NSString *)requestUrl {
    return DropboxCreateFolderPath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSString *folderName = nil;
    if (![_parent isEqualToString:@""] && _parent) {
        if ([_parent rangeOfString:@"0"].location != NSNotFound) {
            folderName = [NSString stringWithFormat:@"/%@", _folderName];
        }else {
            folderName = [NSString stringWithFormat:@"/%@/%@", _parent, _folderName];
        }
    }else {
        folderName = [NSString stringWithFormat:@"/%@", _folderName];
    }
    return @{
             @"path": folderName,
             @"autorename": @YES
             };
}

@end

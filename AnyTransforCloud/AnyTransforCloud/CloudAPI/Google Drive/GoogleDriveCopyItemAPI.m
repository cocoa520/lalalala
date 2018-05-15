//
//  GoogleDriveCopyItemAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/3.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GoogleDriveCopyItemAPI.h"

@implementation GoogleDriveCopyItemAPI

- (NSString *)baseUrl
{
    return GoogleDriveAPIBaseURL;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:GoogleDriveCopyFolderAndFilePath,_folderOrfileID];
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"parents": @[_newParentIDOrPath]
             };
}

@end

//
//  OneDCopyItemAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/3.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "OneDCopyItemAPI.h"

@implementation OneDCopyItemAPI

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:OneDriveCopyPath,_folderOrfileID];
    return url;
}

- (id)requestArgument
{
    if ([_newParentIDOrPath isEqualToString:@"0"]) {
        return @{@"parentReference":@{@"driveId": _newParentDriveIDOrPath, @"path": @"/drive/root:"}};
    }else {
        return @{@"parentReference":@{@"driveId": _newParentDriveIDOrPath, @"path": _newParentIDOrPath}};
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

@end

//
//  GoogleDriveMoveToNewParentAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/10.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "GoogleDriveMoveToNewParentAPI.h"

@implementation GoogleDriveMoveToNewParentAPI

- (NSString *)baseUrl
{
    return GoogleDriveAPIBaseURL;
}

- (NSString *)requestUrl
{
    if ([_parent isEqualToString:@"0"]) {
        _parent = @"root";
    }
    if ([_newParentIDOrPath isEqualToString:@"0"]) {
        _newParentIDOrPath = @"root";
    }
    NSString *url = nil;
    url = [NSString stringWithFormat:GoogleDriveMoveFolderAndFilePath,_folderOrfileID,_newParentIDOrPath,_parent];
    return url;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPATCH;
}

@end

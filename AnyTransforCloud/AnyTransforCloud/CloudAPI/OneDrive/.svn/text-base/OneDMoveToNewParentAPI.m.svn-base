//
//  OneDMoveToNewParentAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/10.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "OneDMoveToNewParentAPI.h"

@implementation OneDMoveToNewParentAPI

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:OneDriveReNamePath,_folderOrfileID];
    return url;
}

- (id)requestArgument
{
    if ([_newParentIDOrPath isEqualToString:@"0"]) {
        return @{@"parentReference": @{@"path": @"/drive/root:"}};
    }else {
        return @{@"parentReference": @{@"path": _newParentIDOrPath}};
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPATCH;
}

@end

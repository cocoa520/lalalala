//
//  OneDCreateFolderAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/5.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "OneDCreateFolderAPI.h"

@implementation OneDCreateFolderAPI

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    if ([_parent isEqualToString:@"0"]) {
        url = OneDriveRootChildrenPath;
    }else{
        url = [NSString stringWithFormat:OneDriveCreateFolderPath,_parent];
    }
    return url;
}

- (id)requestArgument
{
    return @{@"name":_folderName,@"folder":@{},@"@microsoft.graph.conflictBehavior":@"rename"};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

@end

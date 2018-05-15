//
//  OneDGetListAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/5.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "OneDGetListAPI.h"

@implementation OneDGetListAPI
#pragma mark - 请求的各个参数配置

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    if ([_folderOrfileID isEqualToString:@"0"]) {
        url = OneDriveRootChildrenPath;
    }else{
        url = [NSString stringWithFormat:OneDriveChildrenPath,_folderOrfileID];
    }
    return url;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

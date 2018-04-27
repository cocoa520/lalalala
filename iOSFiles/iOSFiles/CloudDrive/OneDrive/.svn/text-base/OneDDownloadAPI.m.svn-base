//
//  OneDDownloadAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/5.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "OneDDownloadAPI.h"

@implementation OneDDownloadAPI

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:OneDriveDownloadFilePath,_folderOrfileID];
    return url;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

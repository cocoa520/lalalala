//
//  OneDDeleteItemAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/5.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "OneDDeleteItemAPI.h"

@implementation OneDDeleteItemAPI

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:OneDriveDeleteFilePath,_folderOrfileID];
    return url;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodDELETE;
}

@end

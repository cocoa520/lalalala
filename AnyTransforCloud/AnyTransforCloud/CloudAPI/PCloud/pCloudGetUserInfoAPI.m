//
//  pCloudGetUserInfoAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/20.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloudGetUserInfoAPI.h"

@implementation pCloudGetUserInfoAPI
- (NSString *)baseUrl
{
    return pCloudBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = pCloudGetUserInfoPath;
    return url;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}
@end

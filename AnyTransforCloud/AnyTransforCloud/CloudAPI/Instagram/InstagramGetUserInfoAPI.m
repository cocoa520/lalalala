//
//  InstagramGetUserInfoAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/19.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "InstagramGetUserInfoAPI.h"

@implementation InstagramGetUserInfoAPI

- (NSString *)baseUrl
{
    return InstagramBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = [NSString stringWithFormat:InstagramGetUserInfoPath
                     ,_accestoken];
    return url;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

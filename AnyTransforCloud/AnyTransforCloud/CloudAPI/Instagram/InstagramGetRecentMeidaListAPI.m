//
//  InstagramGetRecentMeidaListAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/12.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "InstagramGetRecentMeidaListAPI.h"

@implementation InstagramGetRecentMeidaListAPI

- (NSString *)baseUrl
{
    return InstagramBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = [NSString stringWithFormat:InstagramGetRecentMediaPath
                     ,_accestoken];
    return url;
}


- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

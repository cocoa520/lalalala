//
//  pCloudGetListAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/20.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloudGetListAPI.h"

@implementation pCloudGetListAPI

- (NSString *)baseUrl
{
    return pCloudBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = pCloudGetListPath;
    return url;
}

- (id)requestArgument
{
    return @{@"folderid":_folderOrfileID};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}


@end

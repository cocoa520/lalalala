//
//  pCloudgetFileLinkAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/21.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloudgetFileLinkAPI.h"

@implementation pCloudgetFileLinkAPI

- (NSString *)baseUrl
{
    return pCloudBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = pCloudgetFileLinkPath;
    return url;
}

- (id)requestArgument
{
   return @{@"fileid":_folderOrfileID};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

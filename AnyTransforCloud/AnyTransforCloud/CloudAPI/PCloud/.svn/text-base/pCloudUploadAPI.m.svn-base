//
//  pCloudUploadAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/22.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloudUploadAPI.h"

@implementation pCloudUploadAPI

- (NSString *)baseUrl
{
    return pCloudBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = pCloudUploadPath;
    return url;
}

- (id)requestArgument
{
    NSDictionary *dic = @{@"filename":_fileName,@"folderid":_parent,@"renameifexists":@(1)};
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

@end

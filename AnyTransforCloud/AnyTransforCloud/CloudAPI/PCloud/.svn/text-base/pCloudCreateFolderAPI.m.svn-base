//
//  pCloudCreateFolderAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/20.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloudCreateFolderAPI.h"

@implementation pCloudCreateFolderAPI

- (NSString *)baseUrl
{
    return pCloudBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = pCloudCreateFolderPath;
    return url;
}

- (id)requestArgument
{
    NSDictionary *dic = @{@"name":_folderName,@"folderid":_parent};
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}
@end

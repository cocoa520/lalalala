//
//  pCloudDeleteItemAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/21.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloudDeleteItemAPI.h"

@implementation pCloudDeleteItemAPI

- (NSString *)baseUrl
{
    return pCloudBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    if (_isFolder) {
        url = pCloudDeleteFolderPath;
    }else{
        url = pCloudDeleteFilePath;
    }
    return url;
}

- (id)requestArgument
{
    if (_isFolder) {
        return @{@"folderid":_folderOrfileID};
    }else{
        return @{@"fileid":_folderOrfileID};
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

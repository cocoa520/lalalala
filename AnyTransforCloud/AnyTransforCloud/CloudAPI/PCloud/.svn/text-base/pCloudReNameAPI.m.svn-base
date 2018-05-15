//
//  pCloudReNameFileAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/21.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloudReNameAPI.h"

@implementation pCloudReNameAPI

- (NSString *)baseUrl
{
    return pCloudBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    if (_isFolder) {
        url = pCloudReNameFolderPath;

    }else{
        url = pCloudReNameFilePath;

    }
    return url;
}

- (id)requestArgument
{
    if (_isFolder) {
        return @{@"toname":_newName,@"folderid":_folderOrfileID};

    }else{
        return @{@"toname":_newName,@"fileid":_folderOrfileID};
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

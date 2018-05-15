//
//  pCloudMoveToNewParentAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/21.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloudMoveToNewParentAPI.h"

@implementation pCloudMoveToNewParentAPI

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
        return @{@"folderid":_folderOrfileID,@"tofolderid":_newParentIDOrPath};
        
    }else{
        return @{@"fileid":_folderOrfileID,@"tofolderid":_newParentIDOrPath};
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

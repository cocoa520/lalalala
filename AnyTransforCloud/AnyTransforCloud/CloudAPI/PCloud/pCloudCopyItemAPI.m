//
//  pCloudCopyItemAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/3.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "pCloudCopyItemAPI.h"

@implementation pCloudCopyItemAPI

- (NSString *)baseUrl
{
    return pCloudBaseURL;
}

- (NSString *)requestUrl
{
    return pCloudCopyFilePath;
}

- (id)requestArgument
{
    return @{@"fileid":_folderOrfileID,@"tofolderid":_newParentIDOrPath};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

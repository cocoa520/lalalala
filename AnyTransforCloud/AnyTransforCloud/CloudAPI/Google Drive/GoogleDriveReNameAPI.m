//
//  GoogleDriveReNameAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/10.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "GoogleDriveReNameAPI.h"

@implementation GoogleDriveReNameAPI

- (NSString *)baseUrl
{
    return GoogleDriveAPIBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:GoogleDriveDeleteFolderAndFilePath,_folderOrfileID];
    return url;
}

- (id)requestArgument
{
    return @{@"name":_newName};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPATCH;
}

@end

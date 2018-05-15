//
//  GoogleDriveDeleteItemAPI.m
//  DriveSync
//
//  Created by Sean on 1/3/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GoogleDriveDeleteItemAPI.h"

@implementation GoogleDriveDeleteItemAPI

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

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodDELETE;
}

@end

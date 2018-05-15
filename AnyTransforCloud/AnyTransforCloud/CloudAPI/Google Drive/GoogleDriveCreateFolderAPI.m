//
//  GoogleDriveCreateFolderAPI.m
//  DriveSync
//
//  Created by Sean on 1/3/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GoogleDriveCreateFolderAPI.h"

@implementation GoogleDriveCreateFolderAPI

- (NSString *)baseUrl
{
    return GoogleDriveAPIBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = GoogleDriveGetListPath;
    return url;
}

- (id)requestArgument
{
    if ([_parent isEqualToString:@"0"]) {
        NSDictionary *dic = @{@"name":_folderName,@"mimeType":@"application/vnd.google-apps.folder",@"parents":@[@"root"]};
        return dic;
    }else{
        return @{@"name":_folderName,@"mimeType":@"application/vnd.google-apps.folder",@"parents":@[_parent]};
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

@end

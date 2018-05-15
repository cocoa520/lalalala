//
//  OneDGetFolderAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/11.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "OneDGetFolderAPI.h"

@implementation OneDGetFolderAPI

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    if ([_folderOrfileID isEqualToString:@"0"]) {
        url = OneDriveRootChildrenPath;
    }else{
        url = [NSString stringWithFormat:OneDriveFolderPath,_folderOrfileID];
    }
    return url;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end

//
//  OneDUploadAPI.m
//  DriveSync
//
//  Created by JGehry on 12/11/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "OneDUploadAPI.h"

@implementation OneDUploadAPI

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    if ([_parent isEqualToString:@"0"]) {
        _parent = @"root";
        url = [NSString stringWithFormat:OneDriveUploadFilePath, _parent, _fileName];
    }else {
        url = [NSString stringWithFormat:OneDriveUploadFilePath, _parent, _fileName];
    }
    return url;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPUT;
}

@end

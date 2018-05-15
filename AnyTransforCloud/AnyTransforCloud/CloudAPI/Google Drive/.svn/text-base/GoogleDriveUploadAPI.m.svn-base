//
//  GoogleDriveUploadAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/5.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "GoogleDriveUploadAPI.h"

@implementation GoogleDriveUploadAPI

- (NSString *)baseUrl
{
    return GoogleDriveAPIBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = GoogleDriveUploadFilePath;
    return url;
}

- (id)requestArgument
{
    if ([_parent isEqualToString:@"0"]) {
        NSDictionary *dic = @{@"name":_fileName,@"parents":@[@"root"]};
        return dic;
    }else{
        return @{@"name":_fileName,@"parents":@[_parent]};
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

@end

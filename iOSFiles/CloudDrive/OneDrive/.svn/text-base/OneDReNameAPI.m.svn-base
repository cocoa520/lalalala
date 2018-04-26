//
//  OneDReNameAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/10.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "OneDReNameAPI.h"

@implementation OneDReNameAPI

- (NSString *)baseUrl
{
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:OneDriveReNamePath,_folderOrfileID];
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

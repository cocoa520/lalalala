//
//  OneDriveRefreshTokenAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/24.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "OneDriveRefreshTokenAPI.h"

@implementation OneDriveRefreshTokenAPI

- (NSString *)baseUrl {
    return OneDriveRefreshEndPointURL;
}

- (NSString *)requestUrl {
    return OneDriveRefreshAccessToken;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (id)requestArgument {
    return @{
             @"client_id":_clientID,
             @"redirect_uri":_redirect_uri,
             @"refresh_token":_refreshToken,
             @"grant_type":@"refresh_token"
             };
}

@end

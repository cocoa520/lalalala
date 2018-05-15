//
//  OneDSearchAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/9.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "OneDSearchAPI.h"

@implementation OneDSearchAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:WebDriveSearchListPath, _driveID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _userLogintoken];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Client": @"Cloud Drive/1.0.0",
             @"accept": @"application/json"
             };
}

- (id)requestArgument {
    if (_searchPageIndex) {
        return @{
                 @"name": _searchName,
                 @"limit": _searchPageLimit,
                 @"next_page_token": _searchPageIndex
                 };
    }else {
        return @{
                 @"name": _searchName,
                 @"limit": _searchPageLimit
                 };
    }
}

@end

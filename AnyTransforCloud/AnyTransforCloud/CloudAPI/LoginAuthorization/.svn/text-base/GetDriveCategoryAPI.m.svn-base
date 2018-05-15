//
//  GetDriveCategoryAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/4/27.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GetDriveCategoryAPI.h"

@implementation GetDriveCategoryAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return WebDriveListCategoryIDEndPointURL;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _userLogintoken];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Client": @"Cloud Drive/1.0.0",
             @"accept": @"application/json"
             };
}

@end

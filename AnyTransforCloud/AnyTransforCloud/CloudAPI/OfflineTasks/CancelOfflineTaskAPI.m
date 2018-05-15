//
//  CancelOfflineTaskAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/4/28.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "CancelOfflineTaskAPI.h"

@implementation CancelOfflineTaskAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:OfflineTaskCancelRunningURL, _offlineTaskID];
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPATCH;
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

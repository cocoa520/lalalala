//
//  GetOfflineTaskWaitingListAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/4/28.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GetOfflineTaskWaitingListAPI.h"

@implementation GetOfflineTaskWaitingListAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return OfflineTaskWaitingURL;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
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

//
//  GetHistoryListsAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/4/24.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GetHistoryListsAPI.h"

@implementation GetHistoryListsAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:HistoryListPath, _pageLimit, _pageIndex];
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

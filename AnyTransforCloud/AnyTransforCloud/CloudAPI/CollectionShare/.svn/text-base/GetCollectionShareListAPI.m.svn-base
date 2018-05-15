//
//  GetCollectionShareListAPI.m
//  AnyTransforCloud
//
//  Created by JGehry on 2018/4/27.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "GetCollectionShareListAPI.h"

@implementation GetCollectionShareListAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:CollectionShareListPath, _pageLimit, _pageIndex];
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

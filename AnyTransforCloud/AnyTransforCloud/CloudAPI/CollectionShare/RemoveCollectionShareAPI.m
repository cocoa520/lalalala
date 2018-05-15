//
//  RemoveCollectionShareAPI.m
//  AnyTransforCloud
//
//  Created by JGehry on 2018/4/27.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "RemoveCollectionShareAPI.h"

@implementation RemoveCollectionShareAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:CollectionSharePath, _collectionShareID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
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

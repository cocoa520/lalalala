//
//  RemoveCollectionAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/4/24.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "RemoveCollectionAPI.h"

@implementation RemoveCollectionAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:CollectionPath, _collectionID];
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

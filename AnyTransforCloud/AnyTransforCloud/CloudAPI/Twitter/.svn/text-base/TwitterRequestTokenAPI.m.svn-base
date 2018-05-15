//
//  TwitterRequestTokenAPI.m
//  DriveSync
//
//  Created by JGehry on 21/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "TwitterRequestTokenAPI.h"

@implementation TwitterRequestTokenAPI

- (NSString *)baseUrl {
    return TwitterAPIBaseURL;
}

- (NSString *)requestUrl {
    return TwitterRequestTokenAPIURL;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": _oauthRequestToken
             };
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end

//
//  TwitterGetVideoAPI.m
//  DriveSync
//
//  Created by JGehry on 22/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "TwitterGetVideoAPI.h"

@implementation TwitterGetVideoAPI

- (NSString *)baseUrl {
    return TwitterAPIBaseURL;
}

- (NSString *)requestUrl {
    return TwitterUpdateProfile;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": _oauthAccessToken
             };
}

//- (YTKRequestMethod)requestMethod {
//    return YTKRequestMethodPOST;
//}

@end

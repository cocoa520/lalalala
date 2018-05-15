//
//  TwitterUserAccountAPI.m
//  DriveSync
//
//  Created by JGehry on 22/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "TwitterUserAccountAPI.h"

@implementation TwitterUserAccountAPI

- (NSString *)baseUrl {
    return TwitterAPIBaseURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:TwitterGetCurrentAccount, _accountName];
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": _oauthAccessToken
             };
}

@end

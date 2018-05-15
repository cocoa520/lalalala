//
//  GooglePhotoGetAlbumsPhotoListAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/4/8.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "GooglePhotoGetAlbumsPhotoListAPI.h"

@implementation GooglePhotoGetAlbumsPhotoListAPI

- (instancetype)initWithUserAccountID:(NSString *)userAccountID albumID:(NSString *)albumID accessToken:(NSString *)accessToken
{
    if (self = [super initWithUserAccountID:userAccountID accessToken:accessToken]) {
        _albumID = [albumID retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return GooglePhotoAPIBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = [NSString stringWithFormat:GooglePhotoGetAlbumsPhotoListPath,_userAccountID,_albumID];
    return url;
}

- (id)requestArgument
{
    return @{};
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accestoken];
    return @{@"Authorization":authorizationHeaderValue,@"GData-Version":@"3"};
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeXMLParser;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (void)dealloc
{
    [_albumID release],_albumID = nil;
    [super dealloc];
}
@end

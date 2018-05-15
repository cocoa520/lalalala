//
//  GooglePhotoGetAlbumsListAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/4/3.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "GooglePhotoGetAlbumsListAPI.h"

@implementation GooglePhotoGetAlbumsListAPI

- (NSString *)baseUrl
{
    return GooglePhotoAPIBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = [NSString stringWithFormat:GooglePhotoGetAlbumsListPath,_userAccountID];
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

@end

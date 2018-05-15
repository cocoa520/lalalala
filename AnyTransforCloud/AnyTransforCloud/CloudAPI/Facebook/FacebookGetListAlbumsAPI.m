//
//  FacebookGetListAlbumsAPI.m
//  DriveSync
//
//  Created by JGehry on 26/02/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "FacebookGetListAlbumsAPI.h"

@implementation FacebookGetListAlbumsAPI

- (NSString *)baseUrl
{
    return FacebookAPIBaseURL;
}

- (NSString *)requestUrl
{
    return FacebookGetListAlbumsPath;
}

- (id)requestArgument {
    return @{
             @"fields": @"name,created_time,photo_count,picture,photos{images,created_time,picture}",
             @"access_token": _accestoken
             };
}

@end

//
//  FacebookGetVideoAPI.m
//  DriveSync
//
//  Created by JGehry on 27/02/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "FacebookGetVideoAPI.h"

@implementation FacebookGetVideoAPI

- (NSString *)baseUrl
{
    return FacebookAPIBaseURL;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:FacebookGetVideoPath, _folderOrfileID];
}

- (id)requestArgument {
    return @{
             @"fields": @"source,picture,length,updated_time,description",
             @"access_token": _accestoken
             };
}

@end

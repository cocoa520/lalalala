//
//  FacebookGetTimelineAPI.m
//  DriveSync
//
//  Created by JGehry on 08/04/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "FacebookGetTimelineAPI.h"

@implementation FacebookGetTimelineAPI

- (NSString *)baseUrl {
    return FacebookAPIBaseURL;
}

- (NSString *)requestUrl {
    return FacebookGetTimeLinePath;
}

- (id)requestArgument {
    return @{
             @"fields": @"picture,message,source,object_id,type,updated_time,name",
             @"access_token": _accestoken
             };
}

@end

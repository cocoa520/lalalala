//
//  SendEmailShareAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/11.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "SendEmailShareAPI.h"

@implementation SendEmailShareAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    NSString *share = [_shareID st_urlEncodedString];
    return [NSString stringWithFormat:SendEmailSharePath, share];
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{
             @"accept": @"application/json"
             };
}

- (id)requestArgument {
    return @{
             @"email": @"jgehry82@gmail.com"
             };
}

@end

@implementation NSString (SendEmailShareAPI)

- (NSString *)st_urlEncodedString {
    return [self st_stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)st_stringByAddingRFC3986PercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    
    NSString *s = (__bridge NSString *)(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (CFStringRef)self,
                                                                                NULL,
                                                                                CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                kCFStringEncodingUTF8));
    return s;
}

@end

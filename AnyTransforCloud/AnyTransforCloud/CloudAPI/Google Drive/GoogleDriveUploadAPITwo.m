//
//  GoogleDriveUploadAPITwo.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/9.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "GoogleDriveUploadAPITwo.h"

@implementation GoogleDriveUploadAPITwo

- (id)initWithUploadURLStr:(NSString *)uploadURLStr
{
    if (self = [super init]) {
        _uploadURLStr = [uploadURLStr retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return _uploadURLStr;
}

- (NSString *)requestUrl
{
    
    return @"";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPUT;
}

- (void)dealloc
{
    [_uploadURLStr release],_uploadURLStr = nil;
    [super dealloc];
}
@end

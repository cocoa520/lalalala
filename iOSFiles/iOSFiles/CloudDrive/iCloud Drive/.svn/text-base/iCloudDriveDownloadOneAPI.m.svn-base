//
//  iCloudDriveDownloadAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/31.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveDownloadOneAPI.h"

@implementation iCloudDriveDownloadOneAPI

- (id)initWithDocumentID:(NSString *)documentID zone:(NSString *)zone iCloudDriveDocwsURL:(NSString *)url
{
    if (self = [super init]) {
        _documentID = [documentID retain];
        _zone = [zone retain];
        _iCloudDriveDocwsUrl = [url retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return _iCloudDriveDocwsUrl;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:@"ws/%@/download/by_id?document_id=%@",_zone,_documentID] ;
    return url;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"Content-Type":@"text/plain",@"Origin":@"https://www.icloud.com"}];
    [dic addEntriesFromDictionary:_cookie];
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (void)dealloc
{
    [_iCloudDriveDocwsUrl release],_iCloudDriveDocwsUrl = nil;
    [_documentID release],_documentID = nil;
    [_zone release],_zone = nil;
    [super dealloc];
}

@end

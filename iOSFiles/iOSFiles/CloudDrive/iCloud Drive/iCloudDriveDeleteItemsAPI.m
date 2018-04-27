//
//  iCloudDriveDeleteItems.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/31.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveDeleteItemsAPI.h"

@implementation iCloudDriveDeleteItemsAPI

- (id)initWithDeleteItems:(NSArray *)deleteItems dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url
{
    if (self = [super init]) {
        _deleteItmes = [deleteItems retain];
        _dsid = [dsid retain];
        _cookie = [cookie retain];
        _iCloudDriveUrl = [url retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return _iCloudDriveUrl;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:@"deleteItems?dsid=%@",_dsid] ;
    return url;
}

- (id)requestArgument
{
    return @{@"items":_deleteItmes};
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
    return YTKRequestMethodPOST;
}

- (void)dealloc
{
    [_deleteItmes release],_deleteItmes = nil;
    [super dealloc];
}
@end

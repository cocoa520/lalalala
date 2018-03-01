//
//  iCloudDriveRenameAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/31.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveRenameAPI.h"

@implementation iCloudDriveRenameAPI

- (id)initWithRenameItems:(NSDictionary *)item dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url
{
    if (self = [super init]) {
        _itemDic = [item retain];
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
    url = [NSString stringWithFormat:@"renameItems?dsid=%@",_dsid] ;
    return url;
}

- (id)requestArgument
{
    return @{@"items":@[_itemDic]};
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
    [_itemDic release],_itemDic = nil;
    [super dealloc];
}
@end

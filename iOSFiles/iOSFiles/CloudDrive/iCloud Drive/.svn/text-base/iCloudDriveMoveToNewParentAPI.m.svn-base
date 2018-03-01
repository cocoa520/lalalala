//
//  iCloudDriveMoveToNewParentAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/31.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveMoveToNewParentAPI.h"

@implementation iCloudDriveMoveToNewParentAPI

- (id)initWithMoveItemDic:(NSDictionary *)dic newParentIDOrPathdsid:(NSString *)parent dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url
{
    if (self = [super init]) {
        _itemDic = [dic retain];
        _newParentIDOrPath = [parent retain];
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
    url = [NSString stringWithFormat:@"moveItems?dsid=%@",_dsid] ;
    return url;
}

- (id)requestArgument
{
    if ([_newParentIDOrPath isEqualToString:@"0"]) {
        return @{@"destinationDrivewsId":@"FOLDER::com.apple.CloudDocs::root",@"items":@[_itemDic]};
    }else {
        return @{@"destinationDrivewsId":_newParentIDOrPath,@"items":@[_itemDic]};
    }
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

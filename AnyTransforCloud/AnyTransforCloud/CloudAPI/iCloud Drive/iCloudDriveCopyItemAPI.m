//
//  iCloudDriveCopyItemAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/4.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "iCloudDriveCopyItemAPI.h"

@implementation iCloudDriveCopyItemAPI

- (id)initWithCopyItemDic:(NSArray *)dic newParentIDOrPathdsid:(NSString *)parent dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url
{
    if (self = [super init]) {
        _itemDics = [dic retain];
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
    url = [NSString stringWithFormat:@"copyItems?dsid=%@",_dsid] ;
    return url;
}

- (id)requestArgument
{
    if ([_newParentIDOrPath isEqualToString:@"0"]) {
        return @{@"destinationDrivewsId":@"FOLDER::com.apple.CloudDocs::root",@"items":_itemDics};
    }else {
        return @{@"destinationDrivewsId":_newParentIDOrPath,@"items":_itemDics};
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
    [_itemDics release],_itemDics = nil;
    [super dealloc];
}

@end

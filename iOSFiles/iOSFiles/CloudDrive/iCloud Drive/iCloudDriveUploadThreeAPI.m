//
//  iCloudDriveUploadThreeAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/2/2.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveUploadThreeAPI.h"

@implementation iCloudDriveUploadThreeAPI
- (id)initWithiCloudDriveDocwsUrl:(NSString *)url dataDic:(NSMutableDictionary *)dataDic fileName:(NSString *)fileName parent:(NSString *)parent  documentID:(NSString *)documentID cookie:(NSMutableDictionary *)cookie
{
    if (self = [super init]) {
        _iCloudDriveDocwsUrl = [url retain];
        _dataDic = [dataDic retain];
        _fileName = [fileName retain];
        _parent = [parent retain];
        _documentID = [documentID retain];
        _cookie = [cookie retain];
        
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
    url = iCloudDriveUploadThreePath;
    return url;
}

- (id)requestArgument
{
    if ([_parent isEqualToString:@"0"]) {
        return @{@"data":_dataDic,@"command":@"add_file",@"document_id":_documentID,@"path":@{@"starting_document_id":@"root",@"path":_fileName},@"allow_conflict":@(true),@"file_flags":@{
                         @"is_writable": @(true),
                         @"is_executable": @(false),
                         @"is_hidden": @(false)
                         }};
    }else{
        return @{@"data":_dataDic,@"command":@"add_file",@"document_id":_documentID,@"path":@{@"starting_document_id":_parent,@"path":_fileName},@"allow_conflict":@(true),@"file_flags":@{
                         @"is_writable": @(true),
                         @"is_executable": @(false),
                         @"is_hidden": @(false)
                         }};
    }
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"Origin":@"https://www.icloud.com"}];
    [dic addEntriesFromDictionary:_cookie];
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (void)dealloc
{
    [_iCloudDriveDocwsUrl release],_iCloudDriveDocwsUrl = nil;
    [super dealloc];
}

@end

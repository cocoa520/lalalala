//
//  OneDriveAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/5.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"
@implementation BaseDriveAPI
@synthesize isFolder = _isFolder;

#pragma mark -- 初始化方法
- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password
{
    if (self = [super init]) {
        _userEmail = [email retain];
        _userPassword = [password retain];
        return self;
    }else {
        return nil;
    }
}

- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken
{
    if (self = [super init]) {
        _userLogintoken = [userLogintoken retain];
        return self;
    }else {
        return nil;
    }
}

- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken withDriveID:(NSString *)driveID
{
    if (self = [super init]) {
        _userLogintoken = [userLogintoken retain];
        _driveID = [driveID retain];
        return self;
    }else {
        return nil;
    }
}

- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken withDriveName:(NSString *)driveName {
    if (self = [super init]) {
        _userLogintoken = [userLogintoken retain];
        _driveName = [driveName retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initWithUserAccountID:(NSString *)userAccountID  accessToken:(NSString *)accessToken
{
    if (self = [super init]) {
        _userAccountID = [userAccountID retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithItemID:(NSString *)folderID accessToken:(NSString *)accessToken
{
    if (self = [super init]) {
        _folderOrfileID = [folderID retain];
        _accestoken = [accessToken retain];
    }
    return self;
}

- (id)initWithItemsID:(NSArray *)filesOrFoldersAry accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _multipleFilesOrFolder = [filesOrFoldersAry retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithItemsAsyncJobID:(NSString *)asyncJobID accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _multipleFilesOrFolderAsyncJobID = [asyncJobID retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithItemID:(NSString *)folderID cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url
{
    if (self = [super init]) {
        _folderOrfileID = [folderID retain];
        _cookie = [cookie retain];
        _iCloudDriveUrl = [url retain];
    }
    return self;
}

- (id)initWithDsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie {
    if (self = [super init]) {
        _dsid = [dsid retain];
        _cookie = [cookie retain];
        return self;
    }else {
        return nil;
    }
}

- (id)initWithItemID:(NSString *)folderID accessToken:(NSString *)accessToken withIsFolder:(BOOL)isFolder
{
    if (self = [super init]) {
        _folderOrfileID = [folderID retain];
        _accestoken = [accessToken retain];
        _isFolder = isFolder;
    }
    return self;
}

- (id)initWithNewName:(NSString *)newName idOrPath:(NSString *)idOrPath accessToken:(NSString *)accessToken
{
    if (self = [super init]) {
        _folderOrfileID = [idOrPath retain];
        _newName = [newName retain];
        _accestoken = [accessToken retain];
    }
    return self;
}

- (id)initWithItemID:(NSString *)folderOrfileID newParentIDOrPath:(NSString *)newParentIDOrPath  parent:(NSString *)parent accessToken:(NSString *)accessToken
{
    if (self = [super init]) {
        _folderOrfileID = [folderOrfileID retain];
        _newParentIDOrPath = [newParentIDOrPath retain];
        _parent = parent;
        _accestoken = [accessToken retain];
    }
    return self;
}

- (id)initWithItemsID:(NSArray *)folderOrfileIDAry newParentIDOrPath:(NSMutableArray *)newParentIDOrPathAry  parent:(NSString *)parent accessToken:(NSString *)accessToken
{
    if (self = [super init]) {
        _multipleFilesOrFolder = [folderOrfileIDAry retain];
        _multipleNewFilesOrFolder = [newParentIDOrPathAry retain];
        _parent = parent;
        _accestoken = [accessToken retain];
    }
    return self;
}

- (id)initWithItemID:(NSString *)folderOrfileID newParentIDOrPath:(NSString *)newParentIDOrPath name:(NSString *)name accessToken:(NSString *)accessToken
{
    if (self = [super init]) {
        _folderOrfileID = [folderOrfileID retain];
        _newParentIDOrPath = [newParentIDOrPath retain];
        _newName = [name retain];
        _accestoken = [accessToken retain];
    }
    return self;
}

- (id)initWithFolderName:(NSString *)folderName Parent:(NSString *)parent accessToken:(NSString *)accessToken
{
    if (self = [super init]) {
        _folderName = [folderName retain];
        _parent = [parent retain];
        _accestoken = [accessToken retain];
    }
    return self;
}

- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _fileName = [fileName retain];
        _parent = [parent retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent fileSize:(long long)fileSize fileStart:(long long)start fileEnd:(long long)end accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _fileName = [fileName retain];
        _parent = [parent retain];
        _uploadRangeStart = start;
        _uploadRangeEnd = end;
        _uploadFileSize = fileSize;
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent uploadFile:(NSString *)filePath offset:(uint64_t)offset sessionID:(NSString *)sessionID accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _fileName = [fileName retain];
        _parent = [parent retain];
        _uploadUrl = filePath;
        _uploadFileSize = offset;
        _uploadSessionID = [sessionID retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent offset:(uint64_t)offset sessionID:(NSString *)sessionID accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _fileName = [fileName retain];
        _parent = [parent retain];
        _uploadFileSize = offset;
        _uploadSessionID = [sessionID retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithFileName:(NSString *)fileName fileSize:(long long)fileSize Parent:(NSString *)parent accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _fileName = [fileName retain];
        _uploadFileSize = fileSize;
        _parent = [parent retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithFileSize:(long long)fileSize fileStart:(long long)start fileEnd:(long long)end accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _uploadRangeStart = start;
        _uploadRangeEnd = end;
        _uploadFileSize = fileSize;
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithUploadUrl:(NSString *)uploadUrl fileSize:(long long)fileSize fileStart:(long long)start fileEnd:(long long)end accessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _uploadUrl = [uploadUrl retain];
        _uploadRangeStart = start;
        _uploadRangeEnd = end;
        _uploadFileSize = fileSize;
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithClientID:(NSString *)clientID redirectUri:(NSString *)redirectUri clientSecret:(NSString *)clientSecret refreshToken:(NSString *)refreshToken
{
    if (self == [super init]) {
        _clientID = [clientID retain];
        _redirect_uri = [redirectUri retain];
        _clientSecret = [clientSecret retain];
        _refreshToken = [refreshToken retain];
    }
    return self;
}

+ (NSString *) utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
//        unichar _char = [string characterAtIndex:i];
//        //判断是否为英文和数字
//        if (_char <= '9' && _char >= '0')
//        {
//            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
//        }
//        else if(_char >= 'a' && _char <= 'z')
//        {
//            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
//        }
//        else if(_char >= 'A' && _char <= 'Z')
//        {
//            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
//        }
//        else
//        {
//            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
//        }
        
        if ([BaseDriveAPI isChinese:subStr]){
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }else {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return s;
}

+ (BOOL)isChinese:(NSString *)userName
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    NSString *match1 = @"^[\u0800-\u4e00]";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF matches %@", match1];
    return [predicate evaluateWithObject:userName] || [predicate1 evaluateWithObject:userName];
}

#pragma mark - 请求参数的一些通用配置 如果比较特殊 需要子类重写

/**
 *  请求资源的访问终结点
 *
 *  @return 返回终结点url字符串
 */
- (NSString *)baseUrl{
    return nil;
}

/**
 *  请求资源的相对路径
 *
 *  @return 返回相对路径的字符窜
 */
- (NSString *)requestUrl
{
    return nil;
}

/**
 *  请求所附带的参数
 *
 *  @return 返回参数值 为id类型
 */
- (id)requestArgument
{
    return nil;
}

/**
 *  请求超时设置
 *
 *  @return 返回超时的时间秒数
 */
- (NSTimeInterval)requestTimeoutInterval
{
    return [super requestTimeoutInterval];
}

/**
 *  请求参数序列化类型
 *
 *  @return 返回对应类型 YTKRequestSerializerTypeJSON json类型 YTKRequestSerializerTypeHTTP二进制类型
 */
- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeJSON;
}

/**
 *  返回参数类型
 *
 *  @return 返回对应类型 YTKResponseSerializerTypeJSON json类型 YTKResponseSerializerTypeHTTP二进制类型 YTKResponseSerializerTypeXMLParser xml
 */
- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}


/**
 *  请求头部参数配置
 *
 *  @return 返回头部参数字典
 */
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accestoken];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:authorizationHeaderValue forKey:@"Authorization"];
    return dic;
}

- (void)start
{
    [super start];
}


- (BOOL)statusCodeValidator {
    return YES;
}

+ (NSString *)createGUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

- (void)dealloc
{
    [_userEmail release],_userEmail = nil;
    [_userPassword release],_userPassword = nil;
    [_driveID release],_driveID = nil;
    [_userLogintoken release],_userLogintoken = nil;
    [_accestoken release],_accestoken = nil;
    [_folderOrfileID release],_folderOrfileID = nil;
    [_parent release],_parent = nil;
    [_folderName release],_folderName = nil;
    [_newName release],_newName = nil;
    [_newParentIDOrPath release],_newParentIDOrPath = nil;
    [_clientSecret release],_clientSecret = nil;
    [_redirect_uri release],_redirect_uri = nil;
    [_clientID release],_clientID = nil;
    [_refreshToken release],_refreshToken = nil;
    [_iCloudDriveUrl release],_iCloudDriveUrl = nil;
    [_cookie release],_cookie = nil;
    [_dsid release],_dsid = nil;
    [super dealloc];
}
@end

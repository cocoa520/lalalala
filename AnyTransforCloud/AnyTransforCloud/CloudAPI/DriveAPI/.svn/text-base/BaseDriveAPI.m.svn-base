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

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -- 初始化方法
- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmPassword
{
    if (self = [self init]) {
        _userEmail = [email retain];
        _userPassword = [password retain];
        _userConfirmPassword = [confirmPassword retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

#pragma mark -- 初始化方法
- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password
{
    if (self = [self init]) {
        _userEmail = [email retain];
        _userPassword = [password retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password withGoogle2FCode:(NSString *)g2fCode {
    if (self = [self init]) {
        _userEmail = [email retain];
        _userPassword = [password retain];
        _userG2FCode = [g2fCode retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initWithUserLoginCode:(NSString *)userLoginCode {
    if (self = [self init]) {
        _userLoginCode = [userLoginCode retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken
{
    if (self = [self init]) {
        _userLogintoken = [userLogintoken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken withDriveID:(NSString *)driveID
{
    if (self = [self init]) {
        _userLogintoken = [userLogintoken retain];
        _driveID = [driveID retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken withDriveName:(NSString *)driveName {
    if (self = [self init]) {
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

- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken
                           withDriveID:(NSString *)driveID
                        withSearchName:(NSString *)searchName
                       withSearchLimit:(NSString *)limit
                   withSearchPageIndex:(NSString *)pageIndex {
    if (self = [self init]) {
        _userLogintoken = [userLogintoken retain];
        _driveID = [driveID retain];
        _searchName = [searchName retain];
        _searchPageLimit = [limit retain];
        _searchPageIndex = [pageIndex retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken withDriveID:(NSString *)driveID withDriveNewName:(NSString *)driveNewName {
    if (self = [self init]) {
        _userLogintoken = [userLogintoken retain];
        _driveID = [driveID retain];
        _driveNewName = [driveNewName retain];
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
    if (self = [self init]) {
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
    if (self = [self init]) {
        _folderOrfileID = [folderID retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithDriveID:(NSString *)driveID
   withFileOrFolderID:(NSString *)fileOrFolderID
         withIsFolder:(BOOL)isFolder
          withAlbumID:(NSString *)albumID
       userLoginToken:(NSString *)userLoginToken {
    if (self = [self init]) {
        _driveID = [driveID retain];
        _folderOrfileID = [fileOrFolderID retain];
        _isFolder = isFolder;
        if (albumID) {
            _albumID = [albumID retain];
        }
        _userLogintoken = [userLoginToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithDriveID:(NSString *)driveID
   withFileOrFolderID:(NSString *)fileOrFolderID
         withIsFolder:(BOOL)isFolder
      withMaxDownload:(int)maxDownload
    withShareExpireAt:(NSString *)shareExpireAt
    withSharePassword:(NSString *)sharePassword
          withAlbumID:(NSString *)albumID
       userLoginToken:(NSString *)userLoginToken {
    if (self = [self init]) {
        _driveID = [driveID retain];
        _folderOrfileID = [fileOrFolderID retain];
        _isFolder = isFolder;
        _maxDownload = maxDownload;
        _shareExpireAt = [shareExpireAt retain];
        _sharePassword = [sharePassword retain];
        if (albumID) {
            _albumID = [albumID retain];
        }
        _userLogintoken = [userLoginToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithItemLimit:(int)limit withPageIndex:(int)pageIndex userLoginToken:(NSString *)userLoginToken {
    if (self = [self init]) {
        _pageLimit = limit;
        _pageIndex = pageIndex;
        _userLogintoken = [userLoginToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithCollectionID:(NSString *)collectionID userLoginToken:(NSString *)userLoginToken {
    if (self = [self init]) {
        _collectionID = [collectionID retain];
        _userLogintoken = [userLoginToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithShareID:(NSString *)shareID userLoginToken:(NSString *)userLoginToken {
    if (self = [self init]) {
        _shareID = [shareID retain];
        _userLogintoken = [userLoginToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithCollectionShareID:(NSString *)collectionShareID userLoginToken:(NSString *)userLoginToken {
    if (self = [self init]) {
        _collectionShareID = [collectionShareID retain];
        _userLogintoken = [userLoginToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithOfflineTaskID:(NSString *)offlineTaskID userLoginToken:(NSString *)userLoginToken {
    if (self = [self init]) {
        _offlineTaskID = [offlineTaskID retain];
        _userLogintoken = [userLoginToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithOfflineTaskName:(NSString *)offlineTaskName
            withSourceDriveID:(NSString *)sourceDriveID
            withTargetDriveID:(NSString *)targetDriveID
     withSourceFolderOrFileID:(NSArray *)sourceFolderOrFileIDArray
     withTargetFolderOrFileID:(NSString *)targetFolderOrFileID
                     withType:(NSString *)type
                     withMode:(NSString *)mode
                    withScope:(NSString *)scope
                 withConflict:(NSString *)conflict
                withFrequency:(NSString *)frequency
              withExecuteTime:(NSString *)executeTime
               userLoginToken:(NSString *)userLoginToken {
    if (self = [self init]) {
        _offlineName = [offlineTaskName retain];
        _driveID = [sourceDriveID retain];
        _targetDriveID = [targetDriveID retain];
        _sourceFolderOrFileID = [sourceFolderOrFileIDArray retain];
        _targetFolderOrFileID = [targetFolderOrFileID retain];
        _offlineType = [type retain];
        _offlineMode = [mode retain];
        _offlineScope = [scope retain];
        _offlineConflict = [conflict retain];
        _offlineFrequency = [frequency retain];
        _offlineExecuteTime = [executeTime retain];
        _userLogintoken = [userLoginToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
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
    if (self = [self init]) {
        _folderOrfileID = [folderID retain];
        _cookie = [cookie retain];
        _iCloudDriveUrl = [url retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithItemID:(NSString *)folderID accessToken:(NSString *)accessToken withIsFolder:(BOOL)isFolder
{
    if (self = [self init]) {
        _folderOrfileID = [folderID retain];
        _accestoken = [accessToken retain];
        _isFolder = isFolder;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithNewName:(NSString *)newName idOrPath:(NSString *)idOrPath accessToken:(NSString *)accessToken
{
    if (self = [self init]) {
        _folderOrfileID = [idOrPath retain];
        _newName = [newName retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithItemID:(NSString *)folderOrfileID newParentIDOrPath:(NSString *)newParentIDOrPath  parent:(NSString *)parent accessToken:(NSString *)accessToken
{
    if (self = [self init]) {
        _folderOrfileID = [folderOrfileID retain];
        _newParentIDOrPath = [newParentIDOrPath retain];
        _parent = parent;
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithItemID:(NSString *)folderOrfileID newParentIDOrPath:(NSString *)newParentIDOrPath newParentDriveID:(NSString *)newParentDriveID accessToken:(NSString *)accessToken
{
    if (self = [self init]) {
        _folderOrfileID = [folderOrfileID retain];
        _newParentIDOrPath = [newParentIDOrPath retain];
        _newParentDriveIDOrPath = [newParentDriveID retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
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
    if (self = [self init]) {
        _folderOrfileID = [folderOrfileID retain];
        _newParentIDOrPath = [newParentIDOrPath retain];
        _newName = [name retain];
        _accestoken = [accessToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (id)initWithFolderName:(NSString *)folderName Parent:(NSString *)parent accessToken:(NSString *)accessToken
{
    if (self = [self init]) {
        _folderName = [folderName retain];
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

- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent accessToken:(NSString *)accessToken {
    if (self = [self init]) {
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
    if (self = [self init]) {
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
    if (self = [self init]) {
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
    if (self = [self init]) {
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
    if (self = [self init]) {
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
    if (self = [self init]) {
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
    if (self = [self init]) {
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
    if (self == [self init]) {
        _clientID = [clientID retain];
        _redirect_uri = [redirectUri retain];
        _clientSecret = [clientSecret retain];
        _refreshToken = [refreshToken retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

+ (NSString *)zhAndJpToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([BaseDriveAPI iscontainCharSet:subStr]){
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }else {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return s;
}

+ (BOOL)iscontainCharSet:(NSString *)userName
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

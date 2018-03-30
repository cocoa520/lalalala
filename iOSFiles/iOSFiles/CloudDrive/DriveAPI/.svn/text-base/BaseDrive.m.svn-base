//
//  BaseDrive.m
//  DriveSync
//
//  Created by 罗磊 on 2017/11/30.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "BaseDrive.h"

@implementation DownLoadAndUploadItem
@synthesize progress = _progress;
@synthesize state = _state;
@synthesize speed = _speed;
@synthesize error = _error;
@synthesize urlString = _urlString;
@synthesize headerParam = _headerParam;
@synthesize fileName = _fileName;
@synthesize httpMethod = _httpMethod;
@synthesize parentPath = _parentPath;
@synthesize itemIDOrPath = _itemIDOrPath;
@synthesize fileSize = _fileSize;
@synthesize currentSize = _currentSize;
@synthesize currentTotalSize = _currentTotalSize;
@synthesize parent = _parent;
@synthesize isFolder = _isFolder;
@synthesize isBigFile = _isBigFile;
@synthesize isConstructingData = _isConstructingData;
@synthesize localPath = _localPath;
@synthesize requestAPI = _requestAPI;
@synthesize uploadParent = _uploadParent;
@synthesize childArray = _childArray;
@synthesize toDriveName = _toDriveName;
@synthesize docwsID = _docwsID;
@synthesize zone = _zone;
@synthesize dataAry = _dataAry;
@synthesize isStart = _isStart;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _speed = 0;
        _progress = 0.0;
        _fileSize = 0;
        _currentSize = 0;
        _currentTotalSize = 0;
    }
    return self;
}

- (NSComparisonResult)compare:(id <DownloadAndUploadDelegate>)item
{
    // 先按照姓排序
    if (self.parentPath.length < item.parentPath.length) {
        return NSOrderedAscending;
    }else if (self.parentPath.length == item.parentPath.length){
        return NSOrderedSame;
    }else{
        return  NSOrderedDescending;
    }
}

- (NSString *)identifier
{
    NSString *identifier = [_urlString stringByAppendingString:_itemIDOrPath];
    return identifier;
}

- (void)dealloc
{
    [_urlString release],_urlString = nil;
    [_headerParam  release],_headerParam = nil;
    [_fileName release],_fileName = nil;
    [_httpMethod release],_httpMethod = nil;
    [_parentPath release],_parentPath = nil;
    [_itemIDOrPath release],_itemIDOrPath = nil;
    [_error release],_error = nil;
    [_localPath release],_localPath = nil;
    [_requestAPI release],_requestAPI = nil;
    [_uploadParent release],_uploadParent = nil;
    [_childArray release],_childArray = nil;
    [super dealloc];
}

@end



@implementation BaseDrive
@synthesize userID = _userID;
@synthesize driveID = _driveID;
@synthesize userLoginToken = _userLoginToken;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;
@synthesize delegate = _delegate;
@synthesize driveArray = _driveArray;
@synthesize refreshToken = _refreshToken;
@synthesize downLoader = _downLoader;

- (instancetype)init
{
    if (self = [super init]) {
        _driveArray = [[NSMutableArray alloc] init];
        _folderItemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithFromLocalOAuth:(BOOL)isFromLocalOAuth
{
    if (self = [self init]) {
        _isFromLocalOAuth = isFromLocalOAuth;
    }
    return self;
}


- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event
           withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSString *URLString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *URL = [NSURL URLWithString:URLString];
    [_currentAuthorizationFlow resumeAuthorizationFlowWithURL:URL];
}

- (void)dealloc
{
    [_userID release],_userID = nil;
    [_driveID release],_driveID = nil;
    [_userLoginToken release],_userLoginToken = nil;
    [_accessToken release],_accessToken = nil;
    [_expirationDate release],_expirationDate = nil;
    [_currentAuthorizationFlow release],_currentAuthorizationFlow = nil;
    [_downLoader release],_downLoader = nil;
    [_upLoader release],_upLoader = nil;
    [_refreshToken release],_refreshToken = nil;
    [_folderItemArray release],_folderItemArray = nil;
    [self setDriveArray:nil];
    [super dealloc];
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

#pragma mark - setter
- (void)setDriveID:(NSString *)driveID {
    if (_driveID != driveID) {
        [_driveID release];
        _driveID = [driveID retain];
    }
}

- (void)setUserLoginToken:(NSString *)userLoginToken {
    if (_userLoginToken != userLoginToken) {
        [_userLoginToken release];
        _userLoginToken = [userLoginToken retain];
    }
}

- (void)setAccessToken:(NSString *)accessToken
{
    if (_accessToken != accessToken) {
        [_accessToken release];
        _accessToken = [accessToken retain];
        _downLoader = [[DownLoader alloc] initWithAccessToken:accessToken];
        _upLoader = [[UpLoader alloc] initWithAccessToken:accessToken];
    }
}

#pragma mark -- driveLogout
- (void)userDidLogout {
    self.userLoginToken = nil;
    self.driveID = nil;
}

- (BOOL)isUserLogin {
    if (_userLoginToken) {
        return YES;
    }else {
        return NO;
    }
}

#pragma makr - logIn / loginOut
- (void)logIn
{
    if ([self isAuthValid]) {
        if ([_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
            [_delegate driveDidLogIn:self];
        }
    }else{
        //子类需要去实现自己的认证逻辑
        [self logIn];
    }
}

- (void)logOut
{
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
}

#pragma makr - Validation

- (BOOL)isLoggedIn
{
    if (_accessToken) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:_expirationDate] == NSOrderedDescending);
}

- (BOOL)isAuthValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

#pragma mark - downloadActions

- (void)downloadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items
{
    for (id <DownloadAndUploadDelegate> item in items) {
        if (!item.isStart) {
            item.isStart = YES;
            [self downloadItem:item];
        }
    }
}

- (void)pauseDownloadItem:(_Nonnull id <DownloadAndUploadDelegate>)item
{
    if (item.isFolder) {
        //设置为暂停
        item.state = DownloadStatePaused;
        for (id <DownloadAndUploadDelegate> subitem in item.childArray) {
            [self pauseDownloadItem:subitem];
        }
    }else {
        [_downLoader pauseDownloadItem:item];

    }
}

- (void)pauseAllDownloadItems
{
    [_downLoader pauseAllDownloadItems];
}

- (void)resumeDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    if (item.isFolder) {
        //设置为等待状态
        item.state = DownloadStateWait;
        for (id <DownloadAndUploadDelegate> subitem in item.childArray) {
            [self resumeDownloadItem:subitem];
        }
    }else{
        [_downLoader resumeDownloadItem:item];
    }
}

- (void)resumeAllDownloadItems
{
    [_downLoader resumeAllDownloadItems];
}

- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    if (item.isFolder) {
        //设置为normal
        item.state = TransferStateNormal;
        for (id<DownloadAndUploadDelegate>subitem in item.childArray) {
            [_downLoader cancelDownloadItem:subitem];
        }
    }else {
        [_downLoader cancelDownloadItem:item];
    }
}

- (void)cancelAllDownloadItems
{
    [_downLoader cancelAllDownloadItems];
}

- (void)uploadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items {
    for (id <DownloadAndUploadDelegate> item in items) {
        [self uploadItem:item];
    }
}

- (void)pauseUploadItem:(_Nonnull id <DownloadAndUploadDelegate>)item {
    [_upLoader pauseUploadItem:item];
}

- (void)pauseAllUploadItems {
    [_upLoader pauseAllDownloadItems];
}

- (void)resumeUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_upLoader resumeUploadItem:item];
}

- (void)resumeAllUploadItems {
    [_upLoader resumeAllUploadItems];
}

- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    if (item.isFolder) {
        for (id<DownloadAndUploadDelegate>item in item.childArray) {
            [_upLoader cancelUploadItem:item];
        }
    }else {
        [_upLoader cancelUploadItem:item];
    }
}

- (void)cancelAllUploadItems {
    [_upLoader cancelAllUploadItems];
}

#pragma mark DriveToDrive

- (void)toDrive:(BaseDrive *)targetDrive item:(id <DownloadAndUploadDelegate>)item
{
    //先下载到本地,然后再上传
}

- (void)cancelDriveToDriveItem:(id<DownloadAndUploadDelegate>)item
{
    
}
#pragma mark -- 检查请求响应的数据类型
- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest * _Nonnull)response {
    if ([response responseData]) {
        if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSDictionary class]]) {
            if ([[[response responseJSONObject] allKeys] containsObject:@"error"]) {
                NSDictionary *errorDict = [[response responseJSONObject] objectForKey:@"error"];
                NSString *errorStr = [errorDict objectForKey:@"code"];
                NSString *errorMessage = nil;
                if (errorStr) {
                    errorMessage = [errorDict objectForKey:@"message"];
                }else {
                    if ([[errorDict allKeys] containsObject:@"path"]) {
                        NSDictionary *dict = [errorDict objectForKey:@"path"];
                        if ([[dict allKeys] containsObject:@".tag"]) {
                            errorMessage = [dict objectForKey:@".tag"];
                        }
                    }
                }
                if ([errorStr isEqualToString:@"InvalidAuthenticationToken"]) {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                    return ResponseTokenInvalid;
                }else if ([errorStr isEqualToString:@"The request timed out."]) {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                    return ResponseTimeOut;
                }else if ([errorStr isEqualToString:@"invalidRequest"]) {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                    return ResponseInvalid;
                }else {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                    return ResponseUnknown;
                }
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"errors"]) {
                NSString *errorMessage = [[response responseJSONObject] objectForKey:@"message"];
                [response setUserInfo:@{@"errorMessage": errorMessage}];
                return ResponseInvalid;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"expires_in"]) {
                NSString *successStr = [[response responseJSONObject] objectForKey:@"token"];
                self.accessToken = successStr;
                [response setUserInfo:@{@"AuthValidRefreshToken": @"Valid refresh token authorization succeeded"}];
                return ResponseSuccess;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"token"]) {
                NSString *successStr = [[response responseJSONObject] objectForKey:@"token"];
                self.userLoginToken = successStr;
                [response setUserInfo:@{@"AuthValidToken": @"Valid token authorization succeeded"}];
                return ResponseSuccess;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"context_info"]) {
                if ([[[response responseJSONObject] allKeys] containsObject:@"message"]) {
                    NSString *errorMessage = [[response responseJSONObject] objectForKey:@"message"];
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                }
                return ResponseInvalid;
            }else {
                return ResponseSuccess;
            }
        }else if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSArray class]]) {
            return ResponseSuccess;
        }else if ([response responseString] && [[response responseString] isKindOfClass:[NSString class]]) {
            NSString *errorStr = [response responseString];
            if ([errorStr rangeOfString:@"access token"].location != NSNotFound) {
                [response setUserInfo:@{@"errorMessage": @"The given OAuth 2 access token is malformed"}];
                return ResponseTokenInvalid;
            }else if ([errorStr isEqualToString:@""]) {
                return ResponseSuccess;
            }else {
                [response setUserInfo:@{@"errorMessage": errorStr}];
                return ResponseUnknown;
            }
        }else {
            return ResponseNotConnectedToInternet;
        }
    }else if ([[response error] localizedDescription]) {
        NSString *errorDescription = [[response error] localizedDescription];
        if ([errorDescription isEqualToString:@"InvalidAuthenticationToken"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTokenInvalid;
        }else if ([errorDescription isEqualToString:@"The request timed out."]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTimeOut;
        }else if ([errorDescription isEqualToString:@"invalidRequest"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseInvalid;
        }else {
            return ResponseSuccess;
        }
    }else {
        return ResponseNotConnectedToInternet;
    }
}

- (ResponseCode)checkResponseTypeWithFailed:(YTKBaseRequest * _Nonnull)response {
    if ([response responseData]) {
        if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSDictionary class]]) {
            if ([[[response responseJSONObject] allKeys] containsObject:@"error"]) {
                NSDictionary *errorDict = [[response responseJSONObject] objectForKey:@"error"];
                NSString *errorStr = [errorDict objectForKey:@"code"];
                NSString *errorMessage = [errorDict objectForKey:@"message"];
                if ([errorStr isEqualToString:@"InvalidAuthenticationToken"]) {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                    return ResponseTokenInvalid;
                }else if ([errorStr isEqualToString:@"The request timed out."]) {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                    return ResponseTimeOut;
                }else if ([errorStr isEqualToString:@"invalidRequest"]) {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                    return ResponseInvalid;
                }else {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                    return ResponseUnknown;
                }
            }else {
                return ResponseNotConnectedToInternet;
            }
        }else if ([response responseString] && [[response responseString] isKindOfClass:[NSString class]]) {
            NSString *errorStr = [response responseString];
            if ([errorStr rangeOfString:@"access token"].location != NSNotFound) {
                [response setUserInfo:@{@"errorMessage": @"The given OAuth 2 access token is malformed"}];
                return ResponseTokenInvalid;
            }else {
                [response setUserInfo:@{@"errorMessage": errorStr}];
                return ResponseUnknown;
            }
        }else {
            return ResponseNotConnectedToInternet;
        }
    }else if ([[response error] localizedDescription]) {
        NSString *errorDescription = [[response error] localizedDescription];
        if ([errorDescription isEqualToString:@"InvalidAuthenticationToken"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTokenInvalid;
        }else if ([errorDescription isEqualToString:@"The request timed out."]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTimeOut;
        }else if ([errorDescription isEqualToString:@"invalidRequest"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseInvalid;
        }else {
            return ResponseNotConnectedToInternet;
        }
    }else {
        return ResponseNotConnectedToInternet;
    }
}

- (NSDictionary *)getList:(NSString *)folerID
{
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    __block BaseDrive *weakSelf = self;
    __block BOOL iswait = YES;
    __block NSThread *currentthread = [NSThread currentThread];
    [self getList:folerID  success:^(DriveAPIResponse *response) {
        [dic setDictionary:response.content];
        iswait = NO;
        [weakSelf performSelector:@selector(createFolderWait) onThread:currentthread withObject:nil waitUntilDone:NO];
    } fail:^(DriveAPIResponse *response) {
        NSDictionary *edic = [NSDictionary dictionaryWithObject:response.content forKey:@"error"];
        [dic setDictionary:edic];
        iswait = NO;
        [weakSelf performSelector:@selector(createFolderWait) onThread:currentthread withObject:nil waitUntilDone:NO];
        NSLog(@"获取list失败");
    }];
    while (iswait) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return dic;
}

+ (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType)
    ;
}

//将获取文件夹列表改成同步的方式获取
- (NSDictionary *)createFolder:(NSString *)folderName parent:(NSString *)parent
{
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    __block BaseDrive *weakSelf = self;
    __block BOOL iswait = YES;
    __block NSThread *currentthread = [NSThread currentThread];
    [self createFolder:folderName parent:parent success:^(DriveAPIResponse *response) {
        [dic setDictionary:response.content];
        iswait = NO;
        [weakSelf performSelector:@selector(createFolderWait) onThread:currentthread withObject:nil waitUntilDone:NO];
    } fail:^(DriveAPIResponse *response) {
        NSDictionary *edic = [NSDictionary dictionaryWithObject:response.content forKey:@"error"];
        [dic setDictionary:edic];
        iswait = NO;
        [weakSelf performSelector:@selector(createFolderWait) onThread:currentthread withObject:nil waitUntilDone:NO];
        NSLog(@"创建文件夹失败");
    }];
    while (iswait) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return dic;
}

- (void)createFolderWait {
}

- (BOOL)isExecute {
    return NO;
}

- (BOOL)refreshTokenWithDrive {
    return NO;
}

#pragma mark -- 激活已授权的云服务状态
- (void)driveSetAccessTokenKey {
}

#pragma mark -- 取消激活已授权的云服务状态
- (void)driveGetAccessTokenKey {
}

#pragma mark -- 移除已授权的云服务状态
- (void)driveRemoveAccessTokenKey {
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id <DownloadAndUploadDelegate> item = (id <DownloadAndUploadDelegate>)object;
    if ([item state] == DownloadStateComplete || [item state] == DownloadStateError||[item state] == UploadStateComplete || [item state] == UploadStateError) {
        [(NSObject *)item removeObserver:self forKeyPath:@"state"];
        [_folderItemArray removeObject:item];
    }
}
@end

//
//  BaseDrive.m
//  DriveSync
//
//  Created by 罗磊 on 2017/11/30.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "BaseDrive.h"
#import "DriveToDrive.h"



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
@synthesize currentSizeStr = _currentSizeStr;
@synthesize currentProgressStr = _currentProgressStr;
@synthesize parent = _parent;
@synthesize isFolder = _isFolder;
@synthesize isBigFile = _isBigFile;
@synthesize isConstructingData = _isConstructingData;
@synthesize constructingData = _constructingData;
@synthesize constructingDataDriveName = _constructingDataDriveName;
@synthesize constructingDataLength = _constructingDataLength;
@synthesize localPath = _localPath;
@synthesize requestAPI = _requestAPI;
@synthesize uploadParent = _uploadParent;
@synthesize childArray = _childArray;
@synthesize toDriveName = _toDriveName;
@synthesize docwsID = _docwsID;
@synthesize zone = _zone;
@synthesize uploadDocwsID = _uploadDocwsID;
@synthesize startTime = _startTime;

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

- (NSString *)identifier
{
    NSString *urlString = [NSString stringWithFormat:@"%@",_urlString];
    NSString *itemIDString = [NSString stringWithFormat:@"%@",_itemIDOrPath];
    NSString *identifier = [urlString stringByAppendingString:itemIDString];
    return identifier;
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

- (void)dealloc
{
    [_uploadDocwsID release],_uploadDocwsID = nil;
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
    [_docwsID release],_docwsID = nil;
    [_zone release],_zone = nil;
    [_startTime release],_startTime = nil;
    [super dealloc];
}

@end



@implementation BaseDrive
@synthesize driveID = _driveID;
@synthesize driveName = _driveName;
@synthesize displayName = _displayName;
@synthesize driveEmail = _driveEmail;
@synthesize driveType = _driveType;
@synthesize driveTotalCapacity = _driveTotalCapacity;
@synthesize driveUsedCapacity = _driveUsedCapacity;
@synthesize totalCapacity = _totalCapacity;
@synthesize usedCapacity = _usedCapacity;
@synthesize userLoginToken = _userLoginToken;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;
@synthesize delegate = _delegate;
@synthesize driveArray = _driveArray;
@synthesize refreshToken = _refreshToken;
@synthesize totalStorageInBytes = _totalStorageInBytes;
@synthesize usedStorageInBytes = _usedStorageInBytes;
@synthesize docwsid = _docwsid;
- (instancetype)init
{
    if (self = [super init]) {
        _driveArray = [[NSMutableArray alloc] init];
        _driveTodrive = [[DriveToDrive alloc] init];
        _folderItemArray = [[NSMutableArray alloc] init];
        _uploadMaxCount = 3;
        _activeUploadCount = 0;
        _totalCapacity = 0;
        _usedCapacity = 0;
        _uploadArray = [[NSMutableArray alloc] init];
        _synchronQueue = dispatch_queue_create([@"synchronUploadQueue" UTF8String],DISPATCH_QUEUE_SERIAL);
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
    [_driveID release],_driveID = nil;
    [_driveName release],_driveName = nil;
    [_driveType release],_driveType = nil;
    [_driveTotalCapacity release],_driveTotalCapacity = nil;
    [_driveUsedCapacity release],_driveUsedCapacity = nil;
    [_userLoginToken release],_userLoginToken = nil;
    [_accessToken release],_accessToken = nil;
    [_expirationDate release],_expirationDate = nil;
    [_currentAuthorizationFlow release],_currentAuthorizationFlow = nil;
    [_downLoader release],_downLoader = nil;
    [_upLoader release],_upLoader = nil;
    [_refreshToken release],_refreshToken = nil;
    [self setDriveArray:nil];
    [_driveTodrive release],_driveTodrive = nil;
    [_folderItemArray release],_folderItemArray = nil;
    [_uploadArray release],_uploadArray = nil;
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
    self.driveID = nil;
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
        [item setState:TransferStateNormal];
        [self downloadItem:item];
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
        //设置为normal
        item.state = TransferStateNormal;
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
        for (id<DownloadAndUploadDelegate>items in item.childArray) {
            [_upLoader cancelUploadItem:items];
        }
    }else {
        [_upLoader cancelUploadItem:item];
    }
}

- (void)cancelAllUploadItems {
    for (id<DownloadAndUploadDelegate>item in _uploadArray) {
        [self cancelUploadItem:item];
    }
}

#pragma mark DriveToDrive

- (void)toDrive:(BaseDrive *)targetDrive item:(id <DownloadAndUploadDelegate>)item
{
    //先下载到本地,然后再上传
    [_driveTodrive transferFromDrive:self targetDrive:targetDrive item:item];
}

- (void)cancelDriveToDriveItem:(id<DownloadAndUploadDelegate>)item
{
    [_driveTodrive cancelDriveToDriveItem:item];
}
#pragma mark -- 检查请求响应的数据类型
- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest *)request
{
    if (request.responseStatusCode == 200) {
        return ResponseSuccess;
    }else if (request.responseStatusCode == 401){
        return ResponseTokenInvalid;
    }else if (request.responseStatusCode == 400){
        return ResponseInvalid;
    }else{
        return ResponseUnknown;
    }
}

- (ResponseCode)checkResponseTypeWithFailed:(YTKBaseRequest *)request
{
    NSError *error = request.error;
    if (error.code == NSURLErrorNotConnectedToInternet) {
        [request setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
        return ResponseNotConnectedToInternet;
    }else if (error.code == NSURLErrorNetworkConnectionLost){
        [request setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
        return ResponseNetworkConnectionLost;
    }else if (error.code == NSURLErrorTimedOut){
        [request setUserInfo:@{@"errorMessage": @"The request timed out."}];
        return ResponseTimeOut;
    }else{
        return ResponseUnknown;
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
        NSDictionary *edic = [NSDictionary dictionaryWithObject:response.content?:@"" forKey:@"error"];
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

#pragma mark -- 指定目录下的文件夹信息，用于搜索
- (void)getFolderInfo:(NSString *)folerID success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 搜索文件或者文件夹
- (void)searchContent:(NSString *)query withLimit:(NSString *)limit withPageIndex:(NSString *)pageIndex success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 批量删除文件或者文件夹
- (void)deleteFilesOrFolders:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 批量复制文件或文件夹
- (void)copyToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 重命名
- (void)reName:(NSString *)newName idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 批量移动文件或者文件夹
- (void)moveToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 获取收藏、访问文件记录、分享、收藏分享列表
- (void)getListWithPageLimit:(int)pageLimit withPageIndex:(int)pageIndex success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 删除收藏、访问文件记录、分享、收藏分享列表
- (void)deleteCollectionOrShareID:(NSArray *)collectionOrShareIDArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 添加收藏、访问文件记录
- (void)addCollectionOrHistory:(BaseDrive *)baseDrive idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 创建分享
- (void)addShare:(BaseDrive *)baseDrive idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 修改分享
- (void)modifyShare:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 添加分享到收藏
- (void)addShareToCollection:(NSArray *)shareIDArray success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 获取不同状态的离线任务列表
- (void)getStatusList:(OfflineStatus)status success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 创建离线任务
- (void)createOfflineTask:(NSArray *)offlineTaskAry success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 修改离线任务
- (void)modifyOfflineTask:(NSArray *)offlineTaskAry success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 取消正在执行、删除离线任务
- (void)removeOrCancelOfflineTaskID:(NSString *)offlineTaskID withType:(OfflineStatus)type success:(Callback)success fail:(Callback)fail {
}

#pragma mark -- 将获取文件夹列表改成同步的方式获取
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
        if (response.content) {
            NSDictionary *edic = [NSDictionary dictionaryWithObject:response.content forKey:@"error"];
            [dic setDictionary:edic];
        }
        iswait = NO;
        [weakSelf performSelector:@selector(createFolderWait) onThread:currentthread withObject:nil waitUntilDone:NO];
        NSLog(@"创建文件夹失败");
    }];
    while (iswait) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return dic;
}

- (void)createFolderWait{}

- (BOOL)isExecute {
    return NO;
}

- (BOOL)refreshTokenWithDrive {
    return NO;
}

#pragma mark -- 检查已授权的云服务状态
- (BOOL)checkIsConstainDrive:(NSString *)driveID {
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([driveID isEqualToString:[evaluatedObject driveID]]) {
            return YES;
        }else {
            return NO;
        }
    }];
    NSArray *returnAry = [[self driveArray] filteredArrayUsingPredicate:pre];
    if ([returnAry count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -- 置顶功能
- (void)getTopIndexWithDrive:(BaseDrive *)indexDrive {
    [indexDrive setIsSetTopIndex:YES];
    NSInteger index = [_driveArray indexOfObject:indexDrive];
    NSInteger actionIndex = index - 1;
    int length = (int)[_driveArray count];
    if (actionIndex >= length || index < 1) {
        return;
    }
    for (int i = 0; i < length; i++) {
        if (actionIndex == i) {
            break;
        }
        [_driveArray exchangeObjectAtIndex:actionIndex withObjectAtIndex:i];
    }
}

#pragma mark -- 置底功能
- (void)getBottomIndexWithDrive:(BaseDrive *)indexDrive {
    [indexDrive setIsSetBottomIndex:YES];
    NSInteger index = [_driveArray indexOfObject:indexDrive];
    NSInteger actionIndex = index - 1;
    int length = (int)[_driveArray count];
    if (index >= length || index < 1) {
        return;
    }
    for (int i = length - 1; i > 0 ; i--) {
        if (actionIndex == i) {
            break;
        }
        [_driveArray exchangeObjectAtIndex:actionIndex withObjectAtIndex:i];
    }
}

#pragma mark -- 激活已授权的云服务状态
- (void)driveSetAccessTokenKey:(NSString *)driveIDKey {
}

#pragma mark -- 取消激活已授权的云服务状态
- (BOOL)driveGetAccessTokenKey:(NSString *)driveIDKey {
    return NO;
}

#pragma mark -- 移除已授权的云服务状态
- (void)driveRemoveAccessTokenKey:(NSString *)driveIDKey {
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id <DownloadAndUploadDelegate> item = (id <DownloadAndUploadDelegate>)object;
    if ([item state] == DownloadStateComplete || [item state] == DownloadStateError||[item state] == UploadStateComplete || [item state] == UploadStateError) {
        [(NSObject *)item removeObserver:self forKeyPath:@"state"];
        [_folderItemArray removeObject:item];
    }
}

#pragma makr - 最大上传数限制
- (BOOL)isUploadActivityLessMax
{
    return _activeUploadCount <= _uploadMaxCount;
}

- (void)removeUploadTaskForItem:(id<DownloadAndUploadDelegate>)item
{
    [_uploadArray removeObject:item];
    _activeUploadCount--;
}

- (void)startNextTaskIfAllow
{
    for (id <DownloadAndUploadDelegate>item in _uploadArray ) {
        if ([self isUploadActivityLessMax]) {
            if (item.state == UploadStateWait) {
                [self startUploadItem:item];
            }
        }else{
            break;
        }
    }
}

- (void)startUploadItem:(id<DownloadAndUploadDelegate>)item{};

- (void)setDownloadPath:(NSString *)downloadPath{
    [_downLoader setDownloadPath:downloadPath];
}
@end

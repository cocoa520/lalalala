//
//  BaseDrive.h
//  DriveSync
//
//  Created by 罗磊 on 2017/11/30.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AppAuth/AppAuth.h>
#if __has_include(<YTKNetwork/YTKNetwork.h>)
#import <YTKNetwork/YTKNetwork.h>
#else
#import "YTKNetwork.h"
#endif
#import "DriveAPIResponse.h"
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif
#import "DownLoader.h"
#import "UpLoader.h"
#import "RefreshTokenAPI.h"
#import "NotificationConst.h"

static NSString *const kAppAuthDropboxStateKey = @"kAppAuthDropboxStateKey";
static NSString *const kAppAuthFacebookStateKey = @"kAppAuthFacebookStateKey";
static NSString *const kAppAuthTwitterStateKey = @"kAppAuthTwitterStateKey";
static NSString *const kAppAuthGoogleDriveStateKey = @"kAppAuthGoogleDriveStateKey";
static NSString *const kAppAuthInstagramStateKey = @"kAppAuthInstagramStateKey";
static NSString *const kAppAuthOneDriveStateKey = @"kAppAuthOneDriveStateKey";
static NSString *const kAppAuthGooglePhotosStateKey = @"kAppAuthGooglePhotosStateKey";
static NSString *const kAppAuthBoxStateKey = @"kAppAuthBoxStateKey";
static NSString *const kAppAuthpCloudStateKey = @"kAppAuthpCloudStateKey";
static NSString *const kAccessTokenKey = @"accessToken";

@class BaseDrive;
@class DriveToDrive;
typedef void(^Callback)(DriveAPIResponse *response);
typedef void (^RefreshTokenAction)(BOOL refresh);

@interface DownLoadAndUploadItem : NSObject<DownloadAndUploadDelegate>

@end
/**
 *@description 登录时传入此类对象，用于完成登录结果的回调和token过期注销的回调
 */
@protocol BaseDriveDelegate <NSObject>

@optional
/**
 *  登录
 */
- (void)driveDidLogIn:(BaseDrive *)drive;

/**
 *  注销
 */
- (void)driveDidLogOut:(BaseDrive *)drive;

/**
 *  请求成功回调
 *  @param type 如果是注册,type=@"register"; 如果是登录,type=@"login"; 如果是取消授权云服务,type=@"cancelAuth"; 如果是重命名云服务,type=@"renameAuth"; 如果是添加云盘, type=@"bindDrive"; 如果是云盘置顶, type=@"setTopIndex"; 如果是云盘分类, type=@"driveCategory"
 */
- (void)driveAPIRequest:(BaseDrive *)drive withSuccess:(NSDictionary *)successDict withType:(NSString *)type;
/**
 *  请求错误回调
 *  @param type 如果是注册,type=@"register"; 如果是登录,type=@"login"; 如果是取消授权云服务,type=@"cancelAuth"; 如果是重命名云服务,type=@"renameAuth"; 如果是添加云盘, type=@"bindDrive"; 如果是第三方登录, type=@"thirdLogin"; 如果是云盘置顶, type=@"setTopIndex"; 如果是云盘分类, type=@"driveCategory"
 */
- (void)driveAPIRequest:(BaseDrive *)drive withFailed:(NSDictionary *)errorDict withType:(NSString *)type;
/** 令牌方式登录 错误回调 */
- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error;
/** 用户名和密码方式登录 错误回调 */
- (void)drive:(BaseDrive *)drive logInFailWithResponseCode:(ResponseCode)responseCode;
/** 表明需要二次验证 回调给给界面弹出安全码验证框 */
- (void)driveNeedSecurityCode:(BaseDrive *)drive;
/** 账号被锁住了 */
- (void)driveAccountLocked:(BaseDrive *)drive;

@end

typedef NS_ENUM(NSInteger, OfflineStatus) {
    OfflineTaskWaiting = 0,             ///<等待执行
    OfflineTaskRunning,                 ///<正在执行
    OfflineTaskCancel,                  ///<取消正在执行
    OfflineTaskCompleted,               ///<执行完成
    OfflineTaskRemove,                  ///<删除执行
    OfflineTaskClear,                   ///<清除执行记录
};

@interface BaseDrive : NSObject
{
    NSString *_driveID;
    NSString *_driveName;
    NSString *_displayName;
    NSString *_driveEmail;
    NSString *_driveType;
    NSString *_driveTotalCapacity;
    NSString *_driveUsedCapacity;
    long long _totalCapacity;
    long long _usedCapacity;
    NSString *_userLoginToken;
    NSString *_accessToken;
    NSString *_refreshToken;
    NSDate *_expirationDate;
    id<OIDAuthorizationFlowSession> _currentAuthorizationFlow;   ///<当前认证流会话
    OIDRedirectHTTPHandler *_redirectHTTPHandler;                ///<重定向hander
    id<BaseDriveDelegate >_delegate;
    DownLoader *_downLoader;                                     ///<下载器
    UpLoader *_upLoader;                                         ///<上传器
    DriveToDrive *_driveTodrive;                                 ///云到云传输器
    NSMutableArray *_driveArray;
    
    BOOL _isFromLocalOAuth;                                     ///<是否是从本地认证
    BOOL _isSetTopIndex;
    BOOL _isSetBottomIndex;
    NSMutableArray *_folderItemArray;                           ///<保存下载的folder项
    
    /**
     *  最大同时上传数限制，由于api接口限制，同时上传的个数有限制，超出限制请求会失败，同时下载个数限制已经在Downloader里做了限制 
     *  由于很多云盘上传分了几个步骤，所以将同时上传个数限制加入到云盘类里
     */
    
    NSInteger _uploadMaxCount;                  ///<最大上传数
    NSInteger _activeUploadCount;
    NSMutableArray *_uploadArray;               ///<上传数组
    dispatch_queue_t _synchronQueue;
    long long _totalStorageInBytes;//总容量
    long long _usedStorageInBytes;//使用容量
    //iCLoud Drive属性
    NSString *_docwsid;
}
//总容量
@property (nonatomic,assign) long long totalStorageInBytes;
//使用容量
@property (nonatomic,assign) long long usedStorageInBytes;
/** 驱动器ID */
@property (nonatomic,retain) NSString *driveID;
/** 驱动器名称 */
@property (nonatomic,retain) NSString *driveName;
/** 驱动器邮箱 */
@property (nonatomic,retain) NSString *driveEmail;
/** 驱动器显示名字 */
@property (nonatomic,retain) NSString *displayName;
/** 驱动器类型 */
@property (nonatomic,retain) NSString *driveType;
/** 驱动器总容量 */
@property (nonatomic,retain) NSString *driveTotalCapacity;
/** 驱动器已用容量 */
@property (nonatomic,retain) NSString *driveUsedCapacity;
/** 驱动器总容量-longlong */
@property (nonatomic,assign) long long totalCapacity;
/** 驱动器已用容量-longlong  */
@property (nonatomic,assign) long long usedCapacity;
/** 用户登录令牌 */
@property (nonatomic,retain) NSString *userLoginToken;
/** 访问令牌 */
@property (nonatomic,retain) NSString *accessToken;
/** 刷新令牌 */
@property (nonatomic,retain) NSString *refreshToken;
/** 过期时间 */
@property (nonatomic,retain) NSDate *expirationDate;
@property (nonatomic,retain) id<BaseDriveDelegate > delegate;
/**
 *  是否添加置顶
 */
@property (nonatomic, assign) BOOL isSetTopIndex;
/**
 *  是否添加置底
 */
@property (nonatomic, assign) BOOL isSetBottomIndex;
/**
 *  加入的云服务数组
 */
@property (nonatomic, readwrite, retain) NSMutableArray *driveArray;
 @property (nonatomic, retain) NSString *docwsid;
/**
 *  Description 得到一个文件的mime值
 *
 *  @param path 文件路径
 *
 *  @return 返回mime值
 */
+ (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path;
/**
 *  Description 从本地认证初始化方法
 *
 *  @param isFromLocalOAuth YES 为从本地认证 NO为web端认证
 *
 *  @return 返回自己
 */
- (id)initWithFromLocalOAuth:(BOOL)isFromLocalOAuth;


/**
 *  将标准时间转化为对应的当地时间
 *
 *  @param anyDate 标准时间
 *
 *  @return 当地时间
 */
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

/**
 **************************** @description 登录认证相关方法
 */

/**
 *  Description  接受internet事件
 *
 *  @param event      event 事件描述符
 *  @param replyEvent replyEvent 回应事件描述符
 */
- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event
           withReplyEvent:(NSAppleEventDescriptor *)replyEvent;

/**
 *  用户退出
 */
- (void)userDidLogout;

/**
 *  用户是否登录
 *
 *  @return YES or NO
 */
- (BOOL)isUserLogin;

/**
 *@description 云登录和注销方法
 */
- (void)logIn;
- (void)logOut;

/**
 *@description 判断是否登录
 *@return YES为已登录，NO为未登录
 */
- (BOOL)isLoggedIn;

/**
 *@description 判断登录是否过期
 *@return YES为过期，NO为未过期
 */
- (BOOL)isAuthorizeExpired;

/**
 *@description 判断登录是否有效
 *@return YES为有效，NO为无效
 */
- (BOOL)isAuthValid;

/**
 *  获取云盘用户信息
 *
 *  @param accountID 账号ID
 *  @param success   成功回调block
 *  @param fail      失败回调block
 */
- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail;

/**
 ***************************** @description 文件操作相关方法
 */

/**
 *  Description 创建文件夹
 *
 *  @param folderName 文件夹名字
 *  @param parentID     文件夹所在父目录ID或者路径 @"0"表示根目录ID
 *  @param success    成功回调block
 *  @param fail       失败回调block
 *
 */
- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID success:(Callback)success fail:(Callback)fail;

/**
 *  Description 同步方式创建文件夹
 *
 *  @param folderName 文件夹名字
 *  @param parent    文件夹所在父目录ID或者路径 @"0"表示根目录ID
 *
 *  @return 创建目录返回值
 */
- (NSDictionary *)createFolder:(NSString *)folderName parent:(NSString *)parent;

/**
 *  Description 得到指定目录下的文件夹信息，用于搜索
 *
 *  @param folerID 目录ID或者路径   @"0"表示根目录ID
 *  @param success 成功回调block
 *  @param fail    失败回调block
 *
 */
- (void)getFolderInfo:(NSString *)folerID success:(Callback)success fail:(Callback)fail;

/**
 *  Description 得到指定目录下的文件列表
 *
 *  @param folerID 目录ID或者路径   @"0"表示根目录ID
 *  @param success 成功回调block
 *  @param fail    失败回调block
 *
 */
- (void)getList:(NSString *)folerID success:(Callback)success fail:(Callback)fail;

/**
 *  Description 同步方式获取目录列表
 *
 *  @param folerID 目录id或者路径
 *
 *  @return 返回 获取列表返回值
 */
- (NSDictionary *)getList:(NSString *)folerID;

/**
 *  搜索文件或者文件夹
 *
 *  @param query                待搜索名称
 *  @param limit                待搜索条数  默认 @"20"
 *  @param pageIndex            搜索第几页  第一次 默认传 @""
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */

- (void)searchContent:(NSString *)query withLimit:(NSString *)limit withPageIndex:(NSString *)pageIndex success:(Callback)success fail:(Callback)fail;

/**
 *  批量删除文件或者文件夹
 *
 *  @param idOrPathArray        源目录数组，包含 @{@"itemIDOrPath": @"文件ID/文件夹ID/文件的完整路径",    //Dropbox传入ID或者完整路径
 *                                              @"isFolder": @(YES)/@(NO)}
 *                              iCloudDrive规则: @{@"etag" : @"oz",
 *                                                @"drivewsid" : @"FOLDER::com.apple.CloudDocs::B661E364-426F-4EAF-A2FE-2BAB5BA7CA96"}
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)deleteFilesOrFolders:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail;

/**
 *  批量复制文件或文件夹
 *
 *  @param newParentIdOrPath    如果是复制到其他子目录，Dropbox或者OneDrive, 传入目标完整路径; 其他云盘, 传入目标ID;
 *                              如果是复制到根目录，GoogleDrive传入根目录ID，其他云盘，传入0
 *  @param idOrPathArray        源目录数组，包含 @{@"fromItemIDOrPath": @"文件ID/文件夹ID/文件的完整路径",      //Dropbox才需要传入完整路径
 *                                              @"fromFolderName": @"文件夹名称",                         //GoogleDrive、PCloud需要传入文件夹名称
 *                                              @"isFolder": @(YES)/@(NO)}
 *                              iCloudDrive规则: @{@"etag": @"pi",
 *                                                @"drivewsid": @"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *                                                @"clientId":@"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB"}
 }
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)copyToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail;

/**
 *  重命名
 *
 *  @param newName              如果是文件夹，传入新名字; 如果是文件，传入新名字+后缀
 *  @param idOrPathArray        源目录数组，包含 @{@"itemIDOrPath": @"文件ID/文件夹ID/文件的完整路径",    //Dropbox才需要传入完整路径
 *                                              @"isFolder": @(YES)/@(NO)}
 *                              iCloudDrive规则: @{@"etag": @"pi",
 *                                                @"drivewsid": @"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *                                                @"name": @"hhh22"}
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)reName:(NSString *)newName idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail;

/**
 *  批量移动文件或者文件夹
 *
 *  @param newParentIdOrPath    如果是移动到其他子目录，Dropbox或者OneDrive, 传入目标完整路径; 其他云盘, 传入目标ID
 *                              如果是移动到根目录，GoogleDrive传入根目录ID，其他云盘，传入0
 *  @param idOrPathArray        源目录数组，包含 @{@"fromItemIDOrPath": @"文件ID/文件夹ID/文件的完整路径",      //Dropbox才需要传入完整路径
 *                                              @"fromItemParentID": @"文件/文件夹父目录ID",               //GoogleDrive才需要传入
 *                                              @"fromName": @"文件夹/文件名+后缀",                        //Box才需要传入
 *                                              @"isFolder": @(YES)/@(NO)}
 *                              iCloudDrive规则: @{@"drivewsid":@"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *                                                @"etag":@"pp",
 *                                                @"clientId":@"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB"}
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)moveToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail;

/**
 *  获取收藏、访问文件记录、分享、收藏分享列表
 *
 *  @param pageLimit    显示多少条
 *  @param pageIndex    第几页
 *  @param success      成功回调block
 *  @param fail         失败回调block
 *
 */
- (void)getListWithPageLimit:(int)pageLimit withPageIndex:(int)pageIndex success:(Callback)success fail:(Callback)fail;

/**
 *  删除收藏、访问文件记录、分享、收藏分享列表
 *
 *  @param collectionOrShareIDArray     数组，包含 @{@"collectionOrShareID": @"收藏ID/分享ID/收藏分享ID"}
 *  @param success                      成功回调block
 *  @param fail                         失败回调block
 *
 */
- (void)deleteCollectionOrShareID:(NSArray *)collectionOrShareIDArray success:(Callback)success fail:(Callback)fail;

/**
 *  添加收藏、访问文件记录
 *
 *  @param baseDrive            传入云盘对象
 *  @param idOrPathArray        源目录数组，包含 @{@"itemIDOrPath": @"文件ID/文件夹ID",
 *                                              @"isFolder": @(YES)/@(NO),
 *                                              @"albumID": @"相册ID"}                                //GooglePhoto相册才需要传入
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)addCollectionOrHistory:(BaseDrive *)baseDrive idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail;

/**
 *  创建分享
 *
 *  @param baseDrive            传入云盘对象
 *  @param idOrPathArray        源目录数组，包含 @{@"itemIDOrPath": @"文件ID/文件夹ID",
 *                                              @"isFolder": @(YES)/@(NO),
 *                                              @"maxDownload": @"分享的允许最大的下载数",
 *                                              @"shareExpireAt": @"分享到到期时间",                    //(比如2018-05-30 12:36:58)
 *                                              @"sharePassword": @"分享密码",
 *                                              @"albumID": @"相册ID"}                                //GooglePhoto相册才需要传入
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)addShare:(BaseDrive *)baseDrive idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail;

/**
 *  修改分享
 *
 *  @param idOrPathArray        源目录数组，包含 @{@"collectionOrShareID": @"分享ID",
 *                                              @"maxDownload": @"分享的允许最大的下载数",
 *                                              @"shareExpireAt": @"分享到到期时间",                    //(比如2018-05-30 12:36:58)
 *                                              @"sharePassword": @"分享密码",
 *                                              @"albumID": @"相册ID"}                                //GooglePhoto相册才需要传入
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)modifyShare:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail;

/**
 *  添加分享到收藏
 *
 *  @param shareIDArray         分享ID数组，包含 @{@"shareID": @"分享ID"}
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)addShareToCollection:(NSArray *)shareIDArray success:(Callback)success fail:(Callback)fail;

/**
 *  获取不同状态的离线任务列表
 *
 *  @param status               任务状态
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)getStatusList:(OfflineStatus)status success:(Callback)success fail:(Callback)fail;

/**
 *  创建离线任务
 *
 *  @param offlineTaskAry       执行离线任务数组字典
 *                              @{
 *                                  @"name": @"任务名称",
 *                                  @"source_drive_id": @"源驱动器ID",
 *                                  @"target_drive_id": @"目标驱动器ID",
 *                                  @"source_path": @"源文件路径ID数组",               //留空表示根目录
 *                                  @"target_path": @"目标文件路径ID",                 //留空表示根目录
 *                                  @"type": @"任务类型",                             //type: one-way/two-way
 *                                  @"mode": @"传输模式",                             //mode: move/copy/backup
 *                                  @"scope": @"传输范围",                            //scope: file/folder/留空（双向同步）
 *                                  @"conflict": @"冲突处理",                         //conflict: skip/overwrite/rename/留空（双向同步）
 *                                  @"frequency": @"执行频率",                        //frequency: once/day/week/month
 *                                  @"execute_time": @"执行时间",
 *                              }
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)createOfflineTask:(NSArray *)offlineTaskAry success:(Callback)success fail:(Callback)fail;

/**
 *  修改离线任务
 *
 *  @param offlineTaskAry       执行离线任务数组字典
 *                              @{
 *                                  @"name": @"任务名称",
 *                                  @"type": @"任务类型",                             //type: one-way/two-way
 *                                  @"mode": @"传输模式",                             //mode: move/copy/backup
 *                                  @"scope": @"传输范围",                            //scope: file/folder/留空（双向同步）
 *                                  @"conflict": @"冲突处理",                         //conflict: skip/overwrite/rename/留空（双向同步）
 *                                  @"frequency": @"执行频率",                        //frequency: once/day/week/month
 *                                  @"execute_time": @"执行时间",
 *                              }
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)modifyOfflineTask:(NSArray *)offlineTaskAry success:(Callback)success fail:(Callback)fail;

/**
 *  取消正在执行、删除离线任务
 *
 *  @param offlineTaskID        离线任务ID
 *  @param type                 离线任务类型, type: remove(删除离线任务)/cancel(取消正在执行的离线任务)
 *  @param success              成功回调block
 *  @param fail                 失败回调block
 */
- (void)removeOrCancelOfflineTaskID:(NSString *)offlineTaskID withType:(OfflineStatus)type success:(Callback)success fail:(Callback)fail;

/**
 ***************************** @description 下载相关方法
 */

- (void)downloadFolder:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 * @description 下载一个item
 *  @param item 传入所需
 */
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description  下载一个item 具有完成回调
 *
 *  @param item              item
 *  @param completionHandler completionHandler 完成回调
 */
- (void)startDownload:(_Nonnull id <DownloadAndUploadDelegate>)item completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/**
 *  @description 同时下载多个
 *  @param items 传入数组
 */
- (void)downloadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

/**
 *  @description暂停正在下载的项
 *
 *  @param item 传入要暂停的项
 */
- (void)pauseDownloadItem:(_Nonnull id <DownloadAndUploadDelegate>)item;

/**
 *  Description 暂停所有的下载项
 */
- (void)pauseAllDownloadItems;

/**
 *  Description 恢复下载项
 *
 *  @param item 下载项
 */
- (void)resumeDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description 恢复所有下载项
 */
- (void)resumeAllDownloadItems;

/**
 *  Description 取消下载项
 *
 *  @param item 下载项
 */
- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description 取消所有
 */
- (void)cancelAllDownloadItems;

/**
 * ***************************** @description 上传相关方法
 */

/**
 * @description 上传一个item
 *  @param item 传入所需
 */
- (void)uploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  @description 同时上传多个
 *  @param items 传入数组
 */
- (void)uploadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

/**
 *  @description暂停正在上传的项
 *
 *  @param item 传入要暂停的项
 */
- (void)pauseUploadItem:(_Nonnull id <DownloadAndUploadDelegate>)item;

/**
 *  Description 暂停所有的上传项
 */
- (void)pauseAllUploadItems;

/**
 *  Description 恢复上传项
 *
 *  @param item 上传项
 */
- (void)resumeUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description 恢复所有上传项
 */
- (void)resumeAllUploadItems;

/**
 *  Description 取消上传项
 *
 *  @param item 上传项
 */
- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description 取消所有上传项
 */
- (void)cancelAllUploadItems;

/**
 * ***************************** @description 云到云传输相关方法
 */

/**
 *  Description  云到云传输
 *
 *  @param targetDrive 目标云
 *  @param item        传输项
 */
- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(_Nonnull id <DownloadAndUploadDelegate>)item;

/**
 *  Description 取消云到云传输
 *
 *  @param item 取消项
 */
- (void)cancelDriveToDriveItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  检查请求响应的数据类型
 *
 *  @param response 成功回调返回的数据
 *
 *  @return 错误类型
 */
- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest * _Nonnull)response;

/**
 *  检查请求响应的数据类型
 *
 *  @param response 失败回调返回的数据
 *
 *  @return 错误类型
 */
- (ResponseCode)checkResponseTypeWithFailed:(YTKBaseRequest * _Nonnull)response;

/**
 *  每次请求前需调用此方法，判断Token是否有效
 *
 *  @return YES or NO
 */
- (BOOL)isExecute;

/**
 *  刷新Token
 *
 *  @return YES or NO
 */
- (BOOL)refreshTokenWithDrive;

/**
 *  检查已授权的云服务状态
 */
- (BOOL)checkIsConstainDrive:(NSString * _Nonnull)driveID;

/**
 *  置顶功能
 *
 *  @param indexDrive           需要置顶的drive对象
 */
- (void)getTopIndexWithDrive:(BaseDrive * _Nonnull)indexDrive;

/**
 *  置底功能
 *
 *  @param indexDrive           需要置底的drive对象
 */
- (void)getBottomIndexWithDrive:(BaseDrive * _Nonnull)indexDrive;

/**
 *  保存访问Token令牌Key值
 */
- (void)driveSetAccessTokenKey:(NSString *_Nonnull)driveIDKey;

/**
 *  获得访问Token令牌Key值
 */
- (BOOL)driveGetAccessTokenKey:(NSString *_Nonnull)driveIDKey;

/**
 *  移除访问Token令牌Key值
 */
- (void)driveRemoveAccessTokenKey:(NSString *_Nonnull)driveIDKey;
/**
 *  Description 看正在上传的最大值
 *
 *  @return 返回值
 */
- (BOOL)isUploadActivityLessMax;

/**
 *  Description 从上传数组中移除上传项
 *
 *  @param item 上传项
 */
- (void)removeUploadTaskForItem:(_Nullable id<DownloadAndUploadDelegate>)item;

/**
 *  Description 如果条件允许开始执行下一个上传任务
 */
- (void)startNextTaskIfAllow;

/**
 *  Description 用户唤醒runloop
 */
- (void)createFolderWait;

/**
 *  Description 设置下载路径
 *
 *  @param downloadPath 下载路径
 */
- (void)setDownloadPath:(NSString * _Nonnull)downloadPath;

@end



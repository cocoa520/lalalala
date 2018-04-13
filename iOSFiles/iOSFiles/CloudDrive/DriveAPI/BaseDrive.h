//
//  BaseDrive.h
//  DriveSync
//
//  Created by 罗磊 on 2017/11/30.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppAuth/AppAuth.h>
#import <YTKNetwork/YTKNetwork.h>
#import "DriveAPIResponse.h"
#import <AFNetworking/AFNetworking.h>
#import "DownLoader.h"
#import "UpLoader.h"
#import "RefreshTokenAPI.h"
#import "NotificationConst.h"
#import "ATTracker.h"
#import "TempHelper.h"

//#import "DriveToDrive.h"
@class DriveToDrive;
static NSString *const kAppAuthDropboxStateKey = @"kAppAuthDropboxStateKey";
//static NSString *const kAppAuthFacebookStateKey = @"kAppAuthFacebookStateKey";
//static NSString *const kAppAuthGmailStateKey = @"kAppAuthGmailStateKey";
static NSString *const kAppAuthGoogleDriveStateKey = @"kAppAuthGoogleDriveStateKey";
//static NSString *const kAppAuthInstagramStateKey = @"kAppAuthInstagramStateKey";
static NSString *const kAppAuthOneDriveStateKey = @"kAppAuthOneDriveStateKey";
static NSString *const kAppAuthBoxStateKey = @"kAppAuthBoxStateKey";

static NSString *const kAccessTokenKey = @"accessToken";

@class BaseDrive;
typedef void(^Callback)(DriveAPIResponse *response);
typedef void (^RefreshTokenAction)(BOOL refresh);

@interface DownLoadAndUploadItem : NSObject<DownloadAndUploadDelegate>
@end
/**
 *@description 登录时传入此类对象，用于完成登录结果的回调和token过期注销的回调
 */
@protocol BaseDriveDelegate <NSObject>

@optional

- (void)driveDidLogIn:(BaseDrive *)drive;
- (void)driveDidLogOut:(BaseDrive *)drive;
- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error;
//表明需要二次验证 回调给给界面弹出安全码验证框
- (void)driveNeedSecurityCode:(BaseDrive *)drive;
//账号被锁住了
- (void)driveAccountLocked:(BaseDrive *)drive;

@end

@interface BaseDrive : NSObject
{
    NSString *_userID;           ///<用户名
    NSString *_driveID;          ///<驱动器ID
    NSString *_userLoginToken;   ///<用户登录令牌
    NSString *_accessToken;      ///<访问令牌
    NSString *_refreshToken;      ///<刷新令牌
    NSDate *_expirationDate;     ///<过期时间
    id<OIDAuthorizationFlowSession> _currentAuthorizationFlow;   ///<当前认证流会话
    OIDRedirectHTTPHandler *_redirectHTTPHandler;                ///<重定向hander
    id<BaseDriveDelegate >_delegate;
    DownLoader *_downLoader;                                     ///<下载器
    UpLoader *_upLoader;                                         ///<上传器
    NSMutableArray *_driveArray;
    
    BOOL _isFromLocalOAuth;                                     ///<是否是从本地认证
    NSMutableArray *_folderItemArray;                           ///<保存下载的folder项
    
    DriveToDrive *_driveTodrive;                                 ///云到云传输器
    
    
    /**
     *  最大同时上传数限制，由于api接口限制，同时上传的个数有限制，超出限制请求会失败，同时下载个数限制已经在Downloader里做了限制
     *  由于很多云盘上传分了几个步骤，所以将同时上传个数限制加入到云盘类里
     */
    
    NSInteger _uploadMaxCount;                  ///<最大上传数
    NSInteger _activeUploadCount;
    NSMutableArray *_uploadArray;               ///<上传数组
    dispatch_queue_t _synchronQueue;
}

@property(nonatomic,retain)NSString *userID;
@property(nonatomic,retain)NSString *driveID;
@property(nonatomic,retain)NSString *userLoginToken;
@property(nonatomic,retain)NSString *accessToken;
@property(nonatomic,retain)NSString *refreshToken;
@property(nonatomic,retain)NSDate *expirationDate;
@property(nonatomic,retain)DownLoader *downLoader; 
@property(nonatomic,retain)id<BaseDriveDelegate >delegate;

/**
 *  Description 从本地认证初始化方法
 *
 *  @param isFromLocalOAuth YES 为从本地认证 NO为web端认证
 *
 *  @return 返回自己
 */
- (id)initWithFromLocalOAuth:(BOOL)isFromLocalOAuth;

/**
 *  加入的云服务数组
 */
@property (nonatomic, readwrite, retain) NSMutableArray *driveArray;

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
 *  Description 重命名
 *
 *  @param newName  新名字
 *  @param idOrPath id或者路径
 *  @param success 成功回调block
 *  @param fail    失败回调block
 */
- (void)reName:(NSString *)newName idOrPath:(NSString *)idOrPath success:(Callback)success fail:(Callback)fail;

/**
 *  Description 移动
 *
 *  @param newParent 父目录的id或者路径
 *  @param parent 原父目录 视情况而定有的平台 不需要parent参数 传nil即可 比如onedrive 不需要parent参数
 *  @param idOrPaths  自身的id或者路径数组
 *  @param success   成功回调block
 *  @param fail      失败回调block
 */
- (void)moveToNewParent:(NSString *)newParent sourceParent:(NSString *)parent idOrPaths:(NSArray *)idOrPaths success:(Callback)success fail:(Callback)fail;

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


+ (NSString * _Nullable)getMIMETypeWithCAPIAtFilePath:(NSString * _Nullable)path;
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
 *  保存访问Token令牌Key值
 */
- (void)driveSetAccessTokenKey;

/**
 *  获得访问Token令牌Key值
 */
- (void)driveGetAccessTokenKey;

/**
 *  移除访问Token令牌Key值
 */
- (void)driveRemoveAccessTokenKey;

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
- (void)removeUploadTaskForItem:(id<DownloadAndUploadDelegate>)item;

/**
 *  Description 如果条件允许开始执行下一个上传任务
 */
- (void)startNextTaskIfAllow;

@end

//
//  IMBCloudManager.h
//  
//
//  Created by ding ming on 18/4/9.
//
//

#import <Foundation/Foundation.h>
#import "LoginAuthorizationDrive.h"
#import "GoogleDrive.h"
#import "OneDrive.h"
#import "IMBBaseManager.h"
#import "IMBTransferViewController.h"

#define AccountCreateSuccessedNotification @"Account_Create_Successed"
#define AccountCreateErroredNotification @"Account_Create_Errored"
#define AccountLoginSuccessedNotification @"Account_Login_Successed"
#define AccountLogoutSuccessedNotification @"Account_Logout_Successed"
#define AccountLoginErroredNotification @"Account_Login_Errored"
#define AccountLogoutErroredNotification @"Account_Logout_Errored"
#define BindDriveSuccessedNotification @"Bind_Drive_Successed"
#define BindDriveErroredNotification @"Bind_Drive_Errored"
#define DeleteDriveSuccessedNotification @"Delete_Drive_Successed"
#define DeleteDriveErroredNotification @"Delete_Drive_Errored"
#define RefreshDriveSuccessedNotification @"Refresh_Drive_successed"
#define RefreshDriveErroredNotification @"Refresh_Drive_errored"
#define HistoryDriveSuccessedNotification @"History_Drive_Successed"
#define HistoryDriveErroredNotification @"History_Drive_Errored"

@interface IMBCloudManager : NSObject <BaseDriveDelegate> {
    LoginAuthorizationDrive *_driveManager;
    NSNotificationCenter *_nc;
    NSString *_curEmail;
    NSString *_curPassword;
    NSMutableDictionary *_cloudManagerDic;
    NSMutableArray *_categroyAryM;
    NSMutableDictionary *_contentCloudDicM;
    IMBiCloudDriveManager *_iCloudDriveManager; // icloudDrive 保留iclouddrive对象
    NSMutableArray *_starAry;
    IMBTransferViewController *_transferViewController;
    IMBUserHistoryTable *_userTable;
    BOOL _isLoadingHistory;
}
@property (nonatomic, retain) LoginAuthorizationDrive *driveManager;
@property (nonatomic, readwrite, retain) NSString *curEmail;
@property (nonatomic, readwrite, retain) NSString *curPassword;
/** 云盘分类数组 */
@property (nonatomic, readwrite, retain) NSMutableArray *categroyAryM;
/** 增加的云盘类别字典 */
@property (nonatomic, readwrite, retain) NSMutableDictionary *contentCloudDicM;
/** 云盘管理类的字典 */
@property (nonatomic, retain) NSMutableDictionary *cloudManagerDic;
/** 收藏文件记录数组 */
@property (nonatomic, retain) NSMutableArray *starAry;
@property (nonatomic, retain) IMBiCloudDriveManager *iCloudDriveManager;
/** 传输界面的控制器*/
@property (nonatomic, retain) IMBTransferViewController *transferViewController;
/** 历史记录管理器*/
@property (nonatomic, retain) IMBUserHistoryTable *userTable;
@property (nonatomic, assign) BOOL isLoadingHistory;

+ (IMBCloudManager *)singleton;

/**
 *  创建账号
 *
 *  @param account         账号名
 *  @param password        账号密码
 *  @param confirmPassword 确认密码
 */
- (void)createAccount:(NSString *)account Password:(NSString *)password ConfirmPassword:(NSString *)confirmPassword;

/**
 *  用户登录
 *
 *  @param account    账号
 *  @param password   密码
 *  @param g2fcode    输入Google登录需要的二次验证Code
 *  @param needCode   是否需要Code, 需要设为YES, 反之设为NO
 */
- (void)loginAccount:(NSString *)account Password:(NSString *)password G2FCode:(NSString *)g2fcode IsNeedCode:(BOOL)needCode;

/**
 *  用户退出账号
 */
- (void)logoutAccount;

/**
 *  增加云盘
 *
 *  @param cloudName 云盘名字
 */
- (void)addCloud:(NSString *)cloudName;

/**
 *  删除云盘
 *  drive   云盘句柄
 */
- (void)deleteCloud:(BaseDrive *)drive;

/**
 *  指定云盘置顶
 *
 *  @param indexdrive           云服务对象
 */
- (void)driveTopIndexWithDrive:(BaseDrive *)indexdrive;

/**
 *  获取对应绑定云盘
 *
 *  @param driveID 唯一标记
 *
 *  @return 返回云盘句柄s
 */
- (BaseDrive *)getBindDrive:(NSString *)driveID;

/**
 *  获取能增加的云盘类型
 */
- (void)getDriveCategoryList;

/**
 *  刷新所有绑定云盘
 */
- (void)refresh;

#pragma mark - 历史记录、分享、收藏、垃圾箱的获取、添加、删除方法
/**
 *  获取历史记录、分享、收藏、垃圾箱内容
 *
 *  @param type 用来判断是以上那种类型
 */
- (void)getContentList:(NSString *)type;

/**
 *  增加历史记录、分享、收藏、垃圾箱内容
 *
 *  @param contentArray 增加内容数组
 *  @param type         用来判断是以上那种类型
 *  @param driveID      云盘唯一标示
 */
- (void)addContent:(NSArray *)contentArray Type:(NSString *)type DriveID:(NSString *)driveID;

#pragma mark - 获取/保存云盘的管理类
/**
 *  保存云管理类
 *
 *  @param baseDrive 底层云类
 */
- (void)saveCloudManager:(BaseDrive *)baseDrive;

/**
 *  获取云管理类
 *
 *  @param baseDrive 底层云类
 *
 *  @return 返回云管理类
 */
- (IMBBaseManager *)getCloudManager:(BaseDrive *)baseDrive;

/**
 *  删除云管理类
 *
 *  @param baseDrive 底层云类
 */
- (void)removeCloudManager:(BaseDrive *)baseDrive;

@end

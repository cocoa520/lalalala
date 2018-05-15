//
//  LoginAuthorizationDrive.h
//  DriveSync
//
//  Created by JGehry on 12/13/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "BaseDrive.h"
#import "CollectionFavorite.h"
#import "AccessHistory.h"
#import "Share.h"
#import "CollectionShare.h"
#import "OfflineTask.h"

@class LoginAuthorizationDriveEntity;
@interface LoginAuthorizationDrive : BaseDrive {
    LoginAuthorizationDriveEntity *_loginEntity;
    CollectionFavorite *_collectionFavorite;
    AccessHistory *_accessHistory;
    Share *_share;
    CollectionShare *_collectionShare;
    OfflineTask *_offlineTask;
    int bindInUsed;
}

/** 登录账户实体 */
@property (nonatomic, readwrite, retain) LoginAuthorizationDriveEntity * _Nonnull loginEntity;
@property (nonatomic, readwrite, retain) CollectionFavorite * _Nonnull collectionFavorite;
@property (nonatomic, readwrite, retain) AccessHistory * _Nonnull accessHistory;
@property (nonatomic, readwrite, retain) Share * _Nonnull share;
@property (nonatomic, readwrite, retain) CollectionShare * _Nonnull collectionShare;
@property (nonatomic, readwrite, retain) OfflineTask * _Nonnull offlineTask;

/**
 *  用户注册
 *
 *  @param email                    输入正确的邮箱
 *  @param password                 输入正确的密码
 *  @param confirmPassword          输入重复正确的密码
 */
- (void)userRegisterWithEmail:(NSString * _Nonnull)email withPassword:(NSString * _Nonnull)password withConfirmPassword:(NSString * _Nonnull)confirmPassword;

/**
 *  用户登录
 *
 *  @param email                输入正确的邮箱
 *  @param password             输入正确的密码
 *  @param g2fcode              输入Google登录需要的二次验证Code
 *  @param needCode             是否需要Code, 需要设为YES, 反之设为NO
 */
- (void)userLoginWithEmail:(NSString * _Nonnull)email withPassword:(NSString * _Nonnull)password withG2FCode:(NSString * _Nonnull)g2fcode withIsNeedCode:(BOOL)needCode;

/**
 *  用户退出
 */
- (void)userLogout;

/**
 *  用户第三方登录
 *  @param loginThirdName       用户第三方登录平台名称
 */
- (void)userLoginWithThird:(NSString * _Nonnull)loginThirdName;

/**
 *  获取当前所有云盘列表
 */
- (void)getCurrentUserDrive;

/**
 *  登录成功后需要刷新绑定的云盘调用
 */
- (void)refreshCurrentUserDrive;

/**
 *  获取云盘分类
 */
- (void)getDriveCategoryList;

/**
 *  创建云盘对象
 *
 *  @param tmpDict 返回的云盘信息字典
 *
 *  @return YES是之前该云盘已经保存，NO是之前没有保存；
 */
- (BOOL)createDrive:(NSDictionary * _Nonnull)tmpDict;

/**
 *  添加授权指定云服务
 *
 *  @param driveName            云服务名称
 */
- (void)driveAuthorizedWithName:(NSString * _Nonnull)driveName;

/**
 *  取消授权指定云服务
 *
 *  @param drive                云服务对象
 */
- (void)driveCancelAuthorizedWithName:(BaseDrive * _Nonnull)drive;

/**
 *  重命名指定云服务名称
 *
 *  @param drive                云服务对象
 *  @param newName              当前云服务新名称
 */
- (void)driveRenameAuthorizedWithName:(BaseDrive * _Nonnull)drive withNewName:(NSString * _Nonnull)newName;

/**
 *  指定云盘置顶
 *
 *  @param indexdrive           云服务对象
 */
- (void)driveTopIndexWithDrive:(BaseDrive * _Nonnull)indexdrive;

/**
 *  获取保存的云盘句柄
 *
 *  @param driveID 唯一标记
 *
 *  @return 返回云盘句柄
 */
- (BaseDrive * _Nonnull)getSaveDrive:(NSString * _Nonnull)driveID;
@end

@interface LoginAuthorizationDriveEntity : NSObject {
    
    NSString *_avatar;
    NSString *_nickName;
    NSString *_firstName;
    NSString *_lastName;
    NSString *_email;
    NSString *_phone;
    NSString *_country;
    NSString *_region;
    NSString *_city;
    NSString *_language;
    
    int _active;
    int _disable;
}

/** 头像 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull avatar;
/** 昵称 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull nickName;
/** 名字 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull firstName;
/** 姓氏 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull lastName;
/** 邮箱 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull email;
/** 电话 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull phone;
/** 国家 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull country;
/** 地区 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull region;
/** 城市 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull city;
/** 语言 */
@property (nonatomic, readwrite, retain) NSString * _Nonnull language;
/** 是否激活 */
@property (nonatomic, assign) int active;
/** 是否应用 */
@property (nonatomic, assign) int disable;

@end

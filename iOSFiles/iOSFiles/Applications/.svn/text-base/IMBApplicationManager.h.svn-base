//
//  IMBApplicationManager.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-16.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
#import "IMBAppEntity.h"
#import "IMBiPod.h"
#import "IMBCommonEnum.h"
//#import "IMBAppConfig.h"
#import "IMBLogManager.h"
#import "SimpleNode.h"
#import "IMBTransResult.h"
#import "IMBProgressCounter.h"
#import "DriveItem.h"
//这个地方需要声明通知机制，以便于UI接收这些东东。
/*
public delegate void AppProgressMessageHandle(int percentComplete, String status);
//定义事件，本次操作成功
public delegate void InstallSuccessEventHandle(bool param);
// Application cofirm message
public delegate void AppCofirmMessageHandle(String MessID, params object[] parms);
// Application error message
public delegate void AppErrorMessageHandle(String MessID, params object[] parms);
// Application complete message
public delegate void AppCompleteHandle(String MessID, ApplicationMode AppMode, string AppKey, bool IsLastDate, params object[] parms);
// Update sigle step handle
public delegate void UpdateSingleAppStepHandle();
*/
@interface IMBApplicationManager : NSObject <AMInstallationProxyDelegate> {
    IMBiPod *_iPod;
    AMDevice *_device;
//    IMBAppConfig *_appConfig;
    NSNotificationCenter *nc;
    id _listener;
    BOOL _alreadyArchived;
    NSArray *_appEntityArray;
    IMBLogManager *logHandle;
    
//    IMBSoftWareInfo *_softWareInfo;
    IMBResultSingleton *_transResult;
    IMBProgressCounter *_progressCounter;
    BOOL _threadBreak;
    DriveItem *_currentItem;
    id _delegate;
    
    NSMutableArray *_appDoucmentArray;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) DriveItem *currentItem;
@property (nonatomic, retain) NSArray *appEntityArray;
@property (nonatomic, retain) NSMutableArray *appDoucmentArray;

- (id)initWithiPod:(IMBiPod*)iPod;

//设置与删除listener
- (void) setListener:(id)listener;
- (void) removeListener;

//得到当前的所有App数组

- (IMBAppEntity*) appEntityByAppKey:(NSString*)appKey;
//TODO 这里不对，得到App的根目录
- (AFCApplicationDirectory*) appDirectoryByAppKey:(NSString*)appKey;
- (AFCApplicationDirectory*) appDirectoryByDevice:(AMDevice*)device AppKey:(NSString*)appKey;
//PhoneBrowse用，ExportAppFileToPc

- (bool) backupAppTolocal:(DriveItem*)appEntity ArchiveType:(IMBAppTransferTypeEnum)archiveType LocalFilePath:(NSString*)LocalFilePath;

- (bool) backupToDriveAppTolocal:(IMBAppEntity*)appEntity ArchiveType:(IMBAppTransferTypeEnum)archiveType LocalFilePath:(NSString*)LocalFilePath;

- (bool) InstallApplication:(IMBAppTransferTypeEnum)archiveType LocalFilePath:(NSString*)localFilePath;
- (bool) InstallApplication:(IMBAppTransferTypeEnum)archiveType appEntity:(IMBAppEntity *)appEntity ;

- (bool) removeApplication:(IMBAppEntity*)appEntity;

- (bool) installAppBetweenDevice:(IMBAppTransferTypeEnum)archiveType AppEntity:(IMBAppEntity*)srcApp SrciPod:(IMBiPod*)srciPod;

- (IMBAppEntity*) getAppInfoFromLocal:(NSString*)filepath;

- (IMBAppEntity *)getAppInfoAndCopySyncFileToLocal:(NSString*)filepath withAppTempPath:(NSString *)tmpPath;

- (NSArray*) refreshAppEntityArray;

/// A new current operation is beginning.
-(void)operationStarted:(NSDictionary*)info;

/// The current operation is continuing.
-(void)operationContinues:(NSDictionary*)info;

/// The current operation finished (one way or the other)
-(void)operationCompleted:(NSDictionary*)info;
// luo lei add
- (void)loadAppArray;
//此方法 是一次遍历所有的结点
/********************此方法 是一次遍历所有的结点 *******************************/
- (SimpleNode *)getAPPDocument:(AFCApplicationDirectory *)directMediaAccess path:(NSString *)path fileName:(NSString *)fileName;
- (void)exploreAPPDocumentToMac:(NSString *)desPath node:(NSArray *)nodeArr  affApplicationDirectory:(AFCApplicationDirectory *)afcmediaDir;
/********************此方法 是一次遍历所有的结点 *******************************/

/******************此方法只遍历当前结点的一级目录  *******************************/
- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path  appBundle:(NSString *)appBundle;
- (void)exploreAPPDocumentToMac:(NSString *)FolderPath withNodeArray:(NSArray *)nodeArray fileManger:(NSFileManager *)fileManger afcMedia:(AFCApplicationDirectory *)afcMedia;
/******************此方法只遍历当前结点的一级目录  *******************************/

- (NSArray *)getSystemApplication;
- (long long)getAllAppSize;

/**
 *  导出APP文件到电脑
 *
 *  @param folderPath 导出路径
 *  @param node       需要导出的实体
 *  @param afcAppmd   app的句柄
 */
- (void)exportAppDocumentToMac:(NSString *)folderPath withSimpleNode:(DriveItem *)node appAFC:(AFCApplicationDirectory *)afcAppmd;

/**
 *  导如文件到APP
 *
 *  @param localPath    导入的文件路径
 *  @param appDir       app的句柄
 *  @param remotePath   导入的目的路径
 */
- (void)importCopyFromLocal:(DriveItem *)localPath ToApp:(AFCApplicationDirectory*)appDir ToPath:(NSString*)remotePath;

/**
 *  删除APPdoucment文件
 *
 *  @param nodeArray    要删除的file实体数组
 *  @param afcAppmd       app的句柄
 */
- (void)removeAppDoucment:(NSArray *)nodeArray appAFC:(AFCApplicationDirectory *)afcAppmd;

/**
 *  创建APPdoucment文件夹
 *
 *  @param newPath    创建的文件夹全路径
 *  @param afcAppmd       app的句柄
 */
- (BOOL)createAppFolder:(NSString *)newPath appAFC:(AFCApplicationDirectory *)afcAppmd;

/**
 *  删除APPdoucment文件
 *
 *  @param filePath    重命名路径
 *  @param fileName    需要修改成的名字
 *  @param afcAppmd       app的句柄
 */
- (BOOL)rename:(NSString *)filePath withfileName:(NSString *)fileName appAFC:(AFCApplicationDirectory *)afcAppmd;

/**
 *  移动APPdoucment文件
 *
 *  @param oriPath    原始路径
 *  @param desPath    目的路径
 *  @param isFolder   是否是文件夹
 *  @param afcAppmd   app的句柄
 */
- (BOOL)moveFile:(NSString *)oriPath desPath:(NSString *)desPath isFolder:(BOOL)isFolder appAFC:(AFCApplicationDirectory *)afcAppmd;

#pragma mark - 获取APP Doucment
/**
 *  获取安装的APP 文件内容
 */
- (NSArray*)loadAppDoucmentArray;
@end

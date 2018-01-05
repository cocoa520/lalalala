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
}

@property (nonatomic, retain) NSArray *appEntityArray;

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

- (bool) backupAppTolocal:(IMBAppEntity*)appEntity ArchiveType:(IMBAppTransferTypeEnum)archiveType LocalFilePath:(NSString*)LocalFilePath;

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
@end

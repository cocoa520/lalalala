//
//  IMBiPod.h
//  AnyTrans
//
//  Created by iMobie on 7/19/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"

@class IMBDeviceInfo;
@class IMBFileSystem;
@class IMBWifiBackupConfig;
//@class IMBSession;
//@class IMBPlaylistList;
//@class IMBTracklist;
//@class IMBIDGenerator;
//@class IMBArtworkDB;
//@class IMBMusicDatabase;
//@class IMBConfig;
//@class IMBAppConfig;
//@class IMBExportSetting;
//@class IMBPurchasesInfo;
//@class IMBApplicationManager;
@interface IMBiPod : NSObject {
    // 设备操作对象句柄
    AMDevice *_deviceHandle;
    
    //设备的配置文件
//    IMBConfig *_transCodingConfig;
//    IMBAppConfig *_appConfig;
//    IMBExportSetting *_exportSetting;
    IMBWifiBackupConfig *_backupConfig;
    
    //设备操作句柄
    IMBDeviceInfo *_deviceInfo;
    IMBFileSystem *_fileSystem;
//    IMBSession *_session;
    NSString *_uniqueKey;
    
    // 纪录日志的句柄
    IMBLogManager *_logHandle;
    NSString *_mediaDBPath;
    BOOL _mediaDamage;
    BOOL _infoLoadFinished;
    BOOL _beingSynchronized;
    BOOL _isAndroidToiOS;
    
    BOOL _isWifiConnection;
}
@property (nonatomic,assign)BOOL isAndroidToiOS;
@property (nonatomic,assign)BOOL beingSynchronized;
@property (nonatomic,assign)BOOL infoLoadFinished;
@property (nonatomic, retain) NSString *mediaDBPath;
@property (nonatomic, readonly) AMDevice *deviceHandle;
@property (nonatomic, readonly) IMBDeviceInfo *deviceInfo;
@property (nonatomic, readonly) IMBFileSystem *fileSystem;
//@property (nonatomic, readonly) IMBSession *session;
@property (nonatomic, copy) NSString *uniqueKey;
@property (nonatomic,getter = backupConfig,  readonly) IMBWifiBackupConfig *backupConfig;
//@property (nonatomic, getter = appConfig, readonly) IMBAppConfig *appConfig;
//@property (nonatomic, getter = exportSetting, readonly) IMBExportSetting *exportSetting;
@property (nonatomic, assign) BOOL mediaDamage;
@property (nonatomic,assign)BOOL isWifiConnection;
- (id)initWithDevice:(id)device;
/*
- (IMBPlaylistList*)playlists;
- (IMBTracklist*)tracks;
- (NSArray*)getTrackArrayByMediaTypes:(NSArray*)mediaTypes;
- (NSArray*)playlistArray;
- (NSArray*)trackArray;
- (IMBIDGenerator *)idGenerator;
- (IMBArtworkDB *)artworkDB;
- (IMBMusicDatabase *)mediaDatabase;
- (IMBApplicationManager *)applicationManager;
- (void)startSync;
- (void)endSync;
- (void)saveChanges;
- (IMBPurchasesInfo *)purchasesInfo;*/

@end

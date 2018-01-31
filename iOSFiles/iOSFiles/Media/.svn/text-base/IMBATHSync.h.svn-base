//
//  IMBATHSync.h
//  iMobieTrans
//
//  Created by zhang yang on 13-4-9.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IMBiPod.h"
//#import "IMBTrack.h"
//#import "IMBLogManager.h"
#import "IMBCommonEnum.h"
//#import "IMBAthServiceInfo.h"
//@class IMBPhotoEntity;
//@class OperationLImitation;
#define IsNeedAirsyncApp 0

typedef enum SyncState{
    SyncNoneState = 0,
    SyncAllowed,
    ReadyForSync,
    AssetManifest,
    SyncFinished,
    SyncFailed,
    ConnectionInvalid
}SyncState;

typedef enum SyncDeleteCategory{
    SyncDelteNone = 0,
    SyncDelteRingTone,
    SyncDelteBook,
    SyncDeltePhotoLibrary,
    SyncDeltePhotoAlbums,
    SyncDelteVoiceMemo,
    SyncDelteMedia,
}SyncDeleteCategory;


/// An object must implement this protocol if it is to be passed as a listener
///.
//@protocol ATHCopyFileToDeviceListener
//@optional
/////拷贝media所用到方法
//- (BOOL)copyFileFromSrcPath:(NSString*)srcPath ToDesPath:(NSString*)desPath WithTrack:(IMBTrack*)track WithAssetID:(NSString *)assetID;
////拷贝photo所用到方法
//- (BOOL)copyDataFromSrcPath:(NSData *)srcData ToDesPath:(NSString *)desPath WithTrack:(IMBTrack *)track WithAssetID:(NSString *)assetID;
//- (BOOL)copyFileFromSrcPath:(NSString*)srcPath ToDesPath:(NSString*)desPath;
///// copyFile
//- (void)completedCopyTrack:(IMBTrack*)track;
//
////删除数据库时 刷新数据库
//
//@end
//
//@class IMBSyncDataEntiy;
//@interface IMBATHSync : NSObject {
//    OperationLImitation *_limitation;
////    afc_long _threadValue;
//    long long _threadValue;
//    IMBiPod *_srcIpod;
//    IMBiPod *_tarIpod;
//    IMBiPod *_curIpod;
//    NSString * _curAssetID;
//    NSData *_curGrappaData;
//    BOOL _isSyncRingTone;
//    BOOL _isSyncIBook;
//    BOOL _isSyncMedia;
//    BOOL _isSyncVoiceMemo;
//    BOOL _isSyncPhoto;
//    BOOL _isStop;
//    id _listener;
//    //通过消息通知中心返回进度信息
//    NSNotificationCenter *nc;
//    IMBLogManager *logHandle;
//    NSMutableDictionary *_typeDic;
//    //需要进行传输同步的tack对象
//    NSArray * _syncTasks;
//    //需要同步的类型 mediatype
//    NSMutableDictionary *_opeateTypeDic;
//    SyncCtrTypeEnum CtrType;
//    IMBAthServiceInfo *_athServiceInfo;
////    afc_long _msgid;
//    IMBSyncDataEntiy *_syncDataItem;
//    //判断是否是设备间传输
//    BOOL _isBetweenDevice;
//    NSArray *_applicationSyncArr;
//    SyncDeleteCategory _syncDelteCategory;
//    
//    NSDictionary *_grappaDic;
//    NSMutableDictionary *_allAssetDic;
//    SyncState _syncState;
//    NSThread *_currentThread;
//    IMBPhotoEntity *_importPhotoAlbum;
//    NSString *_rename;
//    
//    BOOL _airSyncResult;
//    BOOL _stopWaitairSyncResult;
//    NSConnection *_serverConnection;
//    NSThread *runloopThread;
//    NSArray *_photoAlbums;
//    NSString *_maxUUIDStr;
//}
//@property (nonatomic,assign)NSThread *currentThread;
//@property (nonatomic, readwrite) BOOL isStop;
//@property (nonatomic, retain) NSMutableDictionary * opeateTypeDic;
//@property (nonatomic, retain) NSArray *syncTasks;
//@property (nonatomic, retain) NSArray *delTrackList;
//@property (nonatomic, retain) NSArray *applicationSyncArr;
//@property (nonatomic, retain) NSString *maxUUIDStr;
//
//- (void) setListener:(id<ATHCopyFileToDeviceListener>)listener;
//
//- (id)initWithiPod:(IMBiPod *)iPod syncCtrType:(SyncCtrTypeEnum)ctrType;
//
////单个类型删除时 调用此初始化方法
//- (id)initWithiPod:(IMBiPod *)iPod SyncDeleteCategory:(SyncDeleteCategory)syncDelteCategory;
//- (id)initWithiPod:(IMBiPod *)iPod SyncDeleteCategoryArray:(NSMutableArray *)syncDelteCategoryArray;
//- (id)initWithiPod:(IMBiPod *)iPod syncCtrType:(SyncCtrTypeEnum)ctrType photoAlbum:(IMBPhotoEntity *)photoAlbum Rename:(NSString *)rename;
//
//- (id)initWithiPod:(IMBiPod *)iPod SyncNodes:(NSArray *)syncNodes syncCtrType:(SyncCtrTypeEnum)ctrType photoAlbum:(IMBPhotoEntity *)photoAlbum;
//- (id)initWithiPod:(IMBiPod *)iPod SyncNodes:(NSArray *)syncNodes syncCtrType:(SyncCtrTypeEnum)ctrType photoAlbums:(NSArray *)photoAlbums;
//
//- (id)initWithiPod:(IMBiPod *)srcIpod desIpod:(IMBiPod *)desIpod syncCtrType:(SyncCtrTypeEnum)ctrType SyncNodes:(NSArray *)syncNodes;
//
//- (id)initWithiPod:(IMBiPod *)iPod SyncPhoto:(BOOL)isSyncPhoto syncCtrType:(SyncCtrTypeEnum)ctrType WithCategory:(CategoryNodesEnum)categoryNodes;
//
//
////从readyDic中得到Device的grappaData等，通过webservice去得到cig的数值，然后syncMetaDataFinish
////TODO: //Cig生成不成功的话怎么处理，网络有问题怎么处理
//- (int)sendMetaDataSync:(NSDictionary *)readyDic WithPlistPaths:(NSArray*)paths;
//
////使用非airsync方式同步app;
//- (int)addNoneAirsyncApps:(NSArray *)completeArray;
////device sync file progress
//-(int)sendFileProgressByAssetID:(NSString*) assetID WithType:(NSString*)mediaType Progress:(float)progress;
//
//- (CategoryNodesEnum)getPhotoCategory;
//- (BOOL)checkMediaDBExistInTempPath;
//+ (BOOL)copyMediaDBToTmepPathWithIpod:(IMBiPod *)ipod;
//
//
//
////luolei modify 2016 7 30
///**
// 同步流程:1创建同步服务,开启子线程监听设备返回消息。
// 2 发送请求同步命令
// 3 创建plist和用plist和Grapp生成cig文件
// 4 开始copy数据，将数据copy到指定目录下 发送ATHostConnectionSendAssetCompleted消息
// 5 等待同步结束
// */
//
////重新优化
////创建同步服务,并开启子线程监听设备返回消息
//- (BOOL)createAirSyncService;
////发送请求同步命令
//- (BOOL)sendRequestSync;
////创建plist和cig文件发送数据同步命令
//- (BOOL)createPlistAndCigSendDataSync;
////开始copy数据
//- (void)startCopyData;
////等待同步结束
//- (void)waitSyncFinished;
////停止同步
//- (void)stopAirSync;
//@end

//@interface IMBATHSyncAssetEntity : NSObject {
//    NSString* _assetID;
//    NSString* _assetType;
//}
//@property (nonatomic, readwrite, retain) NSString *assetID;
//@property (nonatomic, readwrite, retain) NSString *assetType;
//
//
//@end

@interface IMBSyncDataEntiy:NSObject{
    NSString *_cigName;
    NSString *_ringtoneName;
    NSString *_voiceMemoName;
    NSString *_bookName;
    NSString *_applicationName;
    NSString *_localTempFolder;
    NSString *_targetMediaPath;
    NSString *_targetCigPath;
    NSString *_sourceMediaPath;
    NSString *_sourceCigPath;
    NSString *_sourcePlistPath;
    NSString *_targetPlistPath;
    NSString *_targetRingtonePath;
    NSString *_sourceRingtonePath;
    NSString *_targetVoiceMemoPath;
    NSString *_sourceVoiceMemoPath;
    NSString *_targetBookPath;
    NSString *_sourceBookPath;
    NSString *_sourceApplicationPath;
    NSString *_targetApplicationPath;
    NSString *_sourceAppIconStatePath;
    NSString *_targetAppIconStatePath;
}

@property (nonatomic,assign) NSString *cigName;
@property (nonatomic,assign) NSString *ringtoneName;
@property (nonatomic,assign) NSString *voiceMemoName;
@property (nonatomic,assign) NSString *bookName;
@property (nonatomic,assign) NSString *applicationName;
@property (nonatomic,assign) NSString *localTempFolder;
@property (nonatomic,assign) NSString *targetMediaPath;
@property (nonatomic,assign) NSString *sourceMediaPath;
@property (nonatomic,assign) NSString *targetCigPath;
@property (nonatomic,assign) NSString *sourceCigPath;
@property (nonatomic,assign) NSString *sourcePlistPath;
@property (nonatomic,assign) NSString *targetPlistPath;
@property (nonatomic,assign) NSString *targetRingtonPath;
@property (nonatomic,assign) NSString *sourceRingtonePath;
@property (nonatomic,assign) NSString *targetVoiceMemoPath;
@property (nonatomic,assign) NSString *sourceVoiceMemoPath;
@property (nonatomic,assign) NSString *targetBookPath;
@property (nonatomic,assign) NSString *sourceBookPath;
@property (nonatomic,assign) NSString *sourceApplicationPath;
@property (nonatomic,assign) NSString *targetApplicationPath;
@property (nonatomic,assign) NSString *sourceAppIconStatePath;
@property (nonatomic,assign) NSString *targetAppIconStatePath;
@end

//@interface IMBParamsAssetEntity : NSObject{
//    NSString *_mediaTypeStr;
//    NSString *_assetID;
//}
//
//@property (nonatomic,assign) NSString *mediaTypeStr;
//@property (nonatomic,assign) NSString *assetID;
//
//@end


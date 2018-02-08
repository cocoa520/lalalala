//
//  IMBBaseCommunicate.h
//  
//
//  Created by ding ming on 17/3/17.
//
//

#import <Foundation/Foundation.h>
#import "IMBCoreAndriodSocket.h"
#import "IMBSocketFactory.h"
#import "IMBFileHelper.h"
#import "GCDAsyncSocket.h"
#import "IMBMediaInfo.h"
#import "IMBCommonEnum.h"
#import "IMBScanEntity.h"
#import "StringHelper.h"
#import "IMBHelper.h"
#import "FMDatabase.h"
#import "IMBLogManager.h"
#import "IMBBaseTransfer.h"
#import "IMBTransferError.h"
typedef enum Operate
{
    IMPORT, //导入
    EXPORT, //导出
    QUERY,  //查询
    DELETE, //删除
    SYNC,   //同步
    THUMBNAIL,//缩略图
    STORAGE,//存储空间
    SHAKEHAND, //握手
    SETSMSAPP,
    CHECKSMSDEFAPP,
    COMPLETE,
    START,
    ATTACHMENT,
    ROOTSTATE,
    SWITCH,
}OperateEnum;

typedef enum CommunicateCategory
{
    RINGTONE,
    AUDIO,
    DEVICE,
    VIDEO,
    IMAGE,
    SMS,
    CALENDAR,
    CALLLOG,
    CONTACT,
    DOUCMENT,
    RequestPermission,
    ScanData,
    RecoveryData,
    LINE,
    APK,
    SETAPKPERMISSION,
}CommunicateCategoryEnum;

static const  NSString *MessageOperationKey = @"MessageOperationKey";
static const  NSString *MessageAttachmentOperationKey = @"MessageAttachmenrOperationKey";
static const  NSString *ContactOperationKey = @"ContactOperationKey";
static const  NSString *CallHistoryOperationKey = @"CallHistoryOperationKey";
static const  NSString *CalendarOperationKey = @"CalendarOperationKey";
static const  NSString *GalleryOperationKey = @"GalleryOperationKey";
static const  NSString *AudioOperationKey = @"AudioOperationKey";
static const  NSString *VideoOperationKey = @"VideoOperationKey";
static const  NSString *AppDocumentsOperationKey = @"AppDocumentsOperationKey";
static const  NSString *AppPhotoOperationKey = @"AppPhotoOperationKey";
static const  NSString *AppVideoOperationKey = @"AppVideoOperationKey";
static const  NSString *AppAudioOperationKey = @"AppAudioOperationKey";
static const  NSString *WhatsAppOperationKey = @"WhatsAppOperationKey";
static const  NSString *WhatsAppAttachmentOperationKey = @"WhatsAppAttachmentOperationKey";
static const  NSString *LineOperationKey = @"LineOperationKey";
static const  NSString *LineAttachmentOperationKey = @"LineAttachmentOperationKey";


@interface IMBBaseCommunicate : NSObject {
    IMBCoreAndriodSocket *_coreSocket;
    int _currCount;
    int _totalCount;
    int _successCount;
    int _failedCount;
    long long _currSize;
    long long _totalSize;
    NSString *_serialNumber;
    
    IMBResultEntity *_reslutEntity;
    IMBResultEntity *_attachReslutEntity;
    id _transDelegate;
    
    NSString *_dbPath;
    FMDatabase *_fmDB;
    NSFileManager *_fileManager;
    BOOL _isStop;//是否停止
    BOOL _isPause;//当弹出对话框的时候暂停
    IMBLogManager *_loghandle;
    NSCondition *_condition;
    
    BOOL _isScanAttachment;
    NSString *_version;
    
    /**
     *  用于跟踪需要
     */
    NSString *_currentRealStopName;
}
@property (nonatomic,retain)NSCondition *condition;
@property (nonatomic, readwrite, retain) IMBResultEntity *reslutEntity;
@property (nonatomic, readwrite, retain) IMBResultEntity *attachReslutEntity;
@property (nonatomic, assign) id<TransferDelegate> transDelegate;
@property (nonatomic, readwrite, retain) NSString *dbPath;
@property (nonatomic,assign)BOOL isStop;
@property (nonatomic,assign)BOOL isPause;
@property (nonatomic, readwrite) BOOL isScanAttachment;
@property (nonatomic, readwrite, retain) NSString *version;

@property (nonatomic, readwrite, retain) NSString *currentRealStopName;

- (id)initWithSerialNumber:(NSString *)serialNumber;
- (NSString *)createParamsjJsonCommand:(CommunicateCategoryEnum)category Operate:(OperateEnum)operate ParamDic:(NSDictionary *)paramDic;
- (void)getLocalFileTotalSize:(NSArray *)array;
#pragma mark - Abstract Method
- (int)queryDetailContent;
- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr;
- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr exportType:(NSString *)type;
- (int)exportMessageAttachment:(NSString *)targetPath exportArray:(NSArray *)exportArray;
- (int)importContent:(NSArray *)importArr;
- (int)deleteContent:(NSArray *)deleteArr;
- (NSString *)getDatabasesPath;
- (BOOL)openDBConnection;
- (void)closeDBConnection;

//请求超时执行方法
- (void)timerAction:(NSTimer *)timer;

//html 用到
- (BOOL)writeToMsgFileWithPageTitle:(NSString*)pageTitle exportPath:(NSString *)exportPath Entity:(id)entity;
@end

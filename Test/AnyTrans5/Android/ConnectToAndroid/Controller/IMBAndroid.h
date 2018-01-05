//
//  IMBAndroid.h
//  
//
//  Created by ding ming on 17/3/28.
//
//

#import <Foundation/Foundation.h>
#import "IMBADAudio.h"
#import "IMBADVideo.h"
#import "IMBADGallery.h"
#import "IMBADCallHistory.h"
#import "IMBADCalendar.h"
#import "IMBADContact.h"
#import "IMBADDevice.h"
#import "DeviceInfo.h"
#import "IMBADDoucment.h"
#import "IMBADMessage.h"
#import "IMBADPermisson.h"
#import "IMBLogManager.h"
#import "IMBADRingtone.h"
@class IMBExportConfig;

#if Android_Google
    #define SMS_PATH @"/data/data/com.google.android.apps.messaging/databases/bugle_db"   //短信
    #define CALLLOGS_PATH @"/data/data/com.android.providers.contacts/databases/calllog.db"  //通话记录
#else
    #define SMS_PATH @"/data/data/com.android.providers.telephony/databases/mmssms.db"   //短信
    #define CALLLOGS_PATH @"/data/data/com.android.providers.contacts/databases/contacts2.db"  //通话记录
#endif

#define SMS_JOURNAL_PATH @"/data/data/com.android.providers.telephony/databases/mmssms.db-journal"   //短信日志文件 google--/data/data/com.google.android.apps.messaging/databases/bugle_db-journal
#define CONTACT_PATH @"/data/data/com.android.providers.contacts/databases/contacts2.db"  //联系人
#define CALENDER_PATH @"/data/data/com.android.providers.calendar/databases/calendar.db"  //日历
#define WHATSAPP_PATH @"/data/data/com.whatsapp/databases/msgstore.db"  //WHATSAPP
#define WHATSAPP_WA_PATH @"/data/data/com.whatsapp/databases/wa.db"  //WHATSAPP CONTACT
#define LINE_PATH @"/data/data/jp.naver.line.android/databases/naver_line"  //LINE


@interface IMBAndroid : NSObject {
    IMBADVideo *_adVideo;
    IMBADAudio *_adAudio;
    IMBADGallery *_adGallery;
    IMBADCallHistory *_adCallHistory;
    IMBADCalendar *_adCalendar;
    IMBADContact *_adContact;
    IMBADDevice *_adDevice;
    DeviceInfo *_deviceInfo;
    IMBADDoucment *_adDoucment;
    IMBADMessage *_adSMS;
    IMBADPermisson *_adPermisson;
    IMBADRingtone *_adRingtone;
    
    CategoryNodesEnum _category;
    
    NSString *_rootHandle;//root句柄
    NSString *_currentRealStop;
    
    BOOL _isSuccess;
    BOOL _selfStop;
    IMBExportConfig *_exportSetting;
    NSCondition *_condition;
    IMBLogManager *_logManager;
}

@property (nonatomic, readwrite) CategoryNodesEnum category;
@property (nonatomic, retain) IMBADVideo *adVideo;
@property (nonatomic, retain) IMBADAudio *adAudio;
@property (nonatomic, retain) IMBADGallery *adGallery;
@property (nonatomic, retain) IMBADCallHistory *adCallHistory;
@property (nonatomic, retain) IMBADCalendar *adCalendar;
@property (nonatomic, retain) IMBADContact *adContact;
@property (nonatomic, retain) IMBADDevice *adDevice;
@property (nonatomic, retain) IMBADRingtone *adRingtone;
@property (nonatomic, retain) DeviceInfo *deviceInfo;
@property (nonatomic, retain) IMBADDoucment *adDoucment;
@property (nonatomic, retain) IMBADMessage *adSMS;
@property (nonatomic, retain) IMBADPermisson *adPermisson;
@property (nonatomic, retain) NSString *rootHandle;
@property (nonatomic, readwrite, retain) NSString *currentRealStop;
@property (nonatomic, retain) IMBExportConfig *exportSetting;
@property (nonatomic, assign) BOOL selfStop;


- (id)initWithDeviceInfo:(DeviceInfo *)deviceInfo;
#pragma mark - 查询方法
- (int)queryDeviceDetailInfo;

- (int)queryAudioDetailInfo;

- (int)queryVideoDetailInfo;

- (int)queryGalleryDetailInfo;

//加载图片缩略图
- (BOOL)loadThumbnaiImage:(IMBADPhotoEntity *)photoEntity;
- (BOOL)loadThumbnaiImageWithApp:(IMBADPhotoEntity *)appPhotoEntity;

- (int)queryCallHistoryDetailInfo;

- (int)queryCalendarDetailInfo;

- (int)queryContactDetailInfo;

- (int)queryDoucmentDetailInfo;

- (int)querySMSDetailInfo;

- (int)queryRingtoneDetailInfo;

- (IMBResultEntity *)getAudioContent;

- (IMBResultEntity *)getVideoContent;

- (IMBResultEntity *)getGalleryContent;

- (IMBResultEntity *)getCallHistoryContent;

- (IMBResultEntity *)getCalendarContent;

- (IMBResultEntity *)getContactContent;

- (IMBResultEntity *)getAppDoucmentContent;

- (IMBResultEntity *)getiBooksContent;

- (IMBResultEntity *)getCompressedContent;

- (IMBResultEntity *)getAppPhotoContent;

- (IMBResultEntity *)getAppVideoContent;

- (IMBResultEntity *)getAppAudioContent;

- (IMBResultEntity *)getSMSContent;

- (IMBResultEntity *)getSMSAttachmentContent;

- (IMBResultEntity *)getRingtoneContent;

#pragma mark - 导出方法
- (int)exportAudioContent:(NSString *)path ContentList:(NSArray *)exportArray;

- (int)exportVideoContent:(NSString *)path ContentList:(NSArray *)exportArray;

- (int)exportGalleryContent:(NSString *)path ContentList:(NSArray *)exportArray;

- (int)exportCallHistoryContent:(NSString *)path ContentList:(NSArray *)exportArray;

- (int)exportCalendarContent:(NSString *)path ContentList:(NSArray *)exportArray;

- (int)exportContactContent:(NSString *)path ContentList:(NSArray *)exportArray;

- (int)exportDoucmentContent:(NSString *)path ContentList:(NSArray *)exportArray;

- (int)exportSMSContent:(NSString *)path ContentList:(NSArray *)exportArray;

- (int)exportMMSAttachment:(NSString *)targetPath exportArray:(NSArray *)exportArray;

- (int)exportRingtoneContent:(NSString *)path ContentList:(NSArray *)exportArray;

#pragma marl - 导入方法
- (int)importAudioContent:(NSArray *)contentArray;

- (int)importVideoContent:(NSArray *)contentArray;

- (int)importGalleryContent:(NSArray *)contentArray;

- (int)importCallHistoryContent:(NSArray *)contentArray;

- (int)importCalendarContent:(NSArray *)contentArray;

- (int)importContactContent:(NSArray *)contentArray;

- (int)importDoucmentContent:(NSArray *)contentArray;

- (int)importSMSContent:(NSArray *)contentArray;

#pragma mark - 删除方法
- (int)deleteAudioContent:(NSArray *)contentArray;

- (int)deleteVideoContent:(NSArray *)contentArray;

- (int)deleteGalleryContent:(NSArray *)contentArray;

- (int)deleteCallHistoryContent:(NSArray *)contentArray;

- (int)deleteCalendarContent:(NSArray *)contentArray;

- (int)deleteContactContent:(NSArray *)contentArray;

- (int)deleteDoucmentContent:(NSArray *)contentArray;

- (int)deleteSMSContent:(NSArray *)contentArray;

#pragma mark - 授予设备权限
- (BOOL)checkDevicePermisson;

- (void)sendAction:(NSString *)switchView ResultText:(int)resultCount TargetWord:(NSString *)target;

#pragma mark - 检查是否设备root
- (BOOL)checkDeviceIsRoot;

#pragma mark - 扫描前的分析,确认是否扫描数据库的删除数据
- (void)parseDevice:(NSArray *)array;
#pragma mark - stop pause
- (void)setIsStop:(BOOL)isStop;
- (void)setIsPause:(BOOL)isPause;

#pragma mark - 判断当前停止的选择项
- (BOOL)checkStopSelectItem;
- (BOOL)checkIsInstallApk:(NSString *)serialNo;
- (BOOL)installAPK:(NSString *)serialNumber;

@end

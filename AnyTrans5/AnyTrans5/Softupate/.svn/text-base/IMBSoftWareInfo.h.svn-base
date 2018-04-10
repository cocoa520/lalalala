//
//  IMBSoftWareInfo.h
//  iMobieTrans
//
//  Created by zhang yang on 13-6-23.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
#import "IMBVerifyProduct.h"
#import "IMBUpdateInfo.h"
#define Limit_Count_Used @"Limit Count Used"
#define Limit_Day_Count_Used @"Limit Day Count Used"

#define Count_Limit_Type @"countlimit"
#define Time_Limit_Type @"timelimit"

#define Limit_Day_Key @"limitDay"
#define Limit_Count_Key @"itemCount"

//3QHT-89VE-FUM1-DWXU
//5N7P-66BT-WDHQ-U3HE
//7GXS-NL4Y-BJMM-R5CQ
typedef enum ActivateStatus {
    Activate_OnLine = 1000,
    Activate_Local = 2000,
    Activate_Temporary = 3000,
    Activate_NO = 4000,
    Activate_Error = 5000,
    Activate_Replace_Error = 6000,
} ActivateStatusEnum;
typedef enum
{
    IMBTransfer_Import = 1,
    IMBTransfer_Export = 2,
    IMBTransfer_ToDevice = 3
} IMBTransferType;

@interface IMBSoftWareInfo : NSObject {
    BOOL _isFirstRun;
    NSDate *_firstRunDateTime;
    NSDate *_firstRunDate;
    NSString *_productName;
    NSString *_resProductName;
    NSString *_version;
    NSString *_newversion;
    NSString *_buildDate;
    BOOL _isNeedRegister;
    BOOL _isRegistered;
    NSString *_registerphone;
    NSString *_registerpod;
    NSString *_registeredCode;
    NSString *_registeredDate;
    NSString *_iwizardToMacFolder;
    
    NSString *_privateKey;
    IMBProductLimitType _productLimitType;
    NSString *_limitType;
    int _limitItemCount;
    int _limitDay;
    int _limitItemCountUsedCount;
    NSMutableDictionary *_limitDayUsedCountDic;
    NSMutableArray *_serverArray;
    NSString *_serverKey;
    BOOL isEditRegFile;
    
    //其他信息暂时不用
    BOOL _isSupportApp;
    BOOL _isSupportIOS;
    BOOL _isSupportIPod;
    BOOL _isSupportJailbreak;
    BOOL _isSupportMedia;
    BOOL _isSupportWifi;
    BOOL _isSupportMultiDevice;
    BOOL _isSupportiTunesLib;
    BOOL _isSupportConverter;
    NSString* _iTunesSupportMaxVersion;
    NSString* _iTunesSupportMinVersion;
    NSString* _iosSupportMaxVersion;
    
    NSMutableArray* _registerCodeArray;
    NSMutableArray* _registerPhoneCodeArray;
    NSMutableArray* _registerPodCodeArray;
    BOOL _mustUpdate;
    NSString *_mustUpdateVersion;
    NSString *_mustUpdateBuild;
    NSString *_mustUpdateURL;
    NSString *_skipedVersion;           //是否是跳过的版本号
    
    IMBVerifyProduct *_verifyLicense;
    
    LanguageTypeEnum _chooseLanguageType;
    NSString *_iTunesVersion;
    BOOL _isCopySyncPlistFile;
    
    NSString *_domainNetwork;
    NSDate *_activitylimiteDate;  //活动结束时间
    NSString *_activityURL;
    BOOL _isFamily;
    NSString *_activationCode;
    ActivateStatusEnum _RegisteredStatus;
    int _verificationCount;
    
    NSString *_rigisterErrorCode;
    
    NSString *_curUseSkin;
    NSString *_systemDateFormatter;
    NSMutableArray *_deviceArray;
    
    BOOL _isIllegal;
    
    BOOL _isIronsrc;//合作伙伴的定制版
    
    IMBActivityInfo *_activityInfo;//结果页面显示信息;
    BOOL _isLoadGuideView;
    
    BOOL _isNOAdvertisement;//anytrans6.0没有广告的版本;
    NSString *_iosMoverDiscountUrl;//ios mover折扣链接;
    
    BOOL _isNoYouToBePhoto;//不包含YouTube图片的版本;
    BOOL _isKeepPhotoDate;
    BOOL _isStartUpAirBackup;
    NSString *_selectModular;
    
    int _buyId;
    NSString *_discount;
    BOOL _isOpenAnnoy;
}
@property (nonatomic, readwrite) BOOL isKeepPhotoDate;
@property (nonatomic, readwrite) BOOL isNoYouToBePhoto;
@property (nonatomic, readwrite) BOOL isLoadGuideView;
@property (nonatomic, readwrite) BOOL isIronsrc;
@property (nonatomic, readwrite, retain) IMBVerifyProduct *verifyLicense;
@property (assign) ActivateStatusEnum RegisteredStatus;
@property (nonatomic, assign) BOOL isFamily;
@property (nonatomic, readwrite) BOOL isCopySyncPlistFile;
@property (nonatomic,retain)NSString *domainNetwork;
@property (nonatomic, readwrite) BOOL isFirstRun;
@property (nonatomic, readwrite, retain) NSDate *firstRunDateTime;
@property (nonatomic, readwrite, retain) NSDate *firstRunDate;
@property (readonly,retain) NSString* productName;
@property (nonatomic, readwrite, retain) NSString *resProductName;
@property (readonly,retain) NSString* version;
@property (nonatomic,retain) NSString* newversion;
@property (readonly,retain) NSString* buildDate;
@property (readonly) NSString* ProductNameVersionBuildDateString;
@property (nonatomic,retain)NSString *activityURL;
@property (readonly) BOOL isNeedRegister;
@property (assign) BOOL isRegistered;
@property (assign) BOOL mustUpdate;
@property (nonatomic, readwrite, retain) NSString *activationCode;
@property (nonatomic, readwrite, retain) NSString *mustUpdateVersion;
@property (nonatomic, readwrite, retain) NSString *mustUpdateBuild;
@property (nonatomic, readwrite, retain) NSString *mustUpdateURL;
@property (nonatomic, readwrite, retain) NSString *skipedVersion;
@property (nonatomic,retain) NSString* registeredCode;
@property (nonatomic,retain) NSString* registeredDate;
@property (retain) NSString* iwizardToMacFolder;
@property (nonatomic, readwrite) int verificationCount;
@property (nonatomic, readwrite, retain) NSString *privateKey;
@property (nonatomic, readwrite) IMBProductLimitType productLimitType;
@property (nonatomic, readwrite, retain) NSString *limitType;
@property (nonatomic, readwrite) int limitItemCount;
@property (nonatomic, readwrite) int limitDay;
@property (nonatomic, readwrite, retain) NSMutableArray *serverArray;
@property (nonatomic, readwrite, retain) NSString *serverKey;
@property (nonatomic, readwrite, retain) NSDate *activitylimiteDate;
@property (assign) BOOL isSupportApp;
@property (assign) BOOL isSupportIOS;
@property (assign) BOOL isSupportIPod;
@property (assign) BOOL isSupportJailbreak;
@property (assign) BOOL isSupportMedia;
@property (assign) BOOL isSupportWifi;
@property (assign) BOOL isSupportMultiDevice;
@property (assign) BOOL isSupportiTunesLib;
@property (assign) BOOL isSupportConverter;
@property (assign) BOOL isIllegal;
@property (nonatomic, readwrite) LanguageTypeEnum chooseLanguageType;
@property (readwrite, retain) NSString* iTunesVersion;
@property (readwrite, retain) NSString *rigisterErrorCode;
@property (nonatomic ,readwrite, retain) NSString *curUseSkin;
@property (nonatomic, readwrite, retain) NSString *systemDateFormatter;
@property (nonatomic, readwrite, retain) NSMutableArray *deviceArray;
@property (nonatomic, readwrite, retain) IMBActivityInfo *activityInfo;
@property (nonatomic, readwrite) BOOL isNOAdvertisement;
@property (nonatomic, readwrite, retain) NSString *iosMoverDiscountUrl;
@property (nonatomic, readwrite) BOOL isStartUpAirBackup;
@property (nonatomic, readwrite, retain) NSString *selectModular;
@property (nonatomic, readwrite, assign) int buyId;
@property (nonatomic, readwrite, retain) NSString *discount;
@property (nonatomic, readwrite) BOOL isOpenAnnoy;


+ (IMBSoftWareInfo*) singleton;
- (BOOL) registerSoftware:(NSString*)registerCode;
- (void) save;
- (void)saveIosMoverUrl;
- (BOOL)checkProductExpired:(int*)remainDay;
- (int)getRemainItemCount;
- (NSString*)getCurrentDateTime;
- (NSString*)getCurrentDate;
- (void)addLimitCount:(int)addCount;
- (NSString*) getProductTitle;
+ (NSString *)isaddMosaicTextStr:(NSString *)text;
- (Boolean) checkMustUpdate;
- (NSString*) defaultLanguage;
- (NSString*) ProductNameVersionBuildDateString;
@end

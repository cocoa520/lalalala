//
//  IMBAppEntity.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-16.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
#import "IMBBaseEntity.h"
typedef enum
{
    AppUIDeivceFamily_iPad = 1,
    AppUIDeivceFamily_iPhone = 2,
    AppUIDeviceFamily_All = 9
}  IMBAppUIDeviceFamily;


@interface IMBAppEntity : IMBBaseEntity {
    NSString *_appName;
    NSString *_appStoreID;
    long long _appSize;
    long long _documentSize;
    NSImage *_appIconImage;
    //App bundle ID
    NSString *_appKey;
    NSString *_version;
    NSString *_minimunOSVerison;
    //这个地方需要读取平台的版本号吗
    NSString *_dtplatformName;
    //
    NSString *_purchaseDate;
    NSString *_copyright;
    //用来看是否支持iPhone或者iPad等设备
    //app在本地的路径
    NSString *_srcFilePath;
    IMBAppUIDeviceFamily _uiDeviceFamily;
    
    NSMutableArray *_groupArray;
    NSIndexSet *set;
    NSString *_currentDevicePath;
    NSAttributedString *_appNameAs;
}

@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appStoreID;
@property (nonatomic, assign) long long appSize;
@property (nonatomic, assign) long long documentSize;
@property (nonatomic, retain) NSImage *appIconImage;

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *minimunOSVerison;
@property (nonatomic, copy) NSString *dtplatformName;
@property (nonatomic, copy) NSString *purchaseDate;
@property (nonatomic, copy) NSString *copyright;
@property (nonatomic, copy) NSString *srcFilePath;
@property (nonatomic, assign) IMBAppUIDeviceFamily uiDeviceFamily;
@property (nonatomic, copy) NSMutableArray *groupArray;
@property (nonatomic, copy) NSIndexSet *set;
@property (nonatomic, retain) NSString *currentDevicePath;
@property (nonatomic, retain) NSAttributedString *appNameAs;
- (void)setAppNameAttributedString;
@end

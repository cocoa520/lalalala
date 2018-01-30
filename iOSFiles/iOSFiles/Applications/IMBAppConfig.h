//
//  IMBAppConfig.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-16.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
#import "IMBiPod.h"

#define AppConfigName @"iMobieAppConfig.plist"
#define AppDeviceConfigPath @"iMobieConfig"
@interface IMBAppConfig : NSObject {
    IMBiPod *_ipod;
    NSString *_configDevicePath;
    NSString *_configLocalPath;
    IMBAppTransferTypeEnum _appExportToiTunesType;
    IMBAppTransferTypeEnum _appExportToMacType;
    IMBAppTransferTypeEnum _appExportToDeviceType;
    bool _isAppImportJustData;
    bool _isAppUpgrade;
    bool _isAppDowngrade;
}

@property (nonatomic, assign) IMBAppTransferTypeEnum appExportToiTunesType;
@property (nonatomic, assign) IMBAppTransferTypeEnum appExportToMacType;
@property (nonatomic, assign) IMBAppTransferTypeEnum appExportToDeviceType;
@property (nonatomic, assign) bool isAppImportJustData;
@property (nonatomic, assign) bool isAppUpgrade;
@property (nonatomic, assign) bool isAppDowngrade;


- (id)initWithIPod:(IMBiPod*)iPod;
- (void) saveToDevice;
- (void) createConfigFile:(IMBAppTransferTypeEnum) exToiTunes ExToMac:(IMBAppTransferTypeEnum)exToMac ExToDevice:(IMBAppTransferTypeEnum)exToDevice IsImportJustData:(bool)isImportJustData IsUpgrade:(bool)isUpgrade IsDowngrade:(bool)isDowngrade;


@end

//
//  IMBExportSetting.h
//  iMobieTrans
//
//  Created by iMobie on 7/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"

#define DeviceConfigPath @"iMobieConfig"
#define ExportConfigName @"exportSetting.plist"

@interface IMBExportSetting : NSObject {
    IMBiPod *_ipod;
    NSString *_configDevicePath;
    NSString *_configLocalPath;
    NSFileManager *fm;
    //导出格式
    NSString *_callHistoryType;
    NSString *_contactType;
    NSString *_messageType;
    NSString *_calenderType;
    NSString *_safariType;
    NSString *_notesType;
    NSString *_safariHistoryType;
    NSString *_reminderType;
    //导出路径
    NSString *_exportPath;
    NSString *_backupPath;
    
    //livePhoto
    NSString *_livePhotoType;
    //导出设置
    BOOL _isCreateFolder;
    BOOL _isOpenFolder;
    BOOL _isCreadPhotoDate;
    //备份设置
    int _maxBackupCount;
}
@property (nonatomic, assign) BOOL isCreadPhotoDate;
@property (nonatomic, readwrite, retain) NSString *livePhotoType;
@property (nonatomic, readwrite, retain) NSString *callHistoryType;
@property (nonatomic, readwrite, retain) NSString *contactType;
@property (nonatomic, readwrite, retain) NSString *messageType;
@property (nonatomic, readwrite, retain) NSString *calenderType;
@property (nonatomic, readwrite, retain) NSString *safariType;
@property (nonatomic, readwrite, retain) NSString *notesType;
@property (nonatomic, readwrite, retain) NSString *reminderType;
@property (nonatomic, readwrite, retain) NSString *safariHistoryType;
@property (nonatomic, readwrite, retain) NSString *exportPath;
@property (nonatomic, readwrite, retain) NSString *backupPath;
@property (nonatomic, readwrite) BOOL isCreateFolder;
@property (nonatomic, readwrite) BOOL isOpenFolder;
@property (nonatomic, readwrite) int maxBackupCount;;
- (void)readDictionary;
- (id)initWithIPod:(IMBiPod*)iPod;
- (void) saveToDeviceOrLocal;
- (NSString*)getExportExtension:(NSString*)exportType;

@end

//
//  IMBExportConfig.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EXPORT_CALLHISTORY_CATEGORY @"Call History"
#define EXPORT_MESSAGE_CATEGORY @"Message"
#define EXPORT_CONTACT_CATEGORY @"Contact"
#define EXPORT_CALENDAR_CATEGORY @"Calendar"
#define EXPORT_WHATSAPP_CATEGORY @"WhatsApp"
#define EXPORT_LINE_CATEGORY @"Line"
#define EXPORT_LOCAL_PATH @"exportLocalPath"
#define EXPORT_BACKUPPATH_CATEGORY @"BackUpPath"

@interface IMBExportConfig : NSObject
{
    @private
    NSString *_settingFilePath;
    NSMutableDictionary *_settingDic;
    NSFileManager *fm;

    NSNotificationCenter *nc;
}

@property (nonatomic, readwrite, retain) NSMutableDictionary *settingDic;

+ (IMBExportConfig*)singleton;

- (NSString*)getExportExtension:(NSString*)exportType;
- (NSString*)getExportFolderPath;
- (NSString*)getBackUpPath;
//shuaimingzhong add 2017.5.15
- (BOOL)getGuideIsOpen;

- (void)saveExportSetting;
@end

//
//  IMBExportConfig.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBExportConfig.h"
#import "IMBHelper.h"
#import "IMBNotificationDefine.h"

@implementation IMBExportConfig

@synthesize settingDic = _settingDic;

- (id)init {
    self = [super init];
    if (self) {
        nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
        fm = [NSFileManager defaultManager];
        _settingFilePath = [[[self getConfigFolderPath] stringByAppendingPathComponent:@"export_format_setting.plist"] retain];
        if ([fm fileExistsAtPath:_settingFilePath]) {
            _settingDic = [[NSMutableDictionary dictionaryWithContentsOfFile:_settingFilePath] retain];
        } else {
            _settingDic = [[NSMutableDictionary alloc] init];
        }
        [self initConfig];
    }
    return self;
}

- (void)applicationWillTerminate:(NSNotification*)notification {
    [self dealloc];
}

+ (IMBExportConfig*)singleton {
    static IMBExportConfig *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBExportConfig alloc] init];
		}
	}
	return _singleton;
}

- (void)dealloc {
    if (nc != nil) {
        [nc removeObserver:self];
        nc = nil;
    }
    if (_settingFilePath != nil) {
        [_settingFilePath release];
        _settingFilePath = nil;
    }
    if (_settingDic != nil) {
        [_settingDic release];
        _settingDic = nil;
    }
    [super dealloc];
}

- (void)initConfig {
    BOOL isNeedSave = NO;
    if (_settingDic != nil && _settingDic.allKeys.count > 0) {
        NSArray *allkeys = _settingDic.allKeys;
        if (![allkeys containsObject:EXPORT_CALLHISTORY_CATEGORY]) {
            [_settingDic setObject:@".html" forKey:EXPORT_CALLHISTORY_CATEGORY];
            isNeedSave = YES;
        }
        
        if (![allkeys containsObject:EXPORT_MESSAGE_CATEGORY]) {
            [_settingDic setObject:@".html" forKey:EXPORT_MESSAGE_CATEGORY];
            isNeedSave = YES;
        }
        
        if (![allkeys containsObject:EXPORT_CONTACT_CATEGORY]) {
            [_settingDic setObject:@".vcf" forKey:EXPORT_CONTACT_CATEGORY];
            isNeedSave = YES;
        }
        
        if (![allkeys containsObject:EXPORT_CALENDAR_CATEGORY]) {
            [_settingDic setObject:@".csv" forKey:EXPORT_CALENDAR_CATEGORY];
            isNeedSave = YES;
        }
        
        
        if (![allkeys containsObject:EXPORT_WHATSAPP_CATEGORY]) {
            [_settingDic setObject:@".html" forKey:EXPORT_WHATSAPP_CATEGORY];
            isNeedSave = YES;
        }
        
        if (![allkeys containsObject:EXPORT_LINE_CATEGORY]) {
            [_settingDic setObject:@".html" forKey:EXPORT_LINE_CATEGORY];
            isNeedSave = YES;
        }

        if (![allkeys containsObject:EXPORT_LOCAL_PATH]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *exportFolderPath = [paths objectAtIndex:0];
            [_settingDic setObject:exportFolderPath forKey:EXPORT_LOCAL_PATH];
            isNeedSave = YES;
        }
        if (![allkeys containsObject:GUID_VIEW_ISOPEN]) {
            [_settingDic setObject:[NSNumber numberWithBool:YES] forKey:GUID_VIEW_ISOPEN];
            isNeedSave = YES;
        }

    } else {
        [_settingDic setObject:@".html" forKey:EXPORT_CALLHISTORY_CATEGORY];
        [_settingDic setObject:@".html" forKey:EXPORT_MESSAGE_CATEGORY];
        [_settingDic setObject:@".vcf" forKey:EXPORT_CONTACT_CATEGORY];
        [_settingDic setObject:@".csv" forKey:EXPORT_CALENDAR_CATEGORY];

        [_settingDic setObject:@".html" forKey:EXPORT_WHATSAPP_CATEGORY];
        [_settingDic setObject:@".html" forKey:EXPORT_LINE_CATEGORY];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *exportFolderPath = [paths objectAtIndex:0];

        [_settingDic setObject:exportFolderPath forKey:EXPORT_LOCAL_PATH];
        [_settingDic setObject:[NSNumber numberWithBool:YES] forKey:GUID_VIEW_ISOPEN];
        isNeedSave = YES;
    }
    if (isNeedSave) {
        [self saveExportSetting];
    }
}

- (NSString*)getExportExtension:(NSString*)exportType {
    NSString *retVal = nil;
    if (_settingDic != nil && _settingDic.allKeys.count > 0) {
        NSArray *allkeys = _settingDic.allKeys;
        if ([allkeys containsObject:exportType]) {
            retVal = [_settingDic objectForKey:exportType];
            if ([retVal isEqualToString:@".text"]) {
                retVal = @"txt";
            } else if ([retVal isEqualToString:@".csv"]) {
                retVal = @"csv";
            } else if ([retVal isEqualToString:@".html"]) {
                retVal = @"html";
            } else if ([retVal isEqualToString:@".vcf"]) {
                retVal = @"vcf";
            } else {
                retVal = @"txt";
            }
        } else {
            retVal = @"txt";
        }
    }
    return retVal;
}

- (NSString*)getBackUpPath {
    NSString *retVal = nil;
    if (_settingDic != nil && _settingDic.allKeys.count > 0) {
        NSArray *allkeys = _settingDic.allKeys;
        if ([allkeys containsObject:EXPORT_BACKUPPATH_CATEGORY]) {
            retVal = [_settingDic objectForKey:EXPORT_BACKUPPATH_CATEGORY];
        }
    }
//    if ([IMBHelper stringIsNilOrEmpty:retVal]) {
//        retVal = [IMBHelper getDeviceBackupFolder];
//    }
    return retVal;
}

- (NSString*)getExportFolderPath {
    NSString *retVal = nil;
    if (_settingDic != nil && _settingDic.allKeys.count > 0) {
        NSArray *allkeys = _settingDic.allKeys;
        if ([allkeys containsObject:EXPORT_LOCAL_PATH]) {
            retVal = [_settingDic objectForKey:EXPORT_LOCAL_PATH];
        }
    }
    if ([IMBHelper stringIsNilOrEmpty:retVal]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        retVal = [paths objectAtIndex:0];
    }
    return retVal;
}

- (void)saveExportSetting {
    if ([fm fileExistsAtPath:_settingFilePath]) {
        [fm removeItemAtPath:_settingFilePath error:nil];
    }
    [_settingDic writeToFile:_settingFilePath atomically:YES];
}

- (NSString*)getConfigFolderPath {
    NSString *configFolderPath = [[IMBHelper getAppSupportPath] stringByAppendingPathComponent:@"iMobieConfig"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:configFolderPath isDirectory:&isDir]) {
        if (!isDir) {
            [fileManager removeItemAtPath:configFolderPath error:nil];
            [fileManager createDirectoryAtPath:configFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [fileManager createDirectoryAtPath:configFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return configFolderPath;
}

- (BOOL)getGuideIsOpen {
    BOOL retVal = NO;
    if (_settingDic != nil && _settingDic.allKeys.count > 0) {
        NSArray *allkeys = _settingDic.allKeys;
        if ([allkeys containsObject:GUID_VIEW_ISOPEN]) {
            retVal = [[_settingDic objectForKey:GUID_VIEW_ISOPEN] boolValue];
        }
    }
    return retVal;
}

@end

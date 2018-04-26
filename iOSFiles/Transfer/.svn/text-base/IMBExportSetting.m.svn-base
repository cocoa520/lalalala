//
//  IMBExportSetting.m
//  iMobieTrans
//
//  Created by iMobie on 7/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBExportSetting.h"
#import "IMBFileSystem.h"
#import "IMBSession.h"
#import "TempHelper.h"
#import "StringHelper.h"
#import "IMBHelper.h"

@implementation IMBExportSetting
@synthesize calenderType = _calenderType;
@synthesize callHistoryType = _callHistoryType;
@synthesize contactType = _contactType;
@synthesize messageType = _messageType;
@synthesize safariType = _safariType;
@synthesize reminderType = _reminderType;
@synthesize notesType = _notesType;
@synthesize exportPath = _exportPath;
@synthesize isCreateFolder = _isCreateFolder;
@synthesize isOpenFolder = _isOpenFolder;
@synthesize maxBackupCount = _maxBackupCount;
@synthesize safariHistoryType = _safariHistoryType;
@synthesize backupPath = _backupPath;
@synthesize livePhotoType = _livePhotoType;
@synthesize isCreadPhotoDate = _isCreadPhotoDate;
- (id)initWithIPod:(IMBiPod*)iPod {
    self = [super init];
    if (self) {
        _ipod = iPod;
        _safariHistoryType = @".html";
        _callHistoryType = @".html";
        _messageType = @".html";
        _safariType = @".html";
        _contactType = @".vcf";
        _calenderType = @".csv";
        _reminderType = @".csv";
        _notesType = @".html";
        _livePhotoType = @"mov";
        _isCreadPhotoDate = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _exportPath = [[paths objectAtIndex:0] retain];
        _backupPath = [[TempHelper getBackupFolderPath] retain];
        _isOpenFolder = YES;
        _isCreateFolder = YES;
        _maxBackupCount = 2;
        fm = [NSFileManager defaultManager];
        if (_ipod != nil) {
            _configDevicePath = [iPod.fileSystem.iPodControlPath stringByAppendingPathComponent:DeviceConfigPath];
            if (![_ipod.fileSystem fileExistsAtPath:_configDevicePath]) {
                [_ipod.fileSystem mkDir:_configDevicePath];
            }
            _configDevicePath = [[_configDevicePath stringByAppendingPathComponent :ExportConfigName] retain];
            _configLocalPath = [_ipod.session.sessionFolderPath stringByAppendingPathComponent:DeviceConfigPath];
            if (![fm fileExistsAtPath:_configLocalPath]) {
                [fm createDirectoryAtPath:_configLocalPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            _configLocalPath = [[_configLocalPath stringByAppendingPathComponent:ExportConfigName] retain];
            [self parseConfigFile];
        } else {
            _configLocalPath = [[TempHelper getAppSupportPath] stringByAppendingPathComponent:DeviceConfigPath];
            if (![fm fileExistsAtPath:_configLocalPath]) {
                [fm createDirectoryAtPath:_configLocalPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            _configLocalPath = [[_configLocalPath stringByAppendingPathComponent:ExportConfigName] retain];
            [self parseLocalConfigFile];
        }
    }
    return self;
}

- (void)dealloc {
    if (_configDevicePath != nil) {
        [_configDevicePath release];
        _configDevicePath = nil;
    }
    if (_configLocalPath != nil) {
        [_configLocalPath release];
        _configLocalPath = nil;
    }
    if (_exportPath != nil) {
        [_exportPath release];
        _exportPath = nil;
    }
    if (_backupPath != nil) {
        [_backupPath release];
        _backupPath = nil;
    }
    [super dealloc];
}
             
- (void)parseConfigFile {
    if ([_ipod.fileSystem fileExistsAtPath:_configDevicePath]) {
        [_ipod.fileSystem copyRemoteFile:_configDevicePath toLocalFile:_configLocalPath];
        if ([fm fileExistsAtPath:_configLocalPath]) {
            [self readDictionary];
        }
    }
}

- (void)parseLocalConfigFile {
    if ([fm fileExistsAtPath:_configLocalPath]) {
        [self readDictionary];
    }
}

- (void)readDictionary {
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:_configLocalPath];
    if (dic != nil && dic.count > 0) {
        NSArray *allKeys = [dic allKeys];
        if (allKeys.count > 0) {
            if ([allKeys containsObject:@"Contact"]) {
                NSString *ctType = [dic objectForKey:@"Contact"];
                if (![StringHelper stringIsNilOrEmpty:ctType]) {
                    _contactType = ctType;
                }else {
                    _contactType = @".vcf";
                }
            }
            if ([allKeys containsObject:@"Message"]) {
                NSString *mesType = [dic objectForKey:@"Message"];
                if (![StringHelper stringIsNilOrEmpty:mesType]) {
                    _messageType = mesType;
                }else {
                    _messageType = @".html";
                }
            }
            if ([allKeys containsObject:@"Call History"]) {
                NSString *callType = [dic objectForKey:@"Call History"];
                if (![StringHelper stringIsNilOrEmpty:callType]) {
                    _callHistoryType = callType;
                }else {
                    _callHistoryType = @".html";
                }
            }
            if ([allKeys containsObject:@"livePhoto"]) {
                NSString *liveType = [dic objectForKey:@"livePhoto"];
                if (![StringHelper stringIsNilOrEmpty:liveType]) {
                    _livePhotoType = liveType;
                }else {
                    _livePhotoType = @"photo";
                }
            }
            
            if ([allKeys containsObject:@"photoDate"]) {
                BOOL liveType = [[dic objectForKey:@"photoDate"] boolValue];
                _isCreadPhotoDate = liveType;
            }

            
            if ([allKeys containsObject:@"Calender"]) {
                NSString *caldType = [dic objectForKey:@"Calender"];
                if (![StringHelper stringIsNilOrEmpty:caldType]) {
                    _calenderType = caldType;
                }else {
                    _calenderType = @".csv";
                }
            }
            if ([allKeys containsObject:@"Reminder"]) {
                NSString *reminderType = [dic objectForKey:@"Reminder"];
                if (![StringHelper stringIsNilOrEmpty:reminderType]) {
                    _reminderType = reminderType;
                }else {
                    _reminderType = @".csv";
                }
            }
            if ([allKeys containsObject:@"Safari Bookmark"]) {
                NSString *saType = [dic objectForKey:@"Safari Bookmark"];
                if (![StringHelper stringIsNilOrEmpty:saType]) {
                    _safariType = saType;
                }else {
                    _safariType = @".html";
                }
            }
            if ([allKeys containsObject:@"Notes"]) {
                NSString *notesType = [dic objectForKey:@"Notes"];
                if (![StringHelper stringIsNilOrEmpty:notesType]) {
                    _notesType = notesType;
                }else {
                    _notesType = @".html";
                }
            }
            if ([allKeys containsObject:@"Safari History"]) {
                NSString *safariHistoryType = [dic objectForKey:@"Safari History"];
                if (![StringHelper stringIsNilOrEmpty:safariHistoryType]) {
                    _safariHistoryType = safariHistoryType;
                }else {
                    _safariHistoryType = @".html";
                }
            }
            if ([allKeys containsObject:@"IsOpenFolder"]) {
                BOOL isOpen = [[dic objectForKey:@"IsOpenFolder"] boolValue];
                _isOpenFolder = isOpen;
            }
            if ([allKeys containsObject:@"IsCreateFolder"]) {
                BOOL isCreate = [[dic objectForKey:@"IsCreateFolder"] boolValue];
                _isCreateFolder = isCreate;
            }
            if ([allKeys containsObject:@"Export Path"]) {
                NSString *exPath = [dic objectForKey:@"Export Path"];
                if (![StringHelper stringIsNilOrEmpty:exPath] && [fm fileExistsAtPath:exPath]) {
                    _exportPath = [exPath retain];
                }else {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    _exportPath = [[paths objectAtIndex:0] retain]
                    ;
                }
            }
            if ([allKeys containsObject:@"BackUp Path"]) {
                NSString *exPath = [dic objectForKey:@"BackUp Path"];
                if (![StringHelper stringIsNilOrEmpty:exPath] && [fm fileExistsAtPath:exPath]) {
                    _backupPath = [exPath retain];
                }else {
                    NSString *backUpPath = [TempHelper getBackupFolderPath];
                    _backupPath = [backUpPath retain];
                }
            }
            if ([allKeys containsObject:@"MaxBackupCount"]) {
                int count = [[dic objectForKey:@"MaxBackupCount"] intValue];
                _maxBackupCount = count;
            }
        }
    }
}


- (void) saveToDeviceOrLocal {
    NSMutableDictionary *exportDic = [[NSMutableDictionary alloc] init];
    [exportDic setObject:_contactType forKey:@"Contact"];
    [exportDic setObject:_callHistoryType forKey:@"Call History"];
    [exportDic setObject:_livePhotoType forKey:@"livePhoto"];
    [exportDic setObject:[NSNumber numberWithBool:_isCreadPhotoDate] forKey:@"photoDate"];
    [exportDic setObject:_messageType forKey:@"Message"];
    [exportDic setObject:_calenderType forKey:@"Calender"];
    [exportDic setObject:_reminderType forKey:@"Reminder"];
    [exportDic setObject:_safariType forKey:@"Safari Bookmark"];
    [exportDic setObject:_notesType forKey:@"Notes"];
    [exportDic setObject:_safariHistoryType forKey:@"Safari History"];
    [exportDic setObject:[NSNumber numberWithBool:_isCreateFolder] forKey:@"IsCreateFolder"];
    [exportDic setObject:[NSNumber numberWithBool:_isOpenFolder] forKey:@"IsOpenFolder"];
    [exportDic setObject:_exportPath forKey:@"Export Path"];
    [exportDic setObject:_backupPath forKey:@"BackUp Path"];
    [exportDic setObject:[NSNumber numberWithInt:_maxBackupCount] forKey:@"MaxBackupCount"];
    [exportDic writeToFile:_configLocalPath atomically:YES];
    if (_ipod != nil) {
        if ([_ipod.fileSystem fileExistsAtPath:_configDevicePath]) {
            [_ipod.fileSystem unlink:_configDevicePath];
        }
        [_ipod.fileSystem copyLocalFile:_configLocalPath toRemoteFile:_configDevicePath];
    }
    [exportDic release];
    
    //将备份路径保存到airBackupConfig.plist中
    NSString *configPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"];
    NSFileManager *_fm = [NSFileManager defaultManager];
    NSMutableDictionary *dic = nil;
    if ([_fm fileExistsAtPath:configPath]) {
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:configPath];
        [dic setObject:_backupPath forKey:@"BackupPath"];
        [dic writeToFile:configPath atomically:YES];
        [dic release];
    }
}

- (NSString*)getExportExtension:(NSString*)exportType {
    NSString *retVal = nil;
    if ([exportType isEqualToString:@".text"]) {
        retVal = @"txt";
    } else if ([exportType isEqualToString:@".csv"]) {
        retVal = @"csv";
    } else if ([exportType isEqualToString:@".html"]) {
        retVal = @"html";
    } else if ([exportType isEqualToString:@".pdf"]) {
        retVal = @"pdf";
    }else if ([exportType isEqualToString:@".vcf"]) {
        retVal = @"vcf";
    } else {
        retVal = @"txt";
    }
    return retVal;
}

@end

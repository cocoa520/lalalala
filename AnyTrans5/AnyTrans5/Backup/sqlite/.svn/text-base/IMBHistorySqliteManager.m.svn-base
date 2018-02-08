//
//  IMBHistorySqliteManager.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBHistorySqliteManager.h"
#import "NSString+Category.h"
#import "IMBBackupManager.h"
#import "IMBSafariHistoryEntity.h"
#import "StringHelper.h"
#import "DateHelper.h"
#import "TempHelper.h"
@implementation IMBHistorySqliteManager
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        _backUpPath = [backupfilePath retain];
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        manager.iosVersion = type;
        NSString *sqliteStr = nil;
        if ([_iOSVersion isVersionMajorEqual:@"8"]) {
            _isSqlite = YES;
            if (decypt) {
                [decypt decryptSingleFile:@"AppDomain-com.apple.mobilesafari" withFilePath:@"Library/Safari/History.db"];
                manager.backUpPath = decypt.outputPath;
                if (_backUpPath != nil) {
                    [_backUpPath release];
                    _backUpPath = nil;
                }
                _backUpPath = [decypt.outputPath retain];
            }
      
            sqliteStr = @"History.db";
        }else if ([_iOSVersion isVersionMajorEqual:@"7"]){
            if (decypt) {
                [decypt decryptSingleFile:@"AppDomain-com.apple.mobilesafari" withFilePath:@"Library/Safari/History.plist"];
                manager.backUpPath = decypt.outputPath;
                if (_backUpPath != nil) {
                    [_backUpPath release];
                    _backUpPath = nil;
                }
                _backUpPath = [decypt.outputPath retain];
            }

            sqliteStr = @"History.plist";
        }else{
            if (decypt) {
                [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/Safari/History.plist"];
                manager.backUpPath = decypt.outputPath;
                if (_backUpPath != nil) {
                    [_backUpPath release];
                    _backUpPath = nil;
                }
                _backUpPath = [decypt.outputPath retain];
            }
            sqliteStr = @"History.plist";
        }
        NSString *sqliteddPath = [manager copysqliteToApptempWithsqliteName:sqliteStr backupfilePath:_backUpPath];
        _dbPath = [sqliteddPath retain];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        _devicebackupFolderName = [[backupfilePath lastPathComponent] retain];
    }
    return self;
}

- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
            _isSqlite = YES;
            NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"AppDomain-com.apple.mobilesafari/Library/Safari/History.db"];
            if ([fm fileExistsAtPath:dbNPath]) {
                _databaseConnection = [[FMDatabase alloc] initWithPath:dbNPath];
            }
        }else{
            NSPredicate *pre = nil;
            //遍历需要的文件，然后拷贝到指定的目录下
            if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"8"]) {
                pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"AppDomain-com.apple.mobilesafari", @"Library/Safari/History.db"];
                _isSqlite = YES;
            } else if ([iCloudBackup.iOSVersion rangeOfString:@"7"].length > 0) {///*iOS7以上设备：
                pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"AppDomain-com.apple.mobilesafari", @"Library/Safari/History.plist"];
            } else {
                pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/Safari/History.plist"];
            }
            NSArray *tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            IMBiCloudFileInfo *webHistoryFile = nil;
            if (tmpArray != nil && tmpArray.count > 0) {
                webHistoryFile = [tmpArray objectAtIndex:0];
            }
            
            if (webHistoryFile != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (webHistoryFile.fileName.length > 2) {
                        fd = [webHistoryFile.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:webHistoryFile.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:webHistoryFile.fileName];
                }
                if (sourcefilePath != nil) {
                    _dbPath = [sourcefilePath retain];
                    _databaseConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }
        }
    }
    return self;
}

#pragma mark - 查询数据库方法
- (void)querySqliteDBContent {
    if (_isSqlite) {
        [self readWebHistoryDataByDB];
    } else {
        [self readWebHistoryDataByPlist];
    }
}

- (void)readWebHistoryDataByPlist {
    [_logManger writeInfoLog:@"read history data start."];
    if ([fm fileExistsAtPath:_dbPath]) {
        NSDictionary *webHistoryDic = [self readHistoryDataPListToDic];
        if (webHistoryDic != nil && [webHistoryDic.allKeys count] > 0) {
            if ([[webHistoryDic allKeys] containsObject:@"WebHistoryDates"]) {
                NSMutableArray *historyContent = [webHistoryDic objectForKey:@"WebHistoryDates"];
                if (historyContent != nil && historyContent.count > 0) {
                    int keyId = 1;
                    IMBSafariHistoryEntity *historyItem = nil;
                    for (NSMutableDictionary *item in historyContent) {
                        @autoreleasepool {

                            NSArray *dicKeys = [item allKeys];
                            historyItem = [[IMBSafariHistoryEntity alloc] init];
                            NSString *visitURL = [item objectForKey:[dicKeys objectAtIndex:0]];
                            if (visitURL == nil) {
                                visitURL = @"";
                            }
                            [historyItem setForwardURL:visitURL];
                            
                            
                            if ([dicKeys containsObject:@"title"]) {
                                NSString *title = [item objectForKey:@"title"];
                                if (title == nil) {
                                    title = @"";
                                }
                                [historyItem setTitle:title];
                            }
                            
                            if ([dicKeys containsObject:@"visitCount"]) {
                                int visitCount = [[item objectForKey:@"visitCount"] intValue];
                                [historyItem setVisitCount:visitCount];
                            }
                            
                            if ([dicKeys containsObject:@"lastVisitedDate"]) {
                                int lastVisitedDate = [[item objectForKey:@"lastVisitedDate"] doubleValue];
                                [historyItem setLastVisitedDate:lastVisitedDate];
                            }
                            
                            NSDate *dateTime = [DateHelper getDateTimeFromTimeStamp2001:(uint)[historyItem lastVisitedDate]];
                            [historyItem setLastVisiteDateStr:[NSDateFormatter localizedStringFromDate:dateTime dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]];
                            
                            if ([dicKeys containsObject:@"redirectURLs"]) {
                                historyItem.redirectSourceUrl = [[item objectForKey:@"redirectURLs"] retain];
                            }
                            
                            [item setValue:[NSNumber numberWithInt:keyId] forKey:@"ID"];
                            [historyItem setKeyId:keyId];
                            
                            if (![StringHelper stringIsNilOrEmpty:historyItem.title] || ![StringHelper stringIsNilOrEmpty:historyItem.forwardURL]) {
                                [_dataAry addObject:historyItem];
                            }
   
                            [historyItem release];
                            keyId++;
                        }
                    }
                }
            }
        }else {
            [_logManger writeInfoLog:@"plist file not exsit."];
        }
    }
    [_logManger writeInfoLog:@"read history data end."];
}

- (NSMutableDictionary *)readHistoryDataPListToDic {
    NSMutableDictionary *plistData = nil;
    if ([StringHelper stringIsNilOrEmpty:_dbPath] || ![fm fileExistsAtPath:_dbPath]) {
        return nil;
    }
    plistData = [NSMutableDictionary dictionaryWithContentsOfFile:_dbPath];
    return plistData;
}

- (void)readWebHistoryDataByDB {
    [_logManger writeInfoLog:@"read history sqlist start."];

    if ([self openDataBase]) {
        FMResultSet *rs = [_databaseConnection executeQuery:@"select a.id,a.history_item,a.title,a.visit_time,a.load_successful,a.http_non_get,a.synthesized,a.redirect_source,a.redirect_destination,a.origin,a.generation,b.url,b.domain_expansion,b.visit_count,b.daily_visit_counts,b.weekly_visit_counts,b.autocomplete_triggers,b.should_recompute_derived_visit_counts from history_visits as a left join history_items as b on a.history_item = b.id"];
        IMBSafariHistoryEntity *historyItem = nil;
        while ([rs next]) {
            @autoreleasepool {
                historyItem = [[IMBSafariHistoryEntity alloc] init];
                [historyItem setCheckState:UnChecked];
                int itemID = 0;
                if (![rs columnIsNull:@"id"]) {
                    itemID = [rs intForColumn:@"id"];
                }
                [historyItem setKeyId:itemID];
                
                NSString *title = nil;
                if (![rs columnIsNull:@"title"]) {
                    title = [rs stringForColumn:@"title"];
                } else {
                    title = @"";
                }
                if ([StringHelper stringIsNilOrEmpty:title]) {//滤掉title为空的
                    continue;
                }
                [historyItem setTitle:title];
                
                double visittimes = 0;
                if (![rs columnIsNull:@"visit_time"]) {
                    visittimes = [rs doubleForColumn:@"visit_time"];
                }
                [historyItem setLastVisitedDate:visittimes];
                NSDate *dateTime = [DateHelper getDateTimeFromTimeStamp2001:(uint)[historyItem lastVisitedDate]];
                [historyItem setLastVisiteDateStr:[NSDateFormatter localizedStringFromDate:dateTime dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]];
                
                NSString *url = nil;
                if (![rs columnIsNull:@"url"]) {
                    url = [rs stringForColumn:@"url"];
                } else {
                    url = @"";
                }
                [historyItem setForwardURL:url];

                
                int visitCount = 0;
                if (![rs columnIsNull:@"visit_count"]) {
                    visitCount = [rs intForColumn:@"visit_count"];
                }
                [historyItem setVisitCount:visitCount];
                
                [historyItem setHistoryItem:[rs intForColumn:@"history_item"]];
                [historyItem setLoadSuccessful:[rs boolForColumn:@"load_successful"]];
                [historyItem setHttpNonGet:[rs boolForColumn:@"http_non_get"]];
                [historyItem setSynthesized:[rs boolForColumn:@"synthesized"]];
                [historyItem setRedirectSource:[rs intForColumn:@"redirect_source"]];
                [historyItem setRedirectDestination:[rs intForColumn:@"redirect_destination"]];
                [historyItem setOrigin:[rs intForColumn:@"origin"]];
                [historyItem setGeneration:[rs intForColumn:@"generation"]];
                [historyItem setDomainExpansion:[rs stringForColumn:@"domain_expansion"]];
                [historyItem setDailyVisitCounts:[rs dataForColumn:@"daily_visit_counts"]];
                [historyItem setWeeklyVisitCounts:[rs dataForColumn:@"weekly_visit_counts"]];
                [historyItem setAutocompleteTriggers:[rs dataForColumn:@"autocomplete_triggers"]];
                [historyItem setShouldRecomputeDerivedVisitCounts:[rs intForColumn:@"should_recompute_derived_visit_counts"]];
                
                if (![StringHelper stringIsNilOrEmpty:historyItem.title] || ![StringHelper stringIsNilOrEmpty:historyItem.forwardURL]) {
                    [_dataAry addObject:historyItem];
                }
                [historyItem release];
            }
        }
        [rs close];
        [self closeDataBase];
    }
    [_logManger writeInfoLog:@"read history sqlite end."];
}


//- (NSString *)getFilePathForFileRecord:(IMBMBFileRecord *)mbFileRecord {
//    NSString *filePathModifyDBPath = nil;
//    if (mbFileRecord != nil) {
//        if ([_iOSVersion isVersionMajorEqual:@"10.0"]) {
//            NSString *filePathDBPath = [[_backupFolderPath stringByAppendingPathComponent:[mbFileRecord.key substringToIndex:2]] stringByAppendingPathComponent:mbFileRecord.key];
//            if ([fm fileExistsAtPath:filePathDBPath]) {
//                [fm removeItemAtPath:filePathDBPath error:nil];
//            }
//            if (![fm fileExistsAtPath:[_backupFolderPath stringByAppendingPathComponent:[mbFileRecord.key substringToIndex:2]]]) {
//                [fm createDirectoryAtPath:[_backupFolderPath stringByAppendingPathComponent:[mbFileRecord.key substringToIndex:2]] withIntermediateDirectories:YES attributes:nil error:nil];
//            }
//            
//            [fm copyItemAtPath:[[_deviceBackupFolderPath stringByAppendingPathComponent:[mbFileRecord.key substringToIndex:2]] stringByAppendingPathComponent:mbFileRecord.key] toPath:filePathDBPath error:nil];
//            filePathModifyDBPath = [_modifyFolderPath  stringByAppendingPathComponent:[mbFileRecord.key substringToIndex:2]];
//            if ([fm fileExistsAtPath:filePathModifyDBPath]) {
//                [fm removeItemAtPath:filePathModifyDBPath error:nil];
//            }
//            if (![fm fileExistsAtPath:filePathModifyDBPath ]) {
//                [fm createDirectoryAtPath:filePathModifyDBPath  withIntermediateDirectories:YES attributes:nil error:nil];
//            }
//            [fm copyItemAtPath:[[_deviceBackupFolderPath stringByAppendingPathComponent:[mbFileRecord.key substringToIndex:2]] stringByAppendingPathComponent:mbFileRecord.key]toPath:[filePathModifyDBPath stringByAppendingPathComponent:mbFileRecord.key] error:nil];
//        }else{
//            NSString *filePathDBPath = [_backupFolderPath stringByAppendingPathComponent:mbFileRecord.key];
//            if ([fm fileExistsAtPath:filePathDBPath]) {
//                [fm removeItemAtPath:filePathDBPath error:nil];
//            }
//            [fm copyItemAtPath:[_deviceBackupFolderPath stringByAppendingPathComponent:mbFileRecord.key] toPath:filePathDBPath error:nil];
//            filePathModifyDBPath = [_modifyFolderPath stringByAppendingPathComponent:mbFileRecord.key];
//            if ([fm fileExistsAtPath:filePathModifyDBPath]) {
//                [fm removeItemAtPath:filePathModifyDBPath error:nil];
//            }
//            [fm copyItemAtPath:[_deviceBackupFolderPath stringByAppendingPathComponent:mbFileRecord.key] toPath:filePathModifyDBPath error:nil];
//        }
////    }
//    return filePathModifyDBPath;
//}

- (void)dealloc {
    if (_dbPath != nil) {
        [_dbPath release];
        _dbPath = nil;
    }
    [super dealloc];
}
@end

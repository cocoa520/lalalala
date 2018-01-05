//
//  IMBCalendarSqliteManager.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCalendarSqliteManager.h"
#import "IMBBackupManager.h"
#import "IMBCalAndRemEntity.h"
#import "StringHelper.h"
@implementation IMBCalendarSqliteManager
@synthesize needQueryRedminder = _needQueryRedminder;
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        _backUpPath = [backupfilePath retain];
        _needQueryRedminder = NO;
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        if (isEncrypted) {
            [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/Calendar/Calendar.sqlitedb"];
            manager.backUpPath = decypt.outputPath;
            if (_backUpPath != nil) {
                [_backUpPath release];
                _backUpPath = nil;
            }
            _backUpPath = [decypt.outputPath retain];
        }
        NSString *sqliteddPath = [manager copysqliteToApptempWithsqliteName:@"Calendar.sqlitedb" backupfilePath:_backUpPath];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
    }
    return self;
}

- (id)initWithBackupfilePath:(NSString *)backupfilePath recordArray:(NSMutableArray *)recordArray{
    if (self = [super init]) {
        fm = [NSFileManager defaultManager];
        _logManger = [IMBLogManager singleton];
        _iOSVersion = [[IMBSqliteManager getBackupFileFloatVersion:backupfilePath] retain];
        _dataAry = [[NSMutableArray alloc]init];
        _backUpPath = [backupfilePath retain];
        NSString *sqliteddPath = [self copysqliteToApptempWithsqliteName:@"Calendar.sqlitedb" backupfilePath:backupfilePath recordArray:recordArray];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
    }
    return self;
}


- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
            NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/Calendar/Calendar.sqlitedb"];
            if ([fm fileExistsAtPath:dbNPath]) {
                _databaseConnection = [[FMDatabase alloc] initWithPath:dbNPath];
            }
        }else{
            //遍历需要的文件，然后拷贝到指定的目录下
            _needQueryRedminder = NO;
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/Calendar/Calendar.sqlitedb"];
            NSArray *tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            IMBiCloudFileInfo *calRemFile = nil;
            if (tmpArray != nil && tmpArray.count > 0) {
                calRemFile = [tmpArray objectAtIndex:0];
            }
            if (calRemFile != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (calRemFile.fileName.length > 2) {
                        fd = [calRemFile.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:calRemFile.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:calRemFile.fileName];
                }
//                NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:calRemFile.fileName];
                if (sourcefilePath != nil) {
                    _databaseConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }

        }
    }
    return self;
}

#pragma mark - 查询数据库方法
- (void)querySqliteDBContent {
    [_logManger writeInfoLog:@"query CalendarAndReminder Data Begin"];

    if ([self openDataBase]) {
        NSString *locationStr = @"select rowid from calendar where flags=4105 or title='中国节假日'";
        FMResultSet *rs = [_databaseConnection executeQuery:locationStr];
        int chainId = -1;
        while ([rs next]) {
            chainId = [rs intForColumn:@"rowid"];
        }
        [rs close];
        
        NSString *selectCmd = @"select ci.ROWID,ci.summary,ci.description,ci.start_date,ci.end_date,ci.all_day,ci.url,ci.calendar_id,ci.entity_type,ci.completion_date,l.title as location from calendaritem as ci left join location as l on ci.location_id=l.rowid";
        //        FMResultSet *rs = nil;
        rs = [_databaseConnection executeQuery:selectCmd];
        IMBCalAndRemEntity *calRemItem = nil;
        while ([rs next]) {
            @autoreleasepool {
                int rowid = [rs intForColumn:@"ROWID"];
                int allday = [rs intForColumn:@"all_day"];
                int calendarid = [rs intForColumn:@"calendar_id"];
                double starttime = [rs doubleForColumn:@"start_date"];
                double endtime = [rs doubleForColumn:@"end_date"];
                int entitytype = [rs intForColumn:@"entity_type"];
                double completiondate = [rs doubleForColumn:@"completion_date"];
                NSString *summary = [rs stringForColumn:@"summary"];
                if (summary == nil) {
                    summary = @"";
                }
                NSString *description = [rs stringForColumn:@"description"];
                if (description == nil) {
                    description = @"";
                }
                NSString *url = [rs stringForColumn:@"url"];
                if (url == nil) {
                    url = @"";
                }
                NSString *location = [rs stringForColumn:@"location"];
                if (location == nil) {
                    location = @"";
                }
                
                if ([StringHelper stringIsNilOrEmpty:summary] || calendarid == chainId) {
                    continue;
                }
                
                calRemItem = [[IMBCalAndRemEntity alloc] init];
                [calRemItem setCheckState:UnChecked];
                [calRemItem setRowid:rowid];
                [calRemItem setAllDay:allday];
                [calRemItem setCalendarID:calendarid];
                [calRemItem setStartTime:starttime];
                [calRemItem setEndTime:endtime];
                [calRemItem setEntityType:entitytype];
                [calRemItem setCompletionDate:completiondate];
                [calRemItem setSummary:summary];
                [calRemItem setSortStr:[StringHelper getStringFirstWord:calRemItem.summary]];
                [calRemItem setDescription:description];
                [calRemItem setUrl:url];
                [calRemItem setLocation:location];
                
                
                // 通知UI更新扫描消息个数的进度
                if (entitytype == 2) {//calendar
                    [_dataAry addObject:calRemItem];
                }else if (entitytype == 3) {//reminder
                    if (_needQueryRedminder) {
                        [_dataAry addObject:calRemItem];
                    }
                }
                [calRemItem release];
                calRemItem = nil;
            }
        }
        [rs close];
        [self closeDataBase];
    }
    [_logManger writeInfoLog:@"query CalendarAndReminder Data End"];
}
@end

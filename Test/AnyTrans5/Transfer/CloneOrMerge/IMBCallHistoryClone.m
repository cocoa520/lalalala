//
//  IMBCallHistoryClone.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-17.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBCallHistoryClone.h"
#import "IMBCallHistoryDataEntity.h"
#import "DateHelper.h"
@implementation IMBCallHistoryClone
- (id)initWithSourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray isClone:(BOOL)isClone
{
    if (self = [super init]) {
        _isClone = isClone;
        [self setsourceBackupPath:sourceBackupPath desBackupPath:desBackupPath sourcerecordArray:sourcerecordArray targetrecordArray:targetrecordArray];
        if (_isClone) {
            if (_sourceSqlitePath != nil&&_targetSqlitePath != nil) {
                if (_sourceVersion>_targetVersion) {
                    _sourceDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqlitePath];
                    _targetDBConnection = [[FMDatabase alloc] initWithPath:_targetSqlitePath];
                }else if (_sourceVersion == _targetVersion)
                {
                    if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
                        _sourceDBConnection = [[FMDatabase alloc] initWithPath:_targetSqlitePath];
                        _targetDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqlitePath];
                    }else
                    {
                        _sourceDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqlitePath];
                        _targetDBConnection = [[FMDatabase alloc] initWithPath:_targetSqlitePath];
                    }
                }else
                {
                    _sourceDBConnection = [[FMDatabase alloc] initWithPath:_targetSqlitePath];
                    _targetDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqlitePath];
                }
            }else
            {
                if (_sourceSqlitePath == nil) {
                    [_logHandle writeInfoLog:@"highSqlitePath is empty"];
                }
                if (_targetSqlitePath == nil) {
                    [_logHandle writeInfoLog:@"lowSqlitePath is empty"];
                }
            }
            if (_contactsqlitePath != nil) {
                _targetContactDBConnection = [[FMDatabase alloc] initWithPath:_contactsqlitePath];
            }else
            {
                if (_contactsqlitePath == nil) {
                    [_logHandle writeInfoLog:@"contactsqlitePath is empty"];
                }
            }
        }else{
            if (_sourceSqlitePath != nil&&_targetSqlitePath != nil) {
                
                _sourceDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqlitePath];
                _targetDBConnection = [[FMDatabase alloc] initWithPath:_targetSqlitePath];
            }else
            {
                if (_sourceSqlitePath == nil) {
                    [_logHandle writeInfoLog:@"highSqlitePath is empty"];
                }
                if (_targetSqlitePath == nil) {
                    [_logHandle writeInfoLog:@"lowSqlitePath is empty"];
                }
            }
            if (_contactsqlitePath != nil) {
                _targetContactDBConnection = [[FMDatabase alloc] initWithPath:_contactsqlitePath];
            }else
            {
                if (_contactsqlitePath == nil) {
                    [_logHandle writeInfoLog:@"contactsqlitePath is empty"];
                }
            }
        }
    }
    return self;
}

- (void)setsourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray
{
    _sourceVersion = [IMBBaseClone getBackupFileVersion:sourceBackupPath];
    _targetVersion = [IMBBaseClone getBackupFileVersion:desBackupPath];
    _sourceFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:sourceBackupPath] retain];
    _targetFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:desBackupPath] retain];
    _sourcerecordArray = [sourcerecordArray retain];
    _targetrecordArray = [targetrecordArray retain];
    _sourceBackuppath = [sourceBackupPath retain];
    _targetBakcuppath = [desBackupPath retain];
    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
        _sourceManifestDBConnection = [[FMDatabase alloc] initWithPath:[sourceBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
    }
    {
        if (_sourceVersion >= 8 ) {
            sourceRecord =  [[self getDBFileRecord:@"HomeDomain" path:@"Library/CallHistoryDB/CallHistory.storedata" recordArray:_sourcerecordArray] retain];
            NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
            NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,sourceRecord.key];
            sourceRecord.relativePath = relativePath;
        }else
        {
            sourceRecord = [[self getDBFileRecord:@"WirelessDomain" path:@"Library/CallHistory/call_history.db" recordArray:_sourcerecordArray] retain];
        }
         _sourceSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceSqlite"] fileRecord:sourceRecord backupfilePath:sourceBackupPath] retain];
    }
    if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
        _targetManifestDBConnection = [[FMDatabase alloc] initWithPath:[desBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
    }
    {
        if (_targetVersion >= 8 ) {
            targetRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/CallHistoryDB/CallHistory.storedata" recordArray:_targetrecordArray] retain];
            NSString *rstr = [targetRecord.key substringWithRange:NSMakeRange(0, 2)];
            NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,targetRecord.key];
            targetRecord.relativePath = relativePath;
        }else
        {
            targetRecord = [[self getDBFileRecord:@"WirelessDomain" path:@"Library/CallHistory/call_history.db" recordArray:_targetrecordArray] retain];
        }
        _targetSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetSqlite"] fileRecord:targetRecord backupfilePath:desBackupPath] retain];
        _contactRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/AddressBook/AddressBook.sqlitedb" recordArray:_targetrecordArray] retain];
        NSString *rstr = [_contactRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,_contactRecord.key];
        _contactRecord.relativePath = relativePath;
        _contactsqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetContactSqlite"] fileRecord:_contactRecord backupfilePath:desBackupPath] retain];
    }
}

- (void)merge:(NSMutableArray *)callHistory
{
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"merge callHistory count:%d",callHistory.count]];
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            [self openDataBase:_targetContactDBConnection];
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            [_targetContactDBConnection beginTransaction];
            [_logHandle writeInfoLog:@"merge callHistory enter"];
            if (_sourceVersion>=8.0 ) {
                if (_targetVersion >= 8.0) {
                    //高到高
                    [self insterCallHistoryHightToHight:_sourceDBConnection withTargetFmdb:_targetDBConnection CallDataArray:callHistory];
                }else {
                    //高到低
                    [self insterCallHistoryHightToLow:_sourceDBConnection withTargetFmdb:_targetDBConnection CallDataArray:callHistory];
                }
            }else {
                if (_targetVersion >= 8.0) {
                    //低到高
                    [self insterCallHistoryLowToHight:_sourceDBConnection withTargetFmdb:_targetDBConnection CallDataArray:callHistory];
                }else {
                    //低到低
                    [self insterCallHistoryLowToLow:_sourceDBConnection withTargetFmdb:_targetDBConnection CallDataArray:callHistory];
                }
            }
            if (![_sourceDBConnection commit]) {
                [_sourceDBConnection rollback];
            }
            if (![_targetDBConnection commit]) {
                [_targetDBConnection rollback];
            }
            if (![_targetContactDBConnection commit]) {
                [_targetContactDBConnection rollback];
            }
            
            [_sourceDBConnection close];
            [_targetContactDBConnection close];
            [_targetDBConnection close];
            [_logHandle writeInfoLog:@"merge callHistory exit"];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [self modifyHashAndManifest];
}

- (void)modifyHashAndManifest
{
    [super modifyHashAndManifest];
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSString *contactbackupPath = nil;
    if ([_targetFloatVersion isVersionLess:@"10"]&&_contactRecord) {
        contactbackupPath = [_targetBakcuppath stringByAppendingPathComponent:_contactRecord.key];
    }else if (_contactRecord){
        contactbackupPath = [_targetBakcuppath stringByAppendingPathComponent:_contactRecord.relativePath];
    }
    if ([fileM fileExistsAtPath:contactbackupPath]) {
        [fileM removeItemAtPath:contactbackupPath error:nil];
    }
    if (_contactsqlitePath!=nil&&contactbackupPath!=nil) {
        [fileM copyItemAtPath:_contactsqlitePath toPath:contactbackupPath error:nil];
    }
    if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
        [self modifyHashMajorEqualTen:_targetManifestDBConnection SqlitePath:_contactsqlitePath record:_contactRecord];
    }else{
        [IMBBaseClone reCaculateRecordHash:_contactRecord backupFolderPath:_targetBakcuppath];
        [IMBBaseClone saveMBDB:_targetrecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetManifest.mbdb"] backupFolderPath:_targetBakcuppath];
    }
}


- (void)insterCallHistoryHightToHight:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB CallDataArray:(NSMutableArray *)CallData {
    @try {
        NSString *IOS8SelectStr = @"SELECT  Z_ENT, Z_OPT, ZANSWERED, ZCALLTYPE, ZDISCONNECTED_CAUSE, ZNUMBER_AVAILABILITY, ZORIGINATED, ZREAD, ZDATE, ZFACE_TIME_DATA,ZDURATION, ZADDRESS, ZDEVICE_ID, ZISO_COUNTRY_CODE, ZNAME, ZUNIQUE_ID FROM ZCALLRECORD where z_pk=:z_pk";
        NSString *IOS8InsertStr = @"insert into zcallrecord(Z_ENT, Z_OPT, ZANSWERED, ZCALLTYPE, ZDISCONNECTED_CAUSE, ZNUMBER_AVAILABILITY, ZORIGINATED, ZREAD, ZDATE, ZFACE_TIME_DATA,ZDURATION, ZADDRESS, ZDEVICE_ID, ZISO_COUNTRY_CODE, ZNAME, ZUNIQUE_ID) values(:Z_ENT, :Z_OPT, :ZANSWERED, :ZCALLTYPE, :ZDISCONNECTED_CAUSE, :ZNUMBER_AVAILABILITY, :ZORIGINATED, :ZREAD, :ZDATE, :ZFACE_TIME_DATA, :ZDURATION, :ZADDRESS, :ZDEVICE_ID, :ZISO_COUNTRY_CODE, :ZNAME, :ZUNIQUE_ID)";
        NSString *IOS10InsertStr = @"insert into zcallrecord(Z_ENT, Z_OPT, ZANSWERED, ZCALLTYPE, ZDISCONNECTED_CAUSE, ZNUMBER_AVAILABILITY, ZORIGINATED, ZREAD, ZDATE, ZFACE_TIME_DATA,ZDURATION, ZADDRESS, ZDEVICE_ID, ZISO_COUNTRY_CODE, ZNAME, ZUNIQUE_ID,ZSERVICE_PROVIDER,ZCALL_CATEGORY,ZHANDLE_TYPE) values(:Z_ENT, :Z_OPT, :ZANSWERED, :ZCALLTYPE, :ZDISCONNECTED_CAUSE, :ZNUMBER_AVAILABILITY, :ZORIGINATED, :ZREAD, :ZDATE, :ZFACE_TIME_DATA, :ZDURATION, :ZADDRESS, :ZDEVICE_ID, :ZISO_COUNTRY_CODE, :ZNAME, :ZUNIQUE_ID,:ZSERVICE_PROVIDER,:ZCALL_CATEGORY,:ZHANDLE_TYPE)";
        
        for(IMBCallContactModel *item in CallData) {
            @autoreleasepool {
                for (IMBCallHistoryDataEntity *entity in item.callHistoryList) {
                    @autoreleasepool {
                        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithInt:entity.rowid], @"z_pk",
                                               nil];
                        FMResultSet *rs = nil;
                        rs = [sourceFMDB executeQuery:IOS8SelectStr withParameterDictionary:param];
                        while ([rs next]) {
                            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
                            [paramDic setObject:[rs objectForColumnName:@"Z_ENT"] forKey:@"Z_ENT"];
                            [paramDic setObject:[rs objectForColumnName:@"Z_OPT"] forKey:@"Z_OPT"];
                            [paramDic setObject:[rs objectForColumnName:@"ZANSWERED"] forKey:@"ZANSWERED"];
                            NSNumber *callType = [rs objectForColumnName:@"ZCALLTYPE"];
                            [paramDic setObject:callType forKey:@"ZCALLTYPE"];
                            [paramDic setObject:[rs objectForColumnName:@"ZDISCONNECTED_CAUSE"] forKey:@"ZDISCONNECTED_CAUSE"];
                            [paramDic setObject:[rs objectForColumnName:@"ZFACE_TIME_DATA"] forKey:@"ZFACE_TIME_DATA"];
                            [paramDic setObject:[rs objectForColumnName:@"ZNUMBER_AVAILABILITY"] forKey:@"ZNUMBER_AVAILABILITY"];
                            [paramDic setObject:[rs objectForColumnName:@"ZORIGINATED"] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[rs objectForColumnName:@"ZREAD"] forKey:@"ZREAD"];
                            [paramDic setObject:[rs objectForColumnName:@"ZDATE"] forKey:@"ZDATE"];
                            [paramDic setObject:[rs objectForColumnName:@"ZDURATION"] forKey:@"ZDURATION"];
                            int targetNum = _targetVersion;
                            int sourceNum = _sourceVersion;
                            if (targetNum == sourceNum) {
                                [paramDic setObject:[rs objectForColumnName:@"ZADDRESS"] forKey:@"ZADDRESS"];
                            } else if (targetNum == 8 && sourceNum >= 9) {
                                NSData *data = [rs dataForColumn:@"ZADDRESS"];
                                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                [paramDic setObject:str?:[NSNull null] forKey:@"ZADDRESS"];
                                [str release];
                                str = nil;
                            } else if (targetNum >= 9 && sourceNum == 8) {
                                NSString *str = [rs stringForColumn:@"ZADDRESS"];
                                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                                [paramDic setObject:data?:[NSNull null] forKey:@"ZADDRESS"];
                            }else{
                                [paramDic setObject:[rs objectForColumnName:@"ZADDRESS"] forKey:@"ZADDRESS"];
                            }
                            [paramDic setObject:[rs objectForColumnName:@"ZDEVICE_ID"] forKey:@"ZDEVICE_ID"];
                            [paramDic setObject:[rs objectForColumnName:@"ZISO_COUNTRY_CODE"] forKey:@"ZISO_COUNTRY_CODE"];
                            [paramDic setObject:[rs objectForColumnName:@"ZNAME"] forKey:@"ZNAME"];
                            [paramDic setObject:[rs objectForColumnName:@"ZUNIQUE_ID"] forKey:@"ZUNIQUE_ID"];
                            if (_targetVersion>=10) {
                                if (callType.intValue == 8) {
                                    [paramDic setObject:@"com.apple.FaceTime" forKey:@"ZSERVICE_PROVIDER"];
                                    [paramDic setObject:@(2) forKey:@"ZCALL_CATEGORY"];
                                    
                                }else{
                                    [paramDic setObject:@"com.apple.Telephony" forKey:@"ZSERVICE_PROVIDER"];
                                    [paramDic setObject:@(1) forKey:@"ZCALL_CATEGORY"];
                                    
                                }
                                [paramDic setObject:@(2) forKey:@"ZHANDLE_TYPE"];
                                [targetFMDB executeUpdate:IOS10InsertStr withParameterDictionary:paramDic];
                                
                            }else{
                                [targetFMDB executeUpdate:IOS8InsertStr withParameterDictionary:paramDic];
                            }
                        }
                        [rs close];

                    }
                }
            }
        }
        NSString *cmd = @"update Z_PRIMARYKEY set Z_MAX=(select count(*) from ZCALLRECORD) where Z_NAME='CallRecord'";
        [targetFMDB executeUpdate:cmd];
    }
    @catch (NSException *ex) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"----HightToHight Error----:%@",ex]];
    }
}

- (void)insterCallHistoryHightToLow:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB CallDataArray:(NSMutableArray *)callData {
    @try {
        NSString *IOS8SelectStr = @"SELECT  Z_ENT, Z_OPT, ZANSWERED, ZCALLTYPE, ZDISCONNECTED_CAUSE, ZNUMBER_AVAILABILITY, ZORIGINATED, ZREAD, ZDATE, ZFACE_TIME_DATA,ZDURATION, ZADDRESS, ZDEVICE_ID, ZISO_COUNTRY_CODE, ZNAME, ZUNIQUE_ID FROM ZCALLRECORD where z_pk=:z_pk";
        
        int targetNum = _targetVersion;
        NSString *insertCmd = @"";
        if ([_targetFloatVersion isVersionMajor:@"7.0"]) {
            insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code, read, assisted,face_time_data,answered) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code, :read, :assisted, :face_time_data, :answered)";;
        }else if (targetNum == 6||[_targetFloatVersion isEqualToString:@"7.0"]) {
            insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code, read, assisted,face_time_data) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code, :read, :assisted, :face_time_data)";
        }else if (targetNum == 5) {
            insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code)";
        }
        for (IMBCallContactModel *item in callData) {
            for (IMBCallHistoryDataEntity *entity in item.callHistoryList) {
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:entity.rowid], @"z_pk",
                                       nil];
                FMResultSet *rs = nil;
                rs = [sourceFMDB executeQuery:IOS8SelectStr withParameterDictionary:param];
                
                while ([rs next]) {
                    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
                    id address = [rs objectForColumnName:@"ZADDRESS"];
                    if ([address isKindOfClass:[NSData class]]){
                        address = [[[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding] autorelease];
                    }
                    [paramDic setObject:address?:[NSNull null] forKey:@"address"];
                    NSInteger date = [rs intForColumn:@"ZDATE"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
                    NSDate *originDate = [dateFormatter dateFromString:@"01/01/2001 08:00:00"];
                    if(originDate == nil || originDate == NULL) {
                        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
                        originDate = [dateFormatter dateFromString:@"01/01/2001 08:00:00"];
                    }
                    NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:date sinceDate:originDate] autorelease];
                    NSInteger date1 = [returnDate timeIntervalSince1970];
                    [dateFormatter release];
                    [paramDic setObject:@(date1) forKey:@"date"];
                    
                    [paramDic setObject:[rs objectForColumnName:@"ZDURATION"] forKey:@"duration"];
                    int calltype = [rs intForColumn:@"ZCALLTYPE"];
                    int answered = [rs intForColumn:@"ZANSWERED"];
                    int originated = [rs intForColumn:@"ZORIGINATED"];
                    if (targetNum <= 6) {
                        if (calltype == 8) {
                            if (originated == 1 && answered == 0) {
                                [paramDic setObject:[NSNumber numberWithInt:21] forKey:@"flags"];
                            }else if (originated == 0 && answered == 1) {
                                [paramDic setObject:[NSNumber numberWithInt:20] forKey:@"flags"];
                            }else {
                                [paramDic setObject:[NSNumber numberWithInt:20] forKey:@"flags"];
                            }
                        }else {
                            if (originated == 1 && answered == 0) {
                                [paramDic setObject:[NSNumber numberWithInt:5] forKey:@"flags"];
                            }else if (originated == 0 && answered == 1) {
                                [paramDic setObject:[NSNumber numberWithInt:4] forKey:@"flags"];
                            }else {
                                [paramDic setObject:[NSNumber numberWithInt:4] forKey:@"flags"];
                            }
                        }
                    }else if (targetNum == 7) {
                        if (calltype == 8) {
                            if (originated == 1 && answered == 0) {
                                [paramDic setObject:[NSNumber numberWithInt:17] forKey:@"flags"];
                            }else if (originated == 0 && answered == 1) {
                                [paramDic setObject:[NSNumber numberWithInt:16] forKey:@"flags"];
                            }else {
                                [paramDic setObject:[NSNumber numberWithInt:16] forKey:@"flags"];
                            }
                        }else {
                            if (originated == 1 && answered == 0) {
                                [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"flags"];
                            }else if (originated == 0 && answered == 1) {
                                [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"flags"];
                            }else {
                                [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"flags"];
                            }
                        }
                    }
                    //进行与contact的匹配
                    [paramDic setObject:@(-1) forKey:@"id"];
                    [paramDic setObject:[rs objectForColumnName:@"ZNAME"] forKey:@"name"];
                    NSString *hightCode = [rs stringForColumn:@"ZISO_COUNTRY_CODE"];
                    int countryCode = [self contryCodeHightToLow:hightCode];
                    [paramDic setObject:[NSNumber numberWithInt:countryCode] forKey:@"country_code"];
                    [paramDic setObject:@"00" forKey:@"network_code"];
                    if (targetNum >= 6) {
                        [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"assisted"];
                        if ([rs objectForColumnName:@"ZFACE_TIME_DATA"] != nil)
                        {
                            int facetimaData = [rs intForColumn:@"ZFACE_TIME_DATA"];
                            NSData *faceTimeSize = [NSData dataWithBytes:&facetimaData length: sizeof(facetimaData)];
                            [paramDic setObject:faceTimeSize forKey:@"face_time_data"];
                        }
                        else
                        {
                            [paramDic setObject:[NSNull null] forKey:@"face_time_data"];
                        }
                        [paramDic setObject:[rs objectForColumnName:@"ZREAD"] forKey:@"read"];
                    }
                    if ([_targetFloatVersion isVersionMajor:@"7.0"]) {
                        [paramDic setObject:[NSNumber numberWithInt:answered] forKey:@"answered"];
                    }
                    [targetFMDB executeUpdate:insertCmd withParameterDictionary:paramDic];
                }
                [rs close];
                
            }
        }
        [self updateCallId:targetFMDB];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"----HightToLow Error----:%@",exception]];
    }
}

- (void)insterCallHistoryLowToHight:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB CallDataArray:(NSMutableArray *)callData {
    @try {
        int sourceNum = _sourceVersion;
        int targetNum = _targetVersion;
        NSString *selectCmd = @"";
        if ([_sourceFloatVersion isVersionMajor:@"7.0"]) {
            selectCmd = @"SELECT  address, date, duration, flags, id, name, country_code, network_code, read, assisted, face_time_data, originalAddress, answered FROM call where ROWID=:ROWID";;
        }else if (sourceNum == 6||[_sourceFloatVersion isEqualToString:@"7.0"]) {
            selectCmd = @"SELECT  address, date, duration, flags, id, name, country_code, network_code, read, assisted, face_time_data, originalAddress FROM call where ROWID=:ROWID";
        }else if (sourceNum == 5) {
            selectCmd = @"SELECT  address, date, duration, flags, id, name, country_code, network_code FROM call where ROWID=:ROWID";
        }
        NSString *IOS8InsertStr = @"insert into ZCALLRECORD(Z_ENT,Z_OPT, ZANSWERED,ZCALLTYPE,ZADDRESS,ZDATE,ZDURATION,ZNUMBER_AVAILABILITY,ZORIGINATED,ZISO_COUNTRY_CODE,ZFACE_TIME_DATA,ZNAME,ZREAD,ZUNIQUE_ID) values(:Z_ENT, :Z_OPT, :ZANSWERED, :ZCALLTYPE, :ZADDRESS, :ZDATE, :ZDURATION, :ZNUMBER_AVAILABILITY, :ZORIGINATED, :ZISO_COUNTRY_CODE, :ZFACE_TIME_DATA, :ZNAME, :ZREAD, :ZUNIQUE_ID)";
        NSString *IOS10InsertStr = @"insert into zcallrecord(Z_ENT, Z_OPT, ZANSWERED, ZCALLTYPE, ZDISCONNECTED_CAUSE, ZNUMBER_AVAILABILITY, ZORIGINATED, ZREAD, ZDATE, ZFACE_TIME_DATA,ZDURATION, ZADDRESS, ZDEVICE_ID, ZISO_COUNTRY_CODE, ZNAME, ZUNIQUE_ID,ZSERVICE_PROVIDER,ZCALL_CATEGORY,ZHANDLE_TYPE) values(:Z_ENT, :Z_OPT, :ZANSWERED, :ZCALLTYPE, :ZDISCONNECTED_CAUSE, :ZNUMBER_AVAILABILITY, :ZORIGINATED, :ZREAD, :ZDATE, :ZFACE_TIME_DATA, :ZDURATION, :ZADDRESS, :ZDEVICE_ID, :ZISO_COUNTRY_CODE, :ZNAME, :ZUNIQUE_ID,:ZSERVICE_PROVIDER,:ZCALL_CATEGORY,:ZHANDLE_TYPE)";
        
        
        NSString *entCmd = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='CallRecord'";
        FMResultSet *rs = [targetFMDB executeQuery:entCmd];
        int z_ent = 0;
        while ([rs next]) {
            z_ent = [rs intForColumn:@"Z_ENT"];
        }
        [rs close];
        for (IMBCallContactModel *item in callData) {
            for (IMBCallHistoryDataEntity *entity in item.callHistoryList) {
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:entity.rowid], @"ROWID",
                                       nil];
                FMResultSet *rs1 = [sourceFMDB executeQuery:selectCmd withParameterDictionary:param];
                
                while ([rs1 next]) {
                    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
                    [paramDic setObject:[NSNumber numberWithInt:z_ent] forKey:@"Z_ENT"];
                    int callType = [rs1 objectForColumnName:@"face_time_data"] == nil ? 1 : 8;
                    [paramDic setObject:[NSNumber numberWithInt:callType] forKey:@"ZCALLTYPE"];
                    if (targetNum == 8) {
                        [paramDic setObject:[rs1 objectForColumnName:@"address"] forKey:@"ZADDRESS"];
                    }else if (targetNum == 9) {
                        NSString *str = [rs stringForColumn:@"address"];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        [paramDic setObject:data?:[NSNull null] forKey:@"ZADDRESS"];
                    }
                    double date1 = [DateHelper timeIntervalFrom1970To2001:entity.date];
                    [paramDic setObject:[NSNumber numberWithInt:date1] forKey:@"ZDATE"];
                    int duration = [rs1 intForColumn:@"duration"];
                    if (duration == 0) {
                        [paramDic setObject:[NSNumber numberWithInt:2] forKey:@"Z_OPT"];
                    }else {
                        [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"Z_OPT"];
                    }
                    [paramDic setObject:[NSNumber numberWithInt:duration] forKey:@"ZDURATION"];
                    [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZNUMBER_AVAILABILITY"];
                    int flag = [rs1 intForColumn:@"flags"] & 0xffff;
                    if (sourceNum <= 6) {
                        if (flag == 5) {
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZANSWERED"];
                        }else if (flag == 4) {
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZANSWERED"];
                        }else if (flag == 21) {
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZANSWERED"];
                        }else if (flag == 20) {
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZANSWERED"];
                        }else {
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZANSWERED"];
                        }
                    }else if (sourceNum == 7) {
                        if (flag == 1) {
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZANSWERED"];
                        }else if (flag == 0) {
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZANSWERED"];
                        }else if (flag == 17) {
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZANSWERED"];
                        }else if (flag == 16) {
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZANSWERED"];
                        }else if (flag == 65) {
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZANSWERED"];
                        }else if (flag == 64) {
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZANSWERED"];
                        }else {
                            [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"ZORIGINATED"];
                            [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"ZANSWERED"];
                        }
                    }
                    
                    int countryCodeLow = [rs1 intForColumn:@"country_code"];
                    NSString *countryCodeStr = [self countryCodeLowToHight:countryCodeLow];
                    [paramDic setObject:countryCodeStr forKey:@"ZISO_COUNTRY_CODE"];
                    [paramDic setObject:[rs1 objectForColumnName:@"name"] forKey:@"ZNAME"];
                    [paramDic setObject:[rs1 objectForColumnName:@"read"] forKey:@"ZREAD"];
                    
                    if (duration > 0)
                    {
                        if (flag == 20 || flag == 21 || flag == 16 || flag == 17 || flag == 65 || flag == 64)
                        {
                            NSData *facetime = [rs dataForColumn:@"face_time_data"];
                            if (facetime != nil) {
                                int faceSize = 0;
                                [facetime getBytes:&faceSize length:sizeof(faceSize)];
                                [paramDic setObject:[NSNumber numberWithInt:faceSize] forKey:@"ZFACE_TIME_DATA"];
                            }else {
                                [paramDic setObject:[NSNull null] forKey:@"ZFACE_TIME_DATA"];
                            }
                        }
                        else
                        {
                            [paramDic setObject:[NSNull null] forKey:@"ZFACE_TIME_DATA"];
                        }
                    }
                    else
                    {
                        [paramDic setObject:[NSNull null] forKey:@"ZFACE_TIME_DATA"];
                    }
                    [paramDic setObject:[self createGUID] forKey:@"ZUNIQUE_ID"];
                    if (_targetVersion>=10) {
                        if (callType == 8) {
                            [paramDic setObject:@"com.apple.FaceTime" forKey:@"ZSERVICE_PROVIDER"];
                            [paramDic setObject:@(2) forKey:@"ZCALL_CATEGORY"];
                            
                        }else{
                            [paramDic setObject:@"com.apple.Telephony" forKey:@"ZSERVICE_PROVIDER"];
                            [paramDic setObject:@(1) forKey:@"ZCALL_CATEGORY"];
                        }
                        [paramDic setObject:@(2) forKey:@"ZHANDLE_TYPE"];
                        [targetFMDB executeUpdate:IOS10InsertStr withParameterDictionary:paramDic];
                        
                    }else{
                        [targetFMDB executeUpdate:IOS8InsertStr withParameterDictionary:paramDic];
                    }
                }
                [rs1 close];
                
                
            }
        }
        NSString *cmd = @"update Z_PRIMARYKEY set Z_MAX=(select count(*) from ZCALLRECORD) where Z_NAME='CallRecord'";
        [targetFMDB executeUpdate:cmd];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"----LowToHight Error----:%@",exception]];
    }
}

- (void)insterCallHistoryLowToLow:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB  CallDataArray:(NSMutableArray *)callData {
    @try {
        int sourceNum = _sourceVersion;
        int targetNum = _targetVersion;
        NSString *selectCmd = @"";
        NSString *insertCmd = @"";
        if ([_sourceFloatVersion isVersionMajor:@"7.0"]) {
            selectCmd = @"SELECT  address, date, duration, flags, id, name, country_code, network_code, read, assisted, face_time_data, originalAddress, answered FROM call where ROWID=:ROWID";
        }else if (sourceNum == 6||[_sourceFloatVersion isEqualToString:@"7.0"]) {
            selectCmd = @"SELECT  address, date, duration, flags, id, name, country_code, network_code, read, assisted, face_time_data, originalAddress FROM call where ROWID=:ROWID";
        }else if (sourceNum == 5) {
            selectCmd = @"SELECT  address, date, duration, flags, id, name, country_code, network_code FROM call where ROWID=:ROWID";
        }
        if ([_targetFloatVersion isVersionMajor:@"7.0"]) {
            insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code, read, assisted,face_time_data,answered) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code, :read, :assisted, :face_time_data, :answered)";
        }else if (targetNum == 6||[_targetFloatVersion isEqualToString:@"7.0"]) {
            insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code, read, assisted,face_time_data) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code, :read, :assisted, :face_time_data)";
        }else if (targetNum == 5) {
            insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code)";
        }
        for (IMBCallContactModel *item in callData) {
            for (IMBCallHistoryDataEntity *entity in item.callHistoryList) {
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:entity.rowid], @"ROWID",
                                       nil];
                FMResultSet *rs = nil;
                rs = [sourceFMDB executeQuery:selectCmd withParameterDictionary:param];
                while ([rs next]) {
                    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
                    NSString *address = [rs stringForColumn:@"address"];
                    [paramDic setObject:address?:[NSNull null] forKey:@"address"];
                    int64_t timeinteval = [[rs objectForColumnName:@"date"] longLongValue];
                    if (timeinteval == 0) {
                        [paramDic setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"date"];
                    }else{
                        [paramDic setObject:@(timeinteval) forKey:@"date"];
                    }
                    [paramDic setObject:[rs objectForColumnName:@"duration"] forKey:@"duration"];
                    int flag = [rs intForColumn:@"flags"] & 0xffff;
                    if (targetNum < sourceNum) {
                        if (flag == 1) { [paramDic setObject:[NSNumber numberWithInt:5] forKey:@"flags"]; }
                        else if (flag == 0) { [paramDic setObject:[NSNumber numberWithInt:4] forKey:@"flags"]; }
                        else if (flag == 17) { [paramDic setObject:[NSNumber numberWithInt:21] forKey:@"flags"]; }
                        else if (flag == 16) { [paramDic setObject:[NSNumber numberWithInt:20] forKey:@"flags"]; }
                        else if (flag == 65) { [paramDic setObject:[NSNumber numberWithInt:21] forKey:@"flags"]; }
                        else if (flag == 64) { [paramDic setObject:[NSNumber numberWithInt:20] forKey:@"flags"]; }
                        else { [paramDic setObject:[NSNumber numberWithInt:[rs intForColumn:@"flags"]] forKey:@"flags"]; }
                    }else if (targetNum > sourceNum) {
                        if (flag == 5) { [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"flags"]; }
                        else if (flag == 4) { [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"flags"]; }
                        else if (flag == 21) { [paramDic setObject:[NSNumber numberWithInt:17] forKey:@"flags"]; }
                        else if (flag == 20) { [paramDic setObject:[NSNumber numberWithInt:16] forKey:@"flags"]; }
                        else { [paramDic setObject:[NSNumber numberWithInt:[rs intForColumn:@"flags"]] forKey:@"flags"]; }
                    }else {
                        [paramDic setObject:[NSNumber numberWithInt:[rs intForColumn:@"flags"]] forKey:@"flags"];
                    }
                    [paramDic setObject:@(-1) forKey:@"id"];
                    [paramDic setObject:[rs objectForColumnName:@"name"] forKey:@"name"];
                    [paramDic setObject:[rs objectForColumnName:@"country_code"] forKey:@"country_code"];
                    [paramDic setObject:@"00" forKey:@"network_code"];
                    if (sourceNum > 5 && targetNum > 5) {
                        [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"assisted"];
                        [paramDic setObject:[rs objectForColumnName:@"face_time_data"] forKey:@"face_time_data"];
                        [paramDic setObject:[rs objectForColumnName:@"read"] forKey:@"read"];
                    }
                    if ([_sourceFloatVersion isVersionMajor:@"7.0"]&&[_targetFloatVersion isVersionMajor:@"7.0"]) {
                        [paramDic setObject:[rs objectForColumnName:@"answered"] forKey:@"answered"];
                    }else if ([_targetFloatVersion isVersionMajor:@"7.0"] &&[_sourceFloatVersion isVersionLessEqual:@"7.0"]){
                        switch (flag) {
                            case 5:
                            case 9:
                            case 1:
                            case 21:
                            case 17:
                            case 65:
                                [paramDic setObject:@(0) forKey:@"answered"];
                                break;
                            case 20:
                            case 16:
                            case 64:
                            case 4:
                            case 0:
                                [paramDic setObject:@(1) forKey:@"answered"];
                                break;
                            default:
                                [paramDic setObject:@(0) forKey:@"answered"];
                                break;
                        }
                    }
                    [targetFMDB executeUpdate:insertCmd withParameterDictionary:paramDic];
                }
                [rs close];
            }
        }
        [self updateCallId:targetFMDB];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"----LowToLow Error----:%@",exception]];
    }
}

- (int)contryCodeHightToLow:(NSString *)contryCode {
    int contryPara = 000;
    if ([contryCode isEqualToString:@"cn"])
    {
        contryPara = 460;
    }
    else if ([contryCode isEqualToString:@"fr"])
    {
        contryPara = 208;
    }
    else if ([contryCode isEqualToString:@"de"])
    {
        contryPara = 262;
    }
    else if ([contryCode isEqualToString:@"us"])
    {
        contryPara = 310;
    }
    else if ([contryCode isEqualToString:@"es"])
    {
        contryPara = 214;
    }
    else if ([contryCode isEqualToString:@"jp"])
    {
        contryPara = 440;
    }
    else
    {
        contryPara = 000;
    }
    return contryPara;
}

- (NSString *)countryCodeLowToHight:(int)countryCode {
    NSString *ContryStr = @"es";
    if (countryCode == 460)
    {
        ContryStr = @"cn";
    }
    else if (countryCode == 208)
    {
        ContryStr = @"fr";
    }
    else if (countryCode == 262)
    {
        ContryStr = @"de";
    }
    else if (countryCode == 310)
    {
        ContryStr = @"us";
    }
    else if (countryCode == 214)
    {
        ContryStr = @"es";
    }
    else if (countryCode == 440)
    {
        ContryStr = @"jp";
    }
    else
    {
        ContryStr = @"es";
    }
    return ContryStr;
}

- (void)updateCallId:(FMDatabase *)targetFMDB {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *strCmd = @"SELECT ROWID, address, id FROM call";
    FMResultSet *rs = [targetFMDB executeQuery:strCmd];
    while ([rs next]) {
        int rowid = [rs intForColumn:@"ROWID"];
        NSString *phoneNumber = [rs stringForColumn:@"address"];
        if (phoneNumber.length > 4) {
            phoneNumber = [phoneNumber substringFromIndex:(phoneNumber.length - 4)];
        }
        if (phoneNumber.length > 0) {
            NSString *conCmd = @"SELECT record_id FROM ABMultiValue where value like '%:PhoneLastFour'";
            NSDictionary *parma = [NSDictionary dictionaryWithObjectsAndKeys:
                                   phoneNumber, @"PhoneLastFour",
                                   nil];
            FMResultSet *rs1 = [_targetDBConnection executeQuery:conCmd withParameterDictionary:parma];
            while ([rs1 next]) {
                int contactid = [rs1 intForColumn:@"record_id"];
                if (contactid != 0 && ![dic.allKeys containsObject:[NSNumber numberWithInt:rowid]]) {
                    [dic setObject:[NSNumber numberWithInt:contactid] forKey:[NSNumber numberWithInt:rowid]];
                }
            }
            [rs1 close];
        }
    }
    [rs close];
    if (dic.allKeys.count > 0) {
        @try {
            for (NSNumber *item in dic.allKeys) {
                NSString *cmd = @"update call set id=:id where rowid=:rowid";
                NSDictionary *prama = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:item], @"id", item, @"rowid", nil];
                [targetFMDB executeUpdate:cmd withParameterDictionary:prama];
            }
        }@catch (NSException *ex)
        {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"----error----:%@", ex]];
        }
    }
}
#pragma mark - Clone
- (void)clone
{
    [_logHandle writeInfoLog:@"clone callhistory enter"];

    if (_sourceVersion<=_targetVersion) {
        int version = _sourceVersion;
        _sourceVersion = _targetVersion;
        _targetVersion = version;
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                return;
            }
            IMBMBFileRecord *record = sourceRecord;
            sourceRecord = targetRecord;
            targetRecord = record;
            
            NSString *backupPath = _sourceBackuppath;
            _sourceBackuppath = _targetBakcuppath;
            _targetBakcuppath = backupPath;
            
            NSString *sqlitePath = _sourceSqlitePath;
            _sourceSqlitePath = _targetSqlitePath;
            _targetSqlitePath = sqlitePath;
            
            NSMutableArray *recordArray = _sourcerecordArray;
            _sourcerecordArray = _targetrecordArray;
            _targetrecordArray = recordArray;
            
            FMDatabase *dataCo = _sourceManifestDBConnection;
            _sourceManifestDBConnection = _targetManifestDBConnection;
            _targetManifestDBConnection = dataCo;
            
            NSString *version = _sourceFloatVersion;
            _sourceFloatVersion = _targetFloatVersion;
            _targetFloatVersion = version;
        }else
        {
            if (!isneedClone) {
                return;
            }
        }
    }else
    {
        if (!isneedClone) {
            return;
        }
    }
    //开启数据库
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            [_logHandle writeInfoLog:@"insert ZCALLRECORDTocall enter"];
            [self openDataBase:_targetContactDBConnection];
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            [_targetContactDBConnection beginTransaction];
           
            [self deletecallData];
            if (_sourceVersion >= 8) {
                if (_targetVersion >= 8) {
                    [self insertZCALLRECORD];
                }else if (_targetVersion == 7) {
                    [self insertZCALLRECORDTocallWithiOS7];
                }else if (_targetVersion == 6)
                {
                    [self insertZCALLRECORDTocallWithiOS6];
                }else if (_targetVersion == 5)
                {
                    [self insertZCALLRECORDTocallWithiOS5];
                }
            }else
            {
                if (_targetVersion == 6||_targetVersion == 7)
                {
                    [self insertCallTocallWithiOS6];
                }else if (_targetVersion == 5)
                {
                    [self insertCallTocallWithiOS5];
                }
            }
            
            [_logHandle writeInfoLog:@"insert ZCALLRECORDTocall exit"];
        }
        if (![_sourceDBConnection commit]) {
            [_sourceDBConnection rollback];
        }
        if (![_targetDBConnection commit]) {
            [_targetDBConnection rollback];
        }
        if (![_targetContactDBConnection commit]) {
            [_targetContactDBConnection rollback];
        }

        [self closeDataBase:_sourceDBConnection];
        [self closeDataBase:_targetDBConnection];
        [self closeDataBase:_targetContactDBConnection];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [_logHandle writeInfoLog:@"clone callhistory exit"];
    //修改HashandManifest
    [self modifyHashAndManifest];
}

- (void)deletecallData
{
    NSString *sql = @"delete from call";
    [_targetDBConnection executeUpdate:sql];
}

- (void)insertZCALLRECORD
{
    //face_time_data
    NSString *sql1 = @"select * from ZCALLRECORD";
    NSString *sql2 = @"insert into ZCALLRECORD(Z_PK,ZADDRESS,ZDATE,ZDURATION,ZCALLTYPE,id,ZNAME,ZISO_COUNTRY_CODE,ZREAD,ZANSWERED) values(?,?,?,?,?,?,?,?,?,?)";
    NSString *sql10 = @"insert into ZCALLRECORD(Z_PK,ZADDRESS,ZDATE,ZDURATION,ZCALLTYPE,id,ZNAME,ZISO_COUNTRY_CODE,ZREAD,ZANSWERED,ZSERVICE_PROVIDER,ZCALL_CATEGORY,ZHANDLE_TYPE) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"Z_PK"];
        id address = [rs objectForColumnName:@"ZADDRESS"];
        if (_sourceVersion == 8) {
            if (_targetVersion >= 9) {
                address = [address dataUsingEncoding:NSUTF8StringEncoding];
            }
        }else
        {
            if (_targetVersion == 8) {
                address = [[[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding] autorelease];
            }
        }

        NSInteger date = [rs intForColumn:@"ZDATE"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *originDate = [dateFormatter dateFromString:@"2001-01-01 08:00:00"];
        if(originDate == nil || originDate == NULL) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            originDate = [dateFormatter dateFromString:@"2001-01-01 08:00:00"];
        }
        NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:date sinceDate:originDate] autorelease];
        NSInteger date1 = [returnDate timeIntervalSince1970];
        NSInteger duration = [rs intForColumn:@"ZDURATION"];
        NSInteger flags = [rs intForColumn:@"ZCALLTYPE"];
        NSInteger id1 = [self getContactMulitValueID:address];
        NSString *name = [rs stringForColumn:@"ZNAME"];
        NSString *country_code = [rs stringForColumn:@"ZISO_COUNTRY_CODE"];
        NSInteger read = [rs intForColumn:@"ZREAD"];
        //  NSInteger face_time_data = [rs intForColumn:@"ZFACE_TIME_DATA"];
        // NSData *faceData = [NSData dataWithBytes:&face_time_data length:sizeof(face_time_data)];
        NSInteger answered = [rs intForColumn:@"ZANSWERED"];

        if (_targetVersion>=10) {
            if (flags == 8) {
                 [_targetDBConnection executeUpdate:sql10,[NSNumber numberWithInt:ROWID],address,[NSNumber numberWithInt:date1],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:flags],[NSNumber numberWithInt:id1],name,country_code,[NSNumber numberWithInt:read],[NSNumber numberWithInt:answered],@"com.apple.FaceTime",@(2),@(2)];
            }else{
                [_targetDBConnection executeUpdate:sql10,[NSNumber numberWithInt:ROWID],address,[NSNumber numberWithInt:date1],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:flags],[NSNumber numberWithInt:id1],name,country_code,[NSNumber numberWithInt:read],[NSNumber numberWithInt:answered],@"com.apple.Telephony",@(1),@(2)];
            }
        }else{
             [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],address,[NSNumber numberWithInt:date1],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:flags],[NSNumber numberWithInt:id1],name,country_code,[NSNumber numberWithInt:read],[NSNumber numberWithInt:answered]];
        }
       
    }
    [rs close];
}


//表高ZCALLRECORD TO 底call
- (void)insertZCALLRECORDTocallWithiOS7
{
    //face_time_data
    NSString *sql1 = @"select * from ZCALLRECORD";
    NSString *sql2 = @"insert into call(ROWID,address,date,duration,flags,id,name,country_code,read,answered) values(?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"Z_PK"];
        id address = [rs objectForColumnName:@"ZADDRESS"];
        if ([address isKindOfClass:[NSData class]]){
            address = [[[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding] autorelease];
        }
        NSInteger date = [rs intForColumn:@"ZDATE"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *originDate = [dateFormatter dateFromString:@"2001-01-01 08:00:00"];
        if(originDate == nil || originDate == NULL) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            originDate = [dateFormatter dateFromString:@"2001-01-01 08:00:00"];
        }
        NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:date sinceDate:originDate] autorelease];
        NSInteger date1 = [returnDate timeIntervalSince1970];
        NSInteger duration = [rs intForColumn:@"ZDURATION"];
        NSInteger flags = [rs intForColumn:@"ZORIGINATED"];
        NSInteger id1 = [self getContactMulitValueID:address];
        NSString *name = [rs stringForColumn:@"ZNAME"];
        NSString *country_code = [rs stringForColumn:@"ZISO_COUNTRY_CODE"];
        NSInteger read = [rs intForColumn:@"ZREAD"];
      //  NSInteger face_time_data = [rs intForColumn:@"ZFACE_TIME_DATA"];
       // NSData *faceData = [NSData dataWithBytes:&face_time_data length:sizeof(face_time_data)];
        NSInteger answered = [rs intForColumn:@"ZANSWERED"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],address,[NSNumber numberWithInt:date1],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:flags],[NSNumber numberWithInt:id1],name,country_code,[NSNumber numberWithInt:read],[NSNumber numberWithInt:answered]];
    }
    [rs close];
}

- (void)insertZCALLRECORDTocallWithiOS6
{
    //face_time_data
    NSString *sql1 = @"select * from ZCALLRECORD";
    NSString *sql2 = @"insert into call(ROWID,address,date,duration,flags,id,name,country_code,read) values(?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"Z_PK"];
        id address = [rs objectForColumnName:@"ZADDRESS"];
        if ([address isKindOfClass:[NSData class]]){
            address = [[[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding] autorelease];
        }

        NSInteger date = [rs intForColumn:@"ZDATE"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *originDate = [dateFormatter dateFromString:@"2001-01-01 08:00:00"];
        if(originDate == nil || originDate == NULL) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            originDate = [dateFormatter dateFromString:@"2001-01-01 08:00:00"];
        }
        NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:date sinceDate:originDate] autorelease];
        NSInteger date1 = [returnDate timeIntervalSince1970];
        NSInteger duration = [rs intForColumn:@"ZDURATION"];
        NSInteger flags = [rs intForColumn:@"ZORIGINATED"];
        if (flags == 0) {
            flags = 4;
        }else if (flags == 1)
        {
            flags = 5;
        }
        NSInteger id1 = [self getContactMulitValueID:address];
        NSString *name = [rs stringForColumn:@"ZNAME"];
        NSString *country_code = [rs stringForColumn:@"ZISO_COUNTRY_CODE"];
        NSInteger read = [rs intForColumn:@"ZREAD"];
        //  NSInteger face_time_data = [rs intForColumn:@"ZFACE_TIME_DATA"];
        // NSData *faceData = [NSData dataWithBytes:&face_time_data length:sizeof(face_time_data)];
       // NSInteger answered = [rs intForColumn:@"ZANSWERED"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],address,[NSNumber numberWithInt:date1],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:flags],[NSNumber numberWithInt:id1],name,country_code,[NSNumber numberWithInt:read]];
    }
    [rs close];
}

- (void)insertZCALLRECORDTocallWithiOS5
{
    //face_time_data
    NSString *sql1 = @"select * from ZCALLRECORD";
    NSString *sql2 = @"insert into call(ROWID,address,date,duration,flags,id,name,country_code) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"Z_PK"];
        id address = [rs objectForColumnName:@"ZADDRESS"];
        if ([address isKindOfClass:[NSData class]]){
            address = [[[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding] autorelease];
        }

        NSInteger date = [rs intForColumn:@"ZDATE"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *originDate = [dateFormatter dateFromString:@"2001-01-01 08:00:00"];
        if(originDate == nil || originDate == NULL) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            originDate = [dateFormatter dateFromString:@"2001-01-01 08:00:00"];
        }
        NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:date sinceDate:originDate] autorelease];
        NSInteger date1 = [returnDate timeIntervalSince1970];
        NSInteger duration = [rs intForColumn:@"ZDURATION"];
        NSInteger flags = [rs intForColumn:@"ZCALLTYPE"];
        NSInteger id1 = [self getContactMulitValueID:address];
        NSString *name = [rs stringForColumn:@"ZNAME"];
        NSString *country_code = [rs stringForColumn:@"ZISO_COUNTRY_CODE"];
        //NSInteger read = [rs intForColumn:@"ZREAD"];
        //  NSInteger face_time_data = [rs intForColumn:@"ZFACE_TIME_DATA"];
        // NSData *faceData = [NSData dataWithBytes:&face_time_data length:sizeof(face_time_data)];
        // NSInteger answered = [rs intForColumn:@"ZANSWERED"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],address,[NSNumber numberWithInt:date1],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:flags],[NSNumber numberWithInt:id1],name,country_code];
    }
    [rs close];
}

- (void)insertCallTocallWithiOS6
{
    //face_time_data
    NSString *sql1 = @"select * from call";
    NSString *sql2 = @"insert into call(ROWID,address,date,duration,flags,id,name,country_code,network_code,read,assisted,face_time_data,originalAddress) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *address = [rs stringForColumn:@"address"];
        NSInteger date = [rs intForColumn:@"date"];
        NSInteger duration = [rs intForColumn:@"duration"];
        NSInteger flags = [rs intForColumn:@"flags"];
        NSInteger id1 = [self getContactMulitValueID:address];
        NSString *name = [rs stringForColumn:@"name"];
        NSString *country_code = [rs stringForColumn:@"country_code"];
        NSString *network_code = [rs stringForColumn:@"network_code"];
        NSInteger read = [rs intForColumn:@"read"];
        NSInteger assisted = [rs intForColumn:@"assisted"];
        NSData *face_time_data = [rs dataForColumn:@"face_time_data"];
        NSString *originalAddress = [rs stringForColumn:@"originalAddress"];
       
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],address,[NSNumber numberWithInt:date],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:flags],[NSNumber numberWithInt:id1],name,country_code,network_code,[NSNumber numberWithInt:read],[NSNumber numberWithInt:assisted],face_time_data,originalAddress];
    }
    [rs close];
}

- (void)insertCallTocallWithiOS5
{
    //face_time_data
    NSString *sql1 = @"select * from call";
    NSString *sql2 = @"insert into call(ROWID,address,date,duration,flags,id,name,country_code,network_code) values(?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *address = [rs stringForColumn:@"address"];
        NSInteger date = [rs intForColumn:@"date"];
        NSInteger duration = [rs intForColumn:@"duration"];
        NSInteger flags = [rs intForColumn:@"flags"];
        NSInteger id1 = [self getContactMulitValueID:address];
        NSString *name = [rs stringForColumn:@"name"];
        NSString *country_code = [rs stringForColumn:@"country_code"];
        NSString *network_code = [rs stringForColumn:@"network_code"];
//        NSInteger read = [rs intForColumn:@"ZREAD"];
//        NSInteger assisted = [rs intForColumn:@"assisted"];
//        NSData *face_time_data = [rs dataForColumn:@"ZFACE_TIME_DATA"];
//        NSString *originalAddress = [rs stringForColumn:@"originalAddress"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],address,[NSNumber numberWithInt:date],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:flags],[NSNumber numberWithInt:id1],name,country_code,network_code];
    }
    [rs close];
}

- (int)getContactMulitValueID:(NSString *)address
{
    if ([address isKindOfClass:[NSData class]]) {
         address = [[[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding] autorelease];
    }
    NSInteger id1 = -1;
    NSString *substr = nil;
    if (address.length>4) {
        substr = [address substringFromIndex:address.length-4];
    }
    
    NSString *sql =  [@"select UID from ABMultiValue where value LIKE '%" stringByAppendingFormat:@"%@'",substr];
    FMResultSet *rs = [_targetContactDBConnection executeQuery:sql];
    while ([rs next]) {
        id1 = [rs intForColumn:@"UID"];
    }
    [rs close];
    return id1;
}

- (void)dealloc
{
    [_targetContactDBConnection release],_targetContactDBConnection = nil;
    [_contactRecord release],_contactRecord = nil;
    [_contactsqlitePath release],_contactsqlitePath = nil;
    [super dealloc];
}
@end

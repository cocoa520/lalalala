//
//  IMBCallLOgToiOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBCallLogToiOS.h"
@implementation IMBCallLogToiOS

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
            if (_sourceSqlitePath != nil) {
                _sourceDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqlitePath];

            }
            if (_targetSqlitePath != nil) {
                _targetDBConnection = [[FMDatabase alloc] initWithPath:_targetSqlitePath];
            }
            if (_sourceSqlitePath == nil) {
                [_logHandle writeInfoLog:@"highSqlitePath is empty"];
            }
            if (_targetSqlitePath == nil) {
                [_logHandle writeInfoLog:@"lowSqlitePath is empty"];
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

- (void)merge:(NSArray *)dataArray
{
    @try {
        if ([self openDataBase:_targetDBConnection]) {
            [_targetDBConnection beginTransaction];
            for (IMBCallContactModel *item in dataArray) {
                    for (IMBCallHistoryDataEntity *entity in item.callHistoryList) {
                            if (_targetVersion >= 8.0) {
                                [self insertDataToHight:entity withTargetFmdb:_targetDBConnection];
                            }else {
                                
                                [self insertDataToLow:entity withTargetFmdb:_targetDBConnection];
                            }
                    }
            }
            if (_targetVersion >= 8.0) {
                NSString *cmd = @"update Z_PRIMARYKEY set Z_MAX=(select count(*) from ZCALLRECORD) where Z_NAME='CallRecord'";
                [_targetDBConnection executeUpdate:cmd];
            }else {
                [self updateCallId:_targetDBConnection];
            }
            if (![_targetDBConnection commit]){
                [_targetDBConnection rollback];
            }
            [self closeDataBase:_targetDBConnection];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"----Error----:Merge IMBCallLogToiOS error:%@", exception]];
    }
    @finally {
        
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

- (void)insertDataToHight:(IMBCallHistoryDataEntity *)entity withTargetFmdb:(FMDatabase *)targetFMDB {
    NSString *IOS8InsertStr = @"insert into zcallrecord( Z_ENT, Z_OPT, ZANSWERED, ZCALLTYPE, ZDISCONNECTED_CAUSE, ZNUMBER_AVAILABILITY, ZORIGINATED, ZREAD, ZDATE, ZFACE_TIME_DATA,ZDURATION, ZADDRESS, ZDEVICE_ID, ZISO_COUNTRY_CODE, ZNAME, ZUNIQUE_ID) values(:Z_ENT, :Z_OPT, :ZANSWERED, :ZCALLTYPE, :ZDISCONNECTED_CAUSE, :ZNUMBER_AVAILABILITY, :ZORIGINATED, :ZREAD, :ZDATE, :ZFACE_TIME_DATA, :ZDURATION, :ZADDRESS, :ZDEVICE_ID, :ZISO_COUNTRY_CODE, :ZNAME, :ZUNIQUE_ID)";
    NSString *IOS10InsertStr = @"insert into zcallrecord(Z_ENT, Z_OPT, ZANSWERED, ZCALLTYPE, ZDISCONNECTED_CAUSE, ZNUMBER_AVAILABILITY, ZORIGINATED, ZREAD, ZDATE, ZFACE_TIME_DATA,ZDURATION, ZADDRESS, ZDEVICE_ID, ZISO_COUNTRY_CODE, ZNAME, ZUNIQUE_ID,ZSERVICE_PROVIDER,ZCALL_CATEGORY,ZHANDLE_TYPE) values(:Z_ENT, :Z_OPT, :ZANSWERED, :ZCALLTYPE, :ZDISCONNECTED_CAUSE, :ZNUMBER_AVAILABILITY, :ZORIGINATED, :ZREAD, :ZDATE, :ZFACE_TIME_DATA, :ZDURATION, :ZADDRESS, :ZDEVICE_ID, :ZISO_COUNTRY_CODE, :ZNAME, :ZUNIQUE_ID,:ZSERVICE_PROVIDER,:ZCALL_CATEGORY,:ZHANDLE_TYPE)";
    
    
    NSString *entCmd = @"select Z_ENT from Z_PRIMARYKEY where Z_NAME='CallRecord'";
    FMResultSet *rs = [targetFMDB executeQuery:entCmd];
    int z_ent = 0;
    while ([rs next]) {
        z_ent = [rs intForColumn:@"Z_ENT"];
    }
    [rs close];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInt:z_ent] forKey:@"Z_ENT"];
    [paramDic setObject:[NSNumber numberWithInt:2] forKey:@"Z_OPT"];
    [paramDic setObject:[NSNumber numberWithInt:entity.answered] forKey:@"ZANSWERED"];
    [paramDic setObject:[NSNumber numberWithInt:entity.flags] forKey:@"ZCALLTYPE"];
    [paramDic setObject:[NSNull null] forKey:@"ZDISCONNECTED_CAUSE"];
    [paramDic setObject:[NSNull null] forKey:@"ZNUMBER_AVAILABILITY"];
    [paramDic setObject:[NSNumber numberWithInt:entity.zoriginated] forKey:@"ZORIGINATED"];
    [paramDic setObject:[NSNumber numberWithInt:entity.read] forKey:@"ZREAD"];
    [paramDic setObject:[NSNull null] forKey:@"ZFACE_TIME_DATA"];
    //时间从2001年开始
    if ((entity.date/1000.0)>[DateHelper getTimeIntervalSince2001:[NSDate date]]) {
        //从1970年开始
        [paramDic setObject:[NSNumber numberWithLongLong:[DateHelper timeIntervalFrom1970To2001:entity.date/1000.0]] forKey:@"ZDATE"];
    }else{
        //从2001年开始
        [paramDic setObject:[NSNumber numberWithLongLong:entity.date/1000.0] forKey:@"ZDATE"];
    
    }
    [paramDic setObject:[NSNumber numberWithInt:entity.duration] forKey:@"ZDURATION"];

    if (_targetVersion >= 9) {
        NSData* xmlData = [entity.address dataUsingEncoding:NSUTF8StringEncoding];
        [paramDic setObject:xmlData?:[NSNull null] forKey:@"ZADDRESS"];
    }else{
        [paramDic setObject:entity.address?:[NSNull null] forKey:@"ZADDRESS"];
    }
    
    [paramDic setObject:[NSNull null] forKey:@"ZDEVICE_ID"];
    [paramDic setObject:entity.countryCode?:[NSNull null] forKey:@"ZISO_COUNTRY_CODE"];
    [paramDic setObject:[NSNull null] forKey:@"ZNAME"];
    [paramDic setObject:[self createGUID] forKey:@"ZUNIQUE_ID"];
    if (_targetVersion >= 10) {
        if (entity.flags == 8) {
            [paramDic setObject:@"com.apple.FaceTime" forKey:@"ZSERVICE_PROVIDER"];
            [paramDic setObject:@(2) forKey:@"ZCALL_CATEGORY"];
            
        }else{
            [paramDic setObject:@"com.apple.Telephony" forKey:@"ZSERVICE_PROVIDER"];
            [paramDic setObject:@(1) forKey:@"ZCALL_CATEGORY"];
            
        }
        [paramDic setObject:@(2) forKey:@"ZHANDLE_TYPE"];
        if ([targetFMDB executeUpdate:IOS10InsertStr withParameterDictionary:paramDic]) {
            _succesCount += 1;
        }
    }else{
        if ([targetFMDB executeUpdate:IOS8InsertStr withParameterDictionary:paramDic]) {
            _succesCount += 1;
        }
    }
}

- (void)insertDataToLow:(IMBCallHistoryDataEntity *)entity withTargetFmdb:(FMDatabase *)targetFMDB{

    
    NSString *insertCmd = @"";
    if (_targetVersion>7.0) {
        insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code, read, assisted,face_time_data,answered) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code, :read, :assisted, :face_time_data, :answered)";
    }else if (_targetVersion == 6||_targetVersion==7) {
        insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code, read, assisted,face_time_data) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code, :read, :assisted, :face_time_data)";
    }else if (_targetVersion == 5) {
        insertCmd = @"insert into call(address, date, duration, flags, id, name, country_code, network_code) values(:address, :date, :duration, :flags, :id, :name, :country_code, :network_code)";
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:entity.address?:[NSNull null] forKey:@"address"];
    
    //时间从1970年开始
    if ((entity.date/1000.0)>[DateHelper getTimeIntervalSince2001:[NSDate date]]) {
        //从1970年开始
        [paramDic setObject:[NSNumber numberWithLongLong:entity.date/1000.0] forKey:@"date"];
    }else{
        //从2001年开始
        [paramDic setObject:[NSNumber numberWithLongLong:[DateHelper timeIntervalFrom2001To1970:entity.date/1000.0]] forKey:@"date"];
    }
    [paramDic setObject:[NSNumber numberWithInt:entity.duration] forKey:@"duration"];
    [paramDic setObject:[NSNumber numberWithDouble:entity.flags] forKey:@"flags"];
    
    [paramDic setObject:@(-1) forKey:@"id"];
    [paramDic setObject:[NSNull null] forKey:@"name"];
    [paramDic setObject:[NSNull null] forKey:@"country_code"];
    [paramDic setObject:@"00" forKey:@"network_code"];
    if (_targetVersion >5) {
        [paramDic setObject:[NSNull null] forKey:@"face_time_data"];
        [paramDic setObject:[NSNumber numberWithInt:0] forKey:@"assisted"];
        [paramDic setObject:[NSNumber numberWithInt:entity.read] forKey:@"read"];
    }
    //todo 待测试
    if (_targetVersion>7) {
        [paramDic setObject:[NSNumber numberWithInt:entity.answered] forKey:@"answered"];

    }
    if ([targetFMDB executeUpdate:insertCmd withParameterDictionary:paramDic]) {
        _succesCount += 1;
    }
    [paramDic release];
}

- (void)updateCallId:(FMDatabase *)targetFMDB {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([self openDataBase:_targetContactDBConnection]) {
        NSString *strCmd = @"SELECT ROWID, address, id FROM call";
        FMResultSet *rs = [targetFMDB executeQuery:strCmd];
        while ([rs next]) {
            int rowid = [rs intForColumn:@"ROWID"];
            NSString *phoneNumber = [rs stringForColumn:@"address"];
            if (phoneNumber.length > 4) {
                phoneNumber = [phoneNumber substringFromIndex:(phoneNumber.length - 4)];
            }
            if (phoneNumber.length>0) {
                NSString *conCmd = @"SELECT record_id FROM ABMultiValue where value like '%:PhoneLastFour'";
                NSDictionary *parma = [NSDictionary dictionaryWithObjectsAndKeys:
                                       phoneNumber, @"PhoneLastFour",
                                       nil];
                FMResultSet *rs1 = [_targetContactDBConnection executeQuery:conCmd withParameterDictionary:parma];
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
        [self closeDataBase:_targetContactDBConnection];
    }
    if (dic.allKeys.count > 0) {
        @try {
            for (NSNumber *item in dic.allKeys) {
                NSString *cmd = @"update call set id=:id where rowid=:rowid";
                NSDictionary *prama = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:item], @"id", item, @"rowid", nil];
                [targetFMDB executeUpdate:cmd withParameterDictionary:prama];
            }
        }
        @catch (NSException *ex)
        {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"----error----:%@", ex]];
        }
    }
}

- (void)dealloc
{
    [_targetContactDBConnection release],_targetContactDBConnection = nil;
    [_contactRecord release],_contactRecord = nil;
    [_contactsqlitePath release],_contactsqlitePath = nil;
    [super dealloc];
}
@end

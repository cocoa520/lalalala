//
//  IMBCallHistorySqliteManager.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCallHistorySqliteManager.h"
#import "IMBBackupManager.h"
#import "NSString+Category.h"
#import "IMBCallHistoryDataEntity.h"
#import "DateHelper.h"
#import "TempHelper.h"
#import "StringHelper.h"
@implementation IMBCallHistorySqliteManager
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        _backUpPath = [backupfilePath retain];
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        NSString *sqliteStr = nil;
        if ([_iOSVersion isVersionMajorEqual:@"8"]) {
            isMajoriOS8 = YES;
            sqliteStr = @"CallHistory.storedata";
            if (isEncrypted) {
                [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/CallHistoryDB/CallHistory.storedata"];
                manager.backUpPath = decypt.outputPath;
                if (_backUpPath != nil) {
                    [_backUpPath release];
                    _backUpPath = nil;
                }
                _backUpPath = [decypt.outputPath retain];
            }
        }else{
            if (isEncrypted) {
                [decypt decryptSingleFile:@"WirelessDomain" withFilePath:@"Library/CallHistory/call_history.db"];
                manager.backUpPath = decypt.outputPath;
                if (_backUpPath != nil) {
                    [_backUpPath release];
                    _backUpPath = nil;
                }
                _backUpPath = [decypt.outputPath retain];
            }
            sqliteStr = @"call_history.db";
        }
        NSString *sqliteddPath = [manager copysqliteToApptempWithsqliteName:sqliteStr backupfilePath:_backUpPath];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        _contactManager = [[IMBContactBaseInfoManager alloc]initWithManifestManager:backupfilePath WithisEncrypted:isEncrypted withBackUpDecrypt:decypt];
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
        NSString *sqliteStr = nil;
        if ([[IMBSqliteManager getBackupFileFloatVersion:backupfilePath] isVersionMajorEqual:@"8"]) {
            isMajoriOS8 = YES;
            sqliteStr = @"CallHistory.storedata";
        }else{
            sqliteStr = @"call_history.db";
        }
        NSString *sqliteddPath = [self copysqliteToApptempWithsqliteName:sqliteStr backupfilePath:backupfilePath recordArray:recordArray];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        _contactManager = [[IMBContactBaseInfoManager alloc]initWithManifestManager:backupfilePath WithisEncrypted:NO withBackUpDecrypt:nil];
    }
    return self;
}


- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
        //        NSString *sqlPath = [IMBHelper getSoftwareBackupFolderPath:@"iCloud" withUuid:iCloudBackup.uuid];
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
            isMajoriOS8 = YES;
            NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/CallHistoryDB/CallHistory.storedata"];
            if ([fm fileExistsAtPath:dbNPath]) {
                _databaseConnection = [[FMDatabase alloc] initWithPath:dbNPath];
            }
        }else{
            //遍历需要的文件，然后拷贝到指定的目录下
            NSPredicate *pre = nil;
            if ([_iOSVersion isVersionMajorEqual:@"8"]) {
                 isMajoriOS8 = YES;
                pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/CallHistoryDB/CallHistory.storedata"];
            }else {
                isMajoriOS8 = NO;
                pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"WirelessDomain", @"Library/CallHistory/call_history.db"];
            }
            
            NSArray *tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            IMBiCloudFileInfo *callHistory = nil;
            if (tmpArray != nil && tmpArray.count > 0) {
                callHistory = [tmpArray objectAtIndex:0];
            }
            
            if (callHistory != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (callHistory.fileName.length > 2) {
                        fd = [callHistory.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:callHistory.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:callHistory.fileName];
                }
//                NSString *filePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:callHistory.fileName];
                if (sourcefilePath != nil) {
                    _databaseConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }

        }
        
        _contactManager = [[IMBContactBaseInfoManager alloc] initWithiCloudBackup:iCloudBackup];
    }
    return self;
}


#pragma mark - 查询数据库方法
- (void)querySqliteDBContent {
    [_logManger writeInfoLog:@"query CallHistoryDB Content Begin"];
    if ([self openDataBase]) {
        if (isMajoriOS8) {
            NSString *selectCmd = @"SELECT  Z_PK, Z_ENT, Z_OPT, ZANSWERED, ZCALLTYPE, ZFACE_TIME_DATA, ZNUMBER_AVAILABILITY, ZORIGINATED, ZREAD, ZDATE, ZDURATION, ZADDRESS, ZISO_COUNTRY_CODE, ZUNIQUE_ID FROM ZCALLRECORD ORDER BY Z_PK;";
            FMResultSet *rs = [_databaseConnection executeQuery:selectCmd];
            IMBCallHistoryDataEntity *callHistory = nil;
            while ([rs next]) {
                @autoreleasepool {
                    callHistory = [[IMBCallHistoryDataEntity alloc] init];
                    [callHistory setCheckState:UnChecked];
                    if (![rs columnIsNull:@"Z_PK"]) {
                        [callHistory setRowid:[rs intForColumn:@"Z_PK"]];
                    } else {
                        [callHistory setRowid:0];
                    }
                    if (![rs columnIsNull:@"ZADDRESS"]) {
                        if ([_iOSVersion isVersionMajorEqual:@"9"]) {
                            NSData *data = [rs dataForColumn:@"ZADDRESS"];
                            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            [callHistory setAddress:str];
                            [str release];
                            str = nil;
                        }else {
                            [callHistory setAddress:[rs stringForColumn:@"ZADDRESS"]];
                        }
                    } else {
                        [callHistory setAddress:@""];
                    }
                    if (![rs columnIsNull:@"ZDATE"]) {
                        [callHistory setDate:[rs doubleForColumn:@"ZDATE"]];
                        [callHistory setDateStr:[DateHelper dateFrom2001ToString:callHistory.date withMode:2]];
                        [callHistory setCallDateStr:[DateHelper dateFrom2001ToString:callHistory.date withMode:1]];
                        [callHistory setCallTimeStr:[DateHelper dateFrom2001ToString:callHistory.date withMode:6]];
                    } else {
                        [callHistory setDate:0];
                    }
                    if (![rs columnIsNull:@"ZDURATION"]) {
                        [callHistory setDuration:([rs doubleForColumn:@"ZDURATION"] * 1000)];
                    } else {
                        [callHistory setDuration:0];
                    }
                    
                    if (![rs columnIsNull:@"ZCALLTYPE"]) {
                        [callHistory setFlags:[rs intForColumn:@"ZCALLTYPE"]];
                    } else {
                        [callHistory setFlags:0];
                    }
                    if (![rs columnIsNull:@"ZANSWERED"]) {
                        [callHistory setAnswered:[rs intForColumn:@"ZANSWERED"]];
                    } else {
                        [callHistory setAnswered:0];
                    }
                    if (![rs columnIsNull:@"ZFACE_TIME_DATA"]) {
                        [callHistory setFaceTimeData:[rs intForColumn:@"ZFACE_TIME_DATA"]];
                    } else {
                        [callHistory setFaceTimeData:0];
                    }
                    if (![rs columnIsNull:@"ZNUMBER_AVAILABILITY"]) {
                        [callHistory setZunmber_availa:[rs intForColumn:@"ZNUMBER_AVAILABILITY"]];
                    } else {
                        [callHistory setZunmber_availa:0];
                    }
                    if (![rs columnIsNull:@"ZORIGINATED"]) {
                        [callHistory setZoriginated:[rs intForColumn:@"ZORIGINATED"]];
                    } else {
                        [callHistory setZoriginated:0];
                    }
                    if (![rs columnIsNull:@"ZREAD"]) {
                        [callHistory setRead:[rs intForColumn:@"ZREAD"]];
                    } else {
                        [callHistory setRead:0];
                    }
                    if (![rs columnIsNull:@"ZISO_COUNTRY_CODE"]) {
                        [callHistory setCountryCode:[rs stringForColumn:@"ZISO_COUNTRY_CODE"]];
                    } else {
                        [callHistory setCountryCode:@""];
                    }
                    if (![rs columnIsNull:@"ZUNIQUE_ID"]) {
                        [callHistory setZunique_id:[rs stringForColumn:@"ZUNIQUE_ID"]];
                    } else {
                        [callHistory setZunique_id:@""];
                    }
                    [self getCallHistoryNewFlags:callHistory];
                    [callHistory setContactID:-1];
//                    [_dataAry addObject:callHistory];
                    //todo
                    [self setCallContactModle:callHistory withIsDeleted:NO];
                    [callHistory release];
                    callHistory = nil;
                }
            }
            [rs close];
        }else {
            int sourceNum = [TempHelper getDeviceVersionNumber:_iOSVersion];
            NSString *selectCmd = @"";
            if (sourceNum == 7) {
                selectCmd = @"SELECT ROWID, address, date, duration, flags, id, country_code, read, face_time_data, answered FROM call ORDER BY id";
            }else if (sourceNum == 6) {
                selectCmd= @"SELECT ROWID, address, date, duration, flags, id, country_code, read, face_time_data FROM call ORDER BY id";
            }else if (sourceNum == 5) {
                selectCmd = @"SELECT ROWID, address, date, duration, flags, id, country_code FROM call ORDER BY id";
            }
            FMResultSet *rs = [_databaseConnection executeQuery:selectCmd];
            IMBCallHistoryDataEntity *callHistory = nil;
            while ([rs next]) {
                @autoreleasepool {
                    callHistory = [[IMBCallHistoryDataEntity alloc] init];
                    if (![rs columnIsNull:@"ROWID"]) {
                        [callHistory setRowid:[rs intForColumn:@"ROWID"]];
                    }else {
                        [callHistory setRowid:0];
                    }
                    if (![rs columnIsNull:@"address"]) {
                        [callHistory setAddress:[rs stringForColumn:@"address"]];
                    }else {
                        [callHistory setAddress:@""];
                    }
                    if (![rs columnIsNull:@"date"]) {
                        [callHistory setDate:[rs doubleForColumn:@"date"]];//未加时区
                        [callHistory setDateStr:[DateHelper dateFrom1970ToString:callHistory.date withMode:4]];
                        [callHistory setCallDateStr:[DateHelper dateFrom2001ToString:callHistory.date withMode:1]];
                        [callHistory setCallTimeStr:[DateHelper dateFrom2001ToString:callHistory.date withMode:6]];
                    }else {
                        [callHistory setDate:0];
                    }
                    if (![rs columnIsNull:@"duration"]) {
                        [callHistory setDuration:([rs doubleForColumn:@"duration"] * 1000)];
                    }else {
                        [callHistory setDuration:0];
                    }
                    
                    
                    if (![rs columnIsNull:@"flags"]) {
                        [callHistory setFlags:[rs intForColumn:@"flags"]];
                    }else {
                        [callHistory setFlags:0];
                    }
                    if (![rs columnIsNull:@"id"]) {
                        [callHistory setContactID:[rs intForColumn:@"id"]];
                    }else {
                        [callHistory setContactID:0];
                    }
                    if (![rs columnIsNull:@"country_code"]) {
                        [callHistory setCountryCode:[self countryCodeLowToHight:[rs intForColumn:@"country_code"]]];
                    }else {
                        [callHistory setCountryCode:@""];
                    }
                    if (sourceNum >= 6) {
                        [callHistory setRead:[rs intForColumn:@"read"]];
                        NSData *facetime = [rs dataForColumn:@"face_time_data"];
                        int faceSize = 0;
                        if (facetime != nil) {
                            [facetime getBytes:&faceSize length:sizeof(faceSize)];
                        }
                        [callHistory setFaceTimeData:faceSize];
                    }
                    if (sourceNum >= 7) {
                        [callHistory setAnswered:[rs intForColumn:@"answered"]];
                    }
                    [self getCallingHistroyCallingTypeByCallHistory:callHistory];
                    //todo
                    [self setCallContactModle:callHistory withIsDeleted:NO];
                    [callHistory release];
                    callHistory = nil;

                }
            }
            [rs close];
        }
        
        [self closeDataBase];
    }
    

    //todo
    //排序
//    [self sortResultArray];

    [_logManger writeInfoLog:@"query CallHistoryDB Content End"];
}

- (void)getCallHistoryNewFlags:(IMBCallHistoryDataEntity *)callingHistory {
    BOOL isFaceTime = callingHistory.flags == 8 ? true : false;
    if (callingHistory.zoriginated == 0 && callingHistory.answered == 0)
    {
        //取消的通话
        callingHistory.callType = isFaceTime ? CallingMissedFacetime : CallingMissed;
    }
    else if (callingHistory.zoriginated == 0 && callingHistory.answered == 1)
    {
        //接听电话
        callingHistory.callType = isFaceTime ? CallingReceiveFacetime : CallingReceive;
    }
    else if (callingHistory.zoriginated == 1 && callingHistory.answered == 0)
    {
        //播出电话
        callingHistory.callType = isFaceTime ? CallingCallFacetime : CallingCall;
    }
}

- (void)getCallingHistroyCallingTypeByCallHistory:(IMBCallHistoryDataEntity *)callingHistory {
    int flags = callingHistory.flags & 0xffff;
    switch (flags) {
        case 4:
        case 0: {
            if (callingHistory.duration == 0) {
                //未接电话
                callingHistory.callType = CallingMissed;
            } else {
                //接电话
                callingHistory.callType = CallingReceive;
            }
            break;
        }
        case 5:
        case 9:
        case 1:
        {
            if (callingHistory.duration == 0) {
                //取消拨出电话
                callingHistory.callType = CallingCanceled;
            } else {
                //拨出电话
                callingHistory.callType = CallingCall;
            }
            break;
        }
        case 16:
        case 20:
            //ios7 接受电话
        case 64:
        {
            if (callingHistory.duration == 0){
                callingHistory.callType = CallingMissedFacetime;
            }
            else {
                callingHistory.callType = CallingReceiveFacetime;
            }
            break;
        }
        case 17:
        case 21:
            //ios7 播出facetime电话
        case 65:
        {
            if (callingHistory.duration == 0){
                callingHistory.callType = CallingCanceledFacetime;
            }
            else {
                callingHistory.callType = CallingCallFacetime;
            }
            break;
        }
        default: {
            callingHistory.callType = CallingCall;
            break;
        }
    }
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

- (void)setCallContactModle:(IMBCallHistoryDataEntity *)callHistory withIsDeleted:(BOOL)isDeleted {
    NSString *displayName = [_contactManager getDisplayNameByRecordID:callHistory.contactID addressValue:callHistory.address];
    if ([displayName isEqualToString:CustomLocalizedString(@"contact_id_48", nil)]) {
        displayName = callHistory.address;
    }
    [callHistory setName:displayName];
    IMBCallContactModel *callContact = nil;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [((IMBCallContactModel *)evaluatedObject).contactName isEqualToString:displayName];
    }];
    NSArray *tmpArray = [_dataAry filteredArrayUsingPredicate:pre];
    if (tmpArray != nil && tmpArray.count > 0) {
        callContact = [tmpArray objectAtIndex:0];
    }
    if (callContact == nil) {
        callContact = [[IMBCallContactModel alloc] init];
        [callContact setIsDeleted:isDeleted];
        [callContact setContactName:displayName];
        [callContact setSortStr:[StringHelper getStringFirstWord:callContact.contactName]];
        //        [callContact.callHistoryList addObject:callHistory];
        [callContact.callHistoryList insertObject:callHistory atIndex:0];
        
        if (callHistory.date > 0 && callHistory.date > callContact.lastcalldate) {
            callContact.lastcalldate = callHistory.date;
        }
        [callContact setCallHistoryCount:(callContact.callHistoryCount + 1)];

        //        [_reslutEntity.reslutArray addObject:callContact];
        if (![StringHelper stringIsNilOrEmpty:callContact.contactName]) {
            [_dataAry insertObject:callContact atIndex:0];
        }
        
        [callContact release];
        callContact = nil;
    }else {
        [callContact setCallHistoryCount:(callContact.callHistoryCount + 1)];
        callContact.selectedCount += 1;
        //        [callContact.callHistoryList addObject:callHistory];
        [callContact.callHistoryList insertObject:callHistory atIndex:0];
    }
}


@end

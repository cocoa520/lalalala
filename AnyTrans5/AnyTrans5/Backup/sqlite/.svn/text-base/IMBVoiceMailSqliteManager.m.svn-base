//
//  IMBVoiceMailSqliteManager.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBVoiceMailSqliteManager.h"
#import "IMBBackupManager.h"
#import "IMBVoiceMailEntity.h"
#import "DateHelper.h"
#import "StringHelper.h"

@implementation IMBVoiceMailSqliteManager

- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        _backUpPath = [backupfilePath retain];
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        manager.iosVersion = type;
        if (isEncrypted) {
            [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/Voicemail"];
            manager.backUpPath = decypt.outputPath;
            if (_backUpPath != nil) {
                [_backUpPath release];
                _backUpPath = nil;
            }
            _backUpPath = [decypt.outputPath retain];
        }
        NSString *sqliteddPath = [manager copysqliteToApptempWithsqliteName:@"voicemail.db" backupfilePath:_backUpPath];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        _contactManager = [[IMBContactBaseInfoManager alloc]initWithManifestManager:backupfilePath WithisEncrypted:isEncrypted withBackUpDecrypt:decypt];
    }
    return self;
}

- (id)initWithBackupfilePath:(NSString *)backupfilePath recordArray:(NSMutableArray *)recordArray
{
    if (self = [super init]) {
        _dataAry = [[NSMutableArray alloc] init];
        _backUpPath = [backupfilePath retain];
        NSString *sqliteddPath = [self copysqliteToApptempWithsqliteName:@"voicemail.db" backupfilePath:_backUpPath recordArray:recordArray];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        _contactManager = [[IMBContactBaseInfoManager alloc]initWithManifestManager:backupfilePath WithisEncrypted:NO withBackUpDecrypt:nil];
    }
    return self;
}

- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
            NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/Voicemail/voicemail.db"];
            if ([fm fileExistsAtPath:dbNPath]) {
                _databaseConnection = [[FMDatabase alloc] initWithPath:dbNPath];
            }
        }else{
            //遍历需要的文件，然后拷贝到指定的目录下
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/Voicemail/voicemail.db"];
            NSArray *tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            IMBiCloudFileInfo *voiceMailFile = nil;
            if (tmpArray != nil && tmpArray.count > 0) {
                voiceMailFile = [tmpArray objectAtIndex:0];
            }
            if (voiceMailFile != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (voiceMailFile.fileName.length > 2) {
                        fd = [voiceMailFile.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:voiceMailFile.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:voiceMailFile.fileName];
                }
//                NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:voiceMailFile.fileName];
                if (sourcefilePath != nil) {
                    _databaseConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }

        }
        _contactManager = [[IMBContactBaseInfoManager alloc] initWithiCloudBackup:iCloudBackup];
    }
    return self;
}


- (void)querySqliteDBContent {
    
    [_logManger writeInfoLog:@"query VoiceMail Datas Begin"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if ([self openDataBase]) {
        [_logManger writeInfoLog:@"Begin query Voice Data"];
        FMResultSet *rs =[_databaseConnection executeQuery:@"SELECT * FROM voicemail"];
        while ([rs next]) {
            @autoreleasepool {
                IMBVoiceMailEntity *voiceEntity = [[IMBVoiceMailEntity alloc] init];
                [voiceEntity setCheckState:UnChecked];
                voiceEntity.rowid = [rs intForColumn:@"ROWID"];
                voiceEntity.remoteUid = [rs intForColumn:@"remote_uid"];
                voiceEntity.date = [rs longLongIntForColumn:@"date"];
                voiceEntity.dateStr = [DateHelper dateFrom1970ToString:(long)voiceEntity.date withMode:2];
                voiceEntity.token = [rs stringForColumn:@"token"];
                voiceEntity.sender = [rs stringForColumn:@"sender"];
                voiceEntity.callbackNum = [rs stringForColumn:@"callback_num"];
                voiceEntity.duration = [rs intForColumn:@"duration"];
                voiceEntity.expiration = [rs intForColumn:@"expiration"];
                voiceEntity.trashedDate = [rs longLongIntForColumn:@"trashed_date"];
                voiceEntity.flags = [rs intForColumn:@"flags"];
                if (voiceEntity.flags == 2) {
                    voiceEntity.stateStr = CustomLocalizedString(@"common_id_12", nil);
                }else if (voiceEntity.flags == 3) {
                    voiceEntity.stateStr = CustomLocalizedString(@"Common_id_11", nil);
                }else {
                    voiceEntity.stateStr = CustomLocalizedString(@"Common_id_11", nil);
                }
       
                IMBBackupManager *backupmanager = [IMBBackupManager shareInstance];
               
                NSString *path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.remoteUid] stringByAppendingPathExtension:@"amr"]];
                IMBMBFileRecord *fr = [backupmanager getDBFileRecord:@"HomeDomain" path:path];
                if (fr == nil) {
                    path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.rowid] stringByAppendingPathExtension:@"amr"]];
                    fr = [backupmanager getDBFileRecord:@"HomeDomain" path:path];
                }
                if (fr != nil) {
                    NSString *filePath = nil;
                    if ([_iOSVersion isVersionMajorEqual:@"10"]) {
                        NSString *fd = @"";
                        if (fr.key.length > 2) {
                            fd = [fr.key substringWithRange:NSMakeRange(0, 2)];
                        }
                        filePath = [[_backupPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:fr.key];
                    }else {
                        filePath = [_backupPath stringByAppendingPathComponent:fr.key];
                    }
                    voiceEntity.path = filePath;
                    if (![fm fileExistsAtPath:voiceEntity.path]) {
                        if ([_iOSVersion isVersionMajorEqual:@"10"]) {
                            NSString *fd = @"";
                            if (fr.key.length > 2) {
                                fd = [fr.key substringWithRange:NSMakeRange(0, 2)];
                            }
                            voiceEntity.path = [[_backUpPath stringByAppendingPathComponent:[fr.key substringWithRange:NSMakeRange(0, 2)]] stringByAppendingPathComponent:fr.key];
                            //                                    currentPath = [_manifestManager.deviceBackupFolderPath stringByAppendingPathComponent:fr.key];
                        }else{
                            voiceEntity.path = [[_backUpPath stringByAppendingPathComponent:[fr.key substringWithRange:NSMakeRange(0, 2)]] stringByAppendingPathComponent:fr.key];
                        }
//                        voiceEntity.path = [[_backUpPath stringByAppendingPathComponent:[fr.key substringWithRange:NSMakeRange(0, 2)]] stringByAppendingPathComponent:fr.key];
                    }
                    voiceEntity.size = fr.fileLength;
                    voiceEntity.voicemailRecord = fr;
                }else {
                    if (_iCloudBackup != nil) {
                        NSString *path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.remoteUid] stringByAppendingPathExtension:@"amr"]];
                        //遍历需要的文件，然后拷贝到指定的目录下
                        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", path];
                        NSArray *tmpArray = [_iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
                        IMBiCloudFileInfo *voicemomesFile = nil;
                        if (tmpArray != nil && tmpArray.count > 0) {
                            voicemomesFile = [tmpArray objectAtIndex:0];
                        }else {
                            path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.rowid] stringByAppendingPathExtension:@"amr"]];
                            pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", path];
                            tmpArray = [_iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
                            if (tmpArray != nil && tmpArray.count > 0) {
                                voicemomesFile = [tmpArray objectAtIndex:0];
                            }
                        }
                        if (voicemomesFile != nil) {
                            voiceEntity.path = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:voicemomesFile.fileName];
                            voiceEntity.size = voicemomesFile.fileSize;
                        }else {
                            path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.remoteUid] stringByAppendingPathExtension:@"amr"]];
                            voiceEntity.path = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:[@"HomeDomain" stringByAppendingPathComponent:path]];
                            if (![fm fileExistsAtPath:voiceEntity.path]) {
                                path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.rowid] stringByAppendingPathExtension:@"amr"]];
                                voiceEntity.path = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:[@"HomeDomain" stringByAppendingPathComponent:path]];
                            }
                            voiceEntity.size = [self getFileLength:voiceEntity.path];
                        }
                    }
                }
                if ([fm fileExistsAtPath:voiceEntity.path] && voiceEntity.duration > 0) {
                    voiceEntity.fileIsExist = YES;
                }
                IMBVoiceMailAccountEntity *accountEntity = nil;
                NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    return [((IMBVoiceMailAccountEntity *)evaluatedObject).senderStr isEqualToString:voiceEntity.sender];
                }];
                NSArray *tmpArray = [_dataAry filteredArrayUsingPredicate:pre];
                if (tmpArray != nil && tmpArray.count > 0) {
                    accountEntity = [tmpArray objectAtIndex:0];
                }
                if (accountEntity == nil) {
                    accountEntity = [[IMBVoiceMailAccountEntity alloc] init];
                    accountEntity.senderStr = voiceEntity.sender;
                    //匹配联系人
                    IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:voiceEntity.sender];
                    if (contactInfo != nil) {
                        [accountEntity setContactName:contactInfo.displayName];
                        [accountEntity setIconImage:contactInfo.image];
                    }else {
                        if (![StringHelper stringIsNilOrEmpty:voiceEntity.sender]) {
                            [accountEntity setContactName:voiceEntity.sender];
                        }else {
                            [accountEntity setContactName:CustomLocalizedString(@"Common_id_10", nil)];
                        }
                    }
                    [accountEntity.subArray addObject:voiceEntity];
                    [_dataAry addObject:accountEntity];
                    [accountEntity release];
                    [voiceEntity release];
                } else {
                    [accountEntity.subArray insertObject:voiceEntity atIndex:0];
                }
                
            }
        }
        [rs close];
        [self closeDataBase];
    }
    [_logManger writeInfoLog:@"query VoiceMail Datas End"];
}


- (void)querySqliteDBContentBackupPath:(NSString *)backupPath {
    if (_backupPath != nil) {
        [_backupPath release];
        _backupPath = nil;
    }
    _backupPath = [backupPath retain];
    [_logManger writeInfoLog:@"query VoiceMail Datas Begin"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if ([self openDataBase]) {
        [_logManger writeInfoLog:@"Begin query Voice Data"];
        FMResultSet *rs =[_databaseConnection executeQuery:@"SELECT * FROM voicemail"];
        while ([rs next]) {
            @autoreleasepool {
                IMBVoiceMailEntity *voiceEntity = [[IMBVoiceMailEntity alloc] init];
                [voiceEntity setCheckState:UnChecked];
                voiceEntity.rowid = [rs intForColumn:@"ROWID"];
                voiceEntity.remoteUid = [rs intForColumn:@"remote_uid"];
                voiceEntity.date = [rs longLongIntForColumn:@"date"];
                voiceEntity.dateStr = [DateHelper dateFrom1970ToString:(long)voiceEntity.date withMode:2];
                voiceEntity.token = [rs stringForColumn:@"token"];
                voiceEntity.sender = [rs stringForColumn:@"sender"];
                voiceEntity.callbackNum = [rs stringForColumn:@"callback_num"];
                voiceEntity.duration = [rs intForColumn:@"duration"];
                voiceEntity.expiration = [rs intForColumn:@"expiration"];
                voiceEntity.trashedDate = [rs longLongIntForColumn:@"trashed_date"];
                voiceEntity.flags = [rs intForColumn:@"flags"];
                if (voiceEntity.flags == 2) {
                    voiceEntity.stateStr = CustomLocalizedString(@"common_id_12", nil);
                }else if (voiceEntity.flags == 3) {
                    voiceEntity.stateStr = CustomLocalizedString(@"Common_id_11", nil);
                }else {
                    voiceEntity.stateStr = CustomLocalizedString(@"Common_id_11", nil);
                }
                
                IMBBackupManager *backupmanager = [IMBBackupManager shareInstance];
                
                NSString *path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.remoteUid] stringByAppendingPathExtension:@"amr"]];
                IMBMBFileRecord *fr = [backupmanager getDBFileRecord:@"HomeDomain" path:path];
                if (fr == nil) {
                    path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.rowid] stringByAppendingPathExtension:@"amr"]];
                    fr = [backupmanager getDBFileRecord:@"HomeDomain" path:path];
                }
                if (fr != nil) {
                    NSString *filePath = nil;
                    if ([_iOSVersion isVersionMajorEqual:@"10"]) {
                        NSString *fd = @"";
                        if (fr.key.length > 2) {
                            fd = [fr.key substringWithRange:NSMakeRange(0, 2)];
                        }
                        filePath = [[_backupPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:fr.key];
                    }else {
                        filePath = [_backupPath stringByAppendingPathComponent:fr.key];
                    }
                    voiceEntity.path = filePath;
                    if (![fm fileExistsAtPath:voiceEntity.path]) {
                        if ([_iOSVersion isVersionMajorEqual:@"10"]) {
                            NSString *fd = @"";
                            if (fr.key.length > 2) {
                                fd = [fr.key substringWithRange:NSMakeRange(0, 2)];
                            }
                            voiceEntity.path = [[_backUpPath stringByAppendingPathComponent:[fr.key substringWithRange:NSMakeRange(0, 2)]] stringByAppendingPathComponent:fr.key];
                            //                                    currentPath = [_manifestManager.deviceBackupFolderPath stringByAppendingPathComponent:fr.key];
                        }else{
                            voiceEntity.path = [[_backUpPath stringByAppendingPathComponent:[fr.key substringWithRange:NSMakeRange(0, 2)]] stringByAppendingPathComponent:fr.key];
                        }
                        //                        voiceEntity.path = [[_backUpPath stringByAppendingPathComponent:[fr.key substringWithRange:NSMakeRange(0, 2)]] stringByAppendingPathComponent:fr.key];
                    }
                    voiceEntity.size = fr.fileLength;
                    voiceEntity.voicemailRecord = fr;
                }else {
                    if (_iCloudBackup != nil) {
                        NSString *path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.remoteUid] stringByAppendingPathExtension:@"amr"]];
                        //遍历需要的文件，然后拷贝到指定的目录下
                        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", path];
                        NSArray *tmpArray = [_iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
                        IMBiCloudFileInfo *voicemomesFile = nil;
                        if (tmpArray != nil && tmpArray.count > 0) {
                            voicemomesFile = [tmpArray objectAtIndex:0];
                        }else {
                            path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.rowid] stringByAppendingPathExtension:@"amr"]];
                            pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", path];
                            tmpArray = [_iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
                            if (tmpArray != nil && tmpArray.count > 0) {
                                voicemomesFile = [tmpArray objectAtIndex:0];
                            }
                        }
                        if (voicemomesFile != nil) {
                            voiceEntity.path = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:voicemomesFile.fileName];
                            voiceEntity.size = voicemomesFile.fileSize;
                        }else {
                            path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.remoteUid] stringByAppendingPathExtension:@"amr"]];
                            voiceEntity.path = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:[@"HomeDomain" stringByAppendingPathComponent:path]];
                            if (![fm fileExistsAtPath:voiceEntity.path]) {
                                path = [@"Library/Voicemail/" stringByAppendingPathComponent:[[NSString stringWithFormat:@"%d",voiceEntity.rowid] stringByAppendingPathExtension:@"amr"]];
                                voiceEntity.path = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:[@"HomeDomain" stringByAppendingPathComponent:path]];
                            }
                            voiceEntity.size = [self getFileLength:voiceEntity.path];
                        }
                    }
                }
                if ([fm fileExistsAtPath:voiceEntity.path] && voiceEntity.duration > 0) {
                    voiceEntity.fileIsExist = YES;
                }
                IMBVoiceMailAccountEntity *accountEntity = nil;
                NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    return [((IMBVoiceMailAccountEntity *)evaluatedObject).senderStr isEqualToString:voiceEntity.sender];
                }];
                NSArray *tmpArray = [_dataAry filteredArrayUsingPredicate:pre];
                if (tmpArray != nil && tmpArray.count > 0) {
                    accountEntity = [tmpArray objectAtIndex:0];
                }
                if (accountEntity == nil) {
                    accountEntity = [[IMBVoiceMailAccountEntity alloc] init];
                    accountEntity.senderStr = voiceEntity.sender;
                    //匹配联系人
                    IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:voiceEntity.sender];
                    if (contactInfo != nil) {
                        [accountEntity setContactName:contactInfo.displayName];
                        [accountEntity setIconImage:contactInfo.image];
                    }else {
                        if (![StringHelper stringIsNilOrEmpty:voiceEntity.sender]) {
                            [accountEntity setContactName:voiceEntity.sender];
                        }else {
                            [accountEntity setContactName:CustomLocalizedString(@"Common_id_10", nil)];
                        }
                    }
                    [accountEntity.subArray addObject:voiceEntity];
                    [_dataAry addObject:accountEntity];
                    [accountEntity release];
                    [voiceEntity release];
                } else {
                    [accountEntity.subArray insertObject:voiceEntity atIndex:0];
                }
                
            }
        }
        [rs close];
        [self closeDataBase];
    }
    [_logManger writeInfoLog:@"query VoiceMail Datas End"];
}


//获取文件大小
- (long)getFileLength:(NSString*)filePath {
    long fileSize = 0;
    NSDictionary *fileInfo = [fm attributesOfItemAtPath:filePath error:nil];
    if (fileInfo != nil) {
        fileSize = [[fileInfo valueForKey:NSFileSize] longValue];
    }
    return fileSize;
}

- (void)dealloc {
    if (_contactManager != nil) {
        [_contactManager release];
        _contactManager = nil;
    }
    [super dealloc];
}

@end

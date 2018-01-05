//
//  IMBNoteSqliteManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-21.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBNoteSqliteManager.h"
#import "DateHelper.h"
#import "IMBNoteDataEntity.h"
#import "IMBBackupManager.h"
#import "StringHelper.h"
#import "NSString+Category.h"
#import "IMBZipHelper.h"
#import "IMBSMSChatDataEntity.h"
#import "MediaHelper.h"
#define DataBasePath    @"/Users/iMobie/Desktop/notes.sqlite"
@implementation IMBNoteSqliteManager
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        _backUpPath = [backupfilePath retain];
        _dbType = [self determineDatabase];
        NSString *sqlitePath = nil;
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        if (_dbType) {
            if (isEncrypted) {
                [decypt decryptDomainFile:@"AppDomainGroup-group.com.apple.notes"];
                [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/Notes"];
                manager.backUpPath = decypt.outputPath;
                if (_backUpPath != nil) {
                    [_backUpPath release];
                    _backUpPath = nil;
                }
                _backUpPath = [decypt.outputPath retain];
            }
            sqlitePath = @"NoteStore.sqlite";
        }else{
            if (isEncrypted) {
                 [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/Notes"];
                manager.backUpPath = decypt.outputPath;
                if (_backUpPath != nil) {
                    [_backUpPath release];
                    _backUpPath = nil;
                }
                _backUpPath = [decypt.outputPath retain];
            }
            sqlitePath = @"notes.sqlite";
            _isScanOldSql = YES;
        }
        NSString *sqliteddPath = @"";
        sqliteddPath = [manager copysqliteToApptempWithsqliteName:sqlitePath backupfilePath:_backUpPath];
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
        _dbType = [self determineDatabase];
        NSString *sqlitePath = nil;
        if (_dbType) {
            sqlitePath = @"NoteStore.sqlite";
        }else{
            sqlitePath = @"notes.sqlite";
            _isScanOldSql = YES;
        }
        NSString *sqliteddPath = [self copysqliteToApptempWithsqliteName:sqlitePath backupfilePath:_backUpPath recordArray:recordArray];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
    }
    return self;
}

- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
        _isiCloud = YES;
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
            NSString *sqliteddPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"AppDomainGroup-group.com.apple.notes/NoteStore.sqlite"];
            _dbType = YES;
            if (![fm fileExistsAtPath:sqliteddPath]) {
                _dbType = NO;
                sqliteddPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/Notes/notes.sqlite"];
            }
            if (sqliteddPath != nil) {
                _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
            }
        }else{
            //遍历需要的文件，然后拷贝到指定的目录下
            NSPredicate *pre = nil;
            IMBiCloudFileInfo *notesFile = nil;
            NSArray *tmpArray = nil;
            if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"8"]) {
                pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"AppDomainGroup-group.com.apple.notes", @"NoteStore.sqlite"];//注意NoteStore.sqlite路劲是否对不
                tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
                if (tmpArray != nil && tmpArray.count > 0) {
                    _dbType = YES;
                    notesFile = [tmpArray objectAtIndex:0];
                }else {
                    pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/Notes/notes.sqlite"];
                    tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
                    
                    if (tmpArray != nil && tmpArray.count > 0) {
                        notesFile = [tmpArray objectAtIndex:0];
                    } else {
                        pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/Notes/notes.db"];
                        tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
                        if (tmpArray != nil && tmpArray.count > 0) {
                            notesFile = [tmpArray objectAtIndex:0];
                        }
                    }
                }
            }
            if (notesFile != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (notesFile.fileName.length > 2) {
                        fd = [notesFile.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:notesFile.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:notesFile.fileName];
                }
                if (sourcefilePath != nil) {
                    _databaseConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }
        }

    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    if (attachAry != nil) {
        [attachAry release];
        attachAry = nil;
    }
}

#pragma mark - 查询数据库方法
- (void)querySqliteDBContent{
    if (_dbType) {
        [self queryNotesDataiOS9];
    }else {
        [_logManger writeInfoLog:@"Begin query Notes Data"];
        
        [self QueryNotesData] ;
        
        [_logManger writeInfoLog:@"Query Notes Data End"];
    }
}
//iOS4及以上ios9以下设备查询数据
- (void)QueryNotesData {
    BOOL isOpen = NO;
    isOpen = [self openDataBase];
    if (isOpen) {
        FMResultSet *rs = nil;
        if (_isScanOldSql) {
            rs = [_databaseConnection executeQuery:@"SELECT A1.Z_PK,A2.ZOWNER,A1.ZCONTENTTYPE,A1.ZDELETEDFLAG,A1.ZCREATIONDATE,A1.ZMODIFICATIONDATE,A1.ZAUTHOR,A1.ZGUID,A1.ZSERVERID,A1.ZSUMMARY,A1.ZTITLE,A2.ZCONTENT FROM ZNOTE A1 LEFT JOIN ZNOTEBODY A2 ON A1.Z_PK=A2.ZOWNER"];
        }else {
            rs = [_databaseConnection executeQuery:@"SELECT A1.Z_PK,A2.ZOWNER,A1.ZCONTENTTYPE,A1.ZDELETEDFLAG,A1.ZCREATIONDATE,A1.ZMODIFICATIONDATE,A1.ZAUTHOR,A1.ZGUID,A1.ZSERVERID,A1.ZSUMMARY,A1.ZTITLE,A2.ZCONTENT FROM ZNOTE A1 LEFT JOIN ZNOTEBODY A2 ON A1.Z_PK=A2.ZOWNER"];
        }
        while ([rs next]) {
            @autoreleasepool {
                IMBNoteModelEntity *nd = [[IMBNoteModelEntity alloc] init];
                nd.isDeleted = _isScanOldSql;
                nd.zpk = [rs intForColumn:@"Z_PK"];
                nd.zcontentType = [rs intForColumn:@"ZCONTENTTYPE"];
                nd.zdeletedFlag = [rs intForColumn:@"ZDELETEDFLAG"];
                nd.creatDate = [rs longForColumn:@"ZCREATIONDATE"];
                nd.creatDateStr = [DateHelper dateFrom2001ToString:nd.creatDate withMode:2];
                nd.modifyDate = [rs longForColumn:@"ZMODIFICATIONDATE"];
                nd.modifyDateStr = [DateHelper dateFrom2001ToString:nd.modifyDate withMode:2];
                nd.shortDateStr = [DateHelper dateFrom2001ToString:nd.modifyDate withMode:1];
                if (![rs columnIsNull:@"ZAUTHOR"]) {
                    nd.author = [rs stringForColumn:@"ZAUTHOR"];
                }else {
                    nd.author = @"";
                }
                nd.guid = [rs dataForColumn:@"ZGUID"];
                if (![rs columnIsNull:@"ZSERVERID"]) {
                    nd.serverID = [rs stringForColumn:@"ZSERVERID"];
                }else {
                    nd.serverID = @"";
                }
                if (![rs columnIsNull:@"ZSUMMARY"]) {
                    nd.summary = [rs stringForColumn:@"ZSUMMARY"];
                }else {
                    nd.summary = @"";
                }
                if (![rs columnIsNull:@"ZTITLE"]) {
                    nd.title = [StringHelper flattenHTML:[rs stringForColumn:@"ZTITLE"] trimWhiteSpace:YES];
                }else {
                    nd.title = @"";
                }
                if (![rs columnIsNull:@"ZCONTENT"]) {
                    nd.content = [StringHelper flattenHTML:[rs stringForColumn:@"ZCONTENT"] trimWhiteSpace:YES] ;
                    //                    nd.content = [rs stringForColumn:@"ZCONTENT"];
                }else {
                    nd.content = @"";
                }
                [nd setSortStr:[StringHelper getStringFirstWord:nd.title]];
                
//                if (_isScanOldSql) {
//                    [_reslutEntity.reslutArray insertObject:nd atIndex:0];
//                }else {
                    [_dataAry addObject:nd];
//                }
                
//                //通知UI
//                NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:_reslutEntity.reslutCount], @"CurrentCount", [NSNumber numberWithInt:(int)ScanNotesFile], @"ScanType", nil];
//                [nc postNotificationName:NOTIFY_SCAN_PROGRESS object:nil userInfo:userDic];
                
                [nd release];
                nd = nil;
            }
        }
        [rs close];
//        if (_isScanOldSql) {
//            [self closeOldDBConnection];
//        }else {
            [self closeDataBase];
//        }
    }

}

//iOS9及以上查询数据
- (void)queryNotesDataiOS9 {
    [_logManger writeInfoLog:@"Begin query Notes Data(iOS9)"];
    if ([self openDataBase]) {
        NSString *queryAccountSql = nil;
        if ([_iOSVersion isVersionMajorEqual:@"11"]) {
            //不去查询
        }else if ([_iOSVersion isVersionMajorEqual:@"9.1"]) {
            queryAccountSql = @"SELECT Z_9NOTES FROM Z_12NOTES WHERE Z_12FOLDERS IN (SELECT Z_PK FROM ZICCLOUDSYNCINGOBJECT WHERE ZIDENTIFIER = 'TrashFolder-LocalAccount')";
        }else {
            queryAccountSql = @"SELECT Z_9NOTES FROM Z_12NOTES WHERE Z_12FOLDERS IN (SELECT Z_PK FROM ZICCLOUDSYNCINGOBJECT WHERE ZIDENTIFIER6 = 'TrashFolder')";
        }
        
        NSMutableArray *deleteAry = [[NSMutableArray alloc] init];
        FMResultSet *queryRs = [_databaseConnection executeQuery:queryAccountSql];
        while ([queryRs next]) {
            [deleteAry addObject:[NSNumber numberWithInt:[queryRs intForColumn:@"Z_9NOTES"]]];
        }
        [queryRs close];
        
        FMResultSet *rs = [_databaseConnection executeQuery:@"SELECT ZNOTE, ZDATA FROM ZICNOTEDATA"];
        while ([rs next]) {
            @autoreleasepool {
                IMBNoteModelEntity *nd = [[IMBNoteModelEntity alloc] init];
                if (![rs columnIsNull:@"ZNOTE"]) {
                    nd.zpk = [rs intForColumn:@"ZNOTE"];
                }
                if ([deleteAry containsObject:[NSNumber numberWithInt:nd.zpk]]) {
                    [nd setIsDeleted:YES];
                }
                if (![rs columnIsNull:@"ZDATA"]) {
                    NSData *data = [rs dataForColumn:@"ZDATA"];
                    if (data != nil) {
                        [nd setContentData:data];
                    }
                }
                if (nd.contentData != nil) {

                    [self queryTableZiccloudSyncingObject:nd];
                    NSString *noteContent = [self analysisNoteData:nd.contentData withIsCompress:YES];
                    if (![StringHelper stringIsNilOrEmpty:noteContent]) {
                        nd.content = [StringHelper flattenHTML:noteContent trimWhiteSpace:YES] ;
                        //                        [nd setContent:noteContent];
                    }
                    if (!nd.isDeleted) {
                        [_dataAry addObject:nd];
                    }
                }
                [nd release];
                nd = nil;
            }
        }
        [rs close];
        [self closeDataBase];
        [deleteAry release];
    }
    
    //扫描老的数据库
    if (_isScanOldSql) {
        [self QueryNotesData];
    }

    [_logManger writeInfoLog:@"Query Notes Data End(iOS9)"];
    
}

//查询表ZICCLOUDSYNCINGOBJECT,note 内容;
- (void)queryTableZiccloudSyncingObject:(IMBNoteModelEntity *)noteData {
    NSString *cmd = @"select Z_PK,ZSNIPPET,ZTITLE1,ZFILESIZE,ZMARKEDFORDELETION,ZNOTE,ZMEDIA,ZMODIFICATIONDATE,ZFILENAME,ZIDENTIFIER,ZCREATIONDATE,ZMODIFICATIONDATE1 from ZICCLOUDSYNCINGOBJECT where Z_PK=:noteid";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:noteData.zpk], @"noteid", nil];
    FMResultSet *rs = [_databaseConnection executeQuery:cmd withParameterDictionary:param];
    while ([rs next]) {
        if ([rs intForColumn:@"ZMARKEDFORDELETION"] == 1) {//代表删除了的
            [noteData setIsDeleted:YES];
        }
        if (![rs columnIsNull:@"ZTITLE1"]) {
            noteData.title = [rs stringForColumn:@"ZTITLE1"];
        }
        if (![rs columnIsNull:@"ZSNIPPET"]) {
            noteData.summary = [rs stringForColumn:@"ZSNIPPET"];
        }
        if (![rs columnIsNull:@"ZCREATIONDATE"]) {
            noteData.creatDate = [rs longForColumn:@"ZCREATIONDATE"];
            noteData.creatDateStr = [DateHelper dateFrom2001ToString:noteData.creatDate withMode:2];
        }
        if (![rs columnIsNull:@"ZMODIFICATIONDATE1"]) {
            noteData.modifyDate = [rs longForColumn:@"ZMODIFICATIONDATE1"];
            noteData.modifyDateStr = [DateHelper dateFrom2001ToString:noteData.modifyDate withMode:2];
            noteData.shortDateStr = [DateHelper dateFrom2001ToString:noteData.modifyDate withMode:1];
        }
        [noteData setSortStr:[StringHelper getStringFirstWord:noteData.title]];
        if (![StringHelper stringIsNilOrEmpty:noteData.title]) {
            noteData.content = noteData.title;
            if (![StringHelper stringIsNilOrEmpty:noteData.summary]) {
                noteData.content = [[noteData.content stringByAppendingString:@"\n"] stringByAppendingString:noteData.summary];
            }
        }
        [self queryTableZiccloudSyncingObjectToAttachment:noteData];
    }
    [rs close];
}


//查询表ZICCLOUDSYNCINGOBJECT,note附件信息
- (void)queryTableZiccloudSyncingObjectToAttachment:(IMBNoteModelEntity *)noteData {
    NSString *cmd = @"select Z_PK,ZSNIPPET,ZTITLE1,ZFILESIZE,ZNOTE,ZMEDIA,ZMODIFICATIONDATE,ZFILENAME,ZIDENTIFIER,ZCREATIONDATE,ZMODIFICATIONDATE1,ZTYPEUTI from ZICCLOUDSYNCINGOBJECT where ZNOTE=:noteId";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:noteData.zpk], @"noteId", nil];
    FMResultSet *rs = [_databaseConnection executeQuery:cmd withParameterDictionary:param];
    while ([rs next]) {
        NSMutableArray *attachmentIdList = [[NSMutableArray alloc] init];
        IMBNoteAttachmentEntity *attachmentData = [[IMBNoteAttachmentEntity alloc] init];
        attachmentData.zpk = [rs intForColumn:@"Z_PK"];
        attachmentData.attachmentId = noteData.zpk;
        if (![rs columnIsNull:@"ZMEDIA"]) {
            attachmentData.mediaId = [rs intForColumn:@"ZMEDIA"];
        }
        if (![rs columnIsNull:@"ZFILESIZE"]) {
            attachmentData.fileSize = [rs longForColumn:@"ZFILESIZE"];
        }
        if (![rs columnIsNull:@"ZMODIFICATIONDATE"]) {
            attachmentData.date = [rs longLongIntForColumn:@"ZMODIFICATIONDATE"];
        }
        [attachmentIdList addObject:[NSNumber numberWithInt:attachmentData.mediaId]];
        [self queryAttachmentImage:[rs intForColumn:@"Z_PK"] withAttachment:attachmentIdList];
        [self queryAttachmentImage:[rs intForColumn:@"Z_PK"] withAttachment:attachmentIdList];
        [self queryAttachment:attachmentData withAttachment:attachmentIdList];
        [attachmentData.allPreviewId addObjectsFromArray:attachmentIdList];
        
        [noteData.attachmentAry addObject:attachmentData];
        [attachmentData release];
        attachmentData = nil;
        [attachmentIdList release];
        attachmentIdList = nil;
    }
    [rs close];
    //TODO:获取附件文件本身; DFU 、iCloud获取附件方式没有写
    if (noteData.attachmentAry.count > 0) {
        attachAry = [[NSMutableArray alloc]init];
        if (_isiCloud) {
            if ([_iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
                [self matchAttachmentiCloud:noteData.attachmentAry withAttachData:attachAry];
            }else {
                IMBBackupManager *backupmanager = [IMBBackupManager shareInstance];
                [backupmanager matchAttachmentArray:noteData.attachmentAry withReslutAry:attachAry];
            }
        }else {
            IMBBackupManager *backupmanager = [IMBBackupManager shareInstance];
            [backupmanager matchAttachmentArray:noteData.attachmentAry withReslutAry:attachAry];
        }
    }
}

- (void)matchAttachmentiCloud:(NSMutableArray *)attachmentAry withAttachData:(NSMutableArray *)attachData  {
    NSString *attachmentPath = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"AppDomainGroup-group.com.apple.notes/Media"];
    NSString *attachmentPrePath = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"AppDomainGroup-group.com.apple.notes/Previews"];
    if (_dbType) {
        NSMutableArray *existFileArray = [NSMutableArray array];
        NSArray *attachArray = [fm contentsOfDirectoryAtPath:attachmentPath error:nil];
        if (attachArray != nil && attachArray.count > 0) {
            for (NSString *pathStr in attachArray) {
                if ([pathStr hasPrefix:@"."]) {
                    continue;
                }
                NSString *subPath = [attachmentPath stringByAppendingPathComponent:pathStr];
                NSArray *arr1 = [fm contentsOfDirectoryAtPath:subPath error:nil];
                if (arr1 != nil && arr1.count > 0) {
                    for (NSString *path in arr1) {
                        if ([path hasPrefix:@"."]) {
                            continue;
                        }
                        NSString *filePath = [subPath stringByAppendingPathComponent:path];
                        if ([fm fileExistsAtPath:filePath]) {
                            IMBManifestDataModel *mfItem = [[IMBManifestDataModel alloc] init];
                            mfItem.isFileExist = YES;
                            [mfItem setFilePath:filePath];
                            [mfItem setFileSize:[MediaHelper getFileLength:filePath]];
                            [mfItem setFileBackUpPath:filePath];
                            [mfItem setFileKey:[filePath lastPathComponent]];
                            [existFileArray addObject:mfItem];
                        }
                    }
                }
            }
        }
        
        NSArray *attachPreArray = [fm contentsOfDirectoryAtPath:attachmentPrePath error:nil];
        if (attachPreArray != nil && attachPreArray.count > 0) {
            for (NSString *path in attachPreArray) {
                if ([path hasPrefix:@"."]) {
                    continue;
                }
                NSString *filePath = [attachmentPrePath stringByAppendingPathComponent:path];
                if ([fm fileExistsAtPath:filePath]) {
                    IMBManifestDataModel *mfItem = [[IMBManifestDataModel alloc] init];
                    mfItem.isFileExist = YES;
                    [mfItem setFilePath:filePath];
                    [mfItem setFileSize:[MediaHelper getFileLength:filePath]];
                    [mfItem setFileBackUpPath:filePath];
                    [mfItem setFileKey:[filePath lastPathComponent]];
                    [existFileArray addObject:mfItem];
                }
            }
        }
        
        NSPredicate *pre = nil;
        if (existFileArray != nil && [existFileArray count] > 0) {
            for (IMBNoteAttachmentEntity *item in attachmentAry) {
                if (item.allAttachId.count > 0) {
                    @autoreleasepool {
                        for (NSString *attGUID in item.allAttachId) {
                            if ([MediaHelper stringIsNilOrEmpty:attGUID]) {
                                continue;
                            }
                            pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                IMBManifestDataModel *mdmitem = (IMBManifestDataModel*)evaluatedObject;
                                if ([[mdmitem filePath] rangeOfString:attGUID].length > 0) {
                                    return YES;
                                }else {
                                    return NO;
                                }
                            }];
                            
                            NSArray *manifestDataArray = [existFileArray filteredArrayUsingPredicate:pre];
                            if (manifestDataArray != nil && [manifestDataArray count] > 0) {
                                for (IMBManifestDataModel *mfItem in manifestDataArray) {
                                    if (!mfItem.isFileExist) {
                                        continue;
                                    }
                                    IMBAttachDetailEntity *attachDetailItem = [[IMBAttachDetailEntity alloc] init];
                                    [attachDetailItem setRowID:item.attachmentId];
                                    [attachDetailItem setFileName:[[mfItem filePath] lastPathComponent]];
                                    [attachDetailItem setFileSize:[mfItem fileSize]];
                                    [attachDetailItem setBackUpFilePath:[mfItem fileBackUpPath]];
                                    [attachDetailItem setBackFileName:[mfItem fileKey]];
                                    NSString *filePath = [mfItem filePath];
                                    if (![MediaHelper stringIsNilOrEmpty:filePath] && [[filePath lowercaseString] rangeOfString:@"preview"].length > 0) {
                                        [attachDetailItem setIsPerviewImage:YES];
                                    } else {
                                        [attachDetailItem setIsPerviewImage:NO];
                                    }
                                    
                                    [item.attachDetailList addObject:attachDetailItem];
                                    
                                    [attachData addObject:attachDetailItem];
                                    
                                    [attachDetailItem release];
                                    attachDetailItem = nil;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//查询附件
- (void)queryAttachment:(IMBNoteAttachmentEntity *)attachmentData withAttachment:(NSMutableArray *)attArray {
 
    if (attArray.count > 0) {
        for (NSNumber *number in attArray) {
            NSString *cmd = @"select Z_PK,ZSNIPPET,ZTITLE1,ZFILESIZE,ZNOTE,ZMEDIA,ZMODIFICATIONDATE,ZFILENAME,ZIDENTIFIER,ZCREATIONDATE,ZMODIFICATIONDATE1 from ZICCLOUDSYNCINGOBJECT where Z_PK=:mediaId";
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:number, @"mediaId", nil];
            FMResultSet *rs = [_databaseConnection executeQuery:cmd withParameterDictionary:param];
            while ([rs next]) {
                if (![rs columnIsNull:@"ZIDENTIFIER"]) {
                    NSString *identifier = [rs stringForColumn:@"ZIDENTIFIER"];
                    [attachmentData.allAttachId addObject:identifier];
                }
            }
            [rs close];
        }
    }
    
}

- (void)queryAttachmentImage:(int)zpk withAttachment:(NSMutableArray *)attachmentArr {
    NSString *cmd = nil;
    if ([_iOSVersion isVersionMajorEqual:@"10"]) {
        cmd = @"select Z_PK from ZICCLOUDSYNCINGOBJECT where ZATTACHMENT=:zpk";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:zpk], @"zpk", nil];
        FMResultSet *rs = [_databaseConnection executeQuery:cmd withParameterDictionary:param];
        while ([rs next]) {
            if ([ScanStatus shareInstance].stopScan) {
                break;
            }
            int preId = 0;
            if (![rs columnIsNull:@"Z_PK"]) {
                preId = [rs intForColumn:@"Z_PK"];
            }
            if (preId != 0) {
                [attachmentArr addObject:[NSNumber numberWithInt:preId]];
            }
        }
        [rs close];
        
    }else{
        cmd = @"select * from Z_4PREVIEWIMAGES where Z_4ATTACHMENTS=:zpk";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:zpk], @"zpk", nil];
        FMResultSet *rs = [_databaseConnection executeQuery:cmd withParameterDictionary:param];
        while ([rs next]) {
            if ([ScanStatus shareInstance].stopScan) {
                break;
            }
            int preId = 0;
            if (![rs columnIsNull:@"Z_5PREVIEWIMAGES"]) {
                preId = [rs intForColumn:@"Z_5PREVIEWIMAGES"];
            }
            if (preId != 0) {
                [attachmentArr addObject:[NSNumber numberWithInt:preId]];
            }
        }
        [rs close];
        
    }
}


- (NSString *)analysisNoteData:(NSData *)noteData withIsCompress:(BOOL)isdeCompress {
    NSData *decompressData = nil;
    if (isdeCompress) {
        decompressData = [self uncompressZippedData:noteData];//ZipHelper.Decompress(noteData);
    }else {
        decompressData = noteData;
    }
    
    if (decompressData == nil) {
        return @"";
    }
    NSInteger fileLength = decompressData.length - 4;
    int Offset = 2;
    if (fileLength > 128) {
        //Paging
        Offset = Offset + 2;
    }else {
        Offset = Offset + 1;
    }
    Offset = Offset + 5;
    NSInteger fileMinLength = decompressData.length - 12;
    
    if (fileMinLength > 128) {
        Offset = Offset + 2;
    }else {
        Offset = Offset + 1;
    }
    Offset = Offset + 2;
    char *bytes = (char *)decompressData.bytes;
    NSMutableString *noteContent = [NSMutableString string];// List<byte> noteContent = new List<byte>();
    for (int i = Offset; i < decompressData.length; i++)
    {
        NSString *text16 = [NSString stringWithFormat:@"%02x",(unsigned char)bytes[i]];
        if ([text16 isEqualToString:@"1a"])
        {
            break;
        }
        [noteContent appendFormat:@"%02x", ((unsigned char*)bytes)[i]];
    }
    if (noteContent.length == 0)
    {
        return @"";
    }
    
    NSString *contentStr = @"";
    if (noteContent.length - 1 > 128)
    {
        if (noteContent.length >= 2) {
            contentStr = [noteContent stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
        }
    }else {
        if (noteContent.length >= 1) {
            contentStr = [noteContent stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        }
    }
    NSString *noteStr = [StringHelper stringFromHexString:contentStr];
    return noteStr;
}


- (BOOL)determineDatabase {
    if ([_iOSVersion isVersionMajorEqual:@"9"]) {
        NSString *filePath = [_backUpPath stringByAppendingPathComponent:@"857109b149c3a666c746569cec5ffd3cbf5955d9"];
        if ([_iOSVersion isVersionMajorEqual:@"10"]) {
            filePath = [[_backUpPath stringByAppendingPathComponent:@"85"] stringByAppendingPathComponent:@"857109b149c3a666c746569cec5ffd3cbf5955d9"];
        }
        if ([fm fileExistsAtPath:filePath]) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}


- (NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    unsigned full_length = [compressedData length];
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}
@end

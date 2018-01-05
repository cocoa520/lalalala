//
//  IMBNoteSqliteManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-21.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBNoteSqliteManager.h"
//#import "IMBHelper.h"
#import "IMBNoteDataEntity.h"
#import "IMBBackupManager.h"
#import "StringHelper.h"
#import "NSString+Category.h"
#import "IMBZipHelper.h"
#define DataBasePath    @"/Users/iMobie/Desktop/notes.sqlite"
@implementation IMBNoteSqliteManager
@synthesize noteAry;
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type]) {
        _backUpPath = backupfilePath;
        _dbType = [self determineDatabase];
        NSString *sqlitePath = nil;
        if (_dbType) {
            sqlitePath = @"NoteStore.sqlite";
        }else{
            sqlitePath = @"notes.sqlite";
            _isScanOldSql = YES;
        }
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        NSString *sqliteddPath = [manager copysqliteToApptempWithsqliteName:sqlitePath backupfilePath:backupfilePath];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        noteAry = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    if (noteAry != nil) {
        [noteAry release];
        noteAry = nil;
    }
}

- (NSMutableArray *)queryAllNotes
{
    
    
    NSMutableArray *allBookmarksArray = [NSMutableArray array];
    //开启数据库连接
    [self openDataBase];
    
    return allBookmarksArray;
}

#pragma mark - 查询数据库方法
- (void)querySqliteDBContent{
    if (_dbType) {
        [self queryNotesDataiOS9];
    }else {
        [_logManger writeInfoLog:@"Begin query Notes Data"];
//        NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ScanNotesFile], @"ScanType", nil];
//        [nc postNotificationName:NOTIFY_SINGLE_SCAN_START object:nil userInfo:userDic];
//        userDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ScanNotesAttachmentFile], @"ScanType", nil];
//        [nc postNotificationName:NOTIFY_SINGLE_SCAN_START object:nil userInfo:userDic];
        
        [self QueryNotesData] ;
        
//        [nc postNotificationName:NOTIFY_SINGLE_SCAN_COMPLETE object:nil userInfo:userDic];
        

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
            rs = [_databaseConnection executeQuery:@"SELECT A1.Z_PK,A2.ZOWNER,A1.ZCONTENTTYPE,A1.ZDELETEDFLAG,A1.ZCREATIONDATE,A1.ZMODIFICATIONDATE,A1.ZAUTHOR,A1.ZGUID,A1.ZSERVERID,A1.ZSUMMARY,A1.ZTITLE,A2.ZCONTENT FROM ZNOTE A1 LEFT JOIN ZNOTEBODY A2 ON A1.Z_PK=A2.Z_PK"];
        }else {
            rs = [_databaseConnection executeQuery:@"SELECT A1.Z_PK,A2.ZOWNER,A1.ZCONTENTTYPE,A1.ZDELETEDFLAG,A1.ZCREATIONDATE,A1.ZMODIFICATIONDATE,A1.ZAUTHOR,A1.ZGUID,A1.ZSERVERID,A1.ZSUMMARY,A1.ZTITLE,A2.ZCONTENT FROM ZNOTE A1 LEFT JOIN ZNOTEBODY A2 ON A1.Z_PK=A2.Z_PK"];
        }
        while ([rs next]) {
            @autoreleasepool {
//                [_condition lock];
//                if ([ScanStatus shareInstance].isPause) {
//                    [_condition wait];
//                }
//                [_condition unlock];
//                if ([ScanStatus shareInstance].stopScan) {
//                    break;
//                }
                IMBNoteModelEntity *nd = [[IMBNoteModelEntity alloc] init];
                nd.isDeleted = _isScanOldSql;
                nd.zpk = [rs intForColumn:@"Z_PK"];
                nd.zcontentType = [rs intForColumn:@"ZCONTENTTYPE"];
                nd.zdeletedFlag = [rs intForColumn:@"ZDELETEDFLAG"];
                nd.creatDate = [rs longForColumn:@"ZCREATIONDATE"];
                nd.modifyDate = [rs longForColumn:@"ZMODIFICATIONDATE"];
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
                    [noteAry addObject:nd];
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
    
    //查询删除数据
    @autoreleasepool {
        [self queryNotesDeleteData:noteAry withOldSql:_isScanOldSql];
    }
}

//iOS9及以上查询数据
- (void)queryNotesDataiOS9 {
    [_logManger writeInfoLog:@"Begin query Notes Data(iOS9)"];
    if ([self openDataBase]) {
        NSString *queryAccountSql = nil;
        if ([_iOSVersion isVersionMajorEqual:@"9.1"]) {
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
        
                    [noteAry addObject:nd];
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
    
//    userDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:_reslutEntity.reslutCount], @"CurrentCount", [NSNumber numberWithInt:(int)ScanNotesFile], @"ScanType", nil];
//    [nc postNotificationName:NOTIFY_SINGLE_SCAN_COMPLETE object:nil userInfo:userDic];
//    
//    userDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:_attachmentReslutEntity.reslutCount], @"CurrentCount", [NSNumber numberWithInt:(int)ScanNotesAttachmentFile], @"ScanType", nil];
//    [nc postNotificationName:NOTIFY_SINGLE_SCAN_COMPLETE object:nil userInfo:userDic];
//    [_logHandle writeInfoLog:@"Query Notes Data End(iOS9)"];
    
}

//查询表ZICCLOUDSYNCINGOBJECT,note 内容;
- (void)queryTableZiccloudSyncingObject:(IMBNoteModelEntity *)noteData {
    NSString *cmd = @"select Z_PK,ZSNIPPET,ZTITLE1,ZFILESIZE,ZMARKEDFORDELETION,ZNOTE,ZMEDIA,ZMODIFICATIONDATE,ZFILENAME,ZIDENTIFIER,ZCREATIONDATE,ZMODIFICATIONDATE1 from ZICCLOUDSYNCINGOBJECT where Z_PK=:noteid";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:noteData.zpk], @"noteid", nil];
    FMResultSet *rs = [_databaseConnection executeQuery:cmd withParameterDictionary:param];
    while ([rs next]) {
//        [_condition lock];
//        if ([ScanStatus shareInstance].isPause) {
//            [_condition wait];
//        }
//        [_condition unlock];
//        if ([ScanStatus shareInstance].stopScan) {
//            break;
//        }
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
        }
        if (![rs columnIsNull:@"ZMODIFICATIONDATE1"]) {
            noteData.modifyDate = [rs longForColumn:@"ZMODIFICATIONDATE1"];
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
//        [_condition lock];
//        if ([ScanStatus shareInstance].isPause) {
//            [_condition wait];
//        }
//        [_condition unlock];
//        if ([ScanStatus shareInstance].stopScan) {
//            break;
//        }
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
        [self queryAttachmentImage:[rs intForColumn:@"Z_PK"] withAttachment:attachmentIdList];
        //        if (![rs columnIsNull:@"ZTYPEUTI"]) {
        //            if ([[rs stringForColumn:@"ZTYPEUTI"] isEqualToString:@"public.jpeg"]) {
        //                [attachmentIdList addObject:[NSNumber numberWithInt:[rs intForColumn:@"ZMEDIA"]]];
        //            }
        //        }
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
        
//        IMBSMSBackUpAttachment *manifestMach = [IMBSMSBackUpAttachment singleton];
//        IMBManifestManager *manifest = nil;
//        if (_isCompare) {
//            manifest = _otherManifest;
//        }else {
//            manifest = _manifestManager;
//        }
//        [manifestMach matchAttachmentManifestDBToNotes:manifest.manifestHandle attachmentArray:noteData.attachmentAry withAttachData:_attachmentReslutEntity];
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
    NSString *cmd = @"select * from Z_4PREVIEWIMAGES where Z_4ATTACHMENTS=:zpk";
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

//解析data
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
        [noteContent appendFormat:@"%02x", ((uint8_t*)bytes)[i]];
    }
    if (noteContent.length == 0)
    {
        return @"";
    }
    
    NSString *contentStr = @"";
    if (noteContent.length - 1 > 128)
    {
        if (noteContent.length >= 2) {
            contentStr = [noteContent stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        }
    }else {
        if (noteContent.length >= 1) {
            contentStr = [noteContent stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
    }
    NSString *noteStr = [StringHelper stringFromHexString:contentStr];
    return noteStr;
}

- (BOOL)determineDatabase {
    if ([_iOSVersion isVersionMajorEqual:@"9"]) {
        NSString *filePath = [_backUpPath stringByAppendingPathComponent:@"857109b149c3a666c746569cec5ffd3cbf5955d9"];
        if ([fm fileExistsAtPath:filePath]) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}


-(NSData *)uncompressZippedData:(NSData *)compressedData
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

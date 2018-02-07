//
//  IMBMessageClone.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-16.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBMessageClone.h"
#import "IMBSMSChatDataEntity.h"
@implementation IMBMessageClone

- (void)setsourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray
{
    [super setsourceBackupPath:sourceBackupPath desBackupPath:desBackupPath sourcerecordArray:sourcerecordArray targetrecordArray:targetrecordArray];
    _allMessage = [[NSMutableArray alloc] init];
    _sourceBackuppath = [sourceBackupPath retain];
    _targetBakcuppath = [desBackupPath retain];
   {
        sourceRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SMS/sms.db" recordArray:_sourcerecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,sourceRecord.key];
        sourceRecord.relativePath = relativePath;
        _sourceSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceSqlite"] fileRecord:sourceRecord backupfilePath:sourceBackupPath] retain];
    }
    {
        targetRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SMS/sms.db" recordArray:_targetrecordArray] retain];
        NSString *rstr = [targetRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,targetRecord.key];
        targetRecord.relativePath = relativePath;
        _targetSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetSqlite"] fileRecord:targetRecord backupfilePath:desBackupPath] retain];
    }
}

- (void)merge:(NSArray *)messageArray
{
     //比较两个版本，已较小的为准
    _targetVersion = MIN(_sourceVersion, _targetVersion);
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"merge Message count:%d",messageArray.count]];
    attachfileNameArray = [[NSMutableArray alloc] init];
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            [_logHandle writeInfoLog:@"merge Message enter"];
            [_sourceDBConnection setTraceExecution:NO];
            [_targetDBConnection beginTransaction];
            [_targetDBConnection setTraceExecution:NO];
            if (_targetVersion > 5) {
                //删除触发器--dingming
                [self removeTrigger];
                for (IMBSMSChatDataEntity *entity in messageArray) {
                    @autoreleasepool {
                        int imnewchatRowID = -1;
                        int imhandRowID = -1;
                        int newchatRowID = -1;
                        int handRowID = -1;
                        if ([entity.chatIdentifier hasPrefix:@"chat"]) {
                            //群发
                            int newchatRowID1 = [self mergeChat:entity.iMChatGuid sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                            int handRowID1 = -1;
                            if (newchatRowID1 != -1) {
                                for (int i=0;i<[entity.addressArray count];i++) {
                                    NSString *handID = [entity.addressArray objectAtIndex:i];
                                    if (i == 0) {
                                        handRowID = [self mergehandle:handID service:entity.iMHandleService sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                                        if (handRowID != -1) {
                                            [self mergechat_handle_join:newchatRowID1 handleID:handRowID targetDB:_targetDBConnection];
                                        }
                                    }else{
                                        handRowID1 = [self mergehandle:handID service:entity.iMHandleService sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                                        if (handRowID1 != -1) {
                                            [self mergechat_handle_join:newchatRowID1 handleID:handRowID1 targetDB:_targetDBConnection];
                                        }
                                    }
                                }
                            }
                            if ([entity.iMHandleService isEqualToString:@"SMS"]) {
                                newchatRowID = newchatRowID1;
                            }else{
                                imnewchatRowID = newchatRowID1;
                                imhandRowID = handRowID;
                            }
                            if (![entity.iMHandleService isEqualToString:entity.handleService]) {
                                int newchatRowID1 = [self mergeChat:entity.chatGuid sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                                int handRowID1 = -1;
                                if (newchatRowID1 != -1) {
                                    for (int i=0;i<[entity.addressArray count];i++) {
                                        NSString *handID = [entity.addressArray objectAtIndex:i];
                                        if (i == 0) {
                                            handRowID = [self mergehandle:handID service:entity.handleService sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                                            if (handRowID != -1) {
                                                [self mergechat_handle_join:newchatRowID1 handleID:handRowID targetDB:_targetDBConnection];
                                            }
                                        }else{
                                            handRowID1 = [self mergehandle:handID service:entity.handleService sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                                            if (handRowID1 != -1) {
                                                [self mergechat_handle_join:newchatRowID1 handleID:handRowID1 targetDB:_targetDBConnection];
                                            }
                                        }
                                    }
                                }
                                if ([entity.handleService isEqualToString:@"SMS"]) {
                                    newchatRowID = newchatRowID1;
                                }else{
                                    imnewchatRowID = newchatRowID1;
                                    imhandRowID = handRowID;
                                }
                            }
                        }else{
                            if (entity.isExistTwo) {
                                int newchatRowID1 = [self mergeChat:entity.iMChatGuid sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                                int handRowID1 = -1;
                                if (newchatRowID1 != -1) {
                                    handRowID1 = [self mergehandle:entity.iMHandleId service:entity.iMHandleService sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                                    if (handRowID1 != -1) {
                                        [self mergechat_handle_join:newchatRowID1 handleID:handRowID1 targetDB:_targetDBConnection];
                                    }
                                }
                                if ([entity.iMHandleService isEqualToString:@"SMS"]) {
                                    newchatRowID = newchatRowID1;
                                    handRowID = handRowID1;
                                }else{
                                    imnewchatRowID = newchatRowID1;
                                    imhandRowID = handRowID1;
                                }
                            }
                            int newchatRowID1 = [self mergeChat:entity.chatGuid sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                            int handRowID1 = -1;
                            if (newchatRowID1 != -1) {
                                handRowID1 = [self mergehandle:entity.handleId service:entity.handleService sourceDB:_sourceDBConnection targetDB:_targetDBConnection];
                                if (handRowID1 != -1) {
                                    [self mergechat_handle_join:newchatRowID1 handleID:handRowID1 targetDB:_targetDBConnection];
                                }
                            }
                            if ([entity.handleService isEqualToString:@"SMS"]) {
                                newchatRowID = newchatRowID1;
                                handRowID = handRowID1;
                            }else{
                                imnewchatRowID = newchatRowID1;
                                imhandRowID = handRowID1;
                            }
                        }
                       
                        [_allMessage addObjectsFromArray:entity.msgModelList];
                        if ([entity.chatIdentifier hasPrefix:@"chat"]) {
                            for (IMBMessageDataEntity *message in  entity.msgModelList) {
                                NSString *sql = @"select id,service from handle where ROWID=:ROWID";
                                FMResultSet *rs = [_sourceDBConnection executeQuery:sql withParameterDictionary:[NSDictionary dictionaryWithObject:@(message.handleId) forKey:@"ROWID"]];
                                message.mergeStruct->handRowID = 0;
                                message.mergeStruct->imhandRowID = 0;
                                while ([rs next]) {
                                    NSString *pid = [rs stringForColumn:@"id"];
                                    NSString *service = [rs stringForColumn:@"service"];
                                    NSString *sql1 = @"select ROWID from handle where id=:id and service=:service";
                                    FMResultSet *rs1 = [_targetDBConnection executeQuery:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:pid,@"id",service, @"service",nil]];
                                    while ([rs1 next]) {
                                        int rowid = [rs1 intForColumn:@"ROWID"];
                                        if ([service isEqualToString:@"SMS"]) {
                                            message.mergeStruct->handRowID = rowid;
                                            message.mergeStruct->imhandRowID = imhandRowID;
                                        }else{
                                            message.mergeStruct->handRowID = handRowID;
                                            message.mergeStruct->imhandRowID = rowid;
                                        }
                                        break;
                                    }
                                    [rs1 close];
                                    break;
                                }
                                
                                message.mergeStruct->imnewchatRowID = imnewchatRowID;
                                message.mergeStruct->newchatRowID = newchatRowID;
                                message.chat = entity;

                                [rs close];
                            }
                        }else{
                            for (IMBMessageDataEntity *message in  entity.msgModelList) {
                                message.mergeStruct->handRowID = handRowID;
                                message.mergeStruct->imhandRowID = imhandRowID;
                                message.mergeStruct->imnewchatRowID = imnewchatRowID;
                                message.mergeStruct->newchatRowID = newchatRowID;
                                message.chat = entity;
                            }
                        }
                        
//                        [self mergeMessage:newchatRowID handID:handRowID imchatID:imnewchatRowID imhandID:imhandRowID sourceDB:_sourceDBConnection targetDB:_targetDBConnection chat:entity];
                    }
                }
                NSSortDescriptor *sortDescripto = [[NSSortDescriptor alloc] initWithKey:@"msgDate" ascending:YES];
                NSArray *sortarray = [_allMessage sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescripto]];
                [sortDescripto release];
                for (IMBMessageDataEntity *message in sortarray) {
                    [self mergeMessage:message.mergeStruct->newchatRowID handID:message.mergeStruct->handRowID imchatID:message.mergeStruct->imnewchatRowID imhandID:message.mergeStruct->imhandRowID sourceDB:_sourceDBConnection targetDB:_targetDBConnection chat:message.chat message:message];
                }
                //创建触发器--dingming
                [self createTrigger];
            }
            if (![_targetDBConnection commit]) {
                [_targetDBConnection rollback];
            }
            [_logHandle writeInfoLog:@"merge Message exit"];
        }
        [self closeDataBase:_sourceDBConnection];
        [self closeDataBase:_targetDBConnection];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    if ([_targetFloatVersion isVersionLess:@"10"]) {
        if ([attachfileNameArray count] == 0) {
            [self modifyHashAndManifest];
            return;
        }
        [_logHandle writeInfoLog:@"copy merge message files enter"];
        NSMutableArray *sourceattachmentRecordArray = [NSMutableArray array];
        for (IMBMBFileRecord *record in _sourcerecordArray) {
            if ([record.path hasPrefix:
                 @"Library/SMS/Attachments"]) {
                if ([record.path isEqualToString:@"Library/SMS/Attachments"]) {
                    [sourceattachmentRecordArray addObject:record];
                }
                for (NSString *attachFileName in attachfileNameArray) {
                    NSArray *fileSeArray = [attachFileName componentsSeparatedByString:@"/"];
                    if ([fileSeArray containsObject:@"var"]) {
                        if ([fileSeArray count]>6) {
                            NSString *recordPath = @"Library/SMS/Attachments";
                            for (int i=6;i<[fileSeArray count];i++) {
                                recordPath = [recordPath stringByAppendingPathComponent:[fileSeArray objectAtIndex:i]];
                                if ([record.path isEqualToString:recordPath]&&![sourceattachmentRecordArray containsObject:record]) {
                                    [sourceattachmentRecordArray addObject:record];
                                }
                            }
                        }
                    }else{
                        if ([fileSeArray count]>4) {
                            NSString *recordPath = @"Library/SMS/Attachments";
                            for (int i=4;i<[fileSeArray count];i++) {
                                recordPath = [recordPath stringByAppendingPathComponent:[fileSeArray objectAtIndex:i]];
                                if ([record.path isEqualToString:recordPath]&&![sourceattachmentRecordArray containsObject:record]) {
                                    [sourceattachmentRecordArray addObject:record];
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        NSMutableArray *targetRecodArray1 = [NSMutableArray array];
        NSMutableArray *targetRecodArray2 = [NSMutableArray array];
        NSMutableArray *sourceSameRecordArray = [NSMutableArray array];
        NSMutableArray *targetattachmentRecordArray = [NSMutableArray array];
        BOOL canAdd = YES;
        for (IMBMBFileRecord *record in _targetrecordArray) {
            if (canAdd) {
                [targetRecodArray1 addObject:record];
            }else
            {
                if ([record.path isEqualToString:
                     @"Library/SMS/Attachments"]&&[record.domain isEqualToString:@"MediaDomain"]) {
                    continue;
                }
                [targetRecodArray2 addObject:record];
            }
            if ([record.path isEqualToString:@"Library/SMS"]&&[record.domain isEqualToString:@"MediaDomain"]) {
                canAdd = NO;
            }
            
            if ([record.path hasPrefix:
                 @"Library/SMS/Attachments/"]&&[record.domain isEqualToString:@"MediaDomain"]) {
                [targetattachmentRecordArray addObject:record];
                for (IMBMBFileRecord *hRecord in sourceattachmentRecordArray) {
                    if ([record.path isEqualToString:hRecord.path]) {
                        [sourceSameRecordArray addObject:record];
                    }
                }
            }
        }
        NSFileManager *fileMan = [NSFileManager defaultManager];
        [_targetrecordArray removeAllObjects];
        [_targetrecordArray addObjectsFromArray:targetRecodArray1];
        //进行拷贝文件
        for (IMBMBFileRecord *record in sourceattachmentRecordArray) {
            NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
            NSString *sourcePath = nil;
            if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                sourcePath = [folderPath stringByAppendingPathComponent:record.key];
            }else{
                sourcePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
            }
            NSString *desPath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
            if ([fileMan fileExistsAtPath:desPath]) {
                [fileMan removeItemAtPath:desPath error:nil];
            }
            if ([fileMan fileExistsAtPath:sourcePath]) {
                [record setDataHash:[IMBBaseClone dataHashfilePath:sourcePath]];
                int64_t fileSize = [IMBUtilTool fileSizeAtPath:sourcePath];
                [record changeFileLength:fileSize];
                [fileMan copyItemAtPath:sourcePath toPath:desPath error:nil];
            }
        }
        [targetRecodArray2 removeObjectsInArray:targetattachmentRecordArray];
        [targetattachmentRecordArray removeObjectsInArray:sourceSameRecordArray];
        [sourceattachmentRecordArray addObjectsFromArray:targetattachmentRecordArray];
        [_targetrecordArray addObjectsFromArray:sourceattachmentRecordArray];
        [_targetrecordArray addObjectsFromArray:targetRecodArray2];
        [_logHandle writeInfoLog:@"copy merge message files end"];
        //修改HashandManifest
        [self modifyHashAndManifest];
    }else{
        [_logHandle writeInfoLog:@"copy merge message files enter"];
        @try {
            if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                if ([attachfileNameArray  count] == 0) {
                    [_logHandle writeInfoLog:@"attachfileNameArray count 0"];
                    [self modifyHashAndManifest];
                }else{
                    [_logHandle writeInfoLog:@"search attachfileNameArray"];
                    NSMutableArray *sourceattachmentRecordArray = [NSMutableArray array];
                    for (IMBMBFileRecord *record in _sourcerecordArray) {
                        @autoreleasepool {
                            if ([record.path hasPrefix:
                                 @"Library/SMS/Attachments"]) {
                                if ([record.path isEqualToString:@"Library/SMS/Attachments"]) {
                                    [sourceattachmentRecordArray addObject:record];
                                }
                                for (NSString *attachFileName in attachfileNameArray) {
                                    @autoreleasepool {
                                        NSArray *fileSeArray = [attachFileName componentsSeparatedByString:@"/"];
                                        if ([fileSeArray containsObject:@"var"]) {
                                            if ([fileSeArray count]>6) {
                                                NSString *recordPath = @"Library/SMS/Attachments";
                                                for (int i=6;i<[fileSeArray count];i++) {
                                                    recordPath = [recordPath stringByAppendingPathComponent:[fileSeArray objectAtIndex:i]];
                                                    if ([record.path isEqualToString:recordPath]&&![sourceattachmentRecordArray containsObject:record]) {
                                                        [sourceattachmentRecordArray addObject:record];
                                                    }
                                                }
                                            }
                                        }else{
                                            if ([fileSeArray count]>4) {
                                                NSString *recordPath = @"Library/SMS/Attachments";
                                                for (int i=4;i<[fileSeArray count];i++) {
                                                    recordPath = [recordPath stringByAppendingPathComponent:[fileSeArray objectAtIndex:i]];
                                                    if ([record.path isEqualToString:recordPath]&&![sourceattachmentRecordArray containsObject:record]) {
                                                        [sourceattachmentRecordArray addObject:record];
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    [_logHandle writeInfoLog:@"create attachplist"];
                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"sourceattachmentRecordArray count:%d",[sourceattachmentRecordArray count]]];
                    [self createAttachmentPlist:sourceattachmentRecordArray TargetDB:_targetManifestDBConnection isClone:NO];
                    [_logHandle writeInfoLog:@"modifyhash"];
                    [self modifyHashAndManifest];
                    [_logHandle writeInfoLog:@"copy merge message files end"];
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"exception:%@",exception]];
        }
        @finally {
            
        }
    }
}

- (void)createAttachmentPlist:(NSMutableArray *)sourceattachmentRecordArray TargetDB:(FMDatabase *)targetDB isClone:(BOOL)isClone
{
    if ([self openDataBase:targetDB]) {
        [self openDataBase:_sourceManifestDBConnection];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //首先查看目标数据库是否存在一样的
        NSString *querySql = @"SELECT rowid,file FROM Files where relativePath=:relativePath and domain=:domain";
        for (IMBMBFileRecord *record in sourceattachmentRecordArray) {
            @autoreleasepool {
                BOOL isexsited = NO;
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:record.path,@"relativePath",record.domain,@"domain", nil];
                FMResultSet *rs = [targetDB executeQuery:querySql withParameterDictionary:param];
                while ([rs next]) {
                    isexsited = YES;
                    break;
                }
                [rs close];
                if (!isexsited) {
                    //开始构建plist
                    NSString *insertSql = @"insert into Files(fileID, domain, relativePath, flags, file) values(:fileID, :domain, :relativePath, :flags, :file)";
                    NSMutableDictionary *insertParams = [NSMutableDictionary dictionary];
                    [insertParams setObject:record.key forKey:@"fileID"];
                    [insertParams setObject:record.domain forKey:@"domain"];
                    [insertParams setObject:record.path forKey:@"relativePath"];
                    NSData *data = nil;
                    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                        NSString *querySql1 = @"SELECT rowid,file FROM Files where fileID=:fileID";
                        NSDictionary *param1 = [NSDictionary dictionaryWithObject:record.key forKey:@"fileID"];
                        FMResultSet *rs1 = [_sourceManifestDBConnection executeQuery:querySql1 withParameterDictionary:param1];
                        while ([rs1 next]) {
                            data = [rs1 dataForColumn:@"file"];
                        }
                        [rs1 close];
                        if (record.filetype == FileType_Backup) {
                            [insertParams setObject:@(1) forKey:@"flags"];
                        }else{
                            [insertParams setObject:@(2) forKey:@"flags"];
                        }
                    }else{
                        if (record.filetype == FileType_Backup) {
                            NSString *extension = [[record.path pathExtension] lowercaseString];
                            if ([extension isEqualToString:@"jpg"]) {
                                data = [self createPlist:record createHash:YES isFile:YES];
                                
                            }else{
                                data = [self createPlist:record createHash:NO isFile:YES];
                            }
                            [insertParams setObject:@(1) forKey:@"flags"];
                        }else{
                            data = [self createPlist:record createHash:NO isFile:NO];
                            [insertParams setObject:@(2) forKey:@"flags"];
                        }
                    }
                    if (data) {
                        [insertParams setObject:data forKey:@"file"];
                        if ([targetDB executeUpdate:insertSql withParameterDictionary:insertParams]) {
                            //开始拷贝文件
                            if (record.filetype == FileType_Backup) {
                                NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
                                NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                                NSString *targetfilePath = [folderPath stringByAppendingPathComponent:record.key];
                                NSString *sourcefilePath = nil;
                                if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                                    NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                                    sourcefilePath = [folderPath stringByAppendingPathComponent:record.key];
                                }else{
                                    sourcefilePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
                                }
                                if ([fileManager fileExistsAtPath:folderPath]&&[fileManager fileExistsAtPath:sourcefilePath]) {
                                    if ([fileManager fileExistsAtPath:targetfilePath]) {
                                        [fileManager removeItemAtPath:targetfilePath error:nil];
                                    }
                                    [fileManager copyItemAtPath:sourcefilePath toPath:targetfilePath error:nil];
                                }else{
                                    if ([fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil]&&[fileManager fileExistsAtPath:sourcefilePath]) {
                                        [fileManager copyItemAtPath:sourcefilePath toPath:targetfilePath error:nil];
                                    }
                                }
                            }
                        }
                    }
                }else{
                    if (_isClone) {
                        if (record.filetype == FileType_Backup) {
                            NSString *sql = @"update Files set file=:file,domain=:domain,relativePath=:relativePath,flags=:flags where fileID=:fileID";
                            NSData *data = nil;
                            NSDictionary *param = [NSDictionary dictionaryWithObject:record.key forKey:@"fileID"];
                            FMResultSet *rs = [_sourceManifestDBConnection executeQuery:querySql withParameterDictionary:param];
                            while ([rs next]) {
                                data = [rs dataForColumn:@"file"];
                            }
                            [rs close];
                            if (data) {
                                if ([targetDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:data,@"file",record.domain,@"domain",record.path,@"relativePath",@(1),@"flags",record.key,@"fileID",nil]]) {
                                    NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
                                    NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                                    NSString *targetfilePath = [folderPath stringByAppendingPathComponent:record.key];
                                    NSString *sourcefilePath = nil;
                                    NSString *folderPath1 = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                                    sourcefilePath = [folderPath1 stringByAppendingPathComponent:record.key];
                                    if ([fileManager fileExistsAtPath:folderPath]&&[fileManager fileExistsAtPath:sourcefilePath]) {
                                        if ([fileManager fileExistsAtPath:targetfilePath]) {
                                            [fileManager removeItemAtPath:targetfilePath error:nil];
                                        }
                                        [fileManager copyItemAtPath:sourcefilePath toPath:targetfilePath error:nil];
                                    }else{
                                        if ([fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil]&&[fileManager fileExistsAtPath:sourcefilePath]) {
                                            [fileManager copyItemAtPath:sourcefilePath toPath:targetfilePath error:nil];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        [self closeDataBase:targetDB];
        [self closeDataBase:_sourceManifestDBConnection];
    }
}

- (NSData *)createPlist:(IMBMBFileRecord *)record createHash:(BOOL)createHash isFile:(BOOL)isFile
{
    NSData *data = nil;
    NSMutableDictionary *firstDic = [NSMutableDictionary dictionary];
    [firstDic setObject:@"NSKeyedArchiver" forKey:@"$archiver"];
    NSMutableArray *objectsList = [NSMutableArray array];
    [objectsList addObject:@"$null"];
    NSMutableDictionary *objectsDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
    if (createHash) {
        [classDic setObject:@(5) forKey:@"CF$UID"];
    }else{
        [classDic setObject:@(3) forKey:@"CF$UID"];
    }
    [objectsDic setObject:classDic forKey:@"$class"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"Birth"];
    if (createHash) {
        NSMutableDictionary *DigestDic = [NSMutableDictionary dictionary];
        [DigestDic setObject:@(3) forKey:@"CF$UID"];
        [objectsDic setObject:DigestDic forKey:@"ExtendedAttributes"];
    }
    [objectsDic setObject:@(record.userId) forKey:@"GroupID"];
    [objectsDic setObject:@(record.inode) forKey:@"InodeNumber"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"LastModified"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"LastStatusChange"];
    [objectsDic setObject:@(record.mode) forKey:@"Mode"];
    if (isFile) {
        [objectsDic setObject:@(3) forKey:@"ProtectionClass"];
    }else{
        [objectsDic setObject:@(0) forKey:@"ProtectionClass"];
    }
    NSMutableDictionary *RelativePathDic = [NSMutableDictionary dictionary];
    [RelativePathDic setObject:@(2) forKey:@"CF$UID"];
    [objectsDic setObject:RelativePathDic forKey:@"RelativePath"];
    [objectsDic setObject:@(record.fileLength) forKey:@"Size"];
    [objectsDic setObject:@(record.userId) forKey:@"UserID"];
    [objectsList addObject:objectsDic];
    [objectsList addObject:record.path];
    if (createHash) {
        NSMutableDictionary *nsDataDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *nsUIDDic = [NSMutableDictionary dictionary];
        [nsUIDDic setObject:@(4) forKey:@"CF$UID"];
        [nsDataDic setObject:nsUIDDic forKey:@"$class"];
        NSData *data = nil;
        if (_sourceVersion >=10) {
            NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
            NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
            NSString *sourcefilePath = [folderPath stringByAppendingPathComponent:record.key];
            data = [[NSData alloc] initWithContentsOfFile:sourcefilePath];
        }else{
            data = [[NSData alloc] initWithContentsOfFile:[_sourceBackuppath stringByAppendingPathComponent:record.key]];
        }
        if (data) {
            [nsDataDic setObject:data forKey:@"NS.data"];
        }
        [data release];
        NSMutableDictionary *nsMutableDataDic = [NSMutableDictionary dictionary];
        NSMutableArray *nsMutableClasseslist = [NSMutableArray array];
        [nsMutableClasseslist addObject:@"NSMutableData"];
        [nsMutableClasseslist addObject:@"NSData"];
        [nsMutableClasseslist addObject:@"NSObject"];
        [nsMutableDataDic setObject:nsMutableClasseslist forKey:@"$classes"];
        [nsMutableDataDic setObject:@"NSMutableData" forKey:@"$classname"];
        [objectsList addObject:nsDataDic];
        [objectsList addObject:nsMutableDataDic];
    }
    NSMutableDictionary *endDic = [NSMutableDictionary dictionary];
    NSMutableArray *endClassesDic = [NSMutableArray array];
    [endClassesDic addObject:@"MBFile"];
    [endClassesDic addObject:@"NSObject"];
    [endDic setObject:endClassesDic forKey:@"$classes"];
    [endDic setObject:@"MBFile" forKey:@"$classname"];
    [objectsList addObject:endDic];
    [firstDic setObject:objectsList forKey:@"$objects"];
    NSMutableDictionary *topDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    [rootDic setObject:@(1) forKey:@"CF$UID"];
    [topDic setObject:rootDic forKey:@"root"];
    [firstDic setObject:topDic forKey:@"$top"];
    [firstDic setObject:@(100000) forKey:@"$version"];
    data = [firstDic toData];
    return data;
}

// Trigger
- (void)removeTrigger {
    @try {
        BOOL delval = NO;
        
        NSString *deleteCmd = nil;
        if (_targetVersion >= 9) {//iOS9以上的触发器
            deleteCmd = @"DROP TRIGGER add_to_deleted_messages;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER after_delete_on_attachment;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER after_delete_on_chat;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER after_delete_on_chat_handle_join;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER after_delete_on_chat_message_join;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER after_delete_on_message;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER after_delete_on_message_attachment_join;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER after_insert_on_chat_message_join;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER after_insert_on_message_attachment_join;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER before_delete_on_attachment;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
        }else {
            deleteCmd = @"DROP TRIGGER delete_attachment_files;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER before_delete_attachment_files;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER clean_orphaned_attachments;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER clean_orphaned_handles2;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER clear_message_has_attachments;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER set_message_has_attachments;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER clean_orphaned_handles;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
            
            deleteCmd = @"DROP TRIGGER clean_orphaned_messages;";
            delval = [_targetDBConnection executeUpdate:deleteCmd];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

- (void)createTrigger {
    @try {
        BOOL createval = NO;
        NSString *createCmd = nil;
        
        if (_targetVersion >= 9) {//iOS9以上的触发器
            createCmd = @"CREATE TRIGGER add_to_deleted_messages AFTER DELETE ON message BEGIN     INSERT INTO deleted_messages (guid) VALUES (OLD.guid); END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_attachment AFTER DELETE ON attachment BEGIN   SELECT delete_attachment_path(OLD.filename); END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_chat AFTER DELETE ON chat BEGIN DELETE FROM chat_message_join WHERE chat_id = OLD.ROWID; END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_chat_handle_join AFTER DELETE ON chat_handle_join BEGIN     DELETE FROM handle         WHERE handle.ROWID = OLD.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE other_handle = OLD.handle_id LIMIT 1) IS NULL; END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_chat_message_join AFTER DELETE ON chat_message_join BEGIN     UPDATE message       SET cache_roomnames = (         SELECT group_concat(c.room_name)         FROM chat c         INNER JOIN chat_message_join j ON c.ROWID = j.chat_id         WHERE           j.message_id = OLD.message_id       )       WHERE         message.ROWID = OLD.message_id;  DELETE FROM message WHERE message.ROWID = OLD.message_id AND OLD.message_id NOT IN (SELECT chat_message_join.message_id from chat_message_join WHERE chat_message_join.message_id = OLD.message_id LIMIT 1); END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_message AFTER DELETE ON message BEGIN     DELETE FROM handle         WHERE handle.ROWID = OLD.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE other_handle = OLD.handle_id LIMIT 1) IS NULL; END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_message_attachment_join AFTER DELETE ON message_attachment_join BEGIN     DELETE FROM attachment         WHERE attachment.ROWID = OLD.attachment_id     AND         (SELECT 1 from message_attachment_join WHERE attachment_id = OLD.attachment_id LIMIT 1) IS NULL; END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_insert_on_chat_message_join  AFTER INSERT ON chat_message_join BEGIN     UPDATE message       SET cache_roomnames = (         SELECT group_concat(c.room_name)         FROM chat c         INNER JOIN chat_message_join j ON c.ROWID = j.chat_id         WHERE           j.message_id = NEW.message_id       )       WHERE         message.ROWID = NEW.message_id; END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_insert_on_message_attachment_join AFTER INSERT ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 1     WHERE       message.ROWID = NEW.message_id; END";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER before_delete_on_attachment BEFORE DELETE ON attachment BEGIN   SELECT before_delete_attachment_path(OLD.ROWID, OLD.guid); END";
            createval = [_targetDBConnection executeUpdate:createCmd];
        }else {
            createCmd = @"CREATE TRIGGER delete_attachment_files AFTER DELETE ON attachment BEGIN SELECT delete_attachment_path(old.filename); END;";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER before_delete_attachment_files BEFORE DELETE ON attachment BEGIN   SELECT before_delete_attachment_path(old.ROWID, old.guid); END;";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clean_orphaned_attachments AFTER DELETE ON message_attachment_join BEGIN     DELETE FROM attachment         WHERE attachment.ROWID = old.attachment_id     AND         (SELECT 1 from message_attachment_join WHERE attachment_id = old.attachment_id LIMIT 1) IS NULL; END;";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clean_orphaned_handles2 AFTER DELETE ON message BEGIN     DELETE FROM handle         WHERE handle.ROWID = old.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = old.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = old.handle_id LIMIT 1) IS NULL; END;";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clear_message_has_attachments AFTER DELETE ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 0     WHERE       message.ROWID = old.message_id       AND       (SELECT 1 from message_attachment_join WHERE message_id = old.message_id LIMIT 1) IS NULL; END;";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER set_message_has_attachments AFTER INSERT ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 1     WHERE       message.ROWID = new.message_id; END;";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clean_orphaned_handles AFTER DELETE ON chat_handle_join BEGIN     DELETE FROM handleWHERE handle.ROWID = old.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = old.handle_id LIMIT 1) IS NULL     AND (SELECT 1 from message WHERE handle_id = old.handle_id LIMIT 1) IS NULL; END;";
            createval = [_targetDBConnection executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clean_orphaned_messages AFTER DELETE ON chat_message_join BEGIN DELETE FROM message     WHERE (SELECT 1 FROM chat_message_join        WHERE message_id = message.rowid         LIMIT 1     ) IS NULL; END;";
            createval = [_targetDBConnection executeUpdate:createCmd];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}



#pragma mark - merge
- (int)mergeChat:(NSString *)guid sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    int newrowId = -1;
    NSString *sql1 = @"select * from chat where guid=:guid";
    NSString *sql2 = nil;
    if ([self checkChatsuccessful_queryExist:targetDB]) {
        sql2 = @"insert into chat(guid,style,state,account_id,properties,chat_identifier,service_name,room_name,account_login,is_archived,last_addressed_handle,successful_query) values(?,?,?,?,?,?,?,?,?,?,?,?)";
    }else{
        sql2 = @"insert into chat(guid,style,state,account_id,properties,chat_identifier,service_name,room_name,account_login,is_archived,last_addressed_handle) values(?,?,?,?,?,?,?,?,?,?,?)";
    }
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:guid?:@"" forKey:@"guid"];
    FMResultSet *rs = [sourceDB executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        NSString *guid = [rs stringForColumn:@"guid"];
        int style = [rs intForColumn:@"style"];
        int state = [rs intForColumn:@"state"];
        NSString *account_id = [rs stringForColumn:@"account_id"];
        NSData *properties = nil;
        NSString *chat_identifier = [rs stringForColumn:@"chat_identifier"];
        NSString *service_name = [rs stringForColumn:@"service_name"];
        NSString *room_name = [rs stringForColumn:@"room_name"];
        NSString *account_login = [rs stringForColumn:@"account_login"];
        int is_archived = [rs intForColumn:@"is_archived"];
        NSString *last_addressed_handle = [rs stringForColumn:@"last_addressed_handle"];
        if ([self checkChatsuccessful_queryExist:targetDB]) {
            if ([targetDB executeUpdate:sql2,guid?guid:[self createGUID],[NSNumber numberWithInt:style],[NSNumber numberWithInt:state],account_id,properties,chat_identifier,service_name,room_name,account_login,[NSNumber numberWithInt:is_archived],last_addressed_handle,@(1)]) {
                newrowId = [self getTableMaxROWID:@"chat" targetDB:targetDB];
                [self updatesqlitesequenceSeq:targetDB seq:newrowId name:@"chat"];
            }else{
                //表明该chat已经存在
                NSString *sql = @"select ROWID from chat where guid=:guid";
                NSDictionary *dic = [NSDictionary dictionaryWithObject:guid?:@"" forKey:@"guid"];
                FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:dic];
                while ([rs next]) {
                    newrowId = [rs intForColumn:@"ROWID"];
                    break;
                }
                [rs close];
            }
        }else{
            if ([targetDB executeUpdate:sql2,guid?guid:[self createGUID],[NSNumber numberWithInt:style],[NSNumber numberWithInt:state],account_id,properties,chat_identifier,service_name,room_name,account_login,[NSNumber numberWithInt:is_archived],last_addressed_handle]) {
                newrowId = [self getTableMaxROWID:@"chat" targetDB:targetDB];
                [self updatesqlitesequenceSeq:targetDB seq:newrowId name:@"chat"];
            }else{
                //表明该chat已经存在
                NSString *sql = @"select ROWID from chat where guid=:guid";
                NSDictionary *dic = [NSDictionary dictionaryWithObject:guid?:@"" forKey:@"guid"];
                FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:dic];
                while ([rs next]) {
                    newrowId = [rs intForColumn:@"ROWID"];
                    break;
                }
                [rs close];
            }
            
        }
    }
    [rs close];
    return newrowId;
}

- (int)mergehandle:(NSString *)handleID service:(NSString *)service sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    @autoreleasepool {
        int newhandID = -1;
        NSString *sql1 = @"select * from handle where id=:handleID and service=:service";
        NSString *sql2 = @"insert into handle(id,country,service,uncanonicalized_id) values(?,?,?,?)";
        //执行sql语句,返回结果集
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:handleID,@"handleID",service,@"service",nil];
        FMResultSet *rs = [sourceDB executeQuery:sql1 withParameterDictionary:dic];
        while ([rs next]) {
            
            NSString *nid = [rs stringForColumn:@"id"];
            NSString *country = [rs stringForColumn:@"country"];
            NSString *service = [rs stringForColumn:@"service"];
            NSString *uncanonicalized_id = [rs stringForColumn:@"uncanonicalized_id"];
            BOOL success = [targetDB executeUpdate:sql2,nid,country,service,uncanonicalized_id];
            if (success) {
                newhandID = [self getTableMaxROWID:@"handle" targetDB:targetDB];
                [self updatesqlitesequenceSeq:targetDB seq:newhandID name:@"handle"];
            }else
            {
                NSString *sql = @"select ROWID from handle where id=:handleID and service=:service";
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:handleID,@"handleID",service,@"service",nil];
                FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:dic];
                while ([rs next]) {
                    newhandID = [rs intForColumn:@"ROWID"];
                    break;
                }
                [rs close];
            }
        }
        [rs close];
        return newhandID;
    }
}

- (void)mergechat_handle_join:(int)chatRowID handleID:(int)handleID targetDB:(FMDatabase *)targetDB
{
    @autoreleasepool {
        NSString *sql1 = @"insert into chat_handle_join(chat_id,handle_id) values(?,?)";
        //执行sql语句,返回结果集
        [targetDB executeUpdate:sql1,[NSNumber numberWithInt:chatRowID],[NSNumber numberWithInt:handleID]];
    }
}

- (void)mergeMessage:(int)chatID handID:(int)handID imchatID:(int)imchatID imhandID:(int)imhandID sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB chat:(IMBSMSChatDataEntity *)chat message:(IMBMessageDataEntity *)message
{
    //根据chatID查询出 accont_id
    NSString *account_id =[self getchatAccountid:chatID targetDB:targetDB];
    NSString *imaccount_id =[self getchatAccountid:imchatID targetDB:targetDB];
   // for (IMBMessageDataEntity *message in chat.msgModelList) {
        int newMessageRowID = -1;
        NSString *sql1 = @"select  * from Message where ROWID=:ROWID";
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:message.rowId] forKey:@"ROWID"];
        FMResultSet *rs = [sourceDB executeQuery:sql1 withParameterDictionary:dic];
        @autoreleasepool {
            
            NSString *sql2 = nil;
            if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                sql2 = @"insert into message(guid,text,replace,service_center,handle_id,subject,country,attributedBody,version,type,service,account,account_guid,error,date,date_read,date_delivered,is_delivered,is_finished,is_emote,is_from_me,is_empty,is_delayed,is_auto_reply,is_prepared,is_read,is_system_message,is_sent,has_dd_results,is_service_message,is_forward,was_downgraded,is_archive,cache_has_attachments,cache_roomnames,was_data_detected,was_deduplicated,date_played,associated_message_guid,associated_message_type,balloon_bundle_id,payload_data,expressive_send_style_id,associated_message_range_location,associated_message_range_length,time_expressive_send_played,message_summary_info) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            }else{
                sql2 = @"insert into message(guid,text,replace,service_center,handle_id,subject,country,attributedBody,version,type,service,account,account_guid,error,date,date_read,date_delivered,is_delivered,is_finished,is_emote,is_from_me,is_empty,is_delayed,is_auto_reply,is_prepared,is_read,is_system_message,is_sent,has_dd_results,is_service_message,is_forward,was_downgraded,is_archive,cache_has_attachments,cache_roomnames,was_data_detected,was_deduplicated) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            }
           
            //执行sql语句,返回结果集
            while ([rs next]) {
                int newchatId = -1;
                int msgID = [rs intForColumn:@"ROWID"];
                NSString *guid = [rs stringForColumn:@"guid"];
                if (!guid) {
                    guid = [self createGUID];
                }
                NSString *text = [rs stringForColumn:@"text"];
                int replace = [rs intForColumn:@"replace"];
                NSString *service_center = [rs stringForColumn:@"service_center"];
                NSString *service = [rs stringForColumn:@"service"];
                int handle_id = -1;
                NSString *account_guid = nil;
                if ([service isEqualToString:@"SMS"]) {
                    handle_id = handID;
                    account_guid = account_id;
                    newchatId = chatID;
                }else{
                    handle_id = imhandID;
                    account_guid = imaccount_id;
                    newchatId = imchatID;
                }
                NSString *subject = [rs stringForColumn:@"subject"];
                NSString *country = [rs stringForColumn:@"country"];
                NSData *attributedBody = [rs dataForColumn:@"attributedBody"];
                int version = [rs intForColumn:@"version"];
                int type = [rs intForColumn:@"type"];
                NSString *account = [rs stringForColumn:@"account"];
                int error = [rs intForColumn:@"error"];
                long long date = [rs longLongIntForColumn:@"date"];
                long long date_read = [rs longLongIntForColumn:@"date_read"];
                if (_targetVersion <11&&[DateHelper getDateLength:date]>=18) {
                    date = date/(1000*1000*1000*1.0);
                }
                if (_targetVersion <11&&[DateHelper getDateLength:date_read]>=18) {
                    date_read = date_read/(1000*1000*1000*1.0);
                }
                
                int date_delivered = [rs intForColumn:@"date_delivered"];
                int is_delivered = [rs intForColumn:@"is_delivered"];
                int is_finished = 1;
                int is_emote = [rs intForColumn:@"is_emote"];
                int is_from_me = [rs intForColumn:@"is_from_me"];
                int is_empty = [rs intForColumn:@"is_empty"];
                int is_delayed = [rs intForColumn:@"is_delayed"];
                int is_auto_reply = [rs intForColumn:@"is_auto_reply"];
                int is_prepared = [rs intForColumn:@"is_prepared"];
                int is_read = [rs intForColumn:@"is_read"];
                int is_system_message = [rs intForColumn:@"is_system_message"];
                int is_sent = [rs intForColumn:@"is_sent"];
                int has_dd_results = [rs intForColumn:@"has_dd_results"];
                int is_service_message = [rs intForColumn:@"is_service_message"];
                int is_forward = [rs intForColumn:@"is_forward"];
                int was_downgraded = [rs intForColumn:@"was_downgraded"];
                int is_archive = [rs intForColumn:@"is_archive"];
                int cache_has_attachments = [rs intForColumn:@"cache_has_attachments"];
                NSString *cache_roomnames = [rs stringForColumn:@"cache_roomnames"];
                int was_data_detected = [rs intForColumn:@"was_data_detected"];
                int was_deduplicated = [rs intForColumn:@"was_deduplicated"];
                if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                    id date_played = @(0);
                    id associated_message_guid = [NSNull null];
                    id associated_message_type = @(0);
                    id balloon_bundle_id = [NSNull null];
                    id payload_data = [NSNull null];
                    id expressive_send_style_id = [NSNull null];
                    id associated_message_range_location = @(0);
                    id associated_message_range_length = @(0);
                    id time_expressive_send_played = @(0);
                    id message_summary_info = [NSNull null];
                    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                        date_played = [rs objectForColumnName:@"date_played"];
                        associated_message_guid = [rs objectForColumnName:@"associated_message_guid"];
                        associated_message_type = [rs objectForColumnName:@"associated_message_type"];
                        balloon_bundle_id = [rs objectForColumnName:@"balloon_bundle_id"];
                        payload_data = [rs objectForColumnName:@"payload_data"];
                        expressive_send_style_id = [rs objectForColumnName:@"expressive_send_style_id"];
                        associated_message_range_location = [rs objectForColumnName:@"associated_message_range_location"];
                        associated_message_range_length = [rs objectForColumnName:@"associated_message_range_length"];
                        time_expressive_send_played = [rs objectForColumnName:@"time_expressive_send_played"];
                        message_summary_info = [rs objectForColumnName:@"message_summary_info"];
                    }
                    if ([targetDB executeUpdate:sql2,guid,text,[NSNumber numberWithInt:replace],service_center,[NSNumber numberWithInt:handle_id],subject,country,attributedBody,[NSNumber numberWithInt:version],[NSNumber numberWithInt:type],service,account,account_guid,[NSNumber numberWithInt:error],[NSNumber numberWithLongLong:date],[NSNumber numberWithLongLong:date_read],[NSNumber numberWithInt:date_delivered],[NSNumber numberWithInt:is_delivered],[NSNumber numberWithInt:is_finished],[NSNumber numberWithInt:is_emote],[NSNumber numberWithInt:is_from_me],[NSNumber numberWithInt:is_empty],[NSNumber numberWithInt:is_delayed],[NSNumber numberWithInt:is_auto_reply],[NSNumber numberWithInt:is_prepared],[NSNumber numberWithInt:is_read],[NSNumber numberWithInt:is_system_message],[NSNumber numberWithInt:is_sent],[NSNumber numberWithInt:has_dd_results],[NSNumber numberWithInt:is_service_message],[NSNumber numberWithInt:is_forward],[NSNumber numberWithInt:was_downgraded],[NSNumber numberWithInt:is_archive],[NSNumber numberWithInt:cache_has_attachments],cache_roomnames,[NSNumber numberWithInt:was_data_detected],[NSNumber numberWithInt:was_deduplicated],date_played,associated_message_guid,associated_message_type,balloon_bundle_id,payload_data,expressive_send_style_id,associated_message_range_location,associated_message_range_length,time_expressive_send_played,message_summary_info]) {
                        newMessageRowID = [self getTableMaxROWID:@"message" targetDB:targetDB];
                        [self updatesqlitesequenceSeq:targetDB seq:newMessageRowID name:@"message"];
                        [self mergeAttachment:msgID newMsgID:newMessageRowID sourceDB:sourceDB targetDB:targetDB];
                        if (newchatId !=-1 &&newMessageRowID != -1) {
                            if ([_targetFloatVersion isVersionMajorEqual:@"11"]) {
                                [self mergechat_message_join11:newchatId messageID:newMessageRowID message_date:date targetDB:(FMDatabase *)targetDB];
                            }else{
                                [self mergechat_message_join:newchatId messageID:newMessageRowID targetDB:(FMDatabase *)targetDB];
                            }
                        }
                    }else if ([targetDB executeUpdate:sql2,[self createGUID],text,[NSNumber numberWithInt:replace],service_center,[NSNumber numberWithInt:handle_id],subject,country,attributedBody,[NSNumber numberWithInt:version],[NSNumber numberWithInt:type],service,account,account_guid,[NSNumber numberWithInt:error],[NSNumber numberWithLongLong:date],[NSNumber numberWithLongLong:date_read],[NSNumber numberWithInt:date_delivered],[NSNumber numberWithInt:is_delivered],[NSNumber numberWithInt:is_finished],[NSNumber numberWithInt:is_emote],[NSNumber numberWithInt:is_from_me],[NSNumber numberWithInt:is_empty],[NSNumber numberWithInt:is_delayed],[NSNumber numberWithInt:is_auto_reply],[NSNumber numberWithInt:is_prepared],[NSNumber numberWithInt:is_read],[NSNumber numberWithInt:is_system_message],[NSNumber numberWithInt:is_sent],[NSNumber numberWithInt:has_dd_results],[NSNumber numberWithInt:is_service_message],[NSNumber numberWithInt:is_forward],[NSNumber numberWithInt:was_downgraded],[NSNumber numberWithInt:is_archive],[NSNumber numberWithInt:cache_has_attachments],cache_roomnames,[NSNumber numberWithInt:was_data_detected],[NSNumber numberWithInt:was_deduplicated],date_played,associated_message_guid,associated_message_type,balloon_bundle_id,payload_data,expressive_send_style_id,associated_message_range_location,associated_message_range_length,time_expressive_send_played,message_summary_info]){
                        newMessageRowID = [self getTableMaxROWID:@"message" targetDB:targetDB];
                        [self updatesqlitesequenceSeq:targetDB seq:newMessageRowID name:@"message"];
                        [self mergeAttachment:msgID newMsgID:newMessageRowID sourceDB:sourceDB targetDB:targetDB];
                        if (newchatId !=-1 &&newMessageRowID != -1) {
                            if ([_targetFloatVersion isVersionMajorEqual:@"11"]) {
                                [self mergechat_message_join11:newchatId messageID:newMessageRowID message_date:date targetDB:(FMDatabase *)targetDB];
                            }else{
                                [self mergechat_message_join:newchatId messageID:newMessageRowID targetDB:(FMDatabase *)targetDB];
                            }
                        }
                    }

                }else{
                    if ([targetDB executeUpdate:sql2,guid,text,[NSNumber numberWithInt:replace],service_center,[NSNumber numberWithInt:handle_id],subject,country,attributedBody,[NSNumber numberWithInt:version],[NSNumber numberWithInt:type],service,account,account_guid,[NSNumber numberWithInt:error],[NSNumber numberWithLongLong:date],[NSNumber numberWithLongLong:date_read],[NSNumber numberWithInt:date_delivered],[NSNumber numberWithInt:is_delivered],[NSNumber numberWithInt:is_finished],[NSNumber numberWithInt:is_emote],[NSNumber numberWithInt:is_from_me],[NSNumber numberWithInt:is_empty],[NSNumber numberWithInt:is_delayed],[NSNumber numberWithInt:is_auto_reply],[NSNumber numberWithInt:is_prepared],[NSNumber numberWithInt:is_read],[NSNumber numberWithInt:is_system_message],[NSNumber numberWithInt:is_sent],[NSNumber numberWithInt:has_dd_results],[NSNumber numberWithInt:is_service_message],[NSNumber numberWithInt:is_forward],[NSNumber numberWithInt:was_downgraded],[NSNumber numberWithInt:is_archive],[NSNumber numberWithInt:cache_has_attachments],cache_roomnames,[NSNumber numberWithInt:was_data_detected],[NSNumber numberWithInt:was_deduplicated]]) {
                        newMessageRowID = [self getTableMaxROWID:@"message" targetDB:targetDB];
                        [self updatesqlitesequenceSeq:targetDB seq:newMessageRowID name:@"message"];
                        [self mergeAttachment:msgID newMsgID:newMessageRowID sourceDB:sourceDB targetDB:targetDB];
                        if (newchatId !=-1 &&newMessageRowID != -1) {
                            if ([_targetFloatVersion isVersionMajorEqual:@"11"]) {
                                [self mergechat_message_join11:newchatId messageID:newMessageRowID message_date:date targetDB:(FMDatabase *)targetDB];
                            }else{
                                [self mergechat_message_join:newchatId messageID:newMessageRowID targetDB:(FMDatabase *)targetDB];
                            }
                        }
                    }else if ([targetDB executeUpdate:sql2,[self createGUID],text,[NSNumber numberWithInt:replace],service_center,[NSNumber numberWithInt:handle_id],subject,country,attributedBody,[NSNumber numberWithInt:version],[NSNumber numberWithInt:type],service,account,account_guid,[NSNumber numberWithInt:error],[NSNumber numberWithLongLong:date],[NSNumber numberWithLongLong:date_read],[NSNumber numberWithInt:date_delivered],[NSNumber numberWithInt:is_delivered],[NSNumber numberWithInt:is_finished],[NSNumber numberWithInt:is_emote],[NSNumber numberWithInt:is_from_me],[NSNumber numberWithInt:is_empty],[NSNumber numberWithInt:is_delayed],[NSNumber numberWithInt:is_auto_reply],[NSNumber numberWithInt:is_prepared],[NSNumber numberWithInt:is_read],[NSNumber numberWithInt:is_system_message],[NSNumber numberWithInt:is_sent],[NSNumber numberWithInt:has_dd_results],[NSNumber numberWithInt:is_service_message],[NSNumber numberWithInt:is_forward],[NSNumber numberWithInt:was_downgraded],[NSNumber numberWithInt:is_archive],[NSNumber numberWithInt:cache_has_attachments],cache_roomnames,[NSNumber numberWithInt:was_data_detected],[NSNumber numberWithInt:was_deduplicated]]){
                        newMessageRowID = [self getTableMaxROWID:@"message" targetDB:targetDB];
                        [self updatesqlitesequenceSeq:targetDB seq:newMessageRowID name:@"message"];
                        [self mergeAttachment:msgID newMsgID:newMessageRowID sourceDB:sourceDB targetDB:targetDB];
                        if (newchatId !=-1 &&newMessageRowID != -1) {
                            if ([_targetFloatVersion isVersionMajorEqual:@"11"]) {
                                [self mergechat_message_join11:newchatId messageID:newMessageRowID message_date:date targetDB:(FMDatabase *)targetDB];
                            }else{
                                [self mergechat_message_join:newchatId messageID:newMessageRowID targetDB:(FMDatabase *)targetDB];
                            }
                        }
                    }
                }
            }
            [rs close];
        }
}

- (void)mergechat_message_join:(int)chatId messageID:(int)messageID targetDB:(FMDatabase *)targetDB
{
    NSString *sql = @"insert into chat_message_join(chat_id,message_id) values(?,?)";
    //执行sql语句,返回结果集
    [targetDB executeUpdate:sql,[NSNumber numberWithInt:chatId],[NSNumber numberWithInt:messageID]];
}

- (void)mergechat_message_join11:(int)chatId messageID:(int)messageID message_date:(int64_t)message_date  targetDB:(FMDatabase *)targetDB
{
    NSString *sql = @"insert into chat_message_join(chat_id,message_id,message_date) values(?,?,?)";
    //执行sql语句,返回结果集
    [targetDB executeUpdate:sql,[NSNumber numberWithInt:chatId],[NSNumber numberWithInt:messageID],[NSNumber numberWithLongLong:message_date]];
}

- (void)mergeAttachment:(int)oldMsgID newMsgID:(int)newMsgID sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB
{
    int newattchmentID = -1;
    BOOL sourceExist = [self checkattachmentTotalBytesExist:sourceDB];
    BOOL targetExist = [self checkattachmentTotalBytesExist:targetDB];
    NSString *selectsql = @"SELECT * FROM attachment where ROWID in (select attachment_id from message_attachment_join where message_id=:messageid);";
    NSString *insertsql = nil;
    if (sourceExist&&targetExist) {
        if ([_targetFloatVersion isVersionMajorEqual:@"11"]) {
            insertsql = @"insert into attachment(guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing,user_info,transfer_name,total_bytes,is_sticker,sticker_user_info,attribution_info,hide_attachment,ck_sync_state,original_guid) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            
        }else if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
            insertsql = @"insert into attachment(guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing,user_info,transfer_name,total_bytes,is_sticker,sticker_user_info,attribution_info) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        }else{
            insertsql = @"insert into attachment(guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing,user_info,transfer_name,total_bytes) values(?,?,?,?,?,?,?,?,?,?,?)";
        }
        
    }else{
        insertsql = @"insert into attachment(guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing) values(?,?,?,?,?,?,?,?)";
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:oldMsgID] forKey:@"messageid"];
    //执行sql语句,返回结果集
    FMResultSet *rs = [sourceDB executeQuery:selectsql withParameterDictionary:dic];
    while ([rs next]) {
        @autoreleasepool {
            NSString *guid = [rs stringForColumn:@"guid"];
            int created_date = [rs intForColumn:@"created_date"];
            int start_date = [rs intForColumn:@"start_date"];
            NSString *filename = [rs stringForColumn:@"filename"];
            NSString *uti = [rs stringForColumn:@"uti"];
            NSString *mime_type = [rs stringForColumn:@"mime_type"];
            int transfer_state = [rs intForColumn:@"transfer_state"];
            int is_outgoing = [rs intForColumn:@"is_outgoing"];
            if (sourceExist&&targetExist) {
                NSData *user_info = [rs dataForColumn:@"user_info"];
                NSString *transfer_name = [rs stringForColumn:@"transfer_name"];
                int total_bytes = [rs intForColumn:@"total_bytes"];
                if ([_targetFloatVersion isVersionMajorEqual:@"11"]) {
                    id is_sticker = @(0);
                    id sticker_user_info = [NSNull null];
                    id attribution_info = [NSNull null];
                    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                        is_sticker = [rs objectForColumnName:@"is_sticker"];
                        sticker_user_info = [rs objectForColumnName:@"sticker_user_info"];
                        attribution_info = [rs objectForColumnName:@"attribution_info"];
                    }
                    NSString *gguid = guid?guid:[self createGUID];
                    if ([targetDB executeUpdate:insertsql,gguid,[NSNumber numberWithInt:created_date],[NSNumber numberWithInt:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing],user_info,transfer_name,[NSNumber numberWithInt:total_bytes],is_sticker,sticker_user_info,attribution_info,@(0),@(0),gguid]) {
                        newattchmentID = [self getTableMaxROWID:@"attachment" targetDB:targetDB];
                        [self updatesqlitesequenceSeq:targetDB seq:newattchmentID name:@"attachment"];
                    }else{
                        NSString *sql = @"select ROWID from attachment where guid=:guid";
                        NSDictionary *dic = [NSDictionary dictionaryWithObject:guid forKey:@"guid"];
                        FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:dic];
                        while ([rs next]) {
                            newattchmentID = [rs intForColumn:@"ROWID"];
                            break;
                        }
                        [rs close];
                    }
                    
                }else if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                    id is_sticker = @(0);
                    id sticker_user_info = [NSNull null];
                    id attribution_info = [NSNull null];
                    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                        is_sticker = [rs objectForColumnName:@"is_sticker"];
                        sticker_user_info = [rs objectForColumnName:@"sticker_user_info"];
                        attribution_info = [rs objectForColumnName:@"attribution_info"];
                    }
                    if ([targetDB executeUpdate:insertsql,guid?guid:[self createGUID],[NSNumber numberWithInt:created_date],[NSNumber numberWithInt:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing],user_info,transfer_name,[NSNumber numberWithInt:total_bytes],is_sticker,sticker_user_info,attribution_info]) {
                        newattchmentID = [self getTableMaxROWID:@"attachment" targetDB:targetDB];
                        [self updatesqlitesequenceSeq:targetDB seq:newattchmentID name:@"attachment"];
                    }else{
                        NSString *sql = @"select ROWID from attachment where guid=:guid";
                        NSDictionary *dic = [NSDictionary dictionaryWithObject:guid forKey:@"guid"];
                        FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:dic];
                        while ([rs next]) {
                            newattchmentID = [rs intForColumn:@"ROWID"];
                            break;
                        }
                        [rs close];
                    }
                }else{
                    if ([targetDB executeUpdate:insertsql,guid?guid:[self createGUID],[NSNumber numberWithInt:created_date],[NSNumber numberWithInt:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing],user_info,transfer_name,[NSNumber numberWithInt:total_bytes]]) {
                        newattchmentID = [self getTableMaxROWID:@"attachment" targetDB:targetDB];
                        [self updatesqlitesequenceSeq:targetDB seq:newattchmentID name:@"attachment"];
                    }else{
                        NSString *sql = @"select ROWID from attachment where guid=:guid";
                        NSDictionary *dic = [NSDictionary dictionaryWithObject:guid forKey:@"guid"];
                        FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:dic];
                        while ([rs next]) {
                            newattchmentID = [rs intForColumn:@"ROWID"];
                            break;
                        }
                        [rs close];
                    }
                }
                if (filename.length>0&&![attachfileNameArray containsObject:filename]) {
                    [attachfileNameArray addObject:filename];
                }
                if (newMsgID != -1&&newattchmentID != -1) {
                    [self mergeMesage_attachment_join:newMsgID attachmentRowID:newattchmentID targetDB:targetDB];
                }
            }else{
                if ([targetDB executeUpdate:insertsql,guid?guid:[self createGUID],[NSNumber numberWithInt:created_date],[NSNumber numberWithInt:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing]]) {
                    newattchmentID = [self getTableMaxROWID:@"attachment" targetDB:targetDB];
                    [self updatesqlitesequenceSeq:targetDB seq:newattchmentID name:@"attachment"];
                    
                }else{
                    NSString *sql = @"select ROWID from attachment where guid=:guid";
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:guid forKey:@"guid"];
                    FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:dic];
                    while ([rs next]) {
                        newattchmentID = [rs intForColumn:@"ROWID"];
                        break;
                    }
                    [rs close];
                }
                if (filename.length>0&&![attachfileNameArray containsObject:filename]) {
                    [attachfileNameArray addObject:filename];
                }
                if (newMsgID != -1&&newattchmentID != -1) {
                    [self mergeMesage_attachment_join:newMsgID attachmentRowID:newattchmentID targetDB:targetDB];
                }
            }
        }
    }
}

- (BOOL)checkattachmentTotalBytesExist:(FMDatabase *)targetDB
{
    NSString *name = nil;
    NSString *sql = @"select name from sqlite_master where name = 'attachment' and sql like '%total_bytes%'";
    FMResultSet *set = [targetDB executeQuery:sql];
    while ([set next]) {
        name = [set stringForColumn:@"name"];
    }
    if (name) {
        return YES;
    }else{
        return NO;
    }
    [set close];
}


- (void)mergeMesage_attachment_join:(int)messageRowID attachmentRowID:(int)attachmentRowID targetDB:(FMDatabase *)targetDB
{
    NSString *sql = @"insert into message_attachment_join(message_id,attachment_id) values(?,?)";
    //执行sql语句,返回结果集
    [targetDB executeUpdate:sql,[NSNumber numberWithInt:messageRowID],[NSNumber numberWithInt:attachmentRowID]];
}


- (NSString *)getchatAccountid:(int)chatid targetDB:(FMDatabase *)targetDB
{
    NSString *account = nil;
    NSString *sql = @"select account_id from chat where ROWID=:ROWID";
    FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:[NSDictionary dictionaryWithObject:@(chatid) forKey:@"ROWID"]];
    while ([rs next]) {
        account = [rs stringForColumn:@"account_id"];
    }
    return account;
}


- (BOOL)checkChatsuccessful_queryExist:(FMDatabase *)targetDB
{
    NSString *sql = @"select name from sqlite_master where name = 'chat' and sql like '%successful_query%'";
    FMResultSet *set = [targetDB executeQuery:sql];
    NSString *name = nil;
    while ([set next]) {
        name = [set stringForColumn:@"name"];
    }
    if (name) {
        return YES;
    }else{
        return NO;
    }
    [set close];
}

- (int)getTableMaxROWID:(NSString *)tableName targetDB:(FMDatabase *)targetDB
{
    int maxRowID = -1;
    NSString *sql = [@"select last_insert_rowid() from " stringByAppendingString:tableName];
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        maxRowID = [rs intForColumn:@"last_insert_rowid()"];
        break;
    }
    [rs close];
    return maxRowID;
}

- (void)updatesqlitesequenceSeq:(FMDatabase *)targetDB seq:(int)seq name:(NSString *)name
{
    NSString *sql1 = @"update sqlite_sequence set seq=:seq WHERE name=:name";
    [targetDB executeUpdate:sql1 withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@(seq),@"seq",name?:@"",@"name", nil]];
}

#pragma mark - Clone
- (void)clone
{
    if (_sourceVersion<=_targetVersion) {
        int version = _sourceVersion;
        _sourceVersion = _targetVersion;
        _targetVersion = version;
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                return;
            }
            //交换 源和目标设备
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
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            if (_targetVersion >5) {
                //清除目标设备数据库所有的数据
                if (_targetVersion >= 9) {
                    [self deleteAllDataWithiOS9];
                }else {
                    [self deleteAllDataWithiOS6];
                }
                if (_targetVersion >= 7) {
                    [self insertattachmentWithiOS7];
                    [self insertchatWithiOS7];
                }else if (_targetVersion == 6)
                {
                    [self insertattachmentWithiOS6];
                    [self insertchatWithiOS6];
                }
                [self insertchat_handle_join];
                [self insertchat_message_join];
                [self inserthandle];
                [self insertmessage];
                [self insertmessage_attachment_join];
            }
        }
        if (![_sourceDBConnection commit]) {
            [_sourceDBConnection rollback];
        }
        if (![_targetDBConnection commit]) {
            [_targetDBConnection rollback];
        }
        [self closeDataBase:_sourceDBConnection];
        [self closeDataBase:_targetDBConnection];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [_logHandle writeInfoLog:@"copy clone message files enter"];
    NSMutableArray *attachRecordArray = [NSMutableArray array];
    for (IMBMBFileRecord *record in _sourcerecordArray) {
        if ([record.path hasPrefix:
            @"Library/SMS/Attachments"]) {
            [attachRecordArray addObject:record];
        }
    }
    if ([_targetFloatVersion isVersionLess:@"10"]) {
        if ([attachRecordArray count] == 0) {
            [self modifyHashAndManifest];
            return;
        }
        NSFileManager *fileM = [NSFileManager defaultManager];
        NSMutableArray *lowRecordArray = _targetrecordArray;
        NSMutableArray *lowAttachRecordArray = [NSMutableArray array];
        NSMutableArray *lowNewRecordArray1 = [NSMutableArray array];
        NSMutableArray *lowNewRecordArray2 = [NSMutableArray array];
        BOOL canAdd = YES;
        for (int i=0;i<[lowRecordArray count];i++ ) {
            
            IMBMBFileRecord *record = [lowRecordArray objectAtIndex:i];
            if (canAdd) {
                [lowNewRecordArray1 addObject:record];
            }else
            {
                [lowNewRecordArray2 addObject:record];
            }
            
            if ([record.path isEqualToString:@"Library/SMS"]&&[record.domain isEqualToString:@"MediaDomain"]) {
                canAdd = NO;
            }
            if ([record.path hasPrefix:
                 @"Library/SMS/Attachments"]) {
                [lowAttachRecordArray addObject:record];
                if (record.filetype == FileType_Backup) {
                    NSString *filePath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
                    [fileM removeItemAtPath:filePath error:nil];
                }
            }
        }
        [lowRecordArray removeAllObjects];
        [lowRecordArray addObjectsFromArray:lowNewRecordArray1];
        [lowRecordArray addObjectsFromArray:attachRecordArray];
        [lowNewRecordArray2 removeObjectsInArray:lowAttachRecordArray];
        [lowRecordArray addObjectsFromArray:lowNewRecordArray2];
        
        for (IMBMBFileRecord *record in attachRecordArray) {
            if (record.filetype == FileType_Backup) {
                NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
                NSString *sourcePath = nil;
                if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                    NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                    sourcePath = [folderPath stringByAppendingPathComponent:record.key];
                }else{
                    sourcePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
                }
                NSString *desPath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
                if ([fileM fileExistsAtPath:desPath]) {
                    [fileM removeItemAtPath:desPath error:nil];
                }
                if ([fileM fileExistsAtPath:sourcePath]) {
                    [record setDataHash:[IMBBaseClone dataHashfilePath:sourcePath]];
                    int64_t fileSize = [IMBUtilTool fileSizeAtPath:sourcePath];
                    [record changeFileLength:fileSize];
                    [fileM copyItemAtPath:sourcePath toPath:desPath error:nil];
                }
            }
        }
        //修改HashandManifest
        [self modifyHashAndManifest];

    }else{
        //删掉目标设备中 所有的附件信息
        NSPredicate *cate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMBMBFileRecord *record = (IMBMBFileRecord *)evaluatedObject;
            if ([record.path hasPrefix:@"Library/SMS/Attachments"]) {
                return YES;
            }else{
                return NO;
            }
        }];
        
        NSArray *attRecord = [_targetrecordArray filteredArrayUsingPredicate:cate];
        [self deleteRecords:attRecord TargetDB:_targetManifestDBConnection];
        if ([attachRecordArray count] == 0) {
            [self modifyHashAndManifest];
            return;
        }else{
            [self createAttachmentPlist:attachRecordArray TargetDB:_targetManifestDBConnection isClone:YES];
        }
        [self modifyHashAndManifest];
    }
        [_logHandle writeInfoLog:@"copy clone message files end"];
}

//删除iOS9触发器---dingming
- (void)deleteAllDataWithiOS9
{
    NSString *sql2 = @"delete from attachment";
    NSString *sql3 = @"delete from chat";
    NSString *sql4 = @"delete from chat_handle_join";
    NSString *sql5 = @"delete from chat_message_join";
    NSString *sql6 = @"delete from handle";
    NSString *sql7 = @"delete from message";
    NSString *sql8 = @"delete from message_attachment_join";
    
    BOOL trigger1 = NO;
    BOOL trigger2 = NO;
    BOOL trigger3 = NO;
    BOOL trigger4 = NO;
    BOOL trigger5 = NO;
    BOOL trigger6 = NO;
    BOOL trigger7 = NO;
    BOOL trigger8 = NO;
    BOOL trigger9 = NO;
    BOOL trigger10 = NO;
    NSString *deletetrigger1 = @"DROP TRIGGER add_to_deleted_messages";
    NSString *deletetrigger2 = @"DROP TRIGGER after_delete_on_attachment";
    NSString *deletetrigger3 = @"DROP TRIGGER after_delete_on_chat";
    NSString *deletetrigger4 = @"DROP TRIGGER after_delete_on_chat_handle_join";
    NSString *deletetrigger5 = @"DROP TRIGGER after_delete_on_chat_message_join";
    NSString *deletetrigger6 = @"DROP TRIGGER after_delete_on_message";
    NSString *deletetrigger7 = @"DROP TRIGGER after_delete_on_message_attachment_join";
    NSString *deletetrigger8 = @"DROP TRIGGER after_insert_on_chat_message_join";
    NSString *deletetrigger9 = @"DROP TRIGGER after_insert_on_message_attachment_join";
    NSString *deletetrigger10 = @"DROP TRIGGER before_delete_on_attachment";
    @try {
        
        if ([_targetDBConnection executeUpdate:deletetrigger1]) {
            trigger1 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger2]) {
            trigger2 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger3]) {
            trigger3 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger4]) {
            trigger4 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger5]) {
            trigger5 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger6]) {
            trigger6 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger7]) {
            trigger7 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger8]) {
            trigger8 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger9]) {
            trigger9 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger10]) {
            trigger10 = YES;
        }
        
        [_targetDBConnection executeUpdate:sql2];
        [_targetDBConnection executeUpdate:sql3];
        [_targetDBConnection executeUpdate:sql4];
        [_targetDBConnection executeUpdate:sql5];
        [_targetDBConnection executeUpdate:sql6];
        [_targetDBConnection executeUpdate:sql7];
        [_targetDBConnection executeUpdate:sql8];
        if (trigger1) {
            NSString *createTrigger = @"CREATE TRIGGER add_to_deleted_messages AFTER DELETE ON message BEGIN     INSERT INTO deleted_messages (guid) VALUES (OLD.guid); END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger2) {
            NSString *createTrigger = @"CREATE TRIGGER after_delete_on_attachment AFTER DELETE ON attachment BEGIN   SELECT delete_attachment_path(OLD.filename); END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger3) {
            NSString *createTrigger = @"CREATE TRIGGER after_delete_on_chat AFTER DELETE ON chat BEGIN DELETE FROM chat_message_join WHERE chat_id = OLD.ROWID; END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger4) {
            NSString *createTrigger = @"CREATE TRIGGER after_delete_on_chat_handle_join AFTER DELETE ON chat_handle_join BEGIN     DELETE FROM handle         WHERE handle.ROWID = OLD.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE other_handle = OLD.handle_id LIMIT 1) IS NULL; END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger5) {
            NSString *createTrigger = @"CREATE TRIGGER after_delete_on_chat_message_join AFTER DELETE ON chat_message_join BEGIN     UPDATE message       SET cache_roomnames = (         SELECT group_concat(c.room_name)         FROM chat c         INNER JOIN chat_message_join j ON c.ROWID = j.chat_id         WHERE           j.message_id = OLD.message_id       )       WHERE         message.ROWID = OLD.message_id;  DELETE FROM message WHERE message.ROWID = OLD.message_id AND OLD.message_id NOT IN (SELECT chat_message_join.message_id from chat_message_join WHERE chat_message_join.message_id = OLD.message_id LIMIT 1); END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger6) {
            NSString *createTrigger = @"CREATE TRIGGER after_delete_on_message AFTER DELETE ON message BEGIN     DELETE FROM handle         WHERE handle.ROWID = OLD.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE other_handle = OLD.handle_id LIMIT 1) IS NULL; END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger7) {
            NSString *createTrigger = @"CREATE TRIGGER after_delete_on_message_attachment_join AFTER DELETE ON message_attachment_join BEGIN     DELETE FROM attachment         WHERE attachment.ROWID = OLD.attachment_id     AND         (SELECT 1 from message_attachment_join WHERE attachment_id = OLD.attachment_id LIMIT 1) IS NULL; END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger8) {
            NSString *createTrigger = @"CREATE TRIGGER after_insert_on_chat_message_join  AFTER INSERT ON chat_message_join BEGIN     UPDATE message       SET cache_roomnames = (         SELECT group_concat(c.room_name)         FROM chat c         INNER JOIN chat_message_join j ON c.ROWID = j.chat_id         WHERE           j.message_id = NEW.message_id       )       WHERE         message.ROWID = NEW.message_id; END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger9) {
            NSString *createTrigger = @"CREATE TRIGGER after_insert_on_message_attachment_join AFTER INSERT ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 1     WHERE       message.ROWID = NEW.message_id; END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger10) {
            NSString *createTrigger = @"CREATE TRIGGER before_delete_on_attachment BEFORE DELETE ON attachment BEGIN   SELECT before_delete_attachment_path(OLD.ROWID, OLD.guid); END";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@",exception);
    }
    @finally {
        
    }
}

- (void)deleteAllDataWithiOS6
{
    NSString *sql2 = @"delete from attachment";
    NSString *sql3 = @"delete from chat";
    NSString *sql4 = @"delete from chat_handle_join";
    NSString *sql5 = @"delete from chat_message_join";
    NSString *sql6 = @"delete from handle";
    NSString *sql7 = @"delete from message";
    NSString *sql8 = @"delete from message_attachment_join";
    
    BOOL trigger1 = NO;
    BOOL trigger2 = NO;
    BOOL trigger3 = NO;
    BOOL trigger4 = NO;
    BOOL trigger5 = NO;
    BOOL trigger6 = NO;
    BOOL trigger7 = NO;
    BOOL trigger8 = NO;
    NSString *deletetrigger1 = @"DROP TRIGGER delete_attachment_files";
    NSString *deletetrigger2 = @"DROP TRIGGER before_delete_attachment_files";
    NSString *deletetrigger3 = @"DROP TRIGGER clean_orphaned_attachments";
    NSString *deletetrigger4 = @"DROP TRIGGER clean_orphaned_handles2";
    NSString *deletetrigger5 = @"DROP TRIGGER clear_message_has_attachments";
    NSString *deletetrigger6 = @"DROP TRIGGER set_message_has_attachments";
    NSString *deletetrigger7 = @"DROP TRIGGER clean_orphaned_handles";
    NSString *deletetrigger8 = @"DROP TRIGGER clean_orphaned_messages";
    
    @try {
        
        if ([_targetDBConnection executeUpdate:deletetrigger1]) {
            trigger1 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger2]) {
            trigger2 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger3]) {
            trigger3 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger4]) {
            trigger4 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger5]) {
            trigger5 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger6]) {
            trigger6 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger7]) {
            trigger7 = YES;
        }
        if ([_targetDBConnection executeUpdate:deletetrigger8]) {
            trigger8 = YES;
        }

        [_targetDBConnection executeUpdate:sql2];
        [_targetDBConnection executeUpdate:sql3];
        [_targetDBConnection executeUpdate:sql4];
        [_targetDBConnection executeUpdate:sql5];
        [_targetDBConnection executeUpdate:sql6];
        [_targetDBConnection executeUpdate:sql7];
        [_targetDBConnection executeUpdate:sql8];
        if (trigger1) {
            NSString *createTrigger = @"CREATE TRIGGER delete_attachment_files AFTER DELETE ON attachment BEGIN SELECT delete_attachment_path(old.filename); END;";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger2) {
            NSString *createTrigger = @"CREATE TRIGGER before_delete_attachment_files BEFORE DELETE ON attachment BEGIN   SELECT before_delete_attachment_path(old.ROWID, old.guid); END;";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger3) {
            NSString *createTrigger = @"CREATE TRIGGER clean_orphaned_attachments AFTER DELETE ON message_attachment_join BEGIN     DELETE FROM attachment         WHERE attachment.ROWID = old.attachment_id     AND         (SELECT 1 from message_attachment_join WHERE attachment_id = old.attachment_id LIMIT 1) IS NULL; END;";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger4) {
            NSString *createTrigger = @"CREATE TRIGGER clean_orphaned_handles2 AFTER DELETE ON message BEGIN     DELETE FROM handle         WHERE handle.ROWID = old.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = old.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = old.handle_id LIMIT 1) IS NULL; END;";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger5) {
            NSString *createTrigger = @"CREATE TRIGGER clear_message_has_attachments AFTER DELETE ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 0     WHERE       message.ROWID = old.message_id       AND       (SELECT 1 from message_attachment_join WHERE message_id = old.message_id LIMIT 1) IS NULL; END;";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger6) {
            NSString *createTrigger = @"CREATE TRIGGER set_message_has_attachments AFTER INSERT ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 1     WHERE       message.ROWID = new.message_id; END;";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger7) {
            NSString *createTrigger = @"CREATE TRIGGER clean_orphaned_handles AFTER DELETE ON chat_handle_join BEGIN     DELETE FROM handleWHERE handle.ROWID = old.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = old.handle_id LIMIT 1) IS NULL     AND (SELECT 1 from message WHERE handle_id = old.handle_id LIMIT 1) IS NULL; END;";
            [_targetDBConnection executeUpdate:createTrigger];
        }
        if (trigger8) {
            NSString *createTrigger = @"CREATE TRIGGER clean_orphaned_messages AFTER DELETE ON chat_message_join BEGIN DELETE FROM message     WHERE (SELECT 1 FROM chat_message_join        WHERE message_id = message.rowid         LIMIT 1     ) IS NULL; END;";
            [_targetDBConnection executeUpdate:createTrigger];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@",exception);
    }
    @finally {
        
    }
}

- (void)deleteAllDataWithiOS5
{
    NSString *sql2 = @"delete from group_member";
    NSString *sql3 = @"delete from madrid_attachment";
    NSString *sql4 = @"delete from madrid_chat";
    NSString *sql5 = @"delete from message";
    NSString *sql6 = @"delete from msg_group";
   
    [_targetDBConnection executeUpdate:sql2];
    [_targetDBConnection executeUpdate:sql3];
    [_targetDBConnection executeUpdate:sql4];
    [_targetDBConnection executeUpdate:sql5];
    [_targetDBConnection executeUpdate:sql6];
}

//查询接收iMessage群发消息所对应的identify
- (NSArray *)queryMutiMessageidentify:(int)rowid
{
    NSMutableArray *midentifyArr = [NSMutableArray array];
    NSString *sql = @"select id from chat_handle_join as a,handle as b where a.chat_id=rowid and a.hand_id=b.ROWID";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql];
    while ([rs next]) {
        NSString *id1 = [rs stringForColumn:@"id"];
        [midentifyArr addObject:id1];
    }
    [rs close];
    return midentifyArr;
}

- (NSString *)getAccount_login
{
    NSString *sql1 = @"select a.last_addressed_handle from chat as a,handle as b,chat_handle_join as c where a.ROWID = c.chat_id And b.ROWID = c.handle_id;";
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
         NSString *account_login = [rs stringForColumn:@"last_addressed_handle"];
        if (account_login != nil) {
            account_login = [@"P:" stringByAppendingString:account_login];
            return account_login;
        }
    }
    [rs close];

    return nil;
}

//表attachment
- (void)insertattachmentWithiOS7
{
    
    [_logHandle writeInfoLog:@"insert Message table attachment iOS7 enter"];
    NSString *sql1 = @"select * from attachment";
    NSString *tarSql = @"";

    if (_targetVersion>=11) {
        tarSql = @"insert into attachment(ROWID,guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing,user_info,transfer_name,total_bytes,hide_attachment,ck_sync_state,original_guid) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else{
        tarSql = @"insert into attachment(ROWID,guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing,user_info,transfer_name,total_bytes) values(?,?,?,?,?,?,?,?,?,?,?,?)";

    }
        //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            NSInteger ROWID = [rs intForColumn:@"ROWID"];
            NSString *guid = [rs stringForColumn:@"guid"];
            NSInteger created_date = [rs intForColumn:@"created_date"];
            NSInteger start_date = [rs intForColumn:@"start_date"];
            NSString *filename = [rs stringForColumn:@"filename"];
            NSString *uti = [rs stringForColumn:@"uti"];
            NSString *mime_type = [rs stringForColumn:@"mime_type"];
            NSInteger transfer_state = [rs intForColumn:@"transfer_state"];
            NSInteger is_outgoing = [rs intForColumn:@"is_outgoing"];
            NSData *user_info = [rs dataForColumn:@"user_info"];
            NSString *transfer_name = [rs stringForColumn:@"transfer_name"];
            NSInteger total_bytes = [rs intForColumn:@"total_bytes"];
            if (_targetVersion>=11) {
                NSString *gguid = guid?guid:[self createGUID];
                [_targetDBConnection executeUpdate:tarSql,[NSNumber numberWithInt:ROWID],guid,[NSNumber numberWithInt:created_date],[NSNumber numberWithInt:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing],user_info,transfer_name,[NSNumber numberWithInt:total_bytes],@(0),@(0),gguid];
            }else{
                [_targetDBConnection executeUpdate:tarSql,[NSNumber numberWithInt:ROWID],guid,[NSNumber numberWithInt:created_date],[NSNumber numberWithInt:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing],user_info,transfer_name,[NSNumber numberWithInt:total_bytes]];
            }
            

        }
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Message table attachment iOS7 exit"];
    
    
}

- (void)insertattachmentWithiOS6
{
    
    [_logHandle writeInfoLog:@"insert Message table attachment iOS6 enter"];
    NSString *sql1 = @"select * from attachment";
    NSString *sql2 = @"insert into attachment(ROWID,guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing) values(?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            NSInteger ROWID = [rs intForColumn:@"ROWID"];
            NSString *guid = [rs stringForColumn:@"guid"];
            NSInteger created_date = [rs intForColumn:@"created_date"];
            NSInteger start_date = [rs intForColumn:@"start_date"];
            NSString *filename = [rs stringForColumn:@"filename"];
            NSString *uti = [rs stringForColumn:@"uti"];
            NSString *mime_type = [rs stringForColumn:@"mime_type"];
            NSInteger transfer_state = [rs intForColumn:@"transfer_state"];
            NSInteger is_outgoing = [rs intForColumn:@"is_outgoing"];
            
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],guid,[NSNumber numberWithInt:created_date],[NSNumber numberWithInt:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing]];
        }
        
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Message table attachment iOS6 exit"];

   
}

//表chat
- (void)insertchatWithiOS7
{
    
    [_logHandle writeInfoLog:@"insert Message table chat iOS7 enter"];
    NSString *sql1 = @"select * from chat";
    NSString *sql2 = @"insert into chat(ROWID,guid,style,state,account_id,properties,chat_identifier,service_name,room_name,account_login,is_archived,last_addressed_handle,display_name) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            NSInteger ROWID = [rs intForColumn:@"ROWID"];
            NSString *guid = [rs stringForColumn:@"guid"];
            NSInteger style = [rs intForColumn:@"style"];
            NSInteger state = [rs intForColumn:@"state"];
            NSString *account_id = [rs stringForColumn:@"account_id"];
            NSData *properties = [rs dataForColumn:@"properties"];
            NSString *chat_identifier = [rs stringForColumn:@"chat_identifier"];
            NSString *service_name = [rs stringForColumn:@"service_name"];
            NSString *room_name = [rs stringForColumn:@"room_name"];
            NSString *account_login = [rs stringForColumn:@"account_login"];
            NSInteger is_archived = [rs intForColumn:@"is_archived"];
            NSString *last_addressed_handle = [rs stringForColumn:@"last_addressed_handle"];
            NSString *display_name = [rs stringForColumn:@"display_name"];
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],guid,[NSNumber numberWithInt:style],[NSNumber numberWithInt:state],account_id,properties,chat_identifier,service_name,room_name,account_login,[NSNumber numberWithInt:is_archived],last_addressed_handle,display_name];

        }
        
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Message table chat iOS7 exit"];
   
   
}

- (void)insertchatWithiOS6
{
    NSString *sql1 = @"select * from chat";
    NSString *sql2 = @"insert into chat(ROWID,guid,style,state,account_id,properties,chat_identifier,service_name,room_name,account_login,is_archived,last_addressed_handle) values(?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            NSInteger ROWID = [rs intForColumn:@"ROWID"];
            NSString *guid = [rs stringForColumn:@"guid"];
            NSInteger style = [rs intForColumn:@"style"];
            NSInteger state = [rs intForColumn:@"state"];
            NSString *account_id = [rs stringForColumn:@"account_id"];
            NSData *properties = [rs dataForColumn:@"properties"];
            NSString *chat_identifier = [rs stringForColumn:@"chat_identifier"];
            NSString *service_name = [rs stringForColumn:@"service_name"];
            NSString *room_name = [rs stringForColumn:@"room_name"];
            NSString *account_login = [rs stringForColumn:@"account_login"];
            NSInteger is_archived = [rs intForColumn:@"is_archived"];
            NSString *last_addressed_handle = [rs stringForColumn:@"last_addressed_handle"];
            // NSString *display_name = [rs stringForColumn:@"display_name"];
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],guid,[NSNumber numberWithInt:style],[NSNumber numberWithInt:state],account_id,properties,chat_identifier,service_name,room_name,account_login,[NSNumber numberWithInt:is_archived],last_addressed_handle];
        }
    }
    [rs close];
}

//表chat_handle_join
- (void)insertchat_handle_join
{
    
    [_logHandle writeInfoLog:@"insert Message table chat_handle_join enter"];
    NSString *sql1 = @"select * from chat_handle_join";
    NSString *sql2 = @"insert into chat_handle_join(chat_id,handle_id) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            int chat_id = [rs intForColumn:@"chat_id"];
            int handle_id = [rs intForColumn:@"handle_id"];
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:chat_id],[NSNumber numberWithInt:handle_id]];
        }
        
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Message table chat_handle_join exit"];
}

//表chat_message_join
- (void)insertchat_message_join
{
    [_logHandle writeInfoLog:@"insert Message table chat_message_join enter"];
    NSString *sql1 = @"select * from chat_message_join";
    NSString *sql2 = @"insert into chat_message_join(chat_id,message_id) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            int chat_id = [rs intForColumn:@"chat_id"];
            int message_id = [rs intForColumn:@"message_id"];
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:chat_id],[NSNumber numberWithInt:message_id]];

        }
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Message table chat_message_join exit"];
}

//表handle
- (void)inserthandle
{
    [_logHandle writeInfoLog:@"insert Message table handle enter"];
    NSString *sql1 = @"select * from handle";
    NSString *sql2 = @"insert into handle(ROWID,id,country,service,uncanonicalized_id) values(?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            NSInteger ROWID = [rs intForColumn:@"ROWID"];
            NSString *nid = [rs stringForColumn:@"id"];
            NSString *country = [rs stringForColumn:@"country"];
            NSString *service = [rs stringForColumn:@"service"];
            NSString *uncanonicalized_id = [rs stringForColumn:@"uncanonicalized_id"];
            
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],nid,country,service,uncanonicalized_id];
        }
       
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Message table handle exit"];
}

//表message_attachment_join
- (void)insertmessage_attachment_join
{
    [_logHandle writeInfoLog:@"insert Message table message_attachment_join enter"];
    NSString *sql1 = @"select * from message_attachment_join";
    NSString *sql2 = @"insert into message_attachment_join(message_id,attachment_id) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            int message_id = [rs intForColumn:@"message_id"];
            int attachment_id = [rs intForColumn:@"attachment_id"];
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:message_id],[NSNumber numberWithInt:attachment_id]];
        }
        
    }
    [rs close];
     [_logHandle writeInfoLog:@"insert Message table message_attachment_join exit"];
}

- (void)insertmessage
{
    [_logHandle writeInfoLog:@"insert Message table message enter"];
    NSString *sql1 = @"select * from message";
    NSString *sql2 = @"insert into message(ROWID,guid,text,replace,service_center,handle_id,subject,country,attributedBody,version,type,service,account,account_guid,error,date,date_read,date_delivered,is_delivered,is_finished,is_emote,is_from_me,is_empty,is_delayed,is_auto_reply,is_prepared,is_read,is_system_message,is_sent,has_dd_results,is_service_message,is_forward,was_downgraded,is_archive,cache_has_attachments,cache_roomnames,was_data_detected,was_deduplicated) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        @autoreleasepool {
            
            NSInteger ROWID = [rs intForColumn:@"ROWID"];
            NSString *guid = [rs stringForColumn:@"guid"];
            NSString *text = [rs stringForColumn:@"text"];
            NSInteger replace = [rs intForColumn:@"replace"];
            NSString *service_center = [rs stringForColumn:@"service_center"];
            NSInteger handle_id = [rs intForColumn:@"handle_id"];
            NSString *subject = [rs stringForColumn:@"subject"];
            NSString *country = [rs stringForColumn:@"country"];
            NSData *attributedBody = [rs dataForColumn:@"attributedBody"];
            NSInteger version = [rs intForColumn:@"version"];
            NSInteger type = [rs intForColumn:@"type"];
            NSString *service = [rs stringForColumn:@"service"];
            NSString *account = [rs stringForColumn:@"account"];
            NSString *account_guid = [rs stringForColumn:@"account_guid"];
            NSInteger error = [rs intForColumn:@"error"];
            long long date = [rs longLongIntForColumn:@"date"];
            long long date_read = [rs longLongIntForColumn:@"date_read"];
            if (_targetVersion <11&&[DateHelper getDateLength:date]>=18) {
                date = date/(1000*1000*1000*1.0);
            }
            if (_targetVersion <11&&[DateHelper getDateLength:date_read]>=18) {
                date_read = date_read/(1000*1000*1000*1.0);
            }
            NSInteger date_delivered = [rs intForColumn:@"date_delivered"];
            NSInteger is_delivered = [rs intForColumn:@"is_delivered"];
            NSInteger is_finished = [rs intForColumn:@"is_finished"];
            NSInteger is_emote = [rs intForColumn:@"is_emote"];
            NSInteger is_from_me = [rs intForColumn:@"is_from_me"];
            NSInteger is_empty = [rs intForColumn:@"is_empty"];
            NSInteger is_delayed = [rs intForColumn:@"is_delayed"];
            NSInteger is_auto_reply = [rs intForColumn:@"is_auto_reply"];
            NSInteger is_prepared = [rs intForColumn:@"is_prepared"];
            NSInteger is_read = [rs intForColumn:@"is_read"];
            NSInteger is_system_message = [rs intForColumn:@"is_system_message"];
            NSInteger is_sent = [rs intForColumn:@"is_sent"];
            NSInteger has_dd_results = [rs intForColumn:@"has_dd_results"];
            NSInteger is_service_message = [rs intForColumn:@"is_service_message"];
            NSInteger is_forward = [rs intForColumn:@"is_forward"];
            NSInteger was_downgraded = [rs intForColumn:@"was_downgraded"];
            NSInteger is_archive = [rs intForColumn:@"is_archive"];
            NSInteger cache_has_attachments = [rs intForColumn:@"cache_has_attachments"];
            NSString *cache_roomnames = [rs stringForColumn:@"cache_roomnames"];
            NSInteger was_data_detected = [rs intForColumn:@"was_data_detected"];
            NSInteger was_deduplicated = [rs intForColumn:@"was_deduplicated"];
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],guid,text,[NSNumber numberWithInt:replace],service_center,[NSNumber numberWithInt:handle_id],subject,country,attributedBody,[NSNumber numberWithInt:version],[NSNumber numberWithInt:type],service,account,account_guid,[NSNumber numberWithInt:error],[NSNumber numberWithLongLong:date],[NSNumber numberWithLongLong:date_read],[NSNumber numberWithInt:date_delivered],[NSNumber numberWithInt:is_delivered],[NSNumber numberWithInt:is_finished],[NSNumber numberWithInt:is_emote],[NSNumber numberWithInt:is_from_me],[NSNumber numberWithInt:is_empty],[NSNumber numberWithInt:is_delayed],[NSNumber numberWithInt:is_auto_reply],[NSNumber numberWithInt:is_prepared],[NSNumber numberWithInt:is_read],[NSNumber numberWithInt:is_system_message],[NSNumber numberWithInt:is_sent],[NSNumber numberWithInt:has_dd_results],[NSNumber numberWithInt:is_service_message],[NSNumber numberWithInt:is_forward],[NSNumber numberWithInt:was_downgraded],[NSNumber numberWithInt:is_archive],[NSNumber numberWithInt:cache_has_attachments],cache_roomnames,[NSNumber numberWithInt:was_data_detected],[NSNumber numberWithInt:was_deduplicated]];
            
        }
       
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Message table message exit"];
}

- (void)dealloc
{
    [attachfileNameArray release],attachfileNameArray = nil;
    [_allMessage release],_allMessage = nil;
    [super dealloc];
}
@end

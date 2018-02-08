//
//  IMBMessageToiOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBMessageToiOS.h"
#import "IMBSMSChatDataEntity.h"
@implementation IMBMessageToiOS

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

- (void)merge:(NSArray *)dataArray
{
    @try {
        [_logHandle writeInfoLog:@"IMBMessageToiOS messageConverison enter"];
        if ([self openDataBase:_targetDBConnection]) {
            [_targetDBConnection beginTransaction];
            [self removeTrigger:_targetDBConnection];
            
            if (_attachfileNameArray == nil) {
                _attachfileNameArray = [[NSMutableArray alloc] init];
            }else{
                [_attachfileNameArray removeAllObjects];
            }
            if (_allMessage == nil) {
                _allMessage = [[NSMutableArray alloc] init];
            }else{
                [_allMessage removeAllObjects];
            }
            for (IMBSMSChatDataEntity *entity in dataArray) {
                @autoreleasepool {
                    int imnewchatRowID = -1;
                    int imhandRowID = -1;
                    int newchatRowID = -1;
                    int handRowID = -1;
                    newchatRowID = [self mergeChat:_targetDBConnection chatidentifier:entity.chatIdentifier chat:entity];
                    if ([entity.chatIdentifier hasPrefix:@"chat"]) {
                        //群发
                        for (NSString *phoneNumber in entity.addressArray) {
                            if (newchatRowID != -1) {
                                handRowID = [self mergehandle:_targetDBConnection chatidentifier:phoneNumber];
                                if (handRowID != -1) {
                                    [self mergechat_handle_join:newchatRowID handleID:handRowID targetDB:_targetDBConnection];
                                }
                            }
                        }
                    }else{
                        //单发
                        if (newchatRowID != -1) {
                            handRowID = [self mergehandle:_targetDBConnection chatidentifier:entity.chatIdentifier];
                            if (handRowID != -1) {
                                [self mergechat_handle_join:newchatRowID handleID:handRowID targetDB:_targetDBConnection];
                            }
                        }
                    }
                    for (IMBMessageDataEntity *message in  entity.msgModelList) {
                        message.mergeStruct->handRowID = handRowID;
                        message.mergeStruct->imhandRowID = imhandRowID;
                        message.mergeStruct->imnewchatRowID = imnewchatRowID;
                        message.mergeStruct->newchatRowID = newchatRowID;
                        message.chat = entity;
                    }
                    [_allMessage addObjectsFromArray:entity.msgModelList];
                }
            }
            //对短信进行排序
            NSSortDescriptor *sortDescripto = [[NSSortDescriptor alloc] initWithKey:@"msgDate" ascending:YES];
            NSArray *sortarray = [_allMessage sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescripto]];
            [sortDescripto release];
            
            
            for (IMBMessageDataEntity *message in sortarray) {
                [self mergeMessage:message.mergeStruct->newchatRowID handID:message.mergeStruct->handRowID imchatID:message.mergeStruct->imnewchatRowID imhandID:message.mergeStruct->imhandRowID sourceDB:nil targetDB:_targetDBConnection chat:message.chat message:message];
            }
            
            [self createTrigger:_targetDBConnection];
        if (![_targetDBConnection commit]){
            [_targetDBConnection rollback];
        }
            [self closeDataBase:_targetDBConnection];
        }
        [_logHandle writeInfoLog:@"IMBMessageToiOS insert message quit"];

    } @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"----Error----:Merge IMBMessageToiOS error:%@", exception]];
    }
    @finally {
    }
    [_logHandle writeInfoLog:@"IMBMessageToiOS insert recordArray enter"];
    if ([_attachfileNameArray count] == 0) {
        [self modifyHashAndManifest];
    }else {
        NSMutableArray *recordArray = [self createRecordArray];
        if (_targetVersion >= 10) {
            //此处不需要剔除重复的record
            [self createAttachmentPlist:recordArray TargetDB:_targetManifestDBConnection];
        }else{
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
                    for (IMBMBFileRecord *hRecord in recordArray) {
                        if ([record.path isEqualToString:hRecord.path]) {
                            [sourceSameRecordArray addObject:record];
                        }
                    }
                }
            }
            NSFileManager *fileMan = [NSFileManager defaultManager];
            [_targetrecordArray removeAllObjects];
            [_targetrecordArray addObjectsFromArray:targetRecodArray1];
            NSMutableArray *notexsitRecord = [NSMutableArray array];
            //进行拷贝文件
            for (IMBMBFileRecord *record in recordArray) {
                if (record.filetype == FileType_Backup) {
                    NSString *targetfilePath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
                    NSString *sourcefilePath = nil;
                    sourcefilePath = record.localPath;
                    if ([fileMan fileExistsAtPath:targetfilePath]) {
                        [fileMan removeItemAtPath:targetfilePath error:nil];
                    }
                    if ([fileMan fileExistsAtPath:sourcefilePath]) {
                        [fileMan copyItemAtPath:sourcefilePath toPath:targetfilePath error:nil];
                    }else{
                        [notexsitRecord addObject:record];
                    }
                }
            }
            [recordArray removeObjectsInArray:notexsitRecord];
            [targetRecodArray2 removeObjectsInArray:targetattachmentRecordArray];
            [targetattachmentRecordArray removeObjectsInArray:sourceSameRecordArray];
            [recordArray addObjectsFromArray:targetattachmentRecordArray];
            [_targetrecordArray addObjectsFromArray:recordArray];
            [_targetrecordArray addObjectsFromArray:targetRecodArray2];
        }
        [self modifyHashAndManifest];
    }
    [_logHandle writeInfoLog:@"IMBMessageToiOS messageConverison quit"];

}

- (void)createAttachmentPlist:(NSMutableArray *)sourceattachmentRecordArray TargetDB:(FMDatabase *)targetDB
{
    if ([self openDataBase:targetDB]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //首先查看目标数据库是否存在一样的
        for (IMBMBFileRecord *record in sourceattachmentRecordArray) {
            @autoreleasepool {
                NSString *insertSql = @"insert into Files(fileID, domain, relativePath, flags, file) values(:fileID, :domain, :relativePath, :flags, :file)";
                NSMutableDictionary *insertParams = [NSMutableDictionary dictionary];
                [insertParams setObject:record.key forKey:@"fileID"];
                [insertParams setObject:record.domain forKey:@"domain"];
                [insertParams setObject:record.path forKey:@"relativePath"];
                NSData *data = nil;
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
                if (data) {
                    [insertParams setObject:data forKey:@"file"];
                    if ([targetDB executeUpdate:insertSql withParameterDictionary:insertParams]) {
                        //开始拷贝文件
                        if (record.filetype == FileType_Backup) {
                            NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
                            NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                            NSString *targetfilePath = [folderPath stringByAppendingPathComponent:record.key];
                            NSString *sourcefilePath = nil;
                            sourcefilePath = record.localPath;
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
        [self closeDataBase:targetDB];
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
        data = [[NSData alloc] initWithContentsOfFile:record.localPath];
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


- (NSMutableArray *)createRecordArray
{
    NSMutableArray *recordArrya = [NSMutableArray array];
    uint node = 1000;
    {
        IMBMBFileRecord *record = [[IMBMBFileRecord alloc] init];
        record.alwaysZero = 0;
        record.domain = @"MediaDomain";
        record.path = @"Library/SMS/Attachments";
        record.key = [self createRecordKey:record];
        record.mode = 16832;
        record.fileLength = 0;
        int protectionClass = 0;
        Byte byte[1];
        byte[0] = (Byte)protectionClass;
        record.protectionClass = (Byte)byte;
        Byte byte1[1];
        byte1[0] = (Byte)0;
        record.propertyCount = (Byte)byte1;
        record.groupId = 501;
        record.userId = 501;
        record.aTimeInterval = [[NSDate date] timeIntervalSince1970];
        record.bTimeInterval = [[NSDate date] timeIntervalSince1970];
        record.cTimeInterval = [[NSDate date] timeIntervalSince1970];
        record.inode = node;
        record.filetype = DirectoryType_Backup;
        [self setRecordData:record byte:byte byte1:byte1];
        [recordArrya addObject:record];
        [record release];
    }
    for (IMBSMSAttachmentEntity *attach in _attachfileNameArray) {
        for (NSString *parentPath in attach.parentPathArray) {
            NSPredicate *cate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                IMBMBFileRecord *record = (IMBMBFileRecord *)evaluatedObject;
                if ([record.path isEqualToString:parentPath]) {
                    return YES;
                }else{
                    return NO;
                }
            }];
            if ([recordArrya filteredArrayUsingPredicate:cate].count > 0) {
                continue;
            }
            node++;
            IMBMBFileRecord *record = [[IMBMBFileRecord alloc] init];
            record.alwaysZero = 0;
            record.domain = @"MediaDomain";
            record.path = parentPath;
            record.key = [self createRecordKey:record];
            record.mode = 16832;
            record.fileLength = 0;
            int protectionClass = 0;
            
            Byte byte[1];
            byte[0] = (Byte)protectionClass;
            record.protectionClass = (Byte)byte;
            Byte byte1[1];
            byte1[0] = (Byte)0;
            record.propertyCount = (Byte)byte1;
            
            record.groupId = 501;
            record.userId = 501;
            record.aTimeInterval = [[NSDate date] timeIntervalSince1970];
            record.bTimeInterval = [[NSDate date] timeIntervalSince1970];
            record.cTimeInterval = [[NSDate date] timeIntervalSince1970];
            record.inode = node;
            record.filetype = DirectoryType_Backup;
            [self setRecordData:record byte:byte byte1:byte1];
            [recordArrya addObject:record];
            [record release];
        }
        node++;
        IMBMBFileRecord *record = [[IMBMBFileRecord alloc] init];
        record.alwaysZero = 0;
        record.domain = @"MediaDomain";
        record.path = [attach.fileName stringByReplacingOccurrencesOfString:@"~/" withString:@""];
        record.key = [self createRecordKey:record];
        record.mode = 33188;
        record.fileLength = attach.totalBytes;
        int protectionClass = 3;
        Byte byte[1];
        byte[0] = (Byte)protectionClass;
        record.protectionClass = (Byte)byte;
        Byte byte1[1];
        byte1[0] = (Byte)0;
        record.propertyCount = (Byte)byte1;
        record.groupId = 501;
        record.userId = 501;
        record.aTimeInterval = [[NSDate date] timeIntervalSince1970];
        record.bTimeInterval = [[NSDate date] timeIntervalSince1970];
        record.cTimeInterval = [[NSDate date] timeIntervalSince1970];
        record.inode = node;
        record.filetype = FileType_Backup;
        record.localPath = attach.attachLoaction;
        [self setRecordData:record byte:byte byte1:byte1];
        [recordArrya addObject:record];
        [record release];
    }
    return recordArrya;
}


- (void)setRecordData:(IMBMBFileRecord *)fileRecord byte:(Byte *)byte  byte1:(Byte *)byte1
{
    NSMutableData *listData = [NSMutableData data];
    uint_16.ui16 = fileRecord.mode;
    Byte modeByte[2];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(modeByte, uint_16.c, 2);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:modeByte offset:0 count:2];
        [listData appendBytes:reverseByte length:2];
    } else {
        memcpy(modeByte, uint_16.c, 2);
        [listData appendBytes:modeByte length:2];
    }
    
    uint_32.ui32 = fileRecord.alwaysZero;
    Byte alwaysZeroByte[4];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(alwaysZeroByte, uint_32.c, 4);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:alwaysZeroByte offset:0 count:4];
        [listData appendBytes:reverseByte length:4];
    } else {
        memcpy(alwaysZeroByte, uint_32.c, 4);
        [listData appendBytes:alwaysZeroByte length:4];
    }
    
    uint_32.ui32 = fileRecord.inode;
    Byte inodeByte[4];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(inodeByte, uint_32.c, 4);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:inodeByte offset:0 count:4];
        [listData appendBytes:reverseByte length:4];
    } else {
        memcpy(inodeByte, uint_32.c, 4);
        [listData appendBytes:inodeByte length:4];
    }
    
    uint_32.ui32 = fileRecord.userId;
    Byte useridByte[4];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(useridByte, uint_32.c, 4);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:useridByte offset:0 count:4];
        [listData appendBytes:reverseByte length:4];
    } else {
        memcpy(useridByte, uint_32.c, 4);
        [listData appendBytes:useridByte length:4];
    }
    
    uint_32.ui32 = fileRecord.groupId;
    Byte groupIdByte[4];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(groupIdByte, uint_32.c, 4);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:groupIdByte offset:0 count:4];
        [listData appendBytes:reverseByte length:4];
    } else {
        memcpy(groupIdByte, uint_32.c, 4);
        [listData appendBytes:groupIdByte length:4];
    }
    
    uint_32.ui32 = fileRecord.aTimeInterval;
    Byte atimeByte[4];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(atimeByte, uint_32.c, 4);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:atimeByte offset:0 count:4];
        [listData appendBytes:reverseByte length:4];
    } else {
        memcpy(atimeByte, uint_32.c, 4);
        [listData appendBytes:atimeByte length:4];
    }
    
    uint_32.ui32 = fileRecord.bTimeInterval;
    Byte btimeByte[4];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(btimeByte, uint_32.c, 4);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:btimeByte offset:0 count:4];
        [listData appendBytes:reverseByte length:4];
    } else {
        memcpy(btimeByte, uint_32.c, 4);
        [listData appendBytes:btimeByte length:4];
    }
    
    uint_32.ui32 = fileRecord.cTimeInterval;
    Byte ctimeByte[4];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(ctimeByte, uint_32.c, 4);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:ctimeByte offset:0 count:4];
        [listData appendBytes:reverseByte length:4];
    } else {
        memcpy(ctimeByte, uint_32.c, 4);
        [listData appendBytes:ctimeByte length:4];
    }
    
    int_64.i64 = fileRecord.fileLength;
    Byte fileSizeByte[8];
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        memcpy(fileSizeByte, int_64.c, 8);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:fileSizeByte offset:0 count:8];
        [listData appendBytes:reverseByte length:8];
    } else {
        memcpy(fileSizeByte, int_64.c, 8);
        [listData appendBytes:fileSizeByte length:8];
    }
    [listData appendBytes:byte length:1];
    [listData appendBytes:byte1 length:1];
    [fileRecord setData:[NSString stringToHex:[listData bytes] length:(int)[listData length]]];
}

- (NSString *)createRecordKey:(IMBMBFileRecord *)record
{
    uint8_t hash[20] = { 0x00 };
    NSString *fileName = nil;
    NSString *temp = [[record.domain stringByAppendingString:@"-"] stringByAppendingString:record.path];
    const char *buf = [temp UTF8String];
    int len = (int)strlen(buf);
    CC_SHA1_CTX content;
    CC_SHA1_Init(&content);
    CC_SHA1_Update(&content, buf, len);
    CC_SHA1_Final(hash, &content);
    fileName = [[NSString stringToHex:hash length:CC_SHA1_DIGEST_LENGTH] lowercaseString];
    return fileName;
}



- (void)createTrigger:(FMDatabase *)targetDB {
    @try {
        BOOL createval = NO;
        NSString *createCmd = nil;
        if ([_targetFloatVersion isVersionMajorEqual:@"9"]) {//iOS9以上的触发器
            createCmd = @"CREATE TRIGGER add_to_deleted_messages AFTER DELETE ON message BEGIN     INSERT INTO deleted_messages (guid) VALUES (OLD.guid); END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_attachment AFTER DELETE ON attachment BEGIN   SELECT delete_attachment_path(OLD.filename); END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_chat AFTER DELETE ON chat BEGIN DELETE FROM chat_message_join WHERE chat_id = OLD.ROWID; END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_chat_handle_join AFTER DELETE ON chat_handle_join BEGIN     DELETE FROM handle         WHERE handle.ROWID = OLD.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE other_handle = OLD.handle_id LIMIT 1) IS NULL; END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_chat_message_join AFTER DELETE ON chat_message_join BEGIN     UPDATE message       SET cache_roomnames = (         SELECT group_concat(c.room_name)         FROM chat c         INNER JOIN chat_message_join j ON c.ROWID = j.chat_id         WHERE           j.message_id = OLD.message_id       )       WHERE         message.ROWID = OLD.message_id;  DELETE FROM message WHERE message.ROWID = OLD.message_id AND OLD.message_id NOT IN (SELECT chat_message_join.message_id from chat_message_join WHERE chat_message_join.message_id = OLD.message_id LIMIT 1); END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_message AFTER DELETE ON message BEGIN     DELETE FROM handle         WHERE handle.ROWID = OLD.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = OLD.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE other_handle = OLD.handle_id LIMIT 1) IS NULL; END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_delete_on_message_attachment_join AFTER DELETE ON message_attachment_join BEGIN     DELETE FROM attachment         WHERE attachment.ROWID = OLD.attachment_id     AND         (SELECT 1 from message_attachment_join WHERE attachment_id = OLD.attachment_id LIMIT 1) IS NULL; END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_insert_on_chat_message_join  AFTER INSERT ON chat_message_join BEGIN     UPDATE message       SET cache_roomnames = (         SELECT group_concat(c.room_name)         FROM chat c         INNER JOIN chat_message_join j ON c.ROWID = j.chat_id         WHERE           j.message_id = NEW.message_id       )       WHERE         message.ROWID = NEW.message_id; END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER after_insert_on_message_attachment_join AFTER INSERT ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 1     WHERE       message.ROWID = NEW.message_id; END";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER before_delete_on_attachment BEFORE DELETE ON attachment BEGIN   SELECT before_delete_attachment_path(OLD.ROWID, OLD.guid); END";
            createval = [targetDB executeUpdate:createCmd];
            
        }else {
            createCmd = @"CREATE TRIGGER delete_attachment_files AFTER DELETE ON attachment BEGIN SELECT delete_attachment_path(old.filename); END;";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER before_delete_attachment_files BEFORE DELETE ON attachment BEGIN   SELECT before_delete_attachment_path(old.ROWID, old.guid); END;";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clean_orphaned_attachments AFTER DELETE ON message_attachment_join BEGIN     DELETE FROM attachment         WHERE attachment.ROWID = old.attachment_id     AND         (SELECT 1 from message_attachment_join WHERE attachment_id = old.attachment_id LIMIT 1) IS NULL; END;";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clean_orphaned_handles2 AFTER DELETE ON message BEGIN     DELETE FROM handle         WHERE handle.ROWID = old.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = old.handle_id LIMIT 1) IS NULL     AND         (SELECT 1 from message WHERE handle_id = old.handle_id LIMIT 1) IS NULL; END;";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clear_message_has_attachments AFTER DELETE ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 0     WHERE       message.ROWID = old.message_id       AND       (SELECT 1 from message_attachment_join WHERE message_id = old.message_id LIMIT 1) IS NULL; END;";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER set_message_has_attachments AFTER INSERT ON message_attachment_join BEGIN     UPDATE message       SET cache_has_attachments = 1     WHERE       message.ROWID = new.message_id; END;";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clean_orphaned_handles AFTER DELETE ON chat_handle_join BEGIN     DELETE FROM handleWHERE handle.ROWID = old.handle_id     AND         (SELECT 1 from chat_handle_join WHERE handle_id = old.handle_id LIMIT 1) IS NULL     AND (SELECT 1 from message WHERE handle_id = old.handle_id LIMIT 1) IS NULL; END;";
            createval = [targetDB executeUpdate:createCmd];
            
            createCmd = @"CREATE TRIGGER clean_orphaned_messages AFTER DELETE ON chat_message_join BEGIN DELETE FROM message     WHERE (SELECT 1 FROM chat_message_join        WHERE message_id = message.rowid         LIMIT 1     ) IS NULL; END;";
            createval = [targetDB executeUpdate:createCmd];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

// Trigger
- (void)removeTrigger:(FMDatabase *)targetDB {
    BOOL delval = NO;
    NSString *deleteCmd = nil;
    if ([_targetFloatVersion isVersionMajorEqual:@"9"]) {
        deleteCmd = @"DROP TRIGGER add_to_deleted_messages;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER after_delete_on_attachment;";
        delval = [targetDB executeUpdate:deleteCmd];
        //
        deleteCmd = @"DROP TRIGGER after_delete_on_chat;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER after_delete_on_chat_handle_join;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER after_delete_on_chat_message_join;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER after_delete_on_message;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER after_delete_on_message_attachment_join;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER after_insert_on_chat_message_join;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER after_insert_on_message_attachment_join;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER before_delete_on_attachment;";
        delval = [targetDB executeUpdate:deleteCmd];
    }else {
        deleteCmd = @"DROP TRIGGER delete_attachment_files;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER before_delete_attachment_files;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER clean_orphaned_attachments;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER clean_orphaned_handles2;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER clear_message_has_attachments;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER set_message_has_attachments;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER clean_orphaned_handles;";
        delval = [targetDB executeUpdate:deleteCmd];
        
        deleteCmd = @"DROP TRIGGER clean_orphaned_messages;";
        delval = [targetDB executeUpdate:deleteCmd];
    }
}


- (void)mergeMessage:(int)chatID handID:(int)handID imchatID:(int)imchatID imhandID:(int)imhandID sourceDB:(FMDatabase *)sourceDB targetDB:(FMDatabase *)targetDB chat:(IMBSMSChatDataEntity *)chat message:(IMBMessageDataEntity *)message
{
    @autoreleasepool {
        NSString *account_id =[self getchatAccountid:chatID targetDB:targetDB];
        NSString *imaccount_id =[self getchatAccountid:imchatID targetDB:targetDB];
        int newMessageRowID = -1;
        int newchatId = -1;
        NSString *sql = @"insert into message(guid,text,replace,service_center,handle_id,subject,country,attributedBody,version,type,service,account,account_guid,error,date,date_read,date_delivered,is_delivered,is_finished,is_emote,is_from_me,is_empty,is_delayed,is_auto_reply,is_prepared,is_read,is_system_message,is_sent,has_dd_results,is_service_message,is_forward,was_downgraded,is_archive,cache_has_attachments,cache_roomnames,was_data_detected,was_deduplicated) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        NSString *guid = [self createGUID];
        NSString *text = message.msgText;
        int replace = 0;
        NSString *service_center = nil;
        int handle_id = -1;
        NSString *service = nil;
        NSString *account = nil;
        NSString *account_guid = nil;
        if (chat.isExistTwo) {
            newchatId = chatID;
            service = @"SMS";
            account = @"e:";
            account_guid = account_id;
            handle_id = handID;
        }else{
            service = chat.handleService;
            account = chat.account_login;
            if ([service isEqualToString:@"SMS"]) {
                newchatId = chatID;
                account_guid = account_id;
                handle_id = handID;
            }else{
                account_guid = imaccount_id;
                handle_id = imhandID;
                newchatId = imchatID;
            }
        }
        NSString *subject = nil;
        NSString *country = nil;
        NSData *attributedBody = nil;
        if (message.msgText.length>0) {
            attributedBody = [IMBMessageToiOS makeMsgToData:message.msgText];
        }else{
            
            NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"DataPlist" ofType:@"plist"];
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
            NSData *firstData = [dic objectForKey:@"MessageAttriFirstData"];
            NSData *endData = [dic objectForKey:@"MessageAttriEndData"];
            NSData *guidData = nil;
            if (message.attachmentList.count>0) {
                IMBSMSAttachmentEntity *attach = [message.attachmentList objectAtIndex:0];
                guidData = [attach.attGUID dataUsingEncoding:NSASCIIStringEncoding];
            }
            NSMutableData *totoalData = [NSMutableData data];
            [totoalData appendData:firstData];
            [totoalData appendData:guidData];
            [totoalData appendData:endData];
            attributedBody = totoalData;
        }
        int version = 10;
        int type = 0;
        int error = 0;
        int64_t date = message.msgDate;
        int64_t date_read = message.msgReadDate;
        if (message.msgDate == 0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            NSDate *originDate = [dateFormatter dateFromString:@"01/01/2001 00:00:00"];
            NSDate *date1 = [NSDate date];
            int64_t mintimeInterval = (int64_t)[date1 timeIntervalSinceDate:originDate];
            [dateFormatter release];
            date = mintimeInterval;
            date_read = mintimeInterval;
        }
        int date_delivered = 0;
        int is_delivered = message.isDelivered;
        int is_finished = 1;
        int is_emote = 0;
        if (message.isSent == 1) {
            message.isRead = 0;
        }else{
            message.isRead = 1;
        }
        int is_from_me = message.isSent;
        int is_empty = 0;
        int is_delayed = 0;
        int is_auto_reply = 0;
        int is_prepared = 0;
        int is_read = message.isRead;
        int is_system_message = 0;
        int is_sent = message.isSent;
        int has_dd_results = 0;
        int is_service_message = 0;
        int is_forward = 0;
        int was_downgraded = 0;
        int is_archive = 0;
        int cache_has_attachments = 1;
        NSString *cache_roomnames = nil;
        int was_data_detected = 1;
        int was_deduplicated = 0;
        if ([targetDB executeUpdate:sql,guid,text,[NSNumber numberWithInt:replace],service_center,[NSNumber numberWithInt:handle_id],subject,country,attributedBody,[NSNumber numberWithInt:version],[NSNumber numberWithInt:type],service,account,account_guid,[NSNumber numberWithInt:error],[NSNumber numberWithLongLong:date],[NSNumber numberWithLongLong:date_read],[NSNumber numberWithInt:date_delivered],[NSNumber numberWithInt:is_delivered],[NSNumber numberWithInt:is_finished],[NSNumber numberWithInt:is_emote],[NSNumber numberWithInt:is_from_me],[NSNumber numberWithInt:is_empty],[NSNumber numberWithInt:is_delayed],[NSNumber numberWithInt:is_auto_reply],[NSNumber numberWithInt:is_prepared],[NSNumber numberWithInt:is_read],[NSNumber numberWithInt:is_system_message],[NSNumber numberWithInt:is_sent],[NSNumber numberWithInt:has_dd_results],[NSNumber numberWithInt:is_service_message],[NSNumber numberWithInt:is_forward],[NSNumber numberWithInt:was_downgraded],[NSNumber numberWithInt:is_archive],[NSNumber numberWithInt:cache_has_attachments],cache_roomnames,[NSNumber numberWithInt:was_data_detected],[NSNumber numberWithInt:was_deduplicated]]) {
            _succesCount += 1;
            newMessageRowID = [self getTableMaxROWID:@"message" targetDB:targetDB];
            [self updatesqlitesequenceSeq:targetDB seq:newMessageRowID name:@"message"];
            [self mergeAttachmentMsgID:newMessageRowID targetDB:_targetDBConnection AttachmentList:message.attachmentList];
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


+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
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


- (void)mergeAttachmentMsgID:(int)newMsgID targetDB:(FMDatabase *)targetDB AttachmentList:(NSArray *)attachmentList
{
    int newattchmentID = -1;
    BOOL targetExist = [self checkattachmentTotalBytesExist:targetDB];
    NSString *insertsql = nil;
    if (targetExist) {
        if (_targetVersion >= 11) {
            insertsql = @"insert into attachment(guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing,user_info,transfer_name,total_bytes,original_guid) values(?,?,?,?,?,?,?,?,?,?,?,?)";
            
        }else{
            insertsql = @"insert into attachment(guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing,user_info,transfer_name,total_bytes) values(?,?,?,?,?,?,?,?,?,?,?)";
        }
    }else{
        insertsql = @"insert into attachment(guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing) values(?,?,?,?,?,?,?,?)";
    }
    for (IMBSMSAttachmentEntity *attachment in attachmentList) {
        NSString *guid = attachment.attGUID;
        long long created_date = [DateHelper timeIntervalFrom1970To2001:[[NSDate date] timeIntervalSince1970]];
        long long start_date = attachment.startDate;
        NSString *filename = attachment.fileName;
        NSString *uti = attachment.utiName;
        NSString *mime_type = attachment.mimeType;
        int transfer_state = attachment.transferState;
        int is_outgoing = attachment.isOutgoing;
        if (targetExist) {
            NSData *user_info = nil;
            NSString *transfer_name = attachment.transferName;
            long long total_bytes = attachment.totalBytes;
            {
                if (_targetVersion>=11) {
                    if ([targetDB executeUpdate:insertsql,guid?guid:[self createGUID],[NSNumber numberWithLongLong:created_date],[NSNumber numberWithLongLong:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing],user_info,transfer_name,[NSNumber numberWithLongLong:total_bytes],guid?guid:[self createGUID]]) {
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
                    if ([targetDB executeUpdate:insertsql,guid?guid:[self createGUID],[NSNumber numberWithLongLong:created_date],[NSNumber numberWithLongLong:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing],user_info,transfer_name,[NSNumber numberWithLongLong:total_bytes]]) {
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
            }
            if (filename.length>0&&![_attachfileNameArray containsObject:attachment]) {
                [_attachfileNameArray addObject:attachment];
            }
            if (newMsgID != -1&&newattchmentID != -1) {
                [self mergeMesage_attachment_join:newMsgID attachmentRowID:newattchmentID targetDB:targetDB];
            }
        }else{
            if ([targetDB executeUpdate:insertsql,guid?guid:[self createGUID],[NSNumber numberWithLongLong:created_date],[NSNumber numberWithLongLong:start_date],filename,uti,mime_type,[NSNumber numberWithInt:transfer_state],[NSNumber numberWithInt:is_outgoing]]) {
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
            if (filename.length>0&&![_attachfileNameArray containsObject:attachment]) {
                [_attachfileNameArray addObject:attachment];
            }
            if (newMsgID != -1&&newattchmentID != -1) {
                [self mergeMesage_attachment_join:newMsgID attachmentRowID:newattchmentID targetDB:targetDB];
            }
        }
    }
}

- (void)mergeMesage_attachment_join:(int)messageRowID attachmentRowID:(int)attachmentRowID targetDB:(FMDatabase *)targetDB
{
    NSString *sql = @"insert into message_attachment_join(message_id,attachment_id) values(?,?)";
    //执行sql语句,返回结果集
    [targetDB executeUpdate:sql,[NSNumber numberWithInt:messageRowID],[NSNumber numberWithInt:attachmentRowID]];
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

+ (int)byteLength:(NSString *)str
{
    int count = 0;
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            count = count +3;
        }else{
            count++;
        }
    }
    return count;
}

+ (NSData *)makeMsgToData:(NSString *)msg
{
    NSMutableData *data = [NSMutableData data];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DataPlist" ofType:@"plist"];
    NSMutableDictionary *noteDataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSData *firstData = [noteDataDic objectForKey:@"FirstData"];
    NSData *middleData = [noteDataDic objectForKey:@"middleData"];
    NSData *endData = [noteDataDic objectForKey:@"EndData"];
    NSData *textData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    int bytelength = [IMBMessageToiOS byteLength:msg];
    NSData *bytelengyhData = nil;
    NSUInteger charlength = msg.length;
    NSData *charlengthData = nil;
    if (bytelength>128) {
        Byte byte[3] = {};
        byte[0] = 0x81;
        byte[1] = (Byte)bytelength % 256;
        byte[2] = (Byte)bytelength / 256;
        bytelengyhData = [NSData dataWithBytes:byte length: 3];
    }else{
        bytelengyhData = [NSData dataWithBytes: &bytelength length: 1];
    }
    if (charlength>128) {
        Byte byte[3] = {};
        byte[0] = 0x81;
        byte[1] = (Byte)charlength % 256;
        byte[2] = (Byte)charlength / 256;
        charlengthData = [NSData dataWithBytes:byte length:3];
    }else{
        charlengthData = [NSData dataWithBytes: &charlength length: 1];
    }
    [data appendData:firstData];
    [data appendData:bytelengyhData];
    [data appendData:textData];
    [data appendData:middleData];
    [data appendData:charlengthData];
    [data appendData:endData];
    return data;
}

- (int)mergeChat:(FMDatabase *)targetDB chatidentifier:(NSString*)chatidentifier chat:(IMBSMSChatDataEntity *)chat
{
    int newrowId = -1;
    NSString *sql = nil;
    if ([self checkChatsuccessful_queryExist:targetDB]) {
        sql = @"insert into chat(guid,style,state,account_id,properties,chat_identifier,service_name,room_name,account_login,is_archived,last_addressed_handle,successful_query) values(?,?,?,?,?,?,?,?,?,?,?,?)";
    }else{
        sql = @"insert into chat(guid,style,state,account_id,properties,chat_identifier,service_name,room_name,account_login,is_archived,last_addressed_handle) values(?,?,?,?,?,?,?,?,?,?,?)";
    }
    NSString *guid = nil;
    int style = 45;
    if ([chatidentifier hasPrefix:@"chat"]) {
        guid = [@"SMS;+;" stringByAppendingString:chatidentifier];
        style = 43;
    }else{
        //查询数据库是否存在相同的chatidentifier
        NSString *subStr = nil;
        if (chatidentifier.length > 7) {
            subStr = [chatidentifier substringFromIndex:(chatidentifier.length - 7)];
        }else{
            subStr = chatidentifier;
        }
       NSString *sameSql =  [NSString stringWithFormat:@"select chat_identifier from chat where chat_identifier like '%%%@'",subStr];
        FMResultSet *samers = [targetDB executeQuery:sameSql];
        while ([samers next]) {
            NSString *identify = [samers stringForColumn:@"chat_identifier"];
            chat.chatIdentifier = identify;
            chatidentifier = identify;
            break;
        }
        [samers close];
        guid = [@"SMS;-;" stringByAppendingString:chatidentifier?:@""];
    }
    int state = 3;
    NSString *account_id = [self createGUID];
    NSData *properties = nil;
    NSString *chat_identifier = chatidentifier;
    NSString *service_name = @"SMS";
    NSString *room_name = nil;
    NSString *account_login = @"E:";
    BOOL is_archived = 0;
    NSString *last_addressed_handle = nil;
    if ([self checkChatsuccessful_queryExist:targetDB]) {
        if ([targetDB executeUpdate:sql,guid,@(style),@(state),account_id,properties,chat_identifier,service_name,room_name,account_login,@(is_archived),last_addressed_handle,@(1)]) {
            chat.chatGuid = guid;
            chat.account_login = @"E:";
            chat.handleService = @"SMS";
            newrowId = [self getTableMaxROWID:@"chat" targetDB:targetDB];
            [self updatesqlitesequenceSeq:targetDB seq:newrowId name:@"chat"];
        }else{
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
        if ([targetDB executeUpdate:sql,guid,@(style),@(state),account_id,properties,chat_identifier,service_name,room_name,account_login,@(is_archived),last_addressed_handle]) {
            chat.chatGuid = guid;
            chat.account_login = @"E:";
            chat.handleService = @"SMS";
            newrowId = [self getTableMaxROWID:@"chat" targetDB:targetDB];
            [self updatesqlitesequenceSeq:targetDB seq:newrowId name:@"chat"];
        }else{
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
    return newrowId;
}


- (int)mergehandle:(FMDatabase *)targetDB chatidentifier:(NSString*)chatidentifier
{
    @autoreleasepool {
        int newhandID = -1;
        NSString *sql = @"insert into handle(id,country,service,uncanonicalized_id) values(?,?,?,?)";
        //执行sql语句,返回结果集
        NSString *handID = chatidentifier;
        NSString *country = nil;
        NSString *service = @"SMS";
        NSString *uncanonicalized_id = chatidentifier;
        if ([targetDB executeUpdate:sql,handID,country,service,uncanonicalized_id]) {
            newhandID = [self getTableMaxROWID:@"handle" targetDB:targetDB];
            [self updatesqlitesequenceSeq:targetDB seq:newhandID name:@"handle"];
        }else{
            NSString *sql = @"select ROWID from handle where id=:handleID and service=:service";
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:chatidentifier,@"handleID",@"SMS",@"service",nil];
            FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:dic];
            while ([rs next]) {
                newhandID = [rs intForColumn:@"ROWID"];
                break;
            }
            [rs close];
        }
        return newhandID;
    }
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

- (void)mergechat_handle_join:(int)chatRowID handleID:(int)handleID targetDB:(FMDatabase *)targetDB
{
    @autoreleasepool {
        NSString *sql1 = @"insert into chat_handle_join(chat_id,handle_id) values(?,?)";
        //执行sql语句,返回结果集
        [targetDB executeUpdate:sql1,[NSNumber numberWithInt:chatRowID],[NSNumber numberWithInt:handleID]];
    }
}

- (void)dealloc
{
    [_attachfileNameArray release],_attachfileNameArray = nil;
    [_allMessage release],_allMessage = nil;
    [super dealloc];
}
@end

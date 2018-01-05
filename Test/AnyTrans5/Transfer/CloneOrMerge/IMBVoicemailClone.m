//
//  IMBVoicemailClone.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-22.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBVoicemailClone.h"
#import "IMBVoicemailEntity.h"
@implementation IMBVoicemailClone

- (void)setsourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray
{
    [super setsourceBackupPath:sourceBackupPath desBackupPath:desBackupPath sourcerecordArray:sourcerecordArray targetrecordArray:targetrecordArray];
    _sourceBackuppath = [sourceBackupPath retain];
    _targetBakcuppath = [desBackupPath retain];
    {
        sourceRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/Voicemail/voicemail.db" recordArray:_sourcerecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,sourceRecord.key];
        sourceRecord.relativePath = relativePath;
        _sourceSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceSqlite"] fileRecord:sourceRecord backupfilePath:sourceBackupPath] retain];
    }
    {
        targetRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/Voicemail/voicemail.db" recordArray:_targetrecordArray] retain];
        NSString *rstr = [targetRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,targetRecord.key];
        targetRecord.relativePath = relativePath;
        _targetSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetSqlite"] fileRecord:targetRecord backupfilePath:desBackupPath] retain];
    }
    
    
}

- (void)clone
{
    [_logHandle writeInfoLog:@"Clone Voicemail enter"];
    if (_sourceVersion<=_targetVersion) {
        int version = _sourceVersion;
        _sourceVersion = _targetVersion;
        _targetVersion = version;
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                [_logHandle writeInfoLog:@"Clone Voicemail sourceFloatVersion <= targetFloatVersion"];
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
    if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
        [self clearTable:_targetDBConnection TableName:@"voicemail"];
        voicemailIDArray = [[NSMutableArray array] retain];
        [self insertVoicemail];
    }
    [self closeDataBase:_sourceDBConnection];
    [self closeDataBase:_targetDBConnection];
    NSMutableArray *voicemailRecordArray = [NSMutableArray array];
    for (IMBMBFileRecord *record in _sourcerecordArray) {
        if ([record.path hasPrefix:
             @"Library/Voicemail/"]&&[record.domain isEqualToString:@"HomeDomain"]) {
            NSString *extension = [[record.path pathExtension] lowercaseString];
            if ([extension isEqualToString:@"amr"])
            {
                [voicemailRecordArray addObject:record];
            }
        }
    }
    
    if ([_targetFloatVersion isVersionLess:@"10"]) {
        if ([voicemailRecordArray count] == 0) {
            [self modifyHashAndManifest];
            return;
        }
        NSFileManager *fileM = [NSFileManager defaultManager];
        NSMutableArray *tarNewRecordArray1 = [NSMutableArray array];
        NSMutableArray *tarNewRecordArray2 = [NSMutableArray array];
        BOOL canAdd = YES;
        for (int i=0;i<[_targetrecordArray count];i++ ) {
            IMBMBFileRecord *record = [_targetrecordArray objectAtIndex:i];
            if (canAdd) {
                [tarNewRecordArray1 addObject:record];
            }else
            {
                [tarNewRecordArray2 addObject:record];
            }
            if ([record.path isEqualToString:@"Library/Voicemail"]&&[record.domain isEqualToString:@"HomeDomain"]) {
                canAdd = NO;
            }
        }
        [_targetrecordArray removeAllObjects];
        [_targetrecordArray addObjectsFromArray:tarNewRecordArray1];
        NSMutableArray *ar = [NSMutableArray array];
        for (IMBMBFileRecord *record in voicemailRecordArray) {
            for (IMBMBFileRecord *targetRecor in tarNewRecordArray2) {
                if ([record.path isEqualToString:targetRecor.path]) {
                    [ar addObject:targetRecor];
                }
            }
        }
        [tarNewRecordArray2 removeObjectsInArray:ar];
        [_targetrecordArray addObjectsFromArray:voicemailRecordArray];
        [_targetrecordArray addObjectsFromArray:tarNewRecordArray2];
        
        for (IMBMBFileRecord *record in voicemailRecordArray) {
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
        [self modifyHashAndManifest];

    }else{
        if ([voicemailRecordArray count] == 0) {
            [self modifyHashAndManifest];
            return;
        }else{
            //删掉目标设备中 所有的附件信息
            NSPredicate *cate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                IMBMBFileRecord *record = (IMBMBFileRecord *)evaluatedObject;
                if ([record.path hasPrefix:@"Library/Voicemail/"]&&[[[record.path pathExtension] lowercaseString] isEqualToString:@"amr"]) {
                    return YES;
                }else{
                    return NO;
                }
            }];
            NSArray *attRecord = [_targetrecordArray filteredArrayUsingPredicate:cate];
            [self deleteRecords:attRecord TargetDB:_targetManifestDBConnection];
            [self createAttachmentPlist:voicemailRecordArray TargetDB:_targetManifestDBConnection isClone:YES];
        }
        [self modifyHashAndManifest];
    
    }
}

- (void)clearTable:(FMDatabase *)targetDB TableName:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@",tableName];
    [targetDB executeUpdate:sql];
}

//表voicemail
- (void)insertVoicemail
{
     [_logHandle writeInfoLog:@"insert Voicemail table voicemail enter"];
    NSString *sql1 = @"select * from voicemail";
    NSString *sql2 = @"insert into voicemail(ROWID,remote_uid,date,token,sender,callback_num,duration,expiration,trashed_date,flags) values(?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        [voicemailIDArray addObject:[NSNumber numberWithInt:ROWID]];
        NSInteger remote_uid = [rs intForColumn:@"remote_uid"];
        NSInteger date = [rs intForColumn:@"date"];
        NSString *token = [rs stringForColumn:@"token"];
        NSString *sender = [rs stringForColumn:@"sender"];
        NSString *callback_num = [rs stringForColumn:@"callback_num"];
        NSInteger duration = [rs intForColumn:@"duration"];
        NSInteger expiration = [rs intForColumn:@"expiration"];
        NSInteger trashed_date = [rs intForColumn:@"trashed_date"];
        NSInteger flags = [rs intForColumn:@"flags"];
       [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:remote_uid],[NSNumber numberWithInt:date],token,sender,callback_num,[NSNumber numberWithInt:duration],[NSNumber numberWithInt:expiration],[NSNumber numberWithInt:trashed_date],[NSNumber numberWithInt:flags]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Voicemail table voicemail exit"];

}

- (void)merge:(NSArray *)voicemailArray
{
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"merge Voicemail count:%d",voicemailArray.count]];
    if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
         [_logHandle writeInfoLog:@"merge Voicemail enter"];
        for (IMBVoiceMailEntity *entity in voicemailArray) {
            [self mergeVoicemail:entity.rowid];
        }
         [_logHandle writeInfoLog:@"merge Voicemail exit"];
    }
    [self closeDataBase:_sourceDBConnection];
    [self closeDataBase:_targetDBConnection];
    //修改HashandManifest
    NSMutableArray *voicemailRecordArray = [NSMutableArray array];
    for (IMBMBFileRecord *record in _sourcerecordArray) {
        if ([record.path hasPrefix:
             @"Library/Voicemail/"]&&[record.domain isEqualToString:@"HomeDomain"]) {
            NSString *extension = [[record.path pathExtension] lowercaseString];
            if ([extension isEqualToString:@"amr"])
            {
                [voicemailRecordArray addObject:record];
            }
            
        }
    }
    NSFileManager *fileM = [NSFileManager defaultManager];
    if ([_targetFloatVersion isVersionLess:@"10"]) {
        NSMutableArray *tarNewRecordArray1 = [NSMutableArray array];
        NSMutableArray *tarNewRecordArray2 = [NSMutableArray array];
        BOOL canAdd = YES;
        for (int i=0;i<[_targetrecordArray count];i++ ) {
            IMBMBFileRecord *record = [_targetrecordArray objectAtIndex:i];
            if (canAdd) {
                [tarNewRecordArray1 addObject:record];
            }else
            {
                [tarNewRecordArray2 addObject:record];
            }
            
            if ([record.path isEqualToString:@"Library/Voicemail"]&&[record.domain isEqualToString:@"HomeDomain"]) {
                canAdd = NO;
            }
        }
        [_targetrecordArray removeAllObjects];
        [_targetrecordArray addObjectsFromArray:tarNewRecordArray1];
        NSMutableArray *ar = [NSMutableArray array];
        for (IMBMBFileRecord *record in voicemailRecordArray) {
            for (IMBMBFileRecord *targetRecor in tarNewRecordArray2) {
                if ([record.path isEqualToString:targetRecor.path]) {
                    [ar addObject:record];
                }
            }
        }
        [voicemailRecordArray removeObjectsInArray:ar];
        [_targetrecordArray addObjectsFromArray:voicemailRecordArray];
        [_targetrecordArray addObjectsFromArray:tarNewRecordArray2];
        for (IMBMBFileRecord *record in voicemailRecordArray) {
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
                ;
            }
        }
        [self modifyHashAndManifest];

    }else{
        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
            if ([voicemailRecordArray count] == 0) {
                [self modifyHashAndManifest];
                return;
            }else{
                [self createAttachmentPlist:voicemailRecordArray TargetDB:_targetManifestDBConnection isClone:NO];
            }
        }
        [self modifyHashAndManifest];
    }
}

- (void)createAttachmentPlist:(NSMutableArray *)sourceattachmentRecordArray TargetDB:(FMDatabase *)targetDB isClone:(BOOL)isClone
{
    if ([self openDataBase:targetDB]) {
        [self openDataBase:_sourceManifestDBConnection];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //首先查看目标数据库是否存在一样的
        NSString *querySql = @"SELECT rowid,file FROM Files where fileID =:fileID";
        for (IMBMBFileRecord *record in sourceattachmentRecordArray) {
            BOOL isexsited = NO;
            NSDictionary *param = [NSDictionary dictionaryWithObject:record.key forKey:@"fileID"];
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
                    NSDictionary *param1 = [NSDictionary dictionaryWithObject:record.key forKey:@"fileID"];
                    NSString *querySql1 = @"SELECT rowid,file FROM Files where fileID =:fileID";
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
                        data = [self createPlist:record createHash:YES];
                        [insertParams setObject:@(1) forKey:@"flags"];
                    }else{
                        data = [self createPlist:record createHash:NO];
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
                if (isClone) {
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
        [self closeDataBase:targetDB];
        [self closeDataBase:_sourceManifestDBConnection];
    }
}

- (NSData *)createPlist:(IMBMBFileRecord *)record createHash:(BOOL)createHash
{
    NSData *data = nil;
    NSMutableDictionary *firstDic = [NSMutableDictionary dictionary];
    [firstDic setObject:@"NSKeyedArchiver" forKey:@"$archiver"];
    NSMutableArray *objectsList = [NSMutableArray array];
    [objectsList addObject:@"$null"];
    NSMutableDictionary *objectsDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
    [classDic setObject:@(5) forKey:@"CF$UID"];
    [objectsDic setObject:classDic forKey:@"$class"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"Birth"];
    if (createHash) {
        NSMutableDictionary *DigestDic = [NSMutableDictionary dictionary];
        [DigestDic setObject:@(3) forKey:@"CF$UID"];
        [objectsDic setObject:DigestDic forKey:@"Digest"];
    }
    [objectsDic setObject:@(record.userId) forKey:@"GroupID"];
    [objectsDic setObject:@(record.inode) forKey:@"InodeNumber"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"LastModified"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"LastStatusChange"];
    [objectsDic setObject:@(record.mode) forKey:@"Mode"];
    if (createHash) {
        [objectsDic setObject:@(4) forKey:@"ProtectionClass"];
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
            //计算hash
            NSString *hash = [IMBBaseClone dataHashfilePath:sourcefilePath];
            data = [hash hexToBytes];
        }else{
            //计算hash
            NSString *hash = [IMBBaseClone dataHashfilePath:[_sourceBackuppath stringByAppendingPathComponent:record.key]];
            data = [hash hexToBytes];
        }
        if (data) {
            [nsDataDic setObject:data forKey:@"NS.data"];
        }
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


- (void)mergeVoicemail:(int)voicemailID
{
    [_logHandle writeInfoLog:@"merge Voicemail table voicemail  enter"];
    NSString *sql1 = @"select * from voicemail where ROWID=:voicemailID";
    NSString *sql2 = @"insert into voicemail(remote_uid,date,token,sender,callback_num,duration,expiration,trashed_date,flags) values(?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:voicemailID] forKey:@"voicemailID"];
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        NSInteger remote_uid = [rs intForColumn:@"remote_uid"];
        NSInteger date = [rs intForColumn:@"date"];
        NSString *token = [rs stringForColumn:@"token"];
        NSString *sender = [rs stringForColumn:@"sender"];
        NSString *callback_num = [rs stringForColumn:@"callback_num"];
        NSInteger duration = [rs intForColumn:@"duration"];
        NSInteger expiration = [rs intForColumn:@"expiration"];
        NSInteger trashed_date = [rs intForColumn:@"trashed_date"];
        NSInteger flags = [rs intForColumn:@"flags"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:remote_uid],[NSNumber numberWithInt:date],token,sender,callback_num,[NSNumber numberWithInt:duration],[NSNumber numberWithInt:expiration],[NSNumber numberWithInt:trashed_date],[NSNumber numberWithInt:flags]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"merge Voicemail table voicemail exit"];
}
@end

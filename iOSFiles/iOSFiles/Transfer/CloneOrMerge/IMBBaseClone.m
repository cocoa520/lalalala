//
//  IMBBaseClone.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-16.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseClone.h"
#import "TempHelper.h"
@implementation IMBBaseClone
@synthesize isneedClone = isneedClone;
@synthesize succesCount = _succesCount;
- (id)init
{
    if (self = [super init]) {
        _succesCount = 0;
        _logHandle = [IMBLogManager singleton];
        _sourceVersion = 6;
        _targetVersion = 6;
    }
    return self;
}

- (id)initWithSourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray isClone:(BOOL)isClone
{
    if (self = [self init]) {
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
    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
        _sourceManifestDBConnection = [[FMDatabase alloc] initWithPath:[sourceBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
    }
    if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
         _targetManifestDBConnection = [[FMDatabase alloc] initWithPath:[desBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
    }
}

- (void)clone{}
#pragma mark method
- (void)modifyHashAndManifest
{
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSString *lowSqlitebackupPath = nil;
    if ([_targetFloatVersion isVersionLess:@"10"]&&targetRecord) {
        lowSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:targetRecord.key];
    }else if (targetRecord){
       lowSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:targetRecord.relativePath];
    }
    if ([fileM fileExistsAtPath:lowSqlitebackupPath]) {
        [fileM removeItemAtPath:lowSqlitebackupPath error:nil];
    }
    if (_targetSqlitePath!=nil&&lowSqlitebackupPath!=nil) {
        [fileM copyItemAtPath:_targetSqlitePath toPath:lowSqlitebackupPath error:nil];
    }
    NSString *highSqlitebackupPath = nil;
    if ([_sourceFloatVersion isVersionLess:@"10"]&&sourceRecord) {
        highSqlitebackupPath = [_sourceBackuppath stringByAppendingPathComponent:sourceRecord.key];
    }else if (sourceRecord){
        highSqlitebackupPath = [_sourceBackuppath stringByAppendingPathComponent:sourceRecord.relativePath];
    }
    if ([fileM fileExistsAtPath:highSqlitebackupPath]) {
        [fileM removeItemAtPath:highSqlitebackupPath error:nil];
    }
    if (_sourceSqlitePath!=nil&&highSqlitebackupPath!=nil) {
        [fileM copyItemAtPath:_sourceSqlitePath toPath:highSqlitebackupPath error:nil];
    }
    if (_isClone) {
        if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
            [self modifyHashMajorEqualTen:_sourceManifestDBConnection SqlitePath:_sourceSqlitePath record:sourceRecord];
        }else{
            [IMBBaseClone reCaculateRecordHash:sourceRecord backupFolderPath:_sourceBackuppath];
            [IMBBaseClone saveMBDB:_sourcerecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceManifest.mbdb"] backupFolderPath:_sourceBackuppath];
        }
        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
            [self modifyHashMajorEqualTen:_targetManifestDBConnection SqlitePath:_targetSqlitePath record:targetRecord];
        }else{
             [IMBBaseClone reCaculateRecordHash:targetRecord backupFolderPath:_targetBakcuppath];
             [IMBBaseClone saveMBDB:_targetrecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetManifest.mbdb"] backupFolderPath:_targetBakcuppath];
        }
    }else{
        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
            [self modifyHashMajorEqualTen:_targetManifestDBConnection SqlitePath:_targetSqlitePath record:targetRecord];
        }else{
            [IMBBaseClone reCaculateRecordHash:targetRecord backupFolderPath:_targetBakcuppath];
            [IMBBaseClone saveMBDB:_targetrecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetManifest.mbdb"] backupFolderPath:_targetBakcuppath];
        }
    }
}

- (void)deleteRecords:(NSArray *)recordArray TargetDB:(FMDatabase *)targetDB
{
    if ([self openDataBase:targetDB]) {
        for (IMBMBFileRecord *record in recordArray) {
            NSString *sql = @"delete from Files where fileID=:fileID";
            [targetDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObject:record.key forKey:@"fileID"]];
        }
        [self closeDataBase:targetDB];
    }
}

- (void)addRecords:(NSArray *)recordArray sourceDB:(FMDatabase *)sourceDB TargetDB:(FMDatabase *)targetDB sourceVersion:(NSString *)sourceVersion
{
    if ([self openDataBase:targetDB]) {
        [self openDataBase:sourceDB];
        //首先查看目标数据库是否存在一样的
        NSString *querySql = @"SELECT rowid,file FROM Files where relativePath =:relativePath and domain=:domain";
        for (IMBMBFileRecord *record in recordArray) {
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
                if ([sourceVersion isVersionMajorEqual:@"10"]) {
                    NSString *querySql1 = @"SELECT rowid,file FROM Files where fileID =:fileID";
                    NSDictionary *param1 = [NSDictionary dictionaryWithObject:record.key forKey:@"fileID"];
                    FMResultSet *rs1 = [sourceDB executeQuery:querySql1 withParameterDictionary:param1];
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
                    }
                }
            }
        }
        [self closeDataBase:targetDB];
        [self closeDataBase:sourceDB];
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
    [classDic setObject:@(3) forKey:@"CF$UID"];
    [objectsDic setObject:classDic forKey:@"$class"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"Birth"];
    [objectsDic setObject:@(record.userId) forKey:@"GroupID"];
    [objectsDic setObject:@(record.inode) forKey:@"InodeNumber"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"LastModified"];
    [objectsDic setObject:@((long long)[[NSDate date] timeIntervalSince1970]) forKey:@"LastStatusChange"];
    [objectsDic setObject:@(record.mode) forKey:@"Mode"];
    if (createHash) {
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



- (void)modifyHashMajorEqualTen:(FMDatabase *)targetDB SqlitePath:(NSString *)sqlitePath record:(IMBMBFileRecord *)record
{
    if ([self openDataBase:targetDB]&&record) {
        NSString *sql = @"select file from Files where fileID=:fileID";
        NSDictionary *param = [NSDictionary dictionaryWithObject:record.key forKey:@"fileID"];
        FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:param];
        while ([rs next]) {
            NSData *data = [rs dataForColumn:@"file"];
            NSDictionary *dic = [NSDictionary dictionaryFromData:data];
            NSArray *array = [dic objectForKey:@"$objects"];
            NSMutableArray *muArray = [NSMutableArray arrayWithArray:array];
            int i=0;
            for (id item in array) {
                if ([item isKindOfClass:[NSData class]]) {
                    //计算hash
                    NSString *hash = [IMBBaseClone dataHashfilePath:sqlitePath];
                    NSData *bytedata = [hash hexToBytes];
                    if (bytedata != nil) {
                        [muArray replaceObjectAtIndex:i withObject:bytedata];
                    }
                }else if ([item isKindOfClass:[NSDictionary class]]){
                    //改变大小
                    if ([((NSDictionary *)item).allKeys containsObject:@"Size"]) {
                        int64_t fileSize = [IMBUtilTool fileSizeAtPath:sqlitePath];
                        [item setObject:@(fileSize) forKey:@"Size"];
                    }
                }
                i++;
            }
            [dic setValue:muArray forKeyPath:@"$objects"];
            NSString *updateSql = @"update Files set file=:file where fileID=:fileID";
            NSDictionary *updateParams = [NSDictionary dictionaryWithObjectsAndKeys:[dic toData],@"file",record.key,@"fileID",nil];
            [targetDB executeUpdate:updateSql withParameterDictionary:updateParams];
        }
        [self closeDataBase:targetDB];
    }
}

+ (NSString *)dataHashfilePath:(NSString *)filePath
{
    uint8_t hash[20] = { 0x00 };
    NSData *cont = [NSData dataWithContentsOfFile:filePath];
    const char *buf = [cont bytes];
    long len = cont.length;
    CC_SHA1_CTX content;
    CC_SHA1_Init(&content);
    CC_SHA1_Update(&content, buf, (int)len);
    CC_SHA1_Final(hash, &content);
    NSString *dataHashStr = [NSString stringToHex:hash length:CC_SHA1_DIGEST_LENGTH];
    return dataHashStr;
}

+ (int)getBackupFileVersion:(NSString *)backupPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mpfilePath = [backupPath stringByAppendingPathComponent:@"Manifest.plist"];
    NSString *desfilePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
    if ([fileManager fileExistsAtPath:desfilePath]) {
        
        [fileManager removeItemAtPath:desfilePath error:nil];
    }
    if (mpfilePath == nil) {
        return 10;
    }
    [fileManager copyItemAtPath:mpfilePath toPath:desfilePath error:nil];
    NSDictionary *mpDic = [NSDictionary dictionaryWithContentsOfFile:desfilePath];
    NSDictionary *lockDic  = [mpDic objectForKey:@"Lockdown"];
    NSString *productVersion = [lockDic objectForKey:@"ProductVersion"];
    NSString *versionstrone = nil;
    if (productVersion.length>0) {
        NSRange range;
        NSString *str = [productVersion substringWithRange:NSMakeRange(2, 1)];
        if ([str isEqualToString:@"."]) {
            //表示版本号为两位数
            range.length = 2;
            range.location = 0;
        }else {
            range.length = 1;
            range.location = 0;
        }
        versionstrone = [productVersion substringWithRange:range];
    }else
    {
        return 5;
    }
    return [versionstrone intValue];
}

+ (NSString *)getBackupFileFloatVersion:(NSString *)backupPath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mpfilePath = [backupPath stringByAppendingPathComponent:@"Manifest.plist"];
    NSString *desfilePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
    if ([fileManager fileExistsAtPath:desfilePath]) {
        
        [fileManager removeItemAtPath:desfilePath error:nil];
    }
    if (mpfilePath == nil) {
        return @"10.0";
    }
    [fileManager copyItemAtPath:mpfilePath toPath:desfilePath error:nil];
    NSDictionary *mpDic = [NSDictionary dictionaryWithContentsOfFile:desfilePath];
    NSDictionary *lockDic  = [mpDic objectForKey:@"Lockdown"];
    NSString *productVersion = [lockDic objectForKey:@"ProductVersion"];
    NSString *versionstrone = nil;
    if (productVersion.length>=3) {
        NSRange range;
        NSString *str = [productVersion substringWithRange:NSMakeRange(2, 1)];
        if ([str isEqualToString:@"."]) {
            range.length = 4;
            range.location = 0;
        }else{
            range.length = 3;
            range.location = 0;
        }
        versionstrone = [productVersion substringWithRange:range];
        return versionstrone;
    }
    return @"10.0";
}


- (NSString *)createGUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

- (IMBMBFileRecord *)getDBFileRecord:(NSString *)domainName path:(NSString *)path recordArray:(NSMutableArray *)recordArray{
    IMBMBFileRecord *SMSDBFileItem = nil;
    if ([recordArray count] > 0) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMBMBFileRecord *item = (IMBMBFileRecord *)evaluatedObject;
            if ([[item domain] isEqualToString:domainName] && [[item path] rangeOfString:path].length > 0) {
                return YES;
            } else {
                return NO;
            }
        }];
        NSArray *preArray = [recordArray filteredArrayUsingPredicate:pre];
        if (preArray != nil && [preArray count] > 0) {
            SMSDBFileItem = [preArray objectAtIndex:0];
        }
    }
    return SMSDBFileItem;
}

- (NSString *)copyIMBMBFileRecordTodesignatedPath:(NSString *)path fileRecord:(IMBMBFileRecord *)record backupfilePath:(NSString *)backupfilePath
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *desfilePath = nil;
    if (record) {
        NSString *sourcefilePath = nil;
        if ([[IMBBaseClone getBackupFileFloatVersion:backupfilePath] isVersionMajorEqual:@"10"]) {
            NSString *rstr = [record.key substringWithRange:NSMakeRange(0, 2)];
            NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,record.key];
            sourcefilePath = [backupfilePath stringByAppendingPathComponent:relativePath];
        }else{
            sourcefilePath = [backupfilePath stringByAppendingPathComponent:record.key];
        }
        if ([filemanager fileExistsAtPath:sourcefilePath]) {
            desfilePath = path;
            //假如该文件已经存在,则先删除
            if ([filemanager fileExistsAtPath:desfilePath]) {
                [filemanager removeItemAtPath:desfilePath error:nil];
            }
            if ([filemanager copyItemAtPath:sourcefilePath toPath:desfilePath error:nil]) {
                return desfilePath;
            }else{
                [[IMBLogManager singleton] writeInfoLog:@"copy sourcefilePath failed"];
            }
        }else
        {
            [[IMBLogManager singleton] writeInfoLog:@"sourcefilePath is not exsited"];
            return nil;
        }
    }else{
        [[IMBLogManager singleton] writeInfoLog:@"record is nil"];

    }
    return nil;
}

- (NSString *)copySourcePath:(NSString *)sourcePath desPath:(NSString *)desPath
{
     NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:sourcePath]) {
        //假如该文件已经存在,则先删除
        if ([filemanager fileExistsAtPath:desPath]) {
            [filemanager removeItemAtPath:desPath error:nil];
        }
        if ([filemanager copyItemAtPath:sourcePath toPath:desPath error:nil]) {
            return desPath;
        }else{
            return nil;
        }
    }else
    {
        return nil;
    }
}

#pragma mark - Manifest Operation
//重新计算filerecord的hash值
+ (void)reCaculateRecordHash:(IMBMBFileRecord *)mbfileRecord backupFolderPath:(NSString *)backupFolderPath {
    if (mbfileRecord != nil) {
        NSString *targetFilePath = [backupFolderPath stringByAppendingPathComponent:[mbfileRecord key]];
        // 得到文件的大小并进行赋值
        int64_t fileSize = [IMBUtilTool fileSizeAtPath:targetFilePath];
        [mbfileRecord changeFileLength:fileSize];
        // 计算hash的值并赋与DataHash
        uint8_t hash[20] = { 0x00 };
        NSData *cont = [NSData dataWithContentsOfFile:targetFilePath];
        const char *buf = [cont bytes];
        long len = cont.length;
        CC_SHA1_CTX content;
        CC_SHA1_Init(&content);
        CC_SHA1_Update(&content, buf, (int)len);
        CC_SHA1_Final(hash, &content);
        NSString *dataHashStr = [NSString stringToHex:hash length:CC_SHA1_DIGEST_LENGTH];
        [mbfileRecord setDataHash:dataHashStr];
    }
}

// 将修改号了的Manifest文件保存到备份文件中去,recordsArray修改后的记录,cacheFilePath文件写入的缓存的路径,backupFolderPath备份的文件夹下面
+ (BOOL)saveMBDB:(NSArray*)recordsArray cacheFilePath:(NSString *)cacheFilePath backupFolderPath:(NSString*)backupFolderPath {
    //[[IMBHelper getBackupCacheFolder] stringByAppendingPathComponent:@"Manifest.mbdb"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *cacheMBDBFilePath = cacheFilePath;
    NSMutableData *writer = [[NSMutableData alloc] init];
    if (recordsArray != nil && [recordsArray count] > 0) {
        NSData *sigData = [@"6D6264620500" hexToBytes];
        [writer appendData:sigData];
        for (IMBMBFileRecord *fileRecord in recordsArray) {
            [self writeStr:writer str:[fileRecord domain]];
            [self writeStr:writer str:[fileRecord path]];
            [self writeStr:writer str:[fileRecord linkTarget]];
            [self writeDataHex:writer hexStr:[fileRecord dataHash]];
            [self writeData:writer withData:[fileRecord encryptionKey]];
            NSData *lpdata = [[fileRecord data] hexToBytes];
            if (lpdata != nil) {
                [writer appendData:lpdata];
            }
            NSArray *properties = [[fileRecord properties] retain];
            if (properties != nil && [properties count] > 0) {
                for (IMBFileProperties *filePropertie in properties) {
                    [self writeStr:writer str:[filePropertie name]];
                    [self writeDataHex:writer hexStr:[filePropertie value]];
                }
            }
            [properties release];
        }
    }
    if ([fm fileExistsAtPath:cacheMBDBFilePath]) {
        [fm removeItemAtPath:cacheMBDBFilePath error:nil];
    }
    [writer writeToFile:cacheMBDBFilePath atomically:YES];
    [writer release];
    
    if ([fm fileExistsAtPath:cacheMBDBFilePath] && [IMBUtilTool fileSizeAtPath:cacheMBDBFilePath] > 0) {
        NSString *targetFilePath = [backupFolderPath stringByAppendingPathComponent:@"Manifest.mbdb"];
        if ([fm fileExistsAtPath:targetFilePath]) {
            [fm removeItemAtPath:targetFilePath error:nil];
        }
        [fm copyItemAtPath:cacheMBDBFilePath toPath:targetFilePath error:nil];
    }
    return YES;
}

+ (void)writeStr:(NSMutableData*)writer str:(NSString*)str {
    int dataLength = 0;
    Byte b0, b1;
    if (str == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}

+ (void)writeDataHex:(NSMutableData*)writer hexStr:(NSString*)hexStr {
    int dataLength = 0;
    Byte b0, b1;
    if (hexStr == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        NSData *data = [hexStr hexToBytes];
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}

+ (void)writeData:(NSMutableData*)writer withData:(NSData*)data {
    int dataLength = 0;
    Byte b0, b1;
    if (data == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}

#pragma mark - Sqlite open close
- (BOOL)openDataBase:(FMDatabase *)dbconnection {
    if ([dbconnection open]) {
        [dbconnection setShouldCacheStatements:YES];
        [dbconnection setTraceExecution:NO];
        return true;
    }
    return false;
}

- (BOOL)closeDataBase:(FMDatabase *)databaseConnection {
    
    return [databaseConnection close];
}

- (void)dealloc
{
    [_sourceFloatVersion release],_sourceFloatVersion = nil;
    [_targetFloatVersion release],_targetFloatVersion = nil;
    [_sourceDBConnection release],_sourceDBConnection = nil;
    [_targetDBConnection release],_targetDBConnection = nil;
    [_sourceBackuppath release],_sourceBackuppath = nil;
    [_targetBakcuppath release],_targetBakcuppath = nil;
    [sourceRecord release],sourceRecord = nil;
    [targetRecord release],targetRecord = nil;
    [_sourceSqlitePath release],_sourceSqlitePath = nil;
    [_targetSqlitePath release],_targetSqlitePath = nil;
    [_sourcerecordArray release],_sourcerecordArray = nil;
    [_targetrecordArray release],_targetrecordArray = nil;
    [_sourceManifestDBConnection release],_sourceManifestDBConnection = nil;
    [_targetManifestDBConnection release],_targetManifestDBConnection = nil;
    [super dealloc];
}
@end

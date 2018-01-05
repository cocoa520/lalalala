//
//  IMBContactToiOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBContactToiOS.h"
#import "IMBAddressBookDataEntity.h"

@implementation IMBContactToiOS

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
            if (_sourceSqliteContactImagePath != nil &&_targetSqliteContactImagePath != nil) {
                if (_sourceVersion>_targetVersion) {
                    _sourceImageDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqliteContactImagePath];
                    _targetImageDBConnection = [[FMDatabase alloc] initWithPath:_targetSqliteContactImagePath];
                }else
                {
                    _sourceImageDBConnection = [[FMDatabase alloc] initWithPath:_targetSqliteContactImagePath];
                    _targetImageDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqliteContactImagePath];
                }
            }else
            {
                if (_sourceSqliteContactImagePath == nil) {
                    [_logHandle writeInfoLog:@"_sourceSqliteContactImagePath is empty"];
                }
                if (_targetSqliteContactImagePath == nil) {
                    [_logHandle writeInfoLog:@"_targetSqliteContactImagePath is empty"];
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
            if (_sourceSqliteContactImagePath != nil) {
                _sourceImageDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqliteContactImagePath];

            }
            if (_targetSqliteContactImagePath != nil) {
                _targetImageDBConnection = [[FMDatabase alloc] initWithPath:_targetSqliteContactImagePath];
            }
            if (_sourceSqliteContactImagePath == nil) {
                [_logHandle writeInfoLog:@"_sourceSqliteContactImagePath is empty"];
            }
            if (_targetSqliteContactImagePath == nil) {
                [_logHandle writeInfoLog:@"_targetSqliteContactImagePath is empty"];
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
    //解析manifest
    _sourcerecordArray = [sourcerecordArray retain];
    _targetrecordArray = [targetrecordArray retain];
    _sourceBackuppath = [sourceBackupPath retain];
    _targetBakcuppath = [desBackupPath retain];
    
    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
        _sourceManifestDBConnection = [[FMDatabase alloc] initWithPath:[sourceBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
    }
    {
        sourceRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/AddressBook/AddressBook.sqlitedb" recordArray:_sourcerecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,sourceRecord.key];
        sourceRecord.relativePath = relativePath;
        _sourceContactImageRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/AddressBook/AddressBookImages.sqlitedb" recordArray:_sourcerecordArray] retain];
        NSString *rstr1 = [_sourceContactImageRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath1 = [NSString stringWithFormat:@"%@/%@",rstr1,_sourceContactImageRecord.key];
        _sourceContactImageRecord.relativePath = relativePath1;
        _sourceSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceSqlite"] fileRecord:sourceRecord backupfilePath:sourceBackupPath] retain];
        _sourceSqliteContactImagePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceImageSqlite"] fileRecord:_sourceContactImageRecord backupfilePath:sourceBackupPath] retain];
    }
    if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
        _targetManifestDBConnection = [[FMDatabase alloc] initWithPath:[desBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
    }
    {
        targetRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/AddressBook/AddressBook.sqlitedb" recordArray:_targetrecordArray] retain];
        NSString *rstr = [targetRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,targetRecord.key];
        targetRecord.relativePath = relativePath;
        _targetContactImageRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/AddressBook/AddressBookImages.sqlitedb" recordArray:_targetrecordArray] retain];
        NSString *rstr1 = [_targetContactImageRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath1 = [NSString stringWithFormat:@"%@/%@",rstr1,_targetContactImageRecord.key];
        _targetContactImageRecord.relativePath = relativePath1;
        _targetSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetSqlite"] fileRecord:targetRecord backupfilePath:desBackupPath] retain];
        _targetSqliteContactImagePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetImageSqlite"] fileRecord:_targetContactImageRecord backupfilePath:desBackupPath] retain];
    }
}

- (void)merge:(NSArray *)dataArray
{
    @try {
        if ([self openDataBase:_targetDBConnection]) {
            [self openDataBase:_targetImageDBConnection];
            [_targetDBConnection beginTransaction];
            [_targetImageDBConnection beginTransaction];
            if (_targetVersion>=9) {
                [self deleteTrigger:_targetDBConnection];
            }
            [self mergeABMultiValueEntryKey:@"service"];
            [self mergeABMultiValueEntryKey:@"username"];
            [self mergeABMultiValueEntryKey:@"url"];
            [self mergeABMultiValueEntryKey:@"Street"];
            [self mergeABMultiValueEntryKey:@"ZIP"];
            [self mergeABMultiValueEntryKey:@"City"];
            [self mergeABMultiValueEntryKey:@"State"];
            [self mergeABMultiValueEntryKey:@"Country"];
            [self mergeABMultiValueEntryKey:@"CountryCode"];
            [self mergeABMultiValueEntryKey:@"displayname"];

            for (IMBAddressBookDataEntity *entity in dataArray){
                int newRowID = -1;
                newRowID = [self mergeABPerson:entity targetDB:_targetDBConnection];
                if (newRowID != -1) {
                    [self mergeABMultiValue:entity newRecordID:newRowID targetDB:_targetDBConnection];
                    if (entity.imageData != nil) {
                        [self mergeABFullSizeImageNewRecordID:newRowID ImageData:entity.imageData];
                        [self mergeABThumbnailImageNewRecordID:newRowID ImageData:entity.imageData];
                    }
                }
            }
            if (![_targetDBConnection commit]){
                [_targetDBConnection rollback];
            }
            if (![_targetImageDBConnection commit]) {
                [_targetImageDBConnection rollback];
            }
            if (_targetVersion>=9) {
                [self creatTrigger:_targetDBConnection];
            }
            [self closeDataBase:_targetDBConnection];
            [self closeDataBase:_targetImageDBConnection];
        }
    } @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"----Error----:Merge IMBContactToiOS error:%@", exception]];
    }
    @finally {
        
    }
    [self modifyHashAndManifest];
}

- (void)modifyHashAndManifest
{
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSString *lowSqlitebackupPath = nil;
    NSString *targetImageSqlitebackupPath = nil;

    if ([_targetFloatVersion isVersionLess:@"10"]&&targetRecord) {
        lowSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:targetRecord.key];
        targetImageSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:_targetContactImageRecord.key];

    }else if (targetRecord){
        lowSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:targetRecord.relativePath]
        ;
        targetImageSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:_targetContactImageRecord.relativePath];

    }
    if ([fileM fileExistsAtPath:lowSqlitebackupPath]) {
        [fileM removeItemAtPath:lowSqlitebackupPath error:nil];
    }
    if ([fileM fileExistsAtPath:targetImageSqlitebackupPath]) {
        [fileM removeItemAtPath:targetImageSqlitebackupPath error:nil];
    }
    if (_targetSqlitePath!=nil&&lowSqlitebackupPath!=nil) {
        [fileM copyItemAtPath:_targetSqlitePath toPath:lowSqlitebackupPath error:nil];
    }
    if (_targetSqliteContactImagePath!=nil&&targetImageSqlitebackupPath!=nil) {
        [fileM copyItemAtPath:_targetSqliteContactImagePath toPath:targetImageSqlitebackupPath error:nil];
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
            [self modifyHashMajorEqualTen:_targetManifestDBConnection SqlitePath:_targetSqliteContactImagePath record:_targetContactImageRecord];
        }else{
            [IMBBaseClone reCaculateRecordHash:targetRecord backupFolderPath:_targetBakcuppath];
            [IMBBaseClone reCaculateRecordHash:_targetContactImageRecord backupFolderPath:_targetBakcuppath];
            [IMBBaseClone saveMBDB:_targetrecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetManifest.mbdb"] backupFolderPath:_targetBakcuppath];
        }
    }
}


- (void)mergeABMultiValueEntryKey:(NSString *)value
{
    NSString *sql2 = @"insert into ABMultiValueEntryKey(value) values(?)";
    //执行sql语句,返回结果集
    //value如果存在，不会插入成功
    [_targetDBConnection executeUpdate:sql2,value];
}


- (int)mergeABPerson:(IMBAddressBookDataEntity *)contact targetDB:(FMDatabase *)targetDB
{
    NSString *sql2 = nil;
    if (_targetVersion>=7) {
        sql2 = @"INSERT INTO ABPerson (Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName,guid,PhonemeData) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else{
        sql2 = @"INSERT INTO ABPerson (Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    
    
    NSString *birthday = nil;
    NSString *firstname = contact.firstName;
    NSString *lastname  = contact.lastName;
    NSString *middlename = contact.middleName;
    
    if (firstname == nil&&lastname == nil&&middlename == nil) {
        firstname = contact.allName;
    }
    //check 目标设备是否存在相同的contact
    int rowID = [self checkContactfirstName:firstname middleName:middlename lastName:lastname targetDB:targetDB];
    if (rowID != -1) {
        return rowID;
    }
    NSString *firstnameyomi = contact.firstNameYomi;
    NSString *lastnameyomi = contact.lastNameYomi;
    NSString *middlePhonetic = contact.middleNameYomi;
    NSString *organization  = contact.companyName;
    NSString *department = contact.jobTitle;
    NSString *note  = contact.notes;
    int kind = 0;
    NSString *jobTitle = contact.jobTitle;
    NSString *nickname = contact.nickName;
    NSString *suffix  = contact.suffix;
    NSString *prefix = contact.prefix;
    NSString *firstSort = nil;
    NSString *lastSort = nil;
    
    
    if (firstname.length == 0) {
        firstname = nil;
    }
    if (lastname.length == 0) {
        lastname = nil;
    }if (firstname.length == 0) {
        firstname = nil;
    }if (middlename.length == 0) {
        middlename = nil;
    }if (firstnameyomi.length == 0) {
        firstnameyomi = nil;
    }if (lastnameyomi.length == 0) {
        lastnameyomi = nil;
    }if (middlePhonetic.length == 0) {
        middlePhonetic = nil;
    }if (organization.length == 0) {
        organization = nil;
    }if (department.length == 0) {
        department = nil;
    }if (note.length == 0) {
        note = nil;
    }if (jobTitle.length == 0) {
        jobTitle = nil;
    }if (nickname.length == 0) {
        nickname = nil;
    }if (suffix.length == 0) {
        suffix = nil;
    }if (prefix.length == 0) {
        prefix = nil;
    }

    
    NSString *CompositeNameFallback = nil;
    NSString *ExternalIdentifier = nil;
    NSString *ExternalModificationTag = nil;
    NSString *ExternalUUID = nil;
    int StoreID = [self getStoreID:targetDB];
    
    NSString *DisplayName = nil;
    NSData *ExternalRepresentation = nil;
    NSString *FirstSortSection = nil;
    NSString *LastSortSection = nil;
    int FirstSortLanguageIndex = 0;
    int LastSortLanguageIndex = 0;
    int PersonLink = -1;
    NSString *ImageURI = nil;
    int IsPreferredName = 1;
    NSString *guid = [self createGUID];
    NSString *PhonemeData = nil;
    if (_targetVersion>=7) {
        if ([targetDB executeUpdate:sql2,birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName],guid,PhonemeData]) {
            _succesCount += 1;
        }
    }else{
        if ([targetDB executeUpdate:sql2,birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName]]) {
            _succesCount += 1;
        }
    }
    int maxRowID = -1;
    NSString *sql3 = @"select last_insert_rowid() from ABPerson";
    FMResultSet *rs1 = [targetDB executeQuery:sql3];
    while ([rs1 next]) {
        maxRowID = [rs1 intForColumn:@"last_insert_rowid()"];
    }
    [rs1 close];
    return maxRowID;
}


- (void)mergeABMultiValue:(IMBAddressBookDataEntity *)contact newRecordID:(int)newRecordID targetDB:(FMDatabase *)targetDB
{
    NSString *sql = nil;
    if (_targetVersion>=7) {
        sql = @"insert into ABMultiValue(record_id,property,identifier,label,value,guid) values(?,?,?,?,?,?)";
    }else{
        sql = @"insert into ABMultiValue(record_id,property,identifier,label,value) values(?,?,?,?,?)";
    }
    
    //执行sql语句,返回结果集
    int record_id = newRecordID;
    //插入电话号码
    for (IMBAddressBookMultDataEntity *entity in contact.numberArray) {
        int property = 3;
        int identifier = [self getidentify:record_id property:property targetDB:targetDB];
        int label = [self getABMultiValueLabelID:entity.lableType targetDB:targetDB];
        NSString *value = entity.multValue;
        NSString *guid = [self createGUID];
        BOOL success = NO;
        if (_targetVersion>=7) {
            success = [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value,guid];
        }else{
            success = [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value];
        }
        if (success) {
            int abMultiValueRowID = -1;
            NSString *sql5 = @"select last_insert_rowid() from ABMultiValue";
            FMResultSet *rs = [targetDB executeQuery:sql5];
            while ([rs next]) {
                abMultiValueRowID = [rs intForColumn:@"last_insert_rowid()"];
            }
            [rs close];
            if (abMultiValueRowID != -1) {
                [self mergeABPhoneLastFour:abMultiValueRowID value:value targetDB:targetDB];
            }
        }
    }
    
    //插入邮箱
    for (IMBAddressBookMultDataEntity *entity in contact.emailArray) {
        int property = 4;
        int identifier = [self getidentify:record_id property:property targetDB:targetDB];
        int label = [self getABMultiValueLabelID:entity.lableType targetDB:targetDB];
        NSString *value = entity.multValue;
        NSString *guid = [self createGUID];
        if (_targetVersion>=7) {
            [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value,guid];
        }else{
            [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value];
        }
    }
    
    //插入url
    for (IMBAddressBookMultDataEntity *entity in contact.URLArray) {
        int property = 22;
        int identifier = [self getidentify:record_id property:property targetDB:targetDB];
        int label = [self getABMultiValueLabelID:entity.lableType targetDB:targetDB];
        NSString *value = entity.multValue;
        NSString *guid = [self createGUID];
        if (_targetVersion>=7) {
            [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value,guid];
        }else{
            [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value];
        }
    }
    
    //插入关联的人
    for (IMBAddressBookMultDataEntity *entity in contact.relatedArray) {
        int property = 23;
        int identifier = [self getidentify:record_id property:property targetDB:targetDB];
        int label = [self getABMultiValueLabelID:entity.lableType targetDB:targetDB];
        NSString *value = entity.multValue;
        NSString *guid = [self createGUID];
        if (_targetVersion>=7) {
            [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value,guid];
        }else{
            [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value];
        }
    }
    
    //插入日期事件
    for (IMBAddressBookMultDataEntity *entity in contact.dateArray) {
        int property = 12;
        int identifier = [self getidentify:record_id property:property targetDB:targetDB];
        int label = [self getABMultiValueLabelID:entity.lableType targetDB:targetDB];
        NSString *value = entity.multValue;
        NSString *guid = [self createGUID];
        if (_targetVersion>=7) {
            [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value,guid];
        }else{
            [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value];
        }
    }
    
    //插入地址，由于android 地址没有详细区分 街道 省份等 所以统一将信息插入street
    for (IMBAddressBookMultDataEntity *entity in contact.streetArray) {
        int property = 5;
        int identifier = [self getidentify:record_id property:property targetDB:targetDB];
        int label = [self getABMultiValueLabelID:entity.lableType targetDB:targetDB];
        NSString *guid = [self createGUID];
        BOOL success = NO;
        if (_targetVersion>=7) {
            success = [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],[NSNull null],guid];
        }else{
            success = [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],[NSNull null]];
        }
        if (success) {
            int abMultiValueRowID = -1;
            NSString *sql5 = @"select last_insert_rowid() from ABMultiValue";
            FMResultSet *rs = [targetDB executeQuery:sql5];
            while ([rs next]) {
                abMultiValueRowID = [rs intForColumn:@"last_insert_rowid()"];
            }
            [rs close];
            if (abMultiValueRowID != -1) {
                for (IMBAddressBookDetailEntity *detailEn in entity.multiArray) {
                    int key = [self getABMultiValueEntryKeyID:detailEn.entityType targetDB:targetDB];
                    NSString *MultiValueEntrysql = @"insert into ABMultiValueEntry(parent_id,key,value) values(?,?,?)";
                    [targetDB executeUpdate:MultiValueEntrysql,@(abMultiValueRowID),@(key),detailEn.detailValue];
                }
            }
        }
    }
    
    //插入即时通讯
    for (IMBAddressBookMultDataEntity *entity in contact.IMArray) {
        int property = 13;
        int identifier = [self getidentify:record_id property:property targetDB:targetDB];
        int label = [self getABMultiValueLabelID:entity.lableType targetDB:targetDB];
        NSString *guid = [self createGUID];
        BOOL success = NO;
        if (_targetVersion>=7) {
            success = [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],[NSNull null],guid];
        }else{
            success = [targetDB executeUpdate:sql,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],[NSNull null]];
        }
        if (success) {
            int abMultiValueRowID = -1;
            NSString *sql5 = @"select last_insert_rowid() from ABMultiValue";
            FMResultSet *rs = [targetDB executeQuery:sql5];
            while ([rs next]) {
                abMultiValueRowID = [rs intForColumn:@"last_insert_rowid()"];
            }
            [rs close];
            if (abMultiValueRowID != -1) {
                for (IMBAddressBookDetailEntity *detailEn in entity.multiArray) {
                    int key = [self getABMultiValueEntryKeyID:detailEn.entityType targetDB:targetDB];
                    NSString *MultiValueEntrysql = @"insert into ABMultiValueEntry(parent_id,key,value) values(?,?,?)";
                    [targetDB executeUpdate:MultiValueEntrysql,@(abMultiValueRowID),@(key),detailEn.detailValue];
                }
            }
        }
    }
}

- (void)mergeABPhoneLastFour:(int)uid value:(NSString *)value targetDB:(FMDatabase *)targetDB
{
    NSString *sql2 = @"insert into ABPhoneLastFour(multivalue_id,value) values(?,?)";
    //执行sql语句,返回结果集
    NSString *substr = nil;
    if (value.length>4) {
        substr = [value substringFromIndex:value.length-4];
    }
    if (substr!=nil) {
        [targetDB executeUpdate:sql2,[NSNumber numberWithInt:uid],substr];
    }
}

- (void)mergeABFullSizeImageNewRecordID:(int)newRecordID  ImageData:(NSData *)imageData
{
    [_logHandle writeInfoLog:@"merge Contacts table ABFullSizeImage enter"];
    NSString *sql2 = @"insert into ABFullSizeImage(record_id,crop_x,crop_y,crop_width,data) values(?,?,?,?,?)";
    //执行sql语句,返回结果集
        int record_id = newRecordID;
        NSData *data = imageData;
        [_targetImageDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:200],[NSNumber numberWithInt:200],[NSNumber numberWithInt:500],data];
    [_logHandle writeInfoLog:@"merge Contacts table ABFullSizeImage exit"];
}

- (void)mergeABThumbnailImageNewRecordID:(int)newRecordID ImageData:(NSData *)imageData
{
    [_logHandle writeInfoLog:@"merge Contacts table ABThumbnailImage enter"];
    NSString *sql2 = @"insert into ABThumbnailImage(record_id,format,derived_from_format,data) values(?,?,?,?)";
    //执行sql语句,返回结果集
    int record_id = newRecordID;
    int format = 0;
    int derived_from_format = 2;
    [_targetImageDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:format],[NSNumber numberWithInt:derived_from_format],imageData];
    format = 4;
    derived_from_format = 2;
    [_targetImageDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:format],[NSNumber numberWithInt:derived_from_format],imageData];
    [_logHandle writeInfoLog:@"merge Contacts table ABThumbnailImage exit"];
}

- (int)getidentify:(int)recordId property:(int)property targetDB:(FMDatabase *)targetDB
{
    int identify = 0;
    int count = 0;
    NSString *sql = @"select max(identifier),count(identifier) from ABMultiValue where record_id=:recordID and property=:property";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:recordId],@"recordID",[NSNumber numberWithInt:property], @"property",nil];
    FMResultSet *set = [targetDB executeQuery:sql withParameterDictionary:dic];
    while ([set next]) {
        identify = [set intForColumnIndex:0];
        count = [set intForColumnIndex:1];
        if (count == 0) {
            break;
        }
    }
    [set close];
    if (count>0) {
        identify++;
    }
    return identify;
}

- (int)getABMultiValueEntryKeyID:(NSString *)value targetDB:(FMDatabase *)targetDB
{
    int rowid = -1;
    NSString *sql1 = @"insert into ABMultiValueEntryKey(value) values(?)";
    [targetDB executeUpdate:sql1,value];
    
    NSString *sql2 = @"select rowid from ABMultiValueEntryKey where value=:value";
    NSDictionary *par = [NSDictionary dictionaryWithObject:value?:@"" forKey:@"value"];
    FMResultSet *rs = [targetDB executeQuery:sql2 withParameterDictionary:par];
    while ([rs next]) {
        rowid = [rs intForColumn:@"rowid"];
    }
    [rs close];
    if (rowid != -1) {
        return rowid;
    }else{
        return 1;
    }
}

//根据value值 查询器id 如果不存在插入再返回其id
- (int)getABMultiValueLabelID:(NSString *)value targetDB:(FMDatabase *)targetDB
{
    int rowid = -1;
    NSString *sql1 = @"insert into ABMultiValueLabel(value) values(?)";
    [targetDB executeUpdate:sql1,value];
    
    NSString *sql2 = @"select rowid from ABMultiValueLabel where value=:value";
    NSDictionary *par = [NSDictionary dictionaryWithObject:value?:@"" forKey:@"value"];
    FMResultSet *rs = [targetDB executeQuery:sql2 withParameterDictionary:par];
    while ([rs next]) {
        rowid = [rs intForColumn:@"rowid"];
    }
    [rs close];
    if (rowid != -1) {
        return rowid;
    }else{
        return 1;
    }
}

- (int)mergeABPersonLessThanOrEqualToiOS7:(IMBAddressBookDataEntity *)contact targetDB:(FMDatabase *)targetDB
{
    NSString *sql2 = nil;
    if (_targetVersion>=7) {
        sql2 = @"INSERT INTO ABPerson (Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName,guid,PhonemeData) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
    }else{
        sql2 = @"INSERT INTO ABPerson (Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    NSString *birthday = nil;
    NSString *firstname = contact.firstName;
    NSString *lastname  = contact.lastName;
    NSString *middlename = contact.middleName;
    //check 目标设备是否存在相同的contact
    int rowID = [self checkContactfirstName:firstname middleName:middlename lastName:lastname targetDB:targetDB];
    if (rowID != -1) {
        return rowID;
    }
    NSString *firstnameyomi = contact.firstNameYomi;
    NSString *lastnameyomi = contact.lastNameYomi;
    NSString *middlePhonetic = contact.middleNameYomi;
    NSString *organization  = contact.companyName;
    NSString *department = contact.department;
    NSString *note  = contact.notes;
    int kind = 0;
    NSString *jobTitle = contact.jobTitle;
    NSString *nickname = contact.nickName;
    NSString *suffix  = contact.suffix;
    NSString *prefix = contact.prefix;
    NSString *firstSort = nil;
    NSString *lastSort = nil;
    NSString *CompositeNameFallback = nil;
    NSString *ExternalIdentifier = nil;
    NSString *ExternalModificationTag = nil;
    NSString *ExternalUUID = nil;
    int StoreID = [self getStoreID:targetDB];
    NSString *DisplayName = nil;
    NSData *ExternalRepresentation = nil;
    NSString *FirstSortSection = nil;
    NSString *LastSortSection = nil;
    int FirstSortLanguageIndex = 0;
    int LastSortLanguageIndex = 0;
    int PersonLink = -1;
    NSString *ImageURI = nil;
    int IsPreferredName = 1;
    NSString *guid = [self createGUID];
    NSString *PhonemeData = nil;
    if (_targetVersion>=7) {
        [targetDB executeUpdate:sql2,birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName],guid,PhonemeData];
    }else
    {
        [targetDB executeUpdate:sql2,birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName]];
    }
    int maxRowID = -1;
    NSString *sql3 = @"select last_insert_rowid() from ABPerson";
    FMResultSet *rs1 = [targetDB executeQuery:sql3];
    while ([rs1 next]) {
        maxRowID = [rs1 intForColumn:@"last_insert_rowid()"];
    }
    [rs1 close];
    return maxRowID;
}


- (int)getStoreID:(FMDatabase *)targetDB
{
    int storeID = 0;
    NSString *sql = @"select ROWID from ABStore where StoreInternalIdentifier='local'";
    FMResultSet *rs = [targetDB executeQuery:sql];
    while ([rs next]) {
        storeID = [rs intForColumn:@"ROWID"];
    }
    [rs close];
    return storeID;
}


- (int)checkContactfirstName:(NSString *)firstName middleName:(NSString *)middleName lastName:(NSString *)lastName targetDB:(FMDatabase *)targetDB
{
    int rowID = -1;
    NSString *sql = @"select ROWID from ABPerson where (ifnull(First,?)||ifnull(Middle,?)||ifnull(Last,?))=?";
    NSString *fullName = [NSString stringWithFormat:@"%@%@%@",firstName?firstName:@"",middleName?middleName:@"",lastName?lastName:@""];
    FMResultSet *set = [targetDB executeQuery:sql,@"",@"",@"",fullName];
    while ([set next]) {
        rowID = [set intForColumn:@"ROWID"];
    }
    [set close];
    return rowID;
}

- (void)deleteTrigger:(FMDatabase *)targetFMDB {
    NSString *deletetrigger1 = @"DROP TRIGGER NamePreferredPersonInsertTrigger";
    NSString *deletetrigger2 = @"DROP TRIGGER InitializePersonLinkField";
    NSString *deletetrigger3 = @"DROP TRIGGER UpdatePersonUponLinkInsertion";
    NSString *deletetrigger4 = @"DROP TRIGGER UpdatePersonUponLinkUpdate";
    NSString *deletetrigger5 = @"DROP TRIGGER UpdatePersonLinkField";
    @try {
        [targetFMDB executeUpdate:deletetrigger1];
        [targetFMDB executeUpdate:deletetrigger2];
        [targetFMDB executeUpdate:deletetrigger3];
        [targetFMDB executeUpdate:deletetrigger4];
        [targetFMDB executeUpdate:deletetrigger5];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"delete contact Trigger filed:%@",exception]];
    }
}

-(void)creatTrigger:(FMDatabase *)targetFMDB {
    NSString *creattrigger1 = @"CREATE TRIGGER NamePreferredPersonInsertTrigger AFTER INSERT ON ABPerson BEGIN UPDATE ABPersonLink SET PreferredNamePersonID = NEW.ROWID WHERE (ROWID = NEW.PersonLink AND PreferredNamePersonID = -1); END;";
    NSString *creattrigger2 = @"CREATE TRIGGER InitializePersonLinkField AFTER INSERT ON ABPerson BEGIN UPDATE ABPerson SET IsPreferredName = ab_update_value_from_trigger((NEW.PersonLink = -1 OR ROWID = (SELECT PreferredNamePersonID FROM ABPersonLink abl WHERE abl.ROWID = NEW.PersonLink)), 'IsPreferredName', ROWID) WHERE ROWID = NEW.ROWID; END;";
    NSString *creattrigger3 = @"CREATE TRIGGER UpdatePersonUponLinkInsertion AFTER INSERT ON ABPersonLink BEGIN UPDATE ABPerson SET IsPreferredName = ab_update_value_from_trigger(ROWID = NEW.PreferredNamePersonID, 'IsPreferredName', ROWID) WHERE PersonLink = NEW.ROWID; END;";
    NSString *creattrigger4 = @"CREATE TRIGGER UpdatePersonUponLinkUpdate AFTER UPDATE ON ABPersonLink BEGIN UPDATE ABPerson SET IsPreferredName = ab_update_value_from_trigger(ROWID = NEW.PreferredNamePersonID, 'IsPreferredName', ROWID) WHERE PersonLink = NEW.ROWID; END;";
    NSString *creattrigger5 = @"CREATE TRIGGER UpdatePersonLinkField AFTER UPDATE OF PersonLink ON ABPerson WHEN OLD.PersonLink != NEW.PersonLink BEGIN UPDATE ABPerson SET IsPreferredName = ab_update_value_from_trigger((NEW.PersonLink = -1 OR ROWID = (SELECT PreferredNamePersonID FROM ABPersonLink abl WHERE abl.ROWID = NEW.PersonLink)), 'IsPreferredName', ROWID) WHERE ROWID = NEW.ROWID; END;";
    @try {
        [targetFMDB executeUpdate:creattrigger1];
        [targetFMDB executeUpdate:creattrigger2];
        [targetFMDB executeUpdate:creattrigger3];
        [targetFMDB executeUpdate:creattrigger4];
        [targetFMDB executeUpdate:creattrigger5];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"creat contact Trigger filed:%@",exception]];
    }
}

- (void)dealloc
{
    [_sourceContactImageRecord release],_sourceContactImageRecord = nil;
    [_targetContactImageRecord release],_targetContactImageRecord = nil;
    [_sourceSqliteContactImagePath release],_sourceSqliteContactImagePath = nil;
    [_targetSqliteContactImagePath release],_targetSqliteContactImagePath = nil;
    [_sourceImageDBConnection release],_sourceImageDBConnection = nil;
    [_targetImageDBConnection release],_targetImageDBConnection = nil;
    [super dealloc];
}
@end

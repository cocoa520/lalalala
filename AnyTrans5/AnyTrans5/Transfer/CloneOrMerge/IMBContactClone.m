//
//  IMBContactClone.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-12.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBContactClone.h"
#import "IMBAddressBookDataEntity.h"
@implementation IMBContactClone
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
            if (_sourceSqlitePath != nil&&_targetSqlitePath != nil) {
                _sourceDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqlitePath];
                _targetDBConnection = [[FMDatabase alloc] initWithPath:_targetSqlitePath];
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
                    _sourceImageDBConnection = [[FMDatabase alloc] initWithPath:_sourceSqliteContactImagePath];
                    _targetImageDBConnection = [[FMDatabase alloc] initWithPath:_targetSqliteContactImagePath];
            }else
            {
                if (_sourceSqliteContactImagePath == nil) {
                    [_logHandle writeInfoLog:@"_sourceSqliteContactImagePath is empty"];
                }
                if (_targetSqliteContactImagePath == nil) {
                    [_logHandle writeInfoLog:@"_targetSqliteContactImagePath is empty"];
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
#pragma mark - merge
- (void)merge:(NSArray *)contactArray
{
    NSInteger version = MIN(_sourceVersion, _targetVersion);
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"merge Contacts count:%d",contactArray.count]];
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            [_logHandle writeInfoLog:@"merge Contacts enter"];
            [self openDataBase:_sourceImageDBConnection];
            [self openDataBase:_targetImageDBConnection];
            [_sourceImageDBConnection beginTransaction];
            [_targetImageDBConnection beginTransaction];
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            //先插入只有主键没有外键的表
            //如果是iOS9需要删除触发器
            if (_targetVersion>=9) {
                [self deleteTrigger];
            }
            [self mergeABMultiValueEntryKey];
            [self mergeABMultiValueLabel];
            for (IMBAddressBookDataEntity *entity in contactArray) {
                @autoreleasepool {
                    int newRowID = -1;
                    //以iOS7为基准线   如果最小版本>=7 我们以7为标准 如果最小
                    if (version>=7) {
                        newRowID = [self mergeABPersonGreaterThanOrEqualToiOS7:entity.rowid contactEntity:entity];
                        if (newRowID == -1) {
                            continue;
                        }
                        [self mergeABMultiValueGreaterThanOrEqualToiOS7:entity.rowid newRecordID:newRowID];
                    }else{
                        newRowID = [self mergeABPersonLessThanOrEqualToiOS7:entity.rowid contactEntity:entity TargetVersion:_targetVersion];
                        if (newRowID == -1) {
                            continue;
                        }
                        [self mergeABMultiValueLessThanOrEqualToiOS7:entity.rowid newRecordID:newRowID TargetVersion:_targetVersion];
                    }
                    [self mergeABPersonSearchKey:entity.rowid newPersonID:newRowID];
                    [self mergeABFullSizeImage:entity.rowid newRecordID:newRowID];
                    [self mergeABThumbnailImage:entity.rowid  newRecordID:newRowID];
                    [self mergeABPersonFullTextSearch_content:entity.rowid  newPersonID:newRowID];
                    [self mergeABPersonFullTextSearch_docsize:entity.rowid  newPersonID:newRowID];
                }
            }
            if (_targetVersion>=9) {
                [self creatTrigger];
            }
            [_logHandle writeInfoLog:@"merge Contacts exit"];
            if (![_sourceDBConnection commit]) {
                [_sourceDBConnection rollback];
            }
            if (![_targetDBConnection commit]) {
                [_targetDBConnection rollback];
            }
            if (![_sourceImageDBConnection commit]) {
                [_sourceImageDBConnection rollback];
            }
            if (![_targetImageDBConnection commit]) {
                [_targetImageDBConnection rollback];
            }
        }
        [self closeDataBase:_sourceDBConnection];
        [self closeDataBase:_targetDBConnection];
        [self closeDataBase:_sourceImageDBConnection];
        [self closeDataBase:_targetImageDBConnection];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    //修改HashandManifest
    [self modifyHashAndManifest];
}

- (void)deleteTrigger
{
    NSString *deletetrigger1 = @"DROP TRIGGER NamePreferredPersonInsertTrigger";
    NSString *deletetrigger2 = @"DROP TRIGGER InitializePersonLinkField";
    NSString *deletetrigger3 = @"DROP TRIGGER UpdatePersonUponLinkInsertion";
    NSString *deletetrigger4 = @"DROP TRIGGER UpdatePersonUponLinkUpdate";
    NSString *deletetrigger5 = @"DROP TRIGGER UpdatePersonLinkField";
    @try {
        [_targetDBConnection executeUpdate:deletetrigger1];
        [_targetDBConnection executeUpdate:deletetrigger2];
        [_targetDBConnection executeUpdate:deletetrigger3];
        [_targetDBConnection executeUpdate:deletetrigger4];
        [_targetDBConnection executeUpdate:deletetrigger5];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"delete contact Trigger filed:%@",exception]];
    }
}

- (void)creatTrigger
{
    NSString *creattrigger1 = @"CREATE TRIGGER NamePreferredPersonInsertTrigger AFTER INSERT ON ABPerson BEGIN UPDATE ABPersonLink SET PreferredNamePersonID = NEW.ROWID WHERE (ROWID = NEW.PersonLink AND PreferredNamePersonID = -1); END;";
    NSString *creattrigger2 = @"CREATE TRIGGER InitializePersonLinkField AFTER INSERT ON ABPerson BEGIN UPDATE ABPerson SET IsPreferredName = ab_update_value_from_trigger((NEW.PersonLink = -1 OR ROWID = (SELECT PreferredNamePersonID FROM ABPersonLink abl WHERE abl.ROWID = NEW.PersonLink)), 'IsPreferredName', ROWID) WHERE ROWID = NEW.ROWID; END;";
    NSString *creattrigger3 = @"CREATE TRIGGER UpdatePersonUponLinkInsertion AFTER INSERT ON ABPersonLink BEGIN UPDATE ABPerson SET IsPreferredName = ab_update_value_from_trigger(ROWID = NEW.PreferredNamePersonID, 'IsPreferredName', ROWID) WHERE PersonLink = NEW.ROWID; END;";
    NSString *creattrigger4 = @"CREATE TRIGGER UpdatePersonUponLinkUpdate AFTER UPDATE ON ABPersonLink BEGIN UPDATE ABPerson SET IsPreferredName = ab_update_value_from_trigger(ROWID = NEW.PreferredNamePersonID, 'IsPreferredName', ROWID) WHERE PersonLink = NEW.ROWID; END;";
    NSString *creattrigger5 = @"CREATE TRIGGER UpdatePersonLinkField AFTER UPDATE OF PersonLink ON ABPerson WHEN OLD.PersonLink != NEW.PersonLink BEGIN UPDATE ABPerson SET IsPreferredName = ab_update_value_from_trigger((NEW.PersonLink = -1 OR ROWID = (SELECT PreferredNamePersonID FROM ABPersonLink abl WHERE abl.ROWID = NEW.PersonLink)), 'IsPreferredName', ROWID) WHERE ROWID = NEW.ROWID; END;";
    @try {
        [_targetDBConnection executeUpdate:creattrigger1];
        [_targetDBConnection executeUpdate:creattrigger2];
        [_targetDBConnection executeUpdate:creattrigger3];
        [_targetDBConnection executeUpdate:creattrigger4];
        [_targetDBConnection executeUpdate:creattrigger5];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"creat contact Trigger filed:%@",exception]];
    }
}

- (int)mergeABPersonGreaterThanOrEqualToiOS7:(int)rowID contactEntity:(IMBAddressBookDataEntity *)contact
{
    
    NSString *sql1 = @"select * from ABPerson where ROWID=:rowid";
    //执行sql语句,返回结果集
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:rowID] forKey:@"rowid"];
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:dic];;
    NSString *sql2 = @"INSERT INTO ABPerson (Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CreationDate,ModificationDate,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName,guid,PhonemeData) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    while ([rs next]) {
        
        NSString *birthday = [rs stringForColumn:@"Birthday"];
        NSString *firstname = [rs stringForColumn:@"First"];
        NSString *lastname  = [rs stringForColumn:@"Last"];
        NSString *middlename = [rs stringForColumn:@"Middle"];
        //check 目标设备是否存在相同的contact
        int rowID = [self checkContactfirstName:firstname middleName:middlename lastName:lastname targetDB:_targetDBConnection];
        if (rowID != -1) {
            return rowID;
        }
        NSString *firstnameyomi = [rs stringForColumn:@"FirstPhonetic"];
        NSString *lastnameyomi = [rs stringForColumn:@"LastPhonetic"];
        NSString *middlePhonetic = [rs stringForColumn:@"MiddlePhonetic"];
        NSString *organization  = [rs stringForColumn:@"Organization"];
        NSString *department = [rs stringForColumn:@"Department"];
        NSString *note  = [rs stringForColumn:@"Note"];
        int kind = [rs intForColumn:@"Kind"];
        NSString *jobTitle = [rs stringForColumn:@"JobTitle"];
        NSString *nickname = [rs stringForColumn:@"Nickname"];
        NSString *suffix  = [rs stringForColumn:@"Suffix"];
        NSString *prefix = [rs stringForColumn:@"Prefix"];
        NSString *firstSort = [rs stringForColumn:@"FirstSort"];
        NSString *lastSort = [rs stringForColumn:@"LastSort"];
        int creationDate = [rs intForColumn:@"CreationDate"];
        int modificationDate = [rs intForColumn:@"ModificationDate"];
        NSString *CompositeNameFallback = [rs stringForColumn:@"CompositeNameFallback"];
        NSString *ExternalIdentifier = [rs stringForColumn:@"ExternalIdentifier"];
        NSString *ExternalModificationTag = [rs stringForColumn:@"ExternalModificationTag"];
        NSString *ExternalUUID = [rs stringForColumn:@"ExternalUUID"];
        
        int StoreID = [self getStoreID:_targetDBConnection];
        NSString *DisplayName = [rs stringForColumn:@"DisplayName"];
        NSData *ExternalRepresentation = [rs dataForColumn:@"ExternalRepresentation"];
        NSString *FirstSortSection = [rs stringForColumn:@"FirstSortSection"];
        NSString *LastSortSection = [rs stringForColumn:@"LastSortSection"];
        int FirstSortLanguageIndex = [rs intForColumn:@"FirstSortLanguageIndex"];
        int LastSortLanguageIndex = [rs intForColumn:@"LastSortLanguageIndex"];
        int PersonLink = -1;
        NSString *ImageURI = [rs stringForColumn:@"ImageURI"];
        int IsPreferredName = 1;
        NSString *guid = [rs stringForColumn:@"guid"];
        NSString *PhonemeData = [rs stringForColumn:@"PhonemeData"];
        [_targetDBConnection executeUpdate:sql2,birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,[NSNumber numberWithInt:creationDate],[NSNumber numberWithInt:modificationDate],CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName],guid,PhonemeData];
    }
    [rs close];
    int maxRowID = -1;
    NSString *sql3 = @"select last_insert_rowid() from ABPerson";
    FMResultSet *rs1 = [_targetDBConnection executeQuery:sql3];
    while ([rs1 next]) {
        maxRowID = [rs1 intForColumn:@"last_insert_rowid()"];
    }
    [rs1 close];
    return maxRowID;
    
}

- (void)mergeABMultiValueGreaterThanOrEqualToiOS7:(int)recordID newRecordID:(int)newRecordID
{
    NSString *sql1 = @"select * from ABMultiValue where record_id=:recordid";
    NSString *sql2 = @"insert into ABMultiValue(record_id,property,identifier,label,value,guid) values(?,?,?,?,?,?)";
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:recordID] forKey:@"recordid"];
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:param];
    //执行sql语句,返回结果集
    int uid = -1;
    while ([rs next]) {
        uid = [rs intForColumn:@"UID"];
        int record_id = newRecordID;
        int property  = [rs intForColumn:@"property"];
        int identifier = [self getidentify:record_id property:property targetDB:_targetDBConnection];
        int label  = [rs intForColumn:@"label"];
        NSString *value = [rs stringForColumn:@"value"];
        
        int newlabel = -1;
        NSString *sql3 = @"select value from ABMultiValueLabel where rowid=:label";
        NSDictionary *pa = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:label] forKey:@"label"];
        FMResultSet *rs1 = [_sourceDBConnection executeQuery:sql3 withParameterDictionary:pa];
        while ([rs1 next]) {
            
            NSString *value = [rs1 stringForColumn:@"value"];
            NSDictionary *par = [NSDictionary dictionaryWithObject:value?:@"" forKey:@"value"];
            NSString *sql4 = @"select rowid from ABMultiValueLabel where value=:value";
            FMResultSet *rs2 = [_targetDBConnection executeQuery:sql4 withParameterDictionary:par];
            while ([rs2 next]) {
                newlabel = [rs2 intForColumn:@"rowid"];
            }
            [rs2 close];
        }
        [rs1 close];
        NSString *guid = [rs stringForColumn:@"guid"];
        if (newlabel == -1) {
            newlabel = 1;
        }
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:newlabel],value,guid];
        
        int maxRowID = -1;
        NSString *sql5 = @"select last_insert_rowid() from ABMultiValue";
        FMResultSet *rs2 = [_targetDBConnection executeQuery:sql5];
        while ([rs2 next]) {
            maxRowID = [rs2 intForColumn:@"last_insert_rowid()"];
        }
        [rs2 close];
        if (uid != -1&&maxRowID != -1) {
            //获得新的id之后然后mergeABMultiValueEntry
            [self mergeABMultiValueEntry:uid newUid:maxRowID];
            if (property == 3) {
                [self mergeABPhoneLastFour:maxRowID value:value targetDB:_targetDBConnection];

            }
        }
    }
    [rs close];
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
//最小版本大于等于7
- (int)mergeABPersonLessThanOrEqualToiOS7:(NSInteger)rowID contactEntity:(IMBAddressBookDataEntity *)contact TargetVersion:(int)targetVersion
{
    
    NSString *sql1 = @"select * from ABPerson where ROWID=:rowid";
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:rowID] forKey:@"rowid"];
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:dic];
    NSString *sql2 = nil;
    if (targetVersion>=7) {
        sql2 = @"INSERT INTO ABPerson (Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CreationDate,ModificationDate,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName,guid,PhonemeData) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
    }else{
        sql2 = @"INSERT INTO ABPerson (Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CreationDate,ModificationDate,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    
    while ([rs next]) {
        NSString *birthday = [rs stringForColumn:@"Birthday"];
        NSString *firstname = [rs stringForColumn:@"First"];
        NSString *lastname  = [rs stringForColumn:@"Last"];
        NSString *middlename = [rs stringForColumn:@"Middle"];
        int rowID = [self checkContactfirstName:firstname middleName:middlename lastName:lastname targetDB:_targetDBConnection];
        if (rowID != -1) {
            return rowID;
        }
        NSString *firstnameyomi = [rs stringForColumn:@"FirstPhonetic"];
        NSString *lastnameyomi = [rs stringForColumn:@"LastPhonetic"];
        NSString *middlePhonetic = [rs stringForColumn:@"MiddlePhonetic"];
        NSString *organization  = [rs stringForColumn:@"Organization"];
        NSString *department = [rs stringForColumn:@"Department"];
        NSString *note  = [rs stringForColumn:@"Note"];
        int kind = [rs intForColumn:@"Kind"];
        NSString *jobTitle = [rs stringForColumn:@"JobTitle"];
        NSString *nickname = [rs stringForColumn:@"Nickname"];
        NSString *suffix  = [rs stringForColumn:@"Suffix"];
        NSString *prefix = [rs stringForColumn:@"Prefix"];
        NSString *firstSort = [rs stringForColumn:@"FirstSort"];
        NSString *lastSort = [rs stringForColumn:@"LastSort"];
        int creationDate = [rs intForColumn:@"CreationDate"];
        int modificationDate = [rs intForColumn:@"ModificationDate"];
        NSString *CompositeNameFallback = [rs stringForColumn:@"CompositeNameFallback"];
        NSString *ExternalIdentifier = [rs stringForColumn:@"ExternalIdentifier"];
        NSString *ExternalModificationTag = [rs stringForColumn:@"ExternalModificationTag"];
        NSString *ExternalUUID = [rs stringForColumn:@"ExternalUUID"];
        
        int StoreID = [self getStoreID:_targetDBConnection];
        NSString *DisplayName = [rs stringForColumn:@"DisplayName"];
        NSData *ExternalRepresentation = [rs dataForColumn:@"ExternalRepresentation"];
        NSString *FirstSortSection = [rs stringForColumn:@"FirstSortSection"];
        NSString *LastSortSection = [rs stringForColumn:@"LastSortSection"];
        int FirstSortLanguageIndex = [rs intForColumn:@"FirstSortLanguageIndex"];
        int LastSortLanguageIndex = [rs intForColumn:@"LastSortLanguageIndex"];
        int PersonLink = -1;
        NSString *ImageURI = [rs stringForColumn:@"ImageURI"];
        int IsPreferredName = 1;
        
        if (targetVersion>=7) {
            [_targetDBConnection executeUpdate:sql2,birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,[NSNumber numberWithInt:creationDate],[NSNumber numberWithInt:modificationDate],CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName],[self createGUID],[NSNull null]];
        }else
        {
            [_targetDBConnection executeUpdate:sql2,birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,[NSNumber numberWithInt:creationDate],[NSNumber numberWithInt:modificationDate],CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName]];
        }
    }
    [rs close];
    int maxRowID = -1;
    NSString *sql3 = @"select last_insert_rowid() from ABPerson";
    FMResultSet *rs1 = [_targetDBConnection executeQuery:sql3];
    while ([rs1 next]) {
        maxRowID = [rs1 intForColumn:@"last_insert_rowid()"];
    }
    [rs1 close];
    return maxRowID;
}


- (void)mergeABMultiValueLessThanOrEqualToiOS7:(int)recordID newRecordID:(int)newRecordID TargetVersion:(int)targetVersion
{
    [_logHandle writeInfoLog:@"merge Contacts table ABMultiValue iOS6 enter"];
    NSString *sql1 = @"select * from ABMultiValue where record_id=:recordid";
    NSString *sql2 = nil;
    if (targetVersion>=7) {
        sql2 = @"insert into ABMultiValue(record_id,property,identifier,label,value,guid) values(?,?,?,?,?,?)";
    }else
    {
        sql2 = @"insert into ABMultiValue(record_id,property,identifier,label,value) values(?,?,?,?,?)";
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:recordID] forKey:@"recordid"];
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:param];
    //执行sql语句,返回结果集
    int uid = -1;
    while ([rs next]) {
        uid = [rs intForColumn:@"UID"];
        int record_id = newRecordID;
        int property  = [rs intForColumn:@"property"];
        int identifier =[self getidentify:record_id property:property targetDB:_targetDBConnection];
        int label  = [rs intForColumn:@"label"];
        NSString *value = [rs stringForColumn:@"value"];
        int newlabel = -1;
        NSString *sql3 = @"select value from ABMultiValueLabel where rowid=:label";
        NSDictionary *pa = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:label] forKey:@"label"];
        FMResultSet *rs1 = [_sourceDBConnection executeQuery:sql3 withParameterDictionary:pa];
        while ([rs1 next]) {
            
            NSString *value = [rs1 stringForColumn:@"value"];
            NSDictionary *par = [NSDictionary dictionaryWithObject:value?:@"" forKey:@"value"];
            NSString *sql4 = @"select rowid from ABMultiValueLabel where value=:value";
            FMResultSet *rs2 = [_targetDBConnection executeQuery:sql4 withParameterDictionary:par];
            while ([rs2 next]) {
                newlabel = [rs2 intForColumn:@"rowid"];
            }
            [rs2 close];
        }
        [rs1 close];
        if (newlabel == -1) {
            newlabel = 1;
        }
        if (targetVersion>=7) {
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:newlabel],value,[self createGUID]];
        }else
        {
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:newlabel],value];
        }
        
        int maxRowID = -1;
        NSString *sql5 = @"select last_insert_rowid() from ABMultiValue";
        FMResultSet *rs2 = [_targetDBConnection executeQuery:sql5];
        while ([rs2 next]) {
            maxRowID = [rs2 intForColumn:@"last_insert_rowid()"];
        }
        [rs2 close];
        if (uid != -1&&maxRowID != -1) {
            //获得新的id之后然后mergeABMultiValueEntry
            [self mergeABMultiValueEntry:uid newUid:maxRowID];
            [self mergeABPhoneLastFour:maxRowID value:value targetDB:_targetDBConnection];
        }
    }
    [rs close];
    [_logHandle writeInfoLog:@"merge Contacts table ABMultiValue iOS6 exit"];
    
}

- (void)mergeABPersonSearchKey:(int)oldPersonID newPersonID:(int)newPersonID
{
    NSString *sql1 = @"select * from ABPersonSearchKey where person_id=:personid";
    NSString *sql2 = @"insert into ABPersonSearchKey(person_id,SearchKey,NameOnlySearchKey) values(?,?,?)";
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:oldPersonID] forKey:@"personid"];
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        int docid = newPersonID;
        NSData *searchKey = [rs dataForColumn:@"SearchKey"];
        NSData *nameOnlySearchKey = [rs dataForColumn:@"NameOnlySearchKey"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],searchKey,nameOnlySearchKey];
    }
}

- (void)mergeABPersonFullTextSearch_content:(int)oldPersonID newPersonID:(int)newPersonID
{
    NSString *sql1 = @"select * from ABPersonFullTextSearch_content where docid=:docid";
    NSString *sql2 = nil;
    if ([_targetFloatVersion isVersionLessEqual:@"10.1"]) {
        sql2 = @"insert into ABPersonFullTextSearch_content(docid,c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c7Department,c8Note,c9Birthday,c10JobTitle,c11Nickname,c12Prefix,c13Suffix,c14DisplayName,c15Phone,c16Email,c17Address,c18SocialProfile,c19URL,c20RelatedNames,c21IM,c22Date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else if ([_targetFloatVersion isVersionMajorEqual:@"10.2"]){
        sql2 = @"insert into ABPersonFullTextSearch_content(docid,c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c7OrganizationPhonetic,c8Department,c9Note,c10Birthday,c11JobTitle,c12Nickname,c13Prefix,c14Suffix,c15DisplayName,c16Phone,c17Email,c18Address,c19SocialProfile,c20URL,c21RelatedNames,c22IM,c23Date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:oldPersonID] forKey:@"docid"];
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        int docid = newPersonID;
        if ([_sourceFloatVersion isVersionLessEqual:@"10.1"]) {
            NSString *c0First = [rs stringForColumn:@"c0First"];
            NSString *c1Last = [rs stringForColumn:@"c1Last"];
            NSString *c2Middle = [rs stringForColumn:@"c2Middle"];
            NSString *c3FirstPhonetic = [rs stringForColumn:@"c3FirstPhonetic"];
            NSString *c4MiddlePhonetic = [rs stringForColumn:@"c4MiddlePhonetic"];
            NSString *c5LastPhonetic = [rs stringForColumn:@"c5LastPhonetic"];
            NSString *c6Organization = [rs stringForColumn:@"c6Organization"];
            NSString *c7Department = [rs stringForColumn:@"c7Department"];
            NSString *c8Note = [rs stringForColumn:@"c8Note"];
            NSString *c9Birthday = [rs stringForColumn:@"c9Birthday"];
            NSString *c10JobTitle = [rs stringForColumn:@"c10JobTitle"];
            NSString *c11Nickname = [rs stringForColumn:@"c11Nickname"];
            NSString *c12Prefix = [rs stringForColumn:@"c12Prefix"];
            NSString *c13Suffix = [rs stringForColumn:@"c13Suffix"];
            NSString *c14DisplayName = [rs stringForColumn:@"c14DisplayName"];
            NSString *c15Phone = [rs stringForColumn:@"c15Phone"];
            NSString *c16Email = [rs stringForColumn:@"c16Email"];
            NSString *c17Address = [rs stringForColumn:@"c17Address"];
            NSString *c18SocialProfile = [rs stringForColumn:@"c18SocialProfile"];
            NSString *c19URL = [rs stringForColumn:@"c19URL"];
            NSString *c20RelatedNames = [rs stringForColumn:@"c20RelatedNames"];
            NSString *c21IM = [rs stringForColumn:@"c21IM"];
            NSString *c22Date = [rs stringForColumn:@"c22Date"];
            
            if ([_targetFloatVersion isVersionLessEqual:@"10.1"]) {
                BOOL success = [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c7Department,c8Note,c9Birthday,c10JobTitle,c11Nickname,c12Prefix,c13Suffix,c14DisplayName,c15Phone,c16Email,c17Address,c18SocialProfile,c19URL,c20RelatedNames,c21IM,c22Date];
                if (!success) {
                    NSString *sql = @"update ABPersonFullTextSearch_content set c15Phone=(c15Phone||?) where docid=?";
                    [_targetDBConnection executeQuery:sql,c15Phone,[NSNumber numberWithInt:docid]];
                }

            }else if ([_targetFloatVersion isVersionMajorEqual:@"10.2"]){
                [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,[NSNull null],c7Department,c8Note,c9Birthday,c10JobTitle,c11Nickname,c12Prefix,c13Suffix,c14DisplayName,c15Phone,c16Email,c17Address,c18SocialProfile,c19URL,c20RelatedNames,c21IM,c22Date];
            }
            
            
        }else if ([_sourceFloatVersion isVersionMajorEqual:@"10.2"]){
            NSString *c0First = [rs stringForColumn:@"c0First"];
            NSString *c1Last = [rs stringForColumn:@"c1Last"];
            NSString *c2Middle = [rs stringForColumn:@"c2Middle"];
            NSString *c3FirstPhonetic = [rs stringForColumn:@"c3FirstPhonetic"];
            NSString *c4MiddlePhonetic = [rs stringForColumn:@"c4MiddlePhonetic"];
            NSString *c5LastPhonetic = [rs stringForColumn:@"c5LastPhonetic"];
            NSString *c6Organization = [rs stringForColumn:@"c6Organization"];
            NSString *c7OrganizationPhonetic = [rs stringForColumn:@"c7OrganizationPhonetic"];
            NSString *c8Department = [rs stringForColumn:@"c8Department"];
            NSString *c9Note = [rs stringForColumn:@"c9Note"];
            NSString *c10Birthday = [rs stringForColumn:@"c10Birthday"];
            NSString *c11JobTitle = [rs stringForColumn:@"c11JobTitle"];
            NSString *c12Nickname = [rs stringForColumn:@"c12Nickname"];
            NSString *c13Prefix = [rs stringForColumn:@"c13Prefix"];
            NSString *c14Suffix = [rs stringForColumn:@"c14Suffix"];
            NSString *c15DisplayName = [rs stringForColumn:@"c15DisplayName"];
            NSString *c16Phone = [rs stringForColumn:@"c16Phone"];
            NSString *c17Email = [rs stringForColumn:@"c17Email"];
            NSString *c18Address = [rs stringForColumn:@"c18Address"];
            NSString *c19SocialProfile = [rs stringForColumn:@"c19SocialProfile"];
            NSString *c20URL = [rs stringForColumn:@"c20URL"];
            NSString *c21RelatedNames = [rs stringForColumn:@"c21RelatedNames"];
            NSString *c22IM = [rs stringForColumn:@"c22IM"];
            NSString *c23Date = [rs stringForColumn:@"c23Date"];
            if ([_targetFloatVersion isVersionLessEqual:@"10.1"]) {
                [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c8Department,c9Note,c10Birthday,c11JobTitle,c12Nickname,c13Prefix,c14Suffix,c15DisplayName,c16Phone,c17Email,c18Address,c19SocialProfile,c20URL,c21RelatedNames,c22IM,c23Date];
            }else if ([_targetFloatVersion isVersionMajorEqual:@"10.2"]){
                BOOL success = [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c7OrganizationPhonetic,c8Department,c9Note,c10Birthday,c11JobTitle,c12Nickname,c13Prefix,c14Suffix,c15DisplayName,c16Phone,c17Email,c18Address,c19SocialProfile,c20URL,c21RelatedNames,c22IM,c23Date];
                if (!success) {
                    NSString *sql = @"update ABPersonFullTextSearch_content set c16Phone=(c16Phone||?) where docid=?";
                    [_targetDBConnection executeQuery:sql,c16Phone,[NSNumber numberWithInt:docid]];
                }
            }
        }
    }
    [rs close];
}

- (void)mergeABPersonFullTextSearch_docsize:(int)oldPersonID newPersonID:(int)newPersonID
{
    NSString *sql1 = @"select * from ABPersonFullTextSearch_docsize where docid=:docid";
    NSString *sql2 = @"insert into ABPersonFullTextSearch_docsize(docid,size) values(?,?)";
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:oldPersonID] forKey:@"docid"];
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        NSData *size = [rs dataForColumn:@"size"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:newPersonID],size];
    }
    [rs close];
}

- (void)mergeABFullSizeImage:(int)recordID newRecordID:(int)newRecordID
{
    [_logHandle writeInfoLog:@"merge Contacts table ABFullSizeImage enter"];
    NSString *sql1 = @"select * from ABFullSizeImage where record_id=:recordID";
    NSString *sql2 = @"insert into ABFullSizeImage(record_id,crop_x,crop_y,crop_width,data) values(?,?,?,?,?)";
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:recordID] forKey:@"recordID"];
    FMResultSet *rs = [_sourceImageDBConnection executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        
        // NSInteger ROWID = [rs intForColumn:@"ROWID"];
        int record_id = newRecordID;
        int crop_x = [rs intForColumn:@"crop_x"];
        int crop_y = [rs intForColumn:@"crop_y"];
        int crop_width = [rs intForColumn:@"crop_width"];
        NSData *data = [rs dataForColumn:@"data"];
        
        [_targetImageDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:crop_x],[NSNumber numberWithInt:crop_y],[NSNumber numberWithInt:crop_width],data];
    }
    [rs close];
    [_logHandle writeInfoLog:@"merge Contacts table ABFullSizeImage exit"];
}

- (void)mergeABThumbnailImage:(int)recordID newRecordID:(int)newRecordID
{
    [_logHandle writeInfoLog:@"merge Contacts table ABThumbnailImage enter"];
    NSString *sql1 = @"select * from ABThumbnailImage where record_id=:recordID";
    NSString *sql2 = @"insert into ABThumbnailImage(record_id,format,derived_from_format,data) values(?,?,?,?)";
    //执行sql语句,返回结果集
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:recordID] forKey:@"recordID"];
    FMResultSet *rs = [_sourceImageDBConnection executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        int record_id = newRecordID;
        int format = [rs intForColumn:@"format"];
        int derived_from_format = [rs intForColumn:@"derived_from_format"];
        NSData *data = [rs dataForColumn:@"data"];
        [_targetImageDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:format],[NSNumber numberWithInt:derived_from_format],data];
    }
    [rs close];
    [_logHandle writeInfoLog:@"merge Contacts table ABThumbnailImage exit"];
    
}


- (void)mergeABMultiValueEntry:(int)uid newUid:(int)newUid
{
    NSString *sql1 = @"select * from ABMultiValueEntry where parent_id=:uid";
    NSString *sql2 = @"insert into ABMultiValueEntry(parent_id,key,value) values(?,?,?)";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:dic];
    while ([rs next]) {
        int parent_id = newUid;
        int key = [rs intForColumn:@"key"];
        int newkey = -1;
        NSString *sql3 = @"select value from ABMultiValueEntryKey where rowid=:key";
        NSDictionary *par = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:key] forKey:@"key"];
        FMResultSet *rs1 = [_sourceDBConnection executeQuery:sql3 withParameterDictionary:par];
        while ([rs1 next]) {
            NSString *value = [rs1 stringForColumn:@"value"];
            NSString *sql4 = @"select rowid from ABMultiValueEntryKey where value=:value";
            NSDictionary *parm = [NSDictionary dictionaryWithObject:value?:@"" forKey:@"value"];
            FMResultSet *rs2 = [_targetDBConnection executeQuery:sql4 withParameterDictionary:parm];
            while ([rs2 next]) {
                newkey = [rs2 intForColumn:@"rowid"];
            }
            [rs2 close];
            
        }
        [rs1 close];
        NSString *value  = [rs stringForColumn:@"value"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:parent_id],[NSNumber numberWithInt:newkey],value];
    }
    [rs close];
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


- (void)mergeABMultiValueLabel
{
    NSString *sql1 = @"select * from ABMultiValueLabel";
    NSString *sql2 = @"insert into ABMultiValueLabel(value) values(?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        
        NSString *value  = [rs stringForColumn:@"value"];
        //value如果存在,不会插入成功。
        [_targetDBConnection executeUpdate:sql2,value];
    }
    [rs close];
}

- (void)mergeABMultiValueEntryKey
{
    NSString *sql1 = @"select * from ABMultiValueEntryKey";
    NSString *sql2 = @"insert into ABMultiValueEntryKey(value) values(?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSString *value  = [rs stringForColumn:@"value"];
        //value如果存在，不会插入成功
        [_targetDBConnection executeUpdate:sql2,value];
    }
    [rs close];
}
#pragma mark - clone
//将高版本contact数据库的值插入到低版本数据库
- (void)clone
{
    [_logHandle writeInfoLog:@"clone Contacts enter"];
    NSInteger version = MIN(_sourceVersion, _targetVersion);
    if (_sourceVersion<=_targetVersion) {
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                return;
            }
            IMBMBFileRecord *record = sourceRecord;
            sourceRecord = targetRecord;
            targetRecord = record;
            
            IMBMBFileRecord *srecord = _sourceContactImageRecord;
            _sourceContactImageRecord = _targetContactImageRecord;
            _targetContactImageRecord = srecord;
            
            NSString *scPath = _sourceSqliteContactImagePath;
            _sourceSqliteContactImagePath = _targetSqliteContactImagePath;
            _targetSqliteContactImagePath = scPath;
            
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
            if (_targetVersion>=9) {
                [self deleteTrigger];
            }
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            [self deleteAllData];
            if (version >=6) {
                [self insertABAccount];//iOS5没有此表
            }
            [self insertABGroup];
            [self insertABGroupChanges];
            [self insertABGroupMembers];
            [self insertABMultiValueEntry];
            [self insertABMultiValueEntryKey];
            [self insertABMultiValueLabel];
            if (version >= 7) {
                [self insertABMultiValueWithiOS7];
                [self insertABPersonWithiOS7];
            }else if (version <= 6)
            {
                [self insertABMultiValueWithiOS6];
                [self insertABPersonWithiOS6];
            }
            [self insertABPersonChanges];
            [self insertABPersonFullTextSearch_content];
            [self insertABPersonFullTextSearch_docsize];
            [self insertABPersonLink];
            [self insertABPersonMultiValueDeletes];
            [self insertABPersonSearchKey];
            [self insertABPhoneLastFour];
            if ([_targetFloatVersion isVersionLess:@"10"]) {
                [self insertABRecent];
                [self insertABPersonBasicChanges];
            }
            [self insertABStore];
        }
        if (_targetVersion>=9) {
            [self creatTrigger];
        }
        if (![_sourceDBConnection commit]) {
            [_sourceDBConnection rollback];
        }
        if (![_targetDBConnection commit]) {
            [_targetDBConnection rollback];
        }
        [self closeDataBase:_sourceDBConnection];
        [self closeDataBase:_targetDBConnection];
        //修改联系人头像数据库
        if ([self openDataBase:_sourceImageDBConnection]&& [self openDataBase:_targetImageDBConnection]) {
            [_sourceImageDBConnection beginTransaction];
            [_targetImageDBConnection beginTransaction];
            [self insertABFullSizeImage];
            [self insertABThumbnailImage];
            if (![_sourceImageDBConnection commit]) {
                [_sourceImageDBConnection rollback];
            }
            if (![_targetImageDBConnection commit]) {
                [_targetImageDBConnection rollback];
            }
        }
        [self closeDataBase:_sourceImageDBConnection];
        [self closeDataBase:_targetImageDBConnection];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [_logHandle writeInfoLog:@"clone Contacts exit"];
    //修改HashandManifest
    [self modifyHashAndManifest];
}

- (void)modifyHashAndManifest
{
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSString *highSqlitebackupPath = nil;
    NSString *sourceImageSqlitebackupPath = nil;
    if ([_sourceFloatVersion isVersionLess:@"10"]&&sourceRecord&&_sourceContactImageRecord) {
        highSqlitebackupPath = [_sourceBackuppath stringByAppendingPathComponent:sourceRecord.key];
        sourceImageSqlitebackupPath = [_sourceBackuppath stringByAppendingPathComponent:_sourceContactImageRecord.key];
    }else if (sourceRecord&&_sourceContactImageRecord){
        highSqlitebackupPath = [_sourceBackuppath stringByAppendingPathComponent:sourceRecord.relativePath];
        sourceImageSqlitebackupPath = [_sourceBackuppath stringByAppendingPathComponent:_sourceContactImageRecord.relativePath];
    }
    if ([fileM fileExistsAtPath:highSqlitebackupPath]) {
        [fileM removeItemAtPath:highSqlitebackupPath error:nil];
    }
    if (_sourceSqlitePath!=nil&&highSqlitebackupPath!=nil) {
        [fileM copyItemAtPath:_sourceSqlitePath toPath:highSqlitebackupPath error:nil];
    }
    if ([fileM fileExistsAtPath:sourceImageSqlitebackupPath]) {
        [fileM removeItemAtPath:sourceImageSqlitebackupPath error:nil];
    }
    if (_sourceSqliteContactImagePath!=nil&&sourceImageSqlitebackupPath!=nil) {
        [fileM copyItemAtPath:_sourceSqliteContactImagePath toPath:sourceImageSqlitebackupPath error:nil];
    }
    NSString *lowSqlitebackupPath = nil;
    NSString *targetImageSqlitebackupPath = nil;
    if ([_targetFloatVersion isVersionLess:@"10"]) {
        lowSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:targetRecord.key];
        targetImageSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:_targetContactImageRecord.key];

    }else{
        lowSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:targetRecord.relativePath];
        targetImageSqlitebackupPath = [_targetBakcuppath stringByAppendingPathComponent:_targetContactImageRecord.relativePath];
    }
    if ([fileM fileExistsAtPath:lowSqlitebackupPath]) {
        [fileM removeItemAtPath:lowSqlitebackupPath error:nil];
    }
    if (_targetSqlitePath!= nil&&lowSqlitebackupPath!=nil) {
        [fileM copyItemAtPath:_targetSqlitePath toPath:lowSqlitebackupPath error:nil];
    }
    if ([fileM fileExistsAtPath:targetImageSqlitebackupPath]) {
        [fileM removeItemAtPath:targetImageSqlitebackupPath error:nil];
    }
    if (_targetSqliteContactImagePath!=nil&&targetImageSqlitebackupPath!=nil) {
        [fileM copyItemAtPath:_targetSqliteContactImagePath toPath:targetImageSqlitebackupPath error:nil];
    }
    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
        [self modifyHashMajorEqualTen:_sourceManifestDBConnection SqlitePath:_sourceSqlitePath record:sourceRecord];
        [self modifyHashMajorEqualTen:_sourceManifestDBConnection SqlitePath:_sourceSqliteContactImagePath record:_sourceContactImageRecord];
    }else{
        [IMBBaseClone reCaculateRecordHash:sourceRecord backupFolderPath:_sourceBackuppath];
        [IMBBaseClone reCaculateRecordHash:_sourceContactImageRecord backupFolderPath:_sourceBackuppath];
        [IMBBaseClone saveMBDB:_sourcerecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceManifest.mbdb"] backupFolderPath:_sourceBackuppath];
    }
    if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
        [self modifyHashMajorEqualTen:_targetManifestDBConnection SqlitePath:_targetSqlitePath record:targetRecord];
        [self modifyHashMajorEqualTen:_targetManifestDBConnection SqlitePath:_targetSqliteContactImagePath record:_targetContactImageRecord];
    }else{
        [IMBBaseClone reCaculateRecordHash:targetRecord backupFolderPath:_targetBakcuppath];
        [IMBBaseClone reCaculateRecordHash:_targetContactImageRecord backupFolderPath:_targetBakcuppath];
        [IMBBaseClone saveMBDB:_targetrecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetManifest.mbdb"] backupFolderPath:_targetBakcuppath];
    }
}


- (void)deleteAllData
{
    NSString *sql1 = @"delete from ABAccount";
    NSString *sql2 = @"delete from ABGroup";
    NSString *sql3 = @"delete from ABGroupChanges";
    NSString *sql4 = @"delete from ABGroupMembers";
    NSString *sql5 = @"delete from ABMultiValue";
    NSString *sql6 = @"delete from ABMultiValueEntry";
    NSString *sql7 = @"delete from ABMultiValueEntryKey";
    NSString *sql8 = @"delete from ABMultiValueLabel";
    NSString *sql9 = @"delete from ABPerson";
    NSString *sql11 = @"delete from ABPersonChanges";
    NSString *sql12 = @"delete from ABPersonLink";
    NSString *sql13 = @"delete from ABPersonMultiValueDeletes";
    NSString *sql14 = @"delete from ABPersonSearchKey";
    if ([_targetFloatVersion isVersionLess:@"10"]) {
        NSString *sql17 = @"delete from ABRecent";
        NSString *sql10 = @"delete from ABPersonBasicChanges";
        [_targetDBConnection executeUpdate:sql10];
        [_targetDBConnection executeUpdate:sql17];
    }
    NSString *sql18 = @"delete from ABStore";
    NSString *sql19 = @"delete from ABPersonFullTextSearch_content";
    NSString *sql20 = @"delete from ABPersonFullTextSearch_docsize";
    NSString *sql21 = @"delete from ABPhoneLastFour";
    [_targetDBConnection executeUpdate:sql1];
    [_targetDBConnection executeUpdate:sql2];
    [_targetDBConnection executeUpdate:sql3];
    [_targetDBConnection executeUpdate:sql4];
    [_targetDBConnection executeUpdate:sql5];
    [_targetDBConnection executeUpdate:sql6];
    [_targetDBConnection executeUpdate:sql7];
    [_targetDBConnection executeUpdate:sql8];
    [_targetDBConnection executeUpdate:sql9];
    [_targetDBConnection executeUpdate:sql11];
    [_targetDBConnection executeUpdate:sql12];
    [_targetDBConnection executeUpdate:sql13];
    [_targetDBConnection executeUpdate:sql14];
    [_targetDBConnection executeUpdate:sql18];
    [_targetDBConnection executeUpdate:sql19];
    [_targetDBConnection executeUpdate:sql20];
    [_targetDBConnection executeUpdate:sql21];
}

//表ABAccount
- (void)insertABAccount
{    [_logHandle writeInfoLog:@"insert Contacts table ABAccount enter"];
    NSString *sql1 = @"select * from ABAccount";
    NSString *sql2 = @"insert into ABAccount(ROWID,AccountIdentifier,Flags,DefaultSourceID) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int ROWID = [rs intForColumn:@"ROWID"];
        NSString *AccountIdentifier = [rs stringForColumn:@"AccountIdentifier"];
        int Flags  = [rs intForColumn:@"Flags"];
        int DefaultSourceID = [rs intForColumn:@"DefaultSourceID"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],AccountIdentifier,[NSNumber numberWithInt:Flags],[NSNumber numberWithInt:DefaultSourceID]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABAccount exit"];
    
}

//将高版本的数据插入到低版本的数据库中 表ABGroup
- (void)insertABGroup
{   [_logHandle writeInfoLog:@"insert Contacts table ABGroup enter"];
    NSString *sql1 = @"select * from ABGroup";
    NSString *sql2 = @"insert into ABGroup(ROWID,Name,ExternalIdentifier,StoreID,ExternalModificationTag,ExternalRepresentation,ExternalUUID) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int ROWID = [rs intForColumn:@"ROWID"];
        NSString *Name = [rs stringForColumn:@"Name"];
        NSString *ExternalIdentifier  = [rs stringForColumn:@"ExternalIdentifier"];
        int  StoreID = [rs intForColumn:@"StoreID"];
        NSString *ExternalModificationTag  = [rs stringForColumn:@"ExternalModificationTag"];
        NSData *ExternalRepresentation = [rs dataForColumn:@"ExternalRepresentation"];
        NSString *ExternalUUID = [rs stringForColumn:@"ExternalUUID"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],Name,ExternalIdentifier,[NSNumber numberWithInt:StoreID],ExternalModificationTag,ExternalRepresentation,ExternalUUID];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABGroup exit"];
}

//表ABGroupChanges
- (void)insertABGroupChanges
{   [_logHandle writeInfoLog:@"insert Contacts table ABGroupChanges enter"];
    NSString *sql1 = @"select * from ABGroupChanges";
    NSString *sql2 = @"insert into ABGroupChanges(record,type,ExternalIdentifier,StoreID) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int record = [rs intForColumn:@"record"];
        int type = [rs intForColumn:@"type"];
        NSString *ExternalIdentifier  = [rs stringForColumn:@"ExternalIdentifier"];
        int StoreID = [rs intForColumn:@"StoreID"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],ExternalIdentifier,[NSNumber numberWithInt:StoreID]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABGroupChanges exit"];
    
}

//表ABGroupMembers
- (void)insertABGroupMembers
{    [_logHandle writeInfoLog:@"insert Contacts table ABGroupMembers enter"];
    NSString *sql1 = @"select * from ABGroupMembers";
    NSString *sql2 = @"insert into ABGroupMembers(UID,group_id,member_type,member_id) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int UID = [rs intForColumn:@"UID"];
        int group_id = [rs intForColumn:@"group_id"];
        int member_type  = [rs intForColumn:@"member_type"];
        int member_id = [rs intForColumn:@"member_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:UID],[NSNumber numberWithInt:group_id],[NSNumber numberWithInt:member_type],[NSNumber numberWithInt:member_id]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABGroupMembers exit"];
    
}
//表ABMultiValue
- (void)insertABMultiValueWithiOS7
{
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValue iOS7 enter"];
    NSString *sql1 = @"select * from ABMultiValue";
    NSString *sql2 = @"insert into ABMultiValue(UID,record_id,property,identifier,label,value,guid) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int UID = [rs intForColumn:@"UID"];
        int record_id = [rs intForColumn:@"record_id"];
        int property  = [rs intForColumn:@"property"];
        int identifier = [rs intForColumn:@"identifier"];
        int label  = [rs intForColumn:@"label"];
        NSString *value = [rs stringForColumn:@"value"];
        NSString *guid = [rs stringForColumn:@"guid"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:UID],[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value,guid];
        
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValue iOS7 exit"];
}

- (void)insertABMultiValueWithiOS6
{
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValue iOS6 enter"];
    NSString *sql1 = @"select * from ABMultiValue";
    NSString *sql2 = @"insert into ABMultiValue(UID,record_id,property,identifier,label,value) values(?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int UID = [rs intForColumn:@"UID"];
        int record_id = [rs intForColumn:@"record_id"];
        int property  = [rs intForColumn:@"property"];
        int identifier = [rs intForColumn:@"identifier"];
        int label  = [rs intForColumn:@"label"];
        NSString *value = [rs stringForColumn:@"value"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:UID],[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property],[NSNumber numberWithInt:identifier],[NSNumber numberWithInt:label],value];
        
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValue iOS6 exit"];
}

//表ABMultiValueEntry
- (void)insertABMultiValueEntry
{
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValueEntry enter"];
    NSString *sql1 = @"select * from ABMultiValueEntry";
    NSString *sql2 = @"insert into ABMultiValueEntry(parent_id,key,value) values(?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int parent_id = [rs intForColumn:@"parent_id"];
        int key = [rs intForColumn:@"key"];
        NSString *value  = [rs stringForColumn:@"value"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:parent_id],[NSNumber numberWithInt:key],value];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValueEntry exit"];
}

//表ABMultiValueEntryKey
- (void)insertABMultiValueEntryKey
{
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValueEntryKey enter"];
    NSString *sql1 = @"select * from ABMultiValueEntryKey order by rowid asc";
    NSString *sql2 = @"insert into ABMultiValueEntryKey(value) values(?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        
        NSString *value  = [rs stringForColumn:@"value"];
        [_targetDBConnection executeUpdate:sql2,value];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValueEntryKey exit"];
}

//表ABMultiValueLabel
- (void)insertABMultiValueLabel
{   [_logHandle writeInfoLog:@"insert Contacts table ABMultiValueLabel enter"];
    NSString *sql1 = @"select * from ABMultiValueLabel order by  rowid asc";
    NSString *sql2 = @"insert into ABMultiValueLabel(value) values(?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSString *value  = [rs stringForColumn:@"value"];
        [_targetDBConnection executeUpdate:sql2,value];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABMultiValueLabel exit"];
}
//表ABPerson
- (void)insertABPersonWithiOS7
{
    //last_insert_rowid()
    [_logHandle writeInfoLog:@"insert Contacts table ABPerson iOS7 enter"];
    NSString *sql1 = @"select * from ABPerson";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    NSString *sql2 = @"INSERT INTO ABPerson (ROWID,Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CreationDate,ModificationDate,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName,guid,PhonemeData) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    while ([rs next]) {
        int rowid = [rs intForColumn:@"ROWID"];
        NSString *birthday = [rs stringForColumn:@"Birthday"];
        NSString *firstname = [rs stringForColumn:@"First"];
        NSString *lastname  = [rs stringForColumn:@"Last"];
        NSString *middlename = [rs stringForColumn:@"Middle"];
        NSString *firstnameyomi = [rs stringForColumn:@"FirstPhonetic"];
        NSString *lastnameyomi = [rs stringForColumn:@"LastPhonetic"];
        NSString *middlePhonetic = [rs stringForColumn:@"MiddlePhonetic"];
        NSString *organization  = [rs stringForColumn:@"Organization"];
        NSString *department = [rs stringForColumn:@"Department"];
        NSString *note  = [rs stringForColumn:@"Note"];
        int kind = [rs intForColumn:@"Kind"];
        NSString *jobTitle = [rs stringForColumn:@"JobTitle"];
        NSString *nickname = [rs stringForColumn:@"Nickname"];
        NSString *suffix  = [rs stringForColumn:@"Suffix"];
        NSString *prefix = [rs stringForColumn:@"Prefix"];
        NSString *firstSort = [rs stringForColumn:@"FirstSort"];
        NSString *lastSort = [rs stringForColumn:@"LastSort"];
        int creationDate = [rs intForColumn:@"CreationDate"];
        int modificationDate = [rs intForColumn:@"ModificationDate"];
        NSString *CompositeNameFallback = [rs stringForColumn:@"CompositeNameFallback"];
        NSString *ExternalIdentifier = [rs stringForColumn:@"ExternalIdentifier"];
        NSString *ExternalModificationTag = [rs stringForColumn:@"ExternalModificationTag"];
        NSString *ExternalUUID = [rs stringForColumn:@"ExternalUUID"];
        int StoreID = [rs intForColumn:@"StoreID"];
        NSString *DisplayName = [rs stringForColumn:@"DisplayName"];
        NSData *ExternalRepresentation = [rs dataForColumn:@"ExternalRepresentation"];
        NSString *FirstSortSection = [rs stringForColumn:@"FirstSortSection"];
        NSString *LastSortSection = [rs stringForColumn:@"LastSortSection"];
        int FirstSortLanguageIndex = [rs intForColumn:@"FirstSortLanguageIndex"];
        int LastSortLanguageIndex = [rs intForColumn:@"LastSortLanguageIndex"];
        int PersonLink = [rs intForColumn:@"PersonLink"];
        NSString *ImageURI = [rs stringForColumn:@"ImageURI"];
        int IsPreferredName = [rs intForColumn:@"IsPreferredName"];
        NSString *guid = [rs stringForColumn:@"guid"];
        NSString *PhonemeData = [rs stringForColumn:@"PhonemeData"];
        if ([_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:rowid],birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,[NSNumber numberWithInt:creationDate],[NSNumber numberWithInt:modificationDate],CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName],guid,PhonemeData]) {
        }
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABPerson iOS7 exit"];
}

- (void)insertABPersonWithiOS6
{
    //last_insert_rowid()
    [_logHandle writeInfoLog:@"insert Contacts table ABPerson iOS6 enter"];
    NSString *sql1 = @"select * from ABPerson";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    NSString *sql2 = nil;
    if (_sourceVersion<=_targetVersion) {
        if (_targetVersion>=7) {
            sql2 = @"INSERT INTO ABPerson (ROWID,Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CreationDate,ModificationDate,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName,guid) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        }else
        {
            sql2 = @"INSERT INTO ABPerson (ROWID,Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CreationDate,ModificationDate,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        }
        
        
    }else
    {
        sql2 = @"INSERT INTO ABPerson (ROWID,Birthday,First,Last,Middle,FirstPhonetic,LastPhonetic,MiddlePhonetic,Organization,Department,Note,Kind,JobTitle,Nickname,Suffix,Prefix,FirstSort,LastSort,CreationDate,ModificationDate,CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,StoreID,DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,FirstSortLanguageIndex,LastSortLanguageIndex,PersonLink,ImageURI,IsPreferredName) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    
    while ([rs next]) {
        int rowid = [rs intForColumn:@"ROWID"];
        NSString *birthday = [rs stringForColumn:@"Birthday"];
        NSString *firstname = [rs stringForColumn:@"First"];
        NSString *lastname  = [rs stringForColumn:@"Last"];
        NSString *middlename = [rs stringForColumn:@"Middle"];
        NSString *firstnameyomi = [rs stringForColumn:@"FirstPhonetic"];
        NSString *lastnameyomi = [rs stringForColumn:@"LastPhonetic"];
        NSString *middlePhonetic = [rs stringForColumn:@"MiddlePhonetic"];
        NSString *organization  = [rs stringForColumn:@"Organization"];
        NSString *department = [rs stringForColumn:@"Department"];
        NSString *note  = [rs stringForColumn:@"Note"];
        int kind = [rs intForColumn:@"Kind"];
        NSString *jobTitle = [rs stringForColumn:@"JobTitle"];
        NSString *nickname = [rs stringForColumn:@"Nickname"];
        NSString *suffix  = [rs stringForColumn:@"Suffix"];
        NSString *prefix = [rs stringForColumn:@"Prefix"];
        NSString *firstSort = [rs stringForColumn:@"FirstSort"];
        NSString *lastSort = [rs stringForColumn:@"LastSort"];
        int creationDate = [rs intForColumn:@"CreationDate"];
        int modificationDate = [rs intForColumn:@"ModificationDate"];
        NSString *CompositeNameFallback = [rs stringForColumn:@"CompositeNameFallback"];
        NSString *ExternalIdentifier = [rs stringForColumn:@"ExternalIdentifier"];
        NSString *ExternalModificationTag = [rs stringForColumn:@"ExternalModificationTag"];
        NSString *ExternalUUID = [rs stringForColumn:@"ExternalUUID"];
        int StoreID = [rs intForColumn:@"StoreID"];
        NSString *DisplayName = [rs stringForColumn:@"DisplayName"];
        NSData *ExternalRepresentation = [rs dataForColumn:@"ExternalRepresentation"];
        NSString *FirstSortSection = [rs stringForColumn:@"FirstSortSection"];
        NSString *LastSortSection = [rs stringForColumn:@"LastSortSection"];
        int FirstSortLanguageIndex = [rs intForColumn:@"FirstSortLanguageIndex"];
        int LastSortLanguageIndex = [rs intForColumn:@"LastSortLanguageIndex"];
        int PersonLink = [rs intForColumn:@"PersonLink"];
        NSString *ImageURI = [rs stringForColumn:@"ImageURI"];
        int IsPreferredName = [rs intForColumn:@"IsPreferredName"];
        if (_sourceVersion<=_targetVersion) {
            if (_targetVersion>=7) {
                [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:rowid],birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,[NSNumber numberWithInt:creationDate],[NSNumber numberWithInt:modificationDate],CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName],[self createGUID]];
            }else
            {
                [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:rowid],birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,[NSNumber numberWithInt:creationDate],[NSNumber numberWithInt:modificationDate],CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName]];
            }
        }else
        {
            [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:rowid],birthday,firstname,lastname,middlename,firstnameyomi,lastnameyomi,middlePhonetic,organization,department,note,[NSNumber numberWithInt:kind],jobTitle,nickname,suffix,prefix,firstSort,lastSort,[NSNumber numberWithInt:creationDate],[NSNumber numberWithInt:modificationDate],CompositeNameFallback,ExternalIdentifier,ExternalModificationTag,ExternalUUID,[NSNumber numberWithInt:StoreID],DisplayName,ExternalRepresentation,FirstSortSection,LastSortSection,[NSNumber numberWithInt:FirstSortLanguageIndex],[NSNumber numberWithInt:LastSortLanguageIndex],[NSNumber numberWithInt:PersonLink],ImageURI,[NSNumber numberWithInt:IsPreferredName]];
        }
        
        
        
        
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABPerson iOS6 exit"];
}



//表ABPersonBasicChanges
- (void)insertABPersonBasicChanges
{
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonBasicChanges enter"];
    NSString *sql1 = @"select * from ABPersonBasicChanges";
    NSString *sql2 = @"insert into ABPersonBasicChanges(record,type,sequenceNumber) values(?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int record = [rs intForColumn:@"record"];
        int type = [rs intForColumn:@"type"];
        int sequenceNumber  = [rs intForColumn:@"sequenceNumber"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:sequenceNumber]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonBasicChanges exit"];
}
//表ABPersonChanges
- (void)insertABPersonChanges
{
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonChanges enter"];
    NSString *sql1 = @"select * from ABPersonChanges";
    NSString *sql2 = @"insert into ABPersonChanges(record,type,Image,ExternalIdentifier,StoreID) values(?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int record = [rs intForColumn:@"record"];
        int type = [rs intForColumn:@"type"];
        int Image  = [rs intForColumn:@"Image"];
        NSString *ExternalIdentifier = [rs stringForColumn:@"ExternalIdentifier"];
        int StoreID  = [rs intForColumn:@"StoreID"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:Image],ExternalIdentifier,[NSNumber numberWithInt:StoreID]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonChanges exit"];
}

//表ABPersonFullTextSearch_content
- (void)insertABPersonFullTextSearch_content
{
    NSString *sql1 = @"select * from ABPersonFullTextSearch_content";
    NSString *sql2 = nil;
    if ([_targetFloatVersion isVersionLessEqual:@"10.1"]) {
        sql2 = @"insert into ABPersonFullTextSearch_content(docid,c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c7Department,c8Note,c9Birthday,c10JobTitle,c11Nickname,c12Prefix,c13Suffix,c14DisplayName,c15Phone,c16Email,c17Address,c18SocialProfile,c19URL,c20RelatedNames,c21IM,c22Date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else if ([_targetFloatVersion isVersionMajorEqual:@"10.2"]){
        sql2 = @"insert into ABPersonFullTextSearch_content(docid,c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c7OrganizationPhonetic,c8Department,c9Note,c10Birthday,c11JobTitle,c12Nickname,c13Prefix,c14Suffix,c15DisplayName,c16Phone,c17Email,c18Address,c19SocialProfile,c20URL,c21RelatedNames,c22IM,c23Date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int docid = [rs intForColumn:@"docid"];
        if ([_sourceFloatVersion isVersionLessEqual:@"10.1"]) {
            NSString *c0First = [rs stringForColumn:@"c0First"];
            NSString *c1Last = [rs stringForColumn:@"c1Last"];
            NSString *c2Middle = [rs stringForColumn:@"c2Middle"];
            NSString *c3FirstPhonetic = [rs stringForColumn:@"c3FirstPhonetic"];
            NSString *c4MiddlePhonetic = [rs stringForColumn:@"c4MiddlePhonetic"];
            NSString *c5LastPhonetic = [rs stringForColumn:@"c5LastPhonetic"];
            NSString *c6Organization = [rs stringForColumn:@"c6Organization"];
            NSString *c7Department = [rs stringForColumn:@"c7Department"];
            NSString *c8Note = [rs stringForColumn:@"c8Note"];
            NSString *c9Birthday = [rs stringForColumn:@"c9Birthday"];
            NSString *c10JobTitle = [rs stringForColumn:@"c10JobTitle"];
            NSString *c11Nickname = [rs stringForColumn:@"c11Nickname"];
            NSString *c12Prefix = [rs stringForColumn:@"c12Prefix"];
            NSString *c13Suffix = [rs stringForColumn:@"c13Suffix"];
            NSString *c14DisplayName = [rs stringForColumn:@"c14DisplayName"];
            NSString *c15Phone = [rs stringForColumn:@"c15Phone"];
            NSString *c16Email = [rs stringForColumn:@"c16Email"];
            NSString *c17Address = [rs stringForColumn:@"c17Address"];
            NSString *c18SocialProfile = [rs stringForColumn:@"c18SocialProfile"];
            NSString *c19URL = [rs stringForColumn:@"c19URL"];
            NSString *c20RelatedNames = [rs stringForColumn:@"c20RelatedNames"];
            NSString *c21IM = [rs stringForColumn:@"c21IM"];
            NSString *c22Date = [rs stringForColumn:@"c22Date"];
            if ([_targetFloatVersion isVersionLessEqual:@"10.1"]) {
                [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c7Department,c8Note,c9Birthday,c10JobTitle,c11Nickname,c12Prefix,c13Suffix,c14DisplayName,c15Phone,c16Email,c17Address,c18SocialProfile,c19URL,c20RelatedNames,c21IM,c22Date];
            }else if ([_targetFloatVersion isVersionMajorEqual:@"10.2"]){
                [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,[NSNull null],c7Department,c8Note,c9Birthday,c10JobTitle,c11Nickname,c12Prefix,c13Suffix,c14DisplayName,c15Phone,c16Email,c17Address,c18SocialProfile,c19URL,c20RelatedNames,c21IM,c22Date];
            }
        }else if ([_sourceFloatVersion isVersionMajorEqual:@"10.2"]){
            NSString *c0First = [rs stringForColumn:@"c0First"];
            NSString *c1Last = [rs stringForColumn:@"c1Last"];
            NSString *c2Middle = [rs stringForColumn:@"c2Middle"];
            NSString *c3FirstPhonetic = [rs stringForColumn:@"c3FirstPhonetic"];
            NSString *c4MiddlePhonetic = [rs stringForColumn:@"c4MiddlePhonetic"];
            NSString *c5LastPhonetic = [rs stringForColumn:@"c5LastPhonetic"];
            NSString *c6Organization = [rs stringForColumn:@"c6Organization"];
            NSString *c7OrganizationPhonetic = [rs stringForColumn:@"c7OrganizationPhonetic"];
            NSString *c8Department = [rs stringForColumn:@"c8Department"];
            NSString *c9Note = [rs stringForColumn:@"c9Note"];
            NSString *c10Birthday = [rs stringForColumn:@"c10Birthday"];
            NSString *c11JobTitle = [rs stringForColumn:@"c11JobTitle"];
            NSString *c12Nickname = [rs stringForColumn:@"c12Nickname"];
            NSString *c13Prefix = [rs stringForColumn:@"c13Prefix"];
            NSString *c14Suffix = [rs stringForColumn:@"c14Suffix"];
            NSString *c15DisplayName = [rs stringForColumn:@"c15DisplayName"];
            NSString *c16Phone = [rs stringForColumn:@"c16Phone"];
            NSString *c17Email = [rs stringForColumn:@"c17Email"];
            NSString *c18Address = [rs stringForColumn:@"c18Address"];
            NSString *c19SocialProfile = [rs stringForColumn:@"c19SocialProfile"];
            NSString *c20URL = [rs stringForColumn:@"c20URL"];
            NSString *c21RelatedNames = [rs stringForColumn:@"c21RelatedNames"];
            NSString *c22IM = [rs stringForColumn:@"c22IM"];
            NSString *c23Date = [rs stringForColumn:@"c23Date"];
            if ([_targetFloatVersion isVersionLessEqual:@"10.1"]) {
                [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c8Department,c9Note,c10Birthday,c11JobTitle,c12Nickname,c13Prefix,c14Suffix,c15DisplayName,c16Phone,c17Email,c18Address,c19SocialProfile,c20URL,c21RelatedNames,c22IM,c23Date];
            }else if ([_targetFloatVersion isVersionMajorEqual:@"10.2"]){
                [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],c0First,c1Last,c2Middle,c3FirstPhonetic,c4MiddlePhonetic,c5LastPhonetic,c6Organization,c7OrganizationPhonetic,c8Department,c9Note,c10Birthday,c11JobTitle,c12Nickname,c13Prefix,c14Suffix,c15DisplayName,c16Phone,c17Email,c18Address,c19SocialProfile,c20URL,c21RelatedNames,c22IM,c23Date];
            }

        }
    }
    [rs close];
}

//表ABPersonFullTextSearch_docsize
- (void)insertABPersonFullTextSearch_docsize
{
    NSString *sql1 = @"select * from ABPersonFullTextSearch_docsize";
    NSString *sql2 = @"insert into ABPersonFullTextSearch_docsize(docid,size) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int docid = [rs intForColumn:@"docid"];
        NSData *size = [rs dataForColumn:@"size"];
        
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:docid],size];
    }
    [rs close];
}

//表ABPersonFullTextSearch_segdir
- (void)insertABPersonFullTextSearch_segdir
{
    NSString *sql1 = @"select * from ABPersonFullTextSearch_segdir";
    NSString *sql2 = @"insert into ABPersonFullTextSearch_segdir(level,idx,start_block,leaves_end_block,end_block,root) values(?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int level = [rs intForColumn:@"level"];
        int idx = [rs intForColumn:@"idx"];
        int start_block = [rs intForColumn:@"start_block"];
        int leaves_end_block = [rs intForColumn:@"leaves_end_block"];
        int end_block = [rs intForColumn:@"end_block"];
        NSData *root = [rs dataForColumn:@"root"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:level],[NSNumber numberWithInt:idx],[NSNumber numberWithInt:start_block],[NSNumber numberWithInt:leaves_end_block],[NSNumber numberWithInt:end_block],root];
    }
    [rs close];
}

//表ABPersonFullTextSearch_segments
- (void)insertABPersonFullTextSearch_segments
{
    NSString *sql1 = @"select * from ABPersonFullTextSearch_segments";
    NSString *sql2 = @"insert into ABPersonFullTextSearch_segments(blockid,block) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int blockid = [rs intForColumn:@"blockid"];
        NSData *block = [rs dataForColumn:@"block"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:blockid],block];
    }
    [rs close];
}

//表ABPersonFullTextSearch_stat
- (void)insertABPersonFullTextSearch_stat
{
    NSString *sql1 = @"select * from ABPersonFullTextSearch_stat";
    NSString *sql2 = @"insert into ABPersonFullTextSearch_stat(id,value) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int nid = [rs intForColumn:@"id"];
        NSData *value = [rs dataForColumn:@"value"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:nid],value];
    }
    [rs close];
}

//表ABPersonLink
- (void)insertABPersonLink
{
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonLink enter"];
    NSString *sql1 = @"select * from ABPersonLink";
    NSString *sql2 = @"insert into ABPersonLink(ROWID,PreferredImagePersonID,PreferredNamePersonID) values(?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int ROWID = [rs intForColumn:@"ROWID"];
        int PreferredImagePersonID = [rs intForColumn:@"PreferredImagePersonID"];
        int PreferredNamePersonID  = [rs intForColumn:@"PreferredNamePersonID"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:PreferredImagePersonID],[NSNumber numberWithInt:PreferredNamePersonID]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonLink exit"];
}

//表ABPersonMultiValueDeletes
- (void)insertABPersonMultiValueDeletes
{
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonMultiValueDeletes enter"];
    NSString *sql1 = @"select * from ABPersonMultiValueDeletes";
    NSString *sql2 = @"insert into ABPersonMultiValueDeletes(record_id,property_id,identifier) values(?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int record_id = [rs intForColumn:@"record_id"];
        int property_id = [rs intForColumn:@"property_id"];
        int identifier  = [rs intForColumn:@"identifier"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:property_id],[NSNumber numberWithInt:identifier]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonMultiValueDeletes exit"];
}

//表ABPersonSearchKey
- (void)insertABPersonSearchKey
{
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonSearchKey enter"];
    NSString *sql1 = @"select * from ABPersonSearchKey";
    NSString *sql2 = @"insert into ABPersonSearchKey(person_id,SearchKey,NameOnlySearchKey) values(?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int person_id = [rs intForColumn:@"person_id"];
        NSData *SearchKey = [rs dataForColumn:@"SearchKey"];
        NSData *NameOnlySearchKey  = [rs dataForColumn:@"NameOnlySearchKey"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:person_id],SearchKey,NameOnlySearchKey];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABPersonSearchKey exit"];
}
//表ABPhoneLastFour
- (void)insertABPhoneLastFour
{
    [_logHandle writeInfoLog:@"insert Contacts table ABPhoneLastFour enter"];
    NSString *sql1 = @"select * from ABPhoneLastFour";
    NSString *sql2 = @"insert into ABPhoneLastFour(multivalue_id,value) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int multivalue_id = [rs intForColumn:@"multivalue_id"];
        NSString *value = [rs stringForColumn:@"value"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:multivalue_id],value];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABPhoneLastFour exit"];
}

//表ABRecent
- (void)insertABRecent
{
    [_logHandle writeInfoLog:@"insert Contacts table ABRecent enter"];
    NSString *sql1 = @"select * from ABRecent";
    NSString *sql2 = @"insert into ABRecent(date,name,property,value) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int date = [rs intForColumn:@"date"];
        NSString *name = [rs stringForColumn:@"name"];
        int property  = [rs intForColumn:@"property"];
        NSString *value  = [rs stringForColumn:@"value"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:date],name,[NSNumber numberWithInt:property],value];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABRecent exit"];
}

//表ABStore
- (void)insertABStore
{
    [_logHandle writeInfoLog:@"insert Contacts table ABStore enter"];
    NSString *sql1 = @"select * from ABStore";
    NSString *sql2 = @"insert into ABStore(ROWID,Name,ExternalIdentifier,Type,ConstraintsPath,ExternalModificationTag,ExternalSyncTag,StoreInternalIdentifier,AccountID,Enabled,SyncData,MeIdentifier) values(?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int ROWID = [rs intForColumn:@"ROWID"];
        NSString *Name = [rs stringForColumn:@"Name"];
        NSString *ExternalIdentifier  = [rs stringForColumn:@"ExternalIdentifier"];
        int Type  = [rs intForColumn:@"Type"];
        NSString *ConstraintsPath = [rs stringForColumn:@"ConstraintsPath"];
        NSString *ExternalModificationTag = [rs stringForColumn:@"ExternalModificationTag"];
        NSString *ExternalSyncTag  = [rs stringForColumn:@"ExternalSyncTag"];
        NSString *StoreInternalIdentifier  = [rs stringForColumn:@"StoreInternalIdentifier"];
        int AccountID = [rs intForColumn:@"AccountID"];
        int Enabled = [rs intForColumn:@"Enabled"];
        NSData *SyncData  = [rs dataForColumn:@"SyncData"];
        int MeIdentifier  = [rs intForColumn:@"MeIdentifier"];
        //int Capabilities  = [rs intForColumn:@"Capabilities"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],Name,ExternalIdentifier,[NSNumber numberWithInt:Type],ConstraintsPath,ExternalModificationTag,ExternalSyncTag,StoreInternalIdentifier,[NSNumber numberWithInt:AccountID],[NSNumber numberWithInt:Enabled],SyncData,[NSNumber numberWithInt:MeIdentifier]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABStore exit"];
}

//表FirstSortSectionCount
- (void)insertFirstSortSectionCount
{
    NSString *sql1 = @"select * from FirstSortSectionCount";
    NSString *sql2 = @"insert into FirstSortSectionCount(LanguageIndex,Section,StoreID,number) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int LanguageIndex = [rs intForColumn:@"LanguageIndex"];
        NSString *Section = [rs stringForColumn:@"Section"];
        int StoreID  = [rs intForColumn:@"StoreID"];
        int number  = [rs intForColumn:@"number"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:LanguageIndex],Section,[NSNumber numberWithInt:StoreID],[NSNumber numberWithInt:number]];
    }
    [rs close];
}
//表FirstSortSectionCountTotal
- (void)insertFirstSortSectionCountTotal
{
    NSString *sql1 = @"select * from FirstSortSectionCountTotal";
    NSString *sql2 = @"insert into FirstSortSectionCountTotal(LanguageIndex,Section,Type,number) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int LanguageIndex = [rs intForColumn:@"LanguageIndex"];
        NSString *Section = [rs stringForColumn:@"Section"];
        int Type  = [rs intForColumn:@"Type"];
        int number  = [rs intForColumn:@"number"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:LanguageIndex],Section,[NSNumber numberWithInt:Type],[NSNumber numberWithInt:number]];
    }
    [rs close];
}

//表LastSortSectionCount
- (void)insertLastSortSectionCount{
    NSString *sql1 = @"select * from LastSortSectionCount";
    NSString *sql2 = @"insert into LastSortSectionCount(LanguageIndex,Section,StoreID,number) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int LanguageIndex = [rs intForColumn:@"LanguageIndex"];
        NSString *Section = [rs stringForColumn:@"Section"];
        int StoreID  = [rs intForColumn:@"StoreID"];
        int number  = [rs intForColumn:@"number"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:LanguageIndex],Section,[NSNumber numberWithInt:StoreID],[NSNumber numberWithInt:number]];
    }
    [rs close];
}

//表LastSortSectionCountTotal
- (void)insertLastSortSectionCountTotal
{
    NSString *sql1 = @"select * from LastSortSectionCountTotal";
    NSString *sql2 = @"insert into LastSortSectionCountTotal(LanguageIndex,Section,Type,number) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        int LanguageIndex = [rs intForColumn:@"LanguageIndex"];
        NSString *Section = [rs stringForColumn:@"Section"];
        int Type  = [rs intForColumn:@"Type"];
        int number  = [rs intForColumn:@"number"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:LanguageIndex],Section,[NSNumber numberWithInt:Type],[NSNumber numberWithInt:number]];
    }
    [rs close];
}

//表_SqliteDatabaseProperties
- (void)insert_SqliteDatabaseProperties
{
    NSString *sql1 = @"select * from _SqliteDatabaseProperties";
    NSString *sql2 = @"insert into _SqliteDatabaseProperties(key,value) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSString *key = [rs stringForColumn:@"key"];
        NSString *value = [rs stringForColumn:@"value"];
        
        [_targetDBConnection executeUpdate:sql2,key,value];
    }
    [rs close];
}

//表sqlite_sequence
- (void)insertsqlite_sequence
{
    NSString *sql1 = @"select * from sqlite_sequence";
    NSString *sql2 = @"insert into sqlite_sequence(name,seq) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"name"];
        int seq = [rs intForColumn:@"seq"];
        
        [_targetDBConnection executeUpdate:sql2,name,seq];
    }
    [rs close];
}
//联系人头像数据库
//表ABFullSizeImage
- (void)insertABFullSizeImage
{
    [_logHandle writeInfoLog:@"insert Contacts table ABFullSizeImage enter"];
    NSString *sql1 = @"select * from ABFullSizeImage";
    NSString *sql2 = @"insert into ABFullSizeImage(ROWID,record_id,crop_x,crop_y,crop_width,data) values(?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceImageDBConnection executeQuery:sql1];
    while ([rs next]) {
        
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger record_id = [rs intForColumn:@"record_id"];
        NSInteger crop_x = [rs intForColumn:@"crop_x"];
        NSInteger crop_y = [rs intForColumn:@"crop_y"];
        NSInteger crop_width = [rs intForColumn:@"crop_width"];
        NSData *data = [rs dataForColumn:@"data"];
        
        [_targetImageDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:crop_x],[NSNumber numberWithInt:crop_y],[NSNumber numberWithInt:crop_width],data];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABFullSizeImage exit"];
    
}

//联系人头像数据库
//表ABThumbnailImage
- (void)insertABThumbnailImage
{
    [_logHandle writeInfoLog:@"insert Contacts table ABThumbnailImage enter"];
    NSString *sql1 = @"select * from ABThumbnailImage";
    NSString *sql2 = @"insert into ABThumbnailImage(ROWID,record_id,format,derived_from_format,data) values(?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceImageDBConnection executeQuery:sql1];
    while ([rs next]) {
        
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger record_id = [rs intForColumn:@"record_id"];
        NSInteger format = [rs intForColumn:@"format"];
        NSInteger derived_from_format = [rs intForColumn:@"derived_from_format"];
        NSData *data = [rs dataForColumn:@"data"];
        
        [_targetImageDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:record_id],[NSNumber numberWithInt:format],[NSNumber numberWithInt:derived_from_format],data];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Contacts table ABThumbnailImage exit"];
    
}



@end

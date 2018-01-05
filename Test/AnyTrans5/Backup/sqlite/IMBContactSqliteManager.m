//
//  IMBContactSqliteManager.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBContactSqliteManager.h"
#import "IMBBackupManager.h"
#import "IMBAddressBookDataEntity.h"
#import "StringHelper.h"
@implementation IMBContactSqliteManager
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        _backUpPath = [backupfilePath retain];
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        if (isEncrypted) {
            [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/AddressBook"];
            manager.backUpPath = decypt.outputPath;
            if (_backUpPath != nil) {
                [_backUpPath release];
                _backUpPath = nil;
            }
            _backUpPath = [decypt.outputPath retain];
        }
        NSString *sqliteddPath = [manager copysqliteToApptempWithsqliteName:@"AddressBook.sqlitedb" backupfilePath:_backUpPath];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        
        NSString *sqlitImgDbPath = [manager copysqliteToApptempWithsqliteName:@"AddressBookImages.sqlitedb" backupfilePath:_backUpPath];
        if (sqlitImgDbPath != nil) {
            _databaseImgConnection = [[FMDatabase alloc] initWithPath:sqlitImgDbPath];
        }
    }
    return self;
}

- (id)initWithBackupfilePath:(NSString *)backupfilePath recordArray:(NSMutableArray *)recordArray{
    if (self = [super init]) {
        fm = [NSFileManager defaultManager];
        _logManger = [IMBLogManager singleton];
        _iOSVersion = [[IMBSqliteManager getBackupFileFloatVersion:backupfilePath] retain];
        _backUpPath = [backupfilePath retain];
        _dataAry = [[NSMutableArray alloc] init];
        NSString *sqliteddPath = [self copysqliteToApptempWithsqliteName:@"AddressBook.sqlitedb" backupfilePath:backupfilePath recordArray:recordArray];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        NSString *sqlitImgDbPath = [self copysqliteToApptempWithsqliteName:@"AddressBookImages.sqlitedb" backupfilePath:backupfilePath recordArray:recordArray];
        if (sqlitImgDbPath != nil) {
            _databaseImgConnection = [[FMDatabase alloc] initWithPath:sqlitImgDbPath];
        }

        
    }
    return self;
}


- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
            NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/AddressBook/AddressBook.sqlitedb"];
            if ([fm fileExistsAtPath:dbNPath]) {
                _databaseConnection = [[FMDatabase alloc] initWithPath:dbNPath];
            }
            
            NSString *dbNPath1 = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/AddressBook/AddressBookImages.sqlitedb"];
            if ([fm fileExistsAtPath:dbNPath]) {
               _databaseImgConnection = [[FMDatabase alloc] initWithPath:dbNPath1];
            }
        }else{
            //遍历需要的文件，然后拷贝到指定的目录下
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/AddressBook/AddressBook.sqlitedb"];
            NSArray *tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            IMBiCloudFileInfo *addressBook = nil;
            IMBiCloudFileInfo *addressBookImages = nil;
            if (tmpArray != nil && tmpArray.count > 0) {
                addressBook = [tmpArray objectAtIndex:0];
            }
            pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/AddressBook/AddressBookImages.sqlitedb"];
            tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            if (tmpArray != nil && tmpArray.count > 0) {
                addressBookImages = [tmpArray objectAtIndex:0];
            }
            if (addressBook != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (addressBook.fileName.length > 2) {
                        fd = [addressBook.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:addressBook.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:addressBook.fileName];
                }
                if (sourcefilePath != nil) {
                    _databaseConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }
            
            if (addressBookImages != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (addressBookImages.fileName.length > 2) {
                        fd = [addressBook.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:addressBookImages.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:addressBookImages.fileName];
                }
                if (sourcefilePath != nil) {
                    _databaseImgConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }

        }
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    if (_databaseImgConnection != nil) {
        [_databaseImgConnection release];
        _databaseImgConnection = nil;
    }
}

-(BOOL)openDbImageConnection{
    if ([_databaseImgConnection open]) {
        [_databaseImgConnection setShouldCacheStatements:NO];
        [_databaseImgConnection setTraceExecution:NO];
        return true;
    }
    return false;
}

-(void)closeDbImageConnection{
    [_databaseImgConnection close];
}


#pragma mark - 查询数据库方法
- (void)querySqliteDBContent {
    [_logManger writeInfoLog:@"query Contact From Sqlite Begin"];
    if ([self openDataBase]) {
        NSString *selectCmd = @"select ROWID,First,Last,Middle,FirstPhonetic,MiddlePhonetic,LastPhonetic,Organization,Department,Note,Kind,Birthday,JobTitle,Nickname,Prefix,Suffix,CreationDate,ModificationDate from ABPerson";
        FMResultSet *rs = [_databaseConnection executeQuery:selectCmd];
        IMBAddressBookDataEntity *addressBookItem = nil;
        while ([rs next]) {
            @autoreleasepool {
                addressBookItem = [[IMBAddressBookDataEntity alloc] init];
                [addressBookItem setCheckState:Check];
                int rowid = [rs intForColumn:@"ROWID"];
                int kind = [rs intForColumn:@"Kind"];
                long birthdayDate = [rs intForColumn:@"Birthday"];
                long createDate = [rs intForColumn:@"CreationDate"];
                long modidicationDate = [rs intForColumn:@"ModificationDate"];
                NSString *firstname = nil;
                if (![rs columnIsNull:@"First"]) {
                    firstname = [rs stringForColumn:@"First"];
                }else {
                    firstname = @"";
                }
                NSString *lastname = nil;
                if (![rs columnIsNull:@"Last"]) {
                    lastname = [rs stringForColumn:@"Last"];
                }else {
                    lastname = @"";
                }
                NSString *allname = nil;
                if (![firstname isEqualToString:@""]) {
                    allname = [[firstname stringByAppendingString:@" "] stringByAppendingString:lastname];
                }else {
                    allname = lastname;
                }
                
                if ([allname isEqualToString:@""]) {
                    allname = CustomLocalizedString(@"contact_id_48", nil);
                }
                NSString *middlename = nil;
                if (![rs columnIsNull:@"Middle"]) {
                    middlename = [rs stringForColumn:@"Middle"];
                }else {
                    middlename = @"";
                }
                
                NSString *firstnameyomi = nil;
                if (![rs columnIsNull:@"FirstPhonetic"]) {
                    firstnameyomi = [rs stringForColumn:@"FirstPhonetic"];
                }else {
                    firstnameyomi = @"";
                }
                NSString *lastnameyomi = nil;
                if (![rs columnIsNull:@"LastPhonetic"]) {
                    lastnameyomi = [rs stringForColumn:@"LastPhonetic"];
                }else {
                    lastnameyomi = @"";
                }
                NSString *middlenameyomi = nil;
                if (![rs columnIsNull:@"MiddlePhonetic"]) {
                    middlenameyomi = [rs stringForColumn:@"MiddlePhonetic"];
                }else {
                    middlenameyomi = @"";
                }
                NSString *companyname = nil;
                if (![rs columnIsNull:@"Organization"]) {
                    companyname = [rs stringForColumn:@"Organization"];
                }else {
                    companyname = @"";
                }
                NSString *department = nil;
                if (![rs columnIsNull:@"Department"]) {
                    department = [rs stringForColumn:@"Department"];
                }else {
                    department = @"";
                }
                NSString *note = nil;
                if (![rs columnIsNull:@"Note"]) {
                    note = [rs stringForColumn:@"Note"];
                }else {
                    note = @"";
                }
                NSString *jobTitle = nil;
                if (![rs columnIsNull:@"JobTitle"]) {
                    jobTitle = [rs stringForColumn:@"JobTitle"];
                }else {
                    jobTitle = @"";
                }
                NSString *nickname = nil;
                if (![rs columnIsNull:@"Nickname"]) {
                    nickname = [rs stringForColumn:@"Nickname"];
                }else {
                    nickname = @"";
                }
                NSString *prefix = nil;
                if (![rs columnIsNull:@"Prefix"]) {
                    prefix = [rs stringForColumn:@"Prefix"];
                }else {
                    prefix = @"";
                }
                NSString *suffix = nil;
                if (![rs columnIsNull:@"Suffix"]) {
                    suffix = [rs stringForColumn:@"Suffix"];
                }else {
                    suffix = @"";
                }
                
                [addressBookItem setCheckState:UnChecked];
                [addressBookItem setAllName:allname];
                [addressBookItem setSortStr:[StringHelper getStringFirstWord:addressBookItem.allName]];
                [addressBookItem setRowid:rowid];
                [addressBookItem setKind:kind];
                [addressBookItem setBirthdayDate:birthdayDate];
                [addressBookItem setCreationDate:createDate];
                [addressBookItem setModificationDate:modidicationDate];
                [addressBookItem setFirstName:firstname];
                [addressBookItem setLastName:lastname];
                [addressBookItem setMiddleName:middlename];
                [addressBookItem setFirstNameYomi:firstnameyomi];
                [addressBookItem setLastNameYomi:lastnameyomi];
                [addressBookItem setMiddleNameYomi:middlenameyomi];
                [addressBookItem setCompanyName:companyname];
                [addressBookItem setDepartment:department];
                [addressBookItem setNotes:note];
                [addressBookItem setJobTitle:jobTitle];
                [addressBookItem setNickName:nickname];
                [addressBookItem setPrefix:prefix];
                [addressBookItem setSuffix:suffix];
                
                // 根据ROWID查询出该联系人的缩略图
                if ([self openDbImageConnection]) {
                    NSString *imgSelectCmd = nil;
                    //                    if (!_manifestManager.manifestHandle.isAbove) {//4代以下的设备
                    //                        imgSelectCmd =  @"select data from ABImage where crop_width>0 and  crop_height>0 and record_id=:rowid";
                    //                    }else {
                    imgSelectCmd =  @"select data from ABFullSizeImage where record_id=:rowid";
                    //                    }
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInt:rowid], @"rowid",
                                           nil];
                    FMResultSet *imgRS = [_databaseImgConnection executeQuery:imgSelectCmd withParameterDictionary:param];
                    while ([imgRS next]) {
                        if (![imgRS columnIsNull:@"data"]) {
                            NSData *data = [imgRS dataForColumn:@"data"];
                            NSImage *image = [[NSImage alloc] initWithData:data];
                            if (image != nil) {
                                [addressBookItem setImage:image];
                            }
                            [image release];
                            image = nil;
                        }
                    }
                    [imgRS close];
                    [self closeDbImageConnection];
                }
                
                //查询表ABMultiValue，获得的数据，装在_contentArray中
                NSMutableArray *ABMultiValueArray = [self queryABMultiValueByBookItem:addressBookItem];
                //            [addressBookItem setContentArray:ABMultiValueArray];
                [addressBookItem.contentArray addObjectsFromArray:ABMultiValueArray];
                [_dataAry addObject:addressBookItem];
                [addressBookItem release];
                addressBookItem = nil;
            }
        }
        [rs close];
        [self closeDbImageConnection];
    }

    [_logManger writeInfoLog:@"query Contact From Sqlite End"];
}

//查询表ABMultiValue，并按property字段分类，放入对应数组中
- (NSMutableArray *)queryABMultiValueByBookItem:(IMBAddressBookDataEntity *)bookItem {
    // 查询出所有的Lable标签
    NSMutableDictionary *labelDic = [self queryABMultiValueLabel];
    
    NSMutableArray *lMultiValueArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *selectCmd = @"select *from ABMultiValue where record_id=:rowid";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:bookItem.rowid], @"rowid",
                           nil];
    FMResultSet *rs = nil;
    rs = [_databaseConnection executeQuery:selectCmd withParameterDictionary:param];
    IMBAddressBookMultDataEntity *multDataItem = nil;
    while ([rs next]) {
        multDataItem = [[IMBAddressBookMultDataEntity alloc] init];
        int uid = [rs intForColumn:@"UID"];
        int recordID = [rs intForColumn:@"record_id"];
        int property = [rs intForColumn:@"property"];
        int identifier = [rs intForColumn:@"identifier"];
        int label = -1;
        if (![rs columnIsNull:@"label"]) {
            label = [rs intForColumn:@"label"];
        }
        NSString *value = @"";
        if (![rs columnIsNull:@"value"]) {
            value = [rs stringForColumn:@"value"];
        }else {
            value = @"";
        }
        NSString *type = @"";
        if (label != -1) {
            type = [labelDic objectForKey:[NSString stringWithFormat:@"%d",label]];
        }else {
            type = @"";
        }
        
        [multDataItem setCheckState:UnChecked];
        [multDataItem setUid:uid];
        [multDataItem setRecordID:recordID];
        [multDataItem setProperty:property];
        [multDataItem setIdentifier:identifier];
        [multDataItem setLabel:label];
        [multDataItem setMultValue:value];
        [multDataItem setLableType:type];
        if ([StringHelper stringIsNilOrEmpty:multDataItem.lableType]) {
            [multDataItem setLableType:CustomLocalizedString(@"contact_id_8", nil)];
        }
        
        //查询表ABMultiValueEntry，获得数据装在_multiArray中；
        NSMutableArray *ABMArray = [self queryABMultiValueEntryByUID:uid];
        [multDataItem setMultiArray:ABMArray];
        
        [lMultiValueArray addObject:multDataItem];
        if (property == 3) {
            [bookItem.numberArray addObject:multDataItem];
        }else if (property == 4) {
            [bookItem.emailArray addObject:multDataItem];
        }else if (property == 5) {
            [bookItem.streetArray addObject:multDataItem];
        }else if (property == 12) {
            [bookItem.dateArray addObject:multDataItem];
        }else if (property == 13) {
            [bookItem.IMArray addObject:multDataItem];
        }else if (property == 22) {
            [bookItem.URLArray addObject:multDataItem];
        }else if (property == 23) {
            [bookItem.relatedArray addObject:multDataItem];
        }else if (property == 46) {
            [bookItem.specialURLArray addObject:multDataItem];
        }
        [multDataItem release];
        multDataItem = nil;
    }
    [rs close];
    
    return lMultiValueArray;
}

//查询表ABMultiValueLabel
- (NSMutableDictionary *)queryABMultiValueLabel {
    NSMutableDictionary *labelValueDic = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString *selectCmd = @"select rowid,value from ABMultiValueLabel";
    FMResultSet *rs = nil;

    rs = [_databaseConnection executeQuery:selectCmd];
 
    while ([rs next]) {
        int rowid = [rs intForColumn:@"rowid"];
        NSString *valueStr = [rs stringForColumn:@"value"];
        if (![StringHelper stringIsNilOrEmpty:valueStr]) {
            valueStr = [[[valueStr stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] stringByReplacingOccurrencesOfString:@">!$_" withString:@""] lowercaseString];
            if ([valueStr hasSuffix:@"page"]) {
                NSRange range = [valueStr rangeOfString:@"page"];
                NSMutableString *string=[NSMutableString stringWithString:valueStr];
                [string insertString:@" " atIndex:range.location];
                valueStr = string;
            } else if ([valueStr hasSuffix:@"fax"]) {
                NSRange range = [valueStr rangeOfString:@"fax"];
                NSMutableString *string=[NSMutableString stringWithString:valueStr];
                [string insertString:@" " atIndex:range.location];
                valueStr = string;
            }
            [labelValueDic setObject:valueStr forKey:[NSString stringWithFormat:@"%d", rowid]];
        }
    }
    [rs close];
    return labelValueDic;
}

//查询表ABMultiValueEntry
- (NSMutableArray *)queryABMultiValueEntryByUID:(int)uid {
    // 查询出所有的EntryKey
    NSMutableDictionary *entityDic = [self queryABMultiValueEntryKey];
    
    NSMutableArray *ABMEntryArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *selectCmd = @"select *from ABMultiValueEntry where parent_id = :parentid";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:uid], @"parentid", nil];
    FMResultSet *rs = nil;
    rs = [_databaseConnection executeQuery:selectCmd withParameterDictionary:param];
    IMBAddressBookDetailEntity *detailItem = nil;
    while ([rs next]) {
        detailItem = [[IMBAddressBookDetailEntity alloc] init];
        int parentID = [rs intForColumn:@"parent_id"];
        int key = -1;
        if (![rs columnIsNull:@"key"]) {
            key = [rs intForColumn:@"key"];
        }
        NSString *detailValue = nil;
        if (![rs columnIsNull:@"value"]) {
            detailValue = [rs stringForColumn:@"value"];
        }else {
            detailValue = @"";
        }
        
        NSString *type = nil;
        if (key != -1) {
            type = [entityDic objectForKey:[NSString stringWithFormat:@"%d",key]];
        }else {
            type = @"";
        }
        
        [detailItem setCheckState:UnChecked];
        [detailItem setParentID:parentID];
        [detailItem setKey:key];
        [detailItem setDetailValue:detailValue];
        [detailItem setEntityType:type];
        
        [ABMEntryArray addObject:detailItem];
        [detailItem release];
        detailItem = nil;
    }
    [rs close];
    
    return ABMEntryArray;
}
//查询ABMultiValueEntryKey表
- (NSMutableDictionary *)queryABMultiValueEntryKey {
    NSMutableDictionary *entryKeyDic = [[[NSMutableDictionary alloc] init] autorelease];
    NSString *selectCmd = @"select rowid,value from ABMultiValueEntryKey;";
    FMResultSet *rs = nil;

    rs = [_databaseConnection executeQuery:selectCmd];

    while ([rs next]) {
        int rowid = [rs intForColumn:@"rowid"];
        NSString *valueStr = [rs stringForColumn:@"value"];
        if (![StringHelper stringIsNilOrEmpty:valueStr]) {
            valueStr = [valueStr lowercaseString];
            if ([valueStr hasSuffix:@"code"]) {
                NSRange range = [valueStr rangeOfString:@"code"];
                NSMutableString *string=[NSMutableString stringWithString:valueStr];
                [string insertString:@" " atIndex:range.location];
                valueStr = string;
            }
            if ([valueStr isEqualToString:@"zip"]) {
                valueStr = @"postal code";
            } else if ([valueStr isEqualToString:@"username"]) {
                valueStr = @"user";
            }
            [entryKeyDic setObject:valueStr forKey:[NSString stringWithFormat:@"%d", rowid]];
        }
    }
    [rs close];
    
    return entryKeyDic;
}
@end

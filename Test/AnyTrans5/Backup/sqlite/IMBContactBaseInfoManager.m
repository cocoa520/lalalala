//
//  IMBContactBaseInfoManager.m
//  DataRecovery
//
//  Created by iMobie on 4/22/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBContactBaseInfoManager.h"
#import "IMBBackupManager.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "NSString+Category.h"
@implementation IMBContactBaseInfoManager
@synthesize contactInfoArray = _contactInfoArray;
@synthesize contactDB = _contactDB;

- (id)initWithManifestManager:(NSString *)backupPath WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt {
    self = [super init];
    if (self) {
        fm = [NSFileManager defaultManager];
        logHandle = [IMBLogManager singleton];
        _contactInfoArray = [[NSMutableArray alloc] init];
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        if (isEncrypted) {
            [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/AddressBook/AddressBook.sqlitedb"];
            manager.backUpPath = decypt.outputPath;
            backupPath = decypt.outputPath;
        }
        _contactPath = [[manager copysqliteToApptempWithsqliteName:@"AddressBook.sqlitedb" backupfilePath:backupPath] retain];
        _dbImagePath = [[manager copysqliteToApptempWithsqliteName:@"Library/AddressBook/AddressBookImages.sqlitedb" backupfilePath:backupPath] retain];
        // 在这里就预先查询出所有的联系人的信息,要取的时候就不用去查询了
        [self queryAllContactInfo];
    }
    return self;
}

- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup {
    self = [super init];
    if (self) {
        _iCloudBackup = [iCloudBackup retain];
        logHandle = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
        
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
            NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/AddressBook/AddressBook.sqlitedb"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:dbNPath]) {
                _contactPath = [dbNPath retain];
            }
            
            NSString *dbNPath1 = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/AddressBook/AddressBookImages.sqlitedb"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:dbNPath1]) {
                _dbImagePath = [dbNPath1 retain];
            }
            _contactInfoArray = [[NSMutableArray alloc] init];
        }else{
            NSString *sqlPath = [TempHelper getAppTempPath];
            //遍历需要的文件，然后拷贝到指定的目录下
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/AddressBook/AddressBook.sqlitedb"];
            NSArray *tmpArray = [_iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            IMBiCloudFileInfo *addressBook = nil;
            if (tmpArray != nil && tmpArray.count > 0) {
                addressBook = [tmpArray objectAtIndex:0];
            }
            if (addressBook != nil) {
                NSString *dbPath = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:addressBook.fileName];
                NSString *filePath = [sqlPath stringByAppendingPathComponent:addressBook.fileName];
                if ([fm fileExistsAtPath:filePath]) {
                    [fm removeItemAtPath:filePath error:nil];
                }
                if ([fm fileExistsAtPath:dbPath]) {
                    [fm copyItemAtPath:dbPath toPath:filePath error:nil];
                }
                _contactPath = [filePath retain];
            }
            
            
            
            
            IMBiCloudFileInfo *addressBookImages = nil;
            pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/AddressBook/AddressBookImages.sqlitedb"];
            tmpArray = [_iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            if (tmpArray != nil && tmpArray.count > 0) {
                addressBookImages = [tmpArray objectAtIndex:0];
            }
            if (addressBookImages != nil) {
                NSString *dbAddImPath = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:addressBookImages.fileName];
                NSString *filePath = [sqlPath stringByAppendingPathComponent:addressBookImages.fileName];
                if ([fm fileExistsAtPath:filePath]) {
                    [fm removeItemAtPath:filePath error:nil];
                }
                if ([fm fileExistsAtPath:dbAddImPath]) {
                    [fm copyItemAtPath:dbAddImPath toPath:filePath error:nil];
                }
                _dbImagePath = [filePath retain];
            }
            
            _contactInfoArray = [[NSMutableArray alloc] init];

        }
        
           // 在这里就预先查询出所有的联系人的信息,要取的时候就不用去查询了
        [self queryAllContactInfo];
    }
    return self;
}

- (void)dealloc
{
    if (_contactInfoArray != nil) {
        [_contactInfoArray release];
        _contactInfoArray = nil;
    }
    if (_contactPath != nil) {
        [_contactPath release];
        _contactPath = nil;
    }
    if (_dbImagePath != nil) {
        [_dbImagePath release];
        _dbImagePath = nil;
    }
    if (_iCloudBackup != nil) {
        [_iCloudBackup release];
        _iCloudBackup = nil;
    }
    [super dealloc];
}

- (BOOL)openConnection {
    BOOL ret = NO;
    if (![StringHelper stringIsNilOrEmpty:_contactPath] && [fm fileExistsAtPath:_contactPath]) {
        _contactDB = [[FMDatabase databaseWithPath:_contactPath] retain];
        if ([_contactDB open]) {
            [_contactDB setShouldCacheStatements:NO];
            [_contactDB setTraceExecution:NO];
            ret = YES;
        } else {
            _contactDB = nil;
        }
    }
    return ret;
}

- (void)closeConnection {
    if (_contactDB != nil) {
        [_contactDB close];
        [_contactDB release];
        _contactDB = nil;
    }
}

//打开image数据库连接
- (BOOL)openImageSqliteConnection {
    BOOL ret = FALSE;
    if ([fm fileExistsAtPath:_dbImagePath]) {
        _fmImageDB = [[FMDatabase databaseWithPath:_dbImagePath] retain];
        if ([_fmImageDB open]) {
            [_fmImageDB setShouldCacheStatements:NO];
            [_fmImageDB setTraceExecution:NO];
            ret = TRUE;
        }
    }else {
        [_fmImageDB release];
        _fmImageDB = nil;
    }
    return ret;
}

- (void)closeImageSqliteConnection {
    if (_fmImageDB != nil) {
        [_fmImageDB close];
        [_fmImageDB release];
        _fmImageDB = nil;
    }
}

- (void)queryAllContactInfo {
    IMBLogManager *logManager = [IMBLogManager singleton];
    [logManager writeInfoLog:@"queryAllContactInfo Begin"];
    if ([self openConnection]) {
        BOOL tableExsit = NO;
        // 检查ABPersonFullTextSearch_content表是否存在
        NSString *tableSelectCmd = [NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and name='%@';", @"ABPersonFullTextSearch_content"];
        FMResultSet *trs = [_contactDB executeQuery:tableSelectCmd];
        while ([trs next]) {
            tableExsit = [trs intForColumnIndex:0] > 0 ? YES : 0;
        }
        [trs close];
        
        if (tableExsit) {
            IMBBackupManager *manager = [IMBBackupManager shareInstance];

            NSString *selectCmd = nil;
            if ([manager.iosVersion isVersionMajorEqual:@"10.2"]) {
                selectCmd = @"select docid,c0First,c1Last,c2Middle,c16Phone from ABPersonFullTextSearch_content;";
            }else{
                selectCmd = @"select docid,c0First,c1Last,c2Middle,c15Phone from ABPersonFullTextSearch_content;";
            }
            FMResultSet *rs = [_contactDB executeQuery:selectCmd];
            IMBContactInfoModel *contactInfo = nil;
            while ([rs next]) {
                contactInfo = [[IMBContactInfoModel alloc] init];
                if (![rs columnIsNull:@"docid"]) {
                    [contactInfo setRowID:[rs intForColumn:@"docid"]];
                } else {
                    [contactInfo setRowID:0];
                }
                if (![rs columnIsNull:@"c0First"]) {
                    [contactInfo setFirstName:[rs stringForColumn:@"c0First"]];
                } else {
                    [contactInfo setFirstName:@""];
                }
                if (![rs columnIsNull:@"c1Last"]) {
                    [contactInfo setLastName:[rs stringForColumn:@"c1Last"]];
                } else {
                    [contactInfo setLastName:@""];
                }
                if (![rs columnIsNull:@"c2Middle"]) {
                    [contactInfo setMiddleName:[rs stringForColumn:@"c2Middle"]];
                } else {
                    [contactInfo setMiddleName:@""];
                }
                
                NSString *allname = nil;
                if (![contactInfo.firstName isEqualToString:@""]) {
                    allname = [[contactInfo.firstName stringByAppendingString:@" "] stringByAppendingString:contactInfo.lastName];
                }else {
                    allname = contactInfo.lastName;
                }
                
                if ([allname isEqualToString:@""]) {
                    allname = CustomLocalizedString(@"contact_id_48", nil);
                }
                
                [contactInfo setDisplayName:allname];
                if ([manager.iosVersion isVersionMajorEqual:@"10.2"]) {
                    if (![rs columnIsNull:@"c16Phone"]) {
                        NSString *phoneStr = [rs stringForColumn:@"c16Phone"];
                        [contactInfo setPhoneContent:phoneStr];
                    }
                }else{
                    if (![rs columnIsNull:@"c15Phone"]) {
                        NSString *phoneStr = [rs stringForColumn:@"c15Phone"];
                        [contactInfo setPhoneContent:phoneStr];
                    }
                }
                
                
                
                // 根据ROWID查询出该联系人的缩略图
                if ([self openImageSqliteConnection]) {
                    NSString *imgSelectCmd = nil;
//                    if (!_manifestManager.manifestHandle.isAbove) {//4代以下的设备
//                        imgSelectCmd =  @"select data from ABImage where crop_width>0 and  crop_height>0 and record_id=:rowid";
//                    }else {
                    imgSelectCmd =  @"select data from ABFullSizeImage where record_id=:rowid";
//                    }
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInt:contactInfo.rowID], @"rowid",
                                           nil];
                    FMResultSet *imgRS = [_fmImageDB executeQuery:imgSelectCmd withParameterDictionary:param];
                    while ([imgRS next]) {
                        if (![imgRS columnIsNull:@"data"]) {
                            NSData *data = [imgRS dataForColumn:@"data"];
                            NSImage *image = [[NSImage alloc] initWithData:data];
                            if (image != nil) {
                                [contactInfo setImage:image];
                            }
                            [image release];
                            image = nil;
                        }
                    }
                    [imgRS close];
                    [self closeImageSqliteConnection];
                }
                
                [_contactInfoArray addObject:contactInfo];
                [contactInfo release];
                contactInfo = nil;
            }
            [rs close];
        } else {
            NSString *selectCmd = @"select ROWID,First,Last,Middle,value from ABPerson as a inner join ABMultiValue as b on a.ROWID = b.record_id where property = 3;";
            //@"insert into ABMultiValue(UID, record_id, property, identifier, label, value) values(1,1,3,0,2,'15968658954')"
            FMResultSet *rs = [_contactDB executeQuery:selectCmd];
            IMBContactInfoModel *contactInfo = nil;
            while ([rs next]) {
                contactInfo = [[IMBContactInfoModel alloc] init];
                if (![rs columnIsNull:@"ROWID"]) {
                    [contactInfo setRowID:[rs intForColumn:@"ROWID"]];
                } else {
                    [contactInfo setRowID:0];
                }
                if (![rs columnIsNull:@"First"]) {
                    [contactInfo setFirstName:[rs stringForColumn:@"First"]];
                } else {
                    [contactInfo setFirstName:@""];
                }
                if (![rs columnIsNull:@"Last"]) {
                    [contactInfo setLastName:[rs stringForColumn:@"Last"]];
                } else {
                    [contactInfo setLastName:@""];
                }
                if (![rs columnIsNull:@"Middle"]) {
                    [contactInfo setMiddleName:[rs stringForColumn:@"Middle"]];
                } else {
                    [contactInfo setMiddleName:@""];
                }
                
                NSString *allname = nil;
                if (![contactInfo.firstName isEqualToString:@""]) {
                    allname = [[contactInfo.firstName stringByAppendingString:@" "] stringByAppendingString:contactInfo.lastName];
                }else {
                    allname = contactInfo.lastName;
                }
                
                if ([allname isEqualToString:@""]) {
                    allname = CustomLocalizedString(@"contact_id_48", nil);
                }
                
                [contactInfo setDisplayName:allname];
                if (![rs columnIsNull:@"value"]) {
                    NSString *phoneStr = [rs stringForColumn:@"value"];
                    [contactInfo setPhoneContent:phoneStr];
                }
                
                // 根据ROWID查询出该联系人的缩略图
                if ([self openImageSqliteConnection]) {
                    NSString *imgSelectCmd = nil;
                    imgSelectCmd =  @"select data from ABFullSizeImage where record_id=:rowid";
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInt:contactInfo.rowID], @"rowid",
                                           nil];
                    FMResultSet *imgRS = [_fmImageDB executeQuery:imgSelectCmd withParameterDictionary:param];
                    while ([imgRS next]) {
                        if (![imgRS columnIsNull:@"data"]) {
                            NSData *data = [imgRS dataForColumn:@"data"];
                            NSImage *image = [[NSImage alloc] initWithData:data];
                            if (image != nil) {
                                [contactInfo setImage:image];
                            }
                            [image release];
                            image = nil;
                        }
                    }
                    [imgRS close];
                    [self closeImageSqliteConnection];
                }
                
                [_contactInfoArray addObject:contactInfo];
                [contactInfo release];
                contactInfo = nil;
            }
            [rs close];
        }
        [self closeConnection];
    }
    [logManager writeInfoLog:@"queryAllContactInfo End"];
}

- (IMBContactInfoModel *)getContactinfoByIdentifier:(NSString *)identifier {
    IMBContactInfoModel *contactInfo = nil;
    if (identifier == nil) {
        identifier = @"";
    }
    if (_contactInfoArray != nil && _contactInfoArray.count > 0) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            BOOL isSelect = NO;
            NSString *phoneContent = ((IMBContactInfoModel *)evaluatedObject).phoneContent;
            if ([phoneContent rangeOfString:identifier].length > 0) {
                isSelect = YES;
            }
            return isSelect;
        }];
        NSArray *tmpArray = [_contactInfoArray filteredArrayUsingPredicate:pre];
        if (tmpArray != nil && tmpArray.count > 0) {
            contactInfo = [tmpArray objectAtIndex:0];
        }
    }
    return contactInfo;
}

- (NSString *)getDisplayNameByRecordID:(int)recordID addressValue:(NSString *)addressValue {
    NSString *displayName = nil;
    if (addressValue == nil) {
        addressValue = @"";
    }
    if (_contactInfoArray != nil && _contactInfoArray.count > 0) {
        if (recordID == -1) {//-1表示没有匹配的联系人，就通过号码比对查询联系人
            NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return ([((IMBContactInfoModel *)evaluatedObject).phoneContent rangeOfString:addressValue].length > 0);
            }];
            NSArray *tmpArray = [_contactInfoArray filteredArrayUsingPredicate:pre];
            if (tmpArray != nil && tmpArray.count > 0) {
                IMBContactInfoModel *contactInfo = [tmpArray objectAtIndex:0];
                if (contactInfo != nil) {
                    displayName = contactInfo.displayName;
                }
            }
        } else {//通过rowid比较查询对应联系人（id字段（表call中）与docid字段（表ABPersonFullTextSearch_content中）比较）
            NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return (((IMBContactInfoModel *)evaluatedObject).rowID == recordID);
            }];
            NSArray *tmpArray = [_contactInfoArray filteredArrayUsingPredicate:pre];
            if (tmpArray != nil && tmpArray.count > 0) {
                IMBContactInfoModel *contactInfo = [tmpArray objectAtIndex:0];
                if (contactInfo != nil) {
                    displayName = contactInfo.displayName;
                }
            }
        }
        
        if ([StringHelper stringIsNilOrEmpty:displayName]) {
            displayName = CustomLocalizedString(@"contact_id_48", nil);
        }
    } else {
        displayName = CustomLocalizedString(@"contact_id_48", nil);
    }
    return displayName;
}

@end

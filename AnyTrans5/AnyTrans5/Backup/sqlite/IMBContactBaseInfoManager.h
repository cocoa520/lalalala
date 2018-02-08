//
//  IMBContactBaseInfoManager.h
//  DataRecovery
//
//  Created by iMobie on 4/22/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCallHistoryDataEntity.h"
#import "FMDatabase.h"
#import "IMBMBDBParse.h"
#import "IMBLogManager.h"
#import "IMBBackupDecrypt.h"
#import "IMBiCloudClient.h"

@interface IMBContactBaseInfoManager : NSObject {
@private
    IMBMBFileRecord *_contactFileRecord;
    NSString *_contactPath;
    NSMutableArray *_contactInfoArray;
    
    IMBiCloudBackup *_iCloudBackup;
    
    NSString *_dbImagePath;
    FMDatabase *_fmImageDB;
    IMBMBFileRecord *_fileImageRecord;
    
    NSFileManager *fm;
    FMDatabase *_contactDB;
    IMBLogManager *logHandle;
}

@property (nonatomic, retain) FMDatabase *contactDB;
@property (nonatomic, readwrite, retain) NSMutableArray *contactInfoArray;

- (id)initWithManifestManager:(NSString *)backupPath WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt;
- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup;


- (IMBContactInfoModel *)getContactinfoByIdentifier:(NSString *)identifier;
- (NSString *)getDisplayNameByRecordID:(int)recordID addressValue:(NSString *)addressValue;

- (BOOL)openConnection;
- (void)closeConnection;

@end

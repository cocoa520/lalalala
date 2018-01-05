//
//  IMBBaseClone.h
//  iMobieTrans
//
//  Created by iMobie on 14-12-16.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//
#import "IMBMBDBParse.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "IMBDeviceInfo.h"
#import "IMBLogManager.h"
#import "IMBiPod.h"
#import "IMBMBDBParse.h"
#import "TempHelper.h"
#import "NSDictionary+Category.h"
@interface IMBBaseClone : NSObject
{
    FMDatabase    *_sourceDBConnection;
    FMDatabase    *_targetDBConnection;
    IMBMBFileRecord *sourceRecord;
    IMBMBFileRecord *targetRecord;
    NSString *_sourceBackuppath;
    NSString *_targetBakcuppath;
    NSString *_sourceSqlitePath;
    NSString *_targetSqlitePath;
    IMBLogManager *_logHandle;
    NSInteger _sourceVersion;  //原设备系统版本
    NSInteger _targetVersion;  //目标设备系统版本
    NSString *_sourceFloatVersion;
    NSString *_targetFloatVersion;
    BOOL isneedClone; //此选项是否需要克隆
    BOOL _isClone;
    NSMutableArray *_sourcerecordArray;
    NSMutableArray *_targetrecordArray;
    //iOS10
    FMDatabase *_sourceManifestDBConnection;
    FMDatabase *_targetManifestDBConnection;
    
    int _succesCount;
}

@property (nonatomic,assign)int succesCount;
@property(nonatomic,assign)BOOL isneedClone;
- (id)initWithSourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray isClone:(BOOL)isClone;
- (void)setsourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray;
- (BOOL)openDataBase:(FMDatabase *)dbconnection;
- (BOOL)closeDataBase:(FMDatabase *)databaseConnection;
- (void)clone;
- (void)merge:(NSArray *)dataArray;
- (NSString *)createGUID;
- (void)modifyHashAndManifest;
+ (int)getBackupFileVersion:(NSString *)backupPath;
+ (NSString *)getBackupFileFloatVersion:(NSString *)backupPath;
- (IMBMBFileRecord *)getDBFileRecord:(NSString *)domainName path:(NSString *)path recordArray:(NSMutableArray *)recordArray;
- (NSString *)copyIMBMBFileRecordTodesignatedPath:(NSString *)path fileRecord:(IMBMBFileRecord *)record backupfilePath:(NSString *)backupfilePath;
+ (void)reCaculateRecordHash:(IMBMBFileRecord *)mbfileRecord backupFolderPath:(NSString *)backupFolderPath;
+ (BOOL)saveMBDB:(NSArray*)recordsArray cacheFilePath:(NSString *)cacheFilePath backupFolderPath:(NSString*)backupFolderPath;
- (void)setsourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath;
- (NSString *)copySourcePath:(NSString *)sourcePath desPath:(NSString *)desPath;
+ (NSString *)dataHashfilePath:(NSString *)filePath;
- (void)modifyHashMajorEqualTen:(FMDatabase *)targetDB SqlitePath:(NSString *)sqlitePath record:(IMBMBFileRecord *)record;
- (void)deleteRecords:(NSArray *)recordArray TargetDB:(FMDatabase *)targetDB;
- (void)addRecords:(NSArray *)recordArray sourceDB:(FMDatabase *)sourceDB TargetDB:(FMDatabase *)targetDB sourceVersion:(NSString *)sourceVersion;
@end

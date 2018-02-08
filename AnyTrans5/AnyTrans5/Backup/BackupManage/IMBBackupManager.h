//
//  IMBBackupManager.h
//  AnyTrans
//
//  Created by long on 16-7-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleNode.h"
#import "IMBiPod.h"
#import "IMBMBDBParse.h"
@interface IMBBackupManager : NSObject
{
    NSMutableArray *backupNodeArr;
    NSMutableDictionary *_recordDic;
    NSMutableDictionary *mdDictionary;
    NSMutableArray *_backFileArray;
    NSString *_backUpPath;
    NSMutableDictionary *mdInfoDic;
    NSFileManager *fm;
    NSString *_iosVersion;
    NSString *_tembackupPath;
}
@property (nonatomic, retain) NSMutableArray *backFileArray;
@property (nonatomic, retain) NSMutableArray *backupNodeArr;
@property (nonatomic, retain) NSMutableDictionary *recordDic;
@property (nonatomic, retain) NSString *backUpPath;
@property (nonatomic, retain) NSString *iosVersion;
+ (IMBBackupManager *)shareInstance;
- (NSMutableArray *)getRootArray:(NSString *)backupfilePath;
- (void)parseManifest:(NSString *)backupFilePath;
- (NSMutableArray *)getBackupRootNode :(IMBiPod *)ipod withPath:(NSString *)tagPath;
- (void)matchAttachmentManifestDBattachmentList:(NSMutableArray *)attachmentList withAttachData:(NSMutableArray *)attachData;
- (NSString *)copysqliteImageToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath;
- (NSString *)copysqliteToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath;
- (void)matchAttachmentArray:(NSMutableArray *)attachmentArray withReslutAry:(NSMutableArray *)ary;
- (IMBMBFileRecord *)getDBFileRecord:(NSString *)domainName path:(NSString *)path;
//- (NSString *)getFilePathForFileRecord:(IMBMBFileRecord *)mbFileRecord ;

- (SimpleNode *)getSingleBackupRootNode:(NSString *)filePath;
- (NSString *)copyImageToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath withBackupstr:(NSString *)backupPath;
@end
@interface IMBManifestDataModel : NSObject {
@private
    NSString *_fileKey;
    NSString *_fileName;
    NSString *_filePath;
    NSString *_fileBackUpPath;
    BOOL _isFileExist;
    int64_t _fileSize;
    NSString *_fileDomain;
    IMBMBFileRecord *_mbFileRecord;
}

@property (nonatomic, readwrite, retain) NSString *fileKey;
@property (nonatomic, readwrite, retain) NSString *fileName;
@property (nonatomic, readwrite, retain) NSString *filePath;
@property (nonatomic, readwrite, retain) NSString *fileBackUpPath;
@property (nonatomic, readwrite) BOOL isFileExist;
@property (nonatomic, readwrite) int64_t fileSize;
@property (nonatomic, readwrite, retain) NSString *fileDomain;
@property (nonatomic, readwrite, retain) IMBMBFileRecord *mbFileRecord;

@end
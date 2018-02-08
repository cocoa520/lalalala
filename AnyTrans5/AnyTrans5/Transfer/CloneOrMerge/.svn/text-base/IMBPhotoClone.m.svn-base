//
//  IMBPhotoClone.m
//  iMobieTrans
//
//  Created by iMobie on 15-3-12.
//  Copyright (c) 2015年 iMobie Inc. All rights reserved.
//

#import "IMBPhotoClone.h"

@implementation IMBPhotoClone
- (id)initWithSourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray isClone:(BOOL)isClone
{
    if (self = [super init]) {
        _sourceBackuppath = [sourceBackupPath retain];
        _targetBakcuppath = [desBackupPath retain];
        _sourceVersion = [IMBBaseClone getBackupFileVersion:sourceBackupPath];
        _targetVersion = [IMBBaseClone getBackupFileVersion:desBackupPath];
        _sourceFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:sourceBackupPath] retain];
        _targetFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:desBackupPath] retain];
        //解析manifest
        _sourcerecordArray = [sourcerecordArray retain];
        _targetrecordArray = [targetrecordArray retain];
        _sourcecameraRollArray = [[self getCameraRollDomain:_sourcerecordArray] retain];
        _targetcameraRollArray = [[self getCameraRollDomain:_targetrecordArray] retain];
        
        if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
            _sourceManifestDBConnection = [[FMDatabase alloc] initWithPath:[sourceBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
        }
        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
            _targetManifestDBConnection = [[FMDatabase alloc] initWithPath:[desBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
        }
    }
    return self;
}

#pragma mark - Method
- (NSMutableArray *)getCameraRollDomain:(NSMutableArray *)recordArray
{
    NSMutableArray *cameraRollArray = [NSMutableArray array];
    if ([recordArray count] > 0) {
        for (IMBMBFileRecord *record in recordArray) {
            if ([record.domain isEqualToString:@"CameraRollDomain"]&&![record.path isEqualToString:@""]) {
                [cameraRollArray addObject:record];
            }
        }
    }
    return cameraRollArray;
}

#pragma mark - Clone
- (void)clone
{
    //如果clone Photo则不需要进行photo结构迁移
    //如果不clone Photo则需要进行photo结构迁移，并且需要迁移photolibrary里的数据
    if (isneedClone) {
        return;
    }
    NSMutableArray *sourceRecordArray1 = [NSMutableArray array];
    NSMutableArray *sourceRecordArray2 = [NSMutableArray array];
    BOOL canAdd = YES;
    for (int i=0;i<[_sourcerecordArray count];i++ ) {
        IMBMBFileRecord *record = [_sourcerecordArray objectAtIndex:i];
        if (canAdd) {
            [sourceRecordArray1 addObject:record];
        }else
        {
            [sourceRecordArray2 addObject:record];
        }
        
        if ([record.path isEqualToString:@""]&&[record.domain isEqualToString:@"CameraRollDomain"]) {
            canAdd = NO;
        }
    }
    [_sourcerecordArray removeAllObjects];
    [_sourcerecordArray addObjectsFromArray:sourceRecordArray1];
    [_sourcerecordArray addObjectsFromArray:_targetcameraRollArray];
    [_sourcerecordArray addObjectsFromArray:sourceRecordArray2];
    [_sourcerecordArray removeObjectsInArray:_sourcecameraRollArray];
    //复制数据
    NSFileManager *fileM = [NSFileManager defaultManager];
    for (IMBMBFileRecord *record in _targetcameraRollArray) {
        if (record.filetype == FileType_Backup) {
            NSString *fkey = [record.key substringWithRange:NSMakeRange(0, 2)];
            NSString *sourcePath = nil;
            if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                if (![fileM fileExistsAtPath:folderPath]) {
                    [fileM createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                if (record.key>0) {
                    sourcePath = [folderPath stringByAppendingPathComponent:record.key];

                }
            }else{
                if (record.key>0) {
                    sourcePath = [_sourceBackuppath stringByAppendingPathComponent:record.key];
                }
            }
            NSString *desPath = nil;
            if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                desPath = [folderPath stringByAppendingPathComponent:record.key];
            }else{
                desPath = [_targetBakcuppath stringByAppendingPathComponent:record.key];
            }
            if ([fileM fileExistsAtPath:sourcePath]) {
                [fileM removeItemAtPath:sourcePath error:nil];
            }
            if ([fileM fileExistsAtPath:desPath]) {
                [record setDataHash:[IMBBaseClone dataHashfilePath:desPath]];
                int64_t fileSize = [IMBUtilTool fileSizeAtPath:desPath];
                [record changeFileLength:fileSize];
                [fileM copyItemAtPath:desPath toPath:sourcePath error:nil];
            }
        }
    }
    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
        //先删掉原设备的cameraRoll 再将目标设备的cameraRoll拷贝到原设备
        [self deleteRecords:_sourcecameraRollArray TargetDB:_sourceManifestDBConnection];
        //将目标设备的cameraRoll拷贝到原设备
        [self addRecords:_targetcameraRollArray sourceDB:_targetManifestDBConnection TargetDB:_sourceManifestDBConnection sourceVersion:_targetFloatVersion];
    }else{
        [IMBBaseClone saveMBDB:_sourcerecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceManifest.mbdb"] backupFolderPath:_sourceBackuppath];
    }
}




- (void)dealloc
{
    [_sourcecameraRollArray release],_sourcecameraRollArray = nil;
    [_targetcameraRollArray release],_targetcameraRollArray = nil;
    [super dealloc];
}
@end

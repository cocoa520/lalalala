//
//  IMBAppClone.m
//  iMobieTrans
//
//  Created by iMobie on 12/22/15.
//  Copyright (c) 2015 iMobie Inc. All rights reserved.
//

#import "IMBAppClone.h"
#import "IMBApplicationManager.h"

@implementation IMBAppClone
@synthesize sourceApp = _sourceApp;
@synthesize targetApp = _targetApp;
- (id)initWithSourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray isClone:(BOOL)isClone
{
    if (self = [super init]) {
        _isClone = isClone;
        _sourceBackuppath = [sourceBackupPath retain];
        _targetBakcuppath = [desBackupPath retain];
        _sourceVersion = [IMBBaseClone getBackupFileVersion:sourceBackupPath];
        _targetVersion = [IMBBaseClone getBackupFileVersion:desBackupPath];
        _sourceFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:sourceBackupPath] retain];
        _targetFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:desBackupPath] retain];
        _sourcerecordArray = [sourcerecordArray retain];
        _targetrecordArray = [targetrecordArray retain];
        _sourceAppDomain = [[self getAllAppsDomain:_sourcerecordArray] retain];
        _targetAppDomain = [[self getAllAppsDomain:_targetrecordArray] retain];
        if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
            _sourceManifestDBConnection = [[FMDatabase alloc] initWithPath:[sourceBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
        }
        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
            _targetManifestDBConnection = [[FMDatabase alloc] initWithPath:[desBackupPath stringByAppendingPathComponent:@"Manifest.db"]];
        }

    }
    
    return self;
}

- (NSArray *)getAllAppsDomain:(NSMutableArray *)recodArray
{
    NSArray *allAppsDomainArray = nil;
    if ([recodArray count] > 0) {
        NSPredicate *pdicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMBMBFileRecord *item = (IMBMBFileRecord *)evaluatedObject;
            if ([[item domain] hasPrefix:@"AppDomain"]) {
                return YES;
            } else {
                return NO;
            }
        }];
        allAppsDomainArray = [recodArray filteredArrayUsingPredicate:pdicate];
        
    }
    
    return allAppsDomainArray;
    
}

/*
 clone都是用低设备备份去还原高设备；
 1、低设备——>高设备：
        不需要克隆app：需要删除低设备中mbdb文件中的AppDomain，进行还原；
        需要克隆app：不需要删除低设备中mbdb文件中的AppDomain，但要判断目标设备中是否有对应的app（没有，需要用户下载后，才进行还原）；
 2、高——>低：
        不需要克隆app：就直接用低设备备份还原；
        需要克隆app：需要把高设备的AppDomain记录增加到低设备的mbdb文件中，也要判断目标设备中是否有对应的app（没有，需要用户下载后，才进行还原）；
*/
- (void)clone {
    NSMutableArray *deleteArray = [NSMutableArray array];
    NSMutableArray *addArray = [NSMutableArray array];
    BOOL isLowToHigh = YES;
    if (_sourceVersion <= _targetVersion) {
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                return;
            }
            isLowToHigh = YES;
        }else {
            if (!isneedClone) {
                return;
            }
            isLowToHigh = NO;
        }
    }else {
        if (!isneedClone) {
            return;
        }
        isLowToHigh = NO;
    }
    
    if (isLowToHigh) {
        //修改manifest
        if (_sourceVersion<10) {
            [_sourcerecordArray removeObjectsInArray:_sourceAppDomain];
            [IMBBaseClone saveMBDB:_sourcerecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"hightManifest.mbdb"] backupFolderPath:_sourceBackuppath];
        }
    }else {
        NSFileManager *fm = [NSFileManager defaultManager];
        if (_sourceApp != nil && _sourceApp.count > 0) {
            for (IMBAppEntity *entity in _sourceApp) {
                BOOL isExite = NO;
                for (IMBAppEntity *tarEntity in _targetApp) {
                    if ([tarEntity.appKey isEqualToString:entity.appKey]) {
                        isExite = YES;
                        break;
                    }
                }
                if (!isExite) {
                    continue;
                }
                //先要删除目标设备中对应的AppDomain
                for (IMBMBFileRecord *tarFr in _targetAppDomain) {
                    NSString *appDomain = [NSString stringWithFormat:@"AppDomain-%@",entity.appKey];
                    if ([tarFr.domain isEqualToString:appDomain]) {
                        [_targetrecordArray removeObject:tarFr];
                        [deleteArray addObject:tarFr];
                    }if (entity.groupArray != nil && entity.groupArray.count > 0) {
                        for (NSString *groupKey in entity.groupArray) {
                            NSString *groupAppDomain = [NSString stringWithFormat:@"AppDomainGroup-%@",groupKey];
                            if ([tarFr.domain isEqualToString:groupAppDomain]) {
                                [_targetrecordArray removeObject:tarFr];
                            }
                        }
                        [deleteArray addObject:tarFr];
                    }
                }
                //在增加原设备中对应的AppDomain
                for (IMBMBFileRecord *fileRecord in _sourceAppDomain) {
                    NSString *appDomain = [NSString stringWithFormat:@"AppDomain-%@",entity.appKey];
                    if ([fileRecord.domain isEqualToString:appDomain] /*&& [domainArr containsObject:fileRecord.domain]*/) {
                        if (fileRecord.filetype == FileType_Backup) {
                            NSString *fkey = [fileRecord.key substringWithRange:NSMakeRange(0, 2)];
                            NSString *appPath = nil;
                            if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                                NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                                appPath = [folderPath stringByAppendingPathComponent:fileRecord.key];
                            }else{
                                appPath = [_sourceBackuppath stringByAppendingPathComponent:fileRecord.key];
                            }
                            if ([fm fileExistsAtPath:appPath]) {
                                NSString *tarAppPath = nil;
                                if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                                    NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                                    if (![fm fileExistsAtPath:folderPath]) {
                                        [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                                    }
                                    tarAppPath = [folderPath stringByAppendingPathComponent:fileRecord.key];
                                }else{
                                    tarAppPath = [_targetBakcuppath stringByAppendingPathComponent:fileRecord.key];
                                }
                                if ([fm fileExistsAtPath:tarAppPath]) {
                                    [fm removeItemAtPath:tarAppPath error:nil];
                                }
                                if ([fm copyItemAtPath:appPath toPath:tarAppPath error:nil]) {
                                    [IMBBaseClone reCaculateRecordHash:fileRecord backupFolderPath:_targetBakcuppath];
                                    int64_t fileSize = [IMBUtilTool fileSizeAtPath:appPath];
                                    [fileRecord changeFileLength:fileSize];
                                    [_targetrecordArray addObject:fileRecord];
                                }
                            }
                        }else {
                            [_targetrecordArray addObject:fileRecord];
                        }
                        [addArray addObject:fileRecord];
                    }else if (entity.groupArray != nil && entity.groupArray.count > 0) {
                        for (NSString *groupKey in entity.groupArray) {
                            NSString *groupAppDomain = [NSString stringWithFormat:@"AppDomainGroup-%@",groupKey];
                            if ([fileRecord.domain isEqualToString:groupAppDomain]) {
                                if (fileRecord.filetype == FileType_Backup) {
                                    NSString *fkey = [fileRecord.key substringWithRange:NSMakeRange(0, 2)];
                                    NSString *appPath = nil;
                                    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                                        NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                                        appPath = [folderPath stringByAppendingPathComponent:fileRecord.key];
                                    }else{
                                        appPath = [_sourceBackuppath stringByAppendingPathComponent:fileRecord.key];
                                    }
                                    if ([fm fileExistsAtPath:appPath]) {
                                        NSString *tarAppPath = nil;
                                        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                                            NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                                            if (![fm fileExistsAtPath:folderPath]) {
                                                [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                                            }
                                            tarAppPath = [folderPath stringByAppendingPathComponent:fileRecord.key];
                                        }else{
                                            tarAppPath = [_targetBakcuppath stringByAppendingPathComponent:fileRecord.key];
                                        }

                                        if ([fm fileExistsAtPath:tarAppPath]) {
                                            [fm removeItemAtPath:tarAppPath error:nil];
                                        }
                                        if ([fm copyItemAtPath:appPath toPath:tarAppPath error:nil]) {
                                            [IMBBaseClone reCaculateRecordHash:fileRecord backupFolderPath:_targetBakcuppath];
                                            int64_t fileSize = [IMBUtilTool fileSizeAtPath:appPath];
                                            [fileRecord changeFileLength:fileSize];
                                            [_targetrecordArray addObject:fileRecord];
                                        }
                                    }
                                }else {
                                    [_targetrecordArray addObject:fileRecord];
                                }
                                [addArray addObject:fileRecord];
                            }
                        }
                    }
                }
            }
        }
        //修改manifest
        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
            [self deleteRecords:deleteArray TargetDB:_targetManifestDBConnection];
            [self addRecords:addArray sourceDB:_sourceManifestDBConnection TargetDB:_targetManifestDBConnection sourceVersion:_sourceFloatVersion];
        }else{
            [IMBBaseClone saveMBDB:_targetrecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"hightManifest.mbdb"] backupFolderPath:_targetBakcuppath];
        }
    }
}

- (void)merge {
    [_logHandle writeInfoLog:@"merge app start"];
    NSMutableArray *recordArray = _targetrecordArray;
    NSMutableArray *deleteArray = [NSMutableArray array];
    NSMutableArray *addArray = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (_sourceApp != nil && _sourceApp.count > 0) {
        for (IMBAppEntity *entity in _sourceApp) {
            BOOL isExite = NO;
            for (IMBAppEntity *tarEntity in _targetApp) {
                if ([tarEntity.appKey isEqualToString:entity.appKey]) {
                    isExite = YES;
                    break;
                }
            }
            if (!isExite) {
                continue;
            }
            //先要删除目标设备中对应的AppDomain
            for (IMBMBFileRecord *tarFr in _targetAppDomain) {
                NSString *appDomain = [NSString stringWithFormat:@"AppDomain-%@",entity.appKey];
                if ([tarFr.domain isEqualToString:appDomain]) {
                    [recordArray removeObject:tarFr];
                    [deleteArray addObject:tarFr];
                }else if (entity.groupArray != nil && entity.groupArray.count > 0) {
                    for (NSString *groupKey in entity.groupArray) {
                        NSString *groupAppDomain = [NSString stringWithFormat:@"AppDomainGroup-%@",groupKey];
                        if ([tarFr.domain isEqualToString:groupAppDomain]) {
                            [recordArray removeObject:tarFr];
                            [deleteArray addObject:tarFr];
                        }
                    }
                }
            }
            //在增加原设备中对应的AppDomain
            for (IMBMBFileRecord *fileRecord in _sourceAppDomain) {
                @autoreleasepool {
                    NSString *appDomain = [NSString stringWithFormat:@"AppDomain-%@",entity.appKey];
                    if ([fileRecord.domain isEqualToString:appDomain]) {
                        if (fileRecord.filetype == FileType_Backup) {
                            NSString *fkey = [fileRecord.key substringWithRange:NSMakeRange(0, 2)];
                            NSString *appPath = nil;
                            if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                                NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                                appPath = [folderPath stringByAppendingPathComponent:fileRecord.key];
                            }else{
                                appPath = [_sourceBackuppath stringByAppendingPathComponent:fileRecord.key];
                            }

                            if ([fm fileExistsAtPath:appPath]) {
                                NSString *tarAppPath = nil;
                                if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                                    NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                                    if (![fm fileExistsAtPath:folderPath]) {
                                        [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                                    }
                                    tarAppPath = [folderPath stringByAppendingPathComponent:fileRecord.key];
                                }else{
                                    tarAppPath = [_targetBakcuppath stringByAppendingPathComponent:fileRecord.key];
                                }

                                if ([fm fileExistsAtPath:tarAppPath]) {
                                    [fm removeItemAtPath:tarAppPath error:nil];
                                }
                                if ([fm copyItemAtPath:appPath toPath:tarAppPath error:nil]) {
                                    int64_t fileSize = [IMBUtilTool fileSizeAtPath:appPath];
                                    [fileRecord changeFileLength:fileSize];
                                    [IMBBaseClone reCaculateRecordHash:fileRecord backupFolderPath:_targetBakcuppath];
                                    [recordArray addObject:fileRecord];
                                }
                            }
                        }else {
                            [recordArray addObject:fileRecord];
                        }
                        [addArray addObject:fileRecord];
                    }else if (entity.groupArray != nil && entity.groupArray.count > 0) {
                        for (NSString *groupKey in entity.groupArray) {
                            NSString *groupAppDomain = [NSString stringWithFormat:@"AppDomainGroup-%@",groupKey];
                            if ([fileRecord.domain isEqualToString:groupAppDomain]) {
                                if (fileRecord.filetype == FileType_Backup) {
                                    NSString *fkey = [fileRecord.key substringWithRange:NSMakeRange(0, 2)];
                                    NSString *appPath = nil;
                                    if ([_sourceFloatVersion isVersionMajorEqual:@"10"]) {
                                        NSString *folderPath = [_sourceBackuppath stringByAppendingPathComponent:fkey];
                                        appPath = [folderPath stringByAppendingPathComponent:fileRecord.key];
                                    }else{
                                        appPath = [_sourceBackuppath stringByAppendingPathComponent:fileRecord.key];
                                    }
                                    if ([fm fileExistsAtPath:appPath]) {
                                        NSString *tarAppPath = nil;
                                        if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
                                            NSString *folderPath = [_targetBakcuppath stringByAppendingPathComponent:fkey];
                                            if (![fm fileExistsAtPath:folderPath]) {
                                                [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                                            }
                                            tarAppPath = [folderPath stringByAppendingPathComponent:fileRecord.key];
                                        }else{
                                            tarAppPath = [_targetBakcuppath stringByAppendingPathComponent:fileRecord.key];
                                        }

                                        if ([fm fileExistsAtPath:tarAppPath]) {
                                            [fm removeItemAtPath:tarAppPath error:nil];
                                        }
                                        if ([fm copyItemAtPath:appPath toPath:tarAppPath error:nil]) {
                                            [IMBBaseClone reCaculateRecordHash:fileRecord backupFolderPath:_targetBakcuppath];
                                            int64_t fileSize = [IMBUtilTool fileSizeAtPath:appPath];
                                            [fileRecord changeFileLength:fileSize];
                                            [recordArray addObject:fileRecord];
                                        }
                                    }
                                }else {
                                    [recordArray addObject:fileRecord];
                                }
                                [addArray addObject:fileRecord];
                            }
                        }
                    }
                }
            }
        }
    }
    //修改manifest
    if ([_targetFloatVersion isVersionMajorEqual:@"10"]) {
        [self deleteRecords:deleteArray TargetDB:_targetManifestDBConnection];
        [self addRecords:addArray sourceDB:_sourceManifestDBConnection TargetDB:_targetManifestDBConnection sourceVersion:_sourceFloatVersion];
    }else{
        [IMBBaseClone saveMBDB:recordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"hightManifest.mbdb"] backupFolderPath:_targetBakcuppath];
    }
    [_logHandle writeInfoLog:@"merge app end"];
}

- (void)toDevice {
    if (_targetApp.count > 0) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSMutableArray *appDomainArray = [[NSMutableArray alloc] init];
        for (IMBAppEntity *entity in _targetApp) {
            for (IMBMBFileRecord *fileRecord in _sourceAppDomain) {
                NSString *appDomain = [NSString stringWithFormat:@"AppDomain-%@",entity.appKey];
                if ([fileRecord.domain isEqualToString:appDomain]) {
                    if (fileRecord.filetype == FileType_Backup) {
                        NSString *appPath = [_sourceBackuppath stringByAppendingPathComponent:fileRecord.key];
                        if ([fm fileExistsAtPath:appPath]) {
                            NSString *tarAppPath = [_targetBakcuppath stringByAppendingPathComponent:fileRecord.key];
                            if ([fm fileExistsAtPath:tarAppPath]) {
                                [fm removeItemAtPath:tarAppPath error:nil];
                            }
                            if ([fm copyItemAtPath:appPath toPath:tarAppPath error:nil]) {
                                [IMBBaseClone reCaculateRecordHash:fileRecord backupFolderPath:_targetBakcuppath];
                                [appDomainArray addObject:fileRecord];
                                NSLog(@"fileRecord domain:%@",fileRecord.domain);
                                NSLog(@"fileRecord path:%@",fileRecord.path);
                                NSLog(@"fileRecord key:%@",fileRecord.key);
                                NSLog(@"----------------------------");
                            }
                        }
                    }else {
                        [appDomainArray addObject:fileRecord];
                        NSLog(@"fileRecord domain:%@",fileRecord.domain);
                        NSLog(@"fileRecord path:%@",fileRecord.path);
                        NSLog(@"fileRecord key:%@",fileRecord.key);
                        NSLog(@"----------------------------");
                    }
                }else if (entity.groupArray != nil && entity.groupArray.count > 0) {
                    NSLog(@"fileRecord.domain:%@",fileRecord.domain);
                    for (NSString *groupKey in entity.groupArray) {
                        NSLog(@"groepkey:%@",groupKey);
                        NSString *groupAppDomain = [NSString stringWithFormat:@"AppDomainGroup-%@",groupKey];
                        if ([fileRecord.domain isEqualToString:groupAppDomain]) {
                            if (fileRecord.filetype == FileType_Backup) {
                                NSString *appPath = [_sourceBackuppath stringByAppendingPathComponent:fileRecord.key];
                                if ([fm fileExistsAtPath:appPath]) {
                                    NSString *tarAppPath = [_targetBakcuppath stringByAppendingPathComponent:fileRecord.key];
                                    if ([fm fileExistsAtPath:tarAppPath]) {
                                        [fm removeItemAtPath:tarAppPath error:nil];
                                    }
                                    if ([fm copyItemAtPath:appPath toPath:tarAppPath error:nil]) {
                                        [IMBBaseClone reCaculateRecordHash:fileRecord backupFolderPath:_targetBakcuppath];
                                        [appDomainArray addObject:fileRecord];
                                    }
                                }
                            }else {
                                [appDomainArray addObject:fileRecord];
                            }
                        }
                    }
                }
            }
        }
        
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"appdomain conut:%d",appDomainArray.count]];
        //排序
        NSArray *sortedArray = [appDomainArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[(IMBMBFileRecord *)obj1 path] compare:[(IMBMBFileRecord *)obj2 path]  options:NSCaseInsensitiveSearch];
        }];
        //修改manifest
        [IMBBaseClone saveMBDB:sortedArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"hightManifest.mbdb"] backupFolderPath:_targetBakcuppath];
        [appDomainArray release];
        appDomainArray = nil;
    }
}

- (void)dealloc
{
    [_sourceAppDomain release],_sourceAppDomain = nil;
    [_targetAppDomain release],_targetAppDomain = nil;
    [super dealloc];
}

@end

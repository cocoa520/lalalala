//
//  IMBExactDeviceDBFiles.m
//  iMobieTrans
//
//  Created by apple on 8/12/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBExtractDeviceDBFiles.h"
#import "IMBSession.h"
@implementation IMBExtractDeviceDBFiles
@synthesize nativeDbPath = _nativeDbPath;
@synthesize isMediaLibraryExist = _isMediaLibraryExist;

- (id)initWithToIpod:(IMBiPod *)toIpod extractType:(ExtractType)extractType{
    if (self = [super init]) {
        _toIPod = [toIpod retain];
        _extractType = extractType;
        _tmpFolder = @"";
        [self createLocalTempFolder];
        _logHandle = [IMBLogManager singleton];
        _DBPaths = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)getDBFilePath{
    if (_DBPaths.count > 0) {
        [_DBPaths removeAllObjects];
    }
    switch (_extractType) {
        case MediaLibrary:
            [_DBPaths setObject:@"" forKey:@"/iTunes_Control/iTunes/MediaLibrary.sqlitedb"];
            [_DBPaths setObject:@"" forKey:@"/iTunes_Control/iTunes/MediaLibrary.sqlitedb-shm"];
            [_DBPaths setObject:@"" forKey:@"/iTunes_Control/iTunes/MediaLibrary.sqlitedb-wal"];
            break;
        case iTunesCDB:
            break;
        case BooksType:
            [_DBPaths setObject:@"" forKey:@"/Books/Photos.sqlite"];
            [_DBPaths setObject:@"" forKey:@"/Books/Photos.sqlite-shm"];
            [_DBPaths setObject:@"" forKey:@"/Books/Photos.sqlite-wal"];
            break;
        case PhotoData:
            [_DBPaths setObject:@"" forKey:@"/PhotoData/Photos.sqlite"];
            [_DBPaths setObject:@"" forKey:@"/PhotoData/Photos.sqlite-shm"];
            [_DBPaths setObject:@"" forKey:@"/PhotoData/Photos.sqlite-wal"];
            break;
        default:
            break;
    }
}

- (void)startExtract{
    if (_toIPod == nil) {
        _toIPod.mediaDBPath = nil;
        return;
    }
    [self getDBFilePath];
    if (_DBPaths.count == 0) {
        return;
    }
    _deviceName = [_toIPod.deviceInfo.deviceName retain];
    NSString *checkpath = [_DBPaths.allKeys objectAtIndex:0];
    if (![self checkDeviceDBFile:checkpath]) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Device Name:%@ ,MediaLibrary.sqlitedb not exist",_deviceName]];
        if (_extractType == MediaLibrary) {
            _isMediaLibraryExist = false;
        }
        return;
    }
    if (_extractType == MediaLibrary) {
        _isMediaLibraryExist = true;
    }
    [self copyFilesToTempFolder:_tmpFolder];
    if (_DBPaths.allValues != nil) {
        NSArray *dbLists = _DBPaths.allValues;
        if (dbLists != nil && dbLists.count > 0) {
            self.nativeDbPath = [dbLists objectAtIndex:0];
        }
    }
    if (_extractType == MediaLibrary) {
        _toIPod.mediaDBPath = _nativeDbPath;
    }
}


- (void)copyFilesToTempFolder:(NSString *)folderpath{
    BOOL result = YES;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *pathPairs = [[NSMutableDictionary alloc] init];
    for (int i = 0;i < _DBPaths.allKeys.count; i++) {
        NSString *item = [_DBPaths.allKeys objectAtIndex:i];
        NSString *fileName = item.lastPathComponent;
        NSString *localPath = [folderpath stringByAppendingPathComponent:fileName];
        result = [self deleteTempFile:localPath];
        if (!result) {
            break;
        }
        else{
            if ([_DBPaths.allKeys containsObject:item]) {
                [pathPairs setObject:localPath forKey:item];
            }
        }
    }
    _DBPaths = [pathPairs retain];
    if (result) {
        for (NSString *item in _DBPaths.allKeys) {
            if ([_toIPod.fileSystem fileExistsAtPath:item]) {
                [_toIPod.fileSystem copyRemoteFile:item toLocalFile:[_DBPaths objectForKey:item]];
            }
        }
    }
    else{
        long folderValue = [self getChildeFolder:folderpath];
        NSString *folderNewPath = [folderpath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",folderValue]];
        if (![fm fileExistsAtPath:folderNewPath]) {
            [fm createDirectoryAtPath:folderNewPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [self copyFilesToTempFolder:folderNewPath];
    }
    [pathPairs release];
}

- (BOOL)deleteTempFile:(NSString *)path{
    BOOL result = true;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        @try {
            [fm removeItemAtPath:path error:nil];
            result = true;
        }
        @catch (NSException *exception) {
            result = false;
        }
    }
    return result;
}

- (BOOL)checkDeviceDBFile:(NSString *)path{
    if ([_toIPod.fileSystem fileExistsAtPath:path]) {
        return true;
    }
    return false;
}

- (void)createLocalTempFolder{
    _tmpFolder = [[_toIPod session] sessionFolderPath];
    _tmpFolder = [[_tmpFolder stringByAppendingPathComponent:@"DataBase"] retain];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:_tmpFolder]) {
        NSError *error;
        [fm createDirectoryAtPath:_tmpFolder withIntermediateDirectories:YES attributes:nil error:&error];
    }
}


- (long)getChildeFolder:(NSString *)folderPath{
    long folderName = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    NSArray *array = [fm subpathsOfDirectoryAtPath:folderPath error:&error];
    if (array == nil || array.count == 0) {
        folderName = 1;
    }
    else{
        int maxValue = 0;
        for (NSString *folderNameStr in array) {
            int value = [folderNameStr intValue];
            if (maxValue < value) {
                maxValue = value;
            }
        }
        @try {
            folderName = maxValue + 1;
        }
        @catch (NSException *exception) {
            NSDateFormatter *formater = [[NSDateFormatter alloc] initWithDateFormat:@"yyyyMMddHHMMss" allowNaturalLanguage:NO];
            NSString *string = [formater stringFromDate:[NSDate date]];
            folderName = [string intValue];
        }
    }
    return folderName;
}

- (void)dealloc{
    if (_toIPod != nil) {
        [_toIPod release];
        _toIPod = nil;
    }
    
    if (_deviceName != nil) {
        [_deviceName release];
        _deviceName = nil;
    }
    
    if (_tmpFolder != nil) {
        [_tmpFolder release];
        _tmpFolder = nil;
    }
    
    if (_DBPaths != nil) {
        [_DBPaths release];
        _DBPaths = nil;
    }
    
    if (_nativeDbPath != nil) {
        [_nativeDbPath release];
        _DBPaths = nil;
    }
    
    [super dealloc];
    
}

@end

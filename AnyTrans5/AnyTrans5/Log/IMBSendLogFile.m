//
//  IMBSendLogFile.m
//  iMobieTrans
//
//  Created by Pallas on 7/30/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSendLogFile.h"
#import "IMBSoftWareInfo.h"
#import "TempHelper.h"
#import "StringHelper.h"
#import "IMBDeviceConnection.h"
#import "IMBHelper.h"
@implementation IMBSendLogFile
@synthesize sendLogZipPath = _sendLogZipPath;

- (id)init {
    self = [super init];
    if (self) {
        _logFolderPath = [[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"LogFile"] retain];
        _sendLogZipPath = [[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"LogFile.zip"] retain];
        fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:_logFolderPath]) {
            [fm createDirectoryAtPath:_logFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        logHandle = [IMBLogManager singleton];
        _deviceConnection = [IMBDeviceConnection singleton];
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:10];
    }
    return self;
}

- (void)dealloc {
    if (_logFolderPath != nil) {
        [_logFolderPath release];
        _logFolderPath = nil;
    }
    if (_sendLogZipPath != nil) {
        [_sendLogZipPath release];
        _sendLogZipPath = nil;
    }
    [super dealloc];
}

- (void)sendLogFile {
    //    NSBlockOperation * ope1 = [NSBlockOperation blockOperationWithBlock:^{
    // 先拷贝Itl文件到临时日志目录中去
    [self copyItlFileToFolder];
    
    [logHandle writeInfoLog:@"--------- SoftWare Info ---------"];
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    if (bundleDic != nil && bundleDic.allKeys.count > 0) {
        NSArray *allKeys = [bundleDic allKeys];
        if ([allKeys containsObject:@"CFBundleDevelopmentRegion"]) {
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Software Development Region is %@", [bundleDic objectForKey:@"CFBundleDevelopmentRegion"]]];
        }
        if ([allKeys containsObject:@"CFBundleIdentifier"]) {
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Software Identifier is %@", [bundleDic objectForKey:@"CFBundleIdentifier"]]];
        }
        if ([allKeys containsObject:@"CFBundleName"]) {
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Software Name is %@", [bundleDic objectForKey:@"CFBundleName"]]];
        }
        if ([allKeys containsObject:@"CFBundleShortVersionString"]) {
            NSString *softwareVersion = nil;
            NSString *maxVersion = [bundleDic objectForKey:@"CFBundleShortVersionString"];
            NSString *minVersion = @"0";
            if ([allKeys containsObject:@"CFBundleVersion"]) {
                minVersion =  [bundleDic objectForKey:@"CFBundleVersion"];
            }
            softwareVersion = [NSString stringWithFormat:@"%@.%@", maxVersion, minVersion];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Software Version is %@", softwareVersion]];
        }
        if ([allKeys containsObject:@"LSMinimumSystemVersion"]) {
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Software MinimumSystemVersion is %@", [bundleDic objectForKey:@"LSMinimumSystemVersion"]]];
        }
    }
    [logHandle writeInfoLog:@"--------- IMBSofeWare Info ---------"];
    IMBSoftWareInfo *softInfo = [IMBSoftWareInfo singleton];
    
    [logHandle writeInfoLog:[NSString stringWithFormat:@"Software build Date is %@", softInfo.buildDate]];
    
    [logHandle writeInfoLog:[NSString stringWithFormat:@"Software Registered is %@", softInfo.isRegistered ? @"YES":@"NO" ]];
    
    [logHandle writeInfoLog:@"--------- System Info ---------"];
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    [logHandle writeInfoLog:[NSString stringWithFormat:@"OS SystemName is %@", processInfo.operatingSystemName]];
    [logHandle writeInfoLog:[NSString stringWithFormat:@"OS SystemVersion is %@", processInfo.operatingSystemVersionString]];
    [logHandle writeInfoLog:[NSString stringWithFormat:@"OS PhysicalMemory is %lld", processInfo.physicalMemory]];
    NSDictionary * fsattrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/" error:nil];
    uint64_t diskSize = [[fsattrs objectForKey:NSFileSystemSize] unsignedLongLongValue];
    [logHandle writeInfoLog:[NSString stringWithFormat:@"Disk TotalSize is %@", [StringHelper getFileSizeString:diskSize reserved:2]]];
    uint64_t diskFreeSize = [[fsattrs objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    [logHandle writeInfoLog:[NSString stringWithFormat:@"Disk FreeSize is %@", [StringHelper getFileSizeString:diskFreeSize reserved:2]]];
    [logHandle writeInfoLog:[NSString stringWithFormat:@"Current User is %@", [NSHomeDirectory() lastPathComponent]]];
    
    // 如果有设备连接进来就将设备的信息发送回来
    NSArray *ipods = [_deviceConnection getConnectedIPods];
    if (ipods != nil && ipods.count > 0) {
        // 如果IPod不为空,则备份设备中的有用文件到日志目录中去
        for (IMBiPod*ipod in ipods) {
            [logHandle writeInfoLog:@"--------- iPod Device Info ---------"];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Name is %@", ipod.deviceInfo.deviceName]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"SerialNumber is %@", ipod.deviceInfo.serialNumber]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"SerialNumberForHashing is %@", ipod.deviceInfo.serialNumberForHashing]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Family is %@", ipod.deviceInfo.getIPodFamilyString]];
            [logHandle writeErrorLog:[NSString stringWithFormat:@"ProductType is %@", ipod.deviceInfo.productType]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"IOS Version is %@", ipod.deviceInfo.productVersion]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"AirSync is %@", (ipod.deviceInfo.airSync ? @"YES": @"NO")]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Jailbreaked is %@", (ipod.deviceInfo.isJailbreak ? @"YES": @"NO")]];
            
            [self readDBToFolderWithIPod:ipod];
        }
    }
    
    //如果有android设备连接进来就将设备的信息发送回来
    for (IMBBaseInfo *baseInfo in _deviceConnection.allDevice) {
        if (baseInfo.connectType == general_Android) {
            [logHandle writeInfoLog:@"--------- android Device Info ---------"];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Name is %@", baseInfo.deviceName]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"SerialNumber is %@", baseInfo.uniqueKey]];
            if ([softInfo.deviceArray count] > 0) {
                [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Manufacturer is %@", [softInfo.deviceArray objectAtIndex:2]]];
                [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Model is %@", [softInfo.deviceArray objectAtIndex:1]]];
                [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Version is %@", [softInfo.deviceArray objectAtIndex:0]]];
            }
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Total Size is %lld", baseInfo.allDeviceSize]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Available Size is %lld", baseInfo.kyDeviceSize]];
        }
    }
    
    // 拷贝IMBSoftware-Info.plist到日志的临时目录中去
    NSString *softwareInfoPath = [[TempHelper getAppSupportPath] stringByAppendingPathComponent:@"IMBSoftware-Info.plist"];
    if ([fm fileExistsAtPath:softwareInfoPath]) {
        [fm copyItemAtPath:softwareInfoPath toPath:[_logFolderPath stringByAppendingPathComponent:@"IMBSoftware-Info.plist"] error:nil];
    }
    
    //    }];
    
    //     NSBlockOperation * ope2 = [NSBlockOperation blockOperationWithBlock:^{
    // 拷贝日志到日志临时目录去
    [self copyLogFileToFolder];
    
    //拷贝airbackup log
    [self copyAirBackupLogFileToFolder];
    
    // 打包该目录到临时目录中去
    [IMBZipHelper zipByPath:_sendLogZipPath localPath:_logFolderPath];
    if ([fm fileExistsAtPath:_logFolderPath]) {
        [fm removeItemAtPath:_logFolderPath error:nil];
    }
    //     }];
    
    //    NSBlockOperation * ope3 = [NSBlockOperation blockOperationWithBlock:^{
    // 打包该目录到临时目录中去
    [IMBZipHelper zipByPath:_sendLogZipPath localPath:_logFolderPath];
    if ([fm fileExistsAtPath:_logFolderPath]) {
        [fm removeItemAtPath:_logFolderPath error:nil];
    }
    //    }];
    
    //    [ope2 addDependency:ope1];
    //    [ope3 addDependency:ope2];
    
    //    [queue addOperation: ope1];
    //    [queue addOperation: ope2];
    //    [queue addOperation: ope3];
}

// 拷贝日志文件夹临时日志目录中去
- (void)copyLogFileToFolder {
    NSString *logsFolderPath = logHandle.logsFolderPath;
    if (![StringHelper stringIsNilOrEmpty:logsFolderPath] && [fm fileExistsAtPath:logsFolderPath]) {
        NSArray *logs = [fm contentsOfDirectoryAtPath:logsFolderPath error:nil];
        if (logs != nil && logs.count > 0) {
            NSString *targetFolderPath = [_logFolderPath stringByAppendingPathComponent:logsFolderPath.lastPathComponent];
            if (![fm fileExistsAtPath:targetFolderPath]) {
                [fm createDirectoryAtPath:targetFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            for (NSString *fn in logs) {
                NSString *sorceFilePath = [logsFolderPath stringByAppendingPathComponent:fn];
                NSString *targetFilePath = [targetFolderPath stringByAppendingPathComponent:fn];
                [fm copyItemAtPath:sorceFilePath toPath:targetFilePath error:nil];
            }
        }
    }
}


// 拷贝日志文件夹临时日志目录中去
- (void)copyAirBackupLogFileToFolder {
    NSString *logsFolderPath = [[IMBHelper getBackupServerSupportPath] stringByAppendingPathComponent:@"LogsFolder"];
    if (![StringHelper stringIsNilOrEmpty:logsFolderPath] && [fm fileExistsAtPath:logsFolderPath]) {
        NSArray *logs = [fm contentsOfDirectoryAtPath:logsFolderPath error:nil];
        if (logs != nil && logs.count > 0) {
            NSString *targetFolderPath = [_logFolderPath stringByAppendingPathComponent:@"AirBackupLogs"];
            if (![fm fileExistsAtPath:targetFolderPath]) {
                [fm createDirectoryAtPath:targetFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            for (NSString *fn in logs) {
                NSString *sorceFilePath = [logsFolderPath stringByAppendingPathComponent:fn];
                NSString *targetFilePath = [targetFolderPath stringByAppendingPathComponent:fn];
                [fm copyItemAtPath:sorceFilePath toPath:targetFilePath error:nil];
            }
        }
    }
}


- (void)copyItlFileToFolder {
    NSString *itlFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Music/iTunes/iTunes Library.itl"];
    NSString *tagFilePath = [_logFolderPath stringByAppendingPathComponent:@"iTunes Library.itl"];
    if ([fm fileExistsAtPath:itlFilePath]) {
        [fm copyItemAtPath:itlFilePath toPath:tagFilePath error:nil];
    }
}

- (void)readDBToFolderWithIPod:(IMBiPod*)ipod {
    NSString *directoryFolder = [_logFolderPath stringByAppendingPathComponent:ipod.deviceInfo.deviceName];
    if (![fm fileExistsAtPath:directoryFolder]) {
        [fm createDirectoryAtPath:directoryFolder withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        [fm removeItemAtPath:directoryFolder error:nil];
        [fm createDirectoryAtPath:directoryFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    _dbFileDictionary = [[[IMBDBFileBackup singleton] getBackupFileName] retain];
    [self readiTunesCDBToFolderWithIPod:ipod directoryFolderPath:directoryFolder];
    [self readiTunesDBToFolderWithIPod:ipod directoryFolderPath:directoryFolder];
    [self readIOS5SqliteDBToFolderWithIPod:ipod directoryFolderPath:directoryFolder];
    [self readArtworkDBToFolderWithIPod:ipod directoryFolderPath:directoryFolder];
    [self readRingtoneToFolderWithIPod:ipod directoryFolderPath:directoryFolder];
    [self readiTunesSDToFolderWithIPod:ipod directoryFolderPath:directoryFolder];
    [self readSqliteDBToFolderWithIPod:ipod directoryFolderPath:directoryFolder];
    [self readiBooksToFolderWithIPod:ipod directoryFolderPath:directoryFolder];
    [_dbFileDictionary release];
    _dbFileDictionary = nil;
    
    NSString *deviceFolderPath = [ipod.fileSystem.driveLetter stringByAppendingPathComponent:@"Purchases"];
    //[self readPurchasesFileToFolderWithIPod:ipod deviceFolderPath:deviceFolderPath folderName:@"Purchases" directoryFolderPath:directoryFolder];
    deviceFolderPath = ipod.fileSystem.iTunesFolderPath;
    [self readPlayCountsAndContainPlaylistFileToFolderWithIPod:ipod deviceFolderPath:deviceFolderPath folderName:deviceFolderPath directoryFolderPath:directoryFolder];
}

- (void)readiTunesCDBToFolderWithIPod:(IMBiPod*)ipod directoryFolderPath:(NSString *)directoryFolderPath {
    NSArray *fileNameList = [_dbFileDictionary objectForKey:[NSNumber numberWithInt:Backup_iTunesCDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        [self copyFileToPcFolder:fileNameList folderPath:folderPath pcFolderPath:directoryFolderPath ipod:ipod];
    }
}

- (void)readIOS5SqliteDBToFolderWithIPod:(IMBiPod*)ipod directoryFolderPath:(NSString *)directoryFolderPath {
    NSArray *fileNameList = [_dbFileDictionary objectForKey:[NSNumber numberWithInt:Backup_IOS5SqliteDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        [self copyFileToPcFolder:fileNameList folderPath:folderPath pcFolderPath:directoryFolderPath ipod:ipod];
    }
}

- (void)readArtworkDBToFolderWithIPod:(IMBiPod*)ipod directoryFolderPath:(NSString *)directoryFolderPath {
    NSArray *fileNameList = [_dbFileDictionary objectForKey:[NSNumber numberWithInt:Backup_ArtworkDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        [self copyFileToPcFolder:fileNameList folderPath:folderPath pcFolderPath:directoryFolderPath ipod:ipod];
    }
}

- (void)readiTunesDBToFolderWithIPod:(IMBiPod*)ipod directoryFolderPath:(NSString *)directoryFolderPath {
    NSArray *fileNameList = [_dbFileDictionary objectForKey:[NSNumber numberWithInt:Backup_iTunesDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        [self copyFileToPcFolder:fileNameList folderPath:folderPath pcFolderPath:directoryFolderPath ipod:ipod];
    }
}

- (void)readRingtoneToFolderWithIPod:(IMBiPod*)ipod directoryFolderPath:(NSString *)directoryFolderPath {
    NSArray *fileNameList = [_dbFileDictionary objectForKey:[NSNumber numberWithInt:Backup_Ringtone]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        [self copyFileToPcFolder:fileNameList folderPath:folderPath pcFolderPath:directoryFolderPath ipod:ipod];
    }
}

- (void)readiTunesSDToFolderWithIPod:(IMBiPod*)ipod directoryFolderPath:(NSString *)directoryFolderPath {
    NSArray *fileNameList = [_dbFileDictionary objectForKey:[NSNumber numberWithInt:Backup_iTunesSD]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        [self copyFileToPcFolder:fileNameList folderPath:folderPath pcFolderPath:directoryFolderPath ipod:ipod];
    }
}

- (void)readSqliteDBToFolderWithIPod:(IMBiPod*)ipod directoryFolderPath:(NSString *)directoryFolderPath {
    NSArray *fileNameList = [_dbFileDictionary objectForKey:[NSNumber numberWithInt:Backup_SqlitDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        NSString *sourceDBPath = [folderPath stringByAppendingPathComponent:@"iTunes Library.itlp"];
        if ([ipod.fileSystem fileExistsAtPath:sourceDBPath]) {
            NSString *itlpFolderPath = [directoryFolderPath stringByAppendingPathComponent:@"iTunes Library.itlp"];
            if (![fm fileExistsAtPath:itlpFolderPath]) {
                [fm createDirectoryAtPath:itlpFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [self copyFileToPcFolder:fileNameList folderPath:sourceDBPath pcFolderPath:itlpFolderPath ipod:ipod];
        }
    }
}

- (void)readiBooksToFolderWithIPod:(IMBiPod*)ipod directoryFolderPath:(NSString *)directoryFolderPath {
    NSArray *fileNameList = [_dbFileDictionary objectForKey:[NSNumber numberWithInt:Backup_iBooks]];
    NSString *folderPath = [ipod.fileSystem.driveLetter stringByAppendingPathComponent:@"Books"];
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        NSString *booksFolderPath = [directoryFolderPath stringByAppendingPathComponent:@"Books"];
        if (![fm fileExistsAtPath:booksFolderPath]) {
            [fm createDirectoryAtPath:booksFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [self copyFileToPcFolder:fileNameList folderPath:folderPath pcFolderPath:booksFolderPath ipod:ipod];
    }
}

- (void)copyFileToPcFolder:(NSArray *)fileNameList folderPath:(NSString *)folderPath pcFolderPath:(NSString *)pcFolderPath ipod:(IMBiPod*)ipod {
    if (![StringHelper stringIsNilOrEmpty:folderPath] && ![StringHelper stringIsNilOrEmpty:pcFolderPath]) {
        NSString *fileSourcePath = nil;
        NSString *fileTargetPath = nil;
        for (NSString *fn in fileNameList) {
            fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
            fileTargetPath = [pcFolderPath stringByAppendingPathComponent:fn];
            if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                [ipod.fileSystem copyRemoteFile:fileSourcePath toLocalFile:fileTargetPath];
            }
        }
    }
}

- (void)readPurchasesFileToFolderWithIPod:(IMBiPod*)ipod deviceFolderPath:(NSString *)deviceFolderPath folderName:(NSString *)folderName directoryFolderPath:(NSString *)directoryFolderPath {
    NSString *cacheFolder = [directoryFolderPath stringByAppendingPathComponent:folderName];
    NSString *cacheFilePath = nil;
    if ([ipod.fileSystem fileExistsAtPath:deviceFolderPath]) {
        NSArray *subItems = [ipod.fileSystem getItemInDirectory:deviceFolderPath];
        if (subItems != nil && subItems.count > 0) {
            if (![fm fileExistsAtPath:cacheFolder]) {
                [fm createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
            }
            for (AMFileEntity *file in subItems) {
                if (file.FileType == AMDirectory) {
                    if ([file.FilePath isEqualToString:[NSString stringWithFormat:@"%@/", deviceFolderPath]] || [file.FilePath isEqualToString:deviceFolderPath]) {
                        continue;
                    }
                    [self readPurchasesFileToFolderWithIPod:ipod deviceFolderPath:file.FilePath folderName:file.Name directoryFolderPath:cacheFolder];
                } else  {
                    cacheFilePath = [cacheFolder stringByAppendingPathComponent:file.Name];
                    [ipod.fileSystem copyRemoteFile:file.FilePath toLocalFile:cacheFilePath];
                }
            }
        }
    }
}

- (void)readPlayCountsAndContainPlaylistFileToFolderWithIPod:(IMBiPod*)ipod deviceFolderPath:(NSString *)deviceFolderPath folderName:(NSString *)folderName directoryFolderPath:(NSString *)directoryFolderPath {
    if ([folderName hasPrefix:@"/"]) {
        folderName = [folderName substringFromIndex:1];
    }
    NSString *cacheFolder = [directoryFolderPath stringByAppendingPathComponent:folderName];
    NSString *cacheFilePath = nil;
    if ([ipod.fileSystem fileExistsAtPath:deviceFolderPath]) {
        NSArray *subItems = [ipod.fileSystem getItemInDirectory:deviceFolderPath];
        if (subItems != nil && subItems.count > 0) {
            for (AMFileEntity *file in subItems) {
                if (file.FileType == AMDirectory) {
                    if ([[file.FilePath stringByStandardizingPath] isEqualToString:[deviceFolderPath stringByStandardizingPath]]) {
                        continue;
                    }
                    if (![[file.Name lowercaseString] isEqualToString:@"backup"] && ![[file.Name lowercaseString] isEqualToString:@"artwork"]) {
                        [self readPlayCountsAndContainPlaylistFileToFolderWithIPod:ipod deviceFolderPath:file.FilePath folderName:file.Name directoryFolderPath:cacheFolder];
                    }
                    
                } else  {
                    if ([file.Name.lowercaseString hasPrefix:@"playcounts"] ||
                        [file.Name.lowercaseString rangeOfString:@"playlist"].length > 0 ||
                        [file.Name.lowercaseString hasSuffix:@"cig"]) {
                        if (![fm fileExistsAtPath:cacheFolder]) {
                            [fm createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
                        }
                        cacheFilePath = [cacheFolder stringByAppendingPathComponent:file.Name];
                        [ipod.fileSystem copyRemoteFile:file.FilePath toLocalFile:cacheFilePath];
                    }
                }
            }
        }
    }
}

@end

//
//  IMBDBFileBackup.m
//  iMobieTrans
//
//  Created by Pallas on 7/23/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBDBFileBackup.h"

@implementation IMBDBFileBackup

- (id)init {
    if (self=[super init]) {
		nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
        filePathDic = [[NSMutableDictionary alloc] init];
        [self fillDicContent];
    }
	return self;
}

- (void)dealloc {
    if (nc != nil) {
        [nc removeObserver:self];
        nc = nil;
    }
    
    if (filePathDic != nil) {
        [filePathDic release];
        filePathDic = nil;
    }
    
    [super dealloc];
}

- (void)applicationWillTerminate:(NSNotification*)notification {
    // 处理程序销毁的时候要清理的内存
    [self dealloc];
}

// 单例实例化对象
+ (IMBDBFileBackup*)singleton {
    static IMBDBFileBackup *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBDBFileBackup alloc] init];
		}
	}
	return _singleton;
}

- (NSMutableDictionary *)getBackupFileName {
    if (filePathDic != nil && filePathDic.allKeys.count > 0) {
        return filePathDic;
    } else {
        [self fillDicContent];
        return filePathDic;
    }
}

- (void)fillDicContent {
    [filePathDic setObject:[NSArray arrayWithObjects:@"iTunesCDB", nil] forKey:[NSNumber numberWithInt:Backup_iTunesCDB]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"Dynamic.itdb", @"Extras.itdb", @"Genius.itdb", @"Library.itdb", @"Locations.itdb", @"Locations.itdb.cbk", nil] forKey:[NSNumber numberWithInt:Backup_SqlitDB]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"MediaLibrary.sqlitedb", @"MediaLibrary.sqlitedb-shm", @"MediaLibrary.sqlitedb-wal", nil] forKey:[NSNumber numberWithInt:Backup_IOS5SqliteDB]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"ArtworkDB", nil] forKey:[NSNumber numberWithInt:Backup_ArtworkDB]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"iTunesDB", nil] forKey:[NSNumber numberWithInt:Backup_iTunesDB]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"Ringtones.plist", nil] forKey:[NSNumber numberWithInt:Backup_Ringtone]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"iBooksData2.plist", @"iBooks.plist", @"Books.plist", nil] forKey:[NSNumber numberWithInt:Backup_iBooks]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"iBooksData2.plist", @"iBooks.plist", @"Books.plist", nil] forKey:[NSNumber numberWithInt:Backup_iBooks]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"iTunesSD", nil] forKey:[NSNumber numberWithInt:Backup_iTunesSD]];
    [filePathDic setObject:[NSArray arrayWithObjects:@"Photos.sqlite", @"Photos.sqlite-shm", @"Photos.sqlite-wal", @"changes", @"changes-shm", @"changes-wal", nil] forKey:[NSNumber numberWithInt:Backup_Photo]];
}

// 备份设备中的数据库文件方法
- (void)backupDBFileWithIPod:(IMBiPod *)ipod {
    @try {
        [self backupiTunesCDBWithIPod:ipod];
        [self backupSqliteDBWithIPod:ipod];
        [self backupiBooksWithIPod:ipod];
        [self backupPhotoWithIPod:ipod];
    } @catch (NSException *exception) {
    }
}

- (void)backupiTunesCDBWithIPod:(IMBiPod *)ipod {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_iTunesCDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        NSString *backupRoot = [folderPath stringByAppendingPathComponent:@"Backup"];
        if (![ipod.fileSystem fileExistsAtPath:backupRoot]) {
            [ipod.fileSystem mkDir:backupRoot];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        dateFormatter = nil;
        NSArray *fileItem = [ipod.fileSystem getItemInDirectory:backupRoot];        // 保存的是AMFileEntity对象
        NSMutableArray *backupList = [[NSMutableArray alloc] init];
        if (fileItem != nil && fileItem.count > 0) {
            for (AMFileEntity *item in fileItem) {
                if (item.FileType == AMDirectory) {
                    [backupList addObject:item];
                }
            }
        }
        if (backupList == nil || backupList.count <= 0) {
            dateTimeStr = [NSString stringWithFormat:@"%@-original", dateTimeStr];
        }
        
        NSString *checkBackupPath = [backupRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-original", dateTimeStr]];
        if (![ipod.fileSystem fileExistsAtPath:checkBackupPath]) {
            NSString *backupFolder = [backupRoot stringByAppendingPathComponent:dateTimeStr];
            if (![ipod.fileSystem fileExistsAtPath:backupFolder]) {
                [ipod.fileSystem mkDir:backupFolder];
                backupFolder = [self createDictoryWithIPod:ipod backupFolder:backupFolder fileRootPath:folderPath];
                if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
                    NSString *fileSourcePath = nil;
                    NSString *fileTargetPath = nil;
                    for (NSString *fn in fileNameList) {
                        fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
                        fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
                        if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                            [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
                        }
                    }
                }
                [self backupIOS5SqliteDBWithIPod:ipod backupFolder:backupFolder];
                [self backupArtworkDBWithIPod:ipod backupFolder:backupFolder];
                [self backupiTunesDBWithIPod:ipod backupFolder:backupFolder];
                [self backupRingtoneWithIPod:ipod backupFolder:backupFolder];
                [self backupiTunesSDWithIPod:ipod backupFolder:backupFolder];
                [self cleanOldDataWithIPod:ipod backupRoot:backupRoot];
            }
        }
        [backupList release];
        backupList = nil;
    }
}

- (void)backupIOS5SqliteDBWithIPod:(IMBiPod *)ipod backupFolder:(NSString *)backupFolder {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_IOS5SqliteDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
        NSString *fileSourcePath = nil;
        NSString *fileTargetPath = nil;
        for (NSString *fn in fileNameList) {
            fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
            fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
            if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
            }
        }
    }
}

- (void)backupArtworkDBWithIPod:(IMBiPod *)ipod backupFolder:(NSString *)backupFolder {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_ArtworkDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
        NSString *fileSourcePath = nil;
        NSString *fileTargetPath = nil;
        for (NSString *fn in fileNameList) {
            fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
            fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
            if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
            }
        }
    }
}

- (void)backupiTunesDBWithIPod:(IMBiPod *)ipod backupFolder:(NSString *)backupFolder {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_iTunesDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
        NSString *fileSourcePath = nil;
        NSString *fileTargetPath = nil;
        for (NSString *fn in fileNameList) {
            fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
            fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
            if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
            }
        }
    }
}

- (void)backupRingtoneWithIPod:(IMBiPod *)ipod backupFolder:(NSString *)backupFolder {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_Ringtone]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
        NSString *fileSourcePath = nil;
        NSString *fileTargetPath = nil;
        for (NSString *fn in fileNameList) {
            fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
            fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
            if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
            }
        }
    }
}

- (void)backupiTunesSDWithIPod:(IMBiPod *)ipod backupFolder:(NSString *)backupFolder {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_iTunesSD]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
        NSString *fileSourcePath = nil;
        NSString *fileTargetPath = nil;
        for (NSString *fn in fileNameList) {
            fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
            fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
            if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
            }
        }
    }
}

- (void)backupSqliteDBWithIPod:(IMBiPod *)ipod {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_SqlitDB]];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        NSString *backupRoot = [folderPath stringByAppendingPathComponent:@"Backup"];
        if (![ipod.fileSystem fileExistsAtPath:backupRoot]) {
            [ipod.fileSystem mkDir:backupRoot];
        }
        NSString *itunesFolderPath = [ipod.fileSystem.iTunesFolderPath substringFromIndex:[ipod.fileSystem.driveLetter stringByStandardizingPath].length];
        if ([ipod.fileSystem fileExistsAtPath:[folderPath stringByAppendingPathComponent:@"iTunes Library.itlp"]]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
            [dateFormatter release];
            dateFormatter = nil;
            NSString *checkBackupPath = [backupRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-original", dateTimeStr]];
            NSString *backupFolder = nil;
            if ([ipod.fileSystem fileExistsAtPath:checkBackupPath]) {
                backupFolder = [[checkBackupPath stringByAppendingPathComponent:itunesFolderPath]
                                stringByAppendingPathComponent:@"iTunes Library.itlp"];
            } else {
                backupFolder = [[[backupRoot stringByAppendingPathComponent:dateTimeStr]
                                 stringByAppendingPathComponent:itunesFolderPath]
                                stringByAppendingPathComponent:@"iTunes Library.itlp"];
            }
            
            if (![ipod.fileSystem fileExistsAtPath:backupFolder]) {
                [ipod.fileSystem mkDir:backupFolder];
                if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
                    NSString *fileSourcePath = nil;
                    NSString *fileTargetPath = nil;
                    NSString *sourceDBPath = [folderPath stringByAppendingPathComponent:@"iTunes Library.itlp"];
                    for (NSString *fn in fileNameList) {
                        fileSourcePath = [sourceDBPath stringByAppendingPathComponent:fn];
                        fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
                        if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                            [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
                        }
                    }
                }
                [self cleanOldDataWithIPod:ipod backupRoot:backupRoot];
                [self cleanOldDataWithIPod:ipod backupRoot:[[folderPath stringByAppendingPathComponent:@"iTunes Library.itlp"] stringByAppendingPathComponent:@"Backup"]];
            }
        }
    }
}

- (void)backupiBooksWithIPod:(IMBiPod *)ipod {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_iBooks]];
    NSString *folderPath = [ipod.fileSystem.driveLetter stringByAppendingPathComponent:@"Books"];
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        NSString *backupRoot = [folderPath stringByAppendingPathComponent:@"Backup"];
        if (![ipod.fileSystem fileExistsAtPath:backupRoot]) {
            [ipod.fileSystem mkDir:backupRoot];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        dateFormatter = nil;
        NSString *backupFolder = [backupRoot stringByAppendingPathComponent:dateTimeStr];
        if (![ipod.fileSystem fileExistsAtPath:backupFolder]) {
            [ipod.fileSystem mkDir:backupFolder];
            backupFolder = [self createDictoryWithIPod:ipod backupFolder:backupFolder fileRootPath:folderPath];
            if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
                NSString *fileSourcePath = nil;
                NSString *fileTargetPath = nil;
                for (NSString *fn in fileNameList) {
                    fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
                    fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
                    if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                        [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
                    }
                }
            }
            [self cleanOldDataWithIPod:ipod backupRoot:backupRoot];
        }
    }
}

- (void)backupPhotoWithIPod:(IMBiPod *)ipod {
    NSArray *fileNameList = [filePathDic objectForKey:[NSNumber numberWithInt:Backup_Photo]];
    NSString *folderPath = [ipod.fileSystem.driveLetter stringByAppendingPathComponent:@"PhotoData"];
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        NSString *backupRoot = [folderPath stringByAppendingPathComponent:@"Backup"];
        if (![ipod.fileSystem fileExistsAtPath:backupRoot]) {
            [ipod.fileSystem mkDir:backupRoot];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateTimeStr = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        dateFormatter = nil;
        NSString *backupFolder = [backupRoot stringByAppendingPathComponent:dateTimeStr];
        if (![ipod.fileSystem fileExistsAtPath:backupFolder]) {
            [ipod.fileSystem mkDir:backupFolder];
            backupFolder = [self createDictoryWithIPod:ipod backupFolder:backupFolder fileRootPath:folderPath];
            if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
                NSString *fileSourcePath = nil;
                NSString *fileTargetPath = nil;
                for (NSString *fn in fileNameList) {
                    fileSourcePath = [folderPath stringByAppendingPathComponent:fn];
                    fileTargetPath = [backupFolder stringByAppendingPathComponent:fn];
                    if ([ipod.fileSystem fileExistsAtPath:fileSourcePath]) {
                        [self backupFileWithIPod:ipod sourcePath:fileSourcePath targetPath:fileTargetPath];
                    }
                }
            }
            [self cleanOldDataWithIPod:ipod backupRoot:backupRoot];
        }
    }
}

- (void)cleanOldDataWithIPod:(IMBiPod *)ipod backupRoot:(NSString *)backupRoot {
    NSArray *fileItem = [ipod.fileSystem getItemInDirectory:backupRoot];        // 保存的是AMFileEntity对象
    NSMutableArray *allFolder = [[NSMutableArray alloc] init];
    if (fileItem != nil && fileItem.count > 0) {
        for (AMFileEntity *item in fileItem) {
            if (item.FileType == AMDirectory) {
                [allFolder addObject:item];
            }
        }
    }
    NSString *folderName = nil;
    if (allFolder != nil && allFolder.count > 0) {
        // 查询出所有的备份
        NSMutableArray *fileNameList = [[NSMutableArray alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        for (AMFileEntity *fileItem in allFolder) {
            folderName = fileItem.Name;
            if (![folderName hasSuffix:@"-original"]) {
                @try {
                    [fileNameList addObject:[dateFormatter dateFromString:folderName]];
                }
                @catch (NSException *exception) {
                }
            }
        }
        
        // 对得到的文件名称进行一次排序
        NSArray *sortedArray = [fileNameList sortedArrayUsingComparator:^(id obj1, id obj2){
            NSDate *date1 = (NSDate *)obj1;
            NSDate *date2 = (NSDate *)obj2;
            return [date2 compare:date1];
        }];
        if (sortedArray != nil && sortedArray.count > 0) {
            for (int i = 0; i < sortedArray.count; i++) {
                if (i < 3) {
                    continue;
                }
                NSString *folderPath = [backupRoot stringByAppendingPathComponent:[dateFormatter stringFromDate:[sortedArray objectAtIndex:i]]];
                @try {
                    [ipod.fileSystem unlinkFolder:folderPath];
                }
                @catch (NSException *exception) {
                    NSLog(@"Error");
                }
            }
        }
        [dateFormatter release];
        dateFormatter = nil;
    }
    
    [allFolder release];
    allFolder = nil;
}

- (void)backupFileWithIPod:(IMBiPod *)ipod sourcePath:(NSString *)sourcePath targetPath:(NSString *)targetPath {
    if ([ipod.fileSystem fileExistsAtPath:sourcePath] && [ipod.fileSystem getFileLength:sourcePath] > 0) {
        [ipod.fileSystem copyFile:sourcePath copyTo:targetPath];
    }
}

- (NSString *)createDictoryWithIPod:(IMBiPod *)ipod backupFolder:(NSString *)backupFolder fileRootPath:(NSString *)fileRootPath {
    NSString *resultPath = backupFolder;
    if ([fileRootPath hasPrefix:[ipod.fileSystem.driveLetter stringByStandardizingPath]]) {
        fileRootPath = [fileRootPath substringFromIndex:[[ipod.fileSystem.driveLetter stringByStandardizingPath] length]];
    }
    NSArray *folder = [[fileRootPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] componentsSeparatedByString:@"/"];
    if (folder != nil && folder.count > 0) {
        for (NSString *p in folder) {
            resultPath = [resultPath stringByAppendingPathComponent:p];
            if (![ipod.fileSystem fileExistsAtPath:resultPath]) {
                [ipod.fileSystem mkDir:resultPath];
            }
        }
    }
    return resultPath;
}

// 还原数据库的文件方法
- (NSMutableArray *)getAllBackupFolderNameWithIPod:(IMBiPod *)ipod {
    NSMutableArray *backupList = [[[NSMutableArray alloc] init] autorelease];
    NSString *folderPath = ipod.fileSystem.iTunesFolderPath;
    if ([ipod.fileSystem fileExistsAtPath:folderPath]) {
        NSString *backupRoot = [folderPath stringByAppendingPathComponent:@"Backup"];
        if ([ipod.fileSystem fileExistsAtPath:backupRoot]) {
            NSArray *fileItem = [ipod.fileSystem getItemInDirectory:backupRoot];        // 保存的是AMFileEntity对象
            
            if (fileItem != nil && fileItem.count > 0) {
                for (AMFileEntity *item in fileItem) {
                    if (item.FileType == AMDirectory) {
                        [backupList addObject:item];
                    }
                }
            }
        }
    }
    return backupList;
}

- (BOOL)restoreBackupFileWithIPod:(IMBiPod *)ipod backupFolder:(NSString *)backupFolder {
    BOOL result = NO;
    if ([ipod.fileSystem fileExistsAtPath:backupFolder]) {
        @try {
            [self recursionRestoreWithIPod:ipod currFolderPath:ipod.fileSystem.driveLetter folderPath:backupFolder];
            result = YES;
        }
        @catch (NSException *exception) {
            NSLog(@"Restore failed: %@", exception.reason);
        }
    }
    return result;
}

- (void)recursionRestoreWithIPod:(IMBiPod *)ipod currFolderPath:(NSString *)currFolderPath folderPath:(NSString *)folderPath {
    NSString *tempPath = nil;
    NSArray *fileArray = [ipod.fileSystem getItemInDirectory:folderPath];
    if (fileArray != nil && fileArray.count > 0) {
        for (AMFileEntity *item in fileArray) {
            if (item.FileType == AMDirectory) {
                if ([[item.FilePath stringByStandardizingPath] isEqualToString:[folderPath stringByStandardizingPath]]) {
                    continue;
                }
                tempPath = [currFolderPath stringByAppendingPathComponent:item.Name];
                if (![ipod.fileSystem fileExistsAtPath:tempPath]) {
                    [ipod.fileSystem mkDir:tempPath];
                }
                [self recursionRestoreWithIPod:ipod currFolderPath:tempPath folderPath:item.FilePath];
            } else {
                tempPath = [currFolderPath stringByAppendingPathComponent:item.Name];
                if ([ipod.fileSystem fileExistsAtPath:tempPath]) {
                    [ipod.fileSystem unlink:tempPath];
                }
                [ipod.fileSystem copyFile:item.FilePath copyTo:tempPath];
            }
        }
    }
}

@end

//
//  IMBIOS5Sqlite.m
//  iMobieTrans
//
//  Created by Pallas on 1/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBIOS5Sqlite.h"
#import "IMBIPod.h"
#import "IMBPlayCountEntry.h"
#import "MediaHelper.h"
#import "DateHelper.h"
#import "IMBFileSystem.h"

@implementation IMBIOS5Sqlite

//zombies
//            int loopCnt = 3;
//            long fileSize = 0;
//            NSString *remotePath = nil;
//            while (loopCnt > 0) {
//                remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"MediaLibrary.sqlitedb"];
//                fileSize = [[iPod fileSystem] getFileLength:remotePath];
//                if ([fileManager fileExistsAtPath:_localLibraryFile] == YES) {
//                    [fileManager removeItemAtPath:_localLibraryFile error:nil];
//                }
//                [[iPod fileSystem] copyRemoteFile:remotePath toLocalFile:_localLibraryFile];
//                if ([fileManager fileExistsAtPath:_localLibraryFile] == YES && [[fileManager attributesOfItemAtPath:_localLibraryFile error:nil] fileSize] == fileSize) {
//                    break;
//                }
//                loopCnt--;
//            }
//
//            loopCnt = 3;
//            fileSize = 0;
//            while (loopCnt > 0) {
//                remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"MediaLibrary.sqlitedb-shm"];
//                fileSize = [[iPod fileSystem] getFileLength:remotePath];
//                if ([fileManager fileExistsAtPath:_localLibrarySHMFile] == YES) {
//                    [fileManager removeItemAtPath:_localLibrarySHMFile error:nil];
//                }
//                [[iPod fileSystem] copyRemoteFile:remotePath toLocalFile:_localLibrarySHMFile];
//                if ([fileManager fileExistsAtPath:_localLibrarySHMFile] == YES && [[fileManager attributesOfItemAtPath:_localLibrarySHMFile error:nil] fileSize] == fileSize) {
//                    break;
//                }
//                loopCnt--;
//            }
//
//            loopCnt = 3;
//            fileSize = 0;
//            while (loopCnt > 0) {
//                 remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"MediaLibrary.sqlitedb-wal"];
//                fileSize = [[iPod fileSystem] getFileLength:remotePath];
//                if ([fileManager fileExistsAtPath:_localLibraryWALFile] == YES) {
//                    [fileManager removeItemAtPath:_localLibraryWALFile error:nil];
//                }
//                [[iPod fileSystem] copyRemoteFile:remotePath toLocalFile:_localLibraryWALFile];
//                if ([fileManager fileExistsAtPath:_localLibraryWALFile] == YES && [[fileManager attributesOfItemAtPath:_localLibraryWALFile error:nil] fileSize] == fileSize) {
//                    break;
//                }
//                loopCnt--;
//            }
//


- (id)initWithIPod:(IMBiPod *)ipod {
    self = [super initWithIPod:ipod];
    if (self) {
        _entryList = [[NSMutableArray alloc] init];
        fileManager = [NSFileManager defaultManager];
        NSString *remoteLibraryFile = nil;
        NSString *remoteLibrarySHMFile = nil;
        NSString *remoteLibraryWALFile = nil;
        
        _localLibraryFile = [[[iPod fileSystem] iTunesFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb"];
        _localLibrarySHMFile = [[[iPod fileSystem] iTunesFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb-shm"];
        _localLibraryWALFile = [[[iPod fileSystem] iTunesFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb-wal"];
        
        remoteLibraryFile  = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"MediaLibrary.sqlitedb"];
        remoteLibrarySHMFile = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"MediaLibrary.sqlitedb-shm"];
        remoteLibraryWALFile = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"MediaLibrary.sqlitedb-wal"];
        
        NSDictionary *localMediaLibDic = @{
                                           @"libraryfile":_localLibraryFile,
                                           @"libraryshmfile":_localLibrarySHMFile,
                                           @"librarywalfile":_localLibraryWALFile
                                           };
        NSDictionary *remoteMediaLibDic = @{
                                            @"libraryfile":remoteLibraryFile,
                                            @"libraryshmfile":remoteLibrarySHMFile,
                                            @"librarywalfile":remoteLibraryWALFile
                                            };
        
        
        @try {
            
            NSDictionary *copiedDic = [MediaHelper copyRemoteMediaLibrayFromRemote:remoteMediaLibDic ToLocal:localMediaLibDic WithIpod:ipod];
            if (copiedDic != nil) {
                _localLibraryFile = [copiedDic objectForKey:@"libraryfile"];
                _localLibrarySHMFile = [copiedDic objectForKey:@"libraryshmfile"];
                _localLibraryWALFile = [copiedDic objectForKey:@"libraryshmfile"];
            }
            
            
            
            if ([fileManager fileExistsAtPath:_localLibraryFile] == YES) {
                _mediaLibraryConnection = [[FMDatabase databaseWithPath:_localLibraryFile] retain];
                if([_mediaLibraryConnection open]) {
                    [_mediaLibraryConnection setShouldCacheStatements:NO];
                    [_mediaLibraryConnection setTraceExecution:NO];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
        }
    
    }
    return self;
}

- (void)dealloc {
    if (_entryList != nil) {
        [_entryList release];
        _entryList = nil;
    }
    if (_mediaLibraryConnection != nil) {
        [_mediaLibraryConnection close];
        [_mediaLibraryConnection release];
        _mediaLibraryConnection = nil;
    }
    [super dealloc];
}

- (NSMutableArray*)getPlayCoutsAndRating {
    NSString *query = nil;
    FMResultSet *rs = nil;
    query = @"select a.item_pid, date_played, play_count_user, user_rating from item_stats as a inner join item as b on a.item_pid=b.item_pid order by a.item_pid";
    rs = [_mediaLibraryConnection executeQuery:query];
    IMBPlayCountEntry *entry = nil;
    while ([rs next]) {
        @try {
            entry = [[IMBPlayCountEntry alloc] init];
            [entry setPersistentID:[rs stringForColumn:@"item_pid"]];
            @try {
                [entry setLastPlayed:[DateHelper getTimeStampFromDate:[DateHelper getDateTimeFromTimeStamp2001:[rs intForColumn:@"date_played"]]]];
            }
            @catch (NSException *exception) { }
            [entry setPlayCount:[rs intForColumn:@"play_count_user"]];
            [entry setRating:[rs intForColumn:@"user_rating"]];
            [_entryList addObject:entry];
            [entry release];
            entry = nil;
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
        }
    }
    [rs close];
    return _entryList;
}

@end

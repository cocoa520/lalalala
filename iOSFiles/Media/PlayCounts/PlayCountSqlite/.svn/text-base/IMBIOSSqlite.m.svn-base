//
//  IMBIOSSqlite.m
//  iMobieTrans
//
//  Created by Pallas on 1/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBIOSSqlite.h"
#import "IMBIPod.h"
#import "IMBSession.h"
#import "IMBPlayCountEntry.h"
#import "DateHelper.h"
#import "IMBFileSystem.h"

@implementation IMBIOSSqlite

- (id)initWithIPod:(IMBiPod *)ipod {
    self = [super initWithIPod:ipod];
    if (self) {
        _entryList = [[NSMutableArray alloc] init];
        NSString *remotingPath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunes Library.itlp/Dynamic.itdb"];
        if ([[iPod fileSystem] fileExistsAtPath:remotingPath] == YES) {
             _localDynamicFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"dynamic.itdb"];
            fileManager = [NSFileManager defaultManager];
            
            int loopCnt = 3;
            long long fileSize = 0;
            while (loopCnt > 0) {
                fileSize = [[iPod fileSystem] getFileLength:remotingPath];
                if ([fileManager fileExistsAtPath:_localDynamicFile] == YES) {
                    [fileManager removeItemAtPath:_localDynamicFile error:nil];
                }
                [[iPod fileSystem] copyRemoteFile:remotingPath toLocalFile: _localDynamicFile];
                if ([fileManager fileExistsAtPath:_localDynamicFile] == YES && [[fileManager attributesOfItemAtPath:_localDynamicFile error:nil] fileSize] == fileSize) {
                    break;
                }
                loopCnt--;
            }
            
            if ([fileManager fileExistsAtPath:_localDynamicFile] == YES) {
                _dynamicConnection = [[FMDatabase databaseWithPath:_localDynamicFile] retain];
                if ([_dynamicConnection open]) {
                    [_dynamicConnection setShouldCacheStatements:NO];
                    [_dynamicConnection setTraceExecution:NO];
                }
            }
        }
    }
    return self;
}

- (void)dealloc {
    if (_entryList != nil) {
        [_entryList release];
        _entryList = nil;
    }
    if (_dynamicConnection != nil) {
        [_dynamicConnection close];
        [_dynamicConnection release];
        _dynamicConnection = nil;
    }
    [super dealloc];
}

- (NSMutableArray*)getPlayCoutsAndRating {
    NSString *query = nil;
    FMResultSet *rs = nil;
    query = @"select item_pid, date_played, play_count_user, user_rating from item_stats order by item_pid";
    rs = [_dynamicConnection executeQuery:query];
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

//
//  IMBRecording.m
//  iMobieTrans
//
//  Created by Pallas on 1/30/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBRecording.h"
#import "IMBIPod.h"
#import "IMBSession.h"
#import "MediaHelper.h"
#import "FMDatabase.h"
#import "IMBRecordingEntry.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import "DateHelper.h"

//2013-10-15 zhangyang modify add iOS7 support
// 1.能显示iOS7的voice memo
// 2.iOS7的voice memo就不能删除了--需要同步来解决


@implementation IMBRecording
@synthesize recordingArray = _recordingArray;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [super init];
    if (self) {
        iPod = ipod;
        fm = [NSFileManager defaultManager];
        [self refreshRecordings];
    }
    return self;
}

- (void)dealloc {
    if (_recordingArray != nil) {
        [_recordingArray release];
        _recordingArray = nil;
    }
    [_remotingPath release],_remotingPath = nil;
    [_localPath release],_localPath = nil;
    
    
    [super dealloc];
}

- (BOOL)checkRecordingDB {
    _recordingFolderPath = [[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:@"Recordings"];
    if ([[iPod fileSystem] fileExistsAtPath:_recordingFolderPath]) {
        NSArray *files= [[iPod fileSystem] getItemInDirectory:_recordingFolderPath];
        if (files != nil && [files count] > 0) {
            for (AMFileEntity *file in files) {
                if ([[file Name] hasSuffix:@".db"]) {
                    [_localPath release],_localPath = nil;
                    _localPath = [[[[iPod session] sessionFolderPath] stringByAppendingPathComponent:[file Name]] retain];;
                    [_remotingPath release],_remotingPath = nil;
                    _remotingPath = [[file FilePath] retain];
                    if ([fm fileExistsAtPath:_localPath]) {
                        [fm removeItemAtPath:_localPath error:nil];
                    }
                    [[iPod fileSystem] copyRemoteFile:_remotingPath toLocalFile:_localPath];
                    continue;
                }
                //For iOS7 Recording
                //Recordings.db-shm
                if ( file.Name != nil && [@"Recordings.db-shm" isEqualToString:file.Name] ) {
                    NSString *shmLocalPath = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:[file Name]];
                    NSString *shmRemotingPath = [file FilePath];
                    if ([fm fileExistsAtPath:shmLocalPath]) {
                        [fm removeItemAtPath:shmLocalPath error:nil];
                    }
                    
                    [[iPod fileSystem] copyRemoteFile:shmRemotingPath toLocalFile:shmLocalPath];
                    continue;
                }
                
                if ( file.Name != nil && [@"Recordings.db-wal" isEqualToString:file.Name] ) {
                    NSString *walLocalPath = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:[file Name]];
                    NSString *walRemotingPath = [file FilePath];
                    if ([fm fileExistsAtPath:walLocalPath]) {
                        [fm removeItemAtPath:walLocalPath error:nil];
                    }
                    [[iPod fileSystem] copyRemoteFile:walRemotingPath toLocalFile:walLocalPath];
                    continue;
                }
            }
        }
        if ([MediaHelper stringIsNilOrEmpty:_localPath] == NO) {
            if ([fm fileExistsAtPath:_localPath] && [[fm attributesOfItemAtPath:_localPath error:nil] fileSize] > 0) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (NSArray*)refreshRecordings {
    if (_recordingArray != nil) {
        [_recordingArray release];
        _recordingArray = nil;
    }
    
    _recordingArray = [[NSMutableArray alloc] init];
    if ([self checkRecordingDB]) {
        FMDatabase *_recordingsDBConnection = [[FMDatabase databaseWithPath:_localPath] retain];
        NSString *query = @"select Z_PK,ZCUSTOMLABEL,ZPATH,ZDURATION,ZDATE,ZITUNESPERSISTENTID from ZRECORDING order by Z_PK";
        [_recordingsDBConnection open];
        FMResultSet *rs = [_recordingsDBConnection executeQuery:query];
        IMBRecordingEntry *item = nil;
        while ([rs next]) {
            item = [[IMBRecordingEntry alloc] init];
            [item setZ_PK:[rs intForColumn:@"Z_PK"]];
            NSString *zcustomlabel = [rs stringForColumn:@"ZCUSTOMLABEL"];
            //NSLog(@"zcustomlabel %@", zcustomlabel);
            [item setPath:[self formatPath:[rs stringForColumn:@"ZPATH"]]];
            [item setTimeLength:[rs doubleForColumn:@"ZDURATION"]];
            //NSLog(@"setTimeLength %f", item.timeLength);
            double recordedDate = [rs doubleForColumn:@"ZDATE"];
            [item setName:[self getRecordName:[item path] zcustomlabel:zcustomlabel]];
            [item setSizeLength:[self recordingSize:item.path]];
            [item setRecorded:[DateHelper dateFrom2001ToString:recordedDate withMode:2]];
            long long persistentID = [rs longLongIntForColumn:@"ZITUNESPERSISTENTID"];
            [item setPersistentID:persistentID];
            if ([[iPod fileSystem] fileExistsAtPath:item.path]) {
                item.fileIsExist = YES;
            }
            [_recordingArray addObject:item];
            [item release];
            item = nil;
        }
        [rs close];
        [_recordingsDBConnection close];
        [_recordingsDBConnection release];
        _recordingsDBConnection = nil;
    }
    return _recordingArray;
}

- (BOOL)deleteRecording:(NSDictionary*)recordingsInfo {
    int result = 0;
    if ([self checkRecordingDB]) {
        if (![MediaHelper stringIsNilOrEmpty:_localPath]) {
            [iPod startSync];
            NSString *whereSql = [self createDeleteWhereSql:recordingsInfo];
            FMDatabase *_recordingsDBConnection = [[FMDatabase databaseWithPath:_localPath] retain];
            NSString *deleteSql = [NSString stringWithFormat:@"delete from ZRECORDING where Z_PK in (%@)", whereSql];
            [_recordingsDBConnection open];
            FMResultSet *rs =[_recordingsDBConnection executeQuery:deleteSql];
            while ([rs next]) {
                result = [rs intForColumnIndex:0];
            }
            if (result > 0) {
                [self updateMax_Z_PK];
                [self deleteFile:recordingsInfo];
                [[iPod fileSystem] copyLocalFile:_localPath toRemoteFile:_remotingPath];
            }
            [_recordingsDBConnection close];
            [_recordingsDBConnection release];
            _recordingsDBConnection = nil;
            [iPod endSync];
        }
    }
    return (result > 0);
}

#pragma mark - 私有函数
- (NSString*)createDeleteWhereSql:(NSDictionary*)recordingsInfo {
    NSString *deletePK = nil;
    if (recordingsInfo != nil && [recordingsInfo count] > 0) {
        NSArray *z_pkArray =[recordingsInfo allKeys];
        for (NSNumber *item in z_pkArray) {
            if ([MediaHelper stringIsNilOrEmpty:deletePK]) {
                deletePK = [NSString stringWithFormat:@"%d", [item intValue]];
            } else {
                deletePK = [deletePK stringByAppendingFormat:@",%d", [item intValue]];
            }
        }
    }
    return deletePK;
}

- (void)deleteFile:(NSDictionary*)recordingsInfo {
    if (recordingsInfo != nil && [recordingsInfo count] > 0) {
        [recordingsInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([[iPod fileSystem] fileExistsAtPath:(NSString*)obj]) {
                [[iPod fileSystem] unlink:(NSString*)obj];
            }
        }];
    }
}

- (BOOL)updateMax_Z_PK {
    BOOL result = NO;
    int max_z_pk = 0;
    FMDatabase *_recordingsDBConnection = [[FMDatabase databaseWithPath:_localPath] retain];
    NSString *query = @"select Max(Z_PK) from ZRECORDING";
    [_recordingsDBConnection open];
    FMResultSet *rs = [_recordingsDBConnection executeQuery:query];
    while ([rs next]) {
        max_z_pk = [rs intForColumnIndex:0];
    }
    [rs close];
    
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Z_PRIMARYKEY SET Z_MAX = %d WHERE Z_ENT =(SELECT MIN(Z_ENT) FROM Z_PRIMARYKEY)", max_z_pk];
    result = [_recordingsDBConnection executeUpdate:updateSql];
    [_recordingsDBConnection close];
    [_recordingsDBConnection release];
    _recordingsDBConnection = nil;
    return result;
}

- (NSString*)getRecordName:(NSString*)path zcustomlabel:(NSString*)zcustomlabel {
    if ([MediaHelper stringIsNilOrEmpty:zcustomlabel]) {
        NSString *recordingName = [[path lastPathComponent] stringByDeletingPathExtension];
        return recordingName;
    } else {
        return zcustomlabel;
    }
}

- (NSString*)getDate:(double)timeSpan {
    NSString *dateStr = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [DateHelper getDateTimeFromTimeStamp2001:(uint)timeSpan];
    dateStr = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    dateFormatter = nil;
    return dateStr;
}

- (NSString*)formatPath:(NSString*)path {
    if (![MediaHelper stringIsNilOrEmpty:path]) {
        path = [@"Recordings" stringByAppendingPathComponent:[path lastPathComponent]];
        path = [[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:path];
        return path;
    }
    return @"";
}

- (long)recordingSize:(NSString*)path {
    long fileSize = 0;
    NSLog(@"path %@",path);
    if ([iPod.fileSystem fileExistsAtPath:path]) {
        fileSize = (long)[iPod.fileSystem getFileLength:path];
        NSLog(@"fileSize %ld",fileSize);
    }
    return fileSize;
}

@end

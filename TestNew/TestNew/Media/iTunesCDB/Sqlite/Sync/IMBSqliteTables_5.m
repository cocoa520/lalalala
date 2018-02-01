//
//  IMBSqliteTables_5.m
//  iMobieTrans
//
//  Created by zhang yang on 13-4-7.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBSqliteTables_5.h"
#import "IMBTrack.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"
#import "IMBTracklist.h"
#import "IMBPlaylist.h"
#import "IMBIPod.h"
//#import "NSString+Compare.h"
@implementation IMBSqliteTables_5
@synthesize dbPid=_dbPid;
@synthesize dirtyTracks=_dirtyTracks;
@synthesize deletedTracks=_deletedTracks;
@synthesize localLibraryFile = _localLibraryFile;

//zombies
//            int loopCnt = 3;
//            long fileSize = 0;
//            NSString *remotePath = nil;
//            while (loopCnt > 0) {
//
//
//                //remotePath = [iPod.fileSystem combinePath:iPod.fileSystem.iTunesFolderPath pathComponent:@"MediaLibrary.sqlitedb"];
//                remotePath = [ipod.fileSystem.iTunesFolderPath stringByAppendingPathComponent:@"MediaLibrary.sqlitedb"];
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
//                remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"MediaLibrary.sqlitedb-wal"];
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


- (id)initWithIPod:(IMBiPod*)ipod {
    self = [super init];
    if (self) {
        iPod = [ipod retain];
        _albums = [[NSMutableArray alloc] init];
        _artists = [[NSMutableArray alloc] init];
        _baseLocations = [[NSMutableArray alloc] init];
        _locationKinds = [[NSMutableDictionary alloc] init];
        _albumArtists = [[NSMutableArray alloc] init];
        
        
        
        _nextKindId = 1;
        _nextBaseLocationId = 1;
        _nextAlbumId = 1;
        _nextArtistId = 1;
        _nextAlbumArtistId = 1;
        _nextArtworkCacheId = 1;
//        logManger = [IMBLogManager singleton];
    }
    return self;
}

- (void)exactDeviceDBFiles{
    NSString *remoteLibraryFile = nil;
    NSString *remoteLibrarySHMFile = nil;
    NSString *remoteLibraryWALFile = nil;
    
    
    fileManager = [NSFileManager defaultManager];
    _localLibraryFile = [[[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb"] copy];
    _localLibrarySHMFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb-shm"];
    _localLibraryWALFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb-wal"];
    
    remoteLibraryFile  = [iPod.fileSystem.iTunesFolderPath stringByAppendingPathComponent:@"MediaLibrary.sqlitedb"];
    
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
        
        NSDictionary *copiedDic = [MediaHelper copyRemoteMediaLibrayFromRemote:remoteMediaLibDic ToLocal:localMediaLibDic WithIpod:iPod];
        if (copiedDic != nil) {
            _localLibraryFile = [copiedDic objectForKey:@"libraryfile"];
            _localLibrarySHMFile = [copiedDic objectForKey:@"libraryshmfile"];
            _localLibraryWALFile = [copiedDic objectForKey:@"librarywalfile"];
        }
        
        if ([fileManager fileExistsAtPath:_localLibraryFile] == YES) {
            _libraryConnection = [[FMDatabase databaseWithPath:_localLibraryFile] retain];
            if([_libraryConnection open]) {
                iPod.mediaDBPath = _localLibraryFile;
                [_libraryConnection setShouldCacheStatements:NO];
                [_libraryConnection setTraceExecution:NO];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }

}

- (BOOL)openDataBase {
    if (_libraryConnection == nil) {
        _libraryConnection = [[FMDatabase databaseWithPath:_localLibraryFile] retain];
    }
    BOOL isOpen = [_libraryConnection open];
    if (isOpen) {
        [_libraryConnection setShouldCacheStatements:NO];
        [_libraryConnection setTraceExecution:NO];
    }
    return isOpen;
}

- (void)closeDataBase {
    [_libraryConnection close];
    [_libraryConnection release];
    _libraryConnection = nil;
}


- (void)dealloc {
    if (_libraryConnection != nil) {
        [_libraryConnection close];
        [_libraryConnection release];
        _libraryConnection = nil;
    }

    
    if (_albumArtists != nil) {
        [_albumArtists release];
        _albumArtists = nil;
    }
    
    if (_albums != nil) {
        [_albums release];
        _albums = nil;
    }
    
    if (_artists != nil) {
        [_artists release];
        _artists = nil;
    }
    
    if (_baseLocations != nil) {
        [_baseLocations release];
        _baseLocations = nil;
    }
    
    if (_locationKinds != nil) {
        [_locationKinds release];
        _locationKinds = nil;
    }
    
    if (_dirtyTracks != nil) {
        [_dirtyTracks release];
        _dirtyTracks = nil;
    }
    
    if (iPod != nil) {
        [iPod release];
        iPod = nil;
    }
        
    [super dealloc];
}

- (void)readLookupTables {
    NSString *query = nil;
    IMBEntry5 *entity = nil;
    FMResultSet *rs = nil;
    
    BOOL isHighVersion = [self checkIosIsHighVersion];
    
    //1.得到DBInfo信息
    query = @"select db_pid from db_info";
    rs = [_libraryConnection executeQuery:query];
    if ([rs next]) {
        _dbPid  = [rs longForColumnIndex:0];
    }
    [rs close];
    
    if (_dbPid == 0)
    {
		//生成一个全新的db_pid
        _dbPid = 1173642227;
//        RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
//        byte[] rndSeries = new byte[8];
//        rng.GetBytes(rndSeries);
//        _dbPid = Math.Abs(BitConverter.ToInt64(rndSeries, 0));
    }
    
    //2.得到location信息
    if ([self checkTableExist:@"base_location"]) {
        query = @"select base_location_id, path from base_location order by base_location_id";
        rs = [_libraryConnection executeQuery:query];
        while ([rs next]) {
            int iD = [rs intForColumn:@"base_location_id"];
            NSString *path = [rs stringForColumn:@"path"];
            if ([MediaHelper stringIsNilOrEmpty:path] == TRUE) {
                continue;
            }
            entity = [[IMBEntry5 alloc] init];
            [entity setID:iD];
            [entity setValue:path];
            [entity setIsDirty:FALSE];
            [_baseLocations addObject:entity];
            [entity release];
            entity = nil;
            _nextBaseLocationId = iD + 1;
        }
        [rs close];

    }
    
    //3.得到Item Artist的信息
    if ([self checkTableExist:@"item_artist"]) {
        query = @"select item_artist_pid, item_artist from item_artist order by item_artist_pid";
        rs = [_libraryConnection executeQuery:query];
        while ([rs next]) {
            long long iD = [rs longLongIntForColumnIndex:0];
            if (![rs columnIndexIsNull:1]) {
                entity = [[IMBEntry5 alloc] init];
                [entity setID:iD];
                [entity setValue:[rs stringForColumnIndex:1]];
                [entity setIsDirty:FALSE];
                [_artists addObject:entity];
                [entity release];
                entity = nil;
            }
            _nextArtistId = iD + 1;

        }
        [rs close];
        
    }
    
    //4.得到Album Artist的信息
    /*8.0设备么得 artwork_cache_id*/
    if ([self checkTableExist:@"album_artist"]) {
        
        if (isHighVersion) {
            query = @"select album_artist_pid, album_artist from album_artist order by album_artist_pid";
        }
        else{
            query = @"select album_artist_pid, album_artist,artwork_cache_id from album_artist order by album_artist_pid";
        }
        rs = [_libraryConnection executeQuery:query];
        while ([rs next]) {
            long long iD = [rs longLongIntForColumnIndex:0];
            long long artworkCacheId = 0;
            
                if (!isHighVersion) {
                    artworkCacheId = [rs longLongIntForColumnIndex:2];
                }
            if (![rs columnIndexIsNull:1]) {
                IMBEntry5 *entry = [[IMBEntry5 alloc] init];
                entry.iD = iD;
                entry.value = [rs stringForColumnIndex:1];
                entry.isDirty = false;
                entry.artworkCacheId = artworkCacheId;
            }
            _nextAlbumArtistId = iD + 1;
        }
        [rs close];

    }
    
    //5.得到Album的信息
    /*8.0没得artwork_cache_id*/
    if ([self checkTableExist:@"album"]) {
        if (isHighVersion) {
            query = @"select album_pid,album_artist_pid, album,representative_item_pid from album order by album_pid";
        }
        else{
            query = @"select album_pid,album_artist_pid, album,artwork_cache_id,representative_item_pid from album order by album_pid";
        }
        rs = [_libraryConnection executeQuery:query];
        while ([rs next]) {
            long long iD = [rs longLongIntForColumnIndex:0];
            long long represenId = 0;
            long long artworkCacheId = 0;
            if (!isHighVersion) {
                @try {
                    artworkCacheId = [rs longLongIntForColumnIndex:3];
                }
                @catch (NSException *exception) {
//                    [logManger writeInfoLog:@"artworkCacheId not exist"];
                }
                represenId = [rs longLongIntForColumnIndex:4];
            }
            else{
                represenId = [rs longLongIntForColumnIndex:3];
            }
            
            if (![rs columnIndexIsNull:2]) {
                IMBAlbumEntry5 *albumEntry = [[IMBAlbumEntry5 alloc] init];
                albumEntry.iD = iD;
                albumEntry.artistID = [rs longLongIntForColumnIndex:1];
                albumEntry.value = [rs stringForColumnIndex:2];
                albumEntry.isDirty = YES;
                albumEntry.artworkCacheId = artworkCacheId;
                albumEntry.representativePid = represenId;
                [_albums addObject:albumEntry];
            }
            _nextAlbumId = iD + 1;

        }
        [rs close];

    }
    
    //6.得到location Kind的信息
    /*判断location_kind是否存在*/
    if ([self checkTableExist:@"location_kind"]) {
        query = @"select location_kind_id, kind from location_kind order by location_kind_id";
        rs = [_libraryConnection executeQuery:query];
        while ([rs next]) {
            int iD = [rs intForColumnIndex:0];
            if (![rs columnIndexIsNull:1]) {
                [_locationKinds setValue:[NSNumber numberWithInt:0] forKey:[rs stringForColumnIndex:1] != nil ? [rs stringForColumnIndex:1]:@""];
            }
            _nextKindId = iD + 1;
        }
        [rs close];
    }
    
    //7.得到最大的artworkCacheId的值
    /*8.0么得artwork_cache_id*/
    long long maxAlbumArtCacheId = 0;
    
    if (!isHighVersion) {
        if ([self checkTableExist:@"album"]) {
            query = @"Select Max(artwork_cache_id) from album";
            rs = [_libraryConnection executeQuery:query];
            if ([rs next]) {
                NSString *artworkCacheIdStr = [rs stringForColumnIndex:0];
                if (artworkCacheIdStr == nil) {
                    maxAlbumArtCacheId = 0;
                } else {
                    maxAlbumArtCacheId = [artworkCacheIdStr longLongValue];
                }
            }
            [rs close];
        }
    }
    long long maxArtCacheId = 0;
    NSString *tableName = @"";
    /*8.0表名改为
     Select Max(cast(item_pid as integer)) as id from item_artwork where length(cast(item_pid as integer)) = length(trim(item_pid))
     */
    if (isHighVersion) {
        query = @"select Max(cast(artwork_token as integer)) as id from artwork";
        tableName = @"artwork";
    }
    else{
        query = @"Select Max(cast(Cache_id as integer)) as id from artwork_info where length(cast(Cache_id as integer)) = length(trim(Cache_id))";
        tableName = @"artwork_info";
    }
    if ([self checkTableExist:tableName]) {
        rs = [_libraryConnection executeQuery:query];
        if ([rs next]) {
            if (![rs columnIndexIsNull:0]) {
                maxArtCacheId = [rs longLongIntForColumnIndex:0];
            }
            else{
                maxArtCacheId = 0;
            }
        }
        [rs close];
    }
    _nextArtworkCacheId = maxArtCacheId >= maxAlbumArtCacheId ? maxArtCacheId : maxAlbumArtCacheId ;
}

- (BOOL)checkIosIsHighVersion{
    NSString *version = iPod.deviceInfo.productVersion;
    int charnum = 0;
    @try {
        if ([version isVersionMajorEqual:@"10"]) {
            charnum = [[version substringToIndex:2] intValue];
        }else {
            charnum = [[version substringToIndex:1] intValue];
        }
    }
    @catch (NSException *exception) {
        charnum = 0;
    }
    @finally {
        if (charnum > 7) {
            return true;
        }
        else{
            return false;
        }
    }
}

- (long long)getArtistID:(NSString*)artistName {
    long long artistID = 0;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[(IMBEntry*)evaluatedObject value] lowercaseString] isEqualToString:[artistName lowercaseString]];
    }];
    NSArray *preArray = [_artists filteredArrayUsingPredicate:pre];
    IMBEntry5 *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry != nil) {
        entry = [[IMBEntry5 alloc] init];
        [entry setID:_nextArtistId++];
        [entry setValue:artistName];
        [entry setIsDirty:FALSE];
        [_artists addObject:entry];
        [entry release];
        entry = nil;
        artistID = [entry iD];
    }
    return artistID;
}

- (long long)getAlbumArtistID:(NSString*)albumArtistName track:(IMBTrack*)track {
    long long albumArtistID = 0;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[(IMBEntry*)evaluatedObject value] lowercaseString] isEqualToString:[albumArtistName lowercaseString]];
    }];
    NSArray *preArray = [_albumArtists filteredArrayUsingPredicate:pre];
    IMBEntry5 *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        entry = [[IMBEntry5 alloc] init];
        [entry setID:_nextAlbumArtistId++];
        [entry setValue:albumArtistName];
        [entry setIsDirty:FALSE];

        if ([track artworkPath] != nil && entry.artworkCacheId == 0)
        {
            entry.artworkCacheId = (++_nextArtworkCacheId);
            entry.artworkPid = track.dbID;
        }
        [_albumArtists addObject:entry];
        [entry release];
        entry = nil;
        albumArtistID = [entry iD];
    }
    return albumArtistID;
}

- (long long)getAlbumID:(long long)artistId track:(IMBTrack*)track {
    long long albumID = 0;
    NSLog(@"Track album %@",track.album);
    NSPredicate *pre = nil;
    pre = [NSPredicate predicateWithBlock:^BOOL(IMBAlbumEntry5 *entry, NSDictionary *bindings) {
        return entry.value == track.album;
    }];
    
    /*
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [track.album isEqualToString:track.album];
    */
        
        /*
        return ([[[(IMBAlbumEntry5*)evaluatedObject value] lowercaseStringWithLocale:[NSLocale currentLocale]] isEqualToString:[[track album] lowercaseStringWithLocale:[NSLocale currentLocale]]] && [(IMBAlbumEntry5*)evaluatedObject artistID] == artistId);
        */
    //}];
    IMBAlbumEntry5 *entry = nil;
    NSLog(@"_albums %lu",(unsigned long)_albums.count);
    for (int i = 0; i < _albums.count; i++) {
        IMBAlbumEntry5 * albumEntry = [_albums objectAtIndex:i];
        if ([albumEntry.value isEqualToString:track.album]) {
            entry = albumEntry;
            break;
        }
    }
    //NSArray *preArray = [_albums filteredArrayUsingPredicate:pre];
    /*IMBAlbumEntry5 *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    */
    if (entry == nil) {

        entry = [[IMBAlbumEntry5 alloc] init];
        [entry setID:_nextAlbumId++];
        [entry setArtistID:artistId];
        [entry setValue:[track album]];
        NSPredicate *pre2 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ([(IMBAlbumEntry5*)evaluatedObject iD] == artistId);
        }];
        NSArray *preArray2 = [_artists filteredArrayUsingPredicate:pre2];
        IMBEntry5 *artistEntry = nil;
        if (preArray2 != nil && [preArray2 count] > 0) {
            artistEntry = [preArray2 objectAtIndex:0];
        }
        if (artistEntry != nil) {
            entry.artworkCacheId = artistEntry.artworkCacheId;
            entry.artworkPid = track.dbID;
        }

        [_albums addObject:entry];
        albumID = [entry iD];
        [entry release];
        entry = nil;
    }
    return albumID;
}

- (int)getKindID:(NSString *)kind {
    if ([[_locationKinds allKeys] containsObject:kind] == NO) {
        [_locationKinds setValue:[NSNumber numberWithInt:_nextKindId] forKey:kind];
        _nextKindId++;
    }
    return [[_locationKinds valueForKey:kind] intValue];
}


//设置Dirty Track中的日志信息。
-(void) getInfoFromDirtyTracks {
    [self readLookupTables];
    
//    if (iPod.tracks.trackArray != nil)
//    {
//        _dirtyTracks = [[NSMutableArray alloc] init];
//        
//        for (int i=0; i<[iPod.tracks.trackArray count]; i++) {
//            IMBTrack *track = [iPod.tracks.trackArray objectAtIndex:i];
//            if ([track isDirty] == TRUE) {
//                [_dirtyTracks addObject:track];
//            }
//        }
//    }
    
    for (int i=0; i<[_dirtyTracks count]; i++) {
        IMBTrack *track = [_dirtyTracks objectAtIndex:i];
        long long artistId = [self getArtistID:track.artist];
        track.item_artist_pid = artistId;
        track.album_artist_pid = [self getAlbumArtistID:track.artist track:track];
        track.album_pid = [self getAlbumID:track.album_artist_pid track:track];
        if (track.artworkPath != nil)
        {
            NSPredicate *predict = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return ([(IMBAlbumEntry5*)evaluatedObject iD] == track.album_pid);
            }];
            NSArray *preArray = [_artists filteredArrayUsingPredicate:predict];
            IMBAlbumEntry5 *albumEntry = nil;
            if (preArray != nil && [preArray count] > 0) {
                albumEntry = [preArray objectAtIndex:0];
            }
            if (albumEntry != nil && albumEntry.artworkCacheId != 0) {
                
                NSPredicate *predict2 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    return ([(IMBTrack*)evaluatedObject dbID] == albumEntry.representativePid);
                }];
                NSArray *preArray2 = [(id)iPod.tracks filteredArrayUsingPredicate:predict2];
                if (preArray2 != nil && [preArray2 count] > 0 ) {
                    track.artworkCacheid = albumEntry.artworkCacheId;
                } else {
                    track.artworkCacheid = (++_nextArtworkCacheId);
                }
                
            } else {
                track.artworkCacheid = (++_nextArtworkCacheId);
            }
        }
    }
}

- (BOOL)checkTableExist:(NSString *)tableName{
    BOOL isExist = false;
    NSString *sb = [NSString stringWithFormat:@"SELECT tbl_name FROM sqlite_master WHERE type = 'table' and tbl_name like '%%%@%%'",tableName];
    FMResultSet *rs = [_libraryConnection executeQuery:sb];
    while (rs.next) {
        isExist = true;
    }
    return isExist;
}

- (bool) isExistPlaylist:(IMBPlaylist*)pl
{
    if (_libraryConnection == nil) {
        _libraryConnection = [[FMDatabase databaseWithPath:_localLibraryFile] retain];
    }
    if([_libraryConnection open]) {
        [_libraryConnection setShouldCacheStatements:NO];
        [_libraryConnection setTraceExecution:NO];
    }
    long count = 0;
    FMResultSet *rs = nil;
    // Handle creation/update of playlist
    NSString *queryCmd = @"select count(*) from container where container_pid = :pid ";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithLongLong:pl.iD], @"pid"
                            , nil];
    rs = [_libraryConnection executeQuery:queryCmd withParameterDictionary:params];
    if ([rs next]) {
        count = [rs longForColumnIndex:0];
    }
    [rs close];
    [self closeDataBase];
    if (count > 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

- (void) generateDeleteTracksInfo
{
    NSLog(@"deletedTracks count:%lu",  (unsigned long)[iPod.session.deletedTracks count]);
    
    _deletedTracks = [iPod.session.deletedTracks retain];
    //NSLog(@"_deleteTracks %@:", [_deletedTracks description]);
    for (int i=0; i < _deletedTracks.count; i++) {
        IMBTrack *track = [_deletedTracks objectAtIndex:i];
        NSLog(@"Track Name %@:", track.title);
        FMResultSet *rs = nil;
        // Handle creation/update of playlist
        NSString *queryCmd = @"select item_artist_pid,album_pid,album_artist_pid from item where item_pid = :pid ";
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithLongLong:track.dbID], @"pid"
                                , nil];
        rs = [_libraryConnection executeQuery:queryCmd withParameterDictionary:params];
        if ([rs next]) {
            track.item_artist_pid = [rs longLongIntForColumn:@"item_artist_pid"];
            track.album_pid = [rs longLongIntForColumn:@"album_pid"];
            track.album_artist_pid = [rs longLongIntForColumn:@"album_artist_pid"];
        }
        [rs close];
    }
    [_deletedTracks release];
}

@end


@implementation IMBEntry5
@synthesize iD = _iD;
@synthesize value = _value;
@synthesize artworkCacheId = _artworkCacheId;
@synthesize artworkPid = _artworkPid;
@synthesize isDirty = _isDirty;

@end

@implementation IMBAlbumEntry5
@synthesize artistID = _artistID;
@synthesize representativePid = _representativePid;
@end
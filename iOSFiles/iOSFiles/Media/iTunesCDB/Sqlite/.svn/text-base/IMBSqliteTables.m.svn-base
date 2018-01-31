//
//  IMBSqliteTables.m
//  iMobieTrans
//
//  Created by Pallas on 1/13/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSqliteTables.h"
#import "IMBIPod.h"
#import "IMBSession.h"
#import "FMDatabaseQueue.h"
#import "IMBTrack.h"
#import "IMBPlaylist.h"
#import <openssl/sha.h>
#import "NSString+Category.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import <malloc/malloc.h>

@implementation IMBSqliteTables

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [super init];
    if (self) {
        iPod = [ipod retain];
        
        _genres = [[NSMutableArray alloc] init];
        _albums = [[NSMutableArray alloc] init];
        _artists = [[NSMutableArray alloc] init];
        _baseLocations = [[NSMutableArray alloc] init];
        _locationKinds = [[NSMutableDictionary alloc] init];
        
        _nextGenreId = 1;
        _nextKindId = 1;
        _nextBaseLocationId = 1;
        _nextAlbumId = 1;
        _nextArtistId = 1;
        
        
        fileManager = [NSFileManager defaultManager];
        _localLibraryFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"library.itdb"];
        _localLocationsFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"locations.itdb"];
        _localDynamicFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"dynamic.itdb"];
        
        @try {
            int loopCnt = 3;
            long fileSize = 0;
            NSString *remotePath = nil;
            while (loopCnt > 0) {
                remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunes Library.itlp/Library.itdb"];
                fileSize = [[iPod fileSystem] getFileLength:remotePath];
                if ([fileManager fileExistsAtPath:_localLibraryFile] == YES) {
                    [fileManager removeItemAtPath:_localLibraryFile error:nil];
                }
                [[iPod fileSystem] copyRemoteFile:remotePath toLocalFile:_localLibraryFile];
                if ([fileManager fileExistsAtPath:_localLibraryFile] == YES && [[fileManager attributesOfItemAtPath:_localLibraryFile error:nil] fileSize] == fileSize) {
                    break;
                }
                loopCnt--;
            }
            
            loopCnt = 3;
            fileSize = 0;
            while (loopCnt > 0) {
                remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunes Library.itlp/Locations.itdb"];
                fileSize = [[iPod fileSystem] getFileLength:remotePath];
                if ([fileManager fileExistsAtPath:_localLocationsFile] == YES) {
                    [fileManager removeItemAtPath:_localLocationsFile error:nil];
                }
                [[iPod fileSystem] copyRemoteFile:remotePath toLocalFile:_localLocationsFile];
                if ([fileManager fileExistsAtPath:_localLibraryFile] == YES && [[fileManager attributesOfItemAtPath:_localLocationsFile error:nil] fileSize] == fileSize) {
                    break;
                }
                loopCnt--;
            }
            
            loopCnt = 3;
            fileSize = 0;
            while (loopCnt > 0) {
                remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunes Library.itlp/Dynamic.itdb"];
                fileSize = [[iPod fileSystem] getFileLength:remotePath];
                if ([fileManager fileExistsAtPath:_localDynamicFile] == YES) {
                    [fileManager removeItemAtPath:_localDynamicFile error:nil];
                }
                [[iPod fileSystem] copyRemoteFile:remotePath toLocalFile:_localDynamicFile];
                if ([fileManager fileExistsAtPath:_localDynamicFile] == YES && [[fileManager attributesOfItemAtPath:_localDynamicFile error:nil] fileSize] == fileSize) {
                    break;
                }
                loopCnt--;
            }
            
            if ([fileManager fileExistsAtPath:_localLibraryFile] == YES) {
                 _libraryConnection = [[FMDatabase databaseWithPath:_localLibraryFile] retain];
                if([_libraryConnection open]) {
                    [_libraryConnection setShouldCacheStatements:NO];
                    [_libraryConnection setTraceExecution:NO];
                }
            }
           
            if ([fileManager fileExistsAtPath:_localLocationsFile] == YES) {
                _locationsConnection = [[FMDatabase databaseWithPath:_localLocationsFile] retain];
                if ([_locationsConnection open]) {
                    [_locationsConnection setShouldCacheStatements:NO];
                    [_locationsConnection setTraceExecution:NO];
                }
            }
            
            if ([fileManager fileExistsAtPath:_localDynamicFile] == YES) {
                _dynamicConnection = [[FMDatabase databaseWithPath:_localDynamicFile] retain];
                if ([_dynamicConnection open]) {
                    [_dynamicConnection setShouldCacheStatements:NO];
                    [_dynamicConnection setTraceExecution:NO];
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
    if (_libraryConnection != nil) {
        [_libraryConnection close];
        [_libraryConnection release];
        _libraryConnection = nil;
    }
    
    if (_locationsConnection != nil) {
        [_locationsConnection close];
        [_locationsConnection release];
        _locationsConnection = nil;
    }
    
    if (_dynamicConnection != nil) {
        [_dynamicConnection close];
        [_dynamicConnection release];
        _dynamicConnection = nil;
    }
    
    if (_genres != nil) {
        [_genres release];
        _genres = nil;
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
    if (iPod != nil) {
        [iPod release];
        iPod = nil;
    }
    [super dealloc];
}

- (void)openDataBase {
    if ([_libraryConnection open]) {
        [_libraryConnection setShouldCacheStatements:NO];
        [_libraryConnection setTraceExecution:NO];
    }
    if ([_locationsConnection open]) {
        [_locationsConnection setShouldCacheStatements:NO];
        [_locationsConnection setTraceExecution:NO];

    }
    if ([_dynamicConnection open]) {
        [_dynamicConnection setShouldCacheStatements:NO];
        [_dynamicConnection setTraceExecution:NO];
    }
}

- (void)closeDataBase {
    [_libraryConnection close];
    [_locationsConnection close];
    [_dynamicConnection close];
}

+ (BOOL)haveLocalSqlliteDBS:(IMBiPod*)ipod {
    NSFileManager *fManager = [NSFileManager defaultManager];
    return [fManager fileExistsAtPath:[[[ipod session] sessionFolderPath] stringByAppendingPathComponent:@"library.itdb"]] == YES;
}

- (void)save {
    if (_libraryConnection != nil) {
        [_libraryConnection close];
        [_libraryConnection release];
        _libraryConnection = nil;
    }
    
    if (_locationsConnection != nil) {
        [_locationsConnection close];
        [_locationsConnection release];
        _locationsConnection = nil;
    }
    
    if (_dynamicConnection != nil) {
        [_dynamicConnection close];
        [_dynamicConnection release];
        _dynamicConnection = nil;
    }
    
    @try {
        NSString *remotePath = nil;
        remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunes Library.itlp/Library.itdb"];
        if ([[iPod fileSystem] fileExistsAtPath:remotePath] == YES) {
            [[iPod fileSystem] unlink:remotePath];
        }
        [[iPod fileSystem] copyLocalFile:_localLibraryFile toRemoteFile:remotePath];
        
        if (_updatedLocationsDb) {
            remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunes Library.itlp/Locations.itdb"];
            if ([[iPod fileSystem] fileExistsAtPath:remotePath] == YES) {
                [[iPod fileSystem] unlink:remotePath];
            }
            NSLog(@"localLocationsFile file: %@",_localLocationsFile );
            [[iPod fileSystem] copyLocalFile:_localLocationsFile toRemoteFile:remotePath];
        }
        
        if (_updatedDynamicDb) {
            remotePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunes Library.itlp/Dynamic.itdb"];
            if ([[iPod fileSystem] fileExistsAtPath:remotePath] == YES) {
                [[iPod fileSystem] unlink:remotePath];
            }
            [[iPod fileSystem] copyLocalFile:_localDynamicFile toRemoteFile:remotePath];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
}

- (void)readLookupTables {
    NSString *query = nil;
    IMBEntry *entity = nil;
    IMBAlbumEntry *albumEntry = nil;
    FMResultSet *rs = nil;
    
    query = @"select id, path from base_location order by id";
    rs = [_locationsConnection executeQuery:query];
    while ([rs next]) {
        int iD = [rs intForColumn:@"id"];
        NSString *path = [rs stringForColumn:@"path"];
        if ([MediaHelper stringIsNilOrEmpty:path] == TRUE) {
            continue;
        }
        entity = [[IMBEntry alloc] init];
        [entity setID:iD];
        [entity setValue:path];
        [_baseLocations addObject:entity];
        [entity release];
        entity = nil;
        _nextBaseLocationId = iD + 1;
    }
    [rs close];
    
    query = @"select id, genre from genre_map order by id";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        int iD = [rs intForColumn:@"id"];
        NSString *genre = [rs stringForColumn:@"genre"];
        if ([MediaHelper stringIsNilOrEmpty:genre] == FALSE) {
            entity = [[IMBEntry alloc] init];
            [entity setID:iD];
            [entity setValue:genre];
            [_genres addObject:entity];
            [entity release];
            entity = nil;
        }
        _nextGenreId = iD + 1;
    }
    [rs close];
    
    query = @"select pid, name from artist order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long iD = [rs longForColumn:@"pid"];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name] == FALSE) {
            entity = [[IMBEntry alloc] init];
            [entity setID:iD];
            [entity setValue:name];
            [_artists addObject:entity];
            [entity release];
            entity = nil;
        }
        _nextArtistId = iD + 1;
    }
    [rs close];
    
    query = @"select pid, ifnull(artist_pid,0), name from album order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long iD = [rs longForColumn:@"pid"];
        long artistId = [rs longForColumnIndex:1];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name] == FALSE) {
            albumEntry = [[IMBAlbumEntry alloc] init];
            [albumEntry setID:iD];
            [albumEntry setArtistID:artistId];
            [albumEntry setValue:name];
            [_albums addObject:albumEntry];
            [albumEntry release];
            albumEntry = nil;
        }
        _nextAlbumId = iD + 1;
    }
    [rs close];
    
    query = @"select id, kind from location_kind_map order by id";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        int iD = [rs intForColumn:@"id"];
        NSString *kind = [rs stringForColumn:@"kind"];
        if ([MediaHelper stringIsNilOrEmpty:kind] == FALSE) {
             [_locationKinds setValue:[NSNumber numberWithInt:iD] forKey:kind];
        }
        _nextKindId = iD + 1;
    }
    [rs close];
}

- (NSString*)getUpdateTrackCommand {
    NSMutableString *updateQuery = [NSMutableString stringWithCapacity:300];
    [updateQuery appendString:@"update item set "];
    [updateQuery appendString:@"year = :year, is_compilation = :is_compilation, "];
    [updateQuery appendString:@"sort_title = :sort_title, title = :title, "];
    [updateQuery appendString:@"track_number = :track_number, disc_number = :disc_number, genre_id = :genre_id, "];
    [updateQuery appendString:@"sort_artist = :sort_artist, artist_pid = :artist_pid, artist = :artist, "];
    [updateQuery appendString:@"sort_album = :sort_album, album_pid = :album_pid, album = :album, "];
    [updateQuery appendString:@"album_artist = :album_artist, is_song = :is_song, is_audio_book = :is_audio_book, "];
    [updateQuery appendString:@"is_music_video = :is_music_video, is_movie = :is_movie, is_tv_show = :is_tv_show, "];
    [updateQuery appendString:@"is_ringtone = :is_ringtone, is_book = :is_book, is_itunes_u = :is_itunes_u, "];
    [updateQuery appendString:@"is_podcast = :is_podcast, date_modified = :date_modified, remember_bookmark = :remember_bookmark, "];
    [updateQuery appendString:@"artwork_status = :artwork_status, artwork_cache_id = :artwork_cache_id "];
    [updateQuery appendString:@"where pid = :pid"];
    return updateQuery;
}

- (NSString*)getInsertTrackCommand {
    NSMutableString *insertQuery = [NSMutableString stringWithCapacity:300];
    [insertQuery appendString:@"insert into item (pid, media_kind, is_song, is_audio_book, is_music_video, is_movie, "];
    [insertQuery appendString:@"is_tv_show, is_ringtone, is_voice_memo, is_rental, is_podcast,is_itunes_u,is_book, "];
    [insertQuery appendString:@"date_modified, year, content_rating, content_rating_level, is_compilation, "];
    [insertQuery appendString:@"is_user_disabled, remember_bookmark, exclude_from_shuffle, artwork_status, artwork_cache_id, "];
    [insertQuery appendString:@"start_time_ms, total_time_ms, track_number, track_count, disc_number, disc_count, bpm, "];
    [insertQuery appendString:@"relative_volume, genius_id, genre_id, category_id, album_pid, artist_pid, composer_pid, title, "];
    [insertQuery appendString:@"artist, album, album_artist, composer, comment, description, description_long, in_songs_collection, "];
    [insertQuery appendString:@"title_blank,artist_blank,album_artist_blank,album_blank,composer_blank, grouping_blank) "];
    [insertQuery appendString:@"values (:pid, :media_kind, :is_song, :is_audio_book, :is_music_video, :is_movie, "];
    [insertQuery appendString:@":is_tv_show, :is_ringtone, 0, 0, :is_podcast, :is_itunes_u, :is_book, :date_modified, "];
    [insertQuery appendString:@" :year, 0, 0, :is_compilation, 0, :remember_bookmark, :exclude_from_shuffle, :artwork_status, "];
    [insertQuery appendString:@":artwork_cache_id, 0, :total_time_ms, :track_number, :track_count, :disc_number, :disc_count, "];
    [insertQuery appendString:@"0, 0, 0, :genre_id, 0, :album_pid, :artist_pid, :composer_pid, :title, "];
    [insertQuery appendString:@":artist, :album, :album_artist, :composer, :comment, :description, :description_long, "];
    [insertQuery appendString:@"1 , 0, 0, 0, 0, 0, 1); "];
    return insertQuery;
}

- (NSDictionary*)fillTrackParameters:(IMBTrack*)track {
    long long artistId = [self getArtistID:[track artist] track:track];
    NSLog(@"artistId: %lld",artistId);
    long long albumArtistId = [self getAlbumArtistID:[track albumArtist] track:track];
    NSLog(@"albumArtistId: %lld",albumArtistId);
    long long albumID = [self getAlbumID:albumArtistId track:track];
    NSLog(@"albumID: %lld",albumID);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithLongLong:[track dbID]], @"pid",
                            [NSNumber numberWithInt:([track mediaType] == Audio ? 1 : 0)], @"is_song",
                            [NSNumber numberWithInt:([track mediaType] == Audiobook ? 1 : 0)], @"is_audio_book",
                            [NSNumber numberWithInt:([track mediaType] == MusicVideo ? 1 : 0)], @"is_music_video",
                            [NSNumber numberWithInt:(([track mediaType] == Video || [track mediaType] == VideoPodcast) ? 1 : 0)], @"is_movie",
                            [NSNumber numberWithInt:([track mediaType] == TVShow ? 1 : 0)], @"is_tv_show",
                            [NSNumber numberWithInt:([track mediaType] == Ringtone ? 1 : 0)], @"is_ringtone",
                            [NSNumber numberWithInt:(([track mediaType] == Books || [track mediaType] == PDFBooks) ? 1 : 0)], @"is_book",
                            [NSNumber numberWithInt:(([track mediaType] == iTunesU || [track mediaType] == iTunesUVideo) ? 1 : 0)], @"is_itunes_u",
                            [NSNumber numberWithInt:(([track mediaType] == Podcast || [track mediaType] == VideoPodcast) ? 1 : 0)], @"is_podcast",
                            [NSNumber numberWithInt:0], @"date_modified",
                            [NSNumber numberWithInt:([track rememberPlaybackPosition] == TRUE ? 1 : 0)], @"remember_bookmark",
                            [NSNumber numberWithInt:([[track artwork] count] > 0 ? 2 : 0)], @"artwork_status",
                            [NSNumber numberWithUnsignedInt:[track artworkIdLink]], @"artwork_cache_id",
                            [NSNumber numberWithUnsignedInt:[track year]], @"year",
                            [NSNumber numberWithInt:([track isCompilation] == TRUE ? 1 : 0)], @"is_compilation",
                            [NSNumber numberWithUnsignedInt:[track trackNumber]], @"track_number",
                            [NSNumber numberWithUnsignedInt:[track discNumber]], @"disc_number",
                            [NSNumber numberWithLong:[self getGenreID:[track genre]]], @"genre_id",
                            [NSNumber numberWithLongLong:artistId], @"artist_pid",
                            [NSNumber numberWithLongLong:albumArtistId], @"album_artist_pid",
                            [NSNumber numberWithLongLong:albumID], @"album_pid",
                            [track title], @"title",
                            [track sortTitle], @"sort_title",
                            [track sortArtist], @"sort_artist",
                            [track sortAlbum], @"sort_album",
                            [track artist], @"artist",
                            [track album], @"album",
                            [track albumArtist], @"album_artist",
                            [NSNumber numberWithInt:([track mediaType] == iTunesU ? iTunesUGroup : [track mediaType])], @"media_kind",
                            [NSNumber numberWithDouble:[track length]], @"total_time_ms",
                            [NSNumber numberWithInt:0], @"track_count",
                            [NSNumber numberWithUnsignedInt:[track totalDiscCount]], @"disc_count",
                            [NSNumber numberWithInt:0], @"composer_pid",
                            @"", @"composer",
                            [track comment], @"comment",
                            [track descriptionText], @"description",
                            [NSNumber numberWithLong:0], @"description_long",
                            [NSNumber numberWithInt:(([track mediaType] == Audiobook || [track mediaType] == Podcast || [track mediaType] == VideoPodcast) ? 1 : 0)], @"exclude_from_shuffle",
                            [NSNumber numberWithUnsignedInt:[track bitrate]], @"bit_rate",
                            [NSNumber numberWithUnsignedInt:[track samplerateForSqlite]], @"sample_rate",
                            nil];
    NSLog(@"params %@",params);
    return params;
}

- (void)updateTracks:(NSMutableArray*)tracks {
    [self readLookupTables];
    NSString *existsQuery = @"select count(*) from item where pid = ?";
    [_libraryConnection beginTransaction];
    @try {
        FMResultSet *rs = nil;
        BOOL itemExists = NO;
        for (IMBTrack *track in tracks) {
            rs = [_libraryConnection executeQuery:existsQuery, [NSNumber numberWithLongLong:[track dbID]]];
            while ([rs next]) {
                NSLog(@"Track Count:%ld", [rs longForColumnIndex:0]);
                itemExists = [rs longForColumnIndex:0] > 0 ? TRUE : FALSE;
            }
            [rs close];
            
            if (itemExists == NO) {
                [self insertNewTrack: _libraryConnection track:track];
            } else {
                NSDictionary *params = [self fillTrackParameters:track];
                [_libraryConnection executeUpdate:[self getUpdateTrackCommand] withParameterDictionary:params];
            }
        }
        [self removeDeletedTracks];
        [self cleanup];
        [_libraryConnection commit];
    }
    @catch (NSException *exception) {
        [_libraryConnection rollback];
    }
}

- (BOOL)insertAVFormat:(IMBTrack *)track db:(FMDatabase *)db {
    //TODO 需要把这部分分离
    BOOL excutResult;
    NSString *insertAVFormat = @"insert into avformat_info(item_pid,audio_format,bit_rate,sample_rate) values (:pid, 0, :bit_rate, :sample_rate);";
    
    NSDictionary *avFormatParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithLongLong:[track dbID]], @"pid",
                                    [NSNumber numberWithUnsignedInt:[track bitrate]], @"bit_rate",
                                    [NSNumber numberWithUnsignedInt:[track sampleRate]], @"sample_rate",
                                    nil];
    excutResult = [db executeUpdate:insertAVFormat withParameterDictionary:avFormatParams];
    return excutResult;
}

- (void)insertNewTrack:(FMDatabase*)db track:(IMBTrack*)track {
    if ([track mediaType] == Books || [track mediaType] == PDFBooks) {
        return;
    }
    
    BOOL excutResult = NO;
    
    
    NSDictionary *params = [self fillTrackParameters:track];
    NSString *insertSql = [self getInsertTrackCommand];
    excutResult = [db executeUpdate:insertSql withParameterDictionary:params];
    NSLog(@"insertSql result is %d", excutResult);
    excutResult = [self insertAVFormat:track db:db];
    NSLog(@"insertAVFormat result is %d", excutResult);
    

    NSMutableString *locationsQuery = [NSMutableString stringWithCapacity:300];
    [locationsQuery appendString:@"insert into location (item_pid, sub_id, base_location_id, location_type, "];
    [locationsQuery appendString:@"location, extension, kind_id, file_size) "];
    [locationsQuery appendString:@"values(:item_pid, 0, :base_location_id, :location_type, "];
    [locationsQuery appendString:@":location, :extension, :kind_id, :file_size)"];
    
    
    NSMutableString *insertVideoInfoQuery = [NSMutableString stringWithCapacity:300];
    [insertVideoInfoQuery appendString:@"insert into video_info (item_pid, has_alternate_audio, has_subtitles, "];
    [insertVideoInfoQuery appendString:@"characteristics_valid ,has_closed_captions, is_self_contained, "];
    [insertVideoInfoQuery appendString:@"is_compressed, is_anamorphic, season_number, audio_language, "];
    [insertVideoInfoQuery appendString:@"audio_track_index, audio_track_id, subtitle_language, subtitle_track_index, "];
    [insertVideoInfoQuery appendString:@"subtitle_track_id, episode_sort_id) "];
    [insertVideoInfoQuery appendString:@"values(:item_pid, 0,0,0,0,1,0,0,0,0,0,0,0,0,0,0)"];
    
    
    IMBEntry *location = [self getBaseLocation:[track filePath]];
    
    NSDictionary *locParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:[track dbID]], @"item_pid",
                               [NSNumber numberWithLongLong:[location iD]], @"base_location_id",
                               [NSNumber numberWithInt:1179208773], @"location_type",
                               [[[track filePath] substringFromIndex:([[location value] length] + 1)] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"], @"location",
                               [NSNumber numberWithInt:[self getExtensionID:[track filePath]]], @"extension",
                               [NSNumber numberWithInt:[self getKindID:[track fileTypeStr]]], @"kind_id",
                               [NSNumber numberWithUnsignedInt:[track fileSize]], @"file_size"
                               , nil];
    excutResult = [_locationsConnection executeUpdate:locationsQuery withParameterDictionary:locParams];
    NSLog(@"locationsQuery result is %d", excutResult);
    
    if ([track isVideo] == TRUE) {
        NSDictionary *videoInfoParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithLongLong:[track dbID]],@"item_pid"
                                         , nil];
        excutResult = [db executeUpdate:insertVideoInfoQuery withParameterDictionary:videoInfoParams];
        NSLog(@"locationsQuery result is %d", excutResult);
    }
    
    _updatedLocationsDb = TRUE;
    
    if ([track playCount] > 0 || [track rating] > 0) {
        _updatedDynamicDb = TRUE;
        [self insertItemStatus:track];
    }
}

- (void)removeDeletedTracks {
    NSString *deleteLocationQuery = @"delete from location where item_pid = :pid";
    NSString *delSql = nil;
    for (IMBTrack *track in [[iPod session] deletedTracks]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithLongLong:[track dbID]], @"pid"
                                        , nil];
        NSLog(@"pid %lld", track.dbID);
        delSql = @"delete from item where pid=@pid;";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        delSql = @"delete from item_to_container where item_pid = :pid;";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        delSql = @"delete from avformat_info where item_pid = :pid;";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        delSql = @"delete from video_characteristics where item_pid = :pid;";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        [_locationsConnection executeUpdate:deleteLocationQuery withParameterDictionary:params];
        _updatedLocationsDb = TRUE;
    }
}

- (void)cleanup {
    NSString *delQuery = @"delete from album where pid not in (select album_pid from item)";
    [_libraryConnection executeUpdate:delQuery];
    
    delQuery = @"delete from artist where pid not in (select artist_pid from item)";
    [_libraryConnection executeUpdate:delQuery];
}

- (int)getGenreID:(NSString*)genre {
    int genreID = 0;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[(IMBEntry*)evaluatedObject value] lowercaseString] isEqualToString:[genre lowercaseString]];
    }];
    NSArray *preArray = [_genres filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        NSString *query = @"insert into genre_map (id, genre) values(:id, :genre)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_nextGenreId], @"id",
                               genre, @"genre", nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBEntry alloc] init];
        [entry setID:_nextGenreId++];
        [entry setValue:genre];
        [_genres addObject:entry];
        genreID = (int)entry.iD;
        [entry release];
        entry = nil;
    }
    return genreID;
}

- (long long)getArtistID:(NSString*)artist track:(IMBTrack*)track {
    long long artistID = 0;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[(IMBEntry*)evaluatedObject value] lowercaseString] isEqualToString:[artist lowercaseString]];
    }];
    NSArray *preArray = [_artists filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        NSString *query = @"insert into artist (pid, kind, name) values(:pid, :kind, :name)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:_nextArtistId], @"pid",
                               [NSNumber numberWithInt:2], @"kind", artist, @"name", nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBEntry alloc] init];
        [entry setID:_nextArtistId++];
        [entry setValue:artist];
        [_artists addObject:entry];
        [entry release];
        entry = nil;
        artistID = [entry iD];
    }
    return artistID;
}

- (long long)getAlbumArtistID:(NSString*)albumArtist track:(IMBTrack*)track {
    return [self getArtistID:albumArtist track:track];
}

- (long long)getAlbumID:(long long)artistId track:(IMBTrack*)track {
    long long albumID = 0;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ([[[(IMBAlbumEntry*)evaluatedObject value] lowercaseString] isEqualToString:[[track album] lowercaseString]] && [(IMBAlbumEntry*)evaluatedObject artistID] == artistId);
    }];
    
    NSArray *preArray = [_albums filteredArrayUsingPredicate:pre];
    IMBAlbumEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        NSString *query = @"insert into album (pid, kind, name, artist_pid, artwork_status, artwork_item_pid) values(:pid, :kind, :name, :artist_pid, 0, 0)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:_nextAlbumId], @"pid",
                               [NSNumber numberWithInt:2], @"kind", [track album], @"name", artistId, @"artist_pid", nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBAlbumEntry alloc] init];
        [entry setID:_nextAlbumId++];
        [entry setArtistID:artistId];
        [entry setValue:[track album]];
        [_albums addObject:entry];
        [entry release];
        entry = nil;
        albumID = [entry iD];
    }
    return albumID;
}


- (IMBEntry*)getBaseLocation:(NSString*)path {
    NSLog(@"path1 %@",path);
    path = [path stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSLog(@"path2 %@",path);
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[path lowercaseString] hasPrefix:[[(IMBEntry*)evaluatedObject value] lowercaseString]];
    }];
    NSArray *preArray = [_baseLocations filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        for (IMBEntry *e in preArray) {
            NSLog(@"location value:%@",e.value);
        }
        NSLog(@"preArray > 0");
        entry = [preArray objectAtIndex:0];
    }
    
    if (entry == nil) {
        NSString *ringtonesPath = @"itunes_control/ringtones";
        NSString *musicPath = @"iTunes_Control/Music";
        
        NSString *query = @"insert into base_location (id, path) values(:id, :path)";
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:_nextBaseLocationId], @"id"
                                , nil];
        if ([[path lowercaseString] rangeOfString:ringtonesPath].location != NSNotFound) {
            [params setValue:ringtonesPath forKey:@"path"];
            entry = [[[IMBEntry alloc] init] autorelease];
            [entry setID:_nextBaseLocationId++];
            [entry setValue:ringtonesPath];
            
        } else {
            [params setValue:musicPath forKey:@"path"];
            entry = [[[IMBEntry alloc] init] autorelease];
            [entry setID:_nextBaseLocationId++];
            [entry setValue:musicPath];
        }
        NSLog(@"query %@:", query);
        [_locationsConnection executeUpdate:query withParameterDictionary:params];
        [_baseLocations addObject:entry];
    }
    //[entry autorelease];
    return entry;
}

- (int)getExtensionID:(NSString*)filePath {
    NSString *ext = [[filePath pathExtension] lowercaseString];
    if ([ext isEqualToString:@"mp3"]) {
        return 1297101600;
    } else if ([ext isEqualToString:@"mp4"]) {
        return 1297101856;
    } else if ([ext isEqualToString:@"m4a"]) {
        return 1295270176;
    } else if ([ext isEqualToString:@"m4r"]) {
        return 1295274528;
    } else if ([ext isEqualToString:@"m4v"]) {
        return 1295275552;
    } else if ([ext isEqualToString:@"wav"]) {
        return 1463899680;
    } else if ([ext isEqualToString:@"aif"]) {
        return 1095321120;
    } else {
        return 1297101600;
    }
}

- (int)getKindID:(NSString *)kind {
    NSLog(@"kind %@", kind);
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSString* kindInLocation, NSDictionary *bindings) {
        return [kindInLocation isEqualToString:kind];
    }];
    NSArray *preArray = [_locationKinds.allKeys filteredArrayUsingPredicate:pre];
    if (preArray == nil || [preArray count] == 0) {
        NSString *query =@"insert into location_kind_map (id, kind) values(:id, :kind)";
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:_nextKindId], @"id",
                                kind, @"kind"
                                , nil];
        NSLog(@"params %@",params);
        [_libraryConnection executeUpdate:query withParameterDictionary:params];
        [_locationKinds setValue:[NSNumber numberWithInt:_nextKindId] forKey:kind];
        _nextKindId++;
    }
    return [[_locationKinds valueForKey:kind] intValue];
}

- (void)insertItemStatus:(IMBTrack*)track {
    @try {
        NSMutableString *queryCmd = [NSMutableString stringWithCapacity:300];
        [queryCmd appendString:@"insert into item_stats (item_pid, has_been_played, date_played, play_count_user, "];
        [queryCmd appendString:@"play_count_recent, user_rating) values (:pid, :has_been_played, :date_played, "];
        [queryCmd appendString:@":play_count_user,:play_count_recent, :user_rating)"];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithLongLong:[track dbID]], @"pid"
                                       , nil];
        if ([track playCount] > 0) {
            [params setValue:[NSNumber numberWithBool:TRUE] forKey:@"has_been_played"];
            [params setValue:[NSNumber numberWithUnsignedInt:[track dateLastPalyed]] forKey:@"date_played"];
            [params setValue:[NSNumber numberWithInt:[track playCount]] forKey:@"play_count_user"];
            [params setValue:[NSNumber numberWithInt:[track playCount]] forKey:@"play_count_recent"];
        } else {
            [params setValue:[NSNumber numberWithBool:FALSE] forKey:@"has_been_played"];
            [params setValue:[NSNumber numberWithUnsignedInt:0] forKey:@"date_played"];
            [params setValue:[NSNumber numberWithInt:0] forKey:@"play_count_user"];
            [params setValue:[NSNumber numberWithInt:0] forKey:@"play_count_recent"];
        }
        if ((int)[track rating] > 0) {
            [params setValue:[NSNumber numberWithInt:(int)[track rating]] forKey:@"user_rating"];
        } else {
            [params setValue:[NSNumber numberWithInt:0] forKey:@"user_rating"];
        }
        [_dynamicConnection executeUpdate:queryCmd withParameterDictionary:params];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
}

- (void)updatePlaylists:(NSMutableArray*)playlists {
    NSString *selectCmd = @"select item_pid from item_to_container where container_pid = :pid";
    NSString *insertCmd = @"insert into item_to_container (item_pid, container_pid) values (:item_pid, :container_pid)";
    NSString *deleteCmd = @"delete from item_to_container where item_pid = :item_pid and container_pid = :container_pid";
    
    [_libraryConnection beginTransaction];
    @try {
        for (IMBPlaylist *playlist in playlists) {
            long count = 0;
            FMResultSet *rs = nil;
            NSString *queryCmd = @"select count(*) from container where pid = :pid";
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithLongLong:(int64_t)[playlist iD]], @"pid"
                                    , nil];
            rs = [_libraryConnection executeQuery:queryCmd withParameterDictionary:params];
            while ([rs next]) {
                count = [rs longForColumnIndex:0];
            }
            [rs close];
            
            if (count == 0) {
                [self createPlaylist:_libraryConnection playList:playlist];
            } else {
                queryCmd = @"update container set name = :name where pid = :pid";
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [playlist name], @"name",
                          [NSNumber numberWithLongLong:(int64_t)[playlist iD]], @"pid"
                          , nil];
                [_libraryConnection executeUpdate:queryCmd withParameterDictionary:params];
            }
            
            NSMutableArray *sqlItemIds = [[NSMutableArray alloc] init];
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSNumber numberWithLongLong:(int64_t)[playlist iD]], @"pid"
                      , nil];
            rs = [_libraryConnection executeQuery:selectCmd withParameterDictionary:params];
            while ([rs next]) {
                [sqlItemIds addObject:[NSNumber numberWithLongLong:[rs longLongIntForColumn:@"item_pid"]]];
            }
            [rs close];
            
            NSMutableArray *updatedIds = [[NSMutableArray alloc] init];
            for (IMBTrack *track in [playlist tracks]) {
                if ([sqlItemIds containsObject:[NSNumber numberWithLongLong:[track dbID]]] == NO) {
                    [updatedIds addObject:[NSNumber numberWithLongLong:[track dbID]]];
                }
            }
            
            if ([updatedIds count] > 0) {
                for (NSNumber *item in updatedIds) {
                    params = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithLongLong:(int64_t)[playlist iD]], @"container_pid",
                              item, @"item_pid"
                              , nil];
                    [_libraryConnection executeUpdate:insertCmd withParameterDictionary:params];
                }
            }
            [updatedIds removeAllObjects];
            
            for (NSNumber *item in sqlItemIds) {
                if ([playlist containsTrackByDBID:[item longValue]] == FALSE) {
                    [updatedIds addObject:item];
                }
            }
            
            if ([updatedIds count] > 0) {
                for (NSNumber *item in updatedIds) {
                    params = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithLongLong:(int64_t)[playlist iD]], @"container_pid",
                              item, @"item_pid"
                              , nil];
                    [_libraryConnection executeUpdate:deleteCmd withParameterDictionary:params];
                }
            }
            [sqlItemIds release];
            sqlItemIds = nil;
            [updatedIds release];
            updatedIds = nil;
            
            NSString *deleteContSql= @"delete from container where pid = :container_pid;";
            NSString *deleteItemSql = @"delete from item_to_container where container_pid = :container_pid;";
            for (IMBPlaylist *playlist in [[iPod session] deletedPlaylists]) {
                params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithLongLong:(int64_t)[playlist iD]], @"container_pid"
                          , nil];
                [_libraryConnection executeUpdate:deleteContSql withParameterDictionary:params];
                [_libraryConnection executeUpdate:deleteItemSql withParameterDictionary:params];
            }
        }
        [_libraryConnection commit];
    }
    @catch (NSException *exception) {
        [_libraryConnection rollback];
    }
}

- (void)createPlaylist:(FMDatabase*)db playList:(IMBPlaylist*)playlist {
    NSMutableString *insertCmd = [NSMutableString stringWithCapacity:200];
    [insertCmd appendString:@"insert into container (pid, distinguished_kind, name, parent_pid, media_kinds, "];
    [insertCmd appendString:@"workout_template_id, is_hidden, smart_is_folder) "];
    [insertCmd appendString:@"values (:pid, :distinguished_kind, :name, 0, :media_kinds, 0, :is_hidden, 0)"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithLongLong:(int64_t)[playlist iD]] forKey:@"pid"];
    [params setValue:[NSNumber numberWithInt:[playlist distinguishedKind]] forKey:@"distinguished_kind"];
    [params setValue:[playlist name] forKey:@"name"];
    if ([playlist isPodcastPlaylist] == TRUE) {
        [params setValue:[NSNumber numberWithInt:Podcast] forKey:@"media_kinds"];
        [params setValue:[NSNumber numberWithBool:TRUE] forKey:@"is_hidden"];
    } else if([playlist isiTunesUPlaylist] == TRUE) {
        [params setValue:[NSNumber numberWithInt:iTunesUGroup] forKey:@"media_kinds"];
        [params setValue:[NSNumber numberWithBool:TRUE] forKey:@"is_hidden"];
    } else {
        [params setValue:[NSNumber numberWithInt:1] forKey:@"media_kinds"];
        [params setValue:[NSNumber numberWithBool:FALSE] forKey:@"is_hidden"];
    }
    [_libraryConnection executeUpdate:insertCmd withParameterDictionary:params];
    [params release];
    params = nil;
}

- (void)updateLocationsCBK {
    // ToDo 这里主要是写Hash值进来
    if (!_updatedLocationsDb) {
        return;
    }
    
    FILE *file = fopen([_localLocationsFile UTF8String], "ab+");
    //得到文件字节的总长度
    fseek(file, 0, SEEK_END);
    long fileLength = ftell(file);
    fseek(file, 0, SEEK_SET);
    
    //定义经过第一次sha1的结果内容
    Byte sha1Buffer[((fileLength / 1024) * 20)];
    int ptr = 0;
    int ptr2 = 0;
    
    while (true) {
        SHA_CTX content;
        if (SHA1_Init(&content)) {
            //读取1024的字节进行sha1算法
            Byte buffer[1024];
            int blockSize = (int)fread(buffer, 1, 1024, file);
            ptr += blockSize;
            //接收经过sha1算法加密后的字节数组
            Byte *hashed = malloc(20 + 1);
            memset(hashed, 0, 21);
            SHA1_Update(&content, buffer, blockSize);
            SHA1_Final(hashed, &content);
            memcpy(sha1Buffer + ptr2, hashed, SHA_DIGEST_LENGTH);
            free(hashed);
            ptr2 += SHA_DIGEST_LENGTH;
            
            NSLog(@"ftellfile:%ld", ftell(file) + 1024);
            if ((ftell(file) + 1024) > fileLength) {
                break;
            }
        }
    }
    
    Byte finalSha1Hash[SHA_DIGEST_LENGTH];
    SHA_CTX content;
    if (SHA1_Init(&content)) {
        SHA1_Update(&content, sha1Buffer, ptr2);
        SHA1_Final(finalSha1Hash, &content);
    }
    fclose(file);
    
    uint8_t calculatedHash[100] = { 0x00 };
    int length = 0;
    [self calculateHashForCBK:finalSha1Hash calculatedHash:calculatedHash length:&length];
    NSString *tempCbk = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"Locations.itdb.cbk"];
    FILE *cbkFile = fopen([tempCbk UTF8String], "ab+");
    fwrite(calculatedHash, 1, length, cbkFile);
    fwrite(finalSha1Hash, 1, 20, cbkFile);
    fwrite(sha1Buffer, 1, ptr2, cbkFile);
    fflush(cbkFile);
    fclose(cbkFile);
    
    NSString *remotCBKPath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunes Library.itlp/Locations.itdb.cbk"];
    if ([[iPod fileSystem] fileExistsAtPath:remotCBKPath] == YES) {
        [[iPod fileSystem] unlink:remotCBKPath];
    }
    [[iPod fileSystem] copyLocalFile:tempCbk toRemoteFile:remotCBKPath];
    [[NSFileManager defaultManager] removeItemAtPath:tempCbk error:nil];
}

- (void)calculateHashForCBK:(Byte [])finalSha1Hash calculatedHash:(uint8_t[])calculatedHash length:(int*)length{
    // ToDo 这里去计算hash72的值
    *length = 46;
    NSURL *uri = [MediaHelper getHashWebserviceUri];
    NSString *nameSpace = [MediaHelper getHashWebserviceNameSpace];
    NSString *sha1Str = [NSString stringToHex:finalSha1Hash length:SHA_DIGEST_LENGTH];
    NSLog(@"sha1Str %@", sha1Str);
    NSString *uuidStr = [[iPod deviceInfo] serialNumberForHashing];
    NSLog(@"uuidStr %@", uuidStr);
    BOOL result = NO;
    [MediaHelper getHashByWebservice:uri nameSpace:nameSpace methodName:@"C0DD217E838A662" sha1:sha1Str uuid:uuidStr signature:calculatedHash isSuccess:&result];
}

- (NSString*)getSortString:(NSString*)item {
    NSString *sortString = nil;
    if ([item hasPrefix:@"The "]) {
        sortString = [item substringFromIndex:4];
    } else if ([item hasPrefix:@"A "]) {
        sortString = [item substringFromIndex:2];
    } else {
        sortString = item;
    }
    return sortString;
}

- (int64_t)getMaxTrackDBID {
    int64_t iD = 0;
    @try {
        NSString *queryCmd = @"select Max(pid) from item";
        FMResultSet *rs = nil;
        rs = [_libraryConnection executeQuery:queryCmd];
        while ([rs next]) {
            iD = [rs longLongIntForColumnIndex:0];
        }
        [rs close];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    return iD;
}

@end

@implementation IMBEntry
@synthesize iD = _iD;
@synthesize value = _value;
@synthesize isUnknown = _isUnknown;
@synthesize hasMusicVideos = _hasMusicVideos;
@synthesize hasMovies = _hasMovies;
@synthesize hasMusic = _hasMusic;
@synthesize hasSongs = _hasSongs;

- (NSString*)description
{
	return [NSString stringWithFormat:@"<IMBEntry id=%lld value=%@ isUnknown=%d hasMusicVideos=%d hasMovies=%d hasMusic=%d hasSongs=%d >"
            ,_iD,_value,_isUnknown,_hasMusicVideos,_hasMovies,_hasMusic,_hasSongs];
}

@end

@implementation IMBAlbumEntry
@synthesize artistID = _artistID;
- (NSString*)description
{
	return [NSString stringWithFormat:@"<IMBEntry id=%lld artistID=%lld value=%@ isUnknown=%d hasMusicVideos=%d hasMovies=%d hasMusic=%d hasSongs=%d >"
            ,_iD,_artistID,_value,_isUnknown,_hasMusicVideos,_hasMovies,_hasMusic,_hasSongs];
}

@end

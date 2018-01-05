//
//  IMBSqliteTables_Nano5G.m
//  iMobieTrans
//
//  Created by zhang yang on 13-4-27.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBSqliteTables_Nano6G.h"
#import "MediaHelper.h"
#import "IMBTrack.h"
#import "IMBPlaylist.h"
#import <openssl/sha.h>
#import "NSString+Category.h"
#import "IMBDeviceInfo.h"

@implementation IMBSqliteTables_Nano6G

- (id)initWithIPod:(IMBiPod *)ipod {
    self = [super initWithIPod:ipod];
    if (self) {
        _trackArtists = [[NSMutableArray alloc] init];
        _nextTrackArtistId = 1;
    }
    return self;
}

- (void)dealloc
{
    if (_trackArtists != nil) {
        [_trackArtists release];
    }
    [super dealloc];
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
    NSLog(@"_baseLocations:%@",[_baseLocations description] );
    
    query = @"select id, genre,is_unknown,has_music from genre_map order by id";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        int iD = [rs intForColumn:@"id"];
        NSString *genre = [rs stringForColumn:@"genre"];
        if ([MediaHelper stringIsNilOrEmpty:genre] == FALSE) {
            entity = [[IMBEntry alloc] init];
            [entity setID:iD];
            [entity setValue:genre];
            entity.isUnknown = [rs boolForColumn:@"is_unknown"];
            entity.hasMusic = [rs boolForColumn:@"has_music"];
            [_genres addObject:entity];
            [entity release];
            entity = nil;
        }
        _nextGenreId = iD + 1;
    }
    [rs close];
    NSLog(@"_genres:%@",[_genres description] );
    
    query = @"select pid, name,is_unknown,has_songs,has_music_videos from artist order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long long iD = [rs longLongIntForColumn:@"pid"];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name] == FALSE) {
            entity = [[IMBEntry alloc] init];
            [entity setID:iD];
            [entity setValue:name];
            entity.isUnknown = [rs boolForColumn:@"is_unknown"];
            entity.hasSongs = [rs boolForColumn:@"has_songs"];
            entity.hasMusicVideos = [rs boolForColumn:@"has_music_videos"];
            [_artists addObject:entity];
            [entity release];
            entity = nil;
        }
        _nextArtistId = iD + 1;
    }
    [rs close];
    NSLog(@"_artists:%@",[_artists description] );
    
        
    query = @"select pid, ifnull(artist_pid,0), name,is_unknown,has_songs,has_music_videos,has_movies from album order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long long iD = [rs longLongIntForColumn:@"pid"];
        long long artistId = [rs longLongIntForColumnIndex:1];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name] == FALSE) {
            albumEntry = [[IMBAlbumEntry alloc] init];
            [albumEntry setID:iD];
            [albumEntry setArtistID:artistId];
            [albumEntry setValue:name];
            albumEntry.isUnknown = [rs boolForColumn:@"is_unknown"];
            albumEntry.hasMusic = [rs boolForColumn:@"has_songs"];
            albumEntry.hasMusicVideos = [rs boolForColumn:@"has_music_videos"];
            albumEntry.hasMovies = [rs boolForColumn:@"has_movies"];
            [_albums addObject:albumEntry];
            [albumEntry release];
            albumEntry = nil;
        }
        _nextAlbumId = iD + 1;
    }
    [rs close];
    NSLog(@"_albums:%@",[_albums description] );
    
    query = @"select id, kind from location_kind_map order by id";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        int iD = [rs intForColumn:@"id"];
        NSString *kind = [rs stringForColumn:@"kind"];
        if ([MediaHelper stringIsNilOrEmpty:kind] == NO) {
            [_locationKinds setValue:[NSNumber numberWithInt:iD] forKey:kind];
        }
        _nextKindId = iD + 1;
    }
    [rs close];
    NSLog(@"_locationKinds:%@",[_locationKinds description] );
    
    query = @"select pid, name,is_unknown,has_songs,has_music_videos from track_artist order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long long iD = [rs longLongIntForColumn:@"pid"];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name] == FALSE) {
            entity = [[IMBEntry alloc] init];
            [entity setID:iD];
            [entity setValue:name];
            entity.isUnknown = [rs boolForColumn:@"is_unknown"];
            entity.hasMusic = [rs boolForColumn:@"has_songs"];
            entity.hasMusicVideos = [rs boolForColumn:@"has_music_videos"];
            [_trackArtists addObject:entity];
            [entity release];
            entity = nil;
        }
        _nextTrackArtistId = iD + 1;
    }
    [rs close];
    NSLog(@"_trackArtists:%@",[_trackArtists description] );
    
}
//这里是从TrackArtist里面读取数据。
- (long long)getArtistID:(NSString *)artist track:(IMBTrack *)track {
    long long artistID = 0;
    NSLog(@"artist %@", artist);
    //这里需要判断是否是unknown的artist，如果是则加入到unknown中，否则就插入一条新的数
    if ([MediaHelper stringIsNilOrEmpty:artist]) {
        //看是否已经有了unknown的东东了，无则加入到数据库中。
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBEntry *artistEntity, NSDictionary *bindings) {
            return artistEntity.isUnknown == TRUE;
        }];
        NSArray *preArray = [_trackArtists filteredArrayUsingPredicate:pre];
        IMBEntry *entry = nil;
        if (preArray != nil && [preArray count] > 0) {
            entry = [preArray objectAtIndex:0];
        }
        if (entry == nil) {
            NSString *query = @"insert into track_artist (pid, name, sort_name, has_songs, has_non_compilation_tracks,name_order,is_unknown) values (:pid, :name, :sort_name, 1, 1,4294967295,1)";
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithLongLong:_nextTrackArtistId], @"pid",
                                   CustomLocalizedString(@"mediaView_id_3", nil), @"name",
                                   [self getSortString:CustomLocalizedString(@"mediaView_id_3", nil)], @"sort_name",
                                   nil];
            [_libraryConnection executeUpdate:query withParameterDictionary:param];
            entry = [[IMBEntry alloc] init];
            [entry setID:_nextTrackArtistId++];
            [entry setValue:CustomLocalizedString(@"mediaView_id_3", nil)];
            entry.isUnknown = TRUE;
            entry.hasSongs = TRUE;
            [_trackArtists addObject:entry];
            [entry release];
            entry = nil;
        }
        artistID = entry.iD;
        NSLog(@"_trackArtists:%@",[_trackArtists description] );
        return artistID;
    }
    //如果不为空则追加一次
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBEntry *artistEntity, NSDictionary *bindings) {
        NSLog(@"artistEntity %@", [artistEntity description]);
        return [artist isEqualToString: artistEntity.value];
    }];
    
    
    NSArray *preArray = [_trackArtists filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        NSString *query = @"insert into track_artist (pid, name, sort_name, has_songs, has_non_compilation_tracks) values(:pid, :name, :sort_name, 1, 1)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:_nextTrackArtistId], @"pid",
                               artist, @"name",
                               [self getSortString:artist], @"sort_name",
                               nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBEntry alloc] init];
        [entry setID:_nextTrackArtistId++];
        [entry setValue:artist];
        entry.isUnknown = FALSE;
        entry.hasSongs = TRUE;
        [_trackArtists addObject:entry];
        [entry release];
        entry = nil;
    }
    NSLog(@"_trackArtists:%@",[_trackArtists description] );
    artistID = entry.iD;
    NSLog(@"artistID: %lld",artistID);

    return artistID;
}

- (long long)getAlbumArtistID:(NSString *)albumArtist track:(IMBTrack *)track {
    long long albumArtistID = 0;
    NSLog(@"albumArtist %@", albumArtist);
    bool hasMV = FALSE;
    if (track.mediaType == MusicVideo)
    {
        hasMV = TRUE;
    }
    if ([MediaHelper stringIsNilOrEmpty:albumArtist]) {
        //看是否已经有了unknown的东东了，无则加入到数据库中。
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBEntry *artistEntity, NSDictionary *bindings) {
            return artistEntity.isUnknown == TRUE;
        }];
        NSArray *preArray = [_artists filteredArrayUsingPredicate:pre];
        IMBEntry *entry = nil;
        if (preArray != nil && [preArray count] > 0) {
            entry = [preArray objectAtIndex:0];
        }

        if (entry == nil) {
            NSString *query = @"insert into artist (pid, kind, name,sort_name,name_order,has_songs,is_unknown,has_music_videos) values(:pid, :kind, :name,:sort_name,4294967295,1,1,:has_music_videos)";            
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithLongLong:_nextTrackArtistId], @"pid",
                                   [NSNumber numberWithInt:2], @"kind",
                                   CustomLocalizedString(@"mediaView_id_3", nil), @"name",
                                   [self getSortString:CustomLocalizedString(@"mediaView_id_3", nil)], @"sort_name",
                                   [NSNumber numberWithBool:hasMV], @"has_music_videos",
                                   nil];
            [_libraryConnection executeUpdate:query withParameterDictionary:param];
            entry = [[IMBEntry alloc] init];
            [entry setID:_nextArtistId++];
            [entry setValue:CustomLocalizedString(@"mediaView_id_3", nil)];
            entry.isUnknown = TRUE;
            entry.hasSongs = TRUE;
            entry.hasMusicVideos = hasMV;
            [_artists addObject:entry];
            [entry release];
            entry = nil;
        } else {
            //这里为更新部分，需要更新has_music_videos
            if (entry.hasMusicVideos == FALSE && hasMV == TRUE ) {
                //Update a new UnKnownAlbum
                NSString *query = @"update artist set has_music_videos = 1 where pid = :pid";
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithLongLong:entry.iD], @"pid",
                                       nil];
                [_libraryConnection executeUpdate:query withParameterDictionary:param];
                entry.HasMusicVideos = true;
            }
            
        }
        albumArtistID = entry.iD;
        NSLog(@"_artists:%@",[_artists description] );
        return albumArtistID;
    }
    //如果不为空则再追加一次
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBEntry *artistEntity, NSDictionary *bindings) {
        NSLog(@"artistEntity %@", [artistEntity description]);
        return [albumArtist isEqualToString: artistEntity.value];
    }];
    
    
    NSArray *preArray = [_artists filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        NSString *query = @"insert into artist (pid, kind, name,sort_name,name_order,has_songs,is_unknown,has_music_videos) values(:pid, :kind, :name,:sort_name,4294967295,1,1,:has_music_videos)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:_nextArtistId], @"pid",
                               [NSNumber numberWithInt:2], @"kind",
                               albumArtist, @"name",
                               [self getSortString:albumArtist], @"sort_name",
                               [NSNumber numberWithBool:hasMV], @"has_music_videos",
                               nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBEntry alloc] init];
        [entry setID:_nextArtistId++];
        [entry setValue:albumArtist];
        entry.isUnknown = FALSE;
        entry.hasSongs = TRUE;
        entry.hasMusicVideos = hasMV;
        [_artists addObject:entry];
        [entry release];
        entry = nil;
    }
    NSLog(@"_artists:%@",[_artists description] );
    albumArtistID = entry.iD;
    return albumArtistID;
}

- (int)getGenreID:(NSString*)genre {
    int genreID = 0;
    if ([MediaHelper stringIsNilOrEmpty:genre]) {
        //看是否已经有了unknown的东东了，无则加入到数据库中。
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBEntry *genreEntity, NSDictionary *bindings) {
            return genreEntity.isUnknown == TRUE;
        }];
        NSArray *preArray = [_genres filteredArrayUsingPredicate:pre];
        IMBEntry *entry = nil;
        if (preArray != nil && [preArray count] > 0) {
            entry = [preArray objectAtIndex:0];
        }
        if (entry == nil) {
            NSString *query = @"insert into genre_map (id, genre, is_unknown, has_music,genre_order) values(:id, :genre, 1, 1, 4294967295)";
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:_nextGenreId], @"id",
                                   @"Unknown Genre", @"genre",
                                   nil];
            [_libraryConnection executeUpdate:query withParameterDictionary:param];
            entry = [[IMBEntry alloc] init];
            [entry setID:_nextGenreId++];
            [entry setValue:@"Unknown Genre"];
            entry.isUnknown = TRUE;
            entry.hasMusic = TRUE;
            [_genres addObject:entry];
            [entry release];
            entry = nil;
            NSLog(@"_genres:%@",[_genres description] );
        }
        genreID = (int)entry.iD;
        return genreID;
    }
    
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[(IMBEntry*)evaluatedObject value] lowercaseString] isEqualToString:[genre lowercaseString]];
    }];
    NSArray *preArray = [_genres filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        NSString *query = @"insert into genre_map (id, genre, is_unknown, has_music) values(:id, :genre, 0, 1)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_nextGenreId], @"id",
            genre, @"genre", nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBEntry alloc] init];
        [entry setID:_nextGenreId++];
        [entry setValue:genre];
        [_genres addObject:entry];
        [entry release];
        entry = nil;
    }
    NSLog(@"_genres:%@",[_genres description] );
    genreID = (int)entry.iD;
    return genreID;
}

- (long long)getAlbumID:(long long)artistId track:(IMBTrack *)track {
    long long albumID = 0;
    bool hasMV = FALSE;
    if (track.mediaType == MusicVideo)
    {
        hasMV = TRUE;
    }
    if ([MediaHelper stringIsNilOrEmpty:track.album]) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBAlbumEntry *albEntity, NSDictionary *bindings) {
            return albEntity.isUnknown == TRUE;
        }];
        
        NSArray *preArray = [_albums filteredArrayUsingPredicate:pre];
        IMBAlbumEntry *entry = nil;
        if (preArray != nil && [preArray count] > 0) {
            entry = [preArray objectAtIndex:0];
        }
        if (entry == nil) {
            NSString *unAlbum = CustomLocalizedString(@"mediaView_id_4", nil);
            NSString *query = @"insert into album (pid, kind, name, sort_name, artist_pid, artwork_status, artwork_item_pid,name_order,is_unknown,has_music_videos, has_songs) values(:pid, :kind, :name, :sort_name, :artist_pid, 0, :artwork_item_pid,:name_order,1,:has_music_videos,1)";
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithLongLong:_nextAlbumId], @"pid",
                                   [NSNumber numberWithInt:2], @"kind",
                                   unAlbum, @"name",
                                   unAlbum, @"sort_name",
                                   [NSNumber numberWithLongLong:artistId], @"artist_pid",
                                   [NSNumber numberWithLongLong:track.dbID], @"artwork_item_pid",
                                   [NSNumber numberWithBool:hasMV], @"has_music_videos",
                                   nil];
            NSLog(@"params: %@",[param description]);
            [_libraryConnection executeUpdate:query withParameterDictionary:param];
            entry = [[IMBAlbumEntry alloc] init];
            [entry setID:_nextAlbumId++];
            [entry setArtistID:artistId];
            [entry setValue:unAlbum];
            entry.isUnknown = TRUE;
            entry.hasSongs = TRUE;
            entry.hasMusicVideos = hasMV;
            [_albums addObject:entry];
            [entry release];
            entry = nil;
        } else if (entry.hasMusicVideos == FALSE && hasMV == TRUE) {
            NSString *query = @"update album set has_music_videos = 1 where pid = :pid";
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithLongLong:entry.iD], @"pid",
                                   nil];
            [_libraryConnection executeUpdate:query withParameterDictionary:param];
            entry.HasMusicVideos = true;

        }
        NSLog(@"_albums:%@",[_albums description] );
        albumID = entry.iD;
        return albumID;
    }

    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBAlbumEntry *albEntity, NSDictionary *bindings) {
        return [albEntity.value isEqualToString:track.album] && albEntity.artistID == artistId;
        //return ([[[(IMBAlbumEntry*)evaluatedObject value] lowercaseStringWithLocale:[NSLocale currentLocale]] isEqualToString:[[track album] lowercaseStringWithLocale:[NSLocale currentLocale]]] && [(IMBAlbumEntry*)evaluatedObject artistID] == artistId);
    }];
    
    NSArray *preArray = [_albums filteredArrayUsingPredicate:pre];
    IMBAlbumEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        NSString *query = @"insert into album (pid, kind, name, sort_name, artist_pid, artwork_status, artwork_item_pid, has_songs,has_music_videos) values(:pid, :kind, :name, :sort_name, :artist_pid, 0, :artwork_item_pid, 1,:has_music_videos)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:_nextAlbumId], @"pid",
                               [NSNumber numberWithInt:2], @"kind",
                               [track album], @"name",
                               [self getSortString:[track album]], @"sort_name",
                               [NSNumber numberWithLongLong:artistId], @"artist_pid",
                               [NSNumber numberWithLongLong:track.dbID], @"artwork_item_pid",
                               [NSNumber numberWithBool:hasMV], @"has_music_videos",
                               nil];
        NSLog(@"params: %@",[param description]);
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBAlbumEntry alloc] init];
        [entry setID:_nextAlbumId++];
        [entry setArtistID:artistId];
        [entry setValue:[track album]];
        entry.isUnknown = FALSE;
        entry.hasSongs = TRUE;
        entry.hasMusicVideos = hasMV;
        [_albums addObject:entry];
        [entry release];
        entry = nil;
    }
    NSLog(@"_albums:%@",[_albums description] );
    albumID = entry.iD;
    return albumID;
}

//--------------------------------
//这里加入如DB的更新追加部分

- (NSString*)getUpdateTrackCommand {
    NSMutableString *updateQuery = [NSMutableString stringWithCapacity:300];
    [updateQuery appendString:@"update item set "];
    [updateQuery appendString:@"year=@year, is_compilation= :is_compilation"];
    [updateQuery appendString:@",sort_title= :sort_title,title= :title"];
    [updateQuery appendString:@",track_number= :track_number, disc_number= :disc_number, genre_id= :genre_id"];
    [updateQuery appendString:@",sort_artist= :sort_artist,artist_pid= :album_artist_pid,artist= :artist "];
    [updateQuery appendString:@",sort_album= :sort_album,album_pid= :album_pid,album= :album"];
    [updateQuery appendString:@",album_artist= :album_artist,track_artist_pid= :artist_pid"];
    [updateQuery appendString:@",is_song= :is_song,is_audio_book= :is_audio_book,is_music_video= :is_music_video,is_movie= :is_movie,is_tv_show= :is_tv_show,is_ringtone= :is_ringtone"];
    [updateQuery appendString:@",date_modified= :date_modified,remember_bookmark= :remember_bookmark,artwork_status= :artwork_status,artwork_cache_id= :artwork_cache_id"];
    [updateQuery appendString:@"where pid = :pid"];
    return updateQuery;
}

- (NSString*)getInsertTrackCommand {
    NSMutableString *insertQuery = [NSMutableString stringWithCapacity:300];
    [insertQuery appendString:@"insert into item (pid, media_kind, is_song, is_audio_book, is_music_video, is_movie, is_tv_show, is_ringtone "];
    [insertQuery appendString:@",is_voice_memo, is_rental, is_podcast, date_modified, year, content_rating, content_rating_level, is_compilation"];
    [insertQuery appendString:@",is_user_disabled, remember_bookmark, exclude_from_shuffle, artwork_status, artwork_cache_id, start_time_ms, total_time_ms, track_number"];
    [insertQuery appendString:@",track_count, disc_number, disc_count, bpm, relative_volume, genius_id, genre_id, category_id, album_pid, artist_pid, composer_pid, title"];
    [insertQuery appendString:@",artist, album, album_artist, track_artist_pid, composer, comment, description, description_long" ];
    
    [insertQuery appendString:@") VALUES (:pid, :media_kind, :is_song, :is_audio_book, :is_music_video, :is_movie, :is_tv_show, :is_ringtone"];
    
    [insertQuery appendString:@",0, 0, 0, :date_modified, :year, 0, 0, :is_compilation"];
    
    [insertQuery appendString:@",0, :remember_bookmark, 0, :artwork_status, :artwork_cache_id, 0, :total_time_ms, :track_number"];
    [insertQuery appendString:@",:track_count, :disc_number, :disc_count, 0, 0, 0, :genre_id, 0, :album_pid, :album_artist_pid, :composer_pid, :title"];
    
    [insertQuery appendString:@",:artist, :album, :album_artist, :artist_pid, :composer, :comment, :description, :description_long"];
    [insertQuery appendString:@") "];
    //"insert into avformat_info(item_pid) values (@pid)";
    return insertQuery;
}

- (void)createPlaylist:(FMDatabase*)db playList:(IMBPlaylist*)playlist {
    [super createPlaylist:db playList:playlist];
    
    NSMutableString *insertCmd = [NSMutableString stringWithCapacity:200];
    
    [insertCmd appendString:@"insert into container_ui (container_pid, play_order, is_reversed, album_field_order, repeat_mode, shuffle_items, has_been_shuffled) values (:pid, 1, 0, 1, 0, 0, 0) "];
    
     NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithLongLong:playlist.iD] forKey:@"pid"];
    BOOL result = [_dynamicConnection executeUpdate:insertCmd withParameterDictionary:params];
    _updatedDynamicDb = true;
    NSLog(@"result %d", result);
    [params release];
    params = nil;
}

/*
- (BOOL)insertAVFormat:(IMBTrack *)track db:(FMDatabase *)db {
    //TODO 需要把这部分分离
    BOOL excutResult;
    NSString *insertAVFormat = @"insert into avformat_info(item_pid) values (:pid)";
    
    NSDictionary *avFormatParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithLongLong:[track dbID]], @"pid",
                                    nil];
    excutResult = [db executeUpdate:insertAVFormat withParameterDictionary:avFormatParams];
    return excutResult;
}
*/


//对数据库进行Cleanup操作
- (void)cleanup {
    //delete entries from album table where there are no matching remaining
    NSString * deleteCmd = @"delete from album where pid not in (select album_pid from item) and is_unknown=0";
    [_libraryConnection executeUpdate:deleteCmd];
    
    deleteCmd = @"update album set has_songs = min(1, (select count(*) from item where album_pid = album.pid)) ";
    [_libraryConnection executeUpdate:deleteCmd];
    
    //delete entries from artist table where there are no matching remaining
    deleteCmd = @"delete from artist where pid not in (select artist_pid from item) and is_unknown=0 ";
    [_libraryConnection executeUpdate:deleteCmd];
    
    deleteCmd = @"update artist set has_songs = min(1, (select count(*) from item where artist_pid = artist.pid))";
    [_libraryConnection executeUpdate:deleteCmd];
    
    //delete entries from track_artist table where there are no matching remaining
    deleteCmd = @"delete from track_artist where pid not in (select track_artist_pid from item) and is_unknown=0 ";
    [_libraryConnection executeUpdate:deleteCmd];
    
    deleteCmd = @"update track_artist set has_songs = min(1, (select count(*) from item where track_artist_pid = track_artist.pid))";
    [_libraryConnection executeUpdate:deleteCmd];
    
    deleteCmd = @"update genre_map set has_music = min(1, (select count(*) from item where genre_id = genre_map.id))";
    [_libraryConnection executeUpdate:deleteCmd];
    [self reindexTableWithTblName:@"artist" ColName:@"pid" Orderby:@"UPPER(coalesce(sort_name, name))" OrderColumn:@"name_order" Where:@"where is_unknown=0"];
    
    [self reindexTableWithTblName:@"track_artist" ColName:@"pid" Orderby:@"UPPER(coalesce(sort_name, name))" OrderColumn:@"name_order" Where:@"where is_unknown=0"];
    
    [self reindexTableWithTblName:@"album" ColName:@"pid" Orderby:@"UPPER(coalesce(sort_name, name))" OrderColumn:@"sort_order" Where:@""];
    
    [self reindexTableWithTblName:@"item" ColName:@"pid" Orderby:@"UPPER(coalesce(sort_title, title))" OrderColumn:@"title_order" Where:@""];
    
    [self reindexTableWithTblName:@"genre_map" ColName:@"id" Orderby:@"UPPER(genre)" OrderColumn:@"genre_order" Where:@"where is_unknown=0"];
}

//对数据库重新进行排序
- (void) reindexTableWithTblName: (NSString*)tableName ColName:(NSString*)idCol Orderby:(NSString*)orderby OrderColumn:(NSString*)orderColumn Where:(NSString*)where {
    NSMutableArray *pids = [[NSMutableArray alloc] init];
    NSString *readQureyStr = [NSString stringWithFormat:@"select %@ from %@ %@ order by %@", idCol,tableName,where,orderby];
    FMResultSet *rs = nil;
    rs = [_libraryConnection executeQuery:readQureyStr];
    while ([rs next]) {
        [pids addObject:[NSNumber numberWithLongLong:[rs longLongIntForColumnIndex:0]]];
    }
    [rs close];
    
    long name_order = 100;
    NSString *updateQureyStr = [NSString stringWithFormat:@"update %@ set %@ = :order where %@ = :pid ", tableName,orderColumn,idCol];
    for (NSNumber *pid in pids) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               pid, @"pid",
                               [NSNumber numberWithLong:name_order],@"order",
                               nil];
        [_libraryConnection executeUpdate:updateQureyStr withParameterDictionary:param];
        name_order += 100;
    }
    [pids release];
    
}


- (void)calculateHashForCBK:(Byte [])finalSha1Hash calculatedHash:(uint8_t[])calculatedHash length:(int*)length {
    if ([[iPod deviceInfo] needHashABChkSum]) {
        *length = 57;
        NSURL *uri = [MediaHelper getHashWebserviceUri];
        NSString *nameSpace = [MediaHelper getHashWebserviceNameSpace];
        NSString *sha1Str = [NSString stringToHex:finalSha1Hash length:SHA_DIGEST_LENGTH];
        NSString *uuidStr = [[iPod deviceInfo] serialNumberForHashing];
        BOOL result = NO;
        [MediaHelper getHashByWebservice:uri nameSpace:nameSpace methodName:@"C4EC501AF7D003B" sha1:sha1Str uuid:uuidStr signature:calculatedHash isSuccess:&result];
    } else {
        return [super calculateHashForCBK:finalSha1Hash calculatedHash:calculatedHash length:length];
    }
}

@end

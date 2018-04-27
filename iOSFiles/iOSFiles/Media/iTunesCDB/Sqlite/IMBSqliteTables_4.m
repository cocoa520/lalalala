//
//  IMBSqliteTables_4.m
//  iMobieTrans
//
//  Created by Pallas on 1/13/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSqliteTables_4.h"
#import "IMBTrack.h"
#import <openssl/sha.h>
#import "NSString+Category.h"
#import "IMBDeviceInfo.h"

@implementation IMBSqliteTables_4

- (id)initWithIPod:(IMBiPod *)ipod {
    self = [super initWithIPod:ipod];
    if (self) {
        [_libraryConnection makeFunctionNamed:@"iPhoneSortKey" maximumArguments:1 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
            //@autoreleasepool {
                //const char *msg = "abcdef";
                //Byte var[] = {0x31, 0x2D};
                //sqlite3_result_blob(context, var, 2, sqlite3_free);
                //sqlite3_result_text(context, msg, strlen(msg), sqlite3_free);
                sqlite3_result_zeroblob(context, 0);
            //}
        }];
        
        [_libraryConnection makeFunctionNamed:@"iPhoneSortSection" maximumArguments:1 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
            //@autoreleasepool {
                 sqlite3_result_int(context, 12);
            //}
        }];
            
        _albumArtists = [[NSMutableArray alloc] init];
        _composers = [[NSMutableArray alloc] init];
        _nextComposerId = 1;
    }
    return self;
}

- (void)dealloc {
    if (_albumArtists != nil) {
        [_albumArtists release];
        _albumArtists = nil;
    }
    if (_composers != nil) {
        [_composers release];
        _composers = nil;
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
    NSLog(@"_genres:%@",[_genres description] );
    
    query = @"select pid, name from item_artist order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long long iD = [rs longLongIntForColumn:@"pid"];
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
    NSLog(@"_artists:%@",[_artists description] );
    
    query = @"select pid, name from album_artist order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long long iD = [rs longLongIntForColumn:@"pid"];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name] == FALSE) {
            entity = [[IMBEntry alloc] init];
            [entity setID:iD];
            [entity setValue:name];
            [_albumArtists addObject:entity];
            [entity release];
            entity = nil;
        }
        _nextAlbumArtistId = iD + 1;
    }
    [rs close];
    NSLog(@"_albumArtists:%@",[_albumArtists description] );
    
    query = @"select pid, ifnull(artist_pid,0), name from album order by pid";
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
            [_albums addObject:albumEntry];
            [albumEntry release];
            albumEntry = nil;
        }
        _nextAlbumId = iD + 1;
    }
    [rs close];
    NSLog(@"_albums:%@",[_albums description] );
    
    query = @"select pid,name from composer";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long long iD = [rs longLongIntForColumn:@"pid"];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name] == FALSE) {
            entity = [[IMBEntry alloc] init];
            [entity setID:iD];
            [entity setValue:name];
            [_composers addObject:entity];
            [entity release];
            entity = nil;
        }
        _nextComposerId = iD + 1;
    }
    [rs close];
    NSLog(@"_composers:%@",[_composers description] );
    
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
}

- (long long)getAlbumID:(long long)artistId track:(IMBTrack *)track {
    long long albumID = 0;
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
        NSString *query = @"insert into album (pid, kind, name, sort_name, artist_pid, artwork_status, artwork_item_pid) values(:pid, :kind, :name, :sort_name, :artist_pid, 0, 0)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:_nextAlbumId], @"pid",
                               [NSNumber numberWithInt:2], @"kind",
                               [track album], @"name",
                               [self getSortString:[track album]], @"sort_name",
                               [NSNumber numberWithLongLong:artistId], @"artist_pid",
                               nil];
        NSLog(@"params: %@",[param description]);
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBAlbumEntry alloc] init];
        [entry setID:_nextAlbumId++];
        [entry setArtistID:artistId];
        [entry setValue:[track album]];
        [_albums addObject:entry];
        albumID = entry.iD;
        [entry release];
        entry = nil;
    }
    NSLog(@"_albums:%@",[_albums description] );
    return albumID;
}

- (long long)getArtistID:(NSString *)artist track:(IMBTrack *)track {
    long long artistID = 0;
    NSLog(@"artist %@", artist);
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBEntry *artistEntity, NSDictionary *bindings) {
        NSLog(@"artistEntity %@", [artistEntity description]);
        return [artist isEqualToString: artistEntity.value];
        /*
        return [[[(IMBEntry*)evaluatedObject value] lowercaseStringWithLocale:[NSLocale currentLocale]] isEqualToString:[artist lowercaseStringWithLocale:[NSLocale currentLocale]]];
        */
    }];
    NSArray *preArray = [_artists filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    NSLog(@"artist1 %@", artist);
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    if (entry == nil) {
        NSString *query = @"insert into item_artist (pid, name, sort_name, artwork_album_pid) values(:pid, :name, :sort_name, 0)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:_nextArtistId], @"pid",
                               artist, @"name",
                               [self getSortString:artist], @"sort_name",
                               nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBEntry alloc] init];
        [entry setID:_nextArtistId++];
        [entry setValue:artist];
        [_artists addObject:entry];
        artistID = entry.iD;
        [entry release];
        entry = nil;
    }
    NSLog(@"_albums:%@",[_artists description] );
    return artistID;
}

- (long long)getAlbumArtistID:(NSString *)albumArtist track:(IMBTrack *)track {
    long long albumArtistID = 0;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBEntry *albArtEntity, NSDictionary *bindings) {
        return [albArtEntity.value isEqualToString:albumArtist];
        //return [[[(IMBEntry*)evaluatedObject value] lowercaseStringWithLocale:[NSLocale currentLocale]] isEqualToString:[albumArtist lowercaseStringWithLocale:[NSLocale currentLocale]]];
    }];
    
    NSArray *preArray = [_albumArtists filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    } 
    
    if (entry == nil) {
        NSString *query = @"insert into album_artist (pid, kind, name, sort_name, artwork_status, artwork_album_pid) values(:pid, :kind, :name, :sort_name, 0, 0)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:_nextAlbumArtistId], @"pid",
                               [NSNumber numberWithInt:2], @"kind",
                               albumArtist, @"name",
                               [self getSortString:albumArtist], @"sort_name",
                               nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBEntry alloc] init];
        [entry setID:_nextAlbumArtistId++];
        [entry setValue:albumArtist];
        [_albumArtists addObject:entry];
        albumArtistID = entry.iD;
        [entry release];
        entry = nil;
    }
    NSLog(@"_albumArtists:%@",[_albumArtists description] );
    return albumArtistID;
}

- (void)cleanup {
    NSString * deleteCmd = @"delete from album where pid not in (select album_pid from item )";
    [_libraryConnection executeUpdate:deleteCmd];
    
    deleteCmd = @"delete from item_artist where pid not in (select artist_pid from item )";
    [_libraryConnection executeUpdate:deleteCmd];
    
    deleteCmd = @"delete from album_artist where pid not in (select artist_pid from album )";
    [_libraryConnection executeUpdate:deleteCmd];
    
    deleteCmd = @"delete from sort_map";
    [_libraryConnection executeUpdate:deleteCmd];
}

- (NSDictionary*)fillTrackParameters:(IMBTrack *)track {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[super fillTrackParameters:track]];
    [params setValue:[NSNumber numberWithLongLong:[self getComposerID:[track composer]]] forKey:@"composer_pid"];
    [params setValue:[track composer] forKey:@"composer"];
    NSLog(@"params: %@", [params description]);
    return params;
}

- (long long)getComposerID:(NSString*)composer {
    long long composerID = 0;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBEntry *comEntity, NSDictionary *bindings) {
        return [comEntity.value isEqualToString: composer];
        //return [[[(IMBEntry*)evaluatedObject value] lowercaseStringWithLocale:[NSLocale currentLocale]] isEqualToString:[composer lowercaseStringWithLocale:[NSLocale currentLocale]]];
    }];
    
    NSArray *preArray = [_composers filteredArrayUsingPredicate:pre];
    IMBEntry *entry = nil;
    if (preArray != nil && [preArray count] > 0) {
        entry = [preArray objectAtIndex:0];
    }
    
    if (entry == nil) {
        NSString *query = @"insert into composer (pid , name, sort_name ) values(:pid, :name, :sort_name )";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:_nextComposerId], @"pid",
                               composer, @"name",
                               composer, @"sort_name",
                               nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        entry = [[IMBEntry alloc] init];
        [entry setID:_nextComposerId++];
        [entry setValue:composer];
        [_composers addObject:entry];
        composerID = entry.iD;
        [entry release];
        entry = nil;
    }
    return composerID;
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

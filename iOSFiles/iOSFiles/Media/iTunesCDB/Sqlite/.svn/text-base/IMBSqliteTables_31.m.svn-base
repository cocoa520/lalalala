//
//  IMBSqliteTables_31.m
//  iMobieTrans
//
//  Created by Pallas on 1/13/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSqliteTables_31.h"
#import "MediaHelper.h"
#import "IMBTrack.h"

@implementation IMBSqliteTables_31

- (id)initWithIPod:(IMBiPod *)ipod {
    self = [super initWithIPod:ipod];
    if (self) {
        //三个Function函数
        [_libraryConnection makeFunctionNamed:@"ML3SortCollation" maximumArguments:1 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
            //@autoreleasepool {
            //const char *msg = "abcdef";
            //Byte var[] = {0x31, 0x2D};
            //sqlite3_result_blob(context, var, 2, sqlite3_free);
            //sqlite3_result_text(context, msg, strlen(msg), sqlite3_free);
            sqlite3_result_zeroblob(context, 0);
            //}
        }];
        
        [_libraryConnection makeFunctionNamed:@"ML3SearchCollation" maximumArguments:1 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
            //@autoreleasepool {
            //const char *msg = "abcdef";
            //Byte var[] = {0x31, 0x2D};
            //sqlite3_result_blob(context, var, 2, sqlite3_free);
            //sqlite3_result_text(context, msg, strlen(msg), sqlite3_free);
            sqlite3_result_zeroblob(context, 0);
            //}
        }];
        
        [_libraryConnection makeFunctionNamed:@"ML3Section" maximumArguments:1 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
            //@autoreleasepool {
            //const char *msg = "abcdef";
            //Byte var[] = {0x31, 0x2D};
            //sqlite3_result_blob(context, var, 2, sqlite3_free);
            //sqlite3_result_text(context, msg, strlen(msg), sqlite3_free);
            sqlite3_result_int(context, 0);
            //}
        }];
        
        /*
        [_libraryConnection makeFunctionNamed:@"iPhoneSortSection" maximumArguments:1 withBlock:^(sqlite3_context *context, int argc, sqlite3_value **argv) {
            //@autoreleasepool {
            sqlite3_result_int(context, 12);
            //}
        }];
        */
        
        /*
        [SQLiteFunction(Name = "ML3Section", Arguments = 1, FuncType = FunctionType.Scalar)]
        public class ML3Section : SQLiteFunction
        {
            public override object Invoke(object[] args)
            {
                if (args[0] is DBNull)
                    return 0;
                else
                {
                    string arg0 = (string)args[0];
                    if (arg0.Length == 0) return 0;
                    arg0 = arg0.ToUpperInvariant();
                    int chr = (int)arg0[0];
                    if (chr >= 65) //65 is uppercase 'a'
                        chr -= 64;
                    return chr;
                }
            }
        }
        */
        
        
        _albumArtists = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_albumArtists != nil) {
        [_albumArtists release];
        _albumArtists = nil;
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
    
    query = @"select pid, name from item_artist order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long iD = [rs longForColumn:@"pid"];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name]) {
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
    
    query = @"select pid, name from album_artist order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long iD = [rs longForColumn:@"pid"];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name]) {
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

    query = @"select pid, ifnull(artist_pid,0), name from album order by pid";
    rs = [_libraryConnection executeQuery:query];
    while ([rs next]) {
        long iD = [rs longForColumn:@"pid"];
        long artistId = [rs longForColumnIndex:1];
        NSString *name = [rs stringForColumn:@"name"];
        if ([MediaHelper stringIsNilOrEmpty:name]) {
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
        if ([MediaHelper stringIsNilOrEmpty:kind] == NO) {
             [_locationKinds setValue:[NSNumber numberWithInt:iD] forKey:kind];
        }
        _nextKindId = iD + 1;
    }
    [rs close];
}

- (long long)getAlbumID:(long long)artistId track:(IMBTrack *)track {
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
        
        NSString *query = @"insert into album (pid, kind, name, sort_name, artist_pid, artwork_status, artwork_item_pid) values(:pid, :kind, :name, :sort_name, :artist_pid, 0, 0)";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:_nextAlbumId], @"pid",
                               [NSNumber numberWithInt:2], @"kind",
                               [track album], @"name",
                               [self getSortString:[track album]], @"sort_name",
                               [NSNumber numberWithLongLong:artistId], @"artist_pid",
                               nil];
        [_libraryConnection executeUpdate:query withParameterDictionary:param];
        
        entry = [[IMBAlbumEntry alloc] init];
        [entry setID:_nextAlbumId++];
        [entry setArtistID:artistId];
        [entry setValue:[track album]];
        [_albums addObject:entry];
        albumID = [entry iD];
        [entry release];
        entry = nil;
    }
    return albumID;
}

- (long long)getArtistID:(NSString *)artist track:(IMBTrack *)track {
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
        artistID = [entry iD];
        [entry release];
        entry = nil;
    }
    return artistID;
}

- (long long)getAlbumArtistID:(NSString *)albumArtist track:(IMBTrack *)track {
    long long albumArtistID = 0;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[(IMBEntry*)evaluatedObject value] lowercaseString] isEqualToString:[albumArtist lowercaseString]];
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
        albumArtistID = [entry iD];
        [entry release];
        entry = nil;
    }
    return albumArtistID;
}

- (void)cleanup {
    NSString *deleteSql = @"delete from album where pid not in (select album_pid from item )";
    [_libraryConnection executeUpdate:deleteSql];
    
    deleteSql = @"delete from item_artist where pid not in (select artist_pid from item )";
    [_libraryConnection executeUpdate:deleteSql];
    
    deleteSql = @"delete from album_artist where pid not in (select artist_pid from album )";
    [_libraryConnection executeUpdate:deleteSql];
}

@end

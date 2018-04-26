//
//  IMBPurchasesSqlite.m
//  iMobieTrans
//
//  Created by zhang yang on 13-7-14.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBPurchasesSqlite.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"
#import "IMBTrack.h"
#import "IMBDeviceInfo.h"
#import "NSString+Category.h"

@implementation IMBPurchasesSqlite

- (id)initWithiPod:(IMBiPod *)iPod{
    self = [super init];
    if (self) {
        _iPod = iPod;
        
        //iPod = ipod;
        NSString *remoteLibraryFile = nil;
        NSString *remoteLibrarySHMFile = nil;
        NSString *remoteLibraryWALFile = nil;

        fileManager = [NSFileManager defaultManager];
        _localLibraryFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb"];
        _localLibrarySHMFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb-shm"];
        _localLibraryWALFile = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:@"MediaLibrary.sqlitedb-wal"];
        fileManager = [NSFileManager defaultManager];
        
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
                    [_libraryConnection setShouldCacheStatements:NO];
                    [_libraryConnection setTraceExecution:NO];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
        }
    }
    return self;
}

- (void)openDataBase {
    if ([_libraryConnection open]) {
        [_libraryConnection setShouldCacheStatements:NO];
        [_libraryConnection setTraceExecution:NO];
    }
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
    
    [super dealloc];
}

- (NSMutableArray*) getPurchasesTrackList {
    [self openDataBase];
    //2.得到Purchase的Sql文。
    NSString *query = [self getPurchasesTrackQuery];
    FMResultSet *rs = [_libraryConnection executeQuery:query];
    NSMutableArray *tracks = [[[NSMutableArray alloc] init] autorelease];
    while ([rs next]) {
        //编辑track
        IMBTrack *track = [[IMBTrack alloc] init];
        track.isPurchase = TRUE;
        track.dbID = [rs longLongIntForColumn:@"item_pid"];
        track.composer = [rs stringForColumn:@"composer"];
        track.trackNumber = [rs intForColumn:@"track_number"];
        track.year = [rs intForColumn:@"year"];
        
        track.discNumber = [rs intForColumn:@"disc_number"];
        track.totalDiscCount = [rs intForColumn:@"disc_count"];
        track.albumTrackCount = [rs intForColumn:@"track_count"];
        
        track.title = [rs stringForColumn:@"title"];
        [track setTitleAttributedString];
        track.artist = [rs stringForColumn:@"item_artist"];
        track.albumArtist = [rs stringForColumn:@"album_artist"];
        track.album = [rs stringForColumn:@"album"];
        track.genre = [rs stringForColumn:@"genre"];
        track.dateLastPalyed = [rs intForColumn:@"date_played"];
        /*
        long datetimes = reader["date_played"] != DBNull.Value ? Convert.ToInt64(reader["date_played"]) : 0;
        track.DateLastPlayed = new IPodDateTime((uint)datetimes);
        */
        
        track.rating = (Byte)[rs intForColumn:@"user_rating"];
        track.fileSize = [rs intForColumn:@"file_size"];
        track.length = [rs intForColumn:@"total_time_ms"];
        //TODO 到底是什么字段呢
        track.playCount = [rs intForColumn:@"play_count_user"];
        NSString *path = [rs stringForColumn:@"location"];
        NSString *basePath = [rs stringForColumn:@"path"];
        if (![basePath contains:@"Purchases"] && ![basePath contains:@"CloudAssets"]) {
            continue;
        }
        if (path != nil &&  basePath != nil) {
            track.filePath = [basePath stringByAppendingPathComponent:path];
            NSLog(@"track.filePath %@", track.filePath);
            if (![MediaHelper stringIsNilOrEmpty:track.filePath]) {
                if ([_iPod.fileSystem fileExistsAtPath:track.filePath]) {
                    track.fileIsExist = TRUE;
                }
            }
        }
        if ([_iPod.deviceInfo.productVersion isVersionMajorEqual:@"9.0"]) {
            NSString *querySql = [NSString stringWithFormat:@"select relative_path from artwork_token,artwork where artwork.artwork_token =  artwork_token.artwork_token and  entity_pid = %lld",track.dbID];
             FMResultSet *rs1 = [_libraryConnection executeQuery:querySql];
            while ([rs1 next]) {
                NSString *relativePath = [rs1 stringForColumn:@"relative_path"];
                NSString *directoryPath = @"/iTunes_Control/iTunes/Artwork/Originals/";
                NSString *artWortStr = [directoryPath stringByAppendingPathComponent:relativePath];
                track.artworkPath = artWortStr;
                track.purchasesArtworkPath = artWortStr;
//                track.filePath = artWortStr;
            }
            [rs1 close];
        }
   
        int mediaTypeInt = [rs intForColumn:@"media_kind"];
        track.mediaType = [self getMediaType:mediaTypeInt WithPath:track.filePath];
        track.isVideo = [self checkIsVideo:track.mediaType];
        
        [tracks addObject:track];
        [track release];
    }
    [rs close];
    [self closeDataBase];
    return tracks;
}

- (NSString*) getPurchasesTrackQuery {
    //ios7以上
    if ([_iPod.deviceInfo.productVersion isVersionMajorEqual:@"9.0"]) {
        NSString *query = @"select item.item_pid,item_extra.title,item_extra.year,item.media_type,item_artist,album,genre,album_artist,item.disc_number,item.track_number,base_location.path,location,item_extra.total_time_ms,item_extra.file_size,item_stats.user_rating,item_stats.play_count_user,item_stats.has_been_played,item_stats.date_played,composer.composer,item_extra.disc_count,item_extra.track_count,item_extra.media_kind,is_ota_purchased from item left join item_extra on item_extra.item_pid = item.item_pid left join item_store on item_store.item_pid = item.item_pid left join item_stats on item_stats.item_pid = item.item_pid left join base_location on base_location.base_location_id = item.base_location_id left join item_artist on item.item_artist_pid = item_artist.item_artist_pid left join album on item.album_pid = album.album_pid left join album_artist on item.album_artist_pid = album_artist.album_artist_pid left join genre on genre.genre_id= item.genre_id left join composer on composer.composer_pid= item.composer_pid"; //where item_store.is_ota_purchased = 1 or item_store.cloud_asset_available > 0";
        return query;
    }else if ([@"7.0" isVersionLessEqual:_iPod.deviceInfo.productVersion]) {
        NSMutableString *query = [[[NSMutableString alloc] init] autorelease];
        [query appendString:@"select item.item_pid,item_extra.title,item_extra.year,item.media_type,item_artist,"];
        [query appendString:@"album,genre,album_artist,item.disc_number,item.track_number,base_location.path,"];
        [query appendString:@"location,item_extra.total_time_ms,item_extra.file_size,"];
        [query appendString:@"item_stats.user_rating,item_stats.play_count_user,item_stats.has_been_played,item_stats.date_played,"];
        [query appendString:@"composer.composer,item_extra.disc_count,"];
        [query appendString:@"item_extra.track_count,item_extra.media_kind, is_ota_purchased"];
        [query appendString:@" from item left join item_extra on item_extra.item_pid = item.item_pid"];
        [query appendString:@" left join item_store on item_store.item_pid = item.item_pid"];
        [query appendString:@" left join item_stats on item_stats.item_pid = item.item_pid"];
        [query appendString:@" left join base_location on base_location.base_location_id = item.base_location_id"];
        [query appendString:@" left join item_artist on item.item_artist_pid = item_artist.item_artist_pid"];
        [query appendString:@" left join album on item.album_pid = album.album_pid"];
        [query appendString:@" left join album_artist on item.album_artist_pid = album_artist.album_artist_pid"];
        [query appendString:@" left join genre on genre.genre_id= item.genre_id"];
        [query appendString:@" left join composer on composer.composer_pid= item.composer_pid"];
        [query appendString:@" where is_ota_purchased = 1"];
        return query;
    } else {
        //ios7以下
        return @"select item.item_pid,item_extra.title,item_extra.year,item.media_type,item_artist,album,genre,album_artist,item.disc_number,item.track_number,base_location.path,location,item_extra.total_time_ms,item_extra.file_size,item_stats.user_rating,item_stats.has_been_played,item_stats.play_count_user,item_stats.date_played,composer.composer,item_extra.disc_count,item_extra.track_count,item_extra.media_kind from item left join item_extra on item_extra.item_pid = item.item_pid left join item_stats on item_stats.item_pid = item.item_pid left join base_location on base_location.base_location_id = item.base_location_id left join item_artist on item.item_artist_pid = item_artist.item_artist_pid left join album_artist on item.album_artist_pid = album_artist.album_artist_pid left join album on item.album_pid = album.album_pid left join genre on genre.genre_id= item.genre_id left join composer on composer.composer_pid= item.composer_pid where is_ota_purchased = 1";
    }
    
}

- (MediaTypeEnum) getMediaType:(int)mediaTypeIntDB WithPath:(NSString*)path
{
    //如果是music是type
    MediaTypeEnum mediaType = 0;
    int mediaTypeInt = mediaTypeIntDB;
    if (mediaTypeInt >= 32 && mediaTypeInt < 64)
    {
        mediaTypeInt = 32;
    }
    switch (mediaTypeInt)
    {
        case Audio:
        case AudioAndVideo:
        case Podcast:
        case Audiobook:
        case Ringtone:
        case Books:
        case iTunesUGroup:
        case iTunesU:
        case PDFBooks:
        case Video:
        case VideoPodcast:
        case MusicVideo:
        case TVShow:
        case TVAndMusic:
        case iTunesUVideo:
            mediaType = (MediaTypeEnum)mediaTypeInt;
            break;
        default:
            //如果是其他则通过后缀名来
        {
            NSString *extension = [path pathExtension];
            if ([extension isCaseInsensitiveLike:@"mp3"] || [extension isCaseInsensitiveLike:@"m4a"] ) {
                mediaType = Audio;
            } else if ([extension isCaseInsensitiveLike:@"mov"] ||
                       [extension isCaseInsensitiveLike:@"mp4"] ||
                       [extension isCaseInsensitiveLike:@"m4v"] ||
                       [extension isCaseInsensitiveLike:@"m4p"] ) {
                mediaType = Video;
            } else {
                mediaType = Audio;
            }
            break;
        }
        
    }
    return mediaType;
}

-(BOOL) checkIsVideo:(MediaTypeEnum)mediaType {
    switch (mediaType) {
        case Video:
        case VideoPodcast:
        case MusicVideo:
        case TVShow:
        case TVAndMusic:
        case iTunesUVideo:
            return true;
            break;
        default:
            return false;
    }
}

@end

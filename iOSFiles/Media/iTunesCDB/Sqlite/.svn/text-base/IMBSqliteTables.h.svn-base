//
//  IMBSqliteTables.h
//  iMobieTrans
//
//  Created by Pallas on 1/13/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

//typedef unsigned char uchar;

@class IMBiPod;
@class IMBTrack;
@class IMBPlaylist;
@class IMBEntry;

@interface IMBSqliteTables : NSObject {
@protected
    IMBiPod *iPod;
    NSString *_localLibraryFile, *_localLocationsFile, *_localDynamicFile;
    NSFileManager *fileManager;
    FMDatabase *_libraryConnection, *_locationsConnection, *_dynamicConnection;
    //存放的是IMBEntity实体对象
    NSMutableArray *_genres;
    //存放的是IMBAlbumEntry实体对象
    NSMutableArray *_albums;
    //存放的是IMBEntity实体对象
    NSMutableArray *_artists;
    //存放的是IMBEntity实体对象
    NSMutableArray *_baseLocations;
    
    NSMutableDictionary *_locationKinds;
    
    int _nextGenreId, _nextKindId, _nextBaseLocationId;
    long long _nextAlbumId, _nextArtistId;
    BOOL _updatedLocationsDb, _updatedDynamicDb;
}

- (id)initWithIPod:(IMBiPod*)ipod;
+ (BOOL)haveLocalSqlliteDBS:(IMBiPod*)ipod;
- (void)save;
- (void)readLookupTables;
- (NSString*)getUpdateTrackCommand;
- (NSString*)getInsertTrackCommand;
- (NSDictionary*)fillTrackParameters:(IMBTrack*)track;
- (void)updateTracks:(NSMutableArray*)tracks;
- (void)insertNewTrack:(FMDatabase*)db track:(IMBTrack*)track;
- (void)removeDeletedTracks;
- (void)cleanup;

- (int)getGenreID:(NSString*)genre;
- (long long)getArtistID:(NSString*)artist track:(IMBTrack*)track;
- (long long)getAlbumArtistID:(NSString*)albumArtist track:(IMBTrack*)track;
- (long long)getAlbumID:(long long)artistId track:(IMBTrack*)track;
- (IMBEntry*)getBaseLocation:(NSString*)path;
- (int)getExtensionID:(NSString*)filePath;
- (int)getKindID:(NSString*)kind;
- (void)insertItemStatus:(IMBTrack*)track;
- (BOOL)insertAVFormat:(IMBTrack *)track db:(FMDatabase *)db;
- (void)updatePlaylists:(NSMutableArray*)playlists;
- (void)createPlaylist:(FMDatabase*)db playList:(IMBPlaylist*)playlist;
- (void)updateLocationsCBK;
- (void)calculateHashForCBK:(Byte[])finalSha1Hash calculatedHash:(uint8_t[])calculatedHash length:(int*)length;
- (NSString*)getSortString:(NSString*)item;
- (int64_t)getMaxTrackDBID;

@end

@interface IMBEntry : NSObject {
    long long _iD;
    NSString *_value;
    BOOL _isUnknown;
    BOOL _hasMusicVideos;
    BOOL _hasMovies;
    BOOL _hasMusic;
    BOOL _hasSongs;
}

@property (nonatomic, readwrite) long long iD;
@property (nonatomic, readwrite, retain) NSString *value;
@property (nonatomic, readwrite) BOOL isUnknown;
@property (nonatomic, readwrite) BOOL hasMusicVideos;
@property (nonatomic, readwrite) BOOL hasMovies;
@property (nonatomic, readwrite) BOOL hasMusic;
@property (nonatomic, readwrite) BOOL hasSongs;

@end

@interface IMBAlbumEntry : IMBEntry {
    long long _artistID;
}

@property (nonatomic, readwrite) long long artistID;

@end

//
//  IMBSqliteTables_5.h
//  iMobieTrans
//
//  Created by zhang yang on 13-4-7.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "IMBDeviceInfo.h"
//#import "IMBLogManager.h"
@class IMBiPod;
@class IMBTrack;
@class IMBPlaylist;
@class IMBEntry;

@interface IMBSqliteTables_5 : NSObject {
    IMBiPod *iPod;
    NSString *_localLibraryFile, *_localLibrarySHMFile, *_localLibraryWALFile;
    NSFileManager *fileManager;
    FMDatabase *_libraryConnection;
    //存放的是IMBAlbumEntry实体对象
    NSMutableArray *_albums;
    //存放的是IMBEntity实体对象
    NSMutableArray *_artists;
    //存放的是IMBEntity实体对象
    NSMutableArray *_baseLocations;
    //存放的是IMBEntity实体对象
    NSMutableArray *_albumArtists;
    //存放的是IMBTrack实体对象
    NSMutableArray *_dirtyTracks;
    //存放的是IMBTrack实体对象
    NSMutableArray *_deletedTracks;
    //是一个Dictionary对象
    NSMutableDictionary *_locationKinds;

    long long _dbPid;
    
    int _nextKindId, _nextBaseLocationId;
    long long _nextAlbumId, _nextArtistId, _nextAlbumArtistId;
    long long _nextArtworkCacheId;
//    IMBLogManager *logManger;
}

@property (nonatomic, readwrite) long long dbPid;
@property (nonatomic, readwrite,retain) NSArray *dirtyTracks;
@property (nonatomic, readwrite,retain) NSArray *deletedTracks;
@property (nonatomic, copy) NSString *localLibraryFile;

- (id)initWithIPod:(IMBiPod*)ipod;
-(void) getInfoFromDirtyTracks;
- (void)closeDataBase;
- (bool) isExistPlaylist:(IMBPlaylist*)pl;
- (void) generateDeleteTracksInfo;
- (void) exactDeviceDBFiles;
- (BOOL)openDataBase;

@end

@interface IMBEntry5 : NSObject {
    long long _iD;
    NSString *_value;    
    BOOL _isDirty;
    long long _artworkCacheId;
    long long _artworkPid;
}

@property (nonatomic, readwrite) long long iD;
@property (nonatomic, readwrite, retain) NSString *value;
@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) long long artworkCacheId;
@property (nonatomic, readwrite) long long artworkPid;

@end

@interface IMBAlbumEntry5 : IMBEntry5 {
    long long _artistID;
    long long _representativePid;
}

@property (nonatomic, readwrite) long long artistID;
@property (nonatomic, readwrite) long long representativePid;
@end

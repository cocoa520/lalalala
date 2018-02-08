//
//  IMBiTunes.h
//  iMobieTrans
//
//  Created by Pallas on 3/12/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
#import "IMBiTLPlaylist.h"
#import "IMBLogManager.h"
#import "IMBiTLTrack.h"
#import "IMBAppEntity.h"

//@class IMBTrack;

enum iTunesTrackStatus {
	iTunesTrackExsit = 'tExt' /* iTune中Track存在 */,
    DeviceFileNotExsit = 'fNet' /* 设备中文件不存在 */,
	iTunesTrackAddFailed = 'tAfl' /* iTunes中加入文件存在 */,
    iTunesTrackAddSuccess = 'tAss' /* iTunes中添加Track成功 */
};
typedef enum iTunesTrackStatus iTunesTSts;


enum iTunesPlaylistStatus {
    iTunesPlaylistExsit = 'pExt' /* iTunes中Playlist存在 */,
    iTunesPlaylistAddFailed = 'pAfl' /* iTunes中Palylist新增失败 */,
    iTunesPlaylistAddSuccess = 'pAss' /* iTunes中Playlist新增成功 */
};
typedef enum iTunesPlaylistStatus iTunesPSts;


@interface IMBiTunes : NSObject {
    //消息通知中心
    NSNotificationCenter *nc;
    iTunesApplication *iTunesApp;
    NSArray *sources;
    NSFileManager *fm;
    NSMutableArray *iTLTracks;
    NSMutableArray *iTLPlaylists;
    BOOL _isLibraryParsed;
    IMBLogManager *logHandle;
    
    BOOL _loadiTunes;
    
    BOOL _isOpeniTunes;
}

+ (IMBiTunes*)singleton;

- (BOOL) parserLibrary;
@property(nonatomic, readwrite) BOOL isLibraryParsed;
@property(nonatomic, readwrite) BOOL isOpeniTunes;

- (NSArray*)getAllTracks;
//- (iTunesTrack*)checkTrackExsit:(IMBTrack*)track itunesTracks:(NSArray*)itunesTracks;

//- (NSArray*)getAllPlaylists;
//- (NSArray*)getSmartPlaylists;
//- (NSArray*)getCustomPlaylists;

//Zy
//得到所有的itlPlaylist
-(NSArray*)getiTLPlaylists;
//得到需要媒体分类的playlist
-(NSArray*)getCategoryiTLPlaylists;
-(NSArray*)getMediaCategoryiTLPlaylists;
-(NSArray*)getNotCategoryiTLPlaylists;


-(IMBiTLPlaylist*)getAppCategoryiTLPlaylist;
-(IMBiTLPlaylist*)getBookCategoryiTLPlaylist;
-(IMBiTLPlaylist*)getRingtoneCategoryiTLPlaylist;
-(NSArray*)getUserDefinediTLPlaylists;
//得到所有的itlTracks
-(NSArray*)getiTLTracks;
-(IMBiTLPlaylist*)getUserPlaylistByName:(NSString*)playlistName;
-(IMBiTLPlaylist*)getPlaylistByName:(NSString*)playlistName;
-(IMBiTLPlaylist*)getiTLPlaylistByID:(int)playlistID;
-(iTunesUserPlaylist*)getPlaylistByID:(int)playlistID;
- (IMBiTLPlaylist*)getPlaylistByDistinguished:(int)distinguishedKindId;
- (void)importFilesToiTunes:(NSArray*)fileInfos toPlaylist:(int)playlistID containRatingAndPlayCount:(BOOL)containRatingAndPlayCount;
-(IMBiTLPlaylist*)getMasterCategoryiTLPlaylist;

- (NSArray*)getTracksByPlaylistName:(NSString*)playlistName;
- (int)importFilesToiTunes:(NSArray*)unitFiles containRatingAndPlayCount:(BOOL)containRatingAndPlayCount withDelegate:(id)delegate;
- (void)importPlaylistToiTunes:(NSArray*)playlists files:(NSArray*)files;
- (int)createPlaylistByName:(NSString*)playlistName;
//- (NSArray*)getPlaylistByName:(NSString*)playlistName;

@end

@interface IMBiTunesPlaylistInfo : NSObject {
@private
    NSString *_playlistName;
    int64_t _playlistID;
    int _iTunesPlaylistID;
    BOOL _isSysPlaylist;
    NSMutableArray *_items;
    iTunesPSts _playlistStatues;
    BOOL _isExist;
    
}

@property (copy) NSString *playlistName;
@property int64_t playlistID;
@property BOOL isSysPlaylist;
@property (copy) NSMutableArray *items;
@property iTunesPSts playlistStatues;
@property int iTunesPlaylistID;
@property BOOL isExist;

@end

@interface IMBiTunesImportFileInfo : NSObject {
@private
    NSString *_sourceFilePath;
    NSString *_desFilePath;
    NSURL *_itunesFileUrl;
    BOOL _isNeedCopy;
    NSString *_trackName;
    NSString *_artist;
    NSString *_album;
    int _trackID;
    MediaTypeEnum _mediaType;
    int _playedCount;
    int _rating;
    iTunesTSts _trackStatues;
    int _trackiTunesID;
    NSMutableArray *_playlistArray;
    NSString *_oriName;
}
@property (copy) NSString *oriName;
@property (copy) NSString *artist;
@property (copy) NSString *album;
@property (copy) NSString *sourceFilePath;
@property (copy) NSString *desFilePath;
@property (copy) NSURL *itunesFileUrl;
@property BOOL isNeedCopy;
@property (copy) NSString *trackName;
@property int trackID;
@property MediaTypeEnum mediaType;
@property int playedCount;
@property int rating;
@property int trackiTunesID;
@property iTunesTSts trackStatues;
@property (nonatomic, readwrite, retain) NSMutableArray *playlistArray;

@end

@interface IMBiBookImportItemInfo : NSObject {
@private
    NSString *_sourceFilePath;
    NSString *_desFilePath;
    NSURL *_itunesFileUrl;
    BOOL _isNeedCopy;
    NSString *_bookName;
    NSString *_extension;
    NSString *_bookID;
    MediaTypeEnum _mediaType;
    iTunesTSts _trackStatues;
}

@property (nonatomic, readwrite, retain) NSString *sourceFilePath;
@property (nonatomic, readwrite, retain) NSString *desFilePath;
@property (nonatomic, readwrite, retain) NSURL *itunesFileUrl;
@property (nonatomic, readwrite) BOOL isNeedCopy;
@property (nonatomic, readwrite, retain) NSString *bookName;
@property (nonatomic, readwrite, retain) NSString *extension;
@property (nonatomic, readwrite, retain) NSString *bookID;
@property (nonatomic, readwrite) MediaTypeEnum mediaType;
@property (nonatomic, readwrite) iTunesTSts trackStatues;

@end

@interface IMBiTunesImportAppInfo : NSObject {
@private
    NSString *_appKey;
    BOOL _isNeedCopy;
    NSString *_appName;
    NSString *_desFilePath;
    NSURL *_itunesFileUrl;
    iTunesTSts _trackStatues;
    IMBAppEntity *_appEntity;
}

@property (nonatomic, readwrite, retain) NSString *appKey;
@property (nonatomic, readwrite) BOOL isNeedCopy;
@property (nonatomic, readwrite, retain) NSString *appName;
@property (nonatomic, readwrite, retain) NSString *desFilePath;
@property (nonatomic, readwrite, retain) NSURL *itunesFileUrl;
@property (nonatomic, readwrite) iTunesTSts trackStatues;
@property (nonatomic, readwrite, retain) IMBAppEntity *appEntity;

@end

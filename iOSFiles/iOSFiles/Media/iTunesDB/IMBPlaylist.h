//
//  IMBPlaylist.h
//  iMobieTrans
//
//  Created by Pallas on 12/28/12.
//  Copyright (c) 2012 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBMHODFactory.h"
#import "IMBPlaylistItem.h"

#define UnknownName @"UnKnownName";

typedef enum PlaylistSortField{
    UnknownSort = 0,
    ManualSort = 1,
    Unknown1Sort = 2,
    TitleSort = 3,
    AlbumSort = 4,
    ArtistSort = 5,
    BitrateSort = 6,
    GenreSort = 7,
    KindSort = 8,
    DateModifiedSort = 9,
    TrackNumberSort = 10,
    SizeSort = 11,
    TimeSort = 12,
    YearSort = 13,
    SampleRateSort = 14,
    CommentSort = 15,
    DateAddedSort = 16,
    EqualizerSort = 17,
    ComposerSort = 18,
    Unknown2Sort = 19,
    PlayCountSort = 20,
    LastPlayedSort = 21,
    DiscNumberSort = 22,
    RatingSort = 23,
    ReleaseDateSort = 24,
    BPMSort = 25,
    GroupingSort = 26,
    CategorySort = 27,
    DescriptionSort = 28,
    ShowSort = 29,
    SeasonSort = 30,
    EpisodeNumberSort = 31
}PlaylistSortFieldEnum;

@interface IMBPlaylist : IMBBaseDatabaseElement {
@private
    Byte _isMaster;
    Byte *_unk1;
    int unk1Length;
    int _timeStamp;
    //int _unk2;
    int64_t _iD;
    int _unk3;
    int16_t _stringObjectCount;
    int16_t _isPodcast;
    Byte *_unk4;
    int unk4Length;
    Byte _playlistType;
    
    int _sortField;
    NSMutableArray *_dataObjects;
    NSMutableArray *_playlistItems;
    
    BOOL _isSmartPlaylist;
    NSMutableArray *_bindingTrackList;
    NSMutableArray *_betweenDeviceCopyableTrackList;
    NSString *_lengthSummary;
    NSString *_sizeSummary;
    BOOL _isDirty;
    BOOL _isPurchases;
}

@property (nonatomic, readwrite) int64_t iD;
@property (nonatomic, readonly) BOOL isDirty;
@property (nonatomic, assign) BOOL isPurchases;
@property (nonatomic, readonly) NSMutableArray *playlistItems;
@property (nonatomic, readonly) NSMutableArray *bindingTrackList;
@property (nonatomic, retain) NSMutableArray *betweenDeviceCopyableTrackList;
@property (nonatomic, readonly) NSString *lengthSummary;
@property (nonatomic, readonly) NSString *sizeSummary;
@property (nonatomic, readonly) NSString *nameAndCountString;

@property (nonatomic, getter = name, setter = setName:, readwrite, retain) NSString *name;
@property (nonatomic, getter = isMaster, readonly) BOOL isMaster;
@property (nonatomic, getter = isSmartPlaylist, readonly) BOOL isSmartPlaylist;
@property (nonatomic, getter = isPodcastPlaylist, setter = setIsPodcastPlaylist:, readwrite) BOOL isPodcastPlaylist;
@property (nonatomic, getter = isUserDefinedPlaylist, readonly) BOOL isUserDefinedPlaylist;
@property (nonatomic, getter = isVoiceMemoPlaylist, readonly) BOOL isVoiceMemoPlaylist;
@property (nonatomic, getter = isAudiobookPlaylist, readonly) BOOL isAudiobookPlaylist;
@property (nonatomic, getter = isiTunesUPlaylist, readonly) BOOL isiTunesUPlaylist;
@property (nonatomic, getter = distinguishedKind,readonly) int distinguishedKind;
@property (nonatomic, getter = sortField, setter = setSortField:, readwrite) PlaylistSortFieldEnum sortField;
@property (nonatomic, getter = itemCount, readonly) int itemCount;

- (void)setName:(NSString *)name;
- (NSString*)name;

- (BOOL)isMaster;

- (BOOL)isSmartPlaylist;

- (void)setIsPodcastPlaylist:(BOOL)isPodcastPlaylist;
- (BOOL)isPodcastPlaylist;

- (BOOL)isUserDefinedPlaylist;

- (BOOL)isVoiceMemoPlaylist;

- (BOOL)isAudiobookPlaylist;

- (BOOL)isiTunesUPlaylist;

- (int)distinguishedKind;

- (void)setSortField:(PlaylistSortFieldEnum)sortField;

- (PlaylistSortFieldEnum)sortField;

- (int)itemCount;

- (int)trackCount;

- (IMBTrack*)getTrackByIndex:(int)index;

- (IMBPlaylistItem*)getPlaylistItemByIndex:(int)index;

- (void)setAudiobookPlaylist;

- (void)setitunesUPlaylist;

- (void)resolveTrack:(IMBiPod*)ipod;

- (void)updateSummaryData;

- (NSMutableArray*)tracks;


- (id)initWithIPod:(IMBiPod*)ipod;

- (BOOL)containsTrackByItem:(IMBTrack*)track;

- (BOOL)containsTrackByDBID:(long long)dbID;

- (void)addItem:(IMBPlaylistItem*)item position:(int)position;

- (void)addTrack:(IMBTrack*)track;

- (void)addTrack:(IMBTrack *)track position:(int)postion;

- (void)addTrack:(IMBTrack *)track position:(int)position skipChecks:(BOOL)skipChecks;

- (void)removeTrack:(IMBTrack*)track;

- (void)removeTrack:(IMBTrack *)track skipChecks:(BOOL)skipChecks;

- (void)removeAllItems;

- (void)removeItem:(IMBPlaylistItem*)item;

- (void)moveTrackToPosition:(IMBTrack*)track newPosition:(int)newPosition;

- (BOOL)groupHasEntries:(IMBPlaylistItem*)group;

- (IMBPlaylistItem*)getGroupByGroupID:(int)groupID;

- (void)assertModificationRights;

- (void)clearTable;

@end

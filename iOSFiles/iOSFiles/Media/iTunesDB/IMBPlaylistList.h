//
//  IMBPlaylistList.h
//  MediaTrans
//
//  Created by Pallas on 12/20/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBPlaylist.h"

@interface IMBPlaylistList : IMBBaseDatabaseElement{
@private
    int _playlistCount;
    NSMutableArray *_playlistArray;
    BOOL _isDirty;
}

@property (nonatomic,readonly) NSMutableArray *playlistArray;
@property (nonatomic, readonly) BOOL isDirty;

- (void)resolveTracks;
- (IMBPlaylist*)getPlaylistByName:(NSString*)playlistName;
- (IMBPlaylist*)getPlaylistByID:(long long)playlistID;
- (IMBPlaylist*)getMasterPlaylist;
- (BOOL)contains:(IMBPlaylist*)item;
- (IMBPlaylist*)addPlaylist:(long)playlistID playlistName:(NSString*)playlistName;
- (IMBPlaylist*)addPlaylist:(NSString*)playlistName;
- (void)removeTrackFromAllPlaylists:(IMBTrack*)track;
- (BOOL)removePlaylist:(IMBPlaylist*)playlist deleteTracks:(BOOL)deleteTracks;
- (BOOL)removePlaylist:(IMBPlaylist*)playlist deleteTracks:(BOOL)deleteTracks skipChecks:(BOOL)skipChecks;
- (NSMutableArray*)getPlaylist;
- (void)followChanges:(IMBPlaylistList*)otherPlaylistList;
- (IMBPlaylist*)getPodcastPlaylist;
- (IMBPlaylist*)getAudioBookPlaylist:(NSString*)name;
- (IMBPlaylist*)getiTunesUPlaylist;
- (NSArray*)getUserDefinedPlaylists;

@end

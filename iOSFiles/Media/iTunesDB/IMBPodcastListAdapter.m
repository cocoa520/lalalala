//
//  IMBPodcastListAdapter.m
//  iMobieTrans
//
//  Created by Pallas on 1/5/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBPodcastListAdapter.h"
#import "IMBPlaylist.h"
#import "IMBIDGenerator.h"

@implementation IMBPodcastListAdapter

-(id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithPlaylist:(IMBiPod*)ipod playList:(IMBPlaylist*)playlist {
    self = [self init];
    if (self) {
        _iPod = ipod;
        _playlist = playlist;
        [_playlist setIsPodcastPlaylist:TRUE];
    }
    return self;
}

- (void)addTrackByTrack:(IMBTrack*)track {
    IMBPlaylistItem *trackItem = nil;
    for (IMBPlaylistItem *item in [_playlist playlistItems]) {
        if ([[item track] isEqual:track] == YES) {
            trackItem = item;
            break;
        }
    }
    
    if (trackItem != nil && [trackItem groupID] != 0) {
        return;
    }
    
    NSString *groupName = nil;
    if ([MediaHelper stringIsNilOrEmpty:[track album]] == NO) {
        groupName = [track album];
    } else {
        groupName = UnknownName;
    }
    IMBPlaylistItem *parentItem = [self getPodcastGroup:groupName];
    if (trackItem == nil) {
        trackItem = [[IMBPlaylistItem alloc] init];
        [trackItem setTrack:track];
        [_playlist addItem:trackItem position:-1];
    }
    [trackItem setPodcastGroupParent:[parentItem groupID]];
    [trackItem setGroupID:[[_iPod idGenerator] getNewPodcastGroupID]];
}

- (void)removePlaylistItemByItem:(IMBPlaylistItem*)item {
    IMBPlaylistItem *parentItem = [self getPodcastGroupByGroupID:[item podcastGroupParent]];
    [_playlist removeItem:item];
    if (parentItem != nil) {
        if ([self podcastGroupHasEntries:parentItem] == NO) {
            [_playlist removeItem:parentItem];
        }
    }
}

- (void)followChanges:(IMBPlaylist*)otherPlaylist{
    IMBTrack *track = nil;
    for (int count = 0; count < [otherPlaylist itemCount]; count++) {
        track = [otherPlaylist getTrackByIndex:count];
        if (track != nil) {
            [self addTrackByTrack:track];
        }
    }
    
    for (int count = ([_playlist itemCount] - 1); count >= 0; count--) {
        if ([_playlist itemCount] == 0) {
            break;
        }
        if ([[_playlist getPlaylistItemByIndex:count] isPodcastGroup] == FALSE) {
            if ([otherPlaylist containsTrackByItem:[_playlist getTrackByIndex:count]]) {
                [self removePlaylistItemByItem:[_playlist getPlaylistItemByIndex:count]];
                count = [_playlist itemCount];
            }
        }
    }
}

- (IMBPlaylistItem*)getPodcastGroup:(NSString*)groupName {
    for (IMBPlaylistItem *item in [_playlist playlistItems]) {
        if ([item isPodcastGroup] == TRUE) {
            if ([[item podcastGroupTitle] isEqualToString:groupName] == YES) {
                return item;
            }
        }
    }
    return [self createPodcastGroup:groupName];
}

- (IMBPlaylistItem*)createPodcastGroup:(NSString*)groupName {
    IMBPlaylistItem *item = [[IMBPlaylistItem alloc] init];
    [item setPodcastGroupTitle:groupName];
    [item setIsPodcastGroup:TRUE];
    [item setPodcastGroupParent:0];
    [item setGroupID:[[_iPod idGenerator] getNewPodcastGroupID]];
    srandom((unsigned int)time((time_t *)NULL));
    [item setGroupDBID:random()];
    [_playlist addItem:item position:0];
    return item;
}

- (BOOL)podcastGroupHasEntries:(IMBPlaylistItem*)podcastGroup {
    for (IMBPlaylistItem *item in [_playlist playlistItems]) {
        if ([item podcastGroupParent] == [podcastGroup groupID]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (IMBPlaylistItem*)getPodcastGroupByGroupID:(int)groupID {
    for (IMBPlaylistItem *item in [_playlist playlistItems]) {
        if ([item groupID] == groupID) {
            return item;
        }
    }
    return nil;
}

@end

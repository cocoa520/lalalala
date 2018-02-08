//
//  IMBiTLPlaylist.m
//  iMobieTrans
//
//  Created by zhang yang on 13-4-17.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBiTLPlaylist.h"

@implementation IMBiTLPlaylist
@synthesize name;
@synthesize isMaster;
@synthesize playlistID;
@synthesize playlistPersistentID;
@synthesize isVisible;
@synthesize isAllItems;
@synthesize playlistItems;
@synthesize isMusic;
@synthesize isAudiobooks;
@synthesize isBooks;
@synthesize isPodcasts;
@synthesize isTVShows;
@synthesize isSmartPlaylist;
@synthesize distinguishedKindId;
@synthesize playlistTrackIds;
@synthesize iTunesType;


- (id)init
{
    self = [super init];
    if (self) {
        playlistItems = [[NSMutableArray alloc] init];
        playlistTrackIds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (name != nil) {
        [name release];
    }
    
    if (playlistPersistentID != nil) {
        [playlistPersistentID release];
    }
    
    if (playlistItems != nil) {
        [playlistItems release];
    }
    
    if (playlistTrackIds != nil) {
        [playlistTrackIds release];
    }
    
    
    [super dealloc];
}

- (BOOL)checkUserDefined {
    return !isMaster && !isSmartPlaylist && !distinguishedKindId > 0;
}

- (NSString*) nameAndCountString {
    int count = (int)self.playlistItems.count;
    if (count > 0) {
        return [NSString stringWithFormat:@"%@ (%d)",self.name,count];
    }
    return self.name;
}

- (iTunesTypeEnum) iTunesType {
    return (iTunesTypeEnum) distinguishedKindId;
}

- (BOOL) containsTrackByPersistentID:(NSString*)persistentID {
    NSArray *tracks = [playlistItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"persistentID == %@",persistentID]];
    if (tracks != nil && tracks.count > 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}


@end

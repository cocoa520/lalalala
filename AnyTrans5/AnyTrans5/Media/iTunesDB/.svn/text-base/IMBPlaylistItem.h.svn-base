//
//  IMBPlaylistItem.h
//  iMobieTrans
//
//  Created by Pallas on 12/28/12.
//  Copyright (c) 2012 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBTracklist.h"
#import "IMBTrack.h"

@interface IMBPlaylistItem : IMBBaseDatabaseElement {
@private
    int _dataObjectCount;
    int _podcastGroupingFlag;
    int _groupID;
    int _trackID;
    int _timeStamp;
    int _podcastGroupParent;
    int64_t _groupDBID;
    int64_t _trackDBID;
    
    IMBTrack *_track;
@public
    NSMutableArray *_childSections;
}

@property (assign, readwrite) int64_t groupDBID;
@property (assign, readwrite) int64_t trackDBID;
@property (assign, readwrite) int podcastGroupParent;
@property (assign, readwrite) int groupID;

@property (nonatomic, getter = track, setter = setTrack:, readwrite, retain) IMBTrack *track;
@property (nonatomic, getter = playlistPostion, setter = setPlaylistPostion:, readwrite) int playlistPostion;
@property (nonatomic, getter = isPodcastGroup, setter = setIsPodcastGroup:, readwrite) BOOL isPodcastGroup;
@property (nonatomic, readwrite, retain) NSString *podcastGroupTitle;

- (void)resolveTrack:(IMBiPod*)ipod;

- (void)setTrack:(IMBTrack *)track;
- (IMBTrack*)track;

- (void)setPlaylistPostion:(int)playlistPostion;
- (int)playlistPostion;

- (void)setIsPodcastGroup:(BOOL)isPodcastGroup;
- (BOOL)isPodcastGroup;

- (void)setPodcastGroupTitle:(NSString *)podcastGroupTitle;
- (NSString*)podcastGroupTitle;

@end

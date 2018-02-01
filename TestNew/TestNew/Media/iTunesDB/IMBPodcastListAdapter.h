//
//  IMBPodcastListAdapter.h
//  iMobieTrans
//
//  Created by Pallas on 1/5/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMBPlaylist;
@class IMBiPod;
@class IMBTrack;
@class IMBPlaylistItem;

@interface IMBPodcastListAdapter : NSObject {
@private
    IMBPlaylist *_playlist;
    IMBiPod *_iPod;
}

- (id)initWithPlaylist:(IMBiPod*)ipod playList:(IMBPlaylist*)playlist;
- (void)addTrackByTrack:(IMBTrack*)track;
- (void)removePlaylistItemByItem:(IMBPlaylistItem*)item;
- (void)followChanges:(IMBPlaylist*)otherPlaylist;

@end

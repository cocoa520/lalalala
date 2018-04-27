//
//  IMBMusicDatabase.h
//  MediaTrans
//
//  Created by Pallas on 12/18/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabase.h"
#import "IMBiTunesDBRoot.h"
#import "IMBiTunesCDBRoot.h"
#import "MobileDeviceAccess.h"

@interface IMBMusicDatabase : IMBBaseDatabase{
@private
    IMBiTunesDBRoot *databaseRoot;
    IMBTrackListContainer *tracksContainer;
@public
    IMBTracklist *_tracklist;
    IMBPlaylistList *_playlistList;
}

@property (nonatomic,readonly) IMBTracklist *tracklist;
@property (nonatomic,readonly) IMBPlaylistList *playlistList;

@property (getter = hashingScheme,readonly) int hashingScheme;

- (id)initWithIPod:(IMBiPod*)ipod;
- (BOOL)isDirty;
- (int)hashingScheme;

@end

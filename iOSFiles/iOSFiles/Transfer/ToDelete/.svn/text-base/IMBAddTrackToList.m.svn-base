//
//  IMBAddTrackToList.m
//  iMobieTrans
//
//  Created by Pallas on 2/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBAddTrackToList.h"
#import "IMBPlaylist.h"
#import "IMBPlaylistList.h"

@implementation IMBAddTrackToList

- (id)initWithIPodKey:(NSString *)ipodKey tracksArray:(NSArray*)tracksArray playlistID:(int64_t)playlistID {
    self = [super init];
    if (self) {
        _tracksArray = [tracksArray retain];
        _playlistID = playlistID;
        _ipod = [[[IMBDeviceConnection singleton] getiPodByKey:ipodKey] retain];
        _logManager = [IMBLogManager singleton];
    }
    return self;
}

- (void)dealloc {
    if (_tracksArray != nil) {
        [_tracksArray release];
        _tracksArray = nil;
    }
    [super dealloc];
}

- (void)startAddTrackToList {
    @try {
        [_ipod startSync];
        IMBPlaylist *playlist = [[_ipod playlists] getPlaylistByID:_playlistID];
        if (playlist != nil) {
            for (IMBTrack *item in _tracksArray) {
                if (item.mediaType == Books || item.mediaType == PDFBooks) {
                    continue;
                }
                if (_isStop) {
                    break;
                }
                
                //TODO 这里没有purchase的内容
                IMBTrack *track = [[_ipod tracks] findByDBID:[item dbID]];
                if (track != nil) {
                    [playlist addTrack:track];
                }
            }
        }
        if (_ipod.deviceInfo.airSync) {
            //开始同步
            IMBATHSync *athSync = [[IMBATHSync alloc] initWithiPod:_ipod syncCtrType:SyncOther];
            [athSync setCurrentThread:[NSThread currentThread]];
            if ([athSync createAirSyncService]) {
                if ([athSync sendRequestSync]) {
                    if ([athSync createPlistAndCigSendDataSync]) {
                        [athSync startCopyData];
                        [athSync waitSyncFinished];
                        [_ipod saveChanges];
                    }else{
                        [athSync waitSyncFinished];
                    }
                }
            }
        }
        [_ipod endSync];
        NSLog(@"=============");
    }
    @catch (NSException *exception) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"Add Track To List exception:%@",exception]];
    }
}

@end

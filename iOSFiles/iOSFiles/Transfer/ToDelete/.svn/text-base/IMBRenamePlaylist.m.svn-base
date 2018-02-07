//
//  IMBRenamePlaylist.m
//  iMobieTrans
//
//  Created by Pallas on 1/31/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBRenamePlaylist.h"
#import "IMBPlaylist.h"
#import "IMBPlaylistList.h"
@implementation IMBRenamePlaylist

- (id)initWithIPodKey:(NSString *)ipodKey playlistName:(NSString*)playlistName playlistID:(int64_t)playlistID {
    self = [super init];
    if (self) {
        _playlistName = [playlistName retain];
        _playlistID = playlistID;
        _ipod = [[[IMBDeviceConnection singleton] getiPodByKey:ipodKey] retain];
        _logManager = [IMBLogManager singleton];
    }
    return self;
}

- (void)dealloc {
    if (_playlistName != nil) {
        [_playlistName release];
        _playlistName = nil;
    }
    [super dealloc];
}

- (void)startRenamePlaylist {
    @try {
        [_ipod startSync];
        if (_isStop) {
            return;
        }
        
        IMBPlaylist *playlist = [[_ipod playlists] getPlaylistByID:_playlistID];
        if (playlist != nil) {
            [playlist setName:_playlistName];
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
        [_logManager writeInfoLog:[NSString stringWithFormat:@"Rename Playlist exception:%@",exception]];
    }
}

@end

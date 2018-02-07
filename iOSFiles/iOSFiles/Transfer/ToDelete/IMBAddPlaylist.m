//
//  IMBAddPlaylist.m
//  iMobieTrans
//
//  Created by Pallas on 2/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBAddPlaylist.h"
#import "IMBPlaylistList.h"

@implementation IMBAddPlaylist

- (id)initWithIPodKey:(NSString *)ipodKey playlistName:(NSString*)playlistName {
    self = [super init];
    if (self) {
        _playlistName = [playlistName retain];
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

- (void)startAddPlaylist {
    @try {
        [_ipod startSync];
        if (_isStop) {
            return;
        }
        
        [[_ipod playlists] addPlaylist:_playlistName];
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

    }
    @catch (NSException *exception) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"Add Playlist exception:%@",exception]];
    }
}

@end

//
//  IMBDeletePlaylist.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-4.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeletePlaylist.h"
#import "IMBPlaylist.h"
#import "IMBPlaylistList.h"
//#import "IMBDevicePlaylistsViewController.h"
#import "TempHelper.h"
@implementation IMBDeletePlaylist

- (void)startDelete
{
    if ([_delegate respondsToSelector:@selector(setDeleteProgress:withWord:)]) {
        [_delegate setDeleteProgress:0 withWord:@"Deleting, please wait..."];
    }
    [_ipod startSync];
    int curIndex = 0;
    int success = 0;
    for (IMBPlaylist *playlist in _deleteArray) {
        if (_isStop) {
            break;
        }
        curIndex ++;
        if (![TempHelper stringIsNilOrEmpty:playlist.name]) {
            if ([_delegate respondsToSelector:@selector(setDeleteProgress:withWord:)]) {
                [_delegate setDeleteProgress:((float)curIndex/_deleteArray.count)*96 withWord:[NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Delete_Item", nil),playlist.name]];
            }
        }
        @try {
            [[_ipod playlists] removePlaylist:playlist deleteTracks:NO];
        }
        @catch (NSException *exception) {
            [_logManager writeInfoLog:[NSString stringWithFormat:@"Deleteplaylist exception:%@",exception]];
        }
    }
    //开始同步
    if ([_delegate respondsToSelector:@selector(setDeleteProgress:withWord:)]) {
        [_delegate setDeleteProgress:((float)curIndex/_deleteArray.count)*96 withWord:CustomLocalizedString(@"ImportSync_id_1", nil)];
    }
    if (_ipod.deviceInfo.airSync) {
        IMBATHSync *athSync = [[IMBATHSync alloc] initWithiPod:_ipod syncCtrType:SyncOther];
        [athSync setCurrentThread:[NSThread currentThread]];
        if ([athSync createAirSyncService]) {
            if ([athSync sendRequestSync]) {
                if ([athSync createPlistAndCigSendDataSync]) {
                    for (IMBPlaylist *playlist in _deleteArray) {
                        if (_isStop) {
                            break;
                        }
                        success ++;
                    }
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
    if ([_delegate respondsToSelector:@selector(setDeleteProgress:withWord:)]) {
        [_delegate setDeleteProgress:100 withWord:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil)];
    }
    if ([_delegate respondsToSelector:@selector(setDeleteComplete:totalCount:)]) {
        [_delegate setDeleteComplete:success totalCount:_deleteArray.count];
    }
}
@end

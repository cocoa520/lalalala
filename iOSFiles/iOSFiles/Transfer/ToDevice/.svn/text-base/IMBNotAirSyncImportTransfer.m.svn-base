//
//  IMBNotAirSyncImportTransfer.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-24.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBNotAirSyncImportTransfer.h"
#import "IMBPlaylistList.h"
#import "IMBFileSystem.h"
@implementation IMBNotAirSyncImportTransfer

- (void)startTransfer {
    [_ipod startSync];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transferDelegate transferPrepareFileStart:@"Preparing Transfer..."];
    }
    NSDictionary *dic = [self paraseFileType];
    [self prepareAndFilterConverterFiles:dic];
    if (_isNeedConversion) {
        [self conversionAndImportFiles];
    }
    if ([_importFiles count]>0) {
        //刷新设备剩余空间
        [_listTrack freshFreeSpace];
        //创建所有的track对象
        @try {
            NSMutableArray *allTracks = [self prepareAllTrack];
            NSString *msgStr1 = @"Analyzing Completed";
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:msgStr1];
            }
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                [_transferDelegate transferPrepareFileEnd];
            }
            for (IMBTrack *track in allTracks) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
//                if (_limitation.remainderCount == 0) {
//                    break;
//                }
                NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),track.title];
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
                if ([self copyLocalFile:track.srcFilePath toRemoteFile:[[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:[track filePath]]]) {
                    //统计成功
                    _successCount++;
//                    [_limitation reduceRedmainderCount];
                }
            }
            [_ipod saveChanges];
        }
        @catch (NSException *exception) {
            [_loghandle writeInfoLog:[NSString stringWithFormat:@"IMBNotAirSyncImportTransfer:%@",exception]];
        }
        @finally {
            
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_ipod endSync];
}

@end

//
//  IMBNotAirSyncImportBetweenDeviceTransfer.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBNotAirSyncImportBetweenDeviceTransfer.h"
#import "IMBFileSystem.h"
@implementation IMBNotAirSyncImportBetweenDeviceTransfer

- (void)startTransfer
{
    [_ipod startSync];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transferDelegate transferPrepareFileStart:@"Preparing Transfer..."];
    }
    [self prepareAllItemsAndCategories];
    _totalItemCount = [self totalItemscount];
    if ([_importFiles count]>0){
        [[_ipod tracks] freshFreeSpace];
        [[_srciPod tracks] freshFreeSpace];
        @try {
            NSArray *allTracks = [self prepareAllTrack];
            if (allTracks.count > 0) {
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
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Skipped"];
                        continue;
                    }
//                    if (_limitation.remainderCount == 0) {
//                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Skipped"];
//                        continue;
//                    }
                    NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",track.title];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                    _currItemIndex ++;
                    if (_currItemIndex > _totalItemCount) {
                        _currItemIndex = _totalItemCount;
                    }
                    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_transferDelegate transferProgress:progress];
                    }

                    if ( [_ipod.fileSystem copyFileBetweenDevice:track.srcFilePath sourDriverLetter:_srciPod.fileSystem.driveLetter targFileName:track.filePath targDriverLetter:_ipod.fileSystem.driveLetter sourDevice:_srciPod]) {
                        //统计成功
//                        [_limitation reduceRedmainderCount];
                        _successCount++;
                    }
                }
                [_ipod saveChanges];
            }
        }
        @catch (NSException *exception) {
            [_loghandle writeInfoLog:[NSString stringWithFormat:@"IMBNotAirSyncImportBetweenDeviceTransfer:%@",exception]];
        }
        @finally {
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_ipod endSync];
}

- (int)totalItemscount{
    int i = 0;
    for (NSArray *array in _importFiles) {
        if ([array isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)array;
            for (NSString *key in [dic allKeys]) {
                NSArray *keyArray = [dic objectForKey:key];
                i += keyArray.count;
                
            }
        }else{
            i += array.count;
            
        }
    }
    return i;
}
@end

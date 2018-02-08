//
//  IMBVoicemailExport.m
//  AnyTrans
//
//  Created by iMobie on 8/2/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBVoicemailExport.h"
#import "TempHelper.h"
#import "IMBVoiceMailEntity.h"

@implementation IMBVoicemailExport

//按个数传输
- (void)startTransfer {
    [_loghandle writeInfoLog:@"VoicemailExport DoProgress enter"];
    if (_exportTracks != nil && [_exportTracks count] > 0 && ![TempHelper stringIsNilOrEmpty:_exportPath]) {
        //计算totalSize
//        _totalSize = [self caculateTransferTotalSize:_exportTracks];
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        for (IMBVoiceMailEntity *entity in _exportTracks) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.sender WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                _currItemIndex ++;
                if (![TempHelper stringIsNilOrEmpty:entity.path]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[entity.path lastPathComponent]];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transferDelegate transferProgress:progress];
                }
                if ([_fileManager fileExistsAtPath:entity.path]) {
                    NSString *destFilePath = [_exportPath stringByAppendingPathComponent:[entity.sender stringByAppendingPathExtension:@"amr"]];
                    if ([_fileManager fileExistsAtPath:destFilePath]) {
                        destFilePath = [TempHelper getFilePathAlias:destFilePath];
                    }
                    if ([_fileManager copyItemAtPath:entity.path toPath:destFilePath error:nil]) {
                        [_limitation reduceRedmainderCount];
                        _successCount += 1;
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:entity.sender WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                        _failedCount += 1;
                    }
                } else {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:entity.sender WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                    _failedCount += 1;
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.sender WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                _skipCount ++;
            }
        }
        
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
        [_loghandle writeInfoLog:@"VoicemailExport DoProgress Complete"];
    }
}

- (int64_t)caculateTransferTotalSize:(NSArray *)array {
    int64_t size = 0;
    if (array != nil) {
        for (IMBVoiceMailEntity *entity in array) {
            size += entity.size;
        }
    }
    return size;
}

@end

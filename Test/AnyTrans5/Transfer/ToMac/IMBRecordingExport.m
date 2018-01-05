//
//  IMBRecordingExport.m
//  iMobieTrans
//
//  Created by Pallas on 2/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBRecordingExport.h"
#import "TempHelper.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"

@implementation IMBRecordingExport

- (BOOL)beforeProgress {
    if (_ipod != nil) {
//        if ([super checkExportLimit] == YES) {
            [_ipod startSync];
            return YES;
//        } else {
//            return NO;
//        }
    } else {
        return NO;
    }
}

- (void)startTransfer {
    //判断录音数组是否存在
    [_loghandle writeInfoLog:@"doProgress in IMBRecordingExport entered"];
     if (_exportTracks != nil && [_exportTracks count] > 0 && ![TempHelper stringIsNilOrEmpty:_exportPath]) {
         if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
             [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"MSG_COM_Prepare", nil)];
         }
         //计算totalSize
         _totalSize = [self caculateTransferTotalSize:_exportTracks];
         
         if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
             [_transferDelegate transferPrepareFileEnd];
         }
         for (IMBRecordingEntry *recordingEntry in _exportTracks) {
             if (_limitation.remainderCount == 0) {
                 [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                 continue;
             }
             [_condition lock];
             if (_isPause) {
                 [_condition wait];
             }
             [_condition unlock];
             if (!_isStop) {
                 _currItemIndex++;
                 //获得设备中的文件路径
                 NSString *remotingFilePath = [[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:[recordingEntry path]];
                 if (![TempHelper stringIsNilOrEmpty:recordingEntry.path]) {
                     NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[recordingEntry.path lastPathComponent]];
                     if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                         [_transferDelegate transferFile:msgStr];
                     }
                 }
//                 float progress = ((float)_currItemIndex / _totalItemCount) * 100;
//                 if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                     [_transferDelegate transferProgress:progress];
//                 }
                 
                 if ([[_ipod fileSystem] fileExistsAtPath:remotingFilePath]) {
                     NSString *fileName = [[TempHelper replaceSpecialChar:[recordingEntry name]] stringByAppendingPathExtension:[[recordingEntry path] pathExtension]];
                     NSString *destFilePath = [_exportPath stringByAppendingPathComponent:fileName];
                     
                     if ([_fileManager fileExistsAtPath:destFilePath]) {
                         destFilePath = [TempHelper getFilePathAlias:destFilePath];
                     }
                     if ([self copyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
//                     if ([self asyncCopyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
                         [_limitation reduceRedmainderCount];
                         _successCount += 1;
                     }else {
                         [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                         _failedCount += 1;
                     }
                 } else {
                     [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                     _failedCount += 1;
                 }
             }else {
                 [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                 _skipCount ++;
             }
         }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_loghandle writeInfoLog:@"doProgress in IMBRecordingExport end"];
//    [self afterProgress];
}

- (int64_t)caculateTransferTotalSize:(NSArray *)array {
    int64_t size = 0;
    if (array != nil) {
        for (IMBRecordingEntry *entity in array) {
            size += entity.sizeLength;
        }
    }
    return size;
}

-(void)afterProgress{
    [_ipod endSync];
}


@end

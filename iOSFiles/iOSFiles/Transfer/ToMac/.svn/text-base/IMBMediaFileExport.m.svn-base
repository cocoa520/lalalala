//
//  IMBMediaFileExport.m
//  iMobieTrans
//
//  Created by Pallas on 1/21/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBMediaFileExport.h"
#import "IMBIPod.h"
#import "TempHelper.h"
#import "IMBTrack.h"
//#import "IMBTransResult.h"
#import "IMBFileSystem.h"
#import "IMBLimitation.h"
#import "IMBExportSetting.h"
#import "IMBDeviceInfo.h"

@implementation IMBMediaFileExport

- (BOOL)beforeProgress {
    if (_ipod != nil) {
//        if ([super checkExportLimit]) {
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
    [_loghandle writeInfoLog:@"MediaFileExport DoProgress enter"];
    if (_exportTracks != nil && [_exportTracks count] > 0 && ![TempHelper stringIsNilOrEmpty:_exportPath]) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:@"Preparing file..."];
        }
        //计算totalSize
//        _totalSize = [self caculateTransferTotalSize:_exportTracks];
        
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        for (DriveItem *track in _exportTracks) {
//            if (_limitation.remainderCount == 0) {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                continue;
//            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (track.state) {
                continue;
            }
            track.isStart = YES;
            if (_currentDriveItem) {
                [_currentDriveItem release];
                _currentDriveItem = nil;
            }
            _currentDriveItem = [track retain];
            _currentDriveItem.progress = 0;
            _currentDriveItem.currentSize = 0;
            if (!_isStop) {
                _currItemIndex++;
                //获得设备中的文件路径
                NSString *remotingFilePath = [[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:[track oriPath]];
                if (![TempHelper stringIsNilOrEmpty:track.fileName]) {
                    NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",track.fileName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
//                float progress = ((float)_currItemIndex / _totalItemCount) * 100;
//                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                    [_transferDelegate transferProgress:progress];
//                }
                if ([[_ipod fileSystem] fileExistsAtPath:remotingFilePath] && ![MediaHelper stringIsNilOrEmpty:track.oriPath]) {
                    NSString *fileName = [[TempHelper replaceSpecialChar:[track fileName]] stringByAppendingPathExtension:[[track oriPath] pathExtension]];
                     NSString *destFilePath = [_exportPath stringByAppendingPathComponent:fileName];
                    if ([_fileManager fileExistsAtPath:destFilePath]) {
                        destFilePath = [TempHelper getFilePathAlias:destFilePath];
                    }
                    if ([self copyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
//                    if ([self asyncCopyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
                        [IMBLimitation sharedLimitation].leftToMacNums--;
                        _successCount += 1;
                        track.currentSize = 0;
                        _curSize  = 0;
                        track.state = DownloadStateComplete;
                        IMBExportSetting *exportSetting = [[IMBExportSetting alloc]initWithIPod:_ipod];
                        [exportSetting readDictionary];
                        if (exportSetting.isCreadPhotoDate) {
                            NSTask *task;
                            task = [[NSTask alloc] init];
                            [task setLaunchPath: @"/usr/bin/touch"];
                            NSArray *arguments;
                            NSString *str = [DateHelper dateFrom2001ToString:track.photoDateData withMode:3];
                            NSString *strData = [TempHelper replaceSpecialChar:str];
                            strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
                            strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            arguments = [NSArray arrayWithObjects: @"-mt", strData, destFilePath, nil];
                            [task setArguments: arguments];
                            NSPipe *pipe;
                            pipe = [NSPipe pipe];
                            [task setStandardOutput: pipe];
                            NSFileHandle *file;
                            file = [pipe fileHandleForReading];
                            [task launch];
                        }
                    }else {
                         [[IMBTransferError singleton] addAnErrorWithErrorName:track.fileName WithErrorReson:@"Coping file failed."];
                        _failedCount += 1;
                        track.state = DownloadStateError;
                    }
                } else {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.fileName WithErrorReson:@"The file does not exist in your iPhone or your backups"];
                    _failedCount += 1;
                    track.state = DownloadStateError;
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:track.fileName WithErrorReson:@"Skipped"];
                _skipCount ++;
            }
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }

//    [self afterProgress];
    [_loghandle writeInfoLog:@"MediaFileExport DoProgress Complete"];
}

- (int64_t)caculateTransferTotalSize:(NSArray *)array {
    int64_t size = 0;
    if (array != nil) {
        for (IMBTrack *track in array) {
            size += track.fileSize;
        }
    }
    return size;
}

- (void)afterProgress{
    //停止同步
    [_ipod endSync];
}

@end

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
//#import "IMBCommonDefine.h"
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
        _totalSize = [self caculateTransferTotalSize:_exportTracks];
        
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        for (IMBTrack *track in _exportTracks) {
//            if (_limitation.remainderCount == 0) {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                continue;
//            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                _currItemIndex++;
                //获得设备中的文件路径
                NSString *remotingFilePath = [[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:[track filePath]];
                if (![TempHelper stringIsNilOrEmpty:track.title]) {
                    NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",track.title];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
//                float progress = ((float)_currItemIndex / _totalItemCount) * 100;
//                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                    [_transferDelegate transferProgress:progress];
//                }
                if ([[_ipod fileSystem] fileExistsAtPath:remotingFilePath] && ![MediaHelper stringIsNilOrEmpty:track.filePath]) {
                    NSString *fileName = [[TempHelper replaceSpecialChar:[track title]] stringByAppendingPathExtension:[[track filePath] pathExtension]];
                     NSString *destFilePath = [_exportPath stringByAppendingPathComponent:fileName];
                    if ([_fileManager fileExistsAtPath:destFilePath]) {
                        destFilePath = [TempHelper getFilePathAlias:destFilePath];
                    }
                    if ([self copyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
//                    if ([self asyncCopyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
//                        [_limitation reduceRedmainderCount];
                        _successCount += 1;
                        IMBExportSetting *exportSetting = [[IMBExportSetting alloc]initWithIPod:_ipod];
                        [exportSetting readDictionary];
                        if (exportSetting.isCreadPhotoDate) {
                            NSTask *task;
                            task = [[NSTask alloc] init];
                            [task setLaunchPath: @"/usr/bin/touch"];
                            NSArray *arguments;
                            NSString *str = [DateHelper dateFrom2001ToString:track.dateLastModified withMode:3];
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
                         [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                        _failedCount += 1;
                    }
                } else {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                    _failedCount += 1;
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
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

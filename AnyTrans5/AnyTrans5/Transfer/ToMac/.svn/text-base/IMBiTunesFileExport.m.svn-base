//
//  IMBiTunesFileExport.m
//  iMobieTrans
//
//  Created by zhang yang on 13-6-21.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBiTunesFileExport.h"
#import "TempHelper.h"
#import "IMBiTLTrack.h"
//#import "IMBTransResult.h"
//#import "IMBCommonDefine.h"
#import "IMBDeviceInfo.h"

@implementation IMBiTunesFileExport
- (id)initWithExportTracks:(NSArray *)exportTracks exportFolder:(NSString *)exportFolder withDelegate:(id)delegate {
    self = [self init];
    if (self) {
        _transferDelegate = delegate;
        _exportTracks = [exportTracks retain];
        _exportPath = [exportFolder retain];
        _totalItemCount = (int)_exportTracks.count;
    }
    return self;
}

- (BOOL)beforeProgress {
//    if ([super checkExportLimit] == YES) {
        return YES;
//    } else {
//        return NO;
//    }
}

//按个数传输
- (void)startTransfer {
    //是否存在导出曲目
    [_loghandle writeInfoLog:@"doProgress in IMBiTunesFileExport entered"];
    if (_exportTracks != nil && [_exportTracks count] > 0 && ![TempHelper stringIsNilOrEmpty:_exportPath]) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        for (IMBiTLTrack *track in _exportTracks) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:track.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
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
                NSString *itunesFilePath = [track.location path];
                if (![TempHelper stringIsNilOrEmpty:itunesFilePath]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[itunesFilePath lastPathComponent]];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transferDelegate transferProgress:progress];
                }
                
                if ([_fileManager fileExistsAtPath:itunesFilePath]) {
                    NSString *fileName = [[TempHelper replaceSpecialChar:[track name]] stringByAppendingPathExtension:[itunesFilePath pathExtension]];
                    NSString *destFilePath = [_exportPath stringByAppendingPathComponent:fileName];

                    if ([_fileManager fileExistsAtPath:destFilePath]) {
                        destFilePath = [TempHelper getFilePathAlias:destFilePath];
                    }
                    if ([_fileManager copyItemAtPath:itunesFilePath toPath:destFilePath error:nil]) {
                        [_limitation reduceRedmainderCount];
                        _successCount += 1;
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.name WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                        _failedCount += 1;
                    }
                } else {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.name WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                    _failedCount += 1;
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:track.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                _skipCount ++;
            }
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_loghandle writeInfoLog:@"doProgress in IMBiTunesFileExport existed"];

}

@end

//
//  IMBAppExport.m
//  AnyTrans
//
//  Created by iMobie on 8/2/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBAppExport.h"
#import "TempHelper.h"
#import "IMBApplicationManager.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "IMBAppConfig.h"
#import "IMBHelper.h"
#import "IMBLimitation.h"


@implementation IMBAppExport
@synthesize appKey = _appKey;
- (void)fileStartTransfer {
    if (_exportTracks != nil && [_exportTracks count]) {
        IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
        IMBInformation *information = [inforManager.informationDic objectForKey:_ipod.uniqueKey];
        AFCApplicationDirectory *afcAppmd = [_ipod.deviceHandle newAFCApplicationDirectory:_appKey];
        for (DriveItem *app in _exportTracks) {
            _currentDriveItem = [app retain];
            [[information applicationManager] setDelegate:self];
            [[information applicationManager] exportAppDocumentToMac:_exportPath withSimpleNode:app appAFC:afcAppmd];
            [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
        }
        [afcAppmd close];
    }
}

- (void)updateUI {
     _currentDriveItem.state = DownloadStateComplete;
}

- (void)sendCopyProgress:(uint64_t)progress {
     _curSize += progress;
    if (!_currentDriveItem.isDownLoad) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _currentDriveItem.currentSize = _curSize;
            _currentDriveItem.progress = (double)_currentDriveItem.currentSize/_currentDriveItem.fileSize *100;
            _currentDriveItem.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[IMBHelper getFileSizeString:_curSize reserved:2],[IMBHelper getFileSizeString:_currentDriveItem.fileSize reserved:2]];
        });
    }
}

- (void)startTransfer {
    [_loghandle writeInfoLog:@"AppFileExport DoProgress enter"];
    _archiveType = _ipod.appConfig.appExportToMacType;
    if (_exportTracks != nil && [_exportTracks count] > 0 && ![TempHelper stringIsNilOrEmpty:_exportPath]) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
    
        _singleStep = 3; //分为 加压，考出与删除App三部分
        _totalStep = _totalItemCount * _singleStep;
        _curStep = 0;
        IMBInformation *mation = [[IMBInformationManager shareInstance].informationDic objectForKey:_ipod.uniqueKey];
        IMBApplicationManager *appManager = [mation applicationManager];
        [appManager setListener:self];
        for (DriveItem *app in _exportTracks) {
//            if (_limitation.remainderCount == 0) {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:app.appName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                continue;
//            }
            if (app.state) {
                continue;
            }
            app.isStart = YES;
            _currentDriveItem = [app retain];
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) { //appManager.StartServiceStatus可以不用哈
                _currItemIndex += 1;
                if (![TempHelper stringIsNilOrEmpty:app.fileName]) {
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:[NSString stringWithFormat:@"Copying %@...",app.fileName]];
                    }
                }
//                NSString *expInfo = @"";
//                if (_archiveType == AppTransferType_All || _archiveType == AppTransferType_DocumentsOnly)
//                { expInfo = @"including docs"; }
//                else
//                { expInfo = @"app only"; }
                NSString *appFilePath = @"";
                appFilePath = [NSString stringWithFormat:@"%@/%@(v%@).ipa",_exportPath,app.fileName,app.docwsID];
                if ([appManager backupAppTolocal:app ArchiveType:_archiveType LocalFilePath:appFilePath]) {
//                    [_limitation reduceRedmainderCount];
                    _successCount += 1;
                    [IMBLimitation sharedLimitation].leftToMacNums--;
                    app.state = DownloadStateComplete;
                } else {
                     [[IMBTransferError singleton] addAnErrorWithErrorName:app.fileName WithErrorReson:@"Coping file failed."];
                    _failedCount +=1;
                    app.state = DownloadStateError;
                }
            } else {
                 [[IMBTransferError singleton] addAnErrorWithErrorName:app.fileName WithErrorReson:@"Skipped"];
                _skipCount += 1;
            }
        }

        [appManager removeListener];
    }
    
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_loghandle writeInfoLog:@"AppFileExport DoProgress Complete"];
}

-(void)setCurStep:(int)curStep {
    _curStep = (_currItemIndex - 1) * _singleStep + curStep;
    float progress = ((float)_curStep / _totalStep) * 100;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
}

@end

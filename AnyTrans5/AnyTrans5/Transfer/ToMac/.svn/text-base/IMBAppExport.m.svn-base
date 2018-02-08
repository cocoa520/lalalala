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

@implementation IMBAppExport

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
        for (IMBAppEntity *app in _exportTracks) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:app.appName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) { //appManager.StartServiceStatus可以不用哈
                _currItemIndex += 1;
                if (![TempHelper stringIsNilOrEmpty:app.appName]) {
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),app.appName]];
                    }
                }
//                NSString *expInfo = @"";
//                if (_archiveType == AppTransferType_All || _archiveType == AppTransferType_DocumentsOnly)
//                { expInfo = @"including docs"; }
//                else
//                { expInfo = @"app only"; }
                NSString *appFilePath = @"";
                appFilePath = [NSString stringWithFormat:@"%@/%@(v%@).ipa",_exportPath,app.appName,app.version];
                if ([appManager backupAppTolocal:app ArchiveType:_archiveType LocalFilePath:appFilePath]) {
                    [_limitation reduceRedmainderCount];
                    _successCount += 1;
                } else {
                     [[IMBTransferError singleton] addAnErrorWithErrorName:app.appName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                    _failedCount +=1;
                }
            } else {
                 [[IMBTransferError singleton] addAnErrorWithErrorName:app.appName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
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

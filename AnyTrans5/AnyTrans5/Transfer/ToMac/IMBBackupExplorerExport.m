//
//  IMBBackupExplorerExport.m
//  AnyTrans
//
//  Created by iMobie on 8/6/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBBackupExplorerExport.h"
#import "StringHelper.h"
#import "SimpleNode.h"

@implementation IMBBackupExplorerExport

- (id)initWithPath:(NSString *)exportPath exportTracks:(NSArray *)exportTracks withDelegate:(id)delegate backupPath:(NSString *)backupPath backUpDecrypt:(IMBBackupDecryptAbove4 *)backUpDecrypt {
    self = [super initWithPath:exportPath exportTracks:exportTracks withMode:@"" withDelegate:delegate];
    if (self) {
        _totalItemCount = 0;
        _backupPath = backupPath;
        _backUpDecrypt = backUpDecrypt;
    }
    return self;
}

- (void)startTransfer {
    [_loghandle writeInfoLog:@"FileSystemExport DoProgress enter"];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"MSG_COM_Prepare", nil)];
    }
    //统计个数
    [self cucleTotalCounts:_exportTracks];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transferDelegate transferPrepareFileEnd];
    }
    
    if (_backUpDecrypt) {
        //是加密备份
        for (int i=0;i<[_exportTracks count];i++) {
             SimpleNode *node = [_exportTracks objectAtIndex:i];
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:node.fileName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                NSString *destinationPath = [_exportPath stringByAppendingPathComponent:node.fileName];
                //如果选中的是文件
                if (!node.container) {
                    _currItemIndex ++;
                    if (![TempHelper stringIsNilOrEmpty:node.path]) {
                        NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[node.path lastPathComponent]];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                    }
                    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_transferDelegate transferProgress:progress];
                    }
                    NSString *sourceName = [_backUpDecrypt decryptSingleFile:node.domain withFilePath:[node.path lastPathComponent]];
                    NSString *backupfilePath = [_backUpDecrypt.outputPath stringByAppendingPathComponent:sourceName];
                    if (![_fileManager fileExistsAtPath:backupfilePath]) {
                        NSString *fd = @"";
                        if (node.key.length > 2) {
                            fd = [node.key substringWithRange:NSMakeRange(0, 2)];
                        }
                        backupfilePath = [[_backUpDecrypt.outputPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:node.key];
                    }
                    if ([_fileManager fileExistsAtPath:backupfilePath]) {
                        if ([_fileManager fileExistsAtPath:destinationPath]) {
                            destinationPath = [StringHelper createDifferentfileName:destinationPath];
                        }
                        if ([_fileManager copyItemAtPath:backupfilePath toPath:destinationPath error:nil]) {
                            [_limitation reduceRedmainderCount];
                            _successCount ++;
                        }else {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:node.fileName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                            _failedCount ++;
                        }
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:node.fileName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                        _failedCount ++;
                    }
                }else   //如果选中的是文件夹
                {
                    if ([_fileManager fileExistsAtPath:destinationPath]) {
                        destinationPath = [StringHelper createDifferentfileName:destinationPath];
                    }
                    [self copyBackupfileByDecrypt:node.childrenArray desPath:destinationPath backupPath:_backupPath];
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:node.fileName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                _skipCount ++;
            }
        }
    }else {
        for (int i=0;i<[_exportTracks count];i++) {
             SimpleNode *node = [_exportTracks objectAtIndex:i];
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:node.fileName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                NSString *destinationPath = [_exportPath stringByAppendingPathComponent:node.fileName];
                //如果选中的是文件
                if (!node.container) {
                    _currItemIndex++;
                    if (![TempHelper stringIsNilOrEmpty:node.path]) {
                        NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[node.path lastPathComponent]];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                    }
                    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_transferDelegate transferProgress:progress];
                    }
                    if ([_fileManager fileExistsAtPath:destinationPath]) {
                        destinationPath = [_exportPath stringByAppendingPathComponent:[StringHelper createDifferentfileName:node.fileName]];
                    }
                    NSString *backupfilePath = [_backupPath stringByAppendingPathComponent:node.key];
                    if (![_fileManager fileExistsAtPath:backupfilePath]) {
                        NSString *fd = @"";
                        if (node.key.length > 2) {
                            fd = [node.key substringWithRange:NSMakeRange(0, 2)];
                        }
                        backupfilePath = [[_backupPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:node.key];
                    }
                    if ([_fileManager fileExistsAtPath:backupfilePath]) {
                        if ([_fileManager fileExistsAtPath:destinationPath]) {
                            destinationPath = [StringHelper createDifferentfileName:destinationPath];
                        }
                        if ([_fileManager copyItemAtPath:backupfilePath toPath:destinationPath error:nil]) {
                            [_limitation reduceRedmainderCount];
                            _successCount ++;
                        }else {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:node.fileName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                            _failedCount ++;
                        }
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:node.fileName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                        _failedCount ++;
                    }
                }else   //如果选中的是文件夹
                {
                    if ([_fileManager fileExistsAtPath:destinationPath]) {
                        //暂时先移除
                        destinationPath = [StringHelper createDifferentfileName:destinationPath];
                    }
                    [self copyBackupfile:node.childrenArray desPath:destinationPath backupPath:_backupPath];
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:node.fileName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                _skipCount ++;
            }
        }
    }
    
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_loghandle writeInfoLog:@"FileSystemExport DoProgress Complete"];
}

- (BOOL)copyBackupfile:(NSArray *)nodeArray desPath:(NSString *)desPath backupPath:(NSString *)backupPath
{
    
    if ([_fileManager createDirectoryAtPath:desPath withIntermediateDirectories:NO attributes:nil error:nil]) {
        for (SimpleNode *node in nodeArray) {
            if (_limitation.remainderCount == 0) {
                break;
            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if (node.container) {
                NSString *despath = [desPath stringByAppendingPathComponent:node.fileName];
                [self copyBackupfile:node.childrenArray desPath:despath backupPath:backupPath];
                
            }else
            {
                _currItemIndex ++;
                if (![TempHelper stringIsNilOrEmpty:node.path]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[node.path lastPathComponent]];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transferDelegate transferProgress:progress];
                }
                
                NSString *backupfilePath = [backupPath stringByAppendingPathComponent:node.key];
                if (![_fileManager fileExistsAtPath:backupfilePath]) {
                    NSString *fd = @"";
                    if (node.key.length > 2) {
                        fd = [node.key substringWithRange:NSMakeRange(0, 2)];
                    }
                    backupfilePath = [[backupPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:node.key];
                }
                
                if ([_fileManager fileExistsAtPath:backupfilePath]) {
                    NSString *desfilePath = [desPath stringByAppendingPathComponent:node.fileName];
                    if ([_fileManager fileExistsAtPath:desfilePath]) {
                        desfilePath = [StringHelper createDifferentfileName:desfilePath];
                    }
                    if ([_fileManager copyItemAtPath:backupfilePath toPath:desfilePath error:nil]) {
                        [_limitation reduceRedmainderCount];
                        _successCount ++;
                    }else {
                        _failedCount ++;
                    }
                }else {
                    _failedCount ++;
                }
            }
        }
        return YES;
        
    }
    return NO;
}

- (BOOL)copyBackupfileByDecrypt:(NSArray *)nodeArray desPath:(NSString *)desPath backupPath:(NSString *)backupPath
{
    
    if ([_fileManager createDirectoryAtPath:desPath withIntermediateDirectories:NO attributes:nil error:nil]) {
        for (SimpleNode *node in nodeArray) {
            if (_limitation.remainderCount == 0) {
                break;
            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if (node.container) {
                NSString *despath = [desPath stringByAppendingPathComponent:node.fileName];
                [self copyBackupfileByDecrypt:node.childrenArray desPath:despath backupPath:backupPath];
            }else
            {
                _currItemIndex ++;
                if (![TempHelper stringIsNilOrEmpty:node.path]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[node.path lastPathComponent]];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transferDelegate transferProgress:progress];
                }
                NSString *sourceName = [_backUpDecrypt decryptSingleFile:node.domain withFilePath:[node.path lastPathComponent]];
                NSString *backupfilePath = [_backUpDecrypt.outputPath stringByAppendingPathComponent:sourceName];
                if (![_fileManager fileExistsAtPath:backupfilePath]) {
                    NSString *fd = @"";
                    if (node.key.length > 2) {
                        fd = [node.key substringWithRange:NSMakeRange(0, 2)];
                    }
                    backupfilePath = [[_backUpDecrypt.outputPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:node.key];
                }
                if ([_fileManager fileExistsAtPath:backupfilePath]) {
                    NSString *desfilePath = [desPath stringByAppendingPathComponent:node.fileName];
                    if ([_fileManager fileExistsAtPath:desfilePath]) {
                        desfilePath = [StringHelper createDifferentfileName:desfilePath];
                    }
                    if ([_fileManager copyItemAtPath:backupfilePath toPath:desfilePath error:nil]) {
                        [_limitation reduceRedmainderCount];
                        _successCount ++;
                    }else {
                        _failedCount ++;
                    }
                }else {
                    _failedCount ++;
                }
            }
            
        }
        
        return YES;
        
    }
    return NO;
}

- (void)cucleTotalCounts:(NSArray *)nodeArray {
    if (nodeArray != nil && nodeArray.count > 0) {
        for (SimpleNode *node in nodeArray) {
            if (node.container) {
                if (node.childrenArray.count > 0) {
                    [self cucleTotalCounts:node.childrenArray];
                }
            }else {
                _totalItemCount += 1;
            }
        }
    }
}

@end

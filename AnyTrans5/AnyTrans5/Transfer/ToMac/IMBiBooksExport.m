//
//  IMBiBooksExport.m
//  AnyTrans
//
//  Created by iMobie on 8/2/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBiBooksExport.h"
#import "IMBBookEntity.h"
#import "StringHelper.h"
#import "IMBZipHelper.h"
#import "IMBFileSystem.h"
#import "IMBBackupManager.h"
#import "DateHelper.h"
@implementation IMBiBooksExport

- (void)startTransfer {

    [_loghandle writeInfoLog:@"iBooksExport DoProgress enter"];
    if (_exportTracks != nil && [_exportTracks count] > 0 && ![StringHelper stringIsNilOrEmpty:_exportPath]) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"MSG_COM_Prepare", nil)];
        }
        _totalSize = [self caculateTransferTotalSize:_exportTracks];
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
      
        AFCMediaDirectory *afcDir = [_ipod.fileSystem afcMediaDirectory];
        for (IMBBookEntity *book in _exportTracks) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                _currItemIndex ++;
                if (![TempHelper stringIsNilOrEmpty:book.bookName]) {
                    if ([TempHelper stringIsNilOrEmpty:book.extension]) {
                        book.extension = [book.bookName pathExtension];
                    }
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),book.bookName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
//                    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
//                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                        [_transferDelegate transferProgress:progress];
//                    }
                if ([book.extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
                    NSString *filePath = [@"Books" stringByAppendingPathComponent:book.path];
                    if ([afcDir fileExistsAtPath:filePath]) {
                        //将电子书考到指定的目录下
                        NSString *desfilePath = [_exportPath stringByAppendingFormat:@"/%@.pdf",book.bookName];
                        if ([_fileManager fileExistsAtPath:desfilePath]) {
                            //如果存在，创建一个新的名字
                            desfilePath = [StringHelper createDifferentfileName:desfilePath];
                            
                        }
                        BOOL issuccess = [self copyRemoteFile:filePath toLocalFile:desfilePath];
                        if (issuccess) {
                            [_limitation reduceRedmainderCount];
                            _successCount ++;
                            IMBExportSetting *exportSetting = [[IMBExportSetting alloc]initWithIPod:_ipod];
                            [exportSetting readDictionary];
                            if (exportSetting.isCreadPhotoDate) {
                                NSDictionary *dice3= [_ipod.fileSystem getFileInfo:book.fullPath];
                                NSDate *creadDate = [dice3 objectForKey:@"st_birthtime"];
                                NSTask *task;
                                task = [[NSTask alloc] init];
                                [task setLaunchPath: @"/usr/bin/touch"];
                                NSArray *arguments;
                                NSString *str = [DateHelper dateFrom2001ToDate:creadDate withMode:3];
                                NSString *strData = [TempHelper replaceSpecialChar:str];
                                strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
                                strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                arguments = [NSArray arrayWithObjects: @"-mt", strData, filePath, nil];
                                [task setArguments: arguments];
                                NSPipe *pipe;
                                pipe = [NSPipe pipe];
                                [task setStandardOutput: pipe];
                                NSFileHandle *file;
                                file = [pipe fileHandleForReading];
                                [task launch];
                            }
                        }else {
                             [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                            _failedCount ++;
                        }
                    }else
                    {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                        _failedCount ++;
                    }
                }else if ([book.extension caseInsensitiveCompare:@"epub"] == NSOrderedSame || [book.extension caseInsensitiveCompare:@"ibooks"] == NSOrderedSame ) {
                    NSString *filePath = [_exportPath stringByAppendingFormat:@"/%@.epub",book.bookName];
                    if ([book.extension caseInsensitiveCompare:@"epub"] == NSOrderedSame) {
                        filePath = [_exportPath stringByAppendingFormat:@"/%@.epub",book.bookName];
                    }else if ([book.extension caseInsensitiveCompare:@"ibooks"] == NSOrderedSame) {
                        filePath = [_exportPath stringByAppendingFormat:@"/%@.ibooks",book.bookName];
                    }
                    if ([_fileManager fileExistsAtPath:filePath]) {
                        //如果存在，创建一个新的名字
                        filePath = [StringHelper createDifferentfileName:filePath];
                    }
                    //创建此文件
                    BOOL issuccess = [_fileManager createFileAtPath:filePath contents:nil attributes:nil];
                    if (issuccess) {
                        NSString *rootPath = nil;
                        if (book.isPurchase) {
                            rootPath = [@"Books/Purchases" stringByAppendingFormat:@"/%@",book.path];
                        }else {
                            rootPath = [@"Books" stringByAppendingPathComponent:book.path];
                        }
                        if ([afcDir fileExistsAtPath:rootPath]) {
                            _successCount ++;
                            ZipFile *zipFile= [[ZipFile alloc] initWithFileName:filePath mode:ZipFileModeCreate];
                            [self exportepubBook:afcDir zipFile:zipFile rootPath:rootPath basefolder:@""];
                            IMBExportSetting *exportSetting = [[IMBExportSetting alloc]initWithIPod:_ipod];
                            [exportSetting readDictionary];
                            if (exportSetting.isCreadPhotoDate) {
                                NSDictionary *dice3= [_ipod.fileSystem getFileInfo:book.fullPath];
                                NSDate *creadDate = [dice3 objectForKey:@"st_birthtime"];
                                NSTask *task;
                                task = [[NSTask alloc] init];
                                [task setLaunchPath: @"/usr/bin/touch"];
                                NSArray *arguments;
                                NSString *str = [DateHelper dateFrom2001ToDate:creadDate withMode:3];
                                NSString *strData = [TempHelper replaceSpecialChar:str];
                                strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
                                strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                arguments = [NSArray arrayWithObjects: @"-mt", strData, filePath, nil];
                                [task setArguments: arguments];
                                NSPipe *pipe;
                                pipe = [NSPipe pipe];
                                [task setStandardOutput: pipe];
                                NSFileHandle *file;
                                file = [pipe fileHandleForReading];
                                [task launch];

                            }
                            NSLog(@"@@");
                            [zipFile close];
                            [zipFile release];
                            zipFile = nil;
                            
                            [_limitation reduceRedmainderCount];
                        }else {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                            _failedCount ++;
                        }
                    }else {
                        _failedCount ++;
                    }
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                _skipCount ++;
            }
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_loghandle writeInfoLog:@"iBooksExport DoProgress Complete"];
}

- (void)exportepubBook:(AFCMediaDirectory *)afcDir zipFile:(ZipFile *)zipFile rootPath:(NSString *)rootPath basefolder:(NSString *)basefolder {
    NSArray *arr = [afcDir getItemInDirWithoutRootDir:rootPath];
    for (AMFileEntity *file in arr) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        NSString *fileName = [file.FilePath lastPathComponent];
        NSString *filePathinzip = [basefolder stringByAppendingPathComponent:fileName];
        //如果是目录
        if (file.FileType == AMDirectory) {
            [self exportepubBook:afcDir zipFile:zipFile rootPath:file.FilePath basefolder:filePathinzip];
        }else {
            AFCFileReference *read = [afcDir openForRead:file.FilePath];
            if (read) {
                ZipWriteStream *stream= [zipFile writeFileInZipWithName:filePathinzip fileDate:[NSDate dateWithTimeIntervalSinceNow:-86400.0] compressionLevel:ZipCompressionLevelBest];
                if (stream) {
                    const uint32_t bufsz = 10240;
                    char *buff = (char*)malloc(bufsz);
                    while (1) {
                        uint64_t n = [read readN:bufsz bytes:buff];
                        if (n==0) break;
                        //将字节数据转化为NSdata
                        NSData *b2 = [[NSData alloc]
                                      initWithBytesNoCopy:buff length:n freeWhenDone:NO];
                        
                        //输入流写数据
                        [stream writeData:b2];
                        [b2 release];
                        [self sendCopyProgress:n];
                    }
                    free(buff);
                    [stream finishedWriting];
                }
                [read closeFile];
            }
        }
    }
}

- (int64_t)caculateTransferTotalSize:(NSArray *)array {
    int64_t size = 0;
    if (array != nil) {
        for (IMBBookEntity *entity in array) {
            size += entity.size;
        }
    }
    return size;
}

@end

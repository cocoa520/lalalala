//
//  IMBPhotoFileExport.m
//  iMobieTrans
//
//  Created by iMobie on 7/24/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBPhotoFileExport.h"
#import "IMBPhotoEntity.h"
#import "IMBFileSystem.h"
#import "TempHelper.h"
#import "DateHelper.h"
#import "ATTracker.h"
#import "CommonEnum.h"
#import "NSString+Category.h"
#import "IMBPhotoExportSettingConfig.h"
//#import "IMBTransResult.h"
#import "IMBMediaInfo.h"
#import "IMBPhotoHeicManager.h"
@implementation IMBPhotoFileExport
@synthesize exportType = _exportType;

- (BOOL)beforeProgress {
    return YES;
    if (_ipod != nil) {
        [_ipod startSync];
        return YES;
    } else {
        return NO;
    }
}

- (void)startTransfer {
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"PhotoFileExport DoProgress enter:%lu ; export Path:%@",(unsigned long)_exportTracks.count,_exportPath]];
    if (_exportTracks != nil && _exportTracks.count > 0 && ![TempHelper stringIsNilOrEmpty:_exportPath]) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"MSG_COM_Prepare", nil)];
        }
        //计算totalSize
        _totalSize = [self caculateTransferTotalSize:_exportTracks];
        
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (IMBPhotoEntity *pe in _exportTracks) {
            if (_limitation.remainderCount == 0 && _exportType != 3) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                _currItemIndex += 1;
                //获得设备中的文件路径
                NSString *remotingFilePath = pe.allPath;
                if (![TempHelper stringIsNilOrEmpty:pe.photoName]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),pe.photoName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                NSString *filePath = [_exportPath stringByAppendingPathComponent:pe.photoName];
                NSString *nowPath = @"";
                BOOL success = NO;
                if (_exportType == 1) {//导出设备中的图片
                    //用户用设备修改过的图片导出
                    if (![pe.photoPath contains:@"Sync"]) {
                        if ([_fileManager fileExistsAtPath:filePath]) {
                            filePath = [TempHelper getFilePathAlias:filePath];
                        }
                        NSString *deviceCutImagePath = [@"PhotoData/Metadata/" stringByAppendingPathComponent:remotingFilePath];
                        if ([_ipod.fileSystem fileExistsAtPath:deviceCutImagePath]) {
                            [_ipod.fileSystem copyRemoteFile:deviceCutImagePath toLocalFile:filePath];
//                            [_ipod.fileSystem asyncCopyRemoteFile:deviceCutImagePath toLocalFile:filePath];
                        }else {
                            deviceCutImagePath = [@"PhotoData/Mutations/" stringByAppendingPathComponent:[[remotingFilePath stringByDeletingPathExtension] stringByAppendingPathComponent:@"Adjustments/FullSizeRender.jpg"]];
                            if ([_ipod.fileSystem fileExistsAtPath:deviceCutImagePath]) {
                               success = [_ipod.fileSystem copyRemoteFile:deviceCutImagePath toLocalFile:filePath];
                                if (pe.kindSubType == 2) {
                                    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i",filePath,[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"],nil];
                                    [self runFFMpeg:params];
                                    
                                    NSImage *mediaInfo = [[NSImage alloc]initWithContentsOfFile:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"]];
//                                    NSImage *mediaInfo = [[NSImage alloc]initWithContentsOfFile:filePath];
                                    NSString *imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width ,(int)mediaInfo.size.height];                                    IMBPhotoExportSettingConfig *exportSeetingConfig = [IMBPhotoExportSettingConfig singleton];
                                    NSString *path = @"";
                                    if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_MP4) {
                                        path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"mp4"];
                                        success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                    }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_M4V){
                                        path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"m4v"];
                                        success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                    }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifHigh){
                                        path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                        success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                    }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifMiddle){
                                        imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/2 ,(int)mediaInfo.size.height/2];
                                        path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                        success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/2倍转换
                                    }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifLow){
                                        imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/4 ,(int)mediaInfo.size.height/4];
                                        path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                        success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/4倍转换
                                    }
                                    [mediaInfo release];
                                    nowPath = path;
                                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                        if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                            [_fileManager removeItemAtPath:filePath error:nil];
                                        }
                                    });
                                }
                            }
                        }
                    }
                    
                    //导出设备存在的图片
                    if (![_ipod.fileSystem fileExistsAtPath:remotingFilePath]) {
                        remotingFilePath = pe.thumbPath;
                    }
                    if ([_ipod.fileSystem fileExistsAtPath:remotingFilePath]) {
                        if ([_fileManager fileExistsAtPath:filePath]) {
                            filePath = [TempHelper getFilePathAlias:filePath];
                        }
                        if (pe.kindSubType == 2) {
                            success = [_ipod.fileSystem copyRemoteFile:[pe.photoPath stringByAppendingPathComponent:pe.photoName] toLocalFile:filePath];
                            
                            NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i",filePath,[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"],nil];
                            [self runFFMpeg:params];
 
                            NSImage *mediaInfo = [[NSImage alloc]initWithContentsOfFile:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"]];
                            NSString *imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width ,(int)mediaInfo.size.height];
                            
                            [_fileManager removeItemAtPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"] error:nil];
                            
                            IMBPhotoExportSettingConfig *exportSeetingConfig = [IMBPhotoExportSettingConfig singleton];
                            NSString *path = @"";
                            if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_MP4) {
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"mp4"];
                               success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                            }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_M4V){
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"m4v"];
                               success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                            }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifHigh){
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];
                            }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifMiddle){
                               imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/2 ,(int)mediaInfo.size.height/2];
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/2倍转换
                            }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifLow){
                                imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/4 ,(int)mediaInfo.size.height/4];
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/4倍转换
                            }
                            if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                nowPath = path;
                            }else{
                                nowPath = filePath;
                            }
                            [mediaInfo release];
                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                    [_fileManager removeItemAtPath:filePath error:nil];
                                }
                            });
                          
                        }else if ([[[pe.photoName pathExtension] lowercaseString] isEqualToString:@"heic"]){
                            success = [_ipod.fileSystem copyRemoteFile:[pe.photoPath stringByAppendingPathComponent:pe.photoName] toLocalFile:filePath];
                            nowPath = filePath;
                            IMBPhotoExportSettingConfig *exportSeetingConfig = [IMBPhotoExportSettingConfig singleton];
                            if (!exportSeetingConfig.isHEICState) {
                                IMBPhotoHeicManager *pM = [IMBPhotoHeicManager singleton];
                                NSString *heicFilePath = filePath;
                                NSString *inputFilePath = [TempHelper getAppTempPath];
                                NSString *outputFilePath = [filePath stringByDeletingLastPathComponent];
                                NSString *fileType = @"jpg";
                                nowPath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
                                [pM initParamsWithHeic:heicFilePath withInputPath:inputFilePath withOutputPath:outputFilePath withFileType:fileType];
                                [pM startConvert];
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                    [_fileManager removeItemAtPath:heicFilePath error:nil];
                                });
                            }
                        }else{
                            nowPath = filePath;
                            success = [self copyRemoteFile:remotingFilePath toLocalFile:filePath];
                        }
                        if (success) {
                            IMBPhotoExportSettingConfig *photoExportConfig = [IMBPhotoExportSettingConfig singleton];
                            if (photoExportConfig.isCreadPhotoDate) {
                                NSTask *task;
                                task = [[NSTask alloc] init];
                                [task setLaunchPath: @"/usr/bin/touch"];
                                NSArray *arguments;
                                NSString *str = [DateHelper dateFrom2001ToString:pe.photoDateData withMode:3];
                                NSString *strData = [TempHelper replaceSpecialChar:str];
                                strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
                                strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                arguments = [NSArray arrayWithObjects: @"-mt", strData, nowPath, nil];
                                [task setArguments: arguments];
                                NSPipe *pipe;
                                pipe = [NSPipe pipe];
                                [task setStandardOutput: pipe];
                                NSFileHandle *file;
                                file = [pipe fileHandleForReading];
                                [task launch];
                            }
                            [_limitation reduceRedmainderCount];
                            _successCount += 1;
                        }else {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                            _failedCount += 1;
                        }
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                        [_loghandle writeInfoLog:[NSString stringWithFormat:@"photo isn't exist:%@",pe.allPath]];
                        _failedCount += 1;
                    }
                }else {//导出备份文件中的图片
                    if ([fileManager fileExistsAtPath:pe.oriPath]) {
                        if ([fileManager fileExistsAtPath:filePath]) {
                            filePath = [TempHelper getFilePathAlias:filePath];
                        }
                        if ([fileManager fileExistsAtPath:pe.oriPath]) {
                            if (pe.kindSubType == 2) {
                                success =  [fileManager copyItemAtPath:pe.oriPath toPath:filePath error:nil];
                                NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i",filePath,[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"],nil];
                                [self runFFMpeg:params];
                                
                                NSImage *mediaInfo = [[NSImage alloc]initWithContentsOfFile:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"]];
//                                NSImage *mediaInfo = [[NSImage alloc]initWithContentsOfFile:filePath];
                                IMBPhotoExportSettingConfig *exportSeetingConfig = [IMBPhotoExportSettingConfig singleton];
                                NSString *path = @"";
                                NSString *imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width ,(int)mediaInfo.size.height];
                                if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_MP4) {
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"mp4"];
                                    success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_M4V){
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"m4v"];
                                    success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifHigh){
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                    success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifMiddle){
                                    imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/2 ,(int)mediaInfo.size.height/2];
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                    success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/2倍转换
                                }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifLow){
                                    imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/4 ,(int)mediaInfo.size.height/4];
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                    success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/4倍转换
                                }
                                
                                if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                    nowPath = filePath;
                                }else{
                                    nowPath = path;
                                }
                                [mediaInfo release];
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                    if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                        [_fileManager removeItemAtPath:filePath error:nil];
                                    }
                                });
                            }else if ([[[pe.photoName pathExtension] lowercaseString] isEqualToString:@"heic"]){
                                success =  [fileManager copyItemAtPath:pe.oriPath toPath:filePath error:nil];
                                IMBPhotoExportSettingConfig *exportSeetingConfig = [IMBPhotoExportSettingConfig singleton];
                                nowPath = filePath;
                                if (!exportSeetingConfig.isHEICState) {
                                    IMBPhotoHeicManager *pM = [IMBPhotoHeicManager singleton];
                                    NSString *heicFilePath = filePath;
                                    NSString *inputFilePath = [TempHelper getAppTempPath];
                                    NSString *outputFilePath = [filePath stringByDeletingLastPathComponent];
                                    NSString *fileType = @"jpg";
                                    [pM initParamsWithHeic:heicFilePath withInputPath:inputFilePath withOutputPath:outputFilePath withFileType:fileType];
                                    [pM startConvert];
                                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                        if([_fileManager fileExistsAtPath:heicFilePath]){
                                            [_fileManager removeItemAtPath:heicFilePath error:nil];
                                        }
                                     
                                    });
                                }
                            }else{
                                nowPath = filePath;
                                //success = [self copyRemoteFile:remotingFilePath toLocalFile:filePath];
                                success =  [fileManager copyItemAtPath:pe.oriPath toPath:filePath error:nil];
                            }
                        }
                        if (success) {
                            if (_exportType == 2) {
                                [_limitation reduceRedmainderCount];
                            }
                            _successCount += 1;
                            IMBPhotoExportSettingConfig *photoExportConfig = [IMBPhotoExportSettingConfig singleton];
                            if (photoExportConfig.isCreadPhotoDate) {
                                NSTask *task;
                                task = [[NSTask alloc] init];
                                [task setLaunchPath: @"/usr/bin/touch"];
                                NSArray *arguments;
                                NSString *str = [DateHelper dateFrom2001ToString:pe.photoDateData withMode:3];
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
                            [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                            _failedCount += 1;
                        }
                    }
                }
                
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    float progress = (float)_successCount/(float)_exportTracks.count*100;
                    [_transferDelegate transferProgress:progress];
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                _skipCount ++;
            }
        }
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
    });

    [_loghandle writeInfoLog:@"PhotoFileExport DoProgress End"];
}

//live photo 转Video
- (BOOL)startVideoConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath withFormat:(NSString *)format {
    NSLog(@"start Convert");
    NSArray *params = [NSArray arrayWithObjects:@"-i",[NSString stringWithFormat:@"%@",sourPath], @"-y",@"-vcodec",@"mpeg4",@"-r",@"30000/1001",@"-q",@"2",@"-b:v",@"2500",@"-ab",@"128k", @"-s",format,@"-strict",@"-2",[NSString stringWithFormat:@"%@",conPath], nil];
    return [self runFFMpeg:params];
}
//live photo 转gif
- (BOOL)startGifConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath withFormat:(NSString *)format {
    NSLog(@"start Convert");
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-ss",@"0",@"-t",@"2",@"-i",[NSString stringWithFormat:@"%@",sourPath],@"-s",format,@"-f",@"gif",[NSString stringWithFormat:@"%@",conPath],nil];
    return [self runFFMpeg:params];
}

- (BOOL)startConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath {
    [_loghandle writeInfoLog:@"start Convert"];
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-ss",@"0",@"-t",@"10",@"-i",[NSString stringWithFormat:@"%@",sourPath],@"-s",@"480*620",@"-f",@"gif",[NSString stringWithFormat:@"%@",conPath],nil];
    return [self runFFMpeg:params];
}

- (BOOL) runFFMpeg:(NSArray*)params {
    [_loghandle writeInfoLog:@"ffmpeg Start"];
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    
    if (params != nil) {
        NSLog(@"params:%@",params);
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath: ffmpegPath];
        [task setArguments: params];
        //        NSPipe *errorPipe = [NSPipe pipe];
        //        [task setStandardError:errorPipe];
        //        NSFileHandle *errFile = [errorPipe fileHandleForReading];
        //        [errFile waitForDataInBackgroundAndNotify];
        
        [task launch];
        [task waitUntilExit];
        sleep(1);
        int status = [task terminationStatus];
        [task release];
        if (status == 0) {
            NSLog(@"Task succeeded.");
            [_loghandle writeInfoLog:@"ConvertMov succeeded"];
            return YES;
        } else {
            NSLog(@"Task failed.");
            [_loghandle writeInfoLog:@"ConvertMov failed"];
            return NO;
        }
    }
    return NO;
}

- (int64_t)caculateTransferTotalSize:(NSArray *)array {
    int64_t size = 0;
    if (array != nil) {
        for (IMBPhotoEntity *entity in array) {
            size += entity.photoSize;
        }
    }
    return size;
}

- (void)afterProgress{
    //停止同步
    [_ipod endSync];
}

@end

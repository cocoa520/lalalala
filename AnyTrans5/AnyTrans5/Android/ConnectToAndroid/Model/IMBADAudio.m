//
//  IMBADAudio.m
//  
//
//  Created by ding ming on 17/3/17.
//
//

#import "IMBADAudio.h"

@implementation IMBADAudio

#pragma mark - Abstract Method
- (int)queryDetailContent {
    [_loghandle writeInfoLog:@"Audio queryDetailContent Begin"];
    int result = 0;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        NSString *jsonStr = [self createParamsjJsonCommand:AUDIO Operate:QUERY ParamDic:[NSDictionary dictionary]];
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSArray *msgArr = [IMBFileHelper dictionaryWithJsonString:msg];
                    if (msgArr != nil) {
                        for (NSDictionary *msgDic in msgArr) {
                            IMBADAudioTrack *track = [[IMBADAudioTrack alloc] init];
                            if ([msgDic.allKeys containsObject:@"album"]) {
                                track.album = [msgDic objectForKey:@"album"];
                            }
                            if ([IMBHelper stringIsNilOrEmpty:track.album]) {
                                track.album = CustomLocalizedString(@"mediaView_id_4", nil);
                            }
                            if ([msgDic.allKeys containsObject:@"albumId"]) {
                                track.albumId = [[msgDic objectForKey:@"albumId"] intValue];
                            }
                            if ([msgDic.allKeys containsObject:@"id"]) {
                                track.trackId = [[msgDic objectForKey:@"id"] intValue];
                            }
                            if ([msgDic.allKeys containsObject:@"displayName"]) {
                                NSString *ext = nil;
                                if ([msgDic.allKeys containsObject:@"extension"]) {
                                    ext = [msgDic objectForKey:@"extension"];
                                }
                                if (![IMBFileHelper stringIsNilOrEmpty:ext]) {
                                    track.name = [[msgDic objectForKey:@"displayName"] stringByAppendingPathExtension:ext];
                                }else {
                                    track.name = [msgDic objectForKey:@"displayName"];
                                }
                            }
                            if ([msgDic.allKeys containsObject:@"singer"]) {
                                track.singer = [msgDic objectForKey:@"singer"];
                            }
                            if ([IMBFileHelper stringIsNilOrEmpty:track.singer]) {
                                track.singer = CustomLocalizedString(@"mediaView_id_3", nil);
                            }
                            if ([msgDic.allKeys containsObject:@"size"]) {
                                track.size = [[msgDic objectForKey:@"size"] longLongValue];
                            }
                            if ([msgDic.allKeys containsObject:@"time"]) {
                                track.time = [[msgDic objectForKey:@"time"] longLongValue];
                            }
                            if ([msgDic.allKeys containsObject:@"title"]) {
                                track.title = [msgDic objectForKey:@"title"];
                            }
                            if ([msgDic.allKeys containsObject:@"url"]) {
                                track.url = [msgDic objectForKey:@"url"];
                            }
                            if ([msgDic.allKeys containsObject:@"mimetype"]) {
                                track.mimeType = [msgDic objectForKey:@"mimetype"];
                            }
                            _reslutEntity.reslutCount ++;
                            _reslutEntity.reslutSize += track.size;
                            _reslutEntity.scanType = ScanAudioFile;
                            [_reslutEntity.reslutArray addObject:track];
                            [track release];
                        }
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Audio queryDetailContent Error"];
                }
                [msg release];
            }];
            NSLog(@"ret:%d",ret);
            if (!ret) {
                result = -3;
            }
        }else {
            result = -2;
        }
        
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        result = -1;
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    [_loghandle writeInfoLog:@"Audio queryDetailContent End"];
    return result;
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr {
    [_loghandle writeInfoLog:@"Audio exportContent Begin"];
    int result = 0;
    if ([IMBFileHelper stringIsNilOrEmpty:_serialNumber]) {
        [_loghandle writeInfoLog:@"Audio exportContent Error -1"];
        result = -1;
    }
    if ([IMBFileHelper stringIsNilOrEmpty:targetPath]) {
        [_loghandle writeInfoLog:@"Audio exportContent Error -2"];
        result = -2;
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"VideoDownload_Pop_Music", nil)];
    }
    _currCount = 0;
    _currSize = 0;
    _totalSize = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = (int)exportArr.count;
    [self sumTotalSize:exportArr];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:targetPath]) {
        [fm createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if (result == 0) {
        if (ret) {
            IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
            [coreSocket setThread:[NSThread currentThread]];
            for (IMBADAudioTrack *track in exportArr) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    continue;
                }
                if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transDelegate transferFile:track.title];
                }
                _currCount ++;
                BOOL isSuccess = NO;
                NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:track.url, @"sourcePath", nil];
                NSString *jsonStr = [self createParamsjJsonCommand:AUDIO Operate:EXPORT ParamDic:paramDic];
                if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                    NSString *exFilePath = [targetPath stringByAppendingPathComponent:[track.name stringByReplacingOccurrencesOfString:@"/" withString:@" "]];
                    if ([fm fileExistsAtPath:exFilePath]) {
                        exFilePath = [IMBFileHelper getFilePathAlias:exFilePath];
                    }
                    isSuccess = [fm createFileAtPath:exFilePath contents:nil attributes:nil];
                    if (track.size > 0) {
                        if (isSuccess) {
                            @try {
                                NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exFilePath];
                                isSuccess = [coreSocket launchRequestContent:jsonStr FileSize:track.size FinishBlock:^(NSData *data) {
                                    if (handle) {
                                        _currSize += data.length;
                                        if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                                            float progress = (float)_currSize / _totalSize * 100;
                                            if (progress > 99) {
                                                progress = 99;
                                            }
                                            NSLog(@"currsize:%lld   _totalSize:%lld  progress:%f",_currSize,_totalSize,progress);
                                            [_transDelegate transferProgress:progress];
                                        }
                                        [handle writeData:data];
                                    }
                                }];
                                if (handle) {
                                    [handle closeFile];
                                    handle = nil;
                                }
                                if (!isSuccess) {
                                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.name WithErrorReson:CustomLocalizedString(@"Ex_Op_GetARPhotoDataFail", nil)];
                                    NSLog(@"launch request failed");
                                    if ([fm fileExistsAtPath:exFilePath]) {
                                        [fm removeItemAtPath:exFilePath error:nil];
                                    }
                                }else {
                                    [track setLocalPath:exFilePath];
                                }
                            }
                            @catch (NSException *exception) {
                                isSuccess = NO;
                                NSLog(@"exception:%@",exception.reason);
                            }
                        }else {
                            NSLog(@"create file failed");
                        }
                    }
                }else {
                    NSLog(@"create json failed");
                }
                if (isSuccess) {
                    _successCount ++;
                }else {
                    _failedCount ++;
                }
            }
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_transDelegate transferProgress:100];
            }
            //关闭连接并释放端口
            [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
            [scoket release];
            [coreSocket release];
        }else {
            [_loghandle writeInfoLog:@"Audio exportContent Error -3"];
            result = -3;
            //关闭连接并释放端口
            [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
            [scoket release];
        }
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    
    [_loghandle writeInfoLog:@"Audio exportContent End"];
    return result;
}

- (int)importContent:(NSArray *)importArr {
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"VideoDownload_Pop_Music", nil)];
    }
    int result = 0;
    _currCount = 0;
    _currSize = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = (int)importArr.count;
    [self getLocalFileTotalSize:importArr];
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if (ret) {
        NSFileManager *fm = [NSFileManager defaultManager];
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        for (NSString *path in importArr) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }

            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:[path lastPathComponent]];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            if ([fm fileExistsAtPath:path]) {
                NSString *fileName = [fm displayNameAtPath:path];
                NSDictionary *fileDic = [fm attributesOfItemAtPath:path error:nil];
                long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
                NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:fileName, @"fileName", nil];
                NSString *jsonStr = [self createParamsjJsonCommand:AUDIO Operate:IMPORT ParamDic:paramDic];
                if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                    isSuccess = [coreSocket launchRequestContent:jsonStr FilePath:path FileSize:fileSize FinishBlock:^(NSData *data) {
                        _currSize += data.length;
                        if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                            float progress = (float)_currSize / _totalSize * 100;
                            NSLog(@"progress:%f",progress);
                            [_transDelegate transferProgress:progress];
                        }
                    }];
                    if (isSuccess){
                        IMBMediaInfo *mediaInfo = [IMBMediaInfo singleton];
                        [mediaInfo openWithFilePath:path];
                        int duration = 0;
                        NSString *audioArtist = @"";
                        NSString *audioAlbum = @"";
                        if ([mediaInfo isGotMetaData]) {
                            duration = [mediaInfo.length intValue];
                            audioAlbum = mediaInfo.album;
                            audioArtist = mediaInfo.artist;
                        }
                        NSDictionary *paramSycDic = [NSDictionary dictionaryWithObjectsAndKeys:fileName, @"fileName", [NSString stringWithFormat:@"%lld",fileSize], @"audioSize", [NSString stringWithFormat:@"%d",duration], @"audioDuration", [fileName stringByDeletingPathExtension], @"audioName", [fileName stringByDeletingPathExtension], @"audioTitle", audioArtist, @"audioArtist", audioAlbum, @"audioAlbum", nil];
                        NSString *jsonSyncStr = [self createParamsjJsonCommand:AUDIO Operate:SYNC ParamDic:paramSycDic];
                        isSuccess = [coreSocket launchSyncRequestContent:jsonSyncStr FinishBlock:^(NSData *data) {
                            NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSLog(@"sync msg:%@",msg);
                            [msg release];
                        }];
                        if (!isSuccess) {
                            result = -5;
                            NSLog(@"sync launch request failed");
                        }
                    }else {
                        result = -4;
                        NSLog(@"import launch request failed");
                    }
                }else {
                    result = -1;
                    NSLog(@"create json failed");
                }
                if (isSuccess) {
                    _successCount ++;
                }else {
                    _failedCount ++;
                }
            }else {
                result = -2;
                _failedCount ++;
                NSLog(@"file isn't exist");
            }
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        result = -3;
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    return result;
}

- (int)deleteContent:(NSArray *)deleteArr {
    int result = 0;
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:@"delete content start"];
    }
    _currCount = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = (int)deleteArr.count;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        for (IMBADAudioTrack *track in deleteArr) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:track.title];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",track.trackId], @"audioId", track.url, @"audioUrl", nil];
            NSString *jsonStr = [self createParamsjJsonCommand:AUDIO Operate:DELETE ParamDic:paramDic];
            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                isSuccess = [coreSocket launchDeleteRequestContent:jsonStr FinishBlock:^(NSData *data) {
                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"sync msg:%@",msg);
                    [msg release];
                }];
                if (!isSuccess){
                    result = -1;
                    NSLog(@"delete launch request failed");
                }
            }else {
                result = -2;
                NSLog(@"create json failed");
            }
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                float progress = (float)_currCount / _totalCount * 100;
                NSLog(@"progress:%f",progress);
                [_transDelegate transferProgress:progress];
            }
            if (isSuccess) {
                _successCount ++;
            }else {
                _failedCount ++;
            }
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        result = -3;
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    return result;
}

- (void)sumTotalSize:(NSArray *)array {
    for (IMBADAudioTrack *track in array) {
        _totalSize += track.size;
    }
}

@end

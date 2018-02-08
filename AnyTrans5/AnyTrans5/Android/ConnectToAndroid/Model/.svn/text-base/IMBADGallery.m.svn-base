//
//  IMBADGallery.m
//  
//
//  Created by ding ming on 17/3/17.
//
//

#import "IMBADGallery.h"

@implementation IMBADGallery

#pragma mark - Abstract Method
- (int)queryDetailContent {
    [_loghandle writeInfoLog:@"Gallery queryDetailContent Begin"];
    int result = 0;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:@"images", @"tableName", nil];
        NSString *jsonStr = [self createParamsjJsonCommand:IMAGE Operate:QUERY ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSArray *msgArr = [IMBFileHelper dictionaryWithJsonString:msg];
                    if (msgArr != nil) {
                        for (NSDictionary *msgDic in msgArr) {
                            NSString *path = nil;
                            if ([msgDic.allKeys containsObject:@"url"]) {
                                path = [msgDic objectForKey:@"url"];
                            }
                            if (![IMBFileHelper stringIsNilOrEmpty:path]) {
                                NSArray *array = [path pathComponents];
                                NSString *albumName = nil;
                                if (array.count > 1) {
                                    albumName = [array objectAtIndex:array.count - 2];
                                }
                                if (![IMBFileHelper stringIsNilOrEmpty:albumName]) {
                                    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                        IMBADAlbumEntity *item = (IMBADAlbumEntity *)evaluatedObject;
                                        if ([[item albumName] isEqualToString:albumName]) {
                                            return YES;
                                        }else {
                                            return NO;
                                        }
                                    }];
                                    NSArray *preArray = [_reslutEntity.reslutArray filteredArrayUsingPredicate:pre];
                                    IMBADAlbumEntity *albumEntity = nil;
                                    BOOL isExist = NO;
                                    if (preArray != nil && preArray.count > 0) {
                                        isExist = YES;
                                        albumEntity = [preArray objectAtIndex:0];
                                    }else {
                                        isExist = NO;
                                        albumEntity = [[IMBADAlbumEntity alloc] init];
                                        [albumEntity setAlbumName:albumName];
                                        [albumEntity setIsAppAlbum:NO];
                                    }
                                    [self paresPhotoDic:msgDic withAlbumEntity:albumEntity];
                                    if (!isExist) {
                                        _reslutEntity.scanType = ScanPhotosFile;
                                        [_reslutEntity.reslutArray addObject:albumEntity];
                                        [albumEntity release];
                                        albumEntity = nil;
                                    }
                                }
                            }
                        }
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Gallery queryDetailContent Error"];
                }
                [msg release];
            }];
            if (ret) {
                if (_reslutEntity.reslutCount > 0) {
                    NSDictionary *thumParamDic = [NSDictionary dictionaryWithObjectsAndKeys:@"thumbnails", @"tableName", nil];
                    NSString *thumJsonStr = [self createParamsjJsonCommand:IMAGE Operate:QUERY ParamDic:thumParamDic];
                    if (![IMBFileHelper stringIsNilOrEmpty:thumJsonStr]) {
                        ret = [coreSocket launchRequestContent:thumJsonStr FinishBlock:^(NSData *data) {
                            NSString *msg1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            if(msg1) {
                                NSArray *thumMsgArr = [IMBFileHelper dictionaryWithJsonString:msg1];
                                if (thumMsgArr != nil) {
                                    for (NSDictionary *msgDic in thumMsgArr) {
                                        if ([msgDic.allKeys containsObject:@"imageId"]) {
                                            int imageId = [[msgDic objectForKey:@"imageId"] intValue];
                                            BOOL isFind = NO;
                                            for (IMBADAlbumEntity *albumEntity in _reslutEntity.reslutArray) {
                                                for (IMBADPhotoEntity *entity in albumEntity.photoArray) {
                                                    if (imageId == entity.photoId) {
                                                        isFind = YES;
                                                        if ([msgDic.allKeys containsObject:@"size"]) {
                                                            entity.thumbnilSize = [[msgDic objectForKey:@"size"] longLongValue];
                                                        }
                                                        if ([msgDic.allKeys containsObject:@"url"]) {
                                                            entity.thumbnilUrl = [msgDic objectForKey:@"url"];
                                                        }
                                                        if ([msgDic.allKeys containsObject:@"id"]) {
                                                            entity.thumbnilId = [[msgDic objectForKey:@"id"] intValue];
                                                        }
                                                        break;
                                                    }
                                                }
                                                if (isFind) {
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }else {
                                NSLog(@"错误");
                                [_loghandle writeInfoLog:@"Gallery Thumbnail queryDetailContent End"];
                            }
                            [msg1 release];
                        }];
                        if (!ret) {
                            result = -5;
                        }
                    }else {
                        result = -4;
                    }
                }
            }else {
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
    [_loghandle writeInfoLog:@"Gallery queryDetailContent End"];
    return result;
}

- (void)paresPhotoDic:(NSDictionary *)photoDic withAlbumEntity:(IMBADAlbumEntity *)albumEntity {
    IMBADPhotoEntity *photo = [[IMBADPhotoEntity alloc] init];
    if ([photoDic.allKeys containsObject:@"name"]) {
        photo.name = [photoDic objectForKey:@"name"];
//        if ([photo.name hasPrefix:@"download20160210111222"]) {
//            
//        }
        photo.title = [photo.name stringByDeletingPathExtension];
    }
    if ([photoDic.allKeys containsObject:@"size"]) {
        photo.size = [[photoDic objectForKey:@"size"] longLongValue];
    }
    if ([photoDic.allKeys containsObject:@"url"]) {
        photo.url = [photoDic objectForKey:@"url"];
    }
    if ([photoDic.allKeys containsObject:@"id"]) {
        photo.photoId = [[photoDic objectForKey:@"id"] intValue];
    }
    if ([photoDic.allKeys containsObject:@"isDelete"]) {
        photo.isDeleted = [[photoDic objectForKey:@"isDelete"] boolValue];
    }
    if ([photoDic.allKeys containsObject:@"mimetype"]) {
        photo.mimeType = [photoDic objectForKey:@"mimetype"];
    }
    if ([photoDic.allKeys containsObject:@"width"]) {
        photo.width = [[photoDic objectForKey:@"width"] intValue];
    }
    if ([photoDic.allKeys containsObject:@"height"]) {
        photo.height = [[photoDic objectForKey:@"height"] intValue];
    }
    if ([photoDic.allKeys containsObject:@"dateModified"]) {
        long long dateTime = [[photoDic objectForKey:@"dateModified"] longLongValue];
        if (dateTime <= 0) {
            if ([photoDic.allKeys containsObject:@"dateAdded"]) {
                dateTime = [[photoDic objectForKey:@"dateAdded"] longLongValue];
            }
        }
        photo.time = dateTime;
    }
    if ([IMBFileHelper stringIsNilOrEmpty:photo.name]) {
        photo.name = [photo.url lastPathComponent];
        photo.title = [photo.name stringByDeletingPathExtension];
    }
    [albumEntity.photoArray addObject:photo];
    albumEntity.count ++;
    albumEntity.size += photo.size;
    _reslutEntity.reslutCount ++;
    _reslutEntity.selectedCount ++;
    _reslutEntity.reslutSize += photo.size;
    [photo release];
}

- (BOOL)queryThumbnailContent:(IMBADPhotoEntity *)photoEntity {
    [_loghandle writeInfoLog:@"Gallery queryThumbnailContent Begin"];
    __block BOOL result = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSString *thumbnailPath = @"0*#&";
        if (![StringHelper stringIsNilOrEmpty:photoEntity.thumbnilUrl]) {
            thumbnailPath = photoEntity.thumbnilUrl;
        }
        NSString *realPath = @"0*#&";
        if (![StringHelper stringIsNilOrEmpty:photoEntity.url]) {
            realPath = photoEntity.url;
        }
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:thumbnailPath, @"thumbnailImagePath", realPath, @"realImagePath", nil];
        NSString *jsonStr = [self createParamsjJsonCommand:IMAGE Operate:THUMBNAIL ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                if (data) {
                    NSImage *image = [[NSImage alloc] initWithData:data];
                    if (image != nil) {
                        photoEntity.photoImage = image;
                        photoEntity.isLoad = YES;
                        result = YES;
                    }
                    [image release];
                }
            }];
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    
    [_loghandle writeInfoLog:@"Gallery queryThumbnailContent End"];
    return result;
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr {
    [_loghandle writeInfoLog:@"Gallery exportContent Begin"];
    int result = 0;
    if ([IMBFileHelper stringIsNilOrEmpty:_serialNumber]) {
        [_loghandle writeInfoLog:@"Gallery exportContent Error -1"];
        return -1;
    }
    if ([IMBFileHelper stringIsNilOrEmpty:targetPath]) {
        [_loghandle writeInfoLog:@"Gallery exportContent Error -2"];
        return -2;
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_77", nil)];
    }
    _currCount = 0;
    _currSize = 0;
    _totalSize = 0;
    _successCount = 0;
    _failedCount = 0;
    for (IMBADAlbumEntity *albumEntity in exportArr) {
        _totalCount += albumEntity.photoArray.count;
    }
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
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        for (IMBADAlbumEntity *albumEntity in exportArr) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            NSString *exAlbumPath = [targetPath stringByAppendingPathComponent:[albumEntity.albumName stringByReplacingOccurrencesOfString:@"/" withString:@" "]];
            if (![fm fileExistsAtPath:exAlbumPath]) {
                [fm createDirectoryAtPath:exAlbumPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            for (IMBADPhotoEntity *entity in albumEntity.photoArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:entity.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    continue;
                }
                @autoreleasepool {
                    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transDelegate transferFile:entity.name];
                    }
                    _currCount ++;
                    BOOL isSuccess = NO;
                    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:entity.url, @"sourcePath", nil];
                    NSString *jsonStr = [self createParamsjJsonCommand:IMAGE Operate:EXPORT ParamDic:paramDic];
                    if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                        NSString *exFilePath = [exAlbumPath stringByAppendingPathComponent:[entity.name stringByReplacingOccurrencesOfString:@"/" withString:@" "]];
                        if ([fm fileExistsAtPath:exFilePath]) {
                            exFilePath = [IMBFileHelper getFilePathAlias:exFilePath];
                        }
                        isSuccess = [fm createFileAtPath:exFilePath contents:nil attributes:nil];
                        if (entity.size > 0) {
                            if (isSuccess) {
                                @try {
                                    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exFilePath];
                                    isSuccess = [coreSocket launchRequestContent:jsonStr FileSize:entity.size FinishBlock:^(NSData *data) {
                                        _currSize += data.length;
                                        if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                                            float progress = (float)_currSize / _totalSize * 100;
                                            NSLog(@"progress:%f",progress);
                                            if (progress > 99) {
                                                progress = 99;
                                            }
                                            [_transDelegate transferProgress:progress];
                                        }
                                        [handle writeData:data];
                                    }];
                                    [handle closeFile];
                                    if (!isSuccess) {
                                        [[IMBTransferError singleton] addAnErrorWithErrorName:entity.name WithErrorReson:CustomLocalizedString(@"Ex_Op_GetARPhotoDataFail", nil)];
                                        if ([fm fileExistsAtPath:exFilePath]) {
                                            [fm removeItemAtPath:exFilePath error:nil];
                                        }
                                        NSLog(@"launch request failed");
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
        [_loghandle writeInfoLog:@"Gallery exportContent Error -3"];
        result = -3;
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    
    [_loghandle writeInfoLog:@"Gallery exportContent End"];
    return result;
}

- (int)importContent:(NSArray *)importArr {
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_77", nil)];
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
                NSString *jsonStr = [self createParamsjJsonCommand:IMAGE Operate:IMPORT ParamDic:paramDic];
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
                        NSDictionary *paramSycDic = [NSDictionary dictionaryWithObjectsAndKeys:fileName, @"fileName", nil];
                        NSString *jsonSyncStr = [self createParamsjJsonCommand:IMAGE Operate:SYNC ParamDic:paramSycDic];
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
        for (IMBADPhotoEntity *entity in deleteArr) {
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:entity.name];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",entity.photoId], @"imageId", entity.url, @"imageUrl", [NSString stringWithFormat:@"%d",entity.thumbnilId], @"thumbnailId", entity.thumbnilUrl, @"thumbnailUrl", nil];
            NSString *jsonStr = [self createParamsjJsonCommand:IMAGE Operate:DELETE ParamDic:paramDic];
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
    for (IMBADAlbumEntity *albumEntity in array) {
        for (IMBADPhotoEntity *entity in albumEntity.photoArray) {
            _totalSize += entity.size;
        }
    }
}

@end

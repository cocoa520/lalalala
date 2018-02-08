//
//  IMBADDoucment.m
//  PhoneRescue_Android
//
//  Created by iMobie on 4/13/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBADDoucment.h"
#import "IMBHelper.h"
#import "IMBADPhotoEntity.h"
#import "IMBADVideoTrack.h"
#import "IMBADAudioTrack.h"

@implementation IMBADDoucment
@synthesize moviesReslutEntity = _moviesReslutEntity;
@synthesize musicReslutEntity = _musicReslutEntity;
@synthesize photoReslutEntity = _photoReslutEntity;
@synthesize ibookReslutEntity = _ibookReslutEntity;
@synthesize compressedReslutEntity = _compressedReslutEntity;
@synthesize category = _category;
@synthesize isDocument = _isDocument;

- (id)initWithSerialNumber:(NSString *)serialNumber {
    if (self = [super initWithSerialNumber:serialNumber]) {
        _moviesReslutEntity = [[IMBResultEntity alloc] init];
        _musicReslutEntity = [[IMBResultEntity alloc] init];
        _photoReslutEntity = [[IMBResultEntity alloc] init];
        _ibookReslutEntity = [[IMBResultEntity alloc] init];
        _compressedReslutEntity = [[IMBResultEntity alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_moviesReslutEntity release],_moviesReslutEntity = nil;
    [_musicReslutEntity release],_musicReslutEntity = nil;
    [_photoReslutEntity release],_photoReslutEntity = nil;
    [_ibookReslutEntity release],_ibookReslutEntity = nil;
    [_compressedReslutEntity release],_compressedReslutEntity = nil;
    [super dealloc];
}

#pragma mark - Abstract Method
- (int)queryDetailContent {
    [_loghandle writeInfoLog:@"Doucment queryDetailContent Begin"];
    int result = 0;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        NSDictionary *jsonDic = nil;
        if (_category == Category_Photo) {
            jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Files", @"Kind", @"PhotoLibrary", @"Item", nil];
        }else if (_category == Category_Document) {
            jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Files", @"Kind", @"Document", @"Item", nil];
        }else if (_category == Category_Movies) {
            jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Files", @"Kind", @"Movies", @"Item", nil];
        }else if (_category == Category_Music) {
            jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Files", @"Kind", @"Music", @"Item", nil];
        }else if (_category == Category_iBooks) {
            jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Files", @"Kind", @"iBooks", @"Item", nil];
        }else if (_category == Category_Compressed) {
            jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Files", @"Kind", @"Compressed", @"Item", nil];
        }else {
            jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Files", @"Kind", nil];
        }
        NSString *jsonStr = [self createParamsjJsonCommand:DOUCMENT Operate:QUERY ParamDic:jsonDic];
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        [coreSocket setIsSingleQuery:YES];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"doucment msg:%@",msg);
                    NSArray *msgArr = [IMBFileHelper dictionaryWithJsonString:msg];
                    if (msgArr != nil && [msgArr isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *msgDic in msgArr) {
                            if (msgDic != nil && [msgDic isKindOfClass:[NSDictionary class]]) {
                                if ([msgDic.allKeys containsObject:@"filePath"]) {
                                    NSString *filePath = [msgDic objectForKey:@"filePath"];
                                    BOOL isFile = NO;
                                    if ([msgDic.allKeys containsObject:@"isFile"]) {
                                        isFile = [[msgDic objectForKey:@"isFile"] boolValue];
                                    }
                                    NSString *parentName = nil;
                                    if ([msgDic.allKeys containsObject:@"parentName"]) {
                                        parentName = [msgDic objectForKey:@"parentName"];
                                    }
                                    if (isFile) {
                                        NSString *fileName = nil;
                                        if ([msgDic.allKeys containsObject:@"displayName"]) {
                                            fileName = [msgDic objectForKey:@"displayName"];
                                        }
                                        NSString *extension = nil;
                                        if ([msgDic.allKeys containsObject:@"extension"]) {
                                            extension = [msgDic objectForKey:@"extension"];
                                        }
                                        long long fileSize = 0;
                                        if ([msgDic.allKeys containsObject:@"fileSize"]) {
                                            fileSize = [[msgDic objectForKey:@"fileSize"] longLongValue];
                                        }
                                        long long fileTime = 0;
                                        if ([msgDic.allKeys containsObject:@"time"]) {
                                            fileTime = [[msgDic objectForKey:@"time"] longLongValue];
                                        }
//                                        if ([@"wma" isEqualToString:[extension lowercaseString]] && ![parentName isEqualToString:@"Music"]) {
//                                            parentName = @"Music";
//                                        }else if ([@"m4v" isEqualToString:[extension lowercaseString]] && ![parentName isEqualToString:@"Movies"]) {
//                                            parentName = @"Movies";
//                                        }
                                        if ([parentName isEqualToString:@"PhotoLibrary"]) {
                                            if (_category == Category_Photo || _category == Category_Summary) {
                                                if ((fileSize > 10240 && [[extension lowercaseString] isEqualToString:@"jpg"]) || (fileSize > 102400 && [[extension lowercaseString] isEqualToString:@"png"])) {
                                                    IMBADPhotoEntity *photo = [[IMBADPhotoEntity alloc] init];
                                                    photo.name = [fileName stringByAppendingPathExtension:extension];
                                                    photo.title = fileName;
                                                    photo.size = fileSize;
                                                    photo.url = filePath;
                                                    _photoReslutEntity.reslutCount ++;
                                                    _photoReslutEntity.selectedCount ++;
                                                    _photoReslutEntity.reslutSize += photo.size;
                                                    [_photoReslutEntity.reslutArray addObject:photo];
                                                    [photo release];
                                                }
                                            }
                                        }else if ([parentName isEqualToString:@"Document"]) {
                                            if (_category == Category_Document || _category == Category_Summary) {
                                                IMBADFileEntity *file = [[IMBADFileEntity alloc] init];
                                                file.fileName = [fileName stringByAppendingPathExtension:extension];
                                                file.fileExtension = extension;
                                                file.title = fileName;
                                                file.fileSize = fileSize;
                                                file.filePath = filePath;
                                                file.createTime = fileTime;
                                                file.isFile = isFile;
                                                file.sortStr = [StringHelper getSortString:file.title];
                                                _reslutEntity.reslutCount += 1;
                                                _reslutEntity.selectedCount ++;
                                                _reslutEntity.reslutSize += fileSize;
                                                [_reslutEntity.reslutArray addObject:file];
                                                [file release];
                                                file = nil;
                                            }
                                        }else if ([parentName isEqualToString:@"Movies"]) {
                                            if (_category == Category_Movies || _category == Category_Summary) {
                                                if (fileSize > 0) {
                                                    IMBADVideoTrack *track = [[IMBADVideoTrack alloc] init];
                                                    track.title = fileName;
                                                    track.name = [fileName stringByAppendingPathExtension:extension];
                                                    track.url = filePath;
                                                    track.size = fileSize;
                                                    track.album = CustomLocalizedString(@"mediaView_id_4", nil);
                                                    track.singer = CustomLocalizedString(@"mediaView_id_3", nil);
                                                    _moviesReslutEntity.reslutCount ++;
                                                    _moviesReslutEntity.selectedCount ++;
                                                    _moviesReslutEntity.reslutSize += fileSize;
                                                    [_moviesReslutEntity.reslutArray addObject:track];
                                                    [track release];
                                                    track = nil;
                                                }
                                            }
                                        }else if ([parentName isEqualToString:@"Music"]) {
                                            if (_category == Category_Music || _category == Category_Summary) {
                                                if (fileSize > 1048576) {
                                                    IMBADAudioTrack *track = [[IMBADAudioTrack alloc] init];
                                                    track.title = fileName;
                                                    track.name = [fileName stringByAppendingPathExtension:extension];
                                                    track.url = filePath;
                                                    track.size = fileSize;
                                                    track.album = CustomLocalizedString(@"mediaView_id_4", nil);
                                                    track.singer = CustomLocalizedString(@"mediaView_id_3", nil);
                                                    _musicReslutEntity.reslutCount ++;
                                                    _musicReslutEntity.selectedCount ++;
                                                    _musicReslutEntity.reslutSize += fileSize;
                                                    [_musicReslutEntity.reslutArray addObject:track];
                                                    [track release];
                                                    track = nil;
                                                }
                                            }
                                        }else if ([parentName isEqualToString:@"iBooks"]) {
                                            if (_category == Category_iBooks || _category == Category_Summary) {
                                                IMBADFileEntity *file = [[IMBADFileEntity alloc] init];
                                                file.fileName = [fileName stringByAppendingPathExtension:extension];
                                                file.title = fileName;
                                                file.fileSize = fileSize;
                                                file.filePath = filePath;
                                                file.isFile = isFile;
                                                file.createTime = fileTime;
                                                file.fileExtension = extension;
                                                file.sortStr = [StringHelper getSortString:file.title];
                                                _ibookReslutEntity.reslutCount += 1;
                                                _ibookReslutEntity.selectedCount ++;
                                                _ibookReslutEntity.reslutSize += fileSize;
                                                [_ibookReslutEntity.reslutArray addObject:file];
                                                [file release];
                                                file = nil;
                                            }
                                        }else if ([parentName isEqualToString:@"Compressed"]) {
                                            if (_category == Category_Compressed || _category == Category_Summary) {
                                                IMBADFileEntity *file = [[IMBADFileEntity alloc] init];
                                                file.fileName = [fileName stringByAppendingPathExtension:extension];
                                                file.title = fileName;
                                                file.fileSize = fileSize;
                                                file.filePath = filePath;
                                                file.isFile = isFile;
                                                file.createTime = fileTime;
                                                file.fileExtension = extension;
                                                file.sortStr = [StringHelper getSortString:file.title];
                                                _compressedReslutEntity.reslutCount += 1;
                                                _compressedReslutEntity.selectedCount ++;
                                                _compressedReslutEntity.reslutSize += fileSize;
                                                [_compressedReslutEntity.reslutArray addObject:file];
                                                [file release];
                                                file = nil;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Doucment queryDetailContent Error"];
                }
                [msg release];
            }];
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
    }
    [_loghandle writeInfoLog:@"Doucment queryDetailContent End"];
    return result;
}

- (BOOL)queryThumbnailContentWithApp:(IMBADPhotoEntity *)appPhotoEntity {
    __block BOOL result = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSString *thumbnailPath = @"0*#&";
        if (![IMBHelper stringIsNilOrEmpty:appPhotoEntity.thumbnilUrl]) {
            thumbnailPath = appPhotoEntity.thumbnilUrl;
        }
        NSString *realPath = @"0*#&";
        if (![IMBHelper stringIsNilOrEmpty:appPhotoEntity.url]) {
            realPath = appPhotoEntity.url;
        }
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:thumbnailPath, @"thumbnailImagePath", realPath, @"realImagePath", nil];
        NSString *jsonStr = [self createParamsjJsonCommand:IMAGE Operate:THUMBNAIL ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                if (data) {
                    NSImage *image = [[NSImage alloc] initWithData:data];
                    if (image != nil) {
                        appPhotoEntity.photoImage = image;
                        appPhotoEntity.isLoad = YES;
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
    
    return result;
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr {
    [_loghandle writeInfoLog:@"Doucment exportContent Begin"];
    int result = 0;
    if ([IMBFileHelper stringIsNilOrEmpty:_serialNumber]) {
        result = -1;
    }
    if ([IMBFileHelper stringIsNilOrEmpty:targetPath]) {
        result = -2;
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        if (_isDocument) {
            [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"List_Header_id_Document", nil)];
        }else{
            [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_87", nil)];

        }
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
            for (IMBADFileEntity *file in exportArr) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }

                [self exportFromRecursive:file withCoreSocket:coreSocket withTargetPath:targetPath];
            }
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_transDelegate transferProgress:100];
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
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    
    [_loghandle writeInfoLog:@"Doucment exportContent End"];
    return result;
}

- (int)importContent:(NSArray *)importArr {
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"List_Header_id_Document", nil)];
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
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
//        for (NSString *path in importArr) {
//            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
//                [_transDelegate transferFile:[path lastPathComponent]];
//            }
//            _currCount ++;
//            BOOL isSuccess = NO;
//            if ([fm fileExistsAtPath:path]) {
//                NSString *fileName = [fm displayNameAtPath:path];
//                NSDictionary *fileDic = [fm attributesOfItemAtPath:path error:nil];
//                long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
//                NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:fileName, @"fileName", nil];
//                NSString *jsonStr = [self createParamsjJsonCommand:VIDEO Operate:IMPORT ParamDic:paramDic];
//                if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
//                    isSuccess = [coreSocket launchRequestContent:jsonStr FilePath:path FileSize:fileSize FinishBlock:^(NSData *data) {
//                        _currSize += data.length;
//                        if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
//                            float progress = (float)_currSize / _totalSize * 100;
//                            NSLog(@"progress:%f",progress);
//                            [_transDelegate transferProgress:progress];
//                        }
//                    }];
//                    if (isSuccess){
//                        IMBMediaInfo *mediaInfo = [IMBMediaInfo singleton];
//                        [mediaInfo openWithFilePath:path];
//                        int duration = 0;
//                        if ([mediaInfo isGotMetaData]) {
//                            duration = [mediaInfo.length intValue];
//                        }
//                        NSDictionary *paramSycDic = [NSDictionary dictionaryWithObjectsAndKeys:fileName, @"fileName", [NSString stringWithFormat:@"%lld",fileSize], @"videoSize", [NSString stringWithFormat:@"%d",duration], @"videoDuration",  nil];
//                        NSString *jsonSyncStr = [self createParamsjJsonCommand:VIDEO Operate:SYNC ParamDic:paramSycDic];
//                        isSuccess = [coreSocket launchSyncRequestContent:jsonSyncStr FinishBlock:^(NSData *data) {
//                            NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                            NSLog(@"sync msg:%@",msg);
//                            [msg release];
//                        }];
//                        if (!isSuccess) {
//                            result = -5;
//                            NSLog(@"sync launch request failed");
//                        }
//                    }else {
//                        result = -4;
//                        NSLog(@"import launch request failed");
//                    }
//                }else {
//                    result = -1;
//                    NSLog(@"create json failed");
//                }
//                if (isSuccess) {
//                    _successCount ++;
//                }else {
//                    _failedCount ++;
//                }
//            }else {
//                result = -2;
//                _failedCount ++;
//                NSLog(@"file isn't exist");
//            }
//        }
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
//        for (IMBVideoTrack *track in deleteArr) {
//            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
//                [_transDelegate transferFile:track.title];
//            }
//            _currCount ++;
//            BOOL isSuccess = NO;
//            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",track.trackId], @"videoId", track.url, @"videoUrl", nil];
//            NSString *jsonStr = [self createParamsjJsonCommand:VIDEO Operate:DELETE ParamDic:paramDic];
//            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
//                isSuccess = [coreSocket launchDeleteRequestContent:jsonStr FinishBlock:^(NSData *data) {
//                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                    NSLog(@"sync msg:%@",msg);
//                    [msg release];
//                }];
//                if (!isSuccess){
//                    result = -1;
//                    NSLog(@"delete launch request failed");
//                }
//            }else {
//                result = -2;
//                NSLog(@"create json failed");
//            }
//            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
//                float progress = (float)_currCount / _totalCount * 100;
//                NSLog(@"progress:%f",progress);
//                [_transDelegate transferProgress:progress];
//            }
//            if (isSuccess) {
//                _successCount ++;
//            }else {
//                _failedCount ++;
//            }
//        }
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

//递归的方式导出
- (void)exportFromRecursive:(IMBADFileEntity *)file withCoreSocket:(IMBCoreAndriodSocket *)coreSocket withTargetPath:(NSString *)targetPath {
    if (!_isStop) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if (file.isFile) {
            _currCount ++;
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:file.fileName];
            }
            BOOL isSuccess = NO;
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:file.filePath, @"sourcePath", nil];
            NSString *jsonStr = [self createParamsjJsonCommand:DOUCMENT Operate:EXPORT ParamDic:paramDic];
            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                NSString *exFilePath = [targetPath stringByAppendingPathComponent:[file.fileName stringByReplacingOccurrencesOfString:@"/" withString:@" "]];
                if ([fm fileExistsAtPath:exFilePath]) {
                    exFilePath = [IMBFileHelper getFilePathAlias:exFilePath];
                }
                isSuccess = [fm createFileAtPath:exFilePath contents:nil attributes:nil];
                if (file.fileSize > 0) {
                    if (isSuccess) {
                        @try {
                            NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exFilePath];
                            isSuccess = [coreSocket launchRequestContent:jsonStr FileSize:file.fileSize FinishBlock:^(NSData *data) {
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
                                [[IMBTransferError singleton] addAnErrorWithErrorName:file.fileName WithErrorReson:CustomLocalizedString(@"Ex_Op_GetARPhotoDataFail", nil)];
                                NSLog(@"launch request failed");
                                if ([fm fileExistsAtPath:exFilePath]) {
                                    [fm removeItemAtPath:exFilePath error:nil];
                                }
                            }else {
                                [file setLocalPath:exFilePath];
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
        }else {
            NSString *exFilePath = [targetPath stringByAppendingPathComponent:file.fileName];
            if (![fm fileExistsAtPath:exFilePath]) {
                [fm createDirectoryAtPath:exFilePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            for (IMBADFileEntity *entity in file.fileList) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                [self exportFromRecursive:entity withCoreSocket:coreSocket withTargetPath:exFilePath];
            }
        }
    }
}

- (void)sumTotalSize:(NSArray *)array {
    for (IMBADFileEntity *file in array) {
        if (file.isFile) {
            _totalSize += file.fileSize;
        }else {
            [self sumTotalSize:file.fileList];
        }
    }
}

@end

//
//  DownLoader.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/7.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "DownLoader.h"
#import "HTTPApiConst.h"
#import <CommonCrypto/CommonDigest.h>
@implementation DownLoader
@synthesize downloadtask = _downloadtask;
@synthesize activedownloadCount = _activedownloadCount;
@synthesize downloadMaxCount = _downloadMaxCount;
@synthesize downloadPath = _downloadPath;
@synthesize downloadArray = _downloadArray;

- (id)initWithAccessToken:(NSString *)accessToken
{
    if (self = [super init]) {
        _accessToken = [accessToken retain];
        _downloadtask = [[NSMutableDictionary alloc] init];
        _downloadArray = [[NSMutableArray alloc] init];
        _downloadMaxCount = 3;
        _activedownloadCount = 0;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
        NSString *downloadPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        _downloadPath = [downloadPath retain];
        _synchronQueue = dispatch_queue_create([@"synchronDownloadQueue" UTF8String],DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - setter
- (void)setDownloadMaxCount:(NSInteger)downloadMaxCount
{
    dispatch_sync(_synchronQueue, ^{
        _downloadMaxCount = downloadMaxCount;
        [self startNextTaskIfAllow];
    });
}


#pragma mark - downloadActions

- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    [self downloadItem:item completionHandler:nil];
}

- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler{
    if (item.state != TransferStateNormal) {
        NSAssert(1,@"只能下载状态为DownloadStateNormal的值");
        return;
    }
    
    if (![item respondsToSelector:@selector(setUrlString:)]&&![item respondsToSelector:@selector(setItemIDOrPath:)]&&![item respondsToSelector:@selector(setFileName:)]) {
        NSAssert(1,@"未实现setItemIDOrPath:和setFileName方法 或者未实现setUrlString:");
        return;
    }
    //初始化状态
    dispatch_sync(_synchronQueue, ^{
        [self.downloadArray addObject:item];
        [self notifyDownloadItem:item withDownloadState:DownloadStateWait];
        if ([self isActivityLessMax]) {
            [self startDownload:item completionHandler:completionHandler];
        }
    });
}

- (void)startDownload:(_Nonnull id <DownloadAndUploadDelegate>)item completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    if (item.parent != nil) {
        id <DownloadAndUploadDelegate> parentItem = item.parent;
        parentItem.state = DownloadStateLoading;
    }
    [self notifyDownloadItem:item withDownloadState:DownloadStateLoading];
    //查看任务是否已经存在
    NSURLSessionDataTask *existingTask = self.downloadtask[item.identifier];
    if (existingTask) {
        NSAssert(1,@"该任务已经存在，请不要再下载");
        return;
    }
    NSURLSessionDataTask *task = nil;
    //创建一个文件输出流,用于写文件
    NSString *localPath = nil;
    if (item.parentPath == nil) {
        if (item.localPath == nil) {
            localPath = [_downloadPath stringByAppendingPathComponent:item.fileName];
        }else{
            localPath = item.localPath;
        }
    }else{
        if (item.localPath == nil) {
            localPath = [[_downloadPath stringByAppendingString:item.parentPath] stringByAppendingPathComponent:item.fileName];
        }else{
            localPath = item.localPath;
        }
    }
    NSString *temlocalPath = nil;
    if (![localPath containsString:@".atc-downloading"]) {
        temlocalPath = [localPath stringByAppendingString:@".atc-downloading"];
    }else{
        temlocalPath = localPath;
    }
    __block NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:[NSURL fileURLWithPath:temlocalPath] append:YES];
    unsigned long long cacheFileSize = 0;
    cacheFileSize = [self fileSizeForPath:temlocalPath];
    item.currentSize = cacheFileSize;
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:item.urlString]];
    [request setHTTPMethod:item.httpMethod];
    if (item.headerParam != nil) {
        [item.headerParam enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (cacheFileSize) {
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-", cacheFileSize];
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accessToken];
    [request setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    AFHTTPSessionManager *downloadManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    task = [downloadManager dataTaskWithRequest:request completionHandler:nil];
    __block id<DownloadAndUploadDelegate> weakItem = item;
    __block DownLoader *weakself = self;
    __block AFHTTPSessionManager *weakdownloadManager = downloadManager;
    //下载接受数据
    [downloadManager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        //下载文件的总大小
        uint64_t expectedLength = response.expectedContentLength;
        if (expectedLength != NSURLResponseUnknownLength) {
            weakItem.fileSize = response.expectedContentLength + cacheFileSize;
        }else {
//            weakItem.fileSize = cacheFileSize;
        }
        //打开流
        [outputStream open];
        return NSURLSessionResponseAllow;
    }];
    //写入数据
    [downloadManager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data){
        NSInteger result = [outputStream write:data.bytes maxLength:data.length];
        if (result == -1) {
            //错误
            [task cancel];
        } else {
            //正确操作
            long long currentSize = weakItem.currentSize + data.length;
            //设置当前大小
            [weakself notifyDownloadItem:weakItem withDownloadCurrentSize:currentSize];
            //计算进度
            double progress = 1.0*currentSize/weakItem.fileSize*100;
            [weakself notifyDownloadItem:weakItem withDownloadProgress:progress];
            //计算速度
            NSTimeInterval downloadTime = -1 * [weakItem.startTime timeIntervalSinceNow];
            if (downloadTime != 0) {
                NSUInteger speed = data.length / downloadTime;
                [weakself notifyDownloadItem:weakItem withDownloadSpeed:speed];
            }
            weakItem.startTime = [NSDate date];
            //计算剩余时间
            unsigned long long remainingContentLength = weakItem.fileSize - weakItem.currentSize;
            if (weakItem.speed != 0) {
                NSUInteger remainingTime = (NSUInteger)(remainingContentLength / weakItem.speed);
                [weakself notifyDownloadItem:weakItem withDownloadRemainingTime:remainingTime];
            }
            //计算文件夹得相关属性
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate =[NSPredicate predicateWithFormat:@"self.state=%d",DownloadStateLoading];
                NSArray *activeArray = [parentItem.childArray filteredArrayUsingPredicate:cate];
                NSInteger speed = [[activeArray valueForKeyPath:@"@sum.speed"] longValue];
                long long  currentSize = [[parentItem.childArray valueForKeyPath:@"@sum.currentSize"] longLongValue];
                [weakself notifyDownloadItem:parentItem withDownloadProgress:currentSize/(parentItem.fileSize*1.0)*100];
                [weakself notifyDownloadItem:parentItem withDownloadCurrentSize:currentSize];
                [weakself notifyDownloadItem:parentItem withDownloadSpeed:speed];
                unsigned long long remainingContentLength = parentItem.fileSize - parentItem.currentSize;
                if (parentItem.speed != 0) {
                    NSUInteger remainingTime = (NSUInteger)(remainingContentLength / parentItem.speed);
                    [weakself notifyDownloadItem:parentItem withDownloadRemainingTime:remainingTime];
                }
            }
        }
    }];
    //下载完成
    [downloadManager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        dispatch_sync(_synchronQueue, ^{
            [outputStream close];
            outputStream = nil;
            [weakself removeDownloadTaskForItem:weakItem];
            [weakself startNextTaskIfAllow];
            if (error) {
                NSLog(@"错误信息:%@",error);
                [weakself handleError:error forItem:weakItem];
            }else{
                NSString *newlocalPath = localPath;
                if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
                   newlocalPath = [self getFilePathAlias:localPath];
                }
                //重命名
                [[NSFileManager defaultManager] moveItemAtPath:temlocalPath toPath:newlocalPath error:nil];
                [weakItem setFileName:[[newlocalPath componentsSeparatedByString:@"/"] lastObject]];
                weakItem.localPath = [_downloadPath stringByAppendingPathComponent:weakItem.fileName];
                [weakself notifyDownloadItem:weakItem withDownloadState:DownloadStateComplete];
                [weakself.downloadArray removeObject:weakItem];
            }
            if (weakItem.parent != nil) {
                //如果是文件夹
                id <DownloadAndUploadDelegate> parentItem = item.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",DownloadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",DownloadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    parentItem.localPath = [_downloadPath stringByAppendingPathComponent:parentItem.fileName];
                    parentItem.state = DownloadStateComplete;
                }
            }
            if (completionHandler != nil) {
                completionHandler(nil,error);
            }
            [weakdownloadManager release];

        });
    }];
    [request release];
    item.startTime = [NSDate date];
    [self addDownloadTask:task forItem:item];
}

- (NSInteger)fileSizeForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

- (void)downloadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items
{
    for (id <DownloadAndUploadDelegate> item in items) {
        [self downloadItem:item];
    }
}

- (void)pauseDownloadItem:(_Nonnull id <DownloadAndUploadDelegate>)item
{
    dispatch_sync(_synchronQueue, ^{
        if (item.state == DownloadStateWait || item.state == DownloadStateLoading) {
            if (item.state == DownloadStateLoading) {
                NSURLSessionDataTask *task = [self downloadTaskForItem:item];
                [task cancel];
            }
            //速度清0
            item.speed = 0;
            [self notifyDownloadItem:item withDownloadState:DownloadStatePaused];
            if (item.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = item.parent;
                parentItem.state = DownloadStatePaused;
            }
        }
    });
}

- (void)pauseAllDownloadItems
{
    for (id <DownloadAndUploadDelegate> item in self.downloadArray) {
        [self pauseDownloadItem:item];
    }
}

- (void)resumeDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    dispatch_sync(_synchronQueue, ^{
        if (item.state == DownloadStatePaused || item.state == DownloadStateError) {
            if ([self isActivityLessMax]) {
                [self startDownload:item completionHandler:nil];
            }else{
                [self notifyDownloadItem:item withDownloadState:DownloadStateWait];
            }
        }
    });
}

- (void)resumeAllDownloadItems
{
    for (id <DownloadAndUploadDelegate> item in self.downloadArray) {
        [self resumeDownloadItem:item];
    }
}

- (NSData *)resumeDataForItem:(_Nonnull id <DownloadAndUploadDelegate>)item
{
    NSString *filePath = [self resumePathForItem:item];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSData dataWithContentsOfFile:filePath];
    }else{
        return nil;
    }
}

- (NSString *)resumePathForItem:(_Nonnull id <DownloadAndUploadDelegate>)item
{
    NSString *tempFileName = [[self pathForDownloadString:item.identifier] stringByAppendingPathExtension:@"download"];
    NSString *filePath = [_downloadPath stringByAppendingPathComponent:tempFileName];
    return filePath;
}

- (NSString *)pathForDownloadString:(NSString *)urlString {
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return [output copy];
}

- (void)startNextTaskIfAllow
{
    for (id <DownloadAndUploadDelegate>item in self.downloadArray ) {
        if ([self isActivityLessMax]) {
            if (item.state == DownloadStateWait) {
                [self startDownload:item completionHandler:nil];
            }
        }else{
            break;
        }
    }
}

- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    dispatch_sync(_synchronQueue, ^{
        if (item.state == DownloadStateLoading || item.state == DownloadStateWait) {
            NSURLSessionDataTask *task = [self downloadTaskForItem:item];
            [task cancel];
        }
        [self notifyDownloadItem:item withDownloadState:TransferStateNormal];
        [self notifyDownloadItem:item withDownloadProgress:0];
        [_downloadArray removeObject:item];
    });
}

- (void)cancelAllDownloadItems
{
    for (id <DownloadAndUploadDelegate>item in self.downloadArray ) {
        [self cancelDownloadItem:item];
    }
}

- (void)handleError:(NSError *)error forItem:(id <DownloadAndUploadDelegate>)item
{
    BOOL handleError = NO;
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorCancelled:
                handleError = YES;
                break;
            default:
                break;
        }
    }else if ([error.domain isEqualToString:NSPOSIXErrorDomain]){
        switch (error.code) {
            case 28:
                //空间不足
                [self pauseAllDownloadItems];
                break;
            default:
                break;
        }
    }
    if (!handleError) {
        if (self.autoCancelFailedItem) {
            
        }else{
            //看是否有临时文件，保存临时文件
            NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
            if (resumeData) {
                [resumeData writeToFile:[self resumePathForItem:item] atomically:YES];
            }
            [self notifyDownloadItem:item withDownloadState:DownloadStateError];
            [self notifyDownloadItem:item withDownloadError:error];
        }
    }
}
#pragma mark - _downloadtask有关方法

- (void)addDownloadTask:(NSURLSessionDataTask *)dowloadTask forItem:(id <DownloadAndUploadDelegate>)item
{
    self.downloadtask[item.identifier] = dowloadTask;
    [dowloadTask resume];
    _activedownloadCount++;
}

- (NSURLSessionDataTask *)downloadTaskForItem:(id<DownloadAndUploadDelegate>)item
{
    return self.downloadtask[item.identifier];
}

- (void)removeDownloadTaskForItem:(id<DownloadAndUploadDelegate>)item
{
    [self.downloadtask removeObjectForKey:item.identifier];
    _activedownloadCount--;
}

#pragma mark - 设置downloaditem的属性值

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadState:(TransferState)downloadState
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setState:)]) {
            item.state = downloadState;
        }else{
            NSAssert(1,@"item未实现setDownloadState:");
        }
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setState:)]) {
                item.state = downloadState;
            }else{
                NSAssert(1,@"item未实现setDownloadState:");
            }
        });
    }
}

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadProgress:(double)downloadProgress
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setProgress:)]) {
            item.progress = downloadProgress;
        }else{
            NSAssert(1,@"item未实现setDownloadProgress:");
        }
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setProgress:)]) {
                item.progress = downloadProgress;
            }else{
                NSAssert(1,@"item未实现setDownloadProgress:");
            }
        });
    }
}

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadCurrentSize:(long long)downcurrentSize
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setCurrentSize:)]) {
            item.currentSize = downcurrentSize;
            if (item.parent == nil){
                item.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[self getFileSizeString:downcurrentSize reserved:2],[self getFileSizeString:item.fileSize reserved:2]];
                item.currentProgressStr = [NSString stringWithFormat:CustomLocalizedString(@"transfer_progrss", nil),(int)(downcurrentSize * 100.0/ item.fileSize)];
            }else{
                NSString *downCurrentSize = [self getFileSizeString:item.parent.currentSize reserved:2];
                NSString *fileSize = [self getFileSizeString:item.parent.fileSize reserved:2];
                item.currentSize = downcurrentSize;
                NSString *currenSize = [NSString stringWithFormat:@"%@/%@",downCurrentSize,fileSize];
                item.parent.currentSizeStr = currenSize;
                item.parent.currentProgressStr = [NSString stringWithFormat: CustomLocalizedString(@"transfer_progrss", nil),(int)(downcurrentSize * 100.0/ item.parent.fileSize)];
            }
            
        }else{
            NSAssert(1,@"item未实现setCurrentSize:");
        }
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setCurrentSize:)]) {
                item.currentSize = downcurrentSize;
                if (item.parent == nil){
                    item.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[self getFileSizeString:downcurrentSize reserved:2],[self getFileSizeString:item.fileSize reserved:2]];
                    item.currentProgressStr = [NSString stringWithFormat:CustomLocalizedString(@"transfer_progrss", nil),(int)(downcurrentSize * 100.0/ item.fileSize)];
                }else{
                    NSString *downCurrentSize = [self getFileSizeString:item.parent.currentSize reserved:2];
                    NSString *fileSize = [self getFileSizeString:item.parent.fileSize reserved:2];
                    item.currentSize = downcurrentSize;
                    NSString *currenSize = [NSString stringWithFormat:@"%@/%@",downCurrentSize,fileSize];
                    //                NSLog(@"downCurrentSize:%@ fileSize:%@",downCurrentSize,fileSize);
                    item.parent.currentSizeStr = currenSize;
                    item.parent.currentProgressStr = [NSString stringWithFormat:CustomLocalizedString(@"transfer_progrss", nil),(int)(downcurrentSize * 100.0/ item.parent.fileSize)];
                }
                
            }else{
                NSAssert(1,@"item未实现setCurrentSize:");
            }
        });
    }
}

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadError:(NSError *)error
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setError:)]) {
            item.error = error;
        }else{
            NSAssert(1,@"item未实现setDowndloadError:");
        }
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setError:)]) {
                item.error = error;
            }else{
                NSAssert(1,@"item未实现setDowndloadError:");
            }
        });
    }
}

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadSpeed:(NSInteger)downloadSpeed
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setSpeed:)]) {
            item.speed = downloadSpeed;
        }else{
            NSAssert(1,@"item未实现setDownloadSpeed:");
        }
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setSpeed:)]) {
                item.speed = downloadSpeed;
            }else{
                NSAssert(1,@"item未实现setDownloadSpeed:");
            }
        });
    }
}

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadRemainingTime:(NSInteger)remainingTime
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setRemainingTime:)]) {
            item.remainingTime = remainingTime;
        }else{
            NSAssert(1,@"item未实现setRemainingTime:");
        }
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setRemainingTime:)]) {
                item.remainingTime = remainingTime;
            }else{
                NSAssert(1,@"item未实现setRemainingTime:");
            }
        });
    }
}

- (BOOL)isActivityLessMax
{
    return self.activedownloadCount <= self.downloadMaxCount;
}

- (NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints {
    double mbSize = (double)totalSize / 1048576;
    double kbSize = (double)totalSize / 1024;
    if (totalSize < 1024) {
        return [NSString stringWithFormat:@" %.0f%@", (double)totalSize,@"B"];
    } else {
        if (mbSize > 1024) {
            double gbSize = (double)totalSize / 1073741824;
            return [self Rounding:gbSize reserved:decimalPoints capacityUnit:@"GB"];
        } else if (kbSize > 1024) {
            return [self Rounding:mbSize reserved:decimalPoints capacityUnit:@"MB"];
        } else {
            return [self Rounding:kbSize reserved:decimalPoints capacityUnit:@"KB"];
        }
    }
}

- (NSString*)Rounding:(double)numberSize reserved:(int)decimalPoints capacityUnit:(NSString*)unit {
    switch (decimalPoints) {
        case 1:
            return [NSString stringWithFormat:@"%.1f %@", numberSize, unit];
            break;
            
        case 2:
            return [NSString stringWithFormat:@"%.2f %@", numberSize, unit];
            break;
            
        case 3:
            return [NSString stringWithFormat:@"%.3f %@", numberSize, unit];
            break;
            
        case 4:
            return [NSString stringWithFormat:@"%.4f %@", numberSize, unit];
            break;
            
        default:
            return [NSString stringWithFormat:@"%.2f %@", numberSize, unit];
            break;
    }
}

- (NSString*)getFilePathAlias:(NSString*)filePath {
    NSString *newPath = filePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    int i = 1;
    NSString *filePathWithOutExt = [filePath stringByDeletingPathExtension];
    NSString *fileExtension = [filePath pathExtension];
    while ([fm fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@(%d).%@",filePathWithOutExt,i++,fileExtension];
    }
    return newPath;
}

- (void)dealloc
{
    [_downloadtask release],_downloadtask = nil;
    [_downloadPath release],_downloadPath = nil;
    [_downloadArray release],_downloadArray = nil;
    [super dealloc];
}
@end

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
        _downloadPath = [@"/Users/luolei/Desktop/pp1" retain];
        _synchronQueue = dispatch_queue_create([@"synchronDownloadQueue" UTF8String],DISPATCH_QUEUE_SERIAL);
        _downloadManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accessToken];
        [_downloadManager.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
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
    NSURLSessionDownloadTask *task = nil;
    NSData *data = [self resumeDataForItem:item];
    if (item.parent != nil) {
        NSString *localParentPath = [_downloadPath stringByAppendingString:item.parentPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:localParentPath]) {
            //创建文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:localParentPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    if (data) {
        __block id<DownloadAndUploadDelegate> weakItem = item;
        __block DownLoader *weakself = self;
        task = [_downloadManager downloadTaskWithResumeData:data progress:^(NSProgress * _Nonnull downloadProgress) {
            [weakself notifyDownloadItem:weakItem withDownloadProgress:downloadProgress.fractionCompleted*100];
            weakItem.currentSize = downloadProgress.completedUnitCount;
            //计算速度
            NSDictionary *progressInfo = downloadProgress.userInfo;
            NSNumber *startTimeValue = progressInfo[ProgressUserInfoStartTimeKey];
            NSNumber *startOffsetValue = progressInfo[ProgressUserInfoOffsetKey];
            if (startTimeValue) {
                CFAbsoluteTime starttime = [startTimeValue doubleValue];
                int64_t startOffset = [startOffsetValue longLongValue];
                NSInteger downloadSpeed = (NSInteger)((downloadProgress.completedUnitCount - startOffset)/(CFAbsoluteTimeGetCurrent() - starttime));
                [weakself notifyDownloadItem:weakItem withDownloadSpeed:downloadSpeed];
            }else{
                [downloadProgress setUserInfoObject:@(CFAbsoluteTimeGetCurrent()) forKey:ProgressUserInfoStartTimeKey];
                [downloadProgress setUserInfoObject:@(downloadProgress.completedUnitCount) forKey:ProgressUserInfoOffsetKey];
            }
            @synchronized (weakself) {
                //计算目录的速度和进度
                if (weakItem.parent != nil) {
                    id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                    NSPredicate *cate =[NSPredicate predicateWithFormat:@"self.state=%d",DownloadStateLoading];
                    NSArray *activeArray = [parentItem.childArray filteredArrayUsingPredicate:cate];
                    NSInteger speed = [[activeArray valueForKeyPath:@"@sum.speed"] longValue];
                    parentItem.speed = speed;
                    long long  currentSize = [[parentItem.childArray valueForKeyPath:@"@sum.currentSize"] longLongValue];
                    parentItem.progress = currentSize/(parentItem.fileSize*1.0)*100;
                }
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (weakItem.parentPath == nil) {
                return [NSURL fileURLWithPath:[_downloadPath stringByAppendingPathComponent:weakItem.fileName]];
            }else{
                NSString *localParentPath = [_downloadPath stringByAppendingString:weakItem.parentPath];
                return [NSURL fileURLWithPath:[localParentPath stringByAppendingPathComponent:weakItem.fileName]];
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            dispatch_sync(_synchronQueue, ^{
                [weakself removeDownloadTaskForItem:weakItem];
                [weakself startNextTaskIfAllow];
                if (error) {
                    [weakself handleError:error forItem:weakItem];
                }else{
                    weakItem.localPath = [_downloadPath stringByAppendingPathComponent:weakItem.fileName];
                    [weakself notifyDownloadItem:weakItem withDownloadState:DownloadStateComplete];
                    [weakself.downloadArray removeObject:weakItem];
                }
                if (weakItem.parent == nil) {
                    //如果是文件直接回调
                    if (completionHandler != nil) {
                        completionHandler(filePath,error);
                    }
                }else{
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
            });
        }];
    }else{
        NSMutableURLRequest *request = [_downloadManager.requestSerializer requestWithMethod:item.httpMethod URLString:item.urlString parameters:nil error:nil];
        if (item.headerParam != nil) {
            [item.headerParam enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [request setValue:obj forHTTPHeaderField:key];
            }];
        }
        __block id<DownloadAndUploadDelegate> weakItem = item;
        __block DownLoader *weakself = self;
        task = [_downloadManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            [weakself notifyDownloadItem:weakItem withDownloadProgress:downloadProgress.fractionCompleted*100];
            weakItem.currentSize = downloadProgress.completedUnitCount;
            NSLog(@"当前大小:%lld,总大小:%lld",weakItem.currentSize,downloadProgress.totalUnitCount);
            //计算速度
            NSDictionary *progressInfo = downloadProgress.userInfo;
            NSNumber *startTimeValue = progressInfo[ProgressUserInfoStartTimeKey];
            NSNumber *startOffsetValue = progressInfo[ProgressUserInfoOffsetKey];
            if (startTimeValue) {
                CFAbsoluteTime starttime = [startTimeValue doubleValue];
                int64_t startOffset = [startOffsetValue longLongValue];
                NSInteger downloadSpeed = (NSInteger)((downloadProgress.completedUnitCount - startOffset)/(CFAbsoluteTimeGetCurrent() - starttime));
                [weakself notifyDownloadItem:weakItem withDownloadSpeed:downloadSpeed];
            }else{
                [downloadProgress setUserInfoObject:@(CFAbsoluteTimeGetCurrent()) forKey:ProgressUserInfoStartTimeKey];
                [downloadProgress setUserInfoObject:@(downloadProgress.completedUnitCount) forKey:ProgressUserInfoOffsetKey];
            }
            @synchronized (weakself) {
                //计算目录的速度和进度
                if (weakItem.parent != nil) {
                    id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                    NSPredicate *cate =[NSPredicate predicateWithFormat:@"self.state=%d",DownloadStateLoading];
                    NSArray *activeArray = [parentItem.childArray filteredArrayUsingPredicate:cate];
                    NSInteger speed = [[activeArray valueForKeyPath:@"@sum.speed"] longValue];
                    parentItem.speed = speed;
                    long long  currentSize = [[parentItem.childArray valueForKeyPath:@"@sum.currentSize"] longLongValue];
                    parentItem.progress = currentSize/(parentItem.fileSize*1.0)*100;
                }
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            if (weakItem.parentPath == nil) {
                return [NSURL fileURLWithPath:[_downloadPath stringByAppendingPathComponent:weakItem.fileName]];
            }else{
                NSString *localParentPath = [_downloadPath stringByAppendingString:weakItem.parentPath];
                return [NSURL fileURLWithPath:[localParentPath stringByAppendingPathComponent:weakItem.fileName]];
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            dispatch_sync(_synchronQueue, ^{
                //to do 发生错误
                [weakself removeDownloadTaskForItem:weakItem];
                [weakself startNextTaskIfAllow];
                if (error) {
                    [weakself handleError:error forItem:weakItem];
                }else{
                    weakItem.localPath = [_downloadPath stringByAppendingPathComponent:weakItem.fileName];
                    [weakself notifyDownloadItem:weakItem withDownloadState:DownloadStateComplete];
                    [weakself.downloadArray removeObject:weakItem];
                }
                if (weakItem.parent == nil) {
                    //如果是文件直接回调
                    if (completionHandler != nil) {
                        completionHandler(filePath,error);
                    }
                }else{
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
            });
        }];
    }
    [self addDownloadTask:task forItem:item];
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
                NSURLSessionDownloadTask *task = [self downloadTaskForItem:item];
                __block DownLoader *weakSelf = self;
                [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    NSString *filePath = [weakSelf resumePathForItem:item];
                    [resumeData writeToFile:filePath atomically:YES];
                }];
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
        if (item.state == DownloadStateLoading) {
            NSURLSessionDownloadTask *task = [self downloadTaskForItem:item];
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            }];
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

- (void)addDownloadTask:(NSURLSessionDownloadTask *)dowloadTask forItem:(id <DownloadAndUploadDelegate>)item
{
    self.downloadtask[item.identifier] = dowloadTask;
    [dowloadTask resume];
    _activedownloadCount++;
}

- (NSURLSessionDownloadTask *)downloadTaskForItem:(id<DownloadAndUploadDelegate>)item
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
    if ([item respondsToSelector:@selector(setState:)]) {
        item.state = downloadState;
    }else{
        NSAssert(1,@"item未实现setDownloadState:");
    }
}

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadProgress:(double)downloadProgress
{
    if ([item respondsToSelector:@selector(setProgress:)]) {
        item.progress = downloadProgress;
    }else{
        NSAssert(1,@"item未实现setDownloadProgress:");
    }
}

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadError:(NSError *)error
{
    if ([item respondsToSelector:@selector(setError:)]) {
        item.error = error;
    }else{
        NSAssert(1,@"item未实现setDowndloadError:");
    }
}

- (void)notifyDownloadItem:(id<DownloadAndUploadDelegate>)item withDownloadSpeed:(NSInteger)downloadSpeed
{
    if ([item respondsToSelector:@selector(setSpeed:)]) {
        item.speed = downloadSpeed;
    }else{
        NSAssert(1,@"item未实现setDownloadSpeed:");
    }
}

- (BOOL)isActivityLessMax
{
    return self.activedownloadCount <= self.downloadMaxCount;
}

- (void)dealloc
{
    [_downloadManager release],_downloadManager = nil;
    [_downloadtask release],_downloadtask = nil;
    [_downloadPath release],_downloadPath = nil;
    [_downloadArray release],_downloadArray = nil;
    [super dealloc];
}

@end

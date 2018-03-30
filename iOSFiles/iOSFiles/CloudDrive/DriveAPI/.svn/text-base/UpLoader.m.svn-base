//
//  UpLoader.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/7.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "UpLoader.h"
#import "HTTPApiConst.h"

@implementation UpLoader
@synthesize uploadListArray = _uploadListArray;
@synthesize uploadTaskListDict = _uploadTaskListDict;

- (id)initWithAccessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _accessToken = [accessToken retain];
        _uploadListArray = [[NSMutableArray alloc] init];
        _uploadTaskListDict = [[NSMutableDictionary alloc] init];
        _uploadMaxCount = 4;
        _activeUploadCount = 0;
        return self;
    }else {
        return nil;
    }
}

- (void)uploadmutilPartItem:(id<DownloadAndUploadDelegate>)item  success:(nullable YTKRequestCompletionBlock)success
{
    __block id<DownloadAndUploadDelegate> weakItem = item;
    __block UpLoader *weakself = self;
    [weakself notifyUploadItem:item withUploadState:UploadStateLoading];
    if ([item isConstructingData]) {
        [[item requestAPI] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (success != nil) {
                success(request);
            }
        } constructingData:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:[item localPath]] name:@"files" error:nil];
        } uploadProgress:^(NSProgress * _Nonnull progress) {
            [weakself notifyUploadItem:weakItem withUploadProgress:progress.fractionCompleted*100];
            [weakself notifyUploadItem:weakItem withUploadcurrentSize:progress.completedUnitCount];
            //计算速度
            NSDictionary *progressInfo = progress.userInfo;
            NSNumber *startTimeValue = progressInfo[ProgressUserInfoStartTimeKey];
            NSNumber *startOffsetValue = progressInfo[ProgressUserInfoOffsetKey];
            if (startTimeValue) {
                CFAbsoluteTime starttime = [startTimeValue doubleValue];
                int64_t startOffset = [startOffsetValue longLongValue];
                NSInteger downloadSpeed = (NSInteger)((progress.completedUnitCount - startOffset)/(CFAbsoluteTimeGetCurrent() - starttime));
                [weakself notifyUploadItem:weakItem withUploadSpeed:downloadSpeed];
            }else{
                [progress setUserInfoObject:@(CFAbsoluteTimeGetCurrent()) forKey:ProgressUserInfoStartTimeKey];
                [progress setUserInfoObject:@(progress.completedUnitCount) forKey:ProgressUserInfoOffsetKey];
            }
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateLoading];
                NSArray *activeArray = [parentItem.childArray filteredArrayUsingPredicate:cate];
                NSInteger speed = [[activeArray valueForKeyPath:@"@sum.speed"] longValue];
                parentItem.speed = speed;
                long long  currentSize = [[parentItem.childArray valueForKeyPath:@"@sum.currentSize"] longLongValue];
                parentItem.progress = currentSize/(parentItem.fileSize*1.0)*100;
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [weakself notifyUploadItem:item withUploadState:UploadStateError];
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    parentItem.state = UploadStateComplete;
                }
            }
            if ([request responseString]) {
                NSLog(@"Request Exception: %@", request.responseString);
            }else {
                NSLog(@"Request Exception: %@", request.error.localizedDescription);
            }
        }];
    }
}

#pragma mark -- 上传单个文件
- (void)uploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    
    __block id<DownloadAndUploadDelegate> weakItem = item;
    __block UpLoader *weakself = self;
    [weakself notifyUploadItem:item withUploadState:UploadStateLoading];
    if ([item isConstructingData]) {
        __block NSThread *currentthread = [NSThread currentThread];
        [[item requestAPI] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([item isBigFile]) {
                [item setIsBigFile:NO];
                [weakself performSelector:@selector(uploadWait) onThread:currentthread withObject:nil waitUntilDone:NO];
            }
            [weakself notifyUploadItem:item withUploadState:UploadStateComplete];
            //如果是文件夹
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    parentItem.state = UploadStateComplete;
                }
            }
            NSLog(@"Request Complete");
        } constructingData:^(id<AFMultipartFormData>  _Nonnull formData) {
            if ([[item constructingDataDriveName] isEqualToString:BoxCSEndPointURL]) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[item localPath]] name:@"file" error:nil];
                NSDictionary *dict = @{@"name": [item fileName], @"parent": @{@"id": [item uploadParent]}};
                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                [formData appendPartWithFormData:data name:@"attributes"];
            }
        } uploadProgress:^(NSProgress * _Nonnull progress) {
            [weakself notifyUploadItem:weakItem withUploadProgress:progress.fractionCompleted*100];
            [weakself notifyUploadItem:weakItem withUploadcurrentSize:progress.completedUnitCount];
            //计算速度
            NSDictionary *progressInfo = progress.userInfo;
            NSNumber *startTimeValue = progressInfo[ProgressUserInfoStartTimeKey];
            NSNumber *startOffsetValue = progressInfo[ProgressUserInfoOffsetKey];
            if (startTimeValue) {
                CFAbsoluteTime starttime = [startTimeValue doubleValue];
                int64_t startOffset = [startOffsetValue longLongValue];
                NSInteger downloadSpeed = (NSInteger)((progress.completedUnitCount - startOffset)/(CFAbsoluteTimeGetCurrent() - starttime));
                [weakself notifyUploadItem:weakItem withUploadSpeed:downloadSpeed];
            }else{
                [progress setUserInfoObject:@(CFAbsoluteTimeGetCurrent()) forKey:ProgressUserInfoStartTimeKey];
                [progress setUserInfoObject:@(progress.completedUnitCount) forKey:ProgressUserInfoOffsetKey];
            }
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateLoading];
                NSArray *activeArray = [parentItem.childArray filteredArrayUsingPredicate:cate];
                NSInteger speed = [[activeArray valueForKeyPath:@"@sum.speed"] longValue];
                parentItem.speed = speed;
                long long  currentSize = [[parentItem.childArray valueForKeyPath:@"@sum.currentSize"] longLongValue];
                [weakself notifyUploadItem:parentItem withUploadProgress:currentSize/(parentItem.fileSize*1.0)*100];
                
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([item isBigFile]) {
                [item setIsBigFile:NO];
                [weakself performSelector:@selector(uploadWait) onThread:currentthread withObject:nil waitUntilDone:NO];
            }
            [weakself notifyUploadItem:item withUploadState:UploadStateError];
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    parentItem.state = UploadStateComplete;
                }
            }
        }];
    }else {
        __block NSThread *currentthread = [NSThread currentThread];
        [[item requestAPI] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [weakself notifyUploadItem:item withUploadState:UploadStateComplete];
            
            //如果是文件夹
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    parentItem.state = UploadStateComplete;
                }
            }
            NSLog(@" Request Complete");
            if ([item isBigFile]) {
                weakItem.currentTotalSize += 10485760;
                [item setIsBigFile:NO];
                [weakself performSelector:@selector(uploadWait) onThread:currentthread withObject:nil waitUntilDone:NO];
            }
        } uploadProgress:^(NSProgress * _Nonnull progress) {
            weakItem.currentSize = weakItem.currentTotalSize + progress.completedUnitCount;
            double fractionCompleted = (double)weakItem.currentSize / weakItem.fileSize;
            [weakself notifyUploadItem:weakItem withUploadProgress:fractionCompleted*100];
            
            //计算速度
            NSDictionary *progressInfo = progress.userInfo;
            NSNumber *startTimeValue = progressInfo[ProgressUserInfoStartTimeKey];
            NSNumber *startOffsetValue = progressInfo[ProgressUserInfoOffsetKey];
            if (startTimeValue) {
                CFAbsoluteTime starttime = [startTimeValue doubleValue];
                int64_t startOffset = [startOffsetValue longLongValue];
                NSInteger downloadSpeed = (NSInteger)((progress.completedUnitCount - startOffset)/(CFAbsoluteTimeGetCurrent() - starttime));
                [weakself notifyUploadItem:weakItem withUploadSpeed:downloadSpeed];
            }else{
                [progress setUserInfoObject:@(CFAbsoluteTimeGetCurrent()) forKey:ProgressUserInfoStartTimeKey];
                [progress setUserInfoObject:@(progress.completedUnitCount) forKey:ProgressUserInfoOffsetKey];
            }
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateLoading];
                NSArray *activeArray = [parentItem.childArray filteredArrayUsingPredicate:cate];
                NSInteger speed = [[activeArray valueForKeyPath:@"@sum.speed"] longValue];
                parentItem.speed = speed;
                long long  currentSize = [[parentItem.childArray valueForKeyPath:@"@sum.currentSize"] longLongValue];
                [weakself notifyUploadItem:parentItem withUploadProgress:currentSize/(parentItem.fileSize*1.0)*100];
                [weakself notifyUploadItem:parentItem withUploadcurrentSize:currentSize];
            }else{
                [weakself notifyUploadItem:weakItem withUploadcurrentSize:weakItem.currentSize];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([item isBigFile]) {
                weakItem.currentTotalSize += 10485760;
                [item setIsBigFile:NO];
                [weakself performSelector:@selector(uploadWait) onThread:currentthread withObject:nil waitUntilDone:NO];
            }
            if ([[request error] code] != 3840) {
                [weakself notifyUploadItem:item withUploadState:UploadStateError];
            }
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    parentItem.state = UploadStateComplete;
                }
            }
        }];
    }
}

#pragma mark -- 上传多个文件
- (void)uploadItems:(NSArray <id<DownloadAndUploadDelegate>> * _Nonnull)items {
    for (id<DownloadAndUploadDelegate> item in items) {
        [self uploadItem:item];
    }
}

#pragma mark -- 暂停上传
- (void)pauseUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    if ([item state] == UploadStateLoading || [item state] == UploadStateWait) {
        if ([item state] == UploadStateLoading) {
            [[item requestAPI] stop];
        }
        [self notifyUploadItem:item withUploadState:UploadStatePaused];
    }
}

#pragma mark -- 暂停所有上传
- (void)pauseAllDownloadItems {
    for (id<DownloadAndUploadDelegate> item in self.uploadListArray) {
        [self pauseUploadItem:item];
    }
}

#pragma mark -- 恢复上传
- (void)resumeUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    
}

#pragma mark -- 恢复所有上传
- (void)resumeAllUploadItems {
    
}

#pragma mark -- 取消上传
- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    if ([item state] == UploadStateLoading || [item state] == UploadStateWait) {
        if ([item state] == UploadStateLoading) {
            [[item requestAPI] cancel];
        }
        [self notifyUploadItem:item withUploadState:UploadStateComplete];
    }
}

#pragma mark -- 取消所有上传
- (void)cancelAllUploadItems {
    for (id<DownloadAndUploadDelegate> item in self.uploadListArray) {
        [self pauseUploadItem:item];
    }
}

#pragma mark -- 监听上传状态属性值
- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadState:(TransferState)uploadState {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([item respondsToSelector:@selector(setState:)]) {
            [item setState:uploadState];
        }else{
            NSAssert(1,@"item未实现setUploadState:");
        }
    });
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadProgress:(double)uploadProgress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([item respondsToSelector:@selector(setProgress:)]) {
            [item setProgress:uploadProgress];
        }else{
            NSAssert(1,@"item未实现setUploadProgress:");
        }
    });
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadSpeed:(NSInteger)uploadSpeed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([item respondsToSelector:@selector(setSpeed:)]) {
            [item setSpeed:uploadSpeed];
        }else{
            NSAssert(1,@"item未实现setUploadSpeed:");
        }
    });
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadcurrentSize:(long long)currentSize
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([item respondsToSelector:@selector(setCurrentSize:)]) {
            [item setCurrentSize:currentSize];
            if (!item.parent) {
                  [item setCurrentSizeStr:[self getFileSizeString:currentSize reserved:2]];
            }
        }else{
            NSAssert(1,@"item未实现setCurrentSize:");
        }
    });
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([item respondsToSelector:@selector(setError:)]) {
            [item setError:error];
        }else{
            NSAssert(1,@"item未实现setUploadError:");
        }
    });
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



-(NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType)
    ;
}

- (void)uploadWait{}

@end

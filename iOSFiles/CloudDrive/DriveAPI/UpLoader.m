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
@synthesize uploadTaskListDict = _uploadTaskListDict;
@synthesize uploadListArray = _uploadListArray;
- (id)initWithAccessToken:(NSString *)accessToken {
    if (self = [super init]) {
        _accessToken = [accessToken retain];
        _uploadTaskListDict = [[NSMutableDictionary alloc] init];
        _uploadListArray = [[NSMutableArray alloc] init];
        return self;
    }else {
        return nil;
    }
}

- (void)dealloc
{
    [_uploadTaskListDict release],_uploadTaskListDict = nil;
    [_uploadListArray release],_uploadListArray = nil;
    [super dealloc];
}

- (void)uploadmutilPartItem:(id<DownloadAndUploadDelegate>)item  success:(nullable YTKRequestCompletionBlock)success  fail:(nullable YTKRequestCompletionBlock)fail
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
                [weakself notifyUploadItem:parentItem withUploadProgress:currentSize/(parentItem.fileSize*1.0)*100];
                [weakself notifyUploadItem:parentItem withUploadcurrentSize:currentSize];

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
                    [weakself notifyUploadItem:parentItem withUploadState:UploadStateComplete];
                }
            }
            if (fail != nil) {
                fail(request);
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
- (void)uploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item success:(nullable YTKRequestCompletionBlock)success  fail:(nullable YTKRequestCompletionBlock)fail{
    __block id<DownloadAndUploadDelegate> weakItem = item;
    __block UpLoader *weakself = self;
    [weakself notifyUploadItem:weakItem withUploadState:UploadStateLoading];
    if ([weakItem isConstructingData]) {
        __block NSThread *currentthread = [NSThread currentThread];
        [[weakItem requestAPI] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [weakself notifyUploadItem:weakItem withUploadState:UploadStateComplete];
            if ([weakItem isBigFile]) {
                [weakItem setIsBigFile:NO];
                [weakself performSelector:@selector(uploadWait) onThread:currentthread withObject:nil waitUntilDone:NO];
            }
            //如果是文件夹
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    [weakself notifyUploadItem:parentItem withUploadState:UploadStateComplete];
                }
            }
            if (success != nil) {
                success(request);
            }
        } constructingData:^(id<AFMultipartFormData>  _Nonnull formData) {
            if ([[weakItem constructingDataDriveName] isEqualToString:BoxCSEndPointURL]) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[weakItem localPath]] name:@"file" error:nil];
                NSDictionary *dict = @{@"name": [weakItem fileName], @"parent": @{@"id": [weakItem uploadParent]}};
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
                [weakself notifyUploadItem:parentItem withUploadcurrentSize:currentSize];

            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [weakself notifyUploadItem:weakItem withUploadState:UploadStateError];
            if ([weakItem isBigFile]) {
                [weakItem setIsBigFile:NO];
                [weakself performSelector:@selector(uploadWait) onThread:currentthread withObject:nil waitUntilDone:NO];
            }
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    [weakself notifyUploadItem:parentItem withUploadState:UploadStateComplete];
                }
            }
            if (fail != nil) {
                fail(request);
            }
        }];
    }else {
        __block NSThread *currentthread = [NSThread currentThread];
        [[weakItem requestAPI] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([weakItem currentSize] == [weakItem fileSize]) {
                [weakself notifyUploadItem:weakItem withUploadState:UploadStateComplete];
            }
            //如果是文件夹
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    [weakself notifyUploadItem:parentItem withUploadState:UploadStateComplete];
                }
            }
            if ([item isBigFile]) {
                weakItem.currentTotalSize += 10485760;
                [item setIsBigFile:NO];
                [weakself performSelector:@selector(uploadWait) onThread:currentthread withObject:nil waitUntilDone:NO];
            }
            if (success != nil) {
                success(request);
            }
        } uploadProgress:^(NSProgress * _Nonnull progress) {
            weakItem.currentSize = weakItem.currentTotalSize + progress.completedUnitCount;
            double fractionCompleted = (double)weakItem.currentSize / weakItem.fileSize;
            [weakself notifyUploadItem:weakItem withUploadProgress:fractionCompleted*100];
            [weakself notifyUploadItem:weakItem withUploadcurrentSize:weakItem.currentSize];

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

            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([weakItem isBigFile]) {
                weakItem.currentTotalSize += 10485760;
                [weakItem setIsBigFile:NO];
                [weakself performSelector:@selector(uploadWait) onThread:currentthread withObject:nil waitUntilDone:NO];
            }
            if ([[request error] code] == 3840) {
                
            }else {
                [weakself notifyUploadItem:weakItem withUploadState:UploadStateError];
                if (fail != nil) {
                    fail(request);
                }
            }
            if ([weakItem currentSize] == [weakItem fileSize]) {
                [weakself notifyUploadItem:weakItem withUploadState:UploadStateComplete];
            }
            if (weakItem.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = weakItem.parent;
                NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                    [weakself notifyUploadItem:parentItem withUploadState:UploadStateComplete];
                }
            }
            
        }];
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
            [((YTKBaseRequest *)[item requestAPI]) stop];
        }
        [self notifyUploadItem:item withUploadState:DownloadStateError];
    }
}

#pragma mark -- 取消所有上传
- (void)cancelAllUploadItems {
    for (id<DownloadAndUploadDelegate> item in self.uploadListArray) {
        [self cancelUploadItem:item];
    }
}

#pragma mark -- 监听上传状态属性值
- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadState:(TransferState)uploadState {
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setState:)]) {
            [item setState:uploadState];
        }else{
            NSAssert(1,@"item未实现setUploadState:");
        }
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setState:)]) {
                [item setState:uploadState];
            }else{
                NSAssert(1,@"item未实现setUploadState:");
            }
        });
    }
    
    
    
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadProgress:(double)uploadProgress
{
     if ([[NSThread currentThread] isMainThread]) {
         if ([item respondsToSelector:@selector(setProgress:)]) {
             [item setProgress:uploadProgress];
         }else{
             NSAssert(1,@"item未实现setUploadProgress:");
         }
     }else {
         dispatch_sync(dispatch_get_main_queue(), ^{
             if ([item respondsToSelector:@selector(setProgress:)]) {
                 [item setProgress:uploadProgress];
             }else{
                 NSAssert(1,@"item未实现setUploadProgress:");
             }
         });
     }
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadSpeed:(NSInteger)uploadSpeed
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setSpeed:)]) {
            [item setSpeed:uploadSpeed];
        }else{
            NSAssert(1,@"item未实现setUploadSpeed:");
        }
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setSpeed:)]) {
                [item setSpeed:uploadSpeed];
            }else{
                NSAssert(1,@"item未实现setUploadSpeed:");
            }
        });
    }
    
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadcurrentSize:(long long)currentSize
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setCurrentSize:)]) {
            item.currentSize = currentSize;
            if (item.parent == nil){
                item.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[self getFileSizeString:currentSize reserved:2],[self getFileSizeString:item.fileSize reserved:2]];
            }else{
                NSString *downCurrentSize = [self getFileSizeString:item.parent.currentSize reserved:2];
                NSString *fileSize = [self getFileSizeString:item.parent.fileSize reserved:2];
                NSString *currenSize = [NSString stringWithFormat:@"%@/%@",downCurrentSize,fileSize];
                item.parent.currentSizeStr = currenSize;
            }
            
        }else{
            NSAssert(1,@"item未实现setCurrentSize:");
        }
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setCurrentSize:)]) {
                item.currentSize = currentSize;
                if (item.parent == nil){
                    item.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[self getFileSizeString:currentSize reserved:2],[self getFileSizeString:item.fileSize reserved:2]];
                }else{
                    NSString *downCurrentSize = [self getFileSizeString:item.parent.currentSize reserved:2];
                    NSString *fileSize = [self getFileSizeString:item.parent.fileSize reserved:2];
                    NSString *currenSize = [NSString stringWithFormat:@"%@/%@",downCurrentSize,fileSize];
                    item.parent.currentSizeStr = currenSize;
                }
                
            }else{
                NSAssert(1,@"item未实现setCurrentSize:");
            }
            
        });
    }
    
    
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadError:(NSError *)error
{
    if ([[NSThread currentThread] isMainThread]) {
        if ([item respondsToSelector:@selector(setError:)]) {
            [item setError:error];
        }else{
            NSAssert(1,@"item未实现setUploadError:");
        }
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([item respondsToSelector:@selector(setError:)]) {
                [item setError:error];
            }else{
                NSAssert(1,@"item未实现setUploadError:");
            }
        });
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


- (void)uploadWait{}

@end

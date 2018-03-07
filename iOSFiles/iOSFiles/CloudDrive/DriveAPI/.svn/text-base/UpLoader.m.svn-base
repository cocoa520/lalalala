//
//  UpLoader.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/7.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "UpLoader.h"
#if __has_include(<AFNetworking/AFURLRequestSerialization.h>)
#import <AFNetworking/AFURLRequestSerialization.h>
#else
#import "AFURLRequestSerialization.h"
#endif
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


#pragma mark - 通过表单方式上传文件

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
            if ([NSStringFromClass([item.requestAPI class]) isEqualToString:@"iCloudDriveUploadTwoAPI"]){
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[item localPath]] name:@"files" error:nil];
            }
        } uploadProgress:^(NSProgress * _Nonnull progress) {
            [weakself notifyUploadItem:weakItem withUploadProgress:progress.fractionCompleted*100];
            weakItem.currentSize = progress.completedUnitCount;
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
        [[item requestAPI] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([item isBigFile]) {
                [item setIsBigFile:NO];
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
            NSLog(@"ResponseJsonObject: %@", request.responseJSONObject);
            NSLog(@"Request Complete");
        } constructingData:^(id<AFMultipartFormData>  _Nonnull formData) {
            if ([[item constructingDataDriveName] isEqualToString:BoxCSEndPointURL]) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[item localPath]] name:@"file" error:nil];
                NSDictionary *dict = @{@"name": [item fileName], @"parent": @{@"id": [item uploadParent]}};
                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                [formData appendPartWithFormData:data name:@"attributes"];
            }else if ([[item constructingDataDriveName] isEqualToString:OneDriveCSEndPointURL]) {
                [formData appendPartWithFormData:[item constructingData] name:@"file"];
            }else if ([[item constructingDataDriveName] isEqualToString:DropboxCSEndPointURL]) {
                
            }else if ([NSStringFromClass([item.requestAPI class]) isEqualToString:@"iCloudDriveUploadTwoAPI"]){
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[item localPath]] name:@"files" error:nil];
            }
        } uploadProgress:^(NSProgress * _Nonnull progress) {
            [weakself notifyUploadItem:weakItem withUploadProgress:progress.fractionCompleted*100];
            weakItem.currentSize = progress.completedUnitCount;
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
    }else {
        [[item requestAPI] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [weakself notifyUploadItem:item withUploadState:UploadStateComplete];
            if ([item isBigFile]) {
                [item setIsBigFile:NO];
            }
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
        } uploadProgress:^(NSProgress * _Nonnull progress) {
            [weakself notifyUploadItem:weakItem withUploadProgress:progress.fractionCompleted*100];
            weakItem.currentSize = progress.completedUnitCount;
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
    if ([item respondsToSelector:@selector(setState:)]) {
        [item setState:uploadState];
    }else{
        NSAssert(1,@"item未实现setUploadState:");
    }
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadProgress:(double)uploadProgress
{
    if ([item respondsToSelector:@selector(setProgress:)]) {
        [item setProgress:uploadProgress];
    }else{
        NSAssert(1,@"item未实现setUploadProgress:");
    }
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadSpeed:(NSInteger)uploadSpeed
{
    if ([item respondsToSelector:@selector(setSpeed:)]) {
        [item setSpeed:uploadSpeed];
    }else{
        NSAssert(1,@"item未实现setUploadSpeed:");
    }
}

- (void)notifyUploadItem:(id<DownloadAndUploadDelegate>)item withUploadError:(NSError *)error
{
    if ([item respondsToSelector:@selector(setError:)]) {
        [item setError:error];
    }else{
        NSAssert(1,@"item未实现setUploadError:");
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

@end

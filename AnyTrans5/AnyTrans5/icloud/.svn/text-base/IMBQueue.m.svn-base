//
//  IMBQueue.m
//  PhoneRescue
//
//  Created by imobie on 14-9-25.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBQueue.h"
//#import "IMBCommonDefine.h"
#import "IMBNotificationDefine.h"
#import "IMBiCloudDataModle.h"
#import "TempHelper.h"
#import "Device.h"
#import "SnapshotEx.h"
@implementation IMBQueue
@synthesize delegate = _delegate;
@synthesize outputPath = _outputPath;
//@synthesize delegate = _delegate;
@synthesize iCloudClient = _iCloudClient;
@synthesize iCloudClient9 = _iCloudClient9;
@synthesize dataDic = _dataDic;
@synthesize deviceSnapshotDict = _deviceSnapshotDict;
@synthesize cancel = _cancel;

- (id)initWithQueueNumber:(int)number withDelegate:(id)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _queueNumber = number;
        _queueArray = [[NSMutableArray alloc] init];
        _deviceSnapshotDict = [[NSMutableDictionary alloc] init];
        _dataDic = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DownloadSucess:) name:NOTIFY_ICLOUD_DOWNLOAD_COMPLETE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed:) name:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:nil];
    }
    return self;
}
- (BOOL)addOject:(id)obj{
    //if ([self getQueueCount] < _queueNumber) {
        [_queueArray addObject:obj];
        return YES;
    //}
    //return NO;
}
- (id)getQueueHeadObject{
    if ([self getQueueCount] > 0) {
        return [_queueArray firstObject];
    }
    return nil;
}
- (void)removeObject:(id)object{
    [_queueArray removeObject:object];
}
- (void)removeHeadObject{
    if ([self getQueueCount] > 0) {
        [_queueArray removeObjectAtIndex:0];
    }
}
- (int)getQueueCount{
    return (int)[_queueArray count];
}
- (void)removeAllObjects{
    if ([self getQueueCount] > 0) {
        [_queueArray removeAllObjects];
    }
}
- (NSArray *)getAllObjects{
    return _queueArray;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ICLOUD_DOWNLOAD_COMPLETE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:nil];
    if (_queueArray != nil) {
        [_queueArray release];
        _queueArray = nil;
    }
    [super dealloc];
}
- (void)DownloadSucess:(id)sender{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(sucessDownloadWithOutputpath:)]) {
        [_delegate sucessDownloadWithOutputpath:_outputPath];
    }

}
- (void)downloadFailed:(id)sender{
    DownloadErrorEnum downloadError = [[(NSNotification *)sender object] intValue];
    if (downloadError == DownloadOtherError) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(downloadFailedWithOutputPath:)]) {
            [_delegate downloadFailedWithOutputPath:_outputPath];
        }
    }
}

- (void)startDownload{
    IMBiCloudBackupBindingEntity*bindingEntity = [self getQueueHeadObject];
    IMBiCloudBackup *backupItem = bindingEntity.backupItem;
    if (bindingEntity.loadType == iCloudDataDownLoad || bindingEntity.loadType == iCLoudDataContinue) {
        bindingEntity.loadType = iCloudDataDownLoading;
        [bindingEntity.btniCloudCommon removeFromSuperview];
    }
    bindingEntity.loadType = iCloudDataDownLoading;
    [bindingEntity.btniCloudCommon removeFromSuperview];
    
    
    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newThread, ^{
        [_iCloudClient downloadBackup:backupItem withFilter:nil withOutputPath:_outputPath];
    });
}

#pragma mark -- ios 9 以后的iCloud Backup登录与下载
- (BOOL)loginAuth:(NSString*)appleID withPassword:(NSString*)password {
    [[IMBLogManager singleton] writeInfoLog:@"login Icloud start"];
    _iCloudClient9 = [[iCloudClient alloc] init];
    [_iCloudClient9 setDelegate:self];
    BOOL isRet = NO;
    BOOL isnetworkfail = NO;
    [_iCloudClient9 setDelegate:self];
    @try {
        [[IMBLogManager singleton] writeInfoLog:@"Verify account password"];
        isRet = [_iCloudClient9 auth:appleID withPassword:password];
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"Network fault interrupt"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil userInfo:nil];
        }
        [[IMBLogManager singleton] writeInfoLog:@"loginEorro"];
        isnetworkfail = YES;
    }
    return isRet;
}

- (void)iOS9StartDownload{
    IMBiCloudBackupBindingEntity*bindingEntity = [self getQueueHeadObject];
    IMBiCloudBackup *backupItem = bindingEntity.backupItem;
    
    if (bindingEntity.loadType == iCloudDataDownLoad || bindingEntity.loadType == iCLoudDataContinue) {
        bindingEntity.loadType = iCloudDataDownLoading;
        [bindingEntity.btniCloudCommon removeFromSuperview];
    }
    bindingEntity.loadType = iCloudDataDownLoading;
    [bindingEntity.btniCloudCommon removeFromSuperview];
    _cancel = NO;
    
    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newThread, ^{
        @try {
            Device *device = [_dataDic objectForKey:[backupItem relativePath]];
            NSArray *snapshots = [_deviceSnapshotDict objectForKey:device];
            SnapshotEx *snapshot = [snapshots objectAtIndex:[backupItem downCount]];
            NSMutableArray *domains = [[[NSMutableArray alloc] initWithObjects:@"HomeDomain", @"MediaDomain", @"CameraRollDomain", @"AppDomainGroup-group.com.apple.notes", @"AppDomain-com.apple.mobilesafari", nil] autorelease];
            NSString *iOSVersion = [snapshot deviceIOSVersion];
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"snapshot:%@ %d iosVersion:%@", snapshot.info, backupItem.downCount, iOSVersion]];
            [_iCloudClient9 downloadWithDevice:device withSnapshot:snapshot withDomains:domains withCancel:&_cancel];
            [[IMBLogManager singleton] writeInfoLog:@"_icloudClient device down backup end"];
        }
        @catch (NSException *exception) {
            [[IMBLogManager singleton] writeWarnLog:[NSString stringWithFormat:@"iCloud Backup Downloading Exception: %@", exception.reason]];
            [_delegate stopDownloadWithUserpath:bindingEntity.userPtath];
        }
        [[IMBLogManager singleton] writeInfoLog:@"end icloud down backup"];
    });
}

#pragma mark -- ios 9 以后的iCloud Backup下载代理
- (void)downloadProgress:(uint64_t)totalSize withCompleteSize:(uint64_t)completeSize {
    if (_delegate && [_delegate respondsToSelector:@selector(loadicloudDownProess:withCompleteSize:)]) {
        [_delegate loadicloudDownProess:totalSize withCompleteSize:completeSize];
    }
}

- (void)downloadComplete {
    if (_delegate && [_delegate respondsToSelector:@selector(loadicloudDownProessComplete)]) {
        [_delegate loadicloudDownProessComplete];
    }
}

@end

//
//  DriveToDrive.m
//  DriveSync
//
//  Created by 罗磊 on 2017/12/12.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "DriveToDrive.h"
#import "DriveItem.h"
static void * KdownloadProgressContext = &KdownloadProgressContext;
static void * KStateContext = &KStateContext;
static void * KuploadProgressContext = &KuploadProgressContext;

@implementation DriveToDrive

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)transferFromDrive:(BaseDrive *)sourceDrive targetDrive:(BaseDrive *)targetDrive item:(id<DownloadAndUploadDelegate>)item
{
    _baseDrive = [targetDrive retain];
//    [_taskDic setObject:@{@"sourceDrive":sourceDrive,@"targetDrive":targetDrive} forKey:item.identifier];
    [(NSObject *)item addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:KdownloadProgressContext];
    [(NSObject *)item addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:KStateContext];
    [sourceDrive downloadItem:item];
}

- (void)cancelDriveToDriveItem:(id<DownloadAndUploadDelegate>)item
{
    BaseDrive *sourceDrive = [[_taskDic objectForKey:item.identifier] objectForKey:@"sourceDrive"];
    BaseDrive *targetDrive = [[_taskDic objectForKey:item.identifier] objectForKey:@"targetDrive"];
    [sourceDrive cancelDownloadItem:item];
    [targetDrive cancelUploadItem:item];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id<DownloadAndUploadDelegate> driveItem = object;
    if (context == KdownloadProgressContext){
        [self notifyDriveToDriveItem:driveItem withProgress:driveItem.progress*0.5];
    }else if (context == KuploadProgressContext){
        [self notifyDriveToDriveItem:driveItem withProgress:driveItem.progress*0.5+50];
    }else if (context == KStateContext){
        if (driveItem.state == DownloadStateError) {
            [(NSObject *)driveItem removeObserver:self forKeyPath:@"progress" context:KdownloadProgressContext];
            if (!driveItem.isFolder) {
                [(NSObject *)driveItem removeObserver:self forKeyPath:@"state" context:KStateContext];
            }
        }else if (driveItem.state == UploadStateError){
            [(NSObject *)driveItem removeObserver:self forKeyPath:@"progress" context:KuploadProgressContext];
            [(NSObject *)driveItem removeObserver:self forKeyPath:@"state" context:KStateContext];
        }else if (driveItem.state == DownloadStateComplete){
            [(NSObject *)driveItem addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:KuploadProgressContext];
            [(NSObject *)driveItem removeObserver:self forKeyPath:@"progress" context:KdownloadProgressContext];
            //进行上传操作
            BaseDrive *targetDrive = [[_taskDic objectForKey:driveItem.identifier] objectForKey:@"targetDrive"];
            [targetDrive uploadItem:driveItem];
        }else if (driveItem.state == UploadStateComplete){
            [(NSObject *)driveItem removeObserver:self forKeyPath:@"progress" context:KuploadProgressContext];
            [(NSObject *)driveItem removeObserver:self forKeyPath:@"state" context:KStateContext];
        }
    }
}

#pragma mark - 设置的属性值

- (void)notifyDriveToDriveItem:(id<DownloadAndUploadDelegate>)item withProgress:(double)progress
{
    if ([item respondsToSelector:@selector(setDriveTodriveProgress:)]) {
        item.driveTodriveProgress = progress;
    }else{
        NSAssert(1,@"item未实现setDriveTodriveProgress:");
    }
}

- (void)dealloc
{
    [_baseDrive release],_baseDrive = nil;
    [_taskDic release],_taskDic = nil;
    [super dealloc];
}
@end

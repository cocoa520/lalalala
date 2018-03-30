//
//  IMBDriveBaseManage.m
//  iOSFiles
//
//  Created by JGehry on 4/16/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDriveBaseManage.h"

@implementation IMBDriveBaseManage
@synthesize driveWindowDelegate = _driveWindowDelegate;
@synthesize driveDataAry = _driveDataAry;
@synthesize downloadPath = _downloadPath;

- (id)initWithUserID:(NSString *) userID WithPassID:(NSString*) passID WithDelegate:(id)delegate {
    if ([self init]) {

    }
    return self;
}

- (id)initWithUserID:(NSString *)userID withDelegate:(id)delegate{
    if ([super init]) {

    }
    return self;
}

- (void)userDidLogout {

}

//删除
- (void)deleteDriveItem:(nullable NSMutableArray *) deleteItemAry {
    
}
//单个文件下载
- (void)oneDriveDownloadOneItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    
}

//多个文件下载到本地
- (void)driveDownloadItemsToMac:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items {
    
}

//上传单个文件、文件夹
- (void)oneDriveUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    
}

//多个文件下载到本地
- (void)driveUploadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items {
    
}

- (void)recursiveDirectoryContentsDics:(nullable NSString *)folerID {
    
}

- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(_Nonnull id <DownloadAndUploadDelegate>)item {
    
}

- (void)createFolder:(nullable NSString *)folderName parent:(nullable NSString *)parentID {
    
}

- (void)dealloc {
    [super dealloc];
    [_driveDataAry release];
    _driveDataAry = nil;
    [_userID release];
    _userID = nil;
}

@end

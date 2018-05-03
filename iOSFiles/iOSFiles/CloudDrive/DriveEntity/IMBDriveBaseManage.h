//
//  IMBDriveBaseManage.h
//  iOSFiles
//
//  Created by JGehry on 4/16/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolDelegate.h"
#import "BaseDrive.h"
#import "IMBDriveEntity.h"
#import "ATTracker.h"

@interface IMBDriveBaseManage : NSObject <DownloadAndUploadDelegate>
{
    //window delegate   用于window功能按钮
    id _driveWindowDelegate;
    NSMutableArray *_driveDataAry;
    NSString *_userID;
    //viewControll delegate 用于切换界面
    id _deivceDelegate;
    NSString *_passWordID;
    NSString *_downloadPath;
    BOOL _isCloudDrive;
}
@property (nonatomic,assign,nullable) id driveWindowDelegate;
@property (nonatomic,retain,nullable) NSMutableArray* driveDataAry;
@property (nonatomic,retain,nullable) NSString *userID;
@property (nonatomic,retain,nullable) NSString *downloadPath;
@property (nonatomic,assign) BOOL isCloudDrive;
- (_Nullable id)initWithUserID:(NSString * _Nullable ) userID WithPassID:( NSString * _Nullable) passID WithDelegate:(_Nullable id)delegate;
- (_Nullable id)initWithUserID:( NSString * _Nullable)userID withDelegate:(_Nullable id)delegate;
//删除
- (void)deleteDriveItem:(nullable NSMutableArray *) deleteItemAry;
//单个文件下载
- (void)oneDriveDownloadOneItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

//多个文件下载到本地
- (void)driveDownloadItemsToMac:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

//上传单个文件、文件夹
- (void)oneDriveUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

//多个文件下载到本地
- (void)driveUploadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

- (void)recursiveDirectoryContentsDics:(nullable NSString *)folerID;

/**
 *  Description  云到云传输
 *
 *  @param targetDrive 目标云
 *  @param item        传输项
 */
//- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(NSMutableArray *) item;
/**
 *  Description 创建文件夹
 *
 *  @param folderName 文件夹名字
 *  @param parentID   文件夹所在父目录ID或者路径 @"0"表示根目录ID
 *  @param entity     接收返回的实体
 *
 */
- (void)createFolder:(nullable NSString *)folderName parent:(nullable NSString *)parentID withEntity:(nullable IMBDriveEntity *)drviceEntity;


- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(NSMutableArray *)item;
//取消下载
- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

//取消上次
- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

- (void)userDidLogout;
@end

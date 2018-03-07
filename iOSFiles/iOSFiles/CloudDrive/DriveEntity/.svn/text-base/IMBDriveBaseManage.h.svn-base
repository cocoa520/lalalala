//
//  IMBDriveBaseManage.h
//  iOSFiles
//
//  Created by JGehry on 4/16/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolDelegate.h"
@interface IMBDriveBaseManage : NSObject <DownloadAndUploadDelegate>
{
    //window delegate   用于window功能按钮
    id _driveWindowDelegate;
    NSMutableArray *_driveDataAry;
    NSString *_userID;
    //viewControll delegate 用于切换界面
    id _deivceDelegate;
    NSString *_passWordID;

}
@property (nonatomic,assign,nullable) id driveWindowDelegate;
@property (nonatomic,retain,nullable) NSMutableArray* driveDataAry;
@property (nonatomic,retain,nullable) NSString *userID;
- (_Nullable id)initWithUserID:(NSString * _Nullable ) userID WithPassID:( NSString * _Nullable) passID WithDelegate:(_Nullable id)delegate;
- (_Nullable id)initWithUserID:( NSString * _Nullable)userID withDelegate:(_Nullable id)delegate;
//删除
- (void)deleteDriveItem:(nullable NSMutableArray *) deleteItemAry;
//单个文件下载
- (void)oneDriveDownloadOneItem:(_Nonnull id<DownloadAndUploadDelegate>)item;
//上传
- (void)oneDriveUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;
- (void)recursiveDirectoryContentsDics:(nullable NSString *)folerID;
@end

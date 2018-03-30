//
//  IMBDropBoxManage.h
//  iOSFiles
//
//  Created by JGehry on 3/12/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dropbox.h"
#import "IMBDriveBaseManage.h"
@interface IMBDropBoxManage : IMBDriveBaseManage<BaseDriveDelegate>
{
    Dropbox *_dropbox;
}


/**
 *  初始化
 *
 *  @param userID id
 *  @param parent 原父目录 视情况而定有的平台 不需要parent参数 传nil即可 比如onedrive 不需要parent参数
 *  @param idOrPath  自身的id或者路径
 *  @param success   成功回调block
 *  @param fail      失败回调block
 */
- (nullable id)initWithUserID:(nullable NSString *)userID withDelegate:(nullable id)delegate;

- (void)driveUploadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

/**
 *  重命名文件或者文件夹
 *
 *  @param newName  新的名称
 *  @param idOrPath 原名称所在的路径，只能传入文件的完整路径
 */
- (void)reName:(nullable NSString *)newName idOrPath:(nullable NSString *)idOrPath;
/**
 *  Description 移动
 *
 *  @param newParent 父目录的id或者路径
 *  @param parent 原父目录 视情况而定有的平台 不需要parent参数 传nil即可 比如onedrive 不需要parent参数
 *  @param idOrPaths  自身的id或者路径数组
 */
- (void)moveToNewParent:(nullable NSString *)newParent sourceParent:(nullable NSString *)parent idOrPaths:(nullable NSArray *)idOrPaths;

@end

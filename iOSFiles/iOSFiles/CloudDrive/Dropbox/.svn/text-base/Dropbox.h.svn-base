//
//  Dropbox.h
//  DriveSync
//
//  Created by JGehry on 12/4/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "BaseDrive.h"

@interface Dropbox : BaseDrive
{
    long long _totalStorageInBytes;//总容量
    long long _usedStorageInBytes;//使用容量
    
}
@property (nonatomic, assign) long long totalStorageInBytes;//总容量
@property (nonatomic, assign) long long usedStorageInBytes;//使用容量
/**
 *  获取云盘使用信息
 *
 *  @param spaceUsage 默认传入0
 *  @param success    成功回调block
 *  @param fail       失败回调block
 */
- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail;
/**
 *  获取云盘使用空间
 *
 *  @param spaceUsage 默认传入0
 *  @param success    成功回调block
 *  @param fail       失败回调block
 */
- (void)getSpaceUsage:(NSString *)spaceUsage success:(Callback)success fail:(Callback)fail;


/**
 *  删除指定的单文件或者目录
 *
 *  @param filePathOrFolderName     删除的文件路径名或者父目录名称
 *  @param success                  成功回调block
 *  @param fail                     失败回调block
 */
- (void)deleteFilesOrFolders:(NSArray *)filePathOrFolderName success:(Callback)success fail:(Callback)fail;

/**
 *  删除指定的多文件或者目录
 *
 *  @param filePathOrFolderName     删除的文件路径名或者父目录名称
 *  @param success                  成功回调block
 *  @param fail                     失败回调block
 */
- (void)deleteMultipleFilesOrFolders:(NSArray *)filePathOrFolderName success:(Callback)success fail:(Callback)fail;

/**
 *  移动多文件或者多文件夹
 *
 *  @param newParent        父目录的id或者路径
 *  @param parent           原父目录 视情况而定有的平台 不需要parent参数 传nil即可 比如onedrive 不需要parent参数
 *  @param idOrPaths        自身的id或者路径数组
 *  @param success          成功回调block
 *  @param fail             失败回调block
 */
- (void)moveMultipleToNewParent:(NSString *)newParent sourceParent:(NSString *)parent idOrPaths:(NSArray *)idOrPaths success:(Callback)success fail:(Callback)fail;

/**
 *  重命名文件或者文件夹
 *
 *  @param newName  新的名称
 *  @param idOrPath 原名称所在的路径，只能传入文件的完整路径
 *  @param success  成功回调
 *  @param fail     失败回调
 */
- (void)reName:(NSString *)newName idOrPath:(NSString *)idOrPath success:(Callback)success fail:(Callback)fail;

@end

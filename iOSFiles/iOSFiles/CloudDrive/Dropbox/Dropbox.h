//
//  Dropbox.h
//  DriveSync
//
//  Created by JGehry on 12/4/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "BaseDrive.h"

@interface Dropbox : BaseDrive

/**
 *  获取云盘使用空间
 *
 *  @param spaceUsage 默认传入0
 *  @param success    成功回调block
 *  @param fail       失败回调block
 */
- (void)getSpaceUsage:(NSString *)spaceUsage success:(Callback)success fail:(Callback)fail;
/**
 *  删除指定的文件或者目录
 *
 *  @param filePathOrFolderName      删除的文件路径名或者父目录名称
 *  @param success           成功回调block
 *  @param fail                  失败回调block
 */
- (void)deleteFilesOrFolders:(NSArray *)filePathOrFolderName success:(Callback)success fail:(Callback)fail;

/**
 *  删除多文件夹及文件
 *
 *  @param folderName     删除的名称+后缀名
 *  @param parentFilePath  父目录
 *  @param success           成功回调block
 *  @param fail                  失败回调block
 */
- (void)deleteMultipleFilesOrFolders:(NSString *)folderName parent:(NSString *)parentFilePath success:(Callback)success fail:(Callback)fail;

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

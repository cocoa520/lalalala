//
//  IMBBaseCloudManager.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDrive.h"
#import "IMBCloudDataModel.h"
#import "StringHelper.h"
#import "DateHelper.h"
@interface IMBBaseCloudManager : NSObject {
    BaseDrive *_baseDrive;
    NSMutableArray *_driveDataAry;
}
@property (nonatomic,retain,nullable) BaseDrive *baseDrive;
@property (nonatomic,retain,nullable) NSMutableArray* driveDataAry;
- (void)loadData;

/**
 *  获取云盘用户信息
 *
 *  @param accountID 账号ID
 *  @param success   成功回调block
 *  @param fail      失败回调block
 */
- (void)getAccount:(NSString *_Nonnull)accountID success:(Callback _Nonnull)success fail:(Callback _Nonnull)fail;

/**
 ***************************** @description 文件操作相关方法
 */

/**
 *  Description 创建文件夹
 *
 *  @param folderName 文件夹名字
 *  @param parentID     文件夹所在父目录ID或者路径 @"0"表示根目录ID
 *  @param success    成功回调block
 *  @param fail       失败回调block
 *
 */
- (void)createFolder:(NSString *_Nonnull)folderName parent:(NSString *_Nonnull)parentID success:(Callback _Nonnull)success fail:(Callback _Nonnull)fail;

/**
 *  Description 同步方式创建文件夹
 *
 *  @param folderName 文件夹名字
 *  @param parent    文件夹所在父目录ID或者路径 @"0"表示根目录ID
 *
 *  @return 创建目录返回值
 */
- (NSDictionary *_Nonnull)createFolder:(NSString *_Nonnull)folderName parent:(NSString *_Nonnull)parent;

/**
 *  Description 得到指定目录下的文件列表
 *
 *  @param folerID 目录ID或者路径   @"0"表示根目录ID
 *  @param success 成功回调block
 *  @param fail    失败回调block
 *
 */
- (void)getList:(NSString *_Nonnull)folerID success:(Callback _Nonnull)success fail:(Callback _Nonnull)fail;

/**
 *  Description 同步方式获取目录列表
 *
 *  @param folerID 目录id或者路径
 *
 *  @return 返回 获取列表返回值
 */
- (NSDictionary *_Nonnull)getList:(NSString *_Nonnull)folerID;

/**
 *  Description 重命名
 *
 *  @param newName  新名字
 *  @param idOrPath id或者路径
 *  @param success 成功回调block
 *  @param fail    失败回调block
 */
- (void)reName:(NSString *_Nonnull)newName idOrPath:(NSString *_Nonnull)idOrPath success:(Callback _Nonnull)success fail:(Callback _Nonnull)fail;

/**
 *  Description 移动
 *
 *  @param newParent 父目录的id或者路径
 *  @param parent 原父目录 视情况而定有的平台 不需要parent参数 传nil即可 比如onedrive 不需要parent参数
 *  @param idOrPaths  自身的id或者路径数组
 *  @param success   成功回调block
 *  @param fail      失败回调block
 */
- (void)moveToNewParent:(NSString *_Nonnull)newParent sourceParent:(NSString *_Nonnull)parent idOrPaths:(NSArray *_Nonnull)idOrPaths success:(Callback _Nonnull)success fail:(Callback _Nonnull)fail;

/**
 ***************************** @description 下载相关方法
 */

- (void)downloadFolder:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 * @description 下载一个item
 *  @param item 传入所需
 */
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description  下载一个item 具有完成回调
 *
 *  @param item              item
 *  @param completionHandler completionHandler 完成回调
 */
- (void)startDownload:(_Nonnull id <DownloadAndUploadDelegate>)item completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/**
 *  @description 同时下载多个
 *  @param items 传入数组
 */
- (void)downloadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

/**
 *  @description暂停正在下载的项
 *
 *  @param item 传入要暂停的项
 */
- (void)pauseDownloadItem:(_Nonnull id <DownloadAndUploadDelegate>)item;

/**
 *  Description 暂停所有的下载项
 */
- (void)pauseAllDownloadItems;

/**
 *  Description 恢复下载项
 *
 *  @param item 下载项
 */
- (void)resumeDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description 恢复所有下载项
 */
- (void)resumeAllDownloadItems;

/**
 *  Description 取消下载项
 *
 *  @param item 下载项
 */
- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description 取消所有
 */
- (void)cancelAllDownloadItems;

/**
 * ***************************** @description 上传相关方法
 */

/**
 * @description 上传一个item
 *  @param item 传入所需
 */
- (void)uploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  @description 同时上传多个
 *  @param items 传入数组
 */
- (void)uploadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

/**
 *  @description暂停正在上传的项
 *
 *  @param item 传入要暂停的项
 */
- (void)pauseUploadItem:(_Nonnull id <DownloadAndUploadDelegate>)item;

/**
 *  Description 暂停所有的上传项
 */
- (void)pauseAllUploadItems;

/**
 *  Description 恢复上传项
 *
 *  @param item 上传项
 */
- (void)resumeUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description 恢复所有上传项
 */
- (void)resumeAllUploadItems;

/**
 *  Description 取消上传项
 *
 *  @param item 上传项
 */
- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  Description 取消所有上传项
 */
- (void)cancelAllUploadItems;

@end

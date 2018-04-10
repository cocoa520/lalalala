//
//  DownLoader.h
//  DriveSync
//
//  Created by 罗磊 on 2017/12/7.
//  Copyright © 2017年 imobie. All rights reserved.
//

/**
 * 下载器专门负责下载
 */
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ProtocolDelegate.h"

@interface DownLoader : NSObject
{
    NSString *_accessToken;
    /**
     *  有关下载属性
     */
    NSMutableArray *_downloadArray;          ///<下载项列表
    NSMutableDictionary *_downloadtask;     ///<下载任务列表
    NSInteger _downloadMaxCount;    ///<最大下载数
    NSInteger _activedownloadCount; ///<已经激活下载数
    NSString *_downloadPath;        ///<下载到电脑上的路径
    AFHTTPSessionManager *_downloadManager;
    dispatch_queue_t _synchronQueue;
}
@property(nonatomic,assign)BOOL autoCancelFailedItem;
@property(nonnull,retain,readonly)NSMutableArray *downloadArray;
@property(nonnull,nonatomic,retain,readonly)NSMutableDictionary *downloadtask;
@property(nonatomic,assign,readonly)NSInteger activedownloadCount;
@property(nonatomic,assign)NSInteger downloadMaxCount;
@property(nonnull,nonatomic,retain)NSString  *downloadPath;

- (id)initWithAccessToken:(NSString *)accessToken;

/**
 * @description 下载一个item
 *  @param item 传入所需
 */
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item ;

/**
 *  Description 下载一个item 具有完成回调
 *
 *  @param item              item
 *  @param completionHandler completionHandler 完成回调  此方法具有下载个数限制
 */
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/**
 *  @description 同时下载多个
 *  @param items 传入数组
 */
- (void)downloadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

/**
*  @description暂停正在下载的项 可以暂停正在下载和等待下载的项
*
*  @param itme 传入要暂停的项
*/
- (void)pauseDownloadItem:(_Nonnull id <DownloadAndUploadDelegate>)itme;

/**
 *  Description 暂停所有的下载项
 */
- (void)pauseAllDownloadItems;

/**
 *  Description 恢复下载项  可以恢复暂停和发生错误的下载项
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

@end

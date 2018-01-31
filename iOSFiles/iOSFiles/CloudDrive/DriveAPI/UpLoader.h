//
//  UpLoader.h
//  DriveSync
//
//  Created by 罗磊 on 2017/12/7.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolDelegate.h"

/**
 *  上传器专门负责上传文件
 */


@interface UpLoader : NSObject {
    NSString *_accessToken;
    NSString *_localFilePath;                   ///<上传的本地文件路径
    NSMutableArray *_uploadListArray;           ///<上传文件列表
    NSMutableDictionary *_uploadTaskListDict;   ///<上传任务列表
    NSInteger _uploadMaxCount;                  ///<最大上传数
    NSInteger _activeUploadCount;               ///<已经激活上传数
}

@property (nonnull, nonatomic, retain) NSString *localFilePath;
@property (nonnull, nonatomic, readonly) NSMutableArray *uploadListArray;
@property (nonnull, nonatomic, readonly) NSMutableDictionary *uploadTaskListDict;
@property (nonatomic, assign) NSInteger uploadMaxCount;
@property (nonatomic, assign) NSInteger activeUploadCount;

- (id)initWithAccessToken:(NSString *)accessToken;

/**
 *  上传单个文件
 *
 *  @param item 上传的对象
 */
- (void)uploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item  ;

/**
 *  上传多个文件
 *
 *  @param items 上传的数组对象
 */
- (void)uploadItems:(NSArray <id<DownloadAndUploadDelegate>> * _Nonnull)items ;

/**
 *  暂停上传
 *
 *  @param item 上传的对象
 */
- (void)pauseUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item ;

/**
 *  暂停所有上传
 */
- (void)pauseAllDownloadItems;

/**
 *  恢复上传
 *
 *  @param item 待上传的对象
 */
- (void)resumeUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  恢复所有上传
 */
- (void)resumeAllUploadItems;

/**
 *  取消上传
 *
 *  @param item 上传的对象
 */
- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  取消所有上传
 */
- (void)cancelAllUploadItems;

@end

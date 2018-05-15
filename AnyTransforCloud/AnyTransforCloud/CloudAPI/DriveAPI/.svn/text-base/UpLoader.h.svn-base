//
//  UpLoader.h
//  DriveSync
//
//  Created by 罗磊 on 2017/12/7.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolDelegate.h"
#if __has_include(<YTKNetwork/YTKNetwork.h>)
#import <YTKNetwork/YTKNetwork.h>
#else
#import "YTKNetwork.h"
#endif
#if __has_include(<AFNetworking/AFURLRequestSerialization.h>)
#import <AFNetworking/AFURLRequestSerialization.h>
#else
#import "AFURLRequestSerialization.h"
#endif

/**
 *  上传器专门负责上传文件
 */


@interface UpLoader : NSObject {
    NSString *_accessToken;
    NSString *_localFilePath;
    NSMutableArray *_uploadListArray;
    NSMutableDictionary *_uploadTaskListDict;

}

/** 上传的本地文件路径 */
@property (nonnull, nonatomic, retain) NSString *localFilePath;
/** 上传文件列表 */
@property (nonnull, nonatomic, readonly) NSMutableArray *uploadListArray;
/** 上传任务列表 */
@property (nonnull, nonatomic, readonly) NSMutableDictionary *uploadTaskListDict;
- (_Nonnull id)initWithAccessToken:(NSString * _Nonnull)accessToken;

/**
 *  Description 通过表单方式上传
 *
 *  @param item    上传项
 *  @param success 成功回调
 *  @param fail 失败回调
 */
- (void)uploadmutilPartItem:(_Nonnull id<DownloadAndUploadDelegate>)item  success:(nullable YTKRequestCompletionBlock)success  fail:(nullable YTKRequestCompletionBlock)fail;

/**
 *  Description  上传
 *
 *  @param item    上传项
 *  @param success 成功回调
 *  @param fail    失败回调
 */
- (void)uploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item success:(nullable YTKRequestCompletionBlock)success  fail:(nullable YTKRequestCompletionBlock)fail;

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


/**
 *  Description 表单上传文件 iCloud Drive需要
 *
 *  @param item    上传项
 *  @param success 成功回调
 */
@end

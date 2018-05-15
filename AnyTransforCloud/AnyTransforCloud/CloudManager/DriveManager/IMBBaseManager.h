//
//  IMBBaseCloudManager.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDrive.h"
#import "IMBDriveModel.h"
#import "StringHelper.h"
#import "DateHelper.h"
#import "IMBDriveModel.h"
#import "IMBCommonEnum.h"
#import "TempHelper.h"
#import "NSString+Category.h"
#import "IMBNotificationDefine.h"
#import "IMBDriveImageSqltie.h"
#import "IMBSearchManager.h"
@protocol IMBDriveDelegate
@optional
- (void)loadDriveDataFail:(ActionTypeEnum)typeEnum;
- (void)loadDriveComplete:(NSMutableArray *_Nonnull)ary WithEvent:(ActionTypeEnum)typeEnum;
@end

@interface IMBBaseManager : NSObject {
    BaseDrive *_baseDrive;
    id _delegete;
    id _searchDelegete;
    NSNotificationCenter *_nc;
    NSString *_photoSqlitePath;
    NSString *_storePhotoPath;
    IMBDriveImageSqltie *_driveSqlite;
}
@property (nonatomic,retain,nullable) BaseDrive *baseDrive;
@property (nonatomic,assign,nullable) id delegate;
@property (nonatomic,assign,nullable) id searchDelegete;

- (id _Nonnull)initWithDrive:(BaseDrive * _Nonnull)drive;
/**
 * Description 加载数据
 */
- (void)loadData;

/**
 *  获取数据
 *  @param folerID 目录ID或者路径   @"0"表示根目录ID
 */
- (void)recursiveDirectoryContentsDics:(NSString *_Nonnull)folerID;

/**
 *  获取账户信息
 */
- (void)getAccount;

/**
 * @description 下载一个item
 *  @param item 传入所需
 */
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  @description 同时下载多个
 *  @param items 传入数组
 */
- (void)downloadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items;

/**
 *  Description 取消下载项
 *
 *  @param item 下载项
 */
- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

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
 *  删除数据
 *  @param deleteItemAry  删除的文件路径名或者父目录名称
 */
- (void)deleteDriveItem:(NSMutableArray *_Nonnull)deleteItemAry;

/**
 *  重命名
 *
 *  @param newName              如果是文件夹，传入新名字; 如果是文件，传入新名字+后缀
 *  @param idOrPathArray        源目录数组，包含 @{@"itemIDOrPath": @"文件ID/文件夹ID/文件的完整路径",    //Dropbox才需要传入完整路径
 *                                              @"isFolder": @(YES)/@(NO)}
 */
- (void)reName:(NSString *_Nonnull)newName idOrPathArray:(NSArray *_Nonnull)idOrPathArray withEntity:(nullable IMBDriveModel *)drviceEntity;

/**
 *  批量复制文件或文件夹
 *
 *  @param newParentIdOrPath    如果是Dropbox, 传入目标完整路径; 其他云盘, 传入目标ID
 *  @param idOrPathArray        源目录数组，包含 @{@"fromItemIDOrPath": @"文件ID/文件夹ID/文件的完整路径",      //Dropbox才需要传入完整路径
 *                                              @"isFolder": @(YES)/@(NO)}
 *                              iCloudDrive规则: @{@"etag": @"pi",
 *                                                @"drivewsid": @"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *                                                @"name": @"hhh22"}
 */
- (void)copyToNewParentIDOrPath:(NSString *_Nonnull)newParentIdOrPath idOrPathArray:(NSArray *_Nonnull)idOrPathArray;


/**
 *  Description 得到指定目录下的文件夹信息，用于搜索
 *
 *  @param folerID 目录ID或者路径   @"0"表示根目录ID
 *
 */
- (void)getFolderInfo:(NSString *_Nonnull)folerID;
/**
 *  搜索文件或者文件夹
 *
 *  @param query                待搜索名称
 *  @param limit                待搜索条数  默认 @"20"
 *  @param pageIndex            搜索第几页  第一次 默认传 @""
 */
- (void)searchContent:(NSString *_Nonnull)query withLimit:(NSString *_Nonnull)limit withPageIndex:(NSString *_Nonnull)pageIndex;

/**
 *  新建文件夹
 *  @param folderName 文件夹名字
 *  @param parentID     文件夹所在父目录ID或者路径 @"0"表示根目录ID
 *  @param drviceEntity 新建的对象
 */
- (void)createFolder:(NSString *_Nonnull)folderName parent:(NSString *_Nonnull)parentID withEntity:(nullable IMBDriveModel *)drviceEntity;

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
 *  移动文件
 *  @param newParent 父目录的id或者路径
 *  @param idOrPaths  自身的id或者路径数组
 */
- (void)moveToNewParent:(NSString *_Nonnull)newParent idOrPaths:(NSArray *_Nonnull)idOrPaths;

/**
 *  Description  云到云传输
 *
 *  @param targetDrive 目标云
 *  @param item        传输项
 */
- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(NSMutableArray *_Nonnull)item;

/**
 *  Description 取消上传项
 *
 *  @param item 上传项
 */
- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item;

/**
 *  时间转换
 *  @param dateSting 字符串
 */
- (NSString *_Nonnull)dateForm2001DateSting:(NSString *_Nonnull)dateSting;

/**
 *  Description 设置下载路径
 *
 *  @param downloadPath 下载路径
 */
- (void)setDownloadPath:(NSString * _Nonnull)downloadPath;

/**
 *  下载图片 保存到数据库中
 *
 *  @param drviceEntity I'MDriveModel实体
 */
- (void)matchingSqlite:(IMBDriveModel * _Nonnull)drviceEntity;

/**
 *  Description 取消所有下载
 */
- (void)cancelAllDownloadItems;

/**
 *  Description 取消所有上传项
 */
- (void)cancelAllUploadItems;

/**
 *  读取保存图片的数据库
 */
- (void)readSqlite;
@end

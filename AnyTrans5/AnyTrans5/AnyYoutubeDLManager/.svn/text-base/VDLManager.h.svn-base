//
//  VDLManager.h
//  
//
//  Created by JGehry on 12/16/16.
//
//

#import <Foundation/Foundation.h>
#import "VideoBaseInfoEntity.h"

@protocol VideoFetchProgressCallBack
@required

/**
 *  分析视频异常
 *
 *  @param errorStr 异常信息
 */
- (void)VDLFetchException:(NSString *)errorStr;

@end

@interface VDLManager : NSObject {
    NSMutableString *_addStr;
    NSString *_vCacheLocation;
    id _vFetchDelegate;
    NSMutableArray *_vEntityMutableArray;
    @public
    id _delegate;
    NSTask *_task;
}

/**
 *  addStr             视频回传字符串
 *  vBIEntity          视频基本信息实体
 *  vCacheLocation     缓存视频存放路径
 *  vDLDelegate        视频代理
 *  isPart             视频是否有分段情况
 *  entityMutableArray 视频实体数组
 */
@property (nonatomic, readwrite, retain) NSMutableString *addStr;
@property (nonatomic, readwrite, retain) NSString *vCacheLocation;
@property (nonatomic, readwrite, assign) id vFetchDelegate;
@property (nonatomic, readwrite, retain) NSMutableArray *vEntityMutableArray;
@property (nonatomic, readwrite, retain) NSTask *task;

/**
 *  根据URL，获取视频信息
 *
 *  @param url                   url链接地址
 */
- (void)fetchURL:(NSString *)url;

/**
 *  根据临时name文件分析，重新下载
 *
 *  @param namePath 视频基本属性文件路径
 */
- (void)fetchName:(NSString *)namePath;

- (void)stopFetchURL;

/**
 *  根据视频列表ID选择性下载
 *
 *  @param videoLocation              下载视频存放的路径
 *  @param videoFormatID              下载对应分辨率视频，默认下载最好的，videoFormatID = nil
 *  @param videoID                    下载选择的视频
 */
- (void)downloadVideoLocation:(NSString *)videoLocation withVideoEntity:(VideoBaseInfoEntity *)videoEntity withDelegate:(id)delegate;
- (void)redownloadVideoLocation:(NSString *)videoLocation withVideoEntity:(VideoBaseInfoEntity *)videoEntity;

/**
 *  获取分析视频实体数组
 *
 *  @return 实体数据源
 */
- (NSMutableArray *)VideoEntityDataSource;

/**
 *  移除视频缓存文件
 */
- (void)removeVideoCacheFile:(VideoBaseInfoEntity *)entityCacheFile;

@end

//
//  VDLMonitor.h
//  
//
//  Created by JGehry on 12/20/16.
//
//

#import <Foundation/Foundation.h>
#import "VideoBaseInfoEntity.h"
@class VDLManager;

@protocol VideoDownloadProgressCallBack
@required

/**
 *  下载进度状态值
 *
 *  @param percentValue 当前进度百分比
 *  @param speed        当前下载进度网速
 *  @param time         当前视频剩余时间
 */
- (void)VDLProgress:(float)percentValue withSpeed:(NSString *)speed withResidualTime:(NSString *)time;

/**
 *  下载完成状态值
 *
 *  @param complete 下载已完成
 */
- (void)VDLProgressComplete:(NSString *)complete  Video:(VideoBaseInfoEntity *)video;

/**
 *  下载视频异常
 *
 *  @param errorStr 异常信息
 */
- (void)VDLDownloadException:(NSString *)errorStr  Video:(VideoBaseInfoEntity *)video;
@optional

/**
 *  分段的视频
 *
 *  @param currentInt 当前分段的数值
 *  @param totalInt   分段视频的总数值
 */
- (void)VDLProgressCurrentPart:(int)currentInt withTotal:(int)totalInt;

@end

@interface VDLMonitor : NSObject {
    VDLManager *_vDLManager;
    VideoBaseInfoEntity *_vMonitorEntity;
    id _vDLDelegate;
    BOOL _isPart;
    
    int _currentInt;              //当前分段视频的数值
    int _totalInt;                //分段视频的总数值
    float partPercentValue;       //当前分段视频的百分比
    float percentValue;           //当前视频百分比
}

@property (nonatomic, readwrite, assign) id vDLDelegate;
@property (nonatomic, readwrite, retain) VideoBaseInfoEntity *vMonitorEntity;
@property (nonatomic, assign) BOOL isPart;
@property (nonatomic, assign) int currentInt;
@property (nonatomic, assign) int totalInt;

- (void)startMonitor:(VideoBaseInfoEntity *)entity withDelegate:(id)delegate withFileHandle:(NSFileHandle *)fh withTask:(NSTask *)task withCacheNamePath:(NSString *)namePath withCachePath:(NSString *)path withIsPaused:(BOOL)isPaused;

@end

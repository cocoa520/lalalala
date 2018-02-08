//
//  VideoBaseInfoEntity.h
//  
//
//  Created by JGehry on 12/16/16.
//
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
typedef enum DownloadState
{
    Downloading = 0,
    DownloadFaild,
    DownloadFinish,
    TransferWait,
    TransferPrePare,
    Transfering,
    TransferWillFnish,
    TransferFinishFail,
    TransferFinishSuccess,
}DownloadState;

@interface VideoBaseInfoEntity : NSObject {
    NSString *_vID;
    NSString *_vFormatID;
    NSString *_vVideoID;
    NSString *_vName;
    NSString *_vType;
    NSString *_vSize;
    NSString *_vDuration;
    NSString *_vThumbnailPath;
    NSString *_vResolution;
    NSString *_vResolutionMode;
    NSImage *_vThumbnail;
    NSMutableArray *_kindOfVideoArray;
    NSTask *_vTask;
    NSString *_vCacheNamePath;
    NSString *_vCachePKLBeforePath;
    NSString *_vCachePKLPath;
    NSString *_progressText;
    NSString *_vDownloadPath;
    NSString *_vDownlaodBeforePath;
    double _progressDoubleValue;//下载进度
    double _tranferprogressValue;//传输进度
    NSString *_merger;//正在合并视频
    BOOL _isPaused;
    BOOL _isMuitlVideo;
    NSFileManager *fm;
    id _transferDelegate;
    id _transfer;
    DownloadState _downloadState;
    
    BOOL _isFileExist;
    NSString *_parseURL;
    BOOL _isToMac;
    NSOperation *_operaiton;
}



/**
 *  vID                  单视频的唯一ID值
 *  vFormatID            选择视频不同分辨率的ID值
 *  vVideoID             选择多视频ID值
 *  vName                视频名称
 *  vType                视频类型
 *  vSize                视频大小
 *  vDuration            视频时长
 *  vThumbnailPath       视频缩略图路径
 *  vResolution          视频分辨率
 *  vResolutionMode      视频分辨率模式（270p, 360p, 480p, 720, 1080p）
 *  vThumbnail           视频缩略图
 *  kindOfVideoArray     存放不同视频帧率数组
 *  vTask                当前实体对象任务
 *  vCacheNamePath        未成功下载视频前临时存放缓存文件路径
 *  vCachePKLBeforePath  未成功下载视频前临时存放缓存文件的上一级路径
 *  vCachePKLPath        未成功下载视频前临时存放缓存文件路径
 */
@property (nonatomic,assign) DownloadState downloadState;
@property (nonatomic,assign)NSOperation *operaiton;
@property (nonatomic, readwrite, retain) NSString *vID;
@property (nonatomic, readwrite, retain) NSString *progressText;
@property (nonatomic, readwrite, retain) NSString *vFormatID;
@property (nonatomic, readwrite, retain) NSString *vVideoID;
@property (nonatomic, readwrite, retain) NSString *vName;
@property (nonatomic, readwrite, retain) NSString *vType;
@property (nonatomic, readwrite, retain) NSString *vSize;
@property (nonatomic, readwrite, retain) NSString *vDuration;
@property (nonatomic, readwrite, retain) NSString *vThumbnailPath;
@property (nonatomic, readwrite, retain) NSString *vResolution;
@property (nonatomic, readwrite, retain) NSString *vResolutionMode;

@property (nonatomic, readwrite, retain) NSImage *vThumbnail;
@property (nonatomic, readwrite, retain) NSMutableArray *kindOfVideoArray;

@property (nonatomic, readwrite, retain) NSTask *vTask;
@property (nonatomic, readwrite, retain) NSString *vCacheNamePath;
@property (nonatomic, readwrite, retain) NSString *vCachePKLBeforePath;
@property (nonatomic, readwrite, retain) NSString *vCachePKLPath;
@property (nonatomic, readwrite, retain) NSString *vDownloadPath;
@property (nonatomic, readwrite, retain) NSString *vDownlaodBeforePath;
@property (nonatomic, assign) double progressDoubleValue;
@property (nonatomic, assign) double tranferprogressValue;
@property (nonatomic, readwrite, retain) NSString *merger;
@property (nonatomic,assign) BOOL isPaused;
@property (nonatomic,assign) BOOL isMuitlVideo;
@property (nonatomic,assign) id transferDelegate;
@property (nonatomic,assign) id transfer;
@property (nonatomic,assign) BOOL isFileExist;
@property (nonatomic,readwrite, retain) NSString *parseURL;
@property (nonatomic,assign) BOOL isToMac;
/**
 *  暂停任务
 */
- (void)suspendMonitorEntity;

/**
 *  恢复任务
 */
- (void)resumeMonitorEntity;

/**
 *  停止任务
 */
- (void)stopMonitorEntity;

@end

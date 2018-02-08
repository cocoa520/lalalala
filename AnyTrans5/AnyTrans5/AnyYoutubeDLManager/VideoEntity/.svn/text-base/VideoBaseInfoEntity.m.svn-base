//
//  VideoBaseInfoEntity.m
//  
//
//  Created by JGehry on 12/16/16.
//
//

#import "VideoBaseInfoEntity.h"

@implementation VideoBaseInfoEntity

@synthesize vID = _vID;
@synthesize vFormatID = _vFormatID;
@synthesize vVideoID = _vVideoID;
@synthesize vName = _vName;
@synthesize vType = _vType;
@synthesize vSize = _vSize;
@synthesize vDuration = _vDuration;
@synthesize vThumbnailPath = _vThumbnailPath;
@synthesize vResolution = _vResolution;
@synthesize vResolutionMode = _vResolutionMode;
@synthesize vThumbnail = _vThumbnail;
@synthesize kindOfVideoArray = _kindOfVideoArray;
@synthesize vTask = _vTask;
@synthesize vCacheNamePath = _vCacheNamePath;
@synthesize vCachePKLBeforePath = _vCachePKLBeforePath;
@synthesize vCachePKLPath = _vCachePKLPath;
@synthesize progressDoubleValue = _progressDoubleValue;
@synthesize progressText = _progressText;
@synthesize vDownloadPath = _vDownloadPath;
@synthesize vDownlaodBeforePath = _vDownlaodBeforePath;
@synthesize isPaused = _isPaused;
@synthesize isMuitlVideo = _isMuitlVideo;
@synthesize tranferprogressValue = _tranferprogressValue;
@synthesize transferDelegate = _transferDelegate;
@synthesize transfer = _transfer;
@synthesize downloadState = _downloadState;
@synthesize isFileExist = _isFileExist;
@synthesize isToMac = _isToMac;
@synthesize parseURL = _parseURL;
@synthesize operaiton = _operaiton;
@synthesize merger = _merger;
- (void)dealloc
{
    [self setParseURL:nil];
    [self setVID:nil];
    [self setVFormatID:nil];
    [self setVVideoID:nil];
    [self setVName:nil];
    [self setVType:nil];
    [self setVSize:nil];
    [self setVDuration:nil];
    [self setVThumbnailPath:nil];
    [self setVResolution:nil];
    [self setVResolutionMode:nil];
    [self setVThumbnail:nil];
    [self setKindOfVideoArray:nil];
    [self setVTask:nil];
    [self setVCacheNamePath:nil];
    [self setVCachePKLBeforePath:nil];
    [self setVCachePKLPath:nil];
    [self setParseURL:nil];
    [_progressText release],_progressText = nil;
    [_transfer release],_transfer = nil;
    [self setVDownloadPath:nil];
    [self setVDownlaodBeforePath:nil];
    [self setMerger:nil];
    [super dealloc];
}

- (instancetype)init
{
    if (self = [super init]) {
        _kindOfVideoArray = [[NSMutableArray alloc] init];
        _isMuitlVideo = NO;
        _isToMac = YES;
        _isFileExist = YES;
        _tranferprogressValue = 0;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self dealloc];
#endif
        return nil;
    }
}

- (id)copy
{
    VideoBaseInfoEntity *entity = [[VideoBaseInfoEntity alloc] init];
    entity.vID = _vID;
    entity.vFormatID = _vFormatID;
    entity.vVideoID = _vVideoID;
    entity.vName = _vName;
    entity.vType = _vType;
    entity.vSize = _vSize;
    entity.vDuration = _vDuration;
    entity.vThumbnailPath = _vThumbnailPath;
    entity.vResolution = _vResolution;
    entity.vResolutionMode = _vResolutionMode;
    entity.vThumbnail = _vThumbnail;
    entity.kindOfVideoArray = _kindOfVideoArray;
    entity.progressDoubleValue = 0.0;
    entity.parseURL = _parseURL;
    entity.isMuitlVideo = YES;
    return entity;
}

- (void)suspendMonitorEntity {
    if (!self.isPaused && [self.vTask isRunning]) {
        [self.vTask suspend];
        self.isPaused = YES;
    }
}

- (void)resumeMonitorEntity {
    if (self.isPaused) {
        [self.vTask resume];
        self.isPaused = NO;
    }
}

- (void)stopMonitorEntity {
    if ([self.vTask isRunning]) {
        [self.vTask terminate];
    }
    fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.vDownloadPath]) {
        [fm removeItemAtPath:self.vDownloadPath error:nil];
    }
}

- (void)setProgressDoubleValue:(double)progressDoubleValue
{
    if (_progressDoubleValue < progressDoubleValue) {
        _progressDoubleValue = progressDoubleValue;
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageDownLoadProgressTips", nil),progressDoubleValue];
        [self setProgressText:str];
    }
}

- (void)setTranferprogressValue:(double)tranferprogressValue
{
    _tranferprogressValue = tranferprogressValue;
    NSLog(@"tranferprogressValue:%f",tranferprogressValue);
}

- (void)setMerger:(NSString *)merger {
    _merger = merger;
    [self setProgressText:merger];
}

#pragma mark - TransferDelegate
- (void)transferPrepareFileStart:(NSString *)file
{
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:Video:)]) {
        [_transferDelegate transferPrepareFileStart:file Video:self];
    }
}

- (void)transferPrepareFileEnd
{
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd:)]) {
        [_transferDelegate transferPrepareFileEnd:self];
    }
}
- (void)transferProgress:(float)progress
{
   dispatch_async(dispatch_get_main_queue(), ^{
       if (progress>=100) {
           if ([_transferDelegate respondsToSelector:@selector(transferTo100:)]) {
               [_transferDelegate transferTo100:self];
           }
       }
       [self setTranferprogressValue:progress];
       NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageImportProgressTips", nil),progress];
       [self setProgressText:str];
   });
}



- (void)transferFile:(NSString *)file
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (file != nil) {
            [self setProgressText:file];
        }
    });
}
- (void)parseProgress:(float)progress
{
   
}
- (void)parseFile:(NSString *)file
{
   
}
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount
{
    if ([_transferDelegate respondsToSelector:@selector(transferComplete: TotalCount: Video:)]) {
        [_transferDelegate transferComplete:successCount TotalCount:totalCount Video:self];
    }
}

@end

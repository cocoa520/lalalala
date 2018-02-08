//
//  VDLManager.m
//  
//
//  Created by JGehry on 12/16/16.
//
//

#import "VDLManager.h"
#import "VDLMonitor.h"
#import "IMBNotificationDefine.h"
#import "TempHelper.h"
#import "StringHelper.h"

@implementation VDLManager
@synthesize addStr = _addStr;
@synthesize vCacheLocation = _vCacheLocation;
@synthesize vFetchDelegate = _vFetchDelegate;
@synthesize vEntityMutableArray = _vEntityMutableArray;
@synthesize task = _task;

- (void)dealloc
{
    [self setAddStr:nil];
    [self setVCacheLocation:nil];
    [self setVEntityMutableArray:nil];
    [super dealloc];
}

- (instancetype)init
{
    if (self = [super init]) {
        _vEntityMutableArray = [[NSMutableArray alloc] init];
        [self setCacheVideoDefaultLocation];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self dealloc];
#endif
        return nil;
    }
}

#pragma mark 设置视频缓存默认路径
- (void)setCacheVideoDefaultLocation {
    NSString *downloadPath = [TempHelper getAppDownloadDefaultPath];
    _vCacheLocation = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@", downloadPath]];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *downloadPath = [[[[fm URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path] stringByAppendingPathComponent:@"AnytransYoutubeDL"];
//    if (![fm fileExistsAtPath:downloadPath]) {
//        [fm createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    
}

#pragma mark 抓取网页分析视频信息
- (void)fetchURL:(NSString *)url {
    if (_addStr) {
        [_addStr release];
        _addStr = nil;
    }
    _addStr = [[NSMutableString alloc] init];
    [_vEntityMutableArray removeAllObjects];
    _task = [[NSTask alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AnyTransVDL" ofType:@""];
    [_task setLaunchPath:path];
    [_task setArguments: [NSArray arrayWithObjects:@"url", url, _vCacheLocation, nil]];
    NSPipe *p = [NSPipe pipe];
    [_task setStandardOutput:p];
    NSFileHandle *fh = [p fileHandleForReading];
    [fh waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedURLData:) name:NSFileHandleDataAvailableNotification object:fh];
    [_task launch];
    [_task waitUntilExit];
    int status = [_task terminationStatus];
    if (status == 0) {
        NSLog(@"Task succeeded.");
    } else {
        NSLog(@"Task failed.");
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleDataAvailableNotification object:fh];
    [_task terminate];
    [_task release];
}

#pragma mark 下载视频
- (void)redownloadVideoLocation:(NSString *)videoLocation withVideoEntity:(VideoBaseInfoEntity *)videoEntity
{
    [self downloadVideoLocation:videoLocation withVideoEntity:videoEntity withDelegate:_delegate];
}

- (void)downloadVideoLocation:(NSString *)videoLocation withVideoEntity:(VideoBaseInfoEntity *)videoEntity withDelegate:(id)delegate {
    _delegate = delegate;
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"AnyTransVDL" ofType:@""]];
    NSFileManager *fm = [NSFileManager defaultManager];
    videoLocation = [videoLocation stringByAppendingPathComponent:CustomLocalizedString(@"VideoDownload_Path", nil)];
    if (![fm fileExistsAtPath:videoLocation]) {
        [fm createDirectoryAtPath:videoLocation withIntermediateDirectories:YES attributes:nil error:nil];
    }
    videoEntity.vDownlaodBeforePath = videoLocation;
    NSString *realVideoPath = nil;
    NSString *videoLocationPath = [NSString stringWithFormat:@"%@", videoLocation];
    if ([fm fileExistsAtPath:videoLocationPath isDirectory:NO]) {
        NSString *videoNamePath = [videoLocationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", videoEntity.vName]];
        if (![fm fileExistsAtPath:videoNamePath]) {
            realVideoPath = videoNamePath;
            [fm createDirectoryAtPath:realVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
        }else {
            realVideoPath = [TempHelper getFolderPathAlias:videoNamePath];
            [fm createDirectoryAtPath:realVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    videoEntity.vDownloadPath = realVideoPath;
    if ([videoEntity.vFormatID isEqualToString:@""] || videoEntity.vFormatID == nil) {
        if (videoEntity.isMuitlVideo) {
            [task setArguments: [NSArray arrayWithObjects:@"down", [NSString stringWithFormat:@"%@/%@/%@.pkl", _vCacheLocation, videoEntity.vID, videoEntity.vVideoID], [NSString stringWithFormat:@"%@/", videoEntity.vDownloadPath], @"#", videoEntity.vVideoID, videoEntity.vID, nil]];
        }else {
            [task setArguments: [NSArray arrayWithObjects:@"down", [NSString stringWithFormat:@"%@/%@/%@.pkl", _vCacheLocation, videoEntity.vID, videoEntity.vID], [NSString stringWithFormat:@"%@/", videoEntity.vDownloadPath], @"#", videoEntity.vVideoID, videoEntity.vID, nil]];
        }
    }else {
        [task setArguments: [NSArray arrayWithObjects:@"down", [NSString stringWithFormat:@"%@/%@/%@.pkl", _vCacheLocation, videoEntity.vID, videoEntity.vID], [NSString stringWithFormat:@"%@/", videoEntity.vDownloadPath], videoEntity.vFormatID, videoEntity.vVideoID, videoEntity.vID, nil]];
    }
    NSPipe *p = [NSPipe pipe];
    [task setStandardOutput:p];
    NSFileHandle *fh = [p fileHandleForReading];
    [fh waitForDataInBackgroundAndNotify];
    VDLMonitor *vMonitor = [[VDLMonitor alloc] init];
    [vMonitor startMonitor:videoEntity withDelegate:delegate withFileHandle:fh withTask:task withCacheNamePath:[NSString stringWithFormat:@"%@/%@/%@_name", _vCacheLocation, videoEntity.vID, videoEntity.vID] withCachePath:[NSString stringWithFormat:@"%@/%@/%@.pkl", _vCacheLocation, videoEntity.vID, videoEntity.vID] withIsPaused:NO];
    [task launch];
    [task waitUntilExit];
    int status = [task terminationStatus];
    if (status == 0) {
        NSLog(@"Task succeeded.");
    } else {
        NSLog(@"Task failed.");
    }
    [vMonitor release];
    [task release];
}


#pragma mark 接受通知信息
- (void)receivedURLData:(NSNotification *)notification {
    NSFileHandle *fh = [notification object];
    NSData *data = [fh availableData];
    if (data.length > 0) { // if data is found, re-register for more data (and print)
        [fh waitForDataInBackgroundAndNotify];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (![StringHelper stringIsNilOrEmpty:str]) {
            [_addStr appendString:str];
        }
        if([str rangeOfString:@"Unsupported URL"].location != NSNotFound) {
            NSString *errorUrlStr = [[str componentsSeparatedByString:@"Unsupported URL"] objectAtIndex:1];
            NSString *errorStr = [@"Unsupported URL" stringByAppendingString:errorUrlStr];
            if (self.vFetchDelegate != nil && [self.vFetchDelegate respondsToSelector:@selector(VDLFetchException:)]) {
                [self.vFetchDelegate VDLFetchException:errorStr];
            }
        }else if ([str rangeOfString:@"ERROR"].location != NSNotFound) {
            if (self.vFetchDelegate != nil && [self.vFetchDelegate respondsToSelector:@selector(VDLFetchException:)]) {
                [self.vFetchDelegate VDLFetchException:str];
            }
        }else if ([str rangeOfString:@"WARNING"].location != NSNotFound) {
            if (self.vFetchDelegate != nil && [self.vFetchDelegate respondsToSelector:@selector(VDLFetchException:)]) {
                [self.vFetchDelegate VDLFetchException:str];
            }
        }else if ([str rangeOfString:@"Invalid result type"].location != NSNotFound) {
            if (self.vFetchDelegate != nil && [self.vFetchDelegate respondsToSelector:@selector(VDLFetchException:)]) {
                [self.vFetchDelegate VDLFetchException:@"Invalid result type"];
            }
        }else if ([str rangeOfString:@"write_fileInfo_finished"].location != NSNotFound) {
            if (_addStr) {
                NSDictionary *dict = @{@"write_finished": _addStr};
                [self saveVideoBaseInfo:dict];
            }
        }
    }
}

- (void)saveVideoBaseInfo:(NSDictionary *)dict {
    NSString *videoInfo = [dict objectForKey:@"write_finished"];
    if ([videoInfo rangeOfString:@"videoID:"].location != NSNotFound) {
        NSString *str = [[[[videoInfo componentsSeparatedByString:@"videoID:"] objectAtIndex:1] componentsSeparatedByString:@"\n"] objectAtIndex:0];
        [self fetchName:[NSString stringWithFormat:@"%@/%@/%@_name", _vCacheLocation, str, str]];
    }
}

- (void)fetchName:(NSString *)namePath {
    NSMutableArray *dataAry = [NSMutableArray array];
    NSString *dataStr = [[NSString alloc] initWithContentsOfFile:namePath encoding:NSUTF8StringEncoding error:nil];
    if ([dataStr rangeOfString:@"$$$"].location != NSNotFound) {
        if ([dataStr rangeOfString:@"playlist_generator"].location != NSNotFound) {
            VideoBaseInfoEntity *vBIEntity = [[VideoBaseInfoEntity alloc] init];
            NSArray *tmpAry1 = [[[dataStr componentsSeparatedByString:@"$$$"] objectAtIndex:0] componentsSeparatedByString:@"\n"];
            [vBIEntity setVID:[tmpAry1 objectAtIndex:0]];
            [vBIEntity setParseURL:[tmpAry1 objectAtIndex:2]];
            NSArray *tmpAry2 = [[[[dataStr componentsSeparatedByString:@"$$$"] objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@"\n"];
            [vBIEntity setVVideoID:[tmpAry2 objectAtIndex:0]];
            [vBIEntity setVName:[tmpAry2 objectAtIndex:1]];
            NSString *vType = [tmpAry2 objectAtIndex:2];
            if ([vType isEqualToString:@"unknown"]) {
                [vBIEntity setVType:@""];
            }else {
                [vBIEntity setVType:vType];
            }
            [_vEntityMutableArray addObject:vBIEntity];
        }else {
            NSArray *playlistAry = [dataStr componentsSeparatedByString:@"$$$"];
            for (NSString *data in playlistAry) {
                NSString *tmpData = [data stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (![tmpData isEqualToString:@""]) {
                    VideoBaseInfoEntity *vBIEntity = [[VideoBaseInfoEntity alloc] init];
                    dataAry = [[tmpData componentsSeparatedByString:@"\n"] mutableCopy];
                    if ([dataAry count] > 9) {
                        for (int i = 0; i < [dataAry count] - 1; i++) {
                            if (i < 9) {
                                continue;
                            }
                            [vBIEntity.kindOfVideoArray addObject:[dataAry objectAtIndex:i]];
                        }
                    }
                    [vBIEntity setVID:[dataAry objectAtIndex:0]];
                    [vBIEntity setVName:[dataAry objectAtIndex:1]];
                    NSString *vSize = [dataAry objectAtIndex:2];
                    if ([vSize isEqualToString:@"0"]) {
                        [vBIEntity setVSize:@""];
                    }else {
                        [vBIEntity setVSize:vSize];
                    }
                    NSString *vType = [dataAry objectAtIndex:3];
                    if ([vType isEqualToString:@"unknown"]) {
                        [vBIEntity setVType:@""];
                    }else {
                        [vBIEntity setVType:vType];
                    }
                    [vBIEntity setVThumbnailPath:[dataAry objectAtIndex:5]];
                    if (![vBIEntity.vThumbnailPath isEqualToString:@"unknown"]) {
                        [vBIEntity setVThumbnail:[[NSImage alloc] initWithContentsOfFile:vBIEntity.vThumbnailPath]];
                    }
                    NSTimeInterval time = [[dataAry objectAtIndex:6] doubleValue];
                    [self CalculateTime:time withBIEntity:vBIEntity];
                    [vBIEntity setVVideoID:[dataAry objectAtIndex:7]];
                    [vBIEntity setParseURL:[dataAry objectAtIndex:8]];
                    if ([vBIEntity.kindOfVideoArray count] > 0) {
                        NSArray *bestVideo = [[vBIEntity.kindOfVideoArray lastObject] componentsSeparatedByString:@"#"];
                        NSString *vFps = [bestVideo objectAtIndex:2];
                        NSString *vResolutionWidth = [bestVideo objectAtIndex:3];
                        NSString *vResolutionHeight = [bestVideo objectAtIndex:4];
                        if ([vFps isEqualToString:@"unknown"] && ([vResolutionWidth isEqualToString:@"unknown"] || [vResolutionHeight isEqualToString:@"unknown"])) {
                            [vBIEntity setVResolutionMode:@""];
                        }else if ([vFps isEqualToString:@"unknown"] || !([vFps rangeOfString:@"p"].location != NSNotFound)) {
                            NSString *width = [bestVideo objectAtIndex:3];
                            NSString *height = [bestVideo objectAtIndex:4];
                            [vBIEntity setVResolutionMode:[NSString stringWithFormat:@"%@ x %@", width, height]];
                        }else if (vFps == nil) {
                            [vBIEntity setVResolutionMode:@""];
                        }else {
                            [vBIEntity setVResolutionMode:vFps];
                        }
                        NSTimeInterval time = [[dataAry objectAtIndex:6] doubleValue];
                        [self CalculateTime:time withBIEntity:vBIEntity];
                    }
                    [vBIEntity setVCachePKLBeforePath:[[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:vBIEntity.vID]];
                    [_vEntityMutableArray addObject:vBIEntity];
                }
            }
        }
    }else {
        VideoBaseInfoEntity *vBIEntity = [[VideoBaseInfoEntity alloc] init];
        dataAry = [[dataStr componentsSeparatedByString:@"\n"] mutableCopy];
        if ([dataAry count] > 9) {
            for (int i = 0; i < [dataAry count] - 1; i++) {
                if (i < 9) {
                    continue;
                }
                [vBIEntity.kindOfVideoArray addObject:[dataAry objectAtIndex:i]];
            }
        }
        [vBIEntity setVID:[dataAry objectAtIndex:0]];
        [vBIEntity setVName:[dataAry objectAtIndex:1]];
        NSString *vSize = [dataAry objectAtIndex:2];
        if ([vSize isEqualToString:@"0"]) {
            [vBIEntity setVSize:@""];
        }else {
            [vBIEntity setVSize:vSize];
        }
        NSString *vType = [dataAry objectAtIndex:3];
        if ([vType isEqualToString:@"unknown"]) {
            [vBIEntity setVType:@""];
        }else {
            [vBIEntity setVType:vType];
        }
        [vBIEntity setVThumbnailPath:[dataAry objectAtIndex:5]];
        if (![vBIEntity.vThumbnailPath isEqualToString:@"unknown"]) {
            [vBIEntity setVThumbnail:[[NSImage alloc] initWithContentsOfFile:vBIEntity.vThumbnailPath]];
        }
        NSTimeInterval time = [[dataAry objectAtIndex:6] doubleValue];
        [self CalculateTime:time withBIEntity:vBIEntity];
        [vBIEntity setVVideoID:[dataAry objectAtIndex:7]];
        [vBIEntity setParseURL:[dataAry objectAtIndex:8]];
        if ([vBIEntity.kindOfVideoArray count] > 0) {
            NSArray *bestVideo = [[vBIEntity.kindOfVideoArray lastObject] componentsSeparatedByString:@"#"];
            NSString *vFps = [bestVideo objectAtIndex:2];
            NSString *vResolutionWidth = [bestVideo objectAtIndex:3];
            NSString *vResolutionHeight = [bestVideo objectAtIndex:4];
            if ([vFps isEqualToString:@"unknown"] && ([vResolutionWidth isEqualToString:@"unknown"] || [vResolutionHeight isEqualToString:@"unknown"])) {
                [vBIEntity setVResolutionMode:@""];
            }else if ([vFps isEqualToString:@"unknown"] || !([vFps rangeOfString:@"p"].location != NSNotFound)) {
                NSString *width = [bestVideo objectAtIndex:3];
                NSString *height = [bestVideo objectAtIndex:4];
                [vBIEntity setVResolutionMode:[NSString stringWithFormat:@"%@ x %@", width, height]];
            }else if (vFps == nil) {
                [vBIEntity setVResolutionMode:@""];
            }else {
                [vBIEntity setVResolutionMode:vFps];
            }
        }
        [_vEntityMutableArray addObject:vBIEntity];
        [dataAry release];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_WRITE_FILEINFO_FINISHED object:nil userInfo:nil];
}

- (void)stopFetchURL {
    if ([self.task isRunning]) {
        [self.task terminate];
    }
}

- (void)CalculateTime:(NSTimeInterval)time withBIEntity:(VideoBaseInfoEntity *)entity {
    NSString *duration = nil;
    if (time == 0) {
        [entity setVDuration:@""];
    }else {
        NSString *hourStr = nil;
        NSString *minStr = nil;
        NSString *secStr = nil;
        if (time > 0 && time < 60) {
            NSInteger sec = (NSInteger)time%60;
            minStr = @"00";
            if (sec < 10) {
                secStr = [NSString stringWithFormat:@"0%d", sec];
            }else {
                secStr = [NSString stringWithFormat:@"%i", sec];
            }
            duration = [NSString stringWithFormat:@"%@:%@", minStr, secStr];
        }else if (time > 60 && time < 3600) {
            NSInteger min = time/60;
            NSInteger sec = (NSInteger)time%60;
            if (min < 10) {
                minStr = [NSString stringWithFormat:@"0%d", min];
            }else {
                minStr = [NSString stringWithFormat:@"%i", min];
            }
            if (sec < 10) {
                secStr = [NSString stringWithFormat:@"0%d", sec];
            }else {
                secStr = [NSString stringWithFormat:@"%i", sec];
            }
            duration = [NSString stringWithFormat:@"%@:%@", minStr, secStr];
        }else if(time >= 3600 ) {
            NSInteger hour = time/3600;
            NSInteger min = (NSInteger)time%3600/60;
            NSInteger sec = (NSInteger)time%3600%60;
            if (hour < 10) {
                hourStr = [NSString stringWithFormat:@"0%d", hour];
            }else {
                hourStr = [NSString stringWithFormat:@"%i", hour];
            }
            if (min < 10) {
                minStr = [NSString stringWithFormat:@"0%d", min];
            }else {
                minStr = [NSString stringWithFormat:@"%i", min];
            }
            if (sec < 10) {
                secStr = [NSString stringWithFormat:@"0%d", sec];
            }else {
                secStr = [NSString stringWithFormat:@"%i", sec];
            }
            duration = [NSString stringWithFormat:@"%@:%@:%@", hourStr, minStr, secStr];
        }
        [entity setVDuration:duration];
    }
}

- (NSMutableArray *)VideoEntityDataSource {
    if ([_vEntityMutableArray count] > 0) {
        return _vEntityMutableArray;
    }else {
        return [[[NSMutableArray alloc] init] autorelease];
    }
}

- (void)removeVideoCacheFile:(VideoBaseInfoEntity *)entityCacheFile {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@/%@_name", _vCacheLocation, entityCacheFile.vID, entityCacheFile.vID] error:nil];
}

@end

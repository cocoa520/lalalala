//
//  VDLMonitor.m
//  
//
//  Created by JGehry on 12/20/16.
//
//

#import "VDLMonitor.h"
#import "TempHelper.h"
#import "IMBAMFileSystem.h"
#import "IMBNotificationDefine.h"

@implementation VDLMonitor
@synthesize vDLDelegate = _vDLDelegate;
@synthesize vMonitorEntity = _vMonitorEntity;
@synthesize isPart = _isPart;
@synthesize currentInt = _currentInt;
@synthesize totalInt = _totalInt;

- (void)dealloc
{
    [self setVMonitorEntity:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleDataAvailableNotification object:nil];
    [super dealloc];
}

- (instancetype)init
{
    if (self = [super init]) {
        _isPart = NO;
        _currentInt = 0;
        _totalInt = 0;
        partPercentValue = 0.0;
        percentValue = 0.0;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self dealloc];
#endif
        return nil;
    }
}

- (void)startMonitor:(VideoBaseInfoEntity *)entity withDelegate:(id)delegate withFileHandle:(NSFileHandle *)fh withTask:(NSTask *)task withCacheNamePath:(NSString *)namePath withCachePath:(NSString *)path withIsPaused:(BOOL)isPaused {
    _vDLDelegate = delegate;
    _vMonitorEntity = [entity retain];
    _vMonitorEntity.vTask = task;
    _vMonitorEntity.isPaused = isPaused;
    _vMonitorEntity.vCacheNamePath = namePath;
    _vMonitorEntity.vCachePKLPath = path;
    _vMonitorEntity.vCachePKLBeforePath = [path stringByDeletingLastPathComponent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedVideoData:) name:NSFileHandleDataAvailableNotification object:fh];
}

- (void)receivedVideoData:(NSNotification *)notification {
    NSFileHandle *fh = [notification object];
    NSData *data = [fh availableData];
    if (data.length > 0) { // if data is found, re-register for more data (and print)
        [fh waitForDataInBackgroundAndNotify];
        __block NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"Anytrans_downloading_video"].location != NSNotFound) {
            NSLog(@"#######%@", str);
            NSString *vIDTmp = [[[[str componentsSeparatedByString:@"Anytrans_downloading_video:"] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
            if ([vIDTmp isEqualToString:_vMonitorEntity.vID]) {
                _isPart = YES;
                partPercentValue = percentValue;
                NSString *tmpStr = [[str componentsSeparatedByString:@"Anytrans_downloading_video:"] objectAtIndex:1];
                _currentInt = [[[[[tmpStr componentsSeparatedByString:@"of"] objectAtIndex:0] componentsSeparatedByString:@" "] objectAtIndex:1] intValue];
                _totalInt = [[[str componentsSeparatedByString:@"of"] lastObject] intValue];
                if (self.vDLDelegate != nil && [self.vDLDelegate respondsToSelector:@selector(VDLProgressCurrentPart:withTotal:)]) {
                    [self.vDLDelegate VDLProgressCurrentPart:_currentInt withTotal:_totalInt];
                }
            }
        }else if ([str rangeOfString:@"Anytrans_download_process:"].location != NSNotFound) {
            NSString *vIDTmp = [[[[str componentsSeparatedByString:@"Anytrans_download_process:"] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
            if ([vIDTmp isEqualToString:_vMonitorEntity.vID]) {
                __block NSString *progressStr = [[str componentsSeparatedByString:_vMonitorEntity.vID] objectAtIndex:1];
                [progressStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (!([progressStr rangeOfString:@"100%"].location != NSNotFound)) {
                    if (_isPart) {
                        float tmpPartPercentValue = [[[progressStr componentsSeparatedByString:@"of"]
                                                      objectAtIndex:0] floatValue];
                        if ( (partPercentValue + ((float)tmpPartPercentValue / _totalInt))>=percentValue) {
                            percentValue = (partPercentValue + ((float)tmpPartPercentValue / _totalInt));
                        }
                    }else {
                        float tmpPercentValue = [[[progressStr componentsSeparatedByString:@"of"] objectAtIndex:0] floatValue];
                        if (tmpPercentValue >= percentValue) {
                            percentValue = [[[progressStr componentsSeparatedByString:@"of"] objectAtIndex:0] floatValue];
                        }
                    }
                    NSString *speed = [[[[progressStr componentsSeparatedByString:@"ETA"] objectAtIndex:0] componentsSeparatedByString:@"at"] lastObject];
                    if ([speed isEqualToString:@" Unknown speed "]) {
                        speed = @"Unknown";
                    }
                    NSString *residualTime = [[progressStr componentsSeparatedByString:@" "] lastObject];
                    if ([residualTime isEqualToString:@"ETA"]) {
                        residualTime = @"Unknown";
                    }
                    if (self.vDLDelegate != nil && [self.vDLDelegate respondsToSelector:@selector(VDLProgress:withSpeed:withResidualTime:)]) {
                        [self.vDLDelegate VDLProgress:percentValue withSpeed:speed withResidualTime:residualTime];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (percentValue > 100) {
                            percentValue = 100.0;
                        }
                        [_vMonitorEntity setProgressDoubleValue:percentValue];
                    });
                }else {
                    if ([progressStr rangeOfString:@"0.00B"].location != NSNotFound) {
                        if (self.vDLDelegate != nil && [self.vDLDelegate respondsToSelector:@selector(VDLDownloadException:Video:)]) {
                            [self.vDLDelegate VDLDownloadException:progressStr Video:_vMonitorEntity];
                        }
                        return;
                    }
                    NSLog(@"Anytrans_download_process = %@", progressStr);
                }
            }
        }else if ([str rangeOfString:@"Anytrans_download_completed:"].location != NSNotFound) {
            NSLog(@"Anytrans_download_completed = %@", str);
            NSString *vIDTmp = [[[[str componentsSeparatedByString:@"Anytrans_download_completed:"] objectAtIndex:1] componentsSeparatedByString:@"\n"] objectAtIndex:0];
            if ([vIDTmp isEqualToString:_vMonitorEntity.vID]) {
                if (_currentInt == _totalInt) {
                    _isPart = NO;
                }
                NSString *finishStr = [[str componentsSeparatedByString:[NSString stringWithFormat:@":%@", vIDTmp]] objectAtIndex:0];
                if (!_isPart) {
                    if ([finishStr rangeOfString:@"Anytrans_download_completed"].location != NSNotFound) {
                        NSFileManager *fm = [NSFileManager defaultManager];
                        if ([fm fileExistsAtPath:_vMonitorEntity.vCachePKLBeforePath isDirectory:NO]) {
                            [fm removeItemAtPath:_vMonitorEntity.vCacheNamePath error:nil];
                        }
                        if ([fm fileExistsAtPath:_vMonitorEntity.vDownlaodBeforePath isDirectory:NO]) {
                            NSArray *fileArr = [fm contentsOfDirectoryAtPath:_vMonitorEntity.vDownloadPath error:nil];
                            if (fileArr.count == 1) {
                                NSString *resvideoName = [fileArr objectAtIndex:0];
                                NSString *videoFilePath = [_vMonitorEntity.vDownloadPath stringByAppendingPathComponent:resvideoName];
                                NSRange range = [resvideoName rangeOfString:@"." options:NSBackwardsSearch];
                                NSUInteger length1 = resvideoName.length;
                                NSUInteger length2 = range.location;
                                NSUInteger len = length1 - length2;
                                NSString *str = [resvideoName stringByReplacingOccurrencesOfString:@"." withString:@"$$$" options:NSBackwardsSearch range:NSMakeRange(length2, len)];
                                NSArray *resvideoNameAry = [str componentsSeparatedByString:@"$$$"];
                                NSString *desvideoName = nil;
                                if (resvideoNameAry.count > 1) {
                                    NSString *resvideoNameTmpIndex = [resvideoNameAry objectAtIndex:0];
                                    NSRange range = [resvideoNameTmpIndex rangeOfString:@"-" options:NSBackwardsSearch];
                                    NSUInteger length1 = resvideoNameTmpIndex.length;
                                    NSUInteger length2 = range.location;
                                    NSUInteger len = length1 - length2;
                                    NSString *resvideoNameTmp = [resvideoNameTmpIndex stringByReplacingOccurrencesOfString:@"-" withString:@"$$$" options:NSBackwardsSearch range:NSMakeRange(length2, len)];
                                    NSArray *resvideoNameTmpAry = [resvideoNameTmp componentsSeparatedByString:@"$$$"];
                                    desvideoName = [NSString stringWithFormat:@"%@.%@", [resvideoNameTmpAry objectAtIndex:0], [resvideoNameAry objectAtIndex:1]];
                                }else {
                                    desvideoName = [NSString stringWithFormat:@"%@.%@", _vMonitorEntity.vName, _vMonitorEntity.vType];
                                }
                                NSString *desPath = [_vMonitorEntity.vDownlaodBeforePath stringByAppendingPathComponent:desvideoName];
                                if (![fm fileExistsAtPath:_vMonitorEntity.vDownlaodBeforePath]) {
                                    [fm createDirectoryAtPath:_vMonitorEntity.vDownlaodBeforePath withIntermediateDirectories:YES attributes:nil error:nil];
                                }
                                if ([fm fileExistsAtPath:videoFilePath]) {
                                    if ([fm fileExistsAtPath:desPath]) {
                                        desPath = [TempHelper getFilePathAlias:desPath];
                                    }
                                    [fm moveItemAtPath:videoFilePath toPath:desPath error:nil];
                                    [fm removeItemAtPath:_vMonitorEntity.vDownloadPath error:nil];
                                    _vMonitorEntity.vDownloadPath = desPath;
                                }
                            }else if (fileArr.count > 1) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_vMonitorEntity setMerger:CustomLocalizedString(@"VideoDownload_Merging", nil)];
                                });
                                NSString *desPath = [self mergeVideo:_vMonitorEntity.vDownloadPath];
                                _vMonitorEntity.vDownloadPath = desPath;
                            }
                        }
                        if (![fm fileExistsAtPath:_vMonitorEntity.vThumbnailPath]) {
                            NSString *secs = @"00:00:07";
                            NSString *thumbnailPath = [_vMonitorEntity.vCachePKLBeforePath stringByAppendingPathComponent:@"thumbnail"];
                            NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-ss", secs, @"-i", _vMonitorEntity.vDownloadPath, @"-f", @"image2", @"-y", thumbnailPath, nil];
                            [self runFFMpeg:params];
                            
                            if ([fm fileExistsAtPath:thumbnailPath]) {
                                NSImage *image = [[NSImage alloc] initWithContentsOfFile:thumbnailPath];
                                if (image != nil) {
                                    [_vMonitorEntity setVThumbnail:image];
                                    [_vMonitorEntity setVThumbnailPath:thumbnailPath];
                                }
                                [image release];
                            }else {
                                secs = @"00:00:02";
                                thumbnailPath = [_vMonitorEntity.vCachePKLBeforePath stringByAppendingPathComponent:@"thumbnail"];
                                params = [NSMutableArray arrayWithObjects:@"-ss", secs, @"-i", _vMonitorEntity.vDownloadPath, @"-f", @"image2", @"-y", thumbnailPath, nil];
                                [self runFFMpeg:params];
                                if ([fm fileExistsAtPath:thumbnailPath]) {
                                    NSImage *image = [[NSImage alloc] initWithContentsOfFile:thumbnailPath];
                                    if (image != nil) {
                                        [_vMonitorEntity setVThumbnail:image];
                                        [_vMonitorEntity setVThumbnailPath:thumbnailPath];
                                    }
                                    [image release];
                                }
                            }
                        }
                        if (self.vDLDelegate != nil && [self.vDLDelegate respondsToSelector:@selector(VDLProgressComplete:Video:)]) {
                            [self.vDLDelegate VDLProgressComplete:[NSString stringWithFormat:@"%@\n", finishStr] Video:_vMonitorEntity];
                        }
                    }
                }
            }
        }else if ([str rangeOfString:@"ERROR"].location != NSNotFound) {
            if (self.vDLDelegate != nil && [self.vDLDelegate respondsToSelector:@selector(VDLDownloadException:Video:)]) {
                [self.vDLDelegate VDLDownloadException:str Video:_vMonitorEntity];
            }
        }
    }
}

- (NSString *)mergeVideo:(NSString *)videoPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = [videoPath stringByAppendingPathComponent:@"filelist.txt"];
    NSString *exp = @"";
    if ([fm fileExistsAtPath:videoPath]) {
        NSArray *fileArr = [fm contentsOfDirectoryAtPath:videoPath error:nil];
        NSMutableString *dataStr = [[NSMutableString alloc] init];
        for (NSString *fileName in fileArr) {
            if (![fileName hasPrefix:@"."]) {
                exp = [fileName pathExtension];
                [dataStr appendString:[NSString stringWithFormat:@"file '%@'\n",fileName]];
            }
        }
        if ([fm fileExistsAtPath:filePath]) {
            [fm removeItemAtPath:filePath error:nil];
        }
        if (dataStr != nil && ![dataStr isEqualToString:@""]) {
            [dataStr writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        }
    }
    NSString *desPath = [videoPath stringByAppendingPathExtension:exp];
    if ([fm fileExistsAtPath:filePath]) {
        NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-f", @"concat", @"-i", filePath, @"-c", @"copy", desPath, nil];
        [self runFFMpeg:params];
        if ([fm fileExistsAtPath:desPath]) {
            [fm removeItemAtPath:videoPath error:nil];
        }else {
            desPath = videoPath;
        }
    }
    return desPath;
}

- (NSString*) runFFMpeg:(NSArray*)params {
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    if (params != nil) {
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath:ffmpegPath];
        [task setArguments:params];
        //增加输出 //luolei add
        NSPipe *pipe;
        pipe = [NSPipe pipe];
        [task setStandardError:pipe];
        NSFileHandle *file = [pipe fileHandleForReading];
        [task launch];
        [task waitUntilExit];
        NSData *data;
        data = [file readDataToEndOfFile];
        NSString *result_str = [[NSString alloc] initWithData: data
                                                     encoding: NSUTF8StringEncoding];
        if (result_str == nil) {
            result_str = [[NSString alloc] initWithData: data
                                               encoding: NSNEXTSTEPStringEncoding];
        }
        [task release];
        return [result_str autorelease];
    }
    return nil;
}



@end

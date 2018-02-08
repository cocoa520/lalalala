//
//  IMBCvtMediaConvertEncoder.cs
//  iMobieTrans
//
//  Created by zhang yang on 13-5-9.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBCvtMediaConvertEncoder.h"
#import "IMBCvtEncodedMedia.h"
#import "NSString+Category.h"
#import "StringHelper.h"
#import "RegexKitLite.h"
#import "IMBNewTrack.h"
#import "SystemHelper.h"
#import "DateHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBCvtMediaConvertEncoder

- (id)init
{
    self = [super init];
    if (self) {
        iProgressErrorCount = 0;
        PROGRESS_ERROR_LIMIT = 100;
        nc = [NSNotificationCenter defaultCenter];
    }
    return self;
}

- (void)dealloc
{
    if (_ffmpegOutputStr != nil) {
        [_ffmpegOutputStr release];
    }
    [_tempEncodedMedia release],_tempEncodedMedia = nil;
    [super dealloc];
}

- (void) encodeMediaAsyncWithMediaFile:(IMBCvtMediaFileEntity*)input EncodeParas:(NSArray*)encodeParas OutputFileName:(NSString*)outputFile ThumbnailSize:(NSString*) thumbnailSize {
    //Todo 看这个地方需要mediaInfo否
    if (!input.infoGathered){
        [self getMediaInfo:input];
    }
    if (_tempEncodedMedia  != nil) {
        [_tempEncodedMedia release];
    }
    _tempEncodedMedia = [[IMBCvtEncodedMedia alloc] init];
    _tempEncodedMedia.sourceMediaPath = input.path;
    _tempEncodedMedia.encodedMediaPath = outputFile;
//    if (input.mediaType == CvtMediaFile_Video)  //在创建artwork时，重新创建获取过缩略图
//    [self createThumbnailFile:input Output:outputFile Size:thumbnailSize];
    //设置需要转换的文件信息
    _tempMediaFile = input;
    //创建转换的参数
    NSMutableArray *finalParams = [NSMutableArray arrayWithObjects:@"-i",[NSString stringWithFormat:@"%@",input.path],@"-threads",[NSString stringWithFormat:@"%d",
                                   FFMPEG_CONVERT_THREAD_COUNT],nil];
    
    [finalParams addObjectsFromArray:encodeParas];
    [finalParams addObject:[NSString stringWithFormat:@"%@",outputFile]];
    [self runFFMpegAsync:finalParams];
}

//这里不需要创建artwork的目录了

- (void) createThumbnailFile:(IMBCvtMediaFileEntity*)input Output:(NSString*)outputFile Size:(NSString*) thumbnailSize {
    NSString* thumbnailFilePath = [outputFile stringByDeletingPathExtension];
    NSString* thumbnailFileFullPath = [thumbnailFilePath stringByAppendingPathExtension:@"jpg"];
    NSLog(@"thumbnailFileFullPath %@", thumbnailFileFullPath);
    if ([self createVideoThumbnailFile:input Path:thumbnailFileFullPath Size:thumbnailSize])
    { _tempEncodedMedia.ThumbnailPath = thumbnailFileFullPath; }
}
 

- (BOOL)createVideoThumbnailFile:(IMBCvtMediaFileEntity*)input Path:(NSString*)path Size:(NSString*) thumbnailSize {
    NSString *secs = @"00:00:07";
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-ss", secs, @"-i", input.path, @"-f", @"image2", @"-y", path, nil];
    [self runFFMpeg:params];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return true;
    } else {
        return false;
    }
}

- (BOOL) getAudioThumbnailFile:(NSString*)mediaPath artworkOutPath:(NSString*)artworkPath {
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i", [NSString stringWithFormat:@"%@",mediaPath], @"-y", @"-f", @"image2", [NSString stringWithFormat:@"%@", artworkPath], nil];
    [self runFFMpeg:params];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:artworkPath]) {
        
        return true;
    } else {
        return false;
    }
}


- (void)runFFMpegAsync:(NSArray*)params {
    //需要用中文
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    if (params != nil) {
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath: ffmpegPath];
        [task setArguments:params];
        NSPipe *pipe = [NSPipe pipe];
        NSPipe *errorPipe = [NSPipe pipe];
        [task setStandardOutput:pipe];
        [task setStandardError:errorPipe];
        NSFileHandle *outFile = [pipe fileHandleForReading];
        NSFileHandle *errFile = [errorPipe fileHandleForReading];
        [outFile waitForDataInBackgroundAndNotify];
        [errFile waitForDataInBackgroundAndNotify];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ffmpegFinished:)
                                                     name:NSTaskDidTerminateNotification
                                                   object:task];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(ffmpegOutData:)
//                                                     name:NSFileHandleDataAvailableNotification
//                                                   object:outFile];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ffmpegProgressData:)
                                                     name:NSFileHandleDataAvailableNotification
                                                   object:errFile];
        [task launch];
        [task waitUntilExit];
        [task terminationStatus];
        [task release];
    }
}

- (NSString*) runFFMpeg:(NSArray*)params {
    //需要用中文
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
        //luolei add
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(ffmpegOutput:)
//                                                     name:NSFileHandleDataAvailableNotification
//                                                   object:errFile];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(terminated:)
//                                                     name:NSTaskDidTerminateNotification
//                                                   object:task];
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

-(void) ffmpegOutData: (NSNotification *) notification
{
    NSFileHandle *fh = [notification object];
    NSData *data = [fh availableData];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"ffmpegOutData:%@",str);
}


-(void)ffmpegProgressData: (NSNotification *) notification
{
    NSFileHandle *fileHandle = (NSFileHandle*) [notification object];
    NSData *data = [fileHandle availableData];
    NSString *progressStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //传给上层的应该是当前文件的进度，以及其他一些信息。
    if (progressStr != nil) {
        if ([progressStr startWithString:@"frame" options:NSCaseInsensitiveSearch] ||
            [progressStr startWithString:@"size" options:NSCaseInsensitiveSearch] ) {
            //重置错误进度数
            //iProgressErrorCount = 0;
            //设置当前转换的媒体名称
            NSString *mediaName = nil;
            mediaName = [_tempMediaFile.path lastPathComponent];
            //设置总共的帧
//            long totalFrames = _tempMediaFile.totalFrames;
            
            //frame= 5107 fps=328 q=4.0 Lsize=   11558kB time=00:02:50.40 bitrate= 555.7kbits/s dup=2551 drop=0 
            //解析当前帧
           
//            int curFrame = [self extractCurProgressFrame:progressStr];
            
            //解析当前转换的时间点位置
            double curDateTime = [self extractCurProgressSec:progressStr];
            //得到FPS
            int fps = [self extractCurProgressFPS:progressStr];
            //Todo这个地方需要判断时间是否一直都小于100毫秒。
            /*
            if (ts.TotalMilliseconds <= 100)
            {
                string strpat = ts.ToString();
                Regex re = new Regex("[T|t]ime=" + strpat + "", RegexOptions.Compiled);
                MatchCollection mc = re.Matches(tempEncodedVideo.EncodingLog);
                if (mc.Count > 20)
                { iProgressErrorCount = PROGRESS_ERROR_LIMIT; }
            }
            */
            double totalDateTime = _tempMediaFile.convertLength;
            //计算转换百分比
            int sPercentage = (int)((curDateTime / totalDateTime) * 100);
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             progressStr, NOTIFY_CVT_PROGRESS_RawData,
                                             [NSNumber numberWithInt:fps], NOTIFY_CVT_PROGRESS_FPS,
                                             [NSNumber numberWithDouble:curDateTime], NOTIFY_CVT_PROGRESS_CurrDateTime,
                                             [NSNumber numberWithDouble:totalDateTime], NOTIFY_CVT_PROGRESS_TotalDateTime,
                                             [NSNumber numberWithInt:sPercentage], NOTIFY_CVT_PROGRESS_Percentage
                                             , nil];
            [nc postNotificationName:NOTIFY_CVT_PROGRESS object:nil userInfo:userInfo];
        }
    }
    [progressStr release];
    //Todo还需要否Progress部分处理
    [fileHandle waitForDataInBackgroundAndNotify];
}

-(void)ffmpegFinished:(NSNotification *) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSFileManager *fm = [NSFileManager defaultManager];
    bool isExist = [fm fileExistsAtPath:_tempEncodedMedia.encodedMediaPath];
    _tempEncodedMedia.Success = isExist;
    //TODO需要拿到existcode
    //_tempEncodedMedia.Success = (iExitCode.Equals(0) && blFileExists);
    /*
    LogMessager.WriteDebug(string.Format("EncodedMediaPath is {0}, file exsit is {1}, proc exist code is {2}", tempEncodedVideo.EncodedMediaPath, blFileExists, iExitCode));
    */
    iProgressErrorCount = 0;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     _tempEncodedMedia, NOTIFY_CVT_FINISHED_Encoded_Media
                                     , nil];
    [nc postNotificationName:NOTIFY_CVT_FINISHED object:@"MSG_COM_Convert_Finished" userInfo:userInfo];
}


- (void) terminated: (NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) ffmpegOutput: (NSNotification *) notification
{
    NSLog(@"ffmpegOutput");
    sleep(1);
    NSFileHandle *fileHandle = (NSFileHandle*) [notification object];
    NSData *data = [fileHandle availableData];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    [_ffmpegOutputStr appendString:str];
    NSLog(@"ffmpegOutput:%@",str);
    NSLog(@"_ffmpegOutputStr:%@",_ffmpegOutputStr);
    [str release];
    //Todo还需要否
    //[fileHandle waitForDataInBackgroundAndNotify];
}


//-----------------------------------------------
//通过正则表达得到相关的值
//frame= 5107 fps=344 q=4.0 Lsize=   11558kB time=00:02:50.40 bitrate= 555.7kbits/s dup=2551 drop=0 
//得到进度的时间片段。
- (double) extractCurProgressSec:(NSString*)progressStr {
    double curSec = 0;
    NSString *regexStr = @"[T|t]ime=.((\\d|:|\\.)*)";
    NSString *matchRes = [progressStr stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        curSec = [DateHelper getTotalSecondsFromHHMMSSMS:matchRes];
    }
    return curSec;
}

//得到当前进度的fps。
- (int) extractCurProgressFPS:(NSString*)progressStr {
    int fps = 0;
    NSString *regexStr = @"fps= +(\\d)* *";
    NSString *matchRes = [progressStr stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        fps = [matchRes intValue];
    }
    return fps;
}

//得到当前进度的frame。
- (int) extractCurProgressFrame:(NSString*)progressStr {
    int frame = 0;
    NSString *regexStr = @"frame= +(\\d)* *";
    NSString *matchRes = [progressStr stringByMatching:regexStr capture:1L];
    NSLog(@"matchRes:%@",matchRes);
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        frame = [matchRes intValue];
    }
    return frame;
}


//得到总的Duration的时间
- (double) extractDuration:(NSString*)rawInfo {
    double curSec = 0;
    NSString *regexStr = @"[D|d]uration:.((\\d|:|\\.)*)";
    NSString *matchRes = [rawInfo stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        curSec = [DateHelper getTotalSecondsFromHHMMSSMS:matchRes];
    }
    return curSec;
}

- (double) extractBitrate:(NSString*)rawInfo {
    double kb = 0.0;
    NSString *regexStr = @"[B|b]itrate:.((\\d|:)*)";
    NSString *matchRes = [rawInfo stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        kb = [matchRes doubleValue];
    }
    return kb;
}



- (int) extractVideoWidth:(NSString*)rawInfo {
    int width = 0;
    NSString *regexStr = @"(\\d{2,4})x\\d{2,4}";
    NSString *matchRes = [rawInfo stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        width = [matchRes intValue];
    }
    return width;
}

- (int) extractVideoHeight:(NSString*)rawInfo {
    int height = 0;
    NSString *regexStr = @"\\d{2,4}x(\\d{2,4})";
    NSString *matchRes = [rawInfo stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        height = [matchRes intValue];
    }
    return height;
}

- (NSString*) extractRawAudioFormat:(NSString*)rawInfo {
    NSString *audioFormat = @"";
    NSString *regexStr = @"[A|a]udio:(.*)";
    NSString *matchRes = [rawInfo stringByMatching:regexStr capture:1L];
    
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        audioFormat = [matchRes stringByReplacingOccurrencesOfString:@"Audio: " withString:@""];
    }
    return audioFormat;
}


- (NSString*) extractAudioFormat:(NSString*)rawAudioFormat
{
    NSArray *array = [rawAudioFormat componentsSeparatedByString:@", "];
    if (array != nil && array.count > 0) {
        return [array objectAtIndex:0];
    }
    return @"";
}

- (NSString*) extractRawVideoFormat:(NSString*)rawInfo {
    NSString *videoFormat = @"";
    NSString *regexStr = @"[V|v]ideo:(.*)";
     NSString *matchRes = [rawInfo stringByMatching:regexStr capture:1L];
    NSLog(@"matchRes str %@:", matchRes);
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        videoFormat = [matchRes stringByReplacingOccurrencesOfString:@"Video: " withString:@""];
    }
    return videoFormat;
}

- (NSString*) extractVideoFormat:(NSString*)rawVideoFormat
{
    NSArray *array = [rawVideoFormat componentsSeparatedByString:@", "];
    if (array != nil && array.count > 0) {
        return [array objectAtIndex:0];
    }
    return @"";
}

- (double) extractFrameRate:(NSString*)rawVideoFormat
{
    double dFPS = 0;
    NSString *regexStr = @",.((\\d|\\.)*) fps";
    NSString *matchRes = [rawVideoFormat stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
    NSLog(@"matchRes str %@:", matchRes);    
        dFPS = [[matchRes stringByReplacingOccurrencesOfString:@" " withString:@""] doubleValue];
    }
    return dFPS;
}

- (double) extractAudioBitRate:(NSString*)rawAudioFormat
{
    double dABR = 0;
    NSString *regexStr = @",.((\\d)*) kb/s";
    NSString *matchRes = [rawAudioFormat stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        NSLog(@"matchRes str %@:", matchRes);
        dABR = [[matchRes stringByReplacingOccurrencesOfString:@" " withString:@""] doubleValue];
    }
    return dABR * 1000;
}

- (double) extractVideoBitRate:(NSString*)rawVideoFormat
{
    double dVBR = 0;
    NSString *regexStr = @",.((\\d)*) kb/s";
    NSString *matchRes = [rawVideoFormat stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        NSLog(@"matchRes str %@:", matchRes);

        dVBR = [[matchRes stringByReplacingOccurrencesOfString:@" " withString:@""] doubleValue];
    }
    return dVBR * 1000;
}

- (long) ExtractTotalFramesWithTotalSecs:(double) duration FPS:(double)frameRate
{
    return (long) round(duration * frameRate);
}

//----------------------
- (double) extractAudioSamplingRate:(NSString*)rawAudioFormat
{
    double dABR = 0;
    NSString *regexStr = @",.((\\d)*) Hz";
    NSString *matchRes = [rawAudioFormat stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        NSLog(@"matchRes str %@:", matchRes);
        dABR = [[matchRes stringByReplacingOccurrencesOfString:@" " withString:@""] doubleValue];
    }
    return dABR * 1000;
}

- (NSString*) extractSAR:(NSString*)rawVideoFormat
{
    NSString *ScaleStr = @"";
    NSString *regexStr = @"SAR +(\\d+:\\d+)";
    NSString *matchRes = [rawVideoFormat stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        NSLog(@"matchRes str %@:", matchRes);
        ScaleStr = matchRes;
    }
    return ScaleStr;
}

- (NSString*) extractDAR:(NSString*)rawVideoFormat
{
    NSString *ScaleStr = @"";
    NSString *regexStr = @"DAR +(\\d+:\\d+)";
    NSString *matchRes = [rawVideoFormat stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        NSLog(@"matchRes str %@:", matchRes);
        ScaleStr = matchRes;
    }
    return ScaleStr;
}


//得到媒体信息-----------------------
//得到总的Duration的时间
- (NSString*) extractMetaStr:(NSString*)rawInfo WithName:(NSString*)name {
    NSString *str = @"";
    NSString *regexStr = [NSString stringWithFormat:@"%@ +: (.*)",name];
    NSString *matchRes = [rawInfo stringByMatching:regexStr capture:1L];
    if (![StringHelper stringIsNilOrEmpty:matchRes]) {
        NSLog(@"matchRes str %@:", matchRes);
        str = matchRes;
    }
    return str;
}

//-----------------------
/*
- (NSString*) runFFMpeg:(NSArray*)params {
    //需要用中文
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    _ffmpegOutputStr = nil;
    if (params != nil) {
        if (_ffmpegOutputStr != nil) {
            [_ffmpegOutputStr release];
        }
        _ffmpegOutputStr = [[NSMutableString alloc] init];
        NSLog(@"params:%@",params);
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath: ffmpegPath];
        [task setArguments: params];
        NSPipe *errorPipe = [NSPipe pipe];
        [task setStandardError:errorPipe];
        NSFileHandle *errFile = [errorPipe fileHandleForReading];
        [errFile waitForDataInBackgroundAndNotify];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(errData:)
                                                     name:NSFileHandleDataAvailableNotification
                                                   object:errFile];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(terminated:)
                                                     name:NSTaskDidTerminateNotification
                                                   object:task];
        [task launch];
        [task waitUntilExit];
        int status = [task terminationStatus];
        
        if (status == 0)
            NSLog(@"Task succeeded.");
        else
            NSLog(@"Task failed.");
        //NSLog(@"terminationStatus %i", [task terminationStatus]);
        NSLog(@"DONE:%@",_ffmpegOutputStr);
        [params release];
        //[task release];
        return _ffmpegOutputStr;
    }
    return nil;
}
 */

//将媒体文件编码器中的信息写到媒体文件实体中
-(void) getMediaInfo:(IMBCvtMediaFileEntity*) input {
    NSArray *Params = [NSArray arrayWithObjects:@"-i", input.path, nil];
    NSString* output = [self runFFMpeg:Params];
    input.rawInfo = output;
    input.duration = [self extractDuration:input.rawInfo];
    input.bitRate = [self extractBitrate:input.rawInfo];
    input.rawAudioFormat = [self extractRawAudioFormat:input.rawInfo];
    input.rawVideoFormat = [self extractRawVideoFormat:input.rawInfo];
    input.audioFormat = CvtMediaFormat_Unknown;
    if (![StringHelper stringIsNilOrEmpty:input.rawAudioFormat] ) {
        if ([input.rawAudioFormat startWithString:@"mp" options:NSCaseInsensitiveSearch]) {
            input.audioFormat = CvtMediaFormat_MP;
        } else if ([input.rawAudioFormat startWithString:@"acc" options:NSCaseInsensitiveSearch]) {
            input.audioFormat = CvtMediaFormat_AAC;
        }
    }
    input.videoFormat = CvtMediaFormat_Unknown;
    //TODO 这里还需要加一些其他的东东。如果是rm,rmvb,mpeg等格式的时候。
    if (![StringHelper stringIsNilOrEmpty:input.rawVideoFormat] ) {
        if ([input.rawVideoFormat containsString:@"H264" options:NSCaseInsensitiveSearch]) {
            input.videoFormat = CvtMediaFormat_H264;
        } else if ([input.rawVideoFormat containsString:@"MPEG4" options:NSCaseInsensitiveSearch]) {
            input.videoFormat = CvtMediaFormat_MPEG4;
            NSLog(@"MPEG4");
        }
        if ([input.rawVideoFormat containsString:@"mjpeg" options:NSCaseInsensitiveSearch] ||
            [input.rawVideoFormat containsString:@"png" options:NSCaseInsensitiveSearch]
            ) {
            input.mediaType = CvtMediaFile_Audio;
        } else {
            input.mediaType = CvtMediaFile_Video;
        }
    }
    input.width = [self extractVideoWidth:input.rawInfo];
    input.height = [self extractVideoHeight:input.rawInfo];
    input.frameRate = [self extractFrameRate:input.rawVideoFormat];
    input.totalFrames = [self ExtractTotalFramesWithTotalSecs:input.duration FPS:input.frameRate];
    input.audioBitRate = [self extractAudioBitRate:input.rawAudioFormat];
    input.videoBitRate = [self extractVideoBitRate:input.rawVideoFormat];
    if ((input.mediaType != CvtMediaFile_Video || input.bitRate == 0) && input.audioBitRate != 0) {
        input.mediaType = CvtMediaFile_Audio;
    } else if (input.videoBitRate != 0 || input.mediaType == CvtMediaFile_Video) {
        input.mediaType = CvtMediaFile_Video;
    } else {
        input.mediaType = CvtMediaFile_Unknown;
    }
    input.samplingRate = [self extractAudioSamplingRate:input.rawAudioFormat];
    input.sar = [self extractSAR:input.rawVideoFormat];
    input.dar = [self extractDAR:input.rawVideoFormat];
    input.convertStart = 0;
    input.convertLength = input.duration;
    input.infoGathered = true;
}


-(NSString*) getVideoArtworkData:(NSString*) mediaFilePath {
    NSArray *Params = [NSArray arrayWithObjects:@"-i", mediaFilePath, nil];
    NSString* output = [self runFFMpeg:Params];
    NSString* rawVideoFormat = [self extractRawVideoFormat:output];
    NSString* artworkPath = nil;
        if ([rawVideoFormat containsString:@"mjpeg" options:NSCaseInsensitiveSearch] ||
            [rawVideoFormat containsString:@"png" options:NSCaseInsensitiveSearch]
        ) {
             artworkPath = [[[TempHelper getAppTempPath] stringByAppendingPathComponent:[SystemHelper getRandomFileName:8]] stringByAppendingPathExtension:@"jpg"];
            
        }
    return artworkPath;
}


-(IMBNewTrack*) createNewtrackWithffmpeg:(NSString*) mediaFilePath {
    IMBNewTrack *newTrack = [[[IMBNewTrack alloc] init] autorelease];
    NSArray *Params = [NSArray arrayWithObjects:@"-i", mediaFilePath, nil];
    [newTrack setFilePath:mediaFilePath];
    [newTrack setFileExtension:[mediaFilePath pathExtension]];
    NSFileManager *fm = [NSFileManager defaultManager];
    newTrack.fileSize= (uint)[[fm attributesOfItemAtPath:mediaFilePath error:nil] fileSize];
    
    NSString* output = [self runFFMpeg:Params];
    NSString* rawAudioFormat = [self extractRawAudioFormat:output];
    NSString* rawVideoFormat = [self extractRawVideoFormat:output];
    
    NSLog(@"output %@",output);
    NSString *title = [self extractMetaStr:output WithName:@"title"];
    NSLog(@"title %@",title);
    NSString *artist = [self extractMetaStr:output WithName:@"artist"];
    NSLog(@"artist %@",artist);
    NSString *album = [self extractMetaStr:output WithName:@"album"];
    NSLog(@"album %@",album);
    NSString *genre = [self extractMetaStr:output WithName:@"genre"];
    NSLog(@"genre %@",genre);
    
    NSString *albumArtist = [self extractMetaStr:output WithName:@"album_artist"];
    NSLog(@"albumArtist %@",albumArtist);
    
    NSString *composer = [self extractMetaStr:output WithName:@"composer"];
    NSLog(@"composer %@",composer);
    
    /*
    M4A
    track           : 11/18
    disc            : 1/1
    date            : 2003-11-17T08:00:00Z
     
    M4A 2
     track           : 1
     gapless_playback: 0
     encoder         : iTunes 10.6.3.25
     
    M4A 3
     
     major_brand     : M4A
     minor_version   : 0
     compatible_brands: M4A mp42isom
     creation_time   : 2012-06-05 01:01:28
     title           : Dive
     artist          : Usher
     album_artist    : Usher
     album           : Looking 4 Myself
     ------------------------
     track           : 8/14
     disc            : 1/1
     date            : 2012
     ------------------------
     gapless_playback: 0
     encoder         : iTunes 10.6.1
     
    MP3
     artist          : 邓丽君
     album           : 传奇再续
     title           : 小城故事
     TYER            : 2011-01-17
     Tagging time    : 2013-05-17T18:09:09
     Duration: 00:02:41.83, start: 0.000000, bitrate: 191 kb/s
    
    
    */
    
    if (title != nil) {
        [newTrack setTitle:title];
    }
    
    if (artist != nil) {
        [newTrack setArtist:artist];
    }
    
    if (album != nil) {
        [newTrack setAlbum:album];
    }
    
    if (genre != nil) {
        [newTrack setGenre:genre];
    }
    
    if (albumArtist != nil) {
        [newTrack setAlbumArtist:albumArtist];
    }
    
    if (composer != nil) {
        [newTrack setComposer:composer];
    }
    
    
    //commnet
    //[newTrack setComments:[taglib comment]];
    /*
     [newTrack setTrackNumber:[[taglib track] unsignedIntValue]];
     [newTrack setYear:[[taglib year] unsignedIntValue]];
     [newTrack setDiscNumber:0];
     [newTrack setAlbumTrackCount:0];
     */
    
    [newTrack setLength:[self extractDuration:output] * 1000];
    [newTrack setBitrate:(int)[self extractBitrate:output]];
    [newTrack setSampleRate:[self extractAudioSamplingRate:rawAudioFormat]];
        [newTrack setAudioChannels:2];
    if ([StringHelper stringIsNilOrEmpty:[newTrack title]]) {
        [newTrack setTitle:[[[mediaFilePath pathComponents] lastObject] stringByDeletingPathExtension]];
    }

    //[IMBHelper getMediaType:newTrack selectCategory:selectCategory];
    
    //TODO 这里还需要加一些其他的东东。如果是rm,rmvb,mpeg等格式的时候。
    if (![StringHelper stringIsNilOrEmpty:rawVideoFormat] ) {
        NSLog(@"rawVideoFormat %@", rawVideoFormat);
        if ([rawVideoFormat containsString:@"mjpeg" options:NSCaseInsensitiveSearch] ||
            [rawVideoFormat containsString:@"png" options:NSCaseInsensitiveSearch]
            ) {
            //[newTrack setIsVideo:false];
            //得到artwork
             NSString* artworkPath = [[[TempHelper getAppTempPath] stringByAppendingPathComponent:[SystemHelper getRandomFileName:8]] stringByAppendingPathExtension:@"jpg"];
            
            if ([self getAudioThumbnailFile:mediaFilePath artworkOutPath:artworkPath]) {
                newTrack.artworkFile = artworkPath;
            }
        }
    }
    newTrack.isVideo = [SystemHelper isVideoFile:newTrack.filePath];
    
    
    return newTrack;
}

@end

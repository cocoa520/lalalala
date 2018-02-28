//
//  IMBMediaConverter.m
//  iMobieTrans
//
//  Created by zhang yang on 13-5-12.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBMediaConverter.h"
#import "IMBDeviceInfo.h"
#import "IMBCvtMediaEncoding.h"
#import "IMBNewTrack.h"
#import "IMBCommonEnum.h"
#import "TempHelper.h"
#import "StringHelper.h"
#import "SystemHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBTransferError.h"

@implementation IMBMediaConverter
@synthesize outputCvtMediaList = _outputCvtMediaList;
@synthesize convertFiles = _convertFiles;
@synthesize outputCvtMediaListMapping = _outputCvtMediaListMapping;
@synthesize isStop = _isStop;
- (id)init
{
    self = [super init];
    if (self) {
        _convertFiles = [[NSMutableArray alloc] init];
        _isRingtoneArray = [[NSMutableArray alloc] init];
        convertFileRintoneStruct.convertFiles = _convertFiles;
        convertFileRintoneStruct.isRingtoneArray = _isRingtoneArray;
        _convEnc = [[IMBCvtMediaConvertEncoder alloc] init];
        if (_convEnc == nil) _convEnc = [[IMBCvtMediaConvertEncoder alloc] init];
        //OutputPathList.Clear();
        _totalItemCount = 0;
        _currentItemCount = 0;
        _totalDatetime = 0;
        _currCompleteDatetime = 0;
        _successCount = 0;
        _faildCount = 0;
        _cancelCount = 0;
        //IsChangeCachePath = null;
        //ConvertCancel = false;
        _curCompletedCount = 0;
        //Todo
        _outputCvtMediaList = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(convEnc_OnEncodeProgress:)
                                                     name:NOTIFY_CVT_PROGRESS
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(convEnc_OnSingleEncodeFinished:)
                                                     name:NOTIFY_CVT_FINISHED
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadShouldBreak) name:CANCELPREPAREFILENOTIFICATION object:nil];
    }
    return self;
}

- (void)threadShouldBreak{
    _isThreadBreak = YES;
}

- (void)dealloc
{
    [_convertTempPath release],_convertTempPath = nil;
    [_cvtDevice release],_cvtDevice = nil;
    if (_convEnc != nil) {
        [_convEnc release];
    }
    if (_convertFiles != nil) {
        [_convertFiles release];
    }
    if (_outputCvtMediaList != nil) {
        [_outputCvtMediaList release];
    }
    if (_isRingtoneArray != nil) {
        [_isRingtoneArray release];
        _isRingtoneArray = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CVT_PROGRESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CVT_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CANCELPREPAREFILENOTIFICATION object:nil];
    [super dealloc];
}

+ (IMBMediaConverter*)singleton {
    static IMBMediaConverter *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBMediaConverter alloc] init];
		}
	}
	return _singleton;
}

-(NSString*) getVideoArtworkData:(NSString*) mediaFilePath
{
    return [_convEnc getVideoArtworkData:mediaFilePath];
}
- (void) reInitWithiPod:(IMBiPod*)iPod
{
    _isStop = NO;
    if (_convertFiles != nil && _convertFiles.count > 0) [_convertFiles removeAllObjects];
    //媒体转换加码器
    if (_convEnc == nil) _convEnc = [[IMBCvtMediaConvertEncoder alloc] init];
    //OutputPathList.Clear();
    _totalItemCount = 0;
    _currentItemCount = 0;
    _totalDatetime = 0;
    _currCompleteDatetime = 0;
    _successCount = 0;
    _faildCount = 0;
    _cancelCount = 0;
    _isThreadBreak = FALSE;
    if (_convertTempPath == nil) {
        if (iPod != nil) {
            _convertTempPath = [iPod.session.sessionFolderPath retain];
        }else {
            _convertTempPath = [[[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iTunes Cache"] stringByAppendingPathComponent:@"Convert"] retain];
        }
    }
    if (_outputCvtMediaList != nil) {
        [_outputCvtMediaList removeAllObjects];
    }
    if (iPod == nil) {//导入iTunes中media的格式转换
        if (_cvtDevice != nil) {
            [_cvtDevice release];
        }
        _cvtDevice = [[IMBCvtDeviceEntity alloc] initWithiPodFamily:iPad_Pro];
        if (_config == nil) {
            _config = [[IMBConfig alloc] initWithIPod:nil];
        }
        if (_rtConfig == nil) {
            _rtConfig = [IMBRingtoneConfig singleton];
        }
    }else {
        if (_iPod == nil || [iPod.uniqueKey isEqualToString:_iPod.uniqueKey]) {
            _iPod = iPod;
            if (_cvtDevice != nil) {
                [_cvtDevice release];
            }
            _cvtDevice = [[IMBCvtDeviceEntity alloc] initWithiPodFamily:_iPod.deviceInfo.family];
            _config = _iPod.transCodingConfig;
            _rtConfig = [IMBRingtoneConfig singleton];
        }
    }
    
}

- (void) reInit
{
    if (_convertFiles != nil && _convertFiles.count > 0) [_convertFiles removeAllObjects];
    if (_isRingtoneArray != nil && _isRingtoneArray.count > 0) {
        [_isRingtoneArray removeAllObjects];
    }
    if (_convEnc == nil) _convEnc = [[IMBCvtMediaConvertEncoder alloc] init];
    //OutputPathList.Clear();
    _totalItemCount = 0;
    _currentItemCount = 0;
    _totalDatetime = 0;
    _currCompleteDatetime = 0;
    _successCount = 0;
    _faildCount = 0;
    _cancelCount = 0;
    _curCompletedCount = 0;
}

//通过ffmpeg的到媒体信息
-(void) getMediaInfo:(IMBCvtMediaFileEntity*) mediaFile
{
    /* TODO
    MediaInfoTool mediaTool = MediaInfoTool.getInstence();
    MediaFile mediaFile = null;
    */
    [_convEnc getMediaInfo:mediaFile];
}

-(IMBNewTrack*) createNewtrackWithffmpeg:(NSString*) mediaFilePath
{
    return [_convEnc createNewtrackWithffmpeg:mediaFilePath];
}


#pragma mark -需要是否条件的所有路径都被覆盖
// 检查媒体是否被设备支持，是否需要转换文件
/*参数含义：
    ipod:被判定的设备
    mediaPath:媒体文件路径
    isCvtVideo:是否需要转换为音频
    isCvtAudio:是否需要转换为视频
    isSprtVideo:是否支持音频
    isSprAudio:是否支持视频
    isSupportExt:是否支持扩展名
 */
-(BOOL)checkDeviceConvertWithiPod:(IMBiPod*) iPod Path:(NSString*)mediaPath IsCvtVideo:(bool)isCvtVideo IsCvtAudio:(bool)isCvtAudio SupportVideo:(bool)isSprtVideo SupportAudio:(bool)isSprtAudio SupportExt:(bool)isSupportExt{
    if (_isThreadBreak) {
        return NO;
    }
    NSLog(@"CheckDeviceConvert method enter");
    NSLog(@"isCvtVideo %d IsCvtAudio:%d SupportVideo:%d SupportAudio:%d SupportExt:%d",isCvtVideo,isCvtAudio,isSprtVideo,isSprtAudio,isSupportExt);
    bool isNeedConvert = false;
    //设备和媒体路径存在
    if (_cvtDevice != nil && [[NSFileManager defaultManager] fileExistsAtPath:mediaPath]) {
        IMBCvtMediaFileEntity *mediaFile = [[IMBCvtMediaFileEntity alloc] init];
        [mediaFile setPath:mediaPath];
        //将媒体文件编码器中的信息写入媒体文件实体中
        [self getMediaInfo:mediaFile];
        //TODO rmvb,avi等等
        //媒体类型为音频，支持音频，需要转换为音频，支持扩展名
        if (isSupportExt) {
            if (mediaFile.mediaType == CvtMediaFile_Video && isSprtVideo == true && isCvtVideo == true) {
                if (mediaFile.videoFormat == CvtMediaFormat_H264) {
                    if (_cvtDevice.isSupportH264 == false) {
                        isNeedConvert = true;
                    } else {
                        if (_cvtDevice.H264VideoMaxBitrate < mediaFile.videoBitRate)
                        {
                            isNeedConvert = YES;
                        }else {
                            if (mediaFile.videoBitRate <= 0) {
                                isNeedConvert = YES;
                            }
                        }
                    }
                } else if (mediaFile.videoFormat == CvtMediaFormat_MPEG4) {
                    if (_cvtDevice.isSupportMPEG4 == false) {
                        isNeedConvert = true;
                    } else {
                        if (_cvtDevice.MPEG4VideoMaxBitrate < mediaFile.videoBitRate)
                        {
                            isNeedConvert = true;
                        }
                    }
                }
    //            if (!isNeedConvert && (_cvtDevice.videoMaxWidth < mediaFile.width || _cvtDevice.videoMaxHeight < mediaFile.height))
    //            {
    //                isNeedConvert = YES;
    //            }
     
            } else if (mediaFile.mediaType == CvtMediaFile_Audio && isSprtAudio == true && isCvtAudio == true) {
                if (mediaFile.audioFormat == CvtMediaFormat_MP)
                {
                    if (!_cvtDevice.isSupportMP3)
                        isNeedConvert = true;
                }
                else if (mediaFile.audioFormat == CvtMediaFormat_AAC)
                {
                    if (!_cvtDevice.isSupportAAC)
                        isNeedConvert = true;
                }
                if (_cvtDevice.audioMaxBitrate < mediaFile.audioBitRate)
                {
                    isNeedConvert = true;
                }
            }
        }else {
            isNeedConvert = YES;
        }
        if (isNeedConvert) {
            [_convertFiles addObject:mediaFile];
        }
        [mediaFile release];
    }
    return isNeedConvert;
}


- (BOOL) checkDeviceConvertWithiPod:(IMBiPod*) iPod Path:(NSString*)mediaPath IsCvtVideo:(bool)isCvtVideo IsCvtAudio:(bool)isCvtAudio SupportVideo:(bool)isSprtVideo SupportAudio:(bool)isSprtAudio SupportExt:(bool)isSupportExt withType:(CategoryNodesEnum)categoryEnum{
    //检查指定设备指定路径
    NSString *extension = [mediaPath pathExtension].lowercaseString;
    if ([extension isEqualToString:@"mov"] && categoryEnum != Category_iTunesU) {
        return NO;
    }
    
    BOOL isNeedToConvert = [self checkDeviceConvertWithiPod:(IMBiPod*) iPod Path:(NSString*)mediaPath IsCvtVideo:(bool)isCvtVideo IsCvtAudio:(bool)isCvtAudio SupportVideo:(bool)isSprtVideo SupportAudio:(bool)isSprtAudio SupportExt:(bool)isSupportExt];
    //需要转换
    if (isNeedToConvert) {
        [_isRingtoneArray addObject:[NSNumber numberWithUnsignedInt:categoryEnum]];
        IMBCvtMediaFileEntity *mediaEntity = [_convertFiles lastObject];
        mediaEntity.categoryNodes = categoryEnum;
    }
    return isNeedToConvert;
    
}


/// 计算媒体的转换尺寸
- (NSString*) calculateMediaSize:(IMBCvtMediaFileEntity*)mediaFile {
    NSString* videoSize = @"";
    double Width = 0;
    double Height = 0;
    double WidthScale = 0;
    double HeightScale = 0;
    bool isOK = false;
    if ([StringHelper stringIsNilOrEmpty:mediaFile.dar]) {
        //取出视频的缩放比例
        NSString *dar = [mediaFile.dar stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *array = [dar componentsSeparatedByString:@":"];
        if (array.count == 2) {
            WidthScale = [[array objectAtIndex:0] doubleValue];
            HeightScale = [[array objectAtIndex:1] doubleValue];
            if (WidthScale != 0 && HeightScale != 0) {
                //对视频尺寸进行计算
                if (mediaFile.width > _cvtDevice.screenWidth || mediaFile.height > _cvtDevice.screenHeight)
                {
                    if (_cvtDevice.screenWidth < _cvtDevice.screenHeight)
                    {
                        Width = _cvtDevice.screenWidth;
                        Height = floor(mediaFile.height * (_cvtDevice.screenWidth/mediaFile.width));
                    }
                    else
                    {
                        Height = _cvtDevice.screenHeight;
                        Width = floor(mediaFile.width * (_cvtDevice.screenHeight/mediaFile.height));
                    }
                    if (Width > _cvtDevice.screenWidth)
                    {
                        Width = floor(_cvtDevice.screenWidth / 4.0) * 4;
                        Height = floor((Width * ((double)HeightScale / WidthScale)) / 4.0) * 4;
                    }
                    if (Height > _cvtDevice.screenHeight)
                    {
                        Height = floor(_cvtDevice.screenHeight / 4.0) * 4;
                        Width = floor((Height * ((double)WidthScale / HeightScale)) / 4.0) * 4;
                    }
                    isOK = true;
                }
            }
        }
    }
    if (!isOK)
    {
        if (_cvtDevice.screenWidth < _cvtDevice.videoMaxWidth) {
            Width = _cvtDevice.screenWidth;
            Height = _cvtDevice.screenHeight;
        }else {
            Width = _cvtDevice.videoMaxWidth;
            Height = _cvtDevice.videoMaxHeight;
        }
        if (Width > mediaFile.width) {
            Width = mediaFile.width;
        }
        if (Height > mediaFile.height) {
            Height = mediaFile.height;
        }
    }
    if (Width != 0 && Height != 0)
    { videoSize = [NSString stringWithFormat:@"%dx%d",(int)Width, (int)Height];}
    return videoSize;
}

/// 构建转换所需要的参数
- (NSArray*) createConvertParms:(CvtMediaFormatEnum) videoFmt AutoSize:(bool)autoSize AudioFmt:(CvtMediaFormatEnum) audioFmt Qt:(CvtQualityTypeEnum)qt MediaFile:(IMBCvtMediaFileEntity*)mediaFile TbnSize:(NSString*)thumbnailSize isRt:(BOOL)isRingtone{
    NSArray *params = nil;
    NSString *mediaSize = nil;
    if(isRingtone) {
        params = [IMBCvtMediaEncoding CreateRingtoneParamsQuality:qt StartSec:mediaFile.convertStart RingtoneLength:mediaFile.convertLength];
    } else {
        if (mediaFile.mediaType == CvtMediaFile_Video) {
            if (autoSize == true) {
                mediaSize = [self calculateMediaSize:mediaFile];
            } else {
                if (mediaFile.width > _cvtDevice.videoMaxWidth || mediaFile.height > _cvtDevice.videoMaxHeight)
                { mediaSize = [self calculateMediaSize:mediaFile]; }
                else
                { mediaSize = [NSString stringWithFormat:@"%dx%d",mediaFile.width, mediaFile.height]; }
            }
            if (videoFmt == CvtMediaFormat_H264)
            {//_H264VideoMaxBitrate的比特率很大，尝试用MPEG4VideoMaxBitrate值
                if (mediaFile.videoBitRate < _cvtDevice.MPEG4VideoMaxBitrate && mediaFile.videoBitRate != 0) {
                    params = [IMBCvtMediaEncoding CreateMediaParamsMediaType:videoFmt Quality:qt BitRate:[NSString stringWithFormat:@"%fk",mediaFile.videoBitRate/1000] Size:mediaSize];
                }else {
                    params = [IMBCvtMediaEncoding CreateMediaParamsMediaType:videoFmt Quality:qt BitRate:[NSString stringWithFormat:@"%ldk",_cvtDevice.MPEG4VideoMaxBitrate/1000] Size:mediaSize];
                }
            }else if (videoFmt == CvtMediaFormat_MPEG4)
            {
                if (mediaFile.videoBitRate < _cvtDevice.MPEG4VideoMaxBitrate && mediaFile.videoBitRate != 0) {
                    params = [IMBCvtMediaEncoding CreateMediaParamsMediaType:videoFmt Quality:qt BitRate:[NSString stringWithFormat:@"%fk",mediaFile.videoBitRate/1000] Size:mediaSize];
                }else {
                    params = [IMBCvtMediaEncoding CreateMediaParamsMediaType:videoFmt Quality:qt BitRate:[NSString stringWithFormat:@"%ldk",_cvtDevice.MPEG4VideoMaxBitrate/1000] Size:mediaSize];
                }
            }
            if ([StringHelper stringIsNilOrEmpty:mediaSize]) thumbnailSize = mediaSize;
        } else {
            if (audioFmt == CvtMediaFormat_MP)
            {
                params = [IMBCvtMediaEncoding CreateMediaParamsMediaType:audioFmt Quality:qt BitRate:nil Size:nil];
            }
            else if (audioFmt == CvtMediaFormat_AAC)
            {
                params = [IMBCvtMediaEncoding CreateMediaParamsMediaType:audioFmt Quality:qt BitRate:nil Size:nil];
            }
        }
    }
    return params;
}

-(double)getTotalDateTime {
    double totalFrame = 0;
    for (IMBCvtMediaFileEntity *media in _convertFiles) {
        totalFrame += media.duration;
    }
    return totalFrame;
}


/// 得到需要转换部分的总时长
-(double) getRingtoneTotalDateTime {
    double totalDateTime = 0;
    for (IMBCvtMediaFileEntity *mediaFile in _convertFiles) {
        if (_rtConfig.convertSize == RT_SecRest) {
            mediaFile.convertStart = 0;
            mediaFile.convertLength = mediaFile.duration;
            totalDateTime += mediaFile.convertLength;
        } else {
            if (mediaFile.duration < (double)_rtConfig.convertSize + 0.01)
            {
                mediaFile.convertStart = 0;
                mediaFile.convertLength = mediaFile.duration;
                totalDateTime += mediaFile.convertLength;
            }
            else if ((mediaFile.duration - _rtConfig.startSecond) < (double)_rtConfig.convertSize + 0.01)
            {
                mediaFile.convertStart = mediaFile.duration - ((double)_rtConfig.convertSize + 0.01);
                mediaFile.convertLength = (double)_rtConfig.convertSize + 0.01;
                totalDateTime += mediaFile.convertLength;
            }
            else
            {
                mediaFile.convertStart = _rtConfig.startSecond;
                mediaFile.convertLength = (double)_rtConfig.convertSize + 0.01;
                totalDateTime += mediaFile.convertLength;
            }
        }
        NSLog(@"totalDateTime %f mediaFile.convertLength %f", totalDateTime, mediaFile.convertLength);
    }
    return totalDateTime;
}

//得到媒体的extension部分
- (NSString*) getMediaExt:(IMBCvtMediaFileEntity*) mediaFile Config:(IMBConfig*)config {
    NSString *extStr = @"";
    CategoryNodesEnum category = mediaFile.categoryNodes;
    if (category == Category_PodCasts || category == Category_Audiobook) {
        extStr = @"mp3";
        return extStr;
    }
    //如果是视屏 存在既是音频又是视屏的文件
    if (category == Category_Movies||category == Category_MusicVideo||category == Category_HomeVideo||category == Category_TVShow)
    {
        if (config.mediaFormat == CvtMediaFormat_H264)
        {
            extStr = @"mp4";
        }else if (config.mediaFormat == CvtMediaFormat_MPEG4)
        {
            extStr = @"mp4";
        }else
        {
            extStr = @"mp4";
        }
    }else if (category == Category_iTunesU) {
        NSString *ext = [mediaFile.path.pathExtension lowercaseString];
        if ([ext isEqualToString:@"mp3"] || [ext isEqualToString:@"m4a"] || [ext isEqualToString:@"wma"] || [ext isEqualToString:@"wav"]) {
            if (config.audioFormat == CvtMediaFormat_MP){
                extStr = @"mp3";
            }else if (config.audioFormat == CvtMediaFormat_MPEG4){
                extStr = @"mp3";
                _isiTunesU = [ext isEqualToString:@"wav"];
                if (_isiTunesU) {
                    extStr = @"m4r";
                }
            }else{
                extStr = @"mp3";
                _isiTunesU = [ext isEqualToString:@"wav"];
                if (_isiTunesU) {
                    extStr = @"m4r";
                }
            }
        }else {
            if (config.mediaFormat == CvtMediaFormat_H264)
            {
                extStr = @"mp4";
            }else if (config.mediaFormat == CvtMediaFormat_MPEG4)
            {
                extStr = @"mp4";
            }else
            {
                extStr = @"mp4";
            }
        }
    }else{
        if (config.audioFormat == CvtMediaFormat_MP){
            extStr = @"mp3";
        }else if (config.audioFormat == CvtMediaFormat_MPEG4){
            extStr = @"m4a";
        }else{
            extStr = @"m4a";
        }
    }
    return extStr;
}

- (void)ConverterSingleMedia:(IMBCvtMediaFileEntity*)mediaFile Config:(IMBConfig*)config{
    if (_isThreadBreak) {
        return;
    }
    _isiTunesU = NO;
    NSString *fileName = @"";
    NSString *extStr = @"";
    NSArray *params = nil;
    //Todo这是什么东东呢
    //??DriveInfo driveRoot = null;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CVT_PROGRESS_TRANSFER object:[NSString stringWithFormat:@"Converting %@",[mediaFile.path lastPathComponent]] userInfo:nil];
    
    /*
     if (EncodeTotalProgressEvent != null)
     { EncodeTotalProgressEvent("MSG_COM_Total_Progress", CurrentItemCount, TotalItemCount); }
    */
    if (_convertCancel == false) {
        NSString *thumbnailSize = @"";
        BOOL isRingtone = _isRingtone;
        if ([[_isRingtoneArray objectAtIndex:_currentItemCount] unsignedIntValue] == Category_Ringtone) {
            isRingtone = true;
        }
        if (isRingtone) {
            extStr = @"m4a"; //先转换成m4a 再改成m4r ffmpeg不能直接转换成m4r
            params =  [self createConvertParms:CvtMediaFormat_AAC AutoSize:true AudioFmt:CvtMediaFormat_AAC Qt:CvtMediaQuality_LowQuality MediaFile:mediaFile TbnSize:thumbnailSize isRt:isRingtone];
        } else {
            extStr = [self getMediaExt:mediaFile Config:config];
            CvtMediaFormatEnum formatEnum = config.audioFormat;
            if (mediaFile.categoryNodes == Category_PodCasts || mediaFile.categoryNodes == Category_Audiobook) {
                formatEnum = CvtMediaFormat_MP;
            }
            params = [self createConvertParms:config.mediaFormat AutoSize:config.autoSize AudioFmt:formatEnum Qt:config.quality MediaFile:mediaFile TbnSize:thumbnailSize isRt:isRingtone];
        }
        //TODO 这个地方判断是否还有有效空间
        if (mediaFile != nil) _currCompleteDatetime += mediaFile.convertLength;
        fileName = [[mediaFile.path lastPathComponent] stringByDeletingPathExtension];
        //TODO这个地方是放到seesion里面还是放到其他目录好呢
        if (![[NSFileManager defaultManager] fileExistsAtPath:_convertTempPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_convertTempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString* cacheFileFullPath = [[_convertTempPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:extStr];
        [_convEnc encodeMediaAsyncWithMediaFile:mediaFile EncodeParas:params OutputFileName:cacheFileFullPath ThumbnailSize:thumbnailSize];
    } else {
        //TOID　同步问题仍需要cancel
    }
}

- (MediaImageType)getFileType:(NSString *)folderPath{
    if ([SystemHelper isImageFile:folderPath]) {
        return ImageTypeIcon;
    }
    else if([SystemHelper isVideoFile:folderPath]){
        return VideoTypeIcon;
    }
    else{
        return MusicTypeIcon;
    }
}

- (void) convertMedia:(NSString*)folderPath isRt:(bool)isRingtone {
    //TODO:方法使用错误，需要在后面加上
//    NSNumber *number = [NSNumber numberWithInteger:[self getFileType:folderPath]];
//
//    [nc postNotificationName:CONVERSIONNOTIFICATION object:number userInfo:nil];
    /*
    ConvEnc.OnEncodeProgress += new EncodeProgressEventHandler(ConvEnc_OnEncodeProgress);
    ConvEnc.OnEncodeFinished += new EncodeFinishedEventHandler(ConvEnc_OnEncodeFinished);
    */
    _curCompletedCount = 0;
    _isRingtone = isRingtone;
    BOOL isRt = _isRingtone;
    _totalItemCount = (int)_convertFiles.count;
    if (!isRt) {
        _totalDatetime = [self getTotalDateTime];
    } else {
        _totalDatetime = [self getRingtoneTotalDateTime];
    }
    for (int i = 0; i<[_convertFiles count];i++) {
        @autoreleasepool {
            if (_isStop) {
                break;
            }
            if (_isRingtoneArray.count > 0 && _curCompletedCount < _isRingtoneArray.count) {
                isRt = [[_isRingtoneArray objectAtIndex:i] unsignedIntValue] == Category_Ringtone;
            }
            if (!isRt) {
//                _totalDatetime = [self getTotalDateTime];
                [self ConverterSingleMedia:[_convertFiles objectAtIndex:i] Config:_config];
            } else {
//                _totalDatetime = [self getRingtoneTotalDateTime];
                [self ConverterSingleMedia:[_convertFiles objectAtIndex:i] Config:nil];
            }

        }
    }
}

//-----event的处理 start --------------------------------------------------
/// 单个文件转换的事件处理
- (void) convEnc_OnEncodeProgress:(NSNotification *) notification {
    NSDictionary* userinfo = [notification userInfo];
    NSString *mediaName = [userinfo objectForKey:NOTIFY_CVT_PROGRESS_MediaName];
    if (mediaName.length == 0) {
        mediaName = @"";
    }
    int itemPercentage = [[userinfo objectForKey:NOTIFY_CVT_PROGRESS_Percentage] intValue];
    if (itemPercentage >100) {
        itemPercentage = 100;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CVT_PROGRESS_TRANSFER object:[[NSString stringWithFormat:@"Converting %@",mediaName] stringByAppendingString:[NSString stringWithFormat:@"%d%%",itemPercentage]]];
}

/// 单个文件转换的结束处理
- (void)convEnc_OnSingleEncodeFinished:(NSNotification *) notification{
    NSDictionary* userinfo = [notification userInfo];
    NSFileManager *fm = [NSFileManager defaultManager];
    IMBCvtEncodedMedia *encodedMedia = [userinfo objectForKey:@"Convert_Finished_Encoded_Media"];
    if (encodedMedia.success) {
        _successCount += 1;
        //TODO 需要写入Artwork到媒体文件
        //[self writeArtworkToFile:encodedMedia]
        BOOL isRingtone = _isRingtone;
        if (_isRingtoneArray.count > 0) {
            isRingtone = [[_isRingtoneArray objectAtIndex:_currentItemCount] unsignedIntValue] == Category_Ringtone;
        }
        if (isRingtone) {
            NSString *filePath = encodedMedia.encodedMediaPath;
            if ([fm fileExistsAtPath:filePath]) {
                NSString *tmpPath = [filePath stringByDeletingPathExtension];
                tmpPath = [tmpPath stringByAppendingPathExtension:@"m4r"];
                [fm moveItemAtPath:filePath toPath:tmpPath error:nil];
                [_outputCvtMediaList addObject:encodedMedia];
                encodedMedia.encodedMediaPath = tmpPath;
                OutputStringTypeMapping outPutStruct;
                outPutStruct.categoryType = [[_isRingtoneArray objectAtIndex:_currentItemCount] unsignedIntValue];
                outPutStruct.encodedMediaPath = tmpPath;
                NSValue *value = nil;
                value = [NSValue valueWithBytes:&outPutStruct objCType:@encode(OutputStringTypeMapping)];
                [_outputCvtMediaListMapping addObject:value];
            }
        }else{
            if (_isiTunesU) {//如果iTunes U需要转换的格式是wav，则先把wav格式转换成m4a，然后在重命名成MP3格式
                NSString *filePath = encodedMedia.encodedMediaPath;
                if ([fm fileExistsAtPath:filePath]) {
                    NSString *tmpPath = [filePath stringByDeletingPathExtension];
                    tmpPath = [tmpPath stringByAppendingPathExtension:@"mp3"];
                    [fm moveItemAtPath:filePath toPath:tmpPath error:nil];
                    [_outputCvtMediaList addObject:encodedMedia];
                    encodedMedia.encodedMediaPath = tmpPath;
                }
            }
            [_outputCvtMediaList addObject:encodedMedia];
        }
    } else {
        [[IMBTransferError singleton] addAnErrorWithErrorName:[encodedMedia.encodedMediaPath lastPathComponent] WithErrorReson:@"Failed to convert file format."];
        _faildCount += 1;
        if ([fm fileExistsAtPath:encodedMedia.encodedMediaPath]) {
            [fm removeItemAtPath:encodedMedia.encodedMediaPath error:nil];
        }
    }
    _currentItemCount += 1;

     NSLog(@"_currentItemCount %d", _currentItemCount);
    if (_convEnc != nil && _currentItemCount >= _convertFiles.count) {
        sleep(1);
        return;
    }
}



//-----event的处理 end ------------------------------------------------------

@end

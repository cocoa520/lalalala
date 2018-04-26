//
//  IMBCvtMediaFileEntity.h
//  iMobieTrans
//
//  Created by zhang yang on 13-4-15.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"

typedef enum
{
    CvtMediaFile_Unknown = 0,
    CvtMediaFile_Audio = 1,
    CvtMediaFile_Video = 2,
    CvtMediaFile_Ringtone = 3
}  CvtMediaTypeEnum;

typedef enum
{
    CvtMediaFormat_Unknown = 0,
    CvtMediaFormat_H264 = 1,
    CvtMediaFormat_MPEG4 = 2,
    CvtMediaFormat_MP = 3,
    CvtMediaFormat_AAC = 4,
    CvtMediaFormat_noMediaConvert = 5,
    CvtMediaFormat_noAudiaConvert = 6
} CvtMediaFormatEnum;

typedef enum QualityTypeEnum
{
    CvtMediaQuality_LowQuality = 1,
    CvtMediaQuality_HighQuality = 2
} CvtQualityTypeEnum;

@interface IMBCvtMediaFileEntity : NSObject {
    CvtMediaTypeEnum _mediaType;
    NSString *_path;
    //TimeInterval
    double _duration;
    double _bitRate;
    double _videoBitRate;
    double _audioBitRate;
    NSString *_rawAudioFormat;
    CvtMediaFormatEnum _audioFormat;
    NSString *_rawVideoFormat;
    CvtMediaFormatEnum _videoFormat;
    int _height;
    int _width;
    double _frameRate;
    long _totalFrames;
    NSString *_rawInfo;
    long _samplingRate;
    NSString *_sar;
    NSString *_dar;
    bool _infoGathered;
    double _convertStart;
    double _convertLength;
    CategoryNodesEnum _categoryNodes;
}

@property (nonatomic, readwrite) CvtMediaTypeEnum mediaType;
@property (nonatomic, readwrite, retain) NSString *path;
//TimeInterval
//NSString * Timespan _duration;
@property (nonatomic, readwrite) double duration;
@property (nonatomic, readwrite) double bitRate;
@property (nonatomic, readwrite) double videoBitRate;
@property (nonatomic, readwrite) double audioBitRate;
@property (nonatomic, readwrite, retain) NSString *rawAudioFormat;
@property (nonatomic, readwrite) CvtMediaFormatEnum audioFormat;
@property (nonatomic, readwrite, retain) NSString *rawVideoFormat;
@property (nonatomic, readwrite)CvtMediaFormatEnum videoFormat;
@property (nonatomic, readwrite)int height;
@property (nonatomic, readwrite)int width;
@property (nonatomic, readwrite)double frameRate;
@property (nonatomic, readwrite)long totalFrames;
@property (nonatomic, readwrite, retain) NSString *rawInfo;
@property (nonatomic, readwrite)long samplingRate;
@property (nonatomic, readwrite, retain) NSString *sar;
@property (nonatomic, readwrite, retain) NSString *dar;
@property (nonatomic, readwrite)bool infoGathered;
@property (nonatomic, readwrite)double convertStart;
@property (nonatomic, readwrite)double convertLength;
@property (nonatomic, assign) CategoryNodesEnum categoryNodes;






@end

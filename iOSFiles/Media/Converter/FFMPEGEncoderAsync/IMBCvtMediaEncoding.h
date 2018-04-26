//
//  IMBCvtMediaEncoding.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-8.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCvtMediaFileEntity.h"

/// <summary>
/// -b参数
/// </summary>
#define Video500Bitrate @"500k"
#define Video700Bitrate @"700k"
#define Video700Bitrate @"700k"
#define Video900Bitrate @"900k"
#define Video1000Bitrate @"1000k"
#define Video1300Bitrate @"1300k"
#define Video1500Bitrate @"1500k"
#define Video1600Bitrate @"1600k"
#define Video1800Bitrate @"1800k"
#define Video2100Bitrate @"2100k"
#define Video2500Bitrate @"2500k"

/// <summary>
/// -ab参数
/// </summary>
#define LLQAudioBitrate @"96k"
#define LQAudioBitrate @"128k"
#define HQAudioBitrate @"256k"

/// <summary>
/// -ar参数
/// </summary>
#define LQAudioSamplingFrequency @"44100"
#define HQAudioSamplingFrequency @"48000"

@interface IMBCvtMediaEncoding : NSObject


+ (NSArray*) CreateMediaParamsMediaType:(CvtMediaFormatEnum) convertmediatype Quality:(CvtQualityTypeEnum)qualityType BitRate:(NSString*)bitrate Size:(NSString*)size;
+ (NSArray*) CreateRingtoneParamsQuality:(CvtQualityTypeEnum)qualityType StartSec:(double) startSec RingtoneLength:(double) rtLength;

@end

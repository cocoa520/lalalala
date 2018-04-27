//
//  IMBCvtMediaEncoding.m
//  iMobieTrans
//
//  Created by zhang yang on 13-5-8.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBCvtMediaEncoding.h"

@implementation IMBCvtMediaEncoding

+ (NSArray*) CreateMediaParamsMediaType:(CvtMediaFormatEnum)convertmediatype Quality:(CvtQualityTypeEnum)qualityType BitRate:(NSString*)bitrate Size:(NSString*)size {
    NSArray* parmsArray = nil;
    switch (convertmediatype) {
        case CvtMediaFormat_H264:
            if (qualityType == CvtMediaQuality_LowQuality)
            { parmsArray = [self H264LowQualityWithBitRate:bitrate Size:size]; }
            else
            { parmsArray = [self H264HighQualityWithBitRate:bitrate Size:size]; }
            break;
        case CvtMediaFormat_MPEG4:
            if (qualityType == CvtMediaQuality_LowQuality)
            { parmsArray = [self MPEG4LowQualityWithBitRate:bitrate Size:size]; }
            else
            { parmsArray = [self MPEG4HighQualityWithBitRate:bitrate Size:size]; }
            break;
        case CvtMediaFormat_MP:
            if (qualityType == CvtMediaQuality_LowQuality)
            { parmsArray = [self MPLowQuality]; }
            else
            { parmsArray = [self MPHighQuality]; }
            break;
        case CvtMediaFormat_AAC:
            if (qualityType == CvtMediaQuality_LowQuality)
            { parmsArray = [self AACLowQuality]; }
            else
            { parmsArray = [self AACHighQuality]; }
            break;
        default:
            break;
    }
    return parmsArray;
}

+ (NSArray*) CreateRingtoneParamsQuality:(CvtQualityTypeEnum)qualityType StartSec:(double) startSec RingtoneLength:(double) rtLength {
    NSArray* parmsArray = nil;
    if (rtLength >= 40.0) {
        if (qualityType == CvtMediaQuality_LowQuality) {
            parmsArray = [self RingtoneLowQualityWithStartSec:startSec Length:rtLength];
        } else {
            parmsArray = [self RingtoneHighQualityWithStartSec:startSec Length:rtLength];
        }
    } else {
        parmsArray = [self RingtoneLowLowQualityWithStartSec:startSec Length:rtLength];
    }
    return parmsArray;
}


//
+ (NSArray*) H264LowQualityWithBitRate:(NSString*) bitrate  Size:(NSString*)size
{
    //"-y -vcodec libx264 -r 30000/1001 -q 5 -b:v {0} -ab {1} -ar {2} -s {3} -acodec libvo_aacenc ";
    return [NSArray arrayWithObjects: @"-y",@"-vcodec",@"libx264",@"-r",@"30000/1001",@"-q",@"5",@"-b:v",bitrate,@"-ab",LQAudioBitrate,@"-ar",LQAudioSamplingFrequency, @"-s",size,@"-strict",@"-2", nil];
}

//
+ (NSArray*) H264HighQualityWithBitRate:(NSString*) bitrate  Size:(NSString*)size
{
    //"-y -vcodec libx264 -r 30000/1001 -q 3 -b:v {0} -ab {1} -s {2} -acodec libvo_aacenc "
    return [NSArray arrayWithObjects: @"-y",@"-vcodec",@"libx264",@"-r",@"30000/1001",@"-q",@"3",@"-b:v",bitrate,@"-ab",LQAudioBitrate, @"-s",size,@"-strict",@"-2", nil];
}

//OK
+ (NSArray*) MPEG4LowQualityWithBitRate:(NSString*) bitrate  Size:(NSString*)size
{
    //"-y -vcodec mpeg4 -r 30000/1001 -q 4 -b:v {0} -ab {1} -ar {2} -s {3} -acodec libvo_aacenc "
    return [NSArray arrayWithObjects: @"-y",@"-vcodec",@"mpeg4",@"-r",@"30000/1001",@"-q",@"4",@"-b:v",bitrate,@"-ab",LQAudioBitrate,@"-ar",LQAudioSamplingFrequency, @"-s",size,@"-strict",@"-2", nil];
}

//
+ (NSArray*) MPEG4HighQualityWithBitRate:(NSString*) bitrate  Size:(NSString*)size
{
    //"-y -vcodec mpeg4 -r 30000/1001 -q 2 -b:v {0} -ab {1} -s {2} -acodec libvo_aacenc "
    //return [NSArray arrayWithObjects: @"-y",@"-vcodec",@"mpeg4",@"-r",@"30000/1001",@"-q",@"2",@"-b:v",bitrate,@"-ab",LQAudioBitrate, @"-s",size,@"-strict",@"-2",@"-acodec",@"libvo_aacenc", nil];
    return [NSArray arrayWithObjects: @"-y",@"-vcodec",@"mpeg4",@"-r",@"30000/1001",@"-q",@"2",@"-b:v",bitrate,@"-ab",LQAudioBitrate, @"-s",size,@"-strict",@"-2", nil];
}

//OK
+ (NSArray*) MPLowQuality
{
    //"-y -vn -ab {0} -ar {1} -acodec libmp3lame "
    return [NSArray arrayWithObjects: @"-y",@"-vn",@"-ab",LQAudioBitrate,@"-ar",LQAudioSamplingFrequency, @"-strict",@"-2",@"-acodec",@"libmp3lame", nil];
}

//OK
+ (NSArray*) MPHighQuality
{
    //"-y -vn -ab {0} -acodec libmp3lame "
    return [NSArray arrayWithObjects: @"-y",@"-vn",@"-ab",LQAudioBitrate, @"-strict",@"-2",@"-acodec",@"libmp3lame", nil];
}

//OK
+ (NSArray*) AACLowQuality
{
    //"-y -vn -ab {0} -ar {1} "
    return [NSArray arrayWithObjects: @"-y",@"-vn",@"-ab",LQAudioBitrate,@"-ar",LQAudioSamplingFrequency, @"-strict",@"-2",@"-acodec",@"aac", nil];
}

//OK
+ (NSArray*) AACHighQuality
{
    //"-y -vn -ab {0} "
    return [NSArray arrayWithObjects: @"-y",@"-vn",@"-ab",LQAudioBitrate, @"-strict",@"-2",@"-acodec",@"aac", nil];
}

//OK
+ (NSArray*) RingtoneLowQualityWithStartSec:(double)startSec Length:(double)length {
    //"-y -vn -ab {0} -ar {1} -ss {2} -t {3} -acodec libvo_aacenc "
    return [NSArray arrayWithObjects: @"-y",@"-vn",@"-ab",LQAudioBitrate,@"-ar",LQAudioSamplingFrequency,@"-ss",[NSString stringWithFormat:@"%f", startSec], @"-t",[NSString stringWithFormat:@"%f", length], @"-strict",@"-2",@"-acodec",@"aac", nil];
}

//OK
+ (NSArray*) RingtoneHighQualityWithStartSec:(double)startSec Length:(double)length {
    //"-y -vn -ab {0} -ss {1} -t {2} -acodec libvo_aacenc "
    return [NSArray arrayWithObjects: @"-y",@"-vn",@"-ab",HQAudioBitrate, @"-ss",[NSString stringWithFormat:@"%f", startSec], @"-t",[NSString stringWithFormat:@"%f", length], @"-strict",@"-2",@"-acodec",@"aac", nil];
}

//OK
+ (NSArray*) RingtoneLowLowQualityWithStartSec:(double)startSec Length:(double)length {
    //"-y -vn -ab {0} -ar {1} -ss {2} -t {3} -acodec libvo_aacenc "
    return [NSArray arrayWithObjects: @"-y",@"-vn",@"-ab",LLQAudioBitrate,@"-ar",LQAudioSamplingFrequency,@"-ss",[NSString stringWithFormat:@"%f", startSec], @"-t",[NSString stringWithFormat:@"%f", length], @"-strict",@"-2", @"-acodec",@"aac", nil];

}


@end

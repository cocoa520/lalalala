//
//  IMBCvtDeviceEntity.h
//  iMobieTrans
//
//  Created by zhang yang on 13-4-15.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
#import "IMBCvtMediaFileEntity.h"

@interface IMBCvtDeviceEntity : NSObject {
    IPodFamilyEnum _iPodFamilyType;
    bool _isSupportMPEG4;
    long _MPEG4VideoMaxBitrate;
    CvtMediaFormatEnum _MPEG4AudioFormat;
    long _MPEG4AudioMaxBitrate;
    bool _isSupportH264;
    long _H264VideoMaxBitrate;
    CvtMediaFormatEnum _H264AudioFormat;
    long _H264AudioMaxBitrate;
    int _screenWidth;
    int _screenHeight;
    int _videoMaxWidth;
    int _videoMaxHeight;
    bool _isSupportMP3;
    bool _isSupportAAC;
    long _audioMaxBitrate;
}

/**
 *
 *      iPodFamilyType              设备型号；
 *      isSupportMPEG4              是否支持MPEG4格式；
 *      MPEG4VideoMaxBitrate        MPEG4格式的视频最大支持比特率；
 *      MPEG4AudioFormat            MPEG4格式的音频转换格式；
 *      MPEG4AudioMaxBitrate        MPEG4格式的音频最大支持比特率；
 *      isSupportH264               是否支持H264格式；
 *      H264VideoMaxBitrate         H264格式的视频最大支持比特率；
 *      H264AudioFormat             H264格式的音频转换格式；
 *      H264AudioMaxBitrate         H264格式的音频最大支持比特率；
 *      screenWidth                 设备屏幕像素宽度；
 *      screenHeight                设备屏幕像素高度；
 *      videoMaxWidth               视频最大支持宽度；
 *      videoMaxHeight              视频最大支持高度；
 *      isSupportMP3                是否支持MP3格式；
 *      isSupportAAC                是否支持AAC格式；
 *      audioMaxBitrate             音频支持的最大比特率；
 */

@property (nonatomic, readwrite) IPodFamilyEnum iPodFamilyType;
@property (nonatomic, readwrite) bool isSupportMPEG4;
@property (nonatomic, readwrite) long MPEG4VideoMaxBitrate;
@property (nonatomic, readwrite) CvtMediaFormatEnum MPEG4AudioFormat;
@property (nonatomic, readwrite) long MPEG4AudioMaxBitrate;
@property (nonatomic, readwrite) bool isSupportH264;
@property (nonatomic, readwrite) long H264VideoMaxBitrate;
@property (nonatomic, readwrite) CvtMediaFormatEnum H264AudioFormat;
@property (nonatomic, readwrite) long H264AudioMaxBitrate;
@property (nonatomic, readwrite) int screenWidth;
@property (nonatomic, readwrite) int screenHeight;
@property (nonatomic, readwrite) int videoMaxWidth;
@property (nonatomic, readwrite) int videoMaxHeight;
@property (nonatomic, readwrite) bool isSupportMP3;
@property (nonatomic, readwrite) bool isSupportAAC;
@property (nonatomic, readwrite) long audioMaxBitrate;


- (id)initWithiPodFamily:(IPodFamilyEnum)iPodFamilyType;


@end

//
//  IMBCvtDeviceEntity.m
//  iMobieTrans
//
//  Created by zhang yang on 13-4-15.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBCvtDeviceEntity.h"

@implementation IMBCvtDeviceEntity
@synthesize audioMaxBitrate = _audioMaxBitrate;
@synthesize H264AudioFormat = _H264AudioFormat;
@synthesize H264AudioMaxBitrate = _H264AudioMaxBitrate;
@synthesize H264VideoMaxBitrate = _H264VideoMaxBitrate;
@synthesize iPodFamilyType = _iPodFamilyType;
@synthesize isSupportAAC = _isSupportAAC;
@synthesize isSupportH264 = _isSupportH264;
@synthesize isSupportMP3 = _isSupportMP3;
@synthesize isSupportMPEG4 = _isSupportMPEG4;
@synthesize MPEG4AudioFormat = _MPEG4AudioFormat;
@synthesize MPEG4AudioMaxBitrate = _MPEG4AudioMaxBitrate;
@synthesize MPEG4VideoMaxBitrate = _MPEG4VideoMaxBitrate;
@synthesize screenHeight = _screenHeight;
@synthesize screenWidth = _screenWidth;
@synthesize videoMaxHeight = _videoMaxHeight;
@synthesize videoMaxWidth = _videoMaxWidth;

- (id)initWithiPodFamily1:(IPodFamilyEnum)iPodFamilyType;
{
    self = [super init];
    if (self) {
        _iPodFamilyType = iPodFamilyType;
        switch (_iPodFamilyType)
        {
            case iPod_Gen1_Gen2:
            case iPod_Gen3:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 0;
                _MPEG4AudioFormat = CvtMediaFormat_Unknown;
                _MPEG4AudioMaxBitrate = 0;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 0;
                _screenHeight = 0;
                _videoMaxWidth = 0;
                _videoMaxHeight = 0;
                _isSupportMP3 = true;
                _isSupportAAC = false;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Mini:
            case iPod_Gen4:
            case iPod_Gen4_2:
            case iPod_Nano_Gen1:
            case iPod_Nano_Gen2:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 0;
                _MPEG4AudioFormat = CvtMediaFormat_Unknown;
                _MPEG4AudioMaxBitrate = 0;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 0;
                _screenHeight = 0;
                _videoMaxWidth = 0;
                _videoMaxHeight = 0;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Gen5:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 768000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 320;
                _screenHeight = 240;
                _videoMaxWidth = 800;
                _videoMaxHeight = 600;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Classic:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 1500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 320;
                _screenHeight = 240;
                _videoMaxWidth = 800;
                _videoMaxHeight = 600;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen4:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 2500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 320;
                _screenHeight = 240;
                _videoMaxWidth = 800;
                _videoMaxHeight = 600;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen3:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 320;
                _screenHeight = 240;
                _videoMaxWidth = 800;
                _videoMaxHeight = 600;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen5:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 2500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 376;
                _screenHeight = 240;
                _videoMaxWidth = 768;
                _videoMaxHeight = 576;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen7:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 2500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 432;
                _screenHeight = 240;
                _videoMaxWidth = 720;
                _videoMaxHeight = 576;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen6:
            case iPod_Shuffle_Gen2:
            case iPod_Shuffle_Gen3:
            case iPod_Shuffle_Gen4:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 0;
                _MPEG4AudioFormat = CvtMediaFormat_Unknown;
                _MPEG4AudioMaxBitrate = 0;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 0;
                _screenHeight = 0;
                _videoMaxWidth = 0;
                _videoMaxHeight = 0;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Shuffle_Gen1:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 0;
                _MPEG4AudioFormat = CvtMediaFormat_Unknown;
                _MPEG4AudioMaxBitrate = 0;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 0;
                _screenHeight = 0;
                _videoMaxWidth = 0;
                _videoMaxHeight = 0;
                _isSupportMP3 = true;
                _isSupportAAC = false;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Touch_1:
            case iPod_Touch_2:
            case iPod_Touch_3:
            case iPhone_3G:
            case iPhone_3GS:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 480;
                _screenHeight = 320;
                _videoMaxWidth = 640;
                _videoMaxHeight = 480;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
                
            case iPhone:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 1500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 480;
                _screenHeight = 320;
                _videoMaxWidth = 640;
                _videoMaxHeight = 480;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;                
            case iPod_Touch_4:
            case iPhone_4:
            case iPhone_4S:
                //视频支持的大小格式的设置需要查询3rd generation  1080p 2nd generation 720p
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 960;
                _screenHeight = 640;
                _videoMaxWidth = 1920;
                _videoMaxHeight = 1080;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPhone_5:
            case iPhone_5S:
            case iPhone_5C:
            case iPhone_6:
            case iPhone_6_Plus:
            case iPhone_6S:
            case iPhone_SE:
            case iPhone_6S_Plus:
            case iPhone_7:
            case iPhone_7_Plus:
            case iPhone_8:
            case iPhone_8_Plus:
            case iPhone_X:
            case iPod_Touch_5:
            case iPod_Touch_6:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 1136;
                _screenHeight = 640;
                _videoMaxWidth = 1920;
                _videoMaxHeight = 1280;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPad_1:
            case iPad_2:
            case iPad_mini:
            case iPad_mini_2:
            case iPad_mini_3:
            case iPad_mini_4:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 1024;
                _screenHeight = 768;
                _videoMaxWidth = 1920;
                _videoMaxHeight = 1280;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case The_New_iPad:
            case iPad_4:
            case iPad_Air:
            case iPad_Air2:
            case iPad_Pro:
            case iPad_5:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000; //1Mbps=1024kbps = 1024kb/s;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 2048;
                _screenHeight = 1536;
                _videoMaxWidth = 1920;
                _videoMaxHeight = 1280;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            default:
                break;
        }
    }
    return self;
}

- (id)initWithiPodFamily:(IPodFamilyEnum)iPodFamilyType;
{
    self = [super init];
    if (self) {
        _iPodFamilyType = iPodFamilyType;
        switch (_iPodFamilyType)
        {
            case iPod_Gen1_Gen2:
            case iPod_Gen3:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 0;
                _MPEG4AudioFormat = CvtMediaFormat_Unknown;
                _MPEG4AudioMaxBitrate = 0;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 0;
                _screenHeight = 0;
                _videoMaxWidth = 0;
                _videoMaxHeight = 0;
                _isSupportMP3 = true;
                _isSupportAAC = false;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Mini:
            case iPod_Gen4:
            case iPod_Gen4_2:
            case iPod_Nano_Gen1:
            case iPod_Nano_Gen2:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 0;
                _MPEG4AudioFormat = CvtMediaFormat_Unknown;
                _MPEG4AudioMaxBitrate = 0;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 0;
                _screenHeight = 0;
                _videoMaxWidth = 0;
                _videoMaxHeight = 0;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Gen5:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 768000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 320;
                _screenHeight = 240;
                _videoMaxWidth = 800;
                _videoMaxHeight = 600;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Classic:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 1500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 320;
                _screenHeight = 240;
                _videoMaxWidth = 800;
                _videoMaxHeight = 600;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen4:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 2500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 320;
                _screenHeight = 240;
                _videoMaxWidth = 800;
                _videoMaxHeight = 600;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen3:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 320;
                _screenHeight = 240;
                _videoMaxWidth = 800;
                _videoMaxHeight = 600;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen5:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 2500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 376;
                _screenHeight = 240;
                _videoMaxWidth = 768;
                _videoMaxHeight = 576;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen7:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 2500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 432;
                _screenHeight = 240;
                _videoMaxWidth = 720;
                _videoMaxHeight = 576;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Nano_Gen6:
            case iPod_Shuffle_Gen2:
            case iPod_Shuffle_Gen3:
            case iPod_Shuffle_Gen4:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 0;
                _MPEG4AudioFormat = CvtMediaFormat_Unknown;
                _MPEG4AudioMaxBitrate = 0;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 0;
                _screenHeight = 0;
                _videoMaxWidth = 0;
                _videoMaxHeight = 0;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Shuffle_Gen1:
                _isSupportMPEG4 = false;
                _MPEG4VideoMaxBitrate = 0;
                _MPEG4AudioFormat = CvtMediaFormat_Unknown;
                _MPEG4AudioMaxBitrate = 0;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_Unknown;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 0;
                _screenHeight = 0;
                _videoMaxWidth = 0;
                _videoMaxHeight = 0;
                _isSupportMP3 = true;
                _isSupportAAC = false;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Touch_1:
            case iPod_Touch_2:
            case iPod_Touch_3:
            case iPhone_3G:
            case iPhone_3GS:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = false;
                _H264VideoMaxBitrate = 0;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 0;
                _screenWidth = 480;
                _screenHeight = 320;
                _videoMaxWidth = 640;
                _videoMaxHeight = 480;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPhone:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 1500000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 480;
                _screenHeight = 320;
                _videoMaxWidth = 640;
                _videoMaxHeight = 480;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Touch_4:
            case iPhone_4:
            case iPhone_4S:
                //视频支持的大小格式的设置需要查询3rd generation  1080p 2nd generation 720p
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 960;
                _screenHeight = 640;
                _videoMaxWidth = 1280;
                _videoMaxHeight = 720;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPhone_6:
            case iPhone_6_Plus:
            case iPhone_6S:
            case iPhone_6S_Plus:
            case iPhone_7:
            case iPhone_7_Plus:
            case iPhone_8:
            case iPhone_8_Plus:
            case iPhone_X:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 1134;
                _screenHeight = 750;
                _videoMaxWidth = 1920;
                _videoMaxHeight = 1080;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPhone_5:
            case iPhone_5S:
            case iPhone_5C:
            case iPod_Touch_6:
            case iPhone_SE:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 1136;
                _screenHeight = 640;
                _videoMaxWidth = 1920;
                _videoMaxHeight = 1080;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPod_Touch_5:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 1136;
                _screenHeight = 640;
                _videoMaxWidth = 1280;
                _videoMaxHeight = 720;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPad_1:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 1024;
                _screenHeight = 768;
                _videoMaxWidth = 1280;
                _videoMaxHeight = 720;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPad_2:
            case The_New_iPad:
            case iPad_4:
            case iPad_mini:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 1024;
                _screenHeight = 768;
                _videoMaxWidth = 1920;
                _videoMaxHeight = 1080;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            case iPad_mini_2:
            case iPad_mini_3:
            case iPad_mini_4:
            case iPad_Air:
            case iPad_Air2:
            case iPad_Pro:
            case iPad_5:
                _isSupportMPEG4 = true;
                _MPEG4VideoMaxBitrate = 2500000;
                _MPEG4AudioFormat = CvtMediaFormat_AAC;
                _MPEG4AudioMaxBitrate = 160000;
                _isSupportH264 = true;
                _H264VideoMaxBitrate = 31192000;//1Mbps=1024kbps = 1024kb/s;
                _H264AudioFormat = CvtMediaFormat_AAC;
                _H264AudioMaxBitrate = 160000;
                _screenWidth = 2048;
                _screenHeight = 1536;
                _videoMaxWidth = 1920;
                _videoMaxHeight = 1080;
                _isSupportMP3 = true;
                _isSupportAAC = true;
                _audioMaxBitrate = 320000;
                break;
            default:
                break;
        }
    }
    return self;
}

@end

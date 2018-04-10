//
//  IMBConfigPlist.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-11.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBCvtMediaFileEntity.h"

#define DeviceConfigPath @"config"
#define CvtConfigName @"iMobieConvertConfig.plist"

@interface IMBConfig : NSObject {
    IMBiPod *_ipod;
    NSString *_configDevicePath;
    NSString *_configLocalPath;
    // 媒体格式
    CvtMediaFormatEnum _mediaFormat;
    /// 是否允许程序自动调整大小
    bool _autoSize;
    /// 音频格式
   CvtMediaFormatEnum _audioFormat;
   //是否转换视频格式
   bool _mediaNoConvert;
   //是否转换音频格式
   bool _audioNoConvert ;
   //视频媒体转换的质量
    CvtQualityTypeEnum _quality;
}

@property (nonatomic, readwrite) CvtMediaFormatEnum mediaFormat;
@property (nonatomic, readwrite) CvtMediaFormatEnum audioFormat;
@property (nonatomic, readwrite) bool autoSize;
@property (nonatomic, readwrite) bool mediaNoConvert;
@property (nonatomic, readwrite) bool audioNoConvert;
@property (nonatomic, readwrite) CvtQualityTypeEnum quality;

- (id)initWithIPod:(IMBiPod*)iPod;
- (void) saveToDevice;


@end

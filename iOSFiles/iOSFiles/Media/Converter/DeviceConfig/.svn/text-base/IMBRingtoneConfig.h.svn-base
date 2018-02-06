//
//  IMBRingtoneConfig.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-11.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCvtMediaFileEntity.h"

#define RtCvtConfigName @"RingtoneConvertConfig.plist"
#define RtDeviceConfigPath @"iMobieConfig"

typedef enum
{
    RT_SecRest = -1,
    RT_Sec25 = 25,
    RT_Sec40 = 40
}CvtRingtoneSizeEnum;

@interface IMBRingtoneConfig : NSObject {
    NSString *_exportPath;
    NSString *_configLocalPath;
    /// 开始秒数
    int _startSecond;
    /// 转换的大小
    CvtRingtoneSizeEnum _convertSize;
    //下次不再提醒
    BOOL _allSkip;
    
    NSFileManager *fm;
}

@property (nonatomic, readwrite) int startSecond;
@property (nonatomic, readwrite) CvtRingtoneSizeEnum convertSize;
@property (nonatomic, readwrite) BOOL allSkip;
@property (nonatomic, readwrite, retain) NSString *exportPath;

+ (IMBRingtoneConfig*)singleton;

- (void) saveToDevice;

@end

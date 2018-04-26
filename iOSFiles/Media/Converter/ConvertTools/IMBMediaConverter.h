//
//  IMBMediaConverter.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-12.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBCvtDeviceEntity.h"
#import "IMBCvtMediaConvertEncoder.h"
#import "IMBConfig.h"
#import "IMBRingtoneConfig.h"
#import "IMBNewTrack.h"

typedef struct {
    NSMutableArray *convertFiles;
    NSMutableArray *isRingtoneArray;
}cvtFileRingtoneStruct;

typedef struct {
    NSMutableArray *outputCvtMediaList;
    NSMutableArray *outputCvtMediaListMapping;
}OutPutWithMappingStruct;

typedef struct {
    NSString *encodedMediaPath;
    CategoryNodesEnum categoryType;
} OutputStringTypeMapping;


@interface IMBMediaConverter : NSObject {
    IMBiPod *_iPod;
    IMBCvtDeviceEntity *_cvtDevice;
    IMBCvtMediaConvertEncoder *_convEnc;
    NSMutableArray *_convertFiles;//mediafile
    NSMutableArray *_isRingtoneArray;
    cvtFileRingtoneStruct convertFileRintoneStruct;
    IMBConfig *_config;
    IMBRingtoneConfig *_rtConfig;
    NSString *_convertTempPath;
    int _totalItemCount;
    int _currentItemCount;
    long _totalDatetime;
    long _currCompleteDatetime;
    int _successCount;
    int _faildCount;
    int _cancelCount;
    bool _convertCancel;
    BOOL _isRingtone;
    BOOL _isiTunesU;
    int _curCompletedCount;
    NSMutableArray *_outputCvtMediaList;
    NSMutableArray *_outputCvtMediaListMapping;
    BOOL _isThreadBreak;
    BOOL _isStop;
}
@property (nonatomic,assign)BOOL isStop;
@property (nonatomic,readonly) NSMutableArray* outputCvtMediaList;
@property (nonatomic,readonly) NSMutableArray* outputCvtMediaListMapping;
@property (nonatomic,readonly) NSMutableArray* convertFiles;
    
+ (IMBMediaConverter*)singleton;
- (void) reInitWithiPod:(IMBiPod*)iPod;
- (void) reInit;
- (void) convertMedia:(NSString*) folderPath isRt:(bool)isRingtone;
- (BOOL) checkDeviceConvertWithiPod:(IMBiPod*) iPod Path:(NSString*)mediaPath IsCvtVideo:(bool)isCvtVideo IsCvtAudio:(bool)isCvtAudio SupportVideo:(bool)isSprtVideo SupportAudio:(bool)isSprtAudio SupportExt:(bool)isSupportExt;

- (BOOL) checkDeviceConvertWithiPod:(IMBiPod*) iPod Path:(NSString*)mediaPath IsCvtVideo:(bool)isCvtVideo IsCvtAudio:(bool)isCvtAudio SupportVideo:(bool)isSprtVideo SupportAudio:(bool)isSprtAudio SupportExt:(bool)isSupportExt withType:(CategoryNodesEnum)categoryEnum;

-(IMBNewTrack*)createNewtrackWithffmpeg:(NSString*) mediaFilePath;

-(NSString*) getVideoArtworkData:(NSString*) mediaFilePath;
@end

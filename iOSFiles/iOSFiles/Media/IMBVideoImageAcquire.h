//
//  IMBVideoImageAquire.h
//  iMobieTrans
//
//  Created by iMobie on 6/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBSession.h"

@interface IMBVideoImageAcquire : NSObject{
    NSString *_ffmpegApp;
    int _hour;
    int _minutes;
    float _seconds;
    int _width;
    int _height;
    BOOL isSupportToGet;
    NSMutableString *_ffmpegOutputStr;
    NSString *_filePath;
    IMBiPod *_ipod;
    NSString *_localPath;  //视屏本地路径
    BOOL _isMovies;
}
@property (nonatomic,assign)BOOL isMovies;
@property (nonatomic,retain) NSString *ffmpegApp;
@property (assign) int hour;
@property (assign) int minutes;
@property (assign) float seconds;
@property (assign) int width;
@property (assign) int height;
@property (nonatomic,retain) NSString *filePath;

- (id)initWithPath:(NSString *)path withIpod:(IMBiPod *)ipod;
- (id)initwithDevicePath:(NSString *)path withIpod:(IMBiPod *)ipod;
- (id)initwithLocalPath:(NSString *)localpath;
- (NSString *)getVideoArtWork;
- (NSString *)getInfo;
- (NSString *)getDeviceInfo;

@end

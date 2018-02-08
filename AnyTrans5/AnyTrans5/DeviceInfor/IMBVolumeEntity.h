//
//  VolumeEntity.h
//  VolumTest1.1
//
//  Created by zhang yang on 13-7-28.
//  Copyright (c) 2013年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    VolumeType_System = 1,
    VolumeType_Audio = 2,
    VolumeType_Video = 3,
    VolumeType_Ringtones = 4,
    VolumeType_Books = 5,
    VolumeType_Apps = 6,
    VolumeType_Others = 7,
    VolumeType_Photo = 8
    
} VolumeTypeEnum;


@interface IMBVolumeEntity : NSObject {
    NSString* _volumeName;
    VolumeTypeEnum _volumeType;
    NSString* _volumebarImageName;
    NSString* _voluemRectImageName;
    double _percentage;
    long long _size;
}


@property  (nonatomic, retain) NSString* volumeName;
@property  (nonatomic, retain) NSString* volumebarImageName;
@property  (nonatomic, retain) NSString* voluemRectImageName;
@property  (nonatomic, assign) double percentage;
@property  (nonatomic, assign) long long size;
@property  (nonatomic, assign) VolumeTypeEnum volumeType;

-(void)setImageNameWithPrefix:(NSString*)prefix;

@end
//
//  VolumeEntity.m
//  VolumTest1.1
//
//  Created by zhang yang on 13-7-28.
//  Copyright (c) 2013年 iMobie. All rights reserved.
//

#import "IMBVolumeEntity.h"

@implementation IMBVolumeEntity
@synthesize percentage = _percentage;
@synthesize size = _size;
@synthesize voluemRectImageName = _voluemRectImageName;
@synthesize volumebarImageName = _volumebarImageName;
@synthesize volumeName = _volumeName;
@synthesize volumeType = _volumeType;

- (void)dealloc
{
    if (_voluemRectImageName != nil) {
        [_voluemRectImageName release];
    }
    if (_volumebarImageName != nil) {
        [_volumebarImageName release];
    }
    if (_volumeName != nil) {
        [_volumeName release];
    }
    [super dealloc];
}

-(void)setImageNameWithPrefix:(NSString*)prefix {
    self.voluemRectImageName = [prefix stringByAppendingString:@"_rect"];
    self.volumebarImageName = [prefix stringByAppendingString:@"_bar"];
}


@end

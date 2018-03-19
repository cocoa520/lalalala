//
//  IMBDevicePageFolderModel.m
//  iOSFiles
//
//  Created by iMobie on 18/2/1.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDevicePageFolderModel.h"
#import "IMBTrack.h"
#import "IMBPhotoEntity.h"
#import "IMBBookEntity.h"
#import "IMBAppEntity.h"
#import "StringHelper.h"

@interface IMBDevicePageFolderModel()

@end

@implementation IMBDevicePageFolderModel
@synthesize image = _image;
@synthesize name = _name;
@synthesize time = _time;
@synthesize size = _size;
@synthesize counts = _counts;
@synthesize trackArray = _trackArray;
@synthesize idx = _idx;
@synthesize sizeString = _sizeString;
@synthesize countsString = _countsString;
@synthesize subPhotoArray = _subPhotoArray;
@synthesize nodesEnum = _nodesEnum;

- (id)init {
    if ([super init]) {
        _subPhotoArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)setTrackArray:(NSArray *)trackArray {
    _trackArray = trackArray;
    
    _size = 0;
    if (trackArray.count) {
        _counts = trackArray.count;
        for (IMBTrack *track in trackArray) {
            _size += track.fileSize;
        }
    }
    [self setSizeStr];
}

- (void)setSizeStr {
    _time = @"2018-1-20 18:02";
    if (_counts || _counts == 0) {
        self.countsString = [NSString stringWithFormat:@"%lu",_counts];
    }else {
        self.countsString = @"-";
    }
    
    if (_size == 0) {
        _sizeString = [@"0 B" retain];
       return;
    }
    _sizeString = [[StringHelper getFileSizeString:_size reserved:2] retain];
}

- (void)dealloc {
    
    if (_name) {
        [_name release];
        _name = nil;
    }
    
    if (_time) {
        [_time release];
        _time = nil;
    }
    
    if (_trackArray) {
        [_trackArray release];
        _trackArray = nil;
    }
     if (_sizeString) {
        [_sizeString release];
        _sizeString = nil;
    }
    
    if (_subPhotoArray) {
        [_subPhotoArray release];
        _subPhotoArray = nil;
    }
    [super dealloc];
}

@end

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

@interface IMBDevicePageFolderModel()<NSCopying>

@end

@implementation IMBDevicePageFolderModel

@synthesize name = _name;
@synthesize time = _time;
@synthesize size = _size;
@synthesize counts = _counts;
@synthesize trackArray = _trackArray;
@synthesize photoArray = _photoArray;
@synthesize booksArray = _booksArray;
@synthesize appsArray = _appsArray;
@synthesize idx = _idx;
@synthesize sizeString = _sizeString;
@synthesize countsString = _countsString;
@synthesize subPhotoArray = _subPhotoArray;



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

- (void)setPhotoArray:(NSArray *)photoArray {
    _photoArray = photoArray;
    
    _size = 0;
    if (photoArray.count) {
        for (NSArray *subArr in photoArray) {
            _counts += subArr.count;
            for (IMBPhotoEntity *photo in subArr) {
                _size += photo.photoSize;
            }
        }
        
    }
    [self setSizeStr];
}


- (void)setBooksArray:(NSArray *)booksArray {
    _booksArray = booksArray;
    
    _size = 0;
    if (booksArray.count) {
        _counts = booksArray.count;
        for (IMBBookEntity *book in booksArray) {
            _size += book.size;
        }
    }
    [self setSizeStr];
}

- (void)setAppsArray:(NSArray *)appsArray {
    _appsArray = appsArray;
    
    _size = 0;
    if (appsArray.count) {
        _counts = appsArray.count;
        for (IMBAppEntity *app in appsArray) {
            _size += (app.appSize + app.documentSize);
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
//    double size = _size/1024.0/1024.0;
//    if (size >= 1000) {
//        size /= 1024.0;
//        _sizeString = [NSString stringWithFormat:@"%.2f GB",size];
//    }else if (size >= 1){
//        _sizeString = [NSString stringWithFormat:@"%.2f MB",size];
//    }else {
//        _sizeString = [NSString stringWithFormat:@"%.2f KB",size*1024.0];
//    }
    
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
    
    if (_photoArray) {
        [_photoArray release];
        _photoArray = nil;
    }
    
    if (_booksArray) {
        [_booksArray release];
        _booksArray = nil;
    }
    
    if (_appsArray) {
        [_appsArray release];
        _appsArray = nil;
    }
    
    if (_sizeString) {
        [_sizeString release];
        _sizeString = nil;
    }
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    if (self.photoArray) {
        IMBDevicePageFolderModel *copyModel = [[IMBDevicePageFolderModel alloc] init];
        copyModel.photoArray = [self.photoArray copy];
        copyModel.idx = self.idx;
        return copyModel;
    }else {
        return self;
    }
    
}
@end

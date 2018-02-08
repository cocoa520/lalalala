//
//  IMBSyncPhotoData.m
//  iMobieTrans
//
//  Created by iMobie on 7/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBSyncPhotoData.h"

@implementation IMBSyncPhotoData
@synthesize albumKind;
@synthesize albumName;
@synthesize albumUUID;
@synthesize albumZpk;

@synthesize photoUUID;
@synthesize photoZpk;
@synthesize photoDate;
@synthesize photoName;
@synthesize photoFileSize;

@synthesize imagePath;
@synthesize imageUUID;

@synthesize thumbPath;
@synthesize thumbName;
@synthesize isFavorite = _isFavorite;
@synthesize photoCreateDate = _photoCreateDate;

- (id)init
{
    self = [super init];
    if (self) {
        albumKind = -1;
        albumName = @"";
        albumUUID = @"";
        albumZpk = -2;
        
        photoUUID = @"";
        photoZpk = -3;
        photoDate = 0;
        photoName = @"";
        
        imagePath = @"";
        imageUUID = @"";
        
        thumbPath = @"";
        thumbName = @"";
        _isFavorite = NO;
        _photoCreateDate = 0;
    }
    return self;
}

@end

//
//  IMBPhotoEntity.m
//  iMobieTrans
//
//  Created by iMobie on 14-6-16.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBPhotoEntity.h"

@implementation IMBPhotoEntity
@synthesize isSelect;
@synthesize imageRect;
@synthesize albumZpk;
@synthesize photoCounts;
@synthesize albumKind;
@synthesize albumTitle;
@synthesize albumUUID;
@synthesize albumType;
@synthesize albumSubType;
@synthesize createdDate;
@synthesize photoBurstsID;
@synthesize photoAsset;
@synthesize photoZpk;
@synthesize photoHeight;
@synthesize photoWidth;
@synthesize photoKind;
@synthesize photoRiginal;
@synthesize photoDate;
@synthesize photoDateData;
@synthesize photoKindSubtype;
@synthesize photoName;
@synthesize photoPath;
@synthesize photoSize;
@synthesize photoTitle;
@synthesize photoUUID;
//@synthesize libAlbumZpk;
@synthesize thumbPath;
@synthesize photoImage;
@synthesize allPath;
@synthesize videoPath;
@synthesize albumUUIDString;
@synthesize photoUUIDString;
@synthesize photoType;
@synthesize image;
@synthesize loadingImage;
@synthesize photoImageData;
@synthesize photoData;
@synthesize isEditorPhoto;
@synthesize catchName = _catchName;
@synthesize cloudLocalState = _cloudLocalState;
@synthesize cloudPathArray = _cloudPathArray;
@synthesize iCloudImage = _iCloudImage;
@synthesize thumbImagePath = _thumbImagePath;
@synthesize oriPath = _oriPath;
@synthesize toolTip = _toolTip;
@synthesize isexisted = _isexisted;
@synthesize kindSubType;
@synthesize extension = _extension;
- (id)init
{
    if (self = [super init]) {
        isEditorPhoto = NO;
        loadingImage = 0;
        photoType = CommonType;
        image = nil;
        _cloudPathArray = [[NSMutableArray alloc] init];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc
{
    if (_cloudPathArray != nil) {
        [_cloudPathArray release];
        _cloudPathArray = nil;
    }
    [super dealloc];
}

@end

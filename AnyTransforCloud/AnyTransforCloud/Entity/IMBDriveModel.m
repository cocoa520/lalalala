//
//  IMBCloudDataModel.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBDriveModel.h"

@implementation IMBDriveModel
@synthesize fileLoadURL = _fileLoadURL;
@synthesize thumbnailURL = _thumbnailURL;
@synthesize createdDateString = _createdDateString;
@synthesize lastModifiedDateString = _lastModifiedDateString;
//@synthesize fileName = _fileName;
//@synthesize fileSize = _fileSize;
@synthesize fileSystemCreatedDate = _fileSystemCreatedDate;
@synthesize fileSystemLastDate = _fileSystemLastDate;
@synthesize fileID = _fileID;
//@synthesize isFolder = _isFolder;
@synthesize zone = _zone;
@synthesize etag = _etag;
@synthesize extension = _extension;
@synthesize filePath = _filePath;
@synthesize fileTypeEnum = _fileTypeEnum;
@synthesize transferImage = _transferImage;
@synthesize iConimage = _iConimage;
@synthesize isTrashed = _isTrashed;
@synthesize children = _children;
@synthesize showType = _showType;
@synthesize hasLoadchid = _hasLoadchid;
@synthesize isDownLoad = _isDownLoad;
@synthesize image = _image;
@synthesize completeDate = _completeDate;
@synthesize driveID = _driveID;
@synthesize isForbiddden = _isForbiddden;
@synthesize sreachSize = _sreachSize;
@synthesize completeInterval = _completeInterval;

- (id)init {
    if ([super init]) {
        _fileLoadURL = @"";
        _thumbnailURL = @"";
        _createdDateString = @"";
        _fileSystemCreatedDate = @"";
        _lastModifiedDateString = @"";
//        _fileName = @"";
        _fileSystemLastDate = @"";
//        _filesize = 0;
//        _isFolder = NO;

        _filePath = @"";
        _checkState = UnChecked;
        _showType = collapseType;
        _hasLoadchid = NO;
        _isForbiddden = NO;
    }
    return self;
}

- (NSArray *)children {
    if (_children == NULL) {
         _children = [[NSMutableArray alloc] init];
    }
    return _children;
}

- (NSInteger)numberOfChildren {
     return  [self children].count;
}

- (IMBDriveModel *)childAtIndex:(NSInteger)n {
     return [[self children] objectAtIndex:n];
}


-(void)dealloc{
    if (_image) {
        [_image release];
        _image = nil;
    }
    [super dealloc];
}

@end

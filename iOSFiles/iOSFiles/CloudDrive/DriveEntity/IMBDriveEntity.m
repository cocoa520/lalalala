//
//  IMBDriveEntity.m
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDriveEntity.h"

@implementation IMBDriveEntity
@synthesize fileLoadURL = _fileLoadURL;
@synthesize createdDateString = _createdDateString;
@synthesize lastModifiedDateString = _lastModifiedDateString;
@synthesize fileName = _fileName;
@synthesize fileSize = _fileSize;
@synthesize fileSystemCreatedDate = _fileSystemCreatedDate;
@synthesize fileSystemLastDate = _fileSystemLastDate;
@synthesize fileID = _fileID;
@synthesize childCount = _childCount;
@synthesize isFolder = _isFolder;
@synthesize checkState = _checkState;
@synthesize image = _image;
@synthesize docwsid = _docwsid;
@synthesize zone = _zone;
@synthesize etag = _etag;
- (id)init {
    if ([super init]) {
        _fileLoadURL = @"";
        _createdDateString = @"";
        _fileSystemCreatedDate = @"";
        _lastModifiedDateString = @"";
        _fileName = @"";
        _fileSystemLastDate = @"";
        _fileSize = 0;
        _isFolder = NO;
        _childCount = 0;
    }
    return self;
}

- (void)setCheckState:(CheckStateEnum)checkState
{
    _checkState = checkState;
}

-(void)dealloc{
    [super dealloc];
    if (_image) {
        [_image release];
        _image = nil;
    }
}
@end

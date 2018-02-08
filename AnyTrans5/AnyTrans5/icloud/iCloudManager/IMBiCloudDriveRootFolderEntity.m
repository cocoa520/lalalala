//
//  IMBiCloudDriveRootFolderEntity.m
//  iCloudDriveDemo_2
//
//  Created by iMobie on 2/11/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import "IMBiCloudDriveRootFolderEntity.h"

@implementation IMBiCloudDriveDownloadFailFileEntity
@synthesize error = _error;
@synthesize fileName = _fileName;

- (id)init
{
    self = [super init];
    if (self) {
        _error = @"";
        _fileName = @"";
    }
    return self;
}


@end

@implementation IMBiCloudDriveFolderEntity
@synthesize drivewsid = _drivewsid;
@synthesize docwsid = _docwsid;
@synthesize zone = _zone;
@synthesize name = _name;
@synthesize etag = _etag;
@synthesize type = _type;
@synthesize numberOfItems = _numberOfItems;
@synthesize fileItemsList = _fileItemsList;
@synthesize size = _size;
@synthesize dateModified = _dateModified;
@synthesize parentId = _parentId;
@synthesize extension = _extension;
@synthesize maxDepth = _maxDepth;
@synthesize supportedExtensions = _supportedExtensions;
@synthesize parentFolder = _parentFolder;
@synthesize image = _image;
@synthesize downloadError = _downloadError;
@synthesize finishSize = _finishSize;
@synthesize downloadPath = _downloadPath;
- (id)init
{
    self = [super init];
    if (self) {
        _drivewsid = @"";
        _docwsid = @"";
        _zone = @"";
        _name = @"";
        _etag = @"";
        _type = @"";
        _numberOfItems = 0;
        _fileItemsList = [[NSMutableArray alloc] init];
        _size = 0;
        _finishSize = 0;
        _dateModified = @"";
        _parentId = @"";
        _extension = @"";
        _maxDepth = @"";
        _supportedExtensions = nil;
        _parentFolder = @"";
        _downloadError = @"";
        _downloadPath = nil;
    }
    return self;
}

- (void)setImage:(NSImage *)image
{
    if (_image != image) {
        [_image release];
        _image = [image retain];
    }
}

- (void)setSupportedExtensions:(NSMutableArray *)supportedExtensions {
    if (supportedExtensions != nil) {
        _supportedExtensions = [supportedExtensions retain];
    }
}

- (void)dealloc
{
    if (_fileItemsList != nil) {
        [_fileItemsList release];
        _fileItemsList = nil;
    }
    if (_supportedExtensions != nil) {
        [_supportedExtensions release];
        _supportedExtensions = nil;
    }
  
    [super dealloc];
}

@end

@implementation IMBiCloudDriveRootFolderEntity
@synthesize docwsid = _docwsid;
@synthesize drivewsid = _drivewsid;
@synthesize zone = _zone;
@synthesize name = _name;
@synthesize etag = _etag;
@synthesize type = _type;
@synthesize numberOfItems = _numberOfItems;
@synthesize folderItemsList = _folderItemsList;

- (id)init
{
    self = [super init];
    if (self) {
        _drivewsid = @"";
        _docwsid = @"";
        _zone = @"";
        _name = @"";
        _etag = @"";
        _type = @"";
        _numberOfItems = 0;
        _folderItemsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_folderItemsList != nil) {
        [_folderItemsList release];
        _folderItemsList = nil;
    }
    [super dealloc];
}


@end

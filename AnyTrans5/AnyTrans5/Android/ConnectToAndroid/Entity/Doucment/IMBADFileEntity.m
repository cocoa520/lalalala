//
//  IMBADFileEntity.m
//  PhoneRescue_Android
//
//  Created by iMobie on 4/13/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBADFileEntity.h"

@implementation IMBADFileEntity
@synthesize fileName = _fileName;
@synthesize filePath = _filePath;
@synthesize fileSize = _fileSize;
@synthesize fileImage = _fileImage;
@synthesize isFile = _isFile;
@synthesize fileList = _fileList;
@synthesize parentName = _parentName;
@synthesize docSelectedCount = _docSelectedCount;
@synthesize fileType = _fileType;
@synthesize imageFileCount = _imageFileCount;
@synthesize audioFileCount = _audioFileCount;
@synthesize videoFileCount = _videoFileCount;
@synthesize cummonFileCount = _cummonFileCount;
@synthesize fileExtension = _fileExtension;
@synthesize localPath = _localPath;
@synthesize title = _title;
@synthesize createTime = _createTime;

- (id)init {
    self = [super init];
    if (self) {
        _isFile = NO;
        _fileSize = 0;
        _imageFileCount = 0;
        _audioFileCount = 0;
        _videoFileCount = 0;
        _cummonFileCount = 0;
        _createTime = 0;
        _fileList = [[NSMutableArray alloc] init];
        _docSelectedCount = 0;
    }
    return self;
}

- (void)dealloc
{
    if (_filePath != nil) {
        [_filePath release];
        _filePath = nil;
    }
    if (_fileName != nil) {
        [_fileName release];
        _fileName = nil;
    }
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    if (_fileImage != nil) {
        [_fileImage release];
        _fileImage = nil;
    }
    if (_parentName != nil) {
        [_parentName release];
        _parentName = nil;
    }
    if (_fileExtension != nil) {
        [_fileExtension release];
        _fileExtension = nil;
    }
    if (_localPath != nil) {
        [_localPath release];
        _localPath = nil;
    }
    [super dealloc];
}

- (void)setFileName:(NSString *)fileName {
    if (_fileName != nil) {
        [_fileName release];
        _fileName = nil;
    }
    _fileName = [fileName retain];
}

- (void)setTitle:(NSString *)title {
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    _title = [title retain];
}

- (void)setFilePath:(NSString *)filePath {
    if (_filePath != nil) {
        [_filePath release];
        _filePath = nil;
    }
    _filePath = [filePath retain];
}

- (void)setParentName:(NSString *)parentName {
    if (_parentName != nil) {
        [_parentName release];
        _parentName = nil;
    }
    _parentName = [parentName retain];
}

- (void)setFileImage:(NSImage *)fileImage {
    if (_fileImage != nil) {
        [_fileImage release];
        _fileImage = nil;
    }
    _fileImage = [fileImage retain];
}

- (void)setFileExtension:(NSString *)fileExtension {
    if (_fileExtension != nil) {
        [_fileExtension release];
        _fileExtension = nil;
    }
    _fileExtension = [fileExtension retain];
}

- (void)setLocalPath:(NSString *)localPath {
    if (_localPath != nil) {
        [_localPath release];
        _localPath = nil;
    }
    _localPath = [localPath retain];
}


@end

//
//  IMBIPodImageFormat.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBIPodImageFormat.h"
#import "IMBArtworkDB.h"
#import "MediaHelper.h"
#import "IMBArtworkHelper.h"
#import "IMBDeviceInfo.h"
#import "IMBFileSystem.h"

@implementation IMBIPodImageFormat
@synthesize isPhoto = _isPhoto;
@synthesize fileOffset = _fileOffset;
@synthesize imageSize = _imageSize;
@synthesize imageBlockSize = _iThmbBlockSize;
@synthesize formatID = _formatID;
@synthesize width = _width;
@synthesize height = _height;

- (id)init:(BOOL)isPhotoFormat {
    self = [super init];
    if (self) {
        _identifier = (char*)[@"mhni" UTF8String];
        _requiredHeaderSize = 44;
        _headerSize = 76;
        _isPhoto = isPhotoFormat;
    }
    return self;
}

- (void)dealloc {
    if (_childElement != nil) {
        [_childElement release];
        _childElement = nil;
    }
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<IMBIPodImageFormat  _isPhoto=%d, _fileOffset= %d, _imageSize = %d, _imageBlockSize = %d, _formatID = %d, _width = %d, _height = %d>"
            ,_isPhoto,_fileOffset,_imageSize,_iThmbBlockSize,_formatID,_width,_height];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    currPosition = [super read:ipod reader:reader currPosition:currPosition];
    
    int readLength = 0;
    readLength = 4;
    identifierLength = readLength;
    _identifier = (char*)malloc(readLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    [reader getBytes:_identifier range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_headerSize);
    [reader getBytes:&_headerSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    [self validateHeader:@"mhni"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_childCount);
    [reader getBytes:&_childCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_formatID);
    [reader getBytes:&_formatID range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_fileOffset);
    [reader getBytes:&_fileOffset range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_imageSize);
    [reader getBytes:&_imageSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_verticalPadding);
    [reader getBytes:&_verticalPadding range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_horizontalPadding);
    [reader getBytes:&_horizontalPadding range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_height);
    [reader getBytes:&_height range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_width);
    [reader getBytes:&_width range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1);
    [reader getBytes:&_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_iThmbBlockSize);
    [reader getBytes:&_iThmbBlockSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    // 去查找是否被支持
    @try {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([(IMBSupportedArtworkFormat*)evaluatedObject formatID] == _formatID) {
                return YES;
            } else {
                return NO;
            }
        }];
        NSArray *formatArr = [[[iPod deviceInfo] supportedArtworkFormats] filteredArrayUsingPredicate:pre];
        IMBSupportedArtworkFormat *format = nil;
        if (formatArr != nil && [formatArr count] > 0) {
            format = [formatArr objectAtIndex:0];
        } else {
            format = nil;
        }
        if (format != nil) {
            _computedWidth = [format width];
            _computedHeight = [format height];
        } else {
            [IMBSupportedArtworkFormat getArtworkDimensions:_formatID width:&_computedWidth height:&_computedHeight];
        }
    }
    @catch (NSException *exception) {
        
    }
    
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    if (_childCount > 0) {
        _childElement = [[IMBArtworkStringMHOD alloc] init];
        currPosition = [_childElement read:ipod reader:reader currPosition:currPosition];
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"IMBIPodImageFormat sectionSize is %i", _sectionSize);
    
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_childCount length:sizeof(_childCount)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_formatID length:sizeof(_formatID)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_fileOffset length:sizeof(_fileOffset)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_imageSize length:sizeof(_imageSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_verticalPadding length:sizeof(_verticalPadding)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_horizontalPadding length:sizeof(_horizontalPadding)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_height length:sizeof(_height)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_width length:sizeof(_width)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk1 length:sizeof(_unk1)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_iThmbBlockSize length:sizeof(_iThmbBlockSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    
    if (_childElement != nil) {
        [_childElement write:writer];
    }
}

- (int)getSectionSize {
    if (_childElement != nil) {
        return _headerSize + [_childElement getSectionSize];
    } else {
        return _headerSize;
    }
}

- (void)create:(IMBiPod*)ipod format:(IMBSupportedArtworkFormat*)format imageData:(NSData*)imageData {
    iPod = ipod;
    identifierLength = 4;
    _identifier = (char*)[@"mhni" UTF8String];
    unusedHeaderLength = _headerSize - _requiredHeaderSize;
    _unusedHeader = malloc(unusedHeaderLength + 1);
    memset(_unusedHeader, 0, malloc_size(_unusedHeader));

    _imageSize = (uint)[imageData length];
    if ([format iThmbBlockSize] == 0) {
        _iThmbBlockSize = _imageSize;
    } else {
        _iThmbBlockSize = [format iThmbBlockSize];
    }
    _width = (short)[format width];
    _computedWidth = [format width];
    _height = (short)[format height];
    _computedHeight = [format height];
    _formatID = [format formatID];
    
    NSString *ithmbName = nil;
    uint offset = 0;
    [[iPod artworkDB] getIThmbRepository:self fileName:&ithmbName fileOffset:&offset];
    _fileOffset = offset;
    NSLog(@"_fileOffset %d", _fileOffset);
    
    _childElement = [[IMBArtworkStringMHOD alloc] init];
    [_childElement create:[MediaHelper getStandardPathToiPodPath:ithmbName]];
    _childCount = 1;
    
    if ([[iPod deviceInfo] isIOSDevice]) {
        AFCFileReference* fileRef = [[iPod fileSystem] openForReadWrite:[[[iPod fileSystem] artworkFolderPath] stringByAppendingPathComponent:[self getFileName]]];
        [fileRef seek:(int)_fileOffset mode:0];
        [fileRef writeN:(uint32_t)[imageData length] bytes:[imageData bytes]];
        [fileRef closeFile];
    } else {
        NSFileHandle *fileRef = [[iPod fileSystem] openForReadWrite:[[[iPod fileSystem] artworkFolderPath] stringByAppendingPathComponent:[self getFileName]]];
        NSLog(@"fileRef pathe %@",[[[iPod fileSystem] artworkFolderPath] stringByAppendingPathComponent:[self getFileName]]);
        
        [fileRef seekToFileOffset:(int)_fileOffset];
        [fileRef writeData:imageData];
        [fileRef closeFile];
    }
}

- (void)updateImageData:(NSData *)imageData {
    NSString *ithmbName = nil;
    uint firstFreeOffset = [[iPod artworkDB] getNextFreeBlockInIThmb:[self getFileName] ithmbBlockSize:_iThmbBlockSize];
    if (firstFreeOffset < _fileOffset) {
        uint offset = 0;
        [[iPod artworkDB] getIThmbRepository:self fileName:&ithmbName fileOffset:&offset];
        [_childElement setData:[MediaHelper getStandardPathToiPodPath:ithmbName]];
        _fileOffset = offset;
    }
    if ([[iPod deviceInfo] isIOSDevice]) {
        AFCFileReference* fileRef = [[iPod fileSystem] openForReadWrite:[[[iPod fileSystem] artworkFolderPath] stringByAppendingPathComponent:[self getFileName]]];
        [fileRef seek:(int)_fileOffset mode:0];
        [fileRef writeN:(uint32_t)[imageData length] bytes:[imageData bytes]];
        [fileRef closeFile];
    } else {
        NSFileHandle *fileRef = [[iPod fileSystem] openForReadWrite:[[[iPod fileSystem] artworkFolderPath] stringByAppendingPathComponent:[self getFileName]]];
        [fileRef seekToFileOffset:(int)_fileOffset];
        [fileRef writeData:imageData];
        [fileRef closeFile];
    }
}

- (BOOL)isFullResolution{
    if (_formatID == 1) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (NSString*)getFileName {
    if (_childElement != nil) {
        NSLog(@"_childElement data: %@", _childElement.data);
        if ([[_childElement data] hasPrefix:@":"] == YES) {
            return [[_childElement data] substringFromIndex:1];
        } else {
            return [_childElement data];
        }
    } else {
        return [NSString stringWithFormat:@"F%d_1.ithmb", _formatID];
    }
}

- (NSImage*)loadFromFile {
    return [IMBArtworkHelper loadArtworkBitmapFromIThmb:iPod imageFormat:self];
}

- (NSData*)loadDataFromFile {
    return nil;
}

@end

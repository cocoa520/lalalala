//
//  IMBImageAlbum.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBImageAlbum.h"
#import "IMBArtworkStringMHOD.h"

@implementation IMBImageAlbum

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 24;
        _dataObjects = [[NSMutableArray alloc] init];
        _albumItems = [[NSMutableArray alloc] init];
        _images = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_dataObjects != nil) {
        [_dataObjects release];
        _dataObjects =nil;
    }
    if (_albumItems != nil) {
        [_albumItems release];
        _albumItems = nil;
    }
    if (_images != nil) {
        [_images release];
        _images = nil;
    }
    [super dealloc];
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
    [self validateHeader:@"mhba"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    int dataObjectCount = 0;
    readLength = sizeof(dataObjectCount);
    [reader getBytes:&dataObjectCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    int albumItemCount = 0;
    readLength = sizeof(albumItemCount);
    [reader getBytes:&albumItemCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    IMBArtworkStringMHOD *mhod = nil;
    for (int i = 0; i < dataObjectCount; i++) {
        mhod = [[IMBArtworkStringMHOD alloc] init];
        currPosition = [mhod read:ipod reader:reader currPosition:currPosition];
        [_dataObjects addObject:mhod];
        [mhod release];
        mhod = nil;
    }
    
    IMBImageAlbumItem *item = nil;
    for (int i = 0; i < albumItemCount; i++) {
        item = [[IMBImageAlbumItem alloc] init];
        currPosition = [item read:ipod reader:reader currPosition:currPosition];
        [_albumItems addObject:item];
        [item release];
        item = nil;
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"ArtworkDBRoot sectionSize is %i", _sectionSize);
    
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    int dataObjectCount = (int)[_dataObjects count];
    [writer appendBytes:&dataObjectCount length:sizeof(dataObjectCount)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    int albumItemsCount = (int)[_albumItems count];
    [writer appendBytes:&albumItemsCount length:sizeof(albumItemsCount)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_iD length:sizeof(_iD)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    
    IMBArtworkStringMHOD *mhod = nil;
    for (int i = 0; i < [_dataObjects count]; i++) {
        mhod = [_dataObjects objectAtIndex:i];
        [mhod write:writer];
    }
    
    IMBImageAlbumItem *item = nil;
    for (int i = 0; i < [_albumItems count]; i++) {
        item = [_albumItems objectAtIndex:i];
        [item write:writer];
    }
}

- (int)getSectionSize {
    int size = _headerSize;
    for (IMBBaseMHODElement *mhod in _dataObjects) {
        size += [mhod getSectionSize];
    }
    for (IMBImageAlbumItem *item in _albumItems) {
        size += [item getSectionSize];
    }
    return size;
}

- (NSString*)title {
    NSString *name = [super getDataElement:_dataObjects clidrentype:TITLE];
    if ([MediaHelper stringIsNilOrEmpty:name] == YES) {
        name = @"Unnamed";
    }
    return name;
}

- (int)imageCount {
    return (int)[_images count];
}

#pragma mark - 存储的是IMBIPodImage对象
- (NSMutableArray*)images {
    for (IMBImageAlbumItem *item in _albumItems) {
        if ([item artwork] != nil) {
            [_images addObject:[item artwork]];
        }
    }
    return _images;
}

- (void)resolveImages:(IMBImageList*)images {
    for (IMBImageAlbumItem *item in _albumItems) {
        IMBIPodImage *art = nil;
        [item setArtwork:art];
    }
}

@end

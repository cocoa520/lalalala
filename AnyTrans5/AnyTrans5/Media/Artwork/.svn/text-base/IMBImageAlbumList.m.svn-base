//
//  IMBImageAlbumList.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBImageAlbumList.h"

@implementation IMBImageAlbumList
@synthesize albums = _childSections;

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 12;
        _childSections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_childSections != nil) {
        [_childSections release];
        _childSections = nil;
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
    [self validateHeader:@"mhla"];
    
    int childCount = 0;
    readLength = sizeof(childCount);
    [reader getBytes:&childCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < childCount; i++) {
        IMBImageAlbum *album = [[IMBImageAlbum alloc] init];
        currPosition = [album read:ipod reader:reader currPosition:currPosition];
        [_childSections addObject:album];
        [album release];
    }
    return currPosition;
}

- (void) write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"IMBImageAlbumList sectionSize is %i", _sectionSize);
    
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    int albumNum = (int)[_childSections count];
    [writer appendBytes:&albumNum length:sizeof(albumNum)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    
    IMBImageAlbum *album = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        album = [_childSections objectAtIndex:i];
        [album write:writer];
    }
}

- (int) getSectionSize {
    int size = _headerSize;
    IMBImageAlbum *album = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        album = [_childSections objectAtIndex:i];
        size += [album getSectionSize];
    }
    return size;
}

- (void)resolveImages:(IMBImageList*)images {
    for (IMBImageAlbum *album in _childSections) {
        [album resolveImages:images];
    }
}

@end

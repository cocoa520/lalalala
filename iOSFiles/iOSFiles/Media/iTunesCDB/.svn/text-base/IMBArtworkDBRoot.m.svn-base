//
//  IMBArtworkDBRoot.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBArtworkDBRoot.h"

@implementation IMBArtworkDBRoot
@synthesize nextImageId = _nextImageId;

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 32;
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
    [self validateHeader:@"mhfd"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1);
    [reader getBytes:&_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk2);
    [reader getBytes:&_unk2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_listContainerCount);
    [reader getBytes:&_listContainerCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk3);
    [reader getBytes:&_unk3 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_nextImageId);
    [reader getBytes:&_nextImageId range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < _listContainerCount; i++) {
        IMBArtworkListContainerHeader *containerHeader = [[IMBArtworkListContainerHeader alloc] init];
        currPosition = [containerHeader read:ipod reader:reader currPosition:currPosition];
        [_childSections addObject:containerHeader];
        [containerHeader release];
        containerHeader = nil;
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    //NSLog(@"ArtworkDBRoot sectionSize is %i", _sectionSize);
    [writer appendBytes:_identifier length:identifierLength];
    //NSLog(@"length is %i", [writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    //NSLog(@"length is %i", [writer length]);
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    //NSLog(@"length is %i", [writer length]);
    [writer appendBytes:&_unk1 length:sizeof(_unk1)];
    //NSLog(@"length is %i", [writer length]);
    [writer appendBytes:&_unk2 length:sizeof(_unk2)];
    //NSLog(@"length is %i", [writer length]);
    int childCount = (int)[_childSections count];
    [writer appendBytes:&childCount length:sizeof(childCount)];
    //NSLog(@"length is %i", [writer length]);
    [writer appendBytes:&_unk3 length:sizeof(_unk3)];
    //NSLog(@"length is %i", [writer length]);
    [writer appendBytes:&_nextImageId length:sizeof(_nextImageId)];
    //NSLog(@"length is %i", [writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    //NSLog(@"length is %i", [writer length]);
    
    IMBArtworkListContainerHeader *containerHeader = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        containerHeader = [_childSections objectAtIndex:i];
        [containerHeader write:writer];
    }
}

- (int)getSectionSize {
    int size = _headerSize;
    IMBArtworkListContainerHeader *containerHeader = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        containerHeader = [_childSections objectAtIndex:i];
        size += [containerHeader getSectionSize];
    }
    return size;
}

- (IMBArtworkListContainerHeader*)getChildSection:(ArtworkMHSDSectionTypeEnum)type {
    IMBArtworkListContainerHeader *containerHeader = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        containerHeader = [_childSections objectAtIndex:i];
        if ([containerHeader type] == type) {
            return containerHeader;
        }
    }
    return nil;
}

@end

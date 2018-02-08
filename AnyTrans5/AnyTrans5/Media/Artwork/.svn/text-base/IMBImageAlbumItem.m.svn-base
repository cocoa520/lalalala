//
//  IMBImageAlbumItem.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBImageAlbumItem.h"

@implementation IMBImageAlbumItem
@synthesize imageID = _imageID;
@synthesize artwork = _artwork;

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 20;
    }
    return self;
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
    [self validateHeader:@"mhia"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1);
    [reader getBytes:&_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_imageID);
    [reader getBytes:&_imageID range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [super readToHeaderEnd:reader currPosition:currPosition];
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"IMBImageAlbumItem sectionSize is %i", _sectionSize);
    
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk1 length:sizeof(_unk1)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_imageID length:sizeof(_imageID)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
}

- (int)getSectionSize {
    return _sectionSize;
}

@end

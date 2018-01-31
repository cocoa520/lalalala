//
//  IMBIThmbFile.m
//  iMobieTrans
//
//  Created by Pallas on 1/10/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBIThmbFile.h"

@implementation IMBIThmbFile
@synthesize formatID = _formatID;
@synthesize imageSize = _imageSize;

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 24;
        _headerSize = 124;
        _sectionSize = 124;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<IMBIThmbFile _formatID=%d, _imageSize=%d >"
            ,_formatID, _imageSize];
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
    [self validateHeader:@"mhif"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1);
    [reader getBytes:&_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_formatID);
    [reader getBytes:&_formatID range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_imageSize);
    [reader getBytes:&_imageSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"IMBIThmbFile sectionSize is %i", _sectionSize);
    
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk1 length:sizeof(_unk1)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_formatID length:sizeof(_formatID)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_imageSize length:sizeof(_imageSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
}

- (int)getSectionSize {
    return _sectionSize;
}

- (void)create:(uint)imageSize formatID:(uint)formatID {
    identifierLength = 4;
    _identifier = (char*)[@"mhif" UTF8String];
    unusedHeaderLength = _headerSize - _requiredHeaderSize;
    _unusedHeader = malloc(unusedHeaderLength + 1);
    _imageSize = imageSize;
    _formatID = formatID;
}

@end

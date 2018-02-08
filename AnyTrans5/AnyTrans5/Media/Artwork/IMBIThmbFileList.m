//
//  IMBIThmbFileList.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBIThmbFileList.h"

@implementation IMBIThmbFileList
@synthesize files = _childSections;

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

- (NSString *)description {
    return [NSString stringWithFormat:@"<IMBIThmbFileList _childSections=%lu,\n IMBIThmbFiles=%@,\n >"
            ,(unsigned long)_childSections.count, _childSections];
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
    [self validateHeader:@"mhlf"];
    
    int fileCount = 0;
    readLength = sizeof(fileCount);
    [reader getBytes:&fileCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < fileCount; i++) {
        IMBIThmbFile *file = [[IMBIThmbFile alloc] init];
        currPosition = [file read:ipod reader:reader currPosition:currPosition];
        [_childSections addObject:file];
        [file release];
        file = nil;
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"IMBIThmbFileList sectionSize is %i", _sectionSize);
    
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    int childCount = (int)[_childSections count];
    [writer appendBytes:&childCount length:sizeof(childCount)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    
    for (int i = 0; i < childCount; i++) {
        [[_childSections objectAtIndex:i] write:writer];
    }
}

- (int)getSectionSize {
    int size = _headerSize;
    for (int i = 0; i < [_childSections count]; i++) {
        size += [[_childSections objectAtIndex:i] getSectionSize];
    }
    return size;
}

- (void)addIThmbFile:(IMBIPodImageFormat *)format {
    IMBIThmbFile *newFile = [[IMBIThmbFile alloc] init];
    [newFile create:[format imageSize] formatID:[format formatID]];
    [_childSections addObject:newFile];
    [newFile release];
    newFile = nil;
}

- (NSMutableArray*)getIThmbFiles {
    return _childSections;
}

@end

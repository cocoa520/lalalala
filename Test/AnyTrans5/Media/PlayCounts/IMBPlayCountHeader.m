//
//  IMBPlayCountHeader.m
//  iMobieTrans
//
//  Created by Pallas on 1/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBPlayCountHeader.h"
#import "IMBPlayCountEntry.h"
#import "IMBSession.h"

@implementation IMBPlayCountHeader
@synthesize entryCount = _nbrEntries;

- (id)init {
    self = [super init];
    if (self) {
        identifierLength = 4;
        _requiredHeaderSize = 16;
        _entries = [[NSMutableArray alloc] init];
    }
    return  self;
}

- (void)dealloc {
    if (_entries != nil) {
        [_entries release];
        _entries = nil;
    }
    [super dealloc];
}

- (void)readPlist:(IMBiPod*)ipod playCountsPath:(NSString*)playCountsPath {
    // ToDu 主要是做的是对U盘此类的设备的读取解析
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
    [self validateHeader:@"mhdp"];
    
    readLength = sizeof(_entrySize);
    [reader getBytes:&_entrySize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_nbrEntries);
    [reader getBytes:&_nbrEntries range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < _nbrEntries; i++) {
        IMBPlayCountEntry *entry = [[IMBPlayCountEntry alloc] initWithSize:_entrySize];
        currPosition = [entry read:ipod reader:reader currPosition:currPosition];
        [_entries addObject:entry];
        [entry release];
        entry = nil;
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    return;
}

- (int)getSectionSize {
    return 0;
}

- (NSEnumerator*)entries {
    NSEnumerator *enumerator = [_entries objectEnumerator];
    return enumerator;
}

@end

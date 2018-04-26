//
//  IMBPlayCountEntry.m
//  iMobieTrans
//
//  Created by Pallas on 1/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBPlayCountEntry.h"
#import "DateHelper.h"

@implementation IMBPlayCountEntry
@synthesize persistentID = _persistentID;
@synthesize playCount = _playCount;
@synthesize lastPlayed = _lastPlayed;
@synthesize rating = _rating;

- (id)initWithSize:(int)entrySize {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 16;
        _headerSize = entrySize;
    }
    return self;
}

- (void)dealloc {
    if (_dateLastPlayed != nil) {
        [_dateLastPlayed release];
        _dateLastPlayed = nil;
    }
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    currPosition = [super read:ipod reader:reader currPosition:currPosition];
    int readLength = 0;
    readLength = sizeof(_playCount);
    [reader getBytes:&_playCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_lastPlayed);
    [reader getBytes:&_lastPlayed range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_bookmarkPosition);
    [reader getBytes:&_bookmarkPosition range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_rating);
    [reader getBytes:&_rating range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    return;
}

- (int)getSectionSize {
    return 0;
}

- (NSDate*)dateLastPlayed {
    _dateLastPlayed = [[DateHelper dateFrom1904:_lastPlayed] retain];
    return _dateLastPlayed;
}

@end

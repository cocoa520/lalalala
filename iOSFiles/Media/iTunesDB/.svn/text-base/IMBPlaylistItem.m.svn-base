//
//  IMBPlaylistItem.m
//  iMobieTrans
//
//  Created by Pallas on 12/28/12.
//  Copyright (c) 2012 iMobie Inc. All rights reserved.
//

#import "IMBPlaylistItem.h"

@implementation IMBPlaylistItem
@synthesize groupDBID = _groupDBID;
@synthesize trackDBID = _trackDBID;
@synthesize podcastGroupParent = _podcastGroupParent;
@synthesize groupID = _groupID;

- (id)init {
    self = [super init];
    if (self) {
        _headerSize = 76;
        _requiredHeaderSize = 36 + 16;
        _dataObjectCount = 0;
        _podcastGroupingFlag = 0;
        _groupID = 0;
        _trackID = 0;
        _timeStamp = 0;
        _podcastGroupParent = 0;
        unusedHeaderLength  = _headerSize - _requiredHeaderSize;
        _unusedHeader = malloc(unusedHeaderLength + 1);
        memset(_unusedHeader, 0, malloc_size(_unusedHeader));
        _childSections = [[NSMutableArray alloc] init];
        _track = nil;
    }
    return self;
}

- (void)dealloc {
    free(_identifier);
    [_childSections release];
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    
    int readLength = 0;
    readLength = 4;
    identifierLength = readLength;
    _identifier = malloc(readLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    [reader getBytes:_identifier range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_headerSize);
    [reader getBytes:&_headerSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    if (_headerSize < _requiredHeaderSize) {
        _requiredHeaderSize = 36;
    }
    [self validateHeader:@"mhip"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_dataObjectCount);
    [reader getBytes:&_dataObjectCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_podcastGroupingFlag);
    [reader getBytes:&_podcastGroupingFlag range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_groupID);
    [reader getBytes:&_groupID range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_trackID);
    [reader getBytes:&_trackID range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_timeStamp);
    [reader getBytes:&_timeStamp range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_podcastGroupParent);
    [reader getBytes:&_podcastGroupParent range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    if (_headerSize >= 36 + 16) {
        readLength = sizeof(uint64);
        [reader getBytes:&_groupDBID range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
        readLength = sizeof(uint64);
        [reader getBytes:&_trackDBID range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
    }
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < _dataObjectCount; i++) {
        IMBBaseMHODElement *mhod = [IMBMHODFactory readMHOD:iPod reader:reader currPosition:&currPosition];
        [_childSections addObject:mhod];
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    
    identifierLength = 4;
    _identifier = (char*)malloc(identifierLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhip", malloc_size(_identifier));
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    int sectionsCount = (int)[_childSections count];
    [writer appendBytes:&sectionsCount length:sizeof(sectionsCount)];
    [writer appendBytes:&_podcastGroupingFlag length:sizeof(_podcastGroupingFlag)];
    [writer appendBytes:&_groupID length:sizeof(_groupID)];
    [writer appendBytes:&_trackID length:sizeof(_trackID)];
    [writer appendBytes:&_timeStamp length:sizeof(_timeStamp)];
    [writer appendBytes:&_podcastGroupParent length:sizeof(_podcastGroupParent)];
    
    if (_headerSize >= 36 + 16) {
        [writer appendBytes:&_groupDBID length:sizeof(_groupDBID)];
        [writer appendBytes:&_trackDBID length:sizeof(_trackDBID)];
    }
    
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        mhod = [_childSections objectAtIndex:i];
        [mhod write:writer];
    }
}

- (int)getSectionSize {
    int size = _headerSize;
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        mhod = [_childSections objectAtIndex:i];
        size += [mhod getSectionSize];
    }
    return size;
}

- (void)setDataElement:(int)type data:(NSString*)data {
    IMBStringMHOD *mhod = [self getDataElement:type];
    if (mhod != nil) {
        [mhod setValue:data forKey:@"data"];
    } else {
        mhod = [[IMBUnicodeMHOD alloc] initWithType:type];
        [mhod setValue:data forKey:@"data"];
        [_childSections addObject:mhod];
        [mhod release];
    }
}

- (IMBStringMHOD*)getDataElement:(int)type {
    IMBStringMHOD *strmhod = nil;
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        mhod = [_childSections objectAtIndex:i];
        if ([[mhod superclass] isSubclassOfClass:[IMBStringMHOD class]] && [mhod type] == type) {
            strmhod = (IMBStringMHOD*)mhod;
            break;
        }
    }
    return strmhod;
}

-(void)resolveTrack:(IMBiPod*)ipod {
    _track =  [[ipod tracks] findByID:_trackID];
}

-(void)setTrack:(IMBTrack *)track {
    [track retain];
    [_track release];
    _track = track;
    _trackID = [track iD];
    _trackDBID = [track dbID];
}

-(IMBTrack*)track {
    return _track;
}

- (void)setPlaylistPostion:(int)playlistPostion {
    IMBBaseMHODElement *mhod = [self getDataElement:PLAYLISTPOSITION];
    if (mhod != nil) {
        ((IMBPlaylistPositionMHOD*)mhod).position = playlistPostion;
    } else {
        mhod = [[IMBPlaylistPositionMHOD alloc] init];
        [(IMBPlaylistPositionMHOD*)mhod create];
        ((IMBPlaylistPositionMHOD*)mhod).position = playlistPostion;
        [_childSections addObject:mhod];
        [mhod release];
    }
}

- (int)playlistPostion{
    IMBBaseMHODElement *mhod = [self getDataElement:PLAYLISTPOSITION];
    if (mhod == nil) {
        return 0;
    } else {
        return [(IMBPlaylistPositionMHOD*)mhod position];
    }
}

- (void)setIsPodcastGroup:(BOOL)isPodcastGroup {
    if (isPodcastGroup == TRUE) {
        _podcastGroupingFlag = 256;
    }
}

- (BOOL)isPodcastGroup {
    if (_podcastGroupingFlag != 0 && _podcastGroupParent == 0 && [@"" isEqualToString: [self podcastGroupTitle]]) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (void)setPodcastGroupTitle:(NSString *)podcastGroupTitle {
    [self setDataElement:TITLE data:podcastGroupTitle];
}

- (NSString*)podcastGroupTitle {
    IMBStringMHOD *mhod = [self getDataElement:TITLE];
    if (mhod == nil) {
        return nil;
    } else {
        return [mhod data];
    }
}

@end

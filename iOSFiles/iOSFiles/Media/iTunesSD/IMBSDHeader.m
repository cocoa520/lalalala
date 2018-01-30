//
//  IMBSDHeader.m
//  iMobieTrans
//
//  Created by Pallas on 1/23/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSDHeader.h"
#import "IMBTracklist.h"
#import "IMBSDEntry.h"

@implementation IMBSDHeader

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithIPod:(IMBiPod *)ipod {
    self = [self init];
    if (self) {
        iPod = ipod;
        _unk1 = malloc(4);
        memset(_unk1, 0, malloc_size(_unk1));
        unk1Length = 3;
        _unk1[0] = 1;
        _unk1[1] = 6;
        _unk1[2] = 0;
        _headerSize = 18;
        _headerPadding = malloc(10);
        memset(_headerPadding, 0, malloc_size(_headerPadding));
        headerPaddingLength = 9;
        _trackCount = [[iPod tracks] getTrackCount];
    }
    return self;
}

- (void)dealloc {
    free(_unk1);
    free(_headerPadding);
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    [writer appendData:[MediaHelper intToITunesSDFormat:_trackCount]];
    [writer appendBytes:_unk1 length:unk1Length];
    [writer appendData:[MediaHelper intToITunesSDFormat:_headerSize]];
    [writer appendBytes:_headerPadding length:headerPaddingLength];
    
    for (IMBTrack *track in [[iPod tracks] trackArray]) {
        IMBSDEntry *entry = [[IMBSDEntry alloc] initWithTrack:track];
        [entry write:writer];
        [entry release];
        entry = nil;
    }
}

- (int)getSectionSize {
    return 0;
}

@end

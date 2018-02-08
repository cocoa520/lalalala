//
//  IMBiTLTrack.m
//  iMobieTrans
//
//  Created by zhang yang on 13-4-17.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBiTLTrack.h"

@implementation IMBiTLTrack

@synthesize album;
@synthesize artist;
@synthesize genre;
@synthesize location;
@synthesize dateAdded;
@synthesize duration;
@synthesize rating;
@synthesize size;
@synthesize playedCount;
@synthesize isPodcast;
@synthesize kind;
@synthesize databaseID;
@synthesize name;
@synthesize persistentID;
@synthesize isMovie;
@synthesize isVideo;
@synthesize isTVShow;
@synthesize isMusicVideo;
@synthesize address;
@synthesize trackKind;
@synthesize iTunesMediaType;
@synthesize fileIsExist;
@synthesize checkState;
- (id)init
{
    self = [super init];
    if (self) {
        iTunesMediaType = iTunesMedia_Unknown;
    }
    return self;
}

- (void)dealloc {
	if (artist != nil)
		[artist release];
	if (album != nil)
		[album release];
	if (name != nil)
		[name release];
	if (dateAdded != nil)
		[dateAdded release];
	if (genre != nil)
		[genre release];
	if (location != nil)
		[location release];
	if (kind != nil) {
        [kind release];
    }
    if (persistentID != nil) {
        [persistentID release];
    }
    [super dealloc];
}

@end

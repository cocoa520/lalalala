//
//  IMBPlaylistListV2Container.m
//  MediaTrans
//
//  Created by Pallas on 12/21/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBPlaylistListV2Container.h"

@implementation IMBPlaylistListV2Container

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(id)initWithParent:(id)parent{
    self = [super init];
    if (self) {
        _header = parent;
    }
    return self;
}

-(void)dealloc{
    [_childSection release];
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    _childSection = [[IMBPlaylistList alloc] init];
    currPosition = [_childSection read:iPod reader:reader currPosition:currPosition];
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    [_childSection write:writer];
}

-(int)getSectionSize{
    return [_header headerSize] + [_childSection getSectionSize];
}

-(IMBPlaylistList*)getPlaylistList {
    return _childSection;
}

@end

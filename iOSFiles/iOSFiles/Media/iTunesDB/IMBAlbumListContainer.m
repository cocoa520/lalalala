//
//  IMBAlbumListContainer.m
//  MediaTrans
//
//  Created by Pallas on 12/20/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBAlbumListContainer.h"

@implementation IMBAlbumListContainer

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(id)initWithParent:(id)parent;{
    self = [super init];
    if (self) {
        _header = parent;
    }
    return self;
}

-(void)dealloc{
    free(_unk1);
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    int length = [_header sectionSize] - [_header headerSize];
    unk1Length = length;
    _unk1 = (Byte*)malloc(length + 1);
    memset(_unk1, 0, malloc_size(_unk1));
    [reader getBytes:_unk1 range:NSMakeRange(currPosition, length)];
    currPosition += length;
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    if (unk1Length <= 0) {
        unk1Length = 0;
        _unk1 =  malloc(1);
        memset(_unk1, 0, malloc_size(_unk1));
    }
    [writer appendBytes:_unk1 length:unk1Length];
}

-(int)getSectionSize{
    return [_header sectionSize];
}

@end

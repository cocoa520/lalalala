//
//  IMBArtworkUnknownListContainer.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBArtworkUnknownListContainer.h"

@implementation IMBArtworkUnknownListContainer

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithParent:(id)parent {
    self = [self init];
    if (self) {
        _header = parent;
    }
    return self;
}

- (void)dealloc {
    free(_unk1);
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    currPosition = [super read:ipod reader:reader currPosition:currPosition];
    int length = [_header sectionSize] - [_header headerSize];
    unk1Length = length;
    _unk1 = (Byte*)malloc(length + 1);
    memset(_unk1, 0, malloc_size(_unk1));
    [reader getBytes:_unk1 range:NSMakeRange(currPosition, length)];
    currPosition += length;
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    NSLog(@"IMBArtworkUnknownListContainer %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unk1 length:unk1Length];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
}

-(int)getSectionSize{
    return [_header sectionSize];
}

@end

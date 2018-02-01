//
//  IMBImageListContainer.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBImageListContainer.h"

@implementation IMBImageListContainer
@synthesize imageList = _childSection;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithParent:(id)parent{
    self = [self init];
    if (self) {
        _header = parent;
        _childSection = [[IMBImageList alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_childSection != nil) {
        [_childSection release];
        _childSection = nil;
    }
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    currPosition = [super read:ipod reader:reader currPosition:currPosition];
    currPosition = [_childSection read:ipod reader:reader currPosition:currPosition];
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    [_childSection write:writer];
}

- (int)getSectionSize {
    return [_header headerSize] + [_childSection getSectionSize];
}

@end
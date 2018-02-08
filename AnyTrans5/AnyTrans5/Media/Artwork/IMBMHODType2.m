//
//  IMBMHODType2.m
//  iMobieTrans
//
//  Created by Pallas on 1/8/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBMHODType2.h"

@implementation IMBMHODType2

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 16;
        _headerSize = 24;
        _identifier = (char*)[@"mhod" UTF8String];
        _type = 2;
        _childElement = [[IMBIPodImageFormat alloc] init:FALSE];
    }
    return self;
}

- (void)dealloc {
    if (_childElement != nil) {
        [_childElement release];
        _childElement = nil;
    }
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<IMBMHODType2  _childElement=%@, >"
            , _childElement];
}


- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    currPosition = [_childElement read:ipod reader:reader currPosition:currPosition];
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    [super write:writer];
    [_childElement write:writer];
}

- (int)getSectionSize {
    return _headerSize + [_childElement getSectionSize];
}

- (IMBIPodImageFormat*)getArtworkFormat {
    return _childElement;
}

- (void)create:(IMBiPod*)ipod format:(IMBSupportedArtworkFormat*)format imageData:(NSData*)imageData {
    iPod = ipod;
    unusedHeaderLength = _headerSize - _requiredHeaderSize;
    _unusedHeader = malloc(unusedHeaderLength + 1);
    _childElement = [[IMBIPodImageFormat alloc] init:FALSE];
    [_childElement create:ipod format:format imageData:imageData];
}


@end

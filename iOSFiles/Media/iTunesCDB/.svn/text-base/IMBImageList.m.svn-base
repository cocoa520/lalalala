//
//  IMBImageList.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBImageList.h"

#import "IMBTrack.h"
#import "IMBIPodImageFormat.h"
#import "IMBIPodImage.h"
#import "IMBDeviceInfo.h"

@implementation IMBImageList

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 12;
        _childSections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_childSections != nil) {
        [_childSections release];
        _childSections = nil;
    }
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<IMBImageList _childSections=%lu,\n IMBIPodImages=%@,\n >"
            ,(unsigned long)_childSections.count, _childSections];
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
    [self validateHeader:@"mhli"];
    
    int imageCount = 0;
    readLength = sizeof(imageCount);
    [reader getBytes:&imageCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < imageCount; i++) {
        IMBIPodImage *mhii = [[IMBIPodImage alloc] init];
        currPosition = [mhii read:ipod reader:reader currPosition:currPosition];
        [_childSections addObject:mhii];
        [mhii release];
        mhii = nil;
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"IMBImageList sectionSize is %i", _sectionSize);
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_sectionSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    int childSectionsCount = (int)[_childSections count];
    [writer appendBytes:&childSectionsCount length:sizeof(childSectionsCount)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    
    for (int i = 0; i < childSectionsCount; i++) {
        [[_childSections objectAtIndex:i] write:writer];
    }
}

- (int)getSectionSize {
    int size = _headerSize;
    for (int i = 0; i < [_childSections count]; i++) {
        size += [[_childSections objectAtIndex:i] getSectionSize];
    }
    return size;
}

- (IMBIPodImage*)getArtworkByTrackID:(int64_t)trackID {
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ([(IMBIPodImage*)evaluatedObject trackDBID] == trackID && [(IMBIPodImage*)evaluatedObject usedCount] > 0);
    }];
    
    NSArray *preArray = [_childSections filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        return [preArray objectAtIndex:0];
    }
    return nil;
}

- (IMBIPodImage*)getArtworkByID:(uint)iD {
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
       return [(IMBIPodImage*)evaluatedObject iD] == iD;
    }];
    
    NSArray *preArray = [_childSections filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        return [preArray objectAtIndex:0];
    }
    return nil;
}

- (void)addNewArtwork:(IMBTrack*)track image:(NSImage*)image {
    if ([[[iPod deviceInfo] supportedArtworkFormats] count] == 0) {
        @throw [NSException exceptionWithName:@"EX_NoSupportedArtwork" reason:@"Not supported artwork formats were detected" userInfo:nil];
    }
    IMBIPodImage *newTrackArtwork = [[IMBIPodImage alloc] init];
    [newTrackArtwork create:iPod track:track image:image];
    [_childSections addObject:newTrackArtwork];
    for (IMBIPodImageFormat *format in [newTrackArtwork getFormats]) {
        [[track artwork] addObject:format];
    }
    [track setArtworkIdLink:[newTrackArtwork iD]];
    [newTrackArtwork release];
    newTrackArtwork = nil;
}

- (NSMutableArray*)getImages {
    return _childSections;
}

- (void)removeArtwork:(IMBIPodImage*)existingArtwork {
    [_childSections removeObject:existingArtwork];
}



@end

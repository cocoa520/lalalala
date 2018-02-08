//
//  IMBArtworkListContainerHeader.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBArtworkListContainerHeader.h"
#import "IMBImageListContainer.h"
#import "IMBIThmbFileListContainer.h"
#import "IMBImageAlbumListContainer.h"
#import "IMBArtworkUnknownListContainer.h"

@implementation IMBArtworkListContainerHeader
@synthesize type = _type;

- (id)init {
    self =[super init];
    if (self) {
        _requiredHeaderSize = 16;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
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
    [self validateHeader:@"mhsd"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_type);
    [reader getBytes:&_type range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    switch (_type) {
        case ArtworkImages:
            _childSection = [[IMBImageListContainer alloc] initWithParent:self];
            break;
            
        case ArtworkFiles:
            _childSection = [[IMBIThmbFileListContainer alloc] initWithParent:self];
            break;
            
        case ArtworkAlbums:
            _childSection = [[IMBImageAlbumListContainer alloc] initWithParent:self];
            break;
            
        default:
            _childSection = [[IMBArtworkUnknownListContainer alloc] initWithParent:self];
            break;
    }
    currPosition = [_childSection read:ipod reader:reader currPosition:currPosition];
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"IMBArtworkListConHeader sectionSize is %i", _sectionSize);
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    int typeNum = _type;
    [writer appendBytes:&typeNum length:sizeof(typeNum)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    
    [_childSection write:writer];
}

- (int)getSectionSize {
    return [_childSection getSectionSize];
}

- (int)headerSize {
    return _headerSize;
}

- (int)sectionSize {
    return _sectionSize;
}

- (IMBBaseDatabaseElement*)getListContainer {
    return _childSection;
}


@end

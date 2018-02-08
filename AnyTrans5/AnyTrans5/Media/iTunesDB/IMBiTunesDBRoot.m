//
//  IMBiTunesDBRoot.m
//  MediaTrans
//
//  Created by Pallas on 12/16/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBiTunesDBRoot.h"

@implementation IMBiTunesDBRoot
@synthesize versionNumber = _versionNumber;
@synthesize hashingScheme = _hashingScheme;

#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if (self) {
        identifierLength = 4;
        _requiredHeaderSize = 50;
        _childSections = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
    free(_identifier);
    free(_unk2);
    if (_childSections != nil) {
        [_childSections release];
        _childSections = nil;
    }
    [super dealloc];
}

#pragma mark - 重写方法
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    
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
    [self validateHeader:@"mhbd"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1);
    [reader getBytes:&_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_versionNumber);
    [reader getBytes:&_versionNumber range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_listContainerCount);
    [reader getBytes:&_listContainerCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_iD);
    [reader getBytes:&_iD range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = 16;
    unk2Length = readLength;
    _unk2 = (Byte*)malloc(readLength + 1);
    memset(_unk2, 0, malloc_size(_unk2));
    [reader getBytes:_unk2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_hashingScheme);
    [reader getBytes:&_hashingScheme range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    while (currPosition != [reader length]) {
        IMBListContainerHeader *containerHeader = [[IMBListContainerHeader alloc] init];
        currPosition = [containerHeader read:iPod reader:reader currPosition:currPosition];
        [_childSections addObject:containerHeader];
        [containerHeader release];
        containerHeader = nil;
    }
    
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    _sectionSize = [self getSectionSize];
    
    identifierLength = 4;
    _identifier = (char*)malloc(identifierLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhbd", malloc_size(_identifier));
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    [writer appendBytes:&_unk1 length:sizeof(_unk1)];
    [writer appendBytes:&_versionNumber length:sizeof(_versionNumber)];
    [writer appendBytes:&_listContainerCount length:sizeof(_listContainerCount)];
    [writer appendBytes:&_iD length:sizeof(_iD)];
    [writer appendBytes:_unk2 length:unk2Length];
    [writer appendBytes:&_hashingScheme length:sizeof(_hashingScheme)];
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    
    IMBListContainerHeader *containerHeader = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        containerHeader = [_childSections objectAtIndex:i];
        [containerHeader write:writer];
    }
}

-(int)getSectionSize{
    int size = _headerSize;
    IMBListContainerHeader *containerHeader = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        containerHeader = [_childSections objectAtIndex:i];
        size += [containerHeader getSectionSize];
    }
    return size;
}

-(IMBListContainerHeader*)getChildSection:(MHSDSectionTypeEnum)type{
    IMBListContainerHeader *containerHeader = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        containerHeader = [_childSections objectAtIndex:i];
        if ([containerHeader type] == type) {
            return containerHeader;
        }
    }
    return nil;
}

-(IMBPlaylistList*)getPlaylistList {
    if ([self getChildSection:Playlists] != nil) {
        IMBPlaylistListContainer *playlistsContainer = (IMBPlaylistListContainer*)[[self getChildSection:Playlists] getListContainer];
        return [playlistsContainer getPlaylistList];
    }
    
    if ([self getChildSection:PlaylistsV2] != nil) {
        IMBPlaylistListV2Container *playlistsContainer = (IMBPlaylistListV2Container*)[[self getChildSection:PlaylistsV2] getListContainer];
        return [playlistsContainer getPlaylistList];
    }
    return nil;
}

-(IMBPlaylistList*)getPlaylistListV2 {
    if ([self getChildSection:PlaylistsV2] != nil) {
        IMBPlaylistListV2Container *playlistsContainer = (IMBPlaylistListV2Container*)[[self getChildSection:PlaylistsV2] getListContainer];
        return [playlistsContainer getPlaylistList];
    }
    return nil;
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end

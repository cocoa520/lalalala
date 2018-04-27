//
//  IMBPlaylist.m
//  iMobieTrans
//
//  Created by Pallas on 12/28/12.
//  Copyright (c) 2012 iMobie Inc. All rights reserved.
//

#import "IMBPlaylist.h"
#import "IMBPlaylistItem.h"
#import "StringHelper.h"

@implementation IMBPlaylist
@synthesize iD = _iD;
@synthesize isDirty = _isDirty;
@synthesize playlistItems = _playlistItems;
@synthesize bindingTrackList = _bindingTrackList;
@synthesize lengthSummary = _lengthSummary;
@synthesize sizeSummary = _sizeSummary;
@synthesize betweenDeviceCopyableTrackList = _betweenDeviceCopyableTrackList;
@synthesize isPurchases = _isPurchases;

-(id)init {
    self = [super init];
    if (self) {
        _headerSize = 108;
        _requiredHeaderSize = 48 + 35;
        _unk1 = malloc(4);
        unk1Length = 3;
        memset(_unk1, 0, malloc_size(_unk1));
        _stringObjectCount = 1;
        _dataObjects = [[NSMutableArray alloc] init];
        _playlistItems = [[NSMutableArray alloc] init];
        unusedHeaderLength = _headerSize - _requiredHeaderSize;
        _unusedHeader = malloc((_headerSize - _requiredHeaderSize) + 1);
        memset(_unusedHeader, 0, malloc_size(_unusedHeader));
        _bindingTrackList = [[NSMutableArray alloc] init];
        _unk4 = malloc(34 + 1);
        unk4Length= 34;
        memset(_unk4, 0, malloc_size(_unk4));
        _playlistType = 0;
    }
    return self;
}

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [self init];
    if (self) {
        iPod = ipod;
    }
    return self;
}

-(void)dealloc {
    free(_identifier);
    free(_unk1);
    if (_dataObjects != nil) {
        [_dataObjects release];
        _dataObjects = nil;
    }
    if (_playlistItems != nil) {
        [_playlistItems release];
        _playlistItems = nil;
    }
    if (_bindingTrackList != nil) {
        [_bindingTrackList release];
        _bindingTrackList = nil;
    }
    if (_betweenDeviceCopyableTrackList != nil){
        [_betweenDeviceCopyableTrackList release];
        _betweenDeviceCopyableTrackList = nil;
    }
    free(_unk4);
    [_sizeSummary release];
    [_lengthSummary release];
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    
    int readLength = 0;
    readLength = 4;
    identifierLength = readLength;
    _identifier = malloc(readLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    [reader getBytes:_identifier range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_headerSize);
    [reader getBytes:&_headerSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    if (_headerSize < 48 + 35) {
        _requiredHeaderSize = _headerSize;
    }
    [self validateHeader:@"mhyp"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    int dataObjectCount = 0;
    readLength = sizeof(dataObjectCount);
    [reader getBytes:&dataObjectCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    int playlistItemCount = 0;
    readLength = sizeof(playlistItemCount);
    [reader getBytes:&playlistItemCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_isMaster);
    [reader getBytes:&_isMaster range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = 3;
    unk1Length =readLength;
    [reader getBytes:_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_timeStamp);
    [reader getBytes:&_timeStamp range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_iD);
    [reader getBytes:&_iD range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk3);
    [reader getBytes:&_unk3 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_stringObjectCount);
    [reader getBytes:&_stringObjectCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_isPodcast);
    [reader getBytes:&_isPodcast range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_sortField);
    [reader getBytes:&_sortField range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    if (_headerSize >= 48 + 35) {
        readLength = 34;
        unk4Length =readLength;
        [reader getBytes:_unk4 range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
        readLength = sizeof(_playlistType);
        [reader getBytes:&_playlistType range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
    }
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < dataObjectCount; i++) {
        IMBBaseMHODElement *mhod = [IMBMHODFactory readMHOD:iPod reader:reader currPosition:&currPosition];
        if ([mhod type] == SMARTPLAYLISTRULE || [mhod type] == SMARTPLAYLISTDATA) {
            _isSmartPlaylist = TRUE;
        }
        [_dataObjects addObject:mhod];
    }
    
    for (int i = 0; i < playlistItemCount; i++) {
        IMBPlaylistItem *mhip = [[IMBPlaylistItem alloc] init];
        currPosition = [mhip read:iPod reader:reader currPosition:currPosition];
        [_playlistItems addObject:mhip];
        [mhip release];
        mhip = nil;
    }
    return currPosition;
}

-(void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    
    identifierLength = 4;
    _identifier = (char*)malloc(identifierLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhyp", malloc_size(_identifier));
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    int dataObjectCount = (int)[_dataObjects count];
    [writer appendBytes:&dataObjectCount length:sizeof(dataObjectCount)];
    int playlistItemCount = (int)[_playlistItems count];
    [writer appendBytes:&playlistItemCount length:sizeof(playlistItemCount)];
    [writer appendBytes:&_isMaster length:sizeof(_isMaster)];
    [writer appendBytes:_unk1 length:unk1Length];
    [writer appendBytes:&_timeStamp length:sizeof(_timeStamp)];
    [writer appendBytes:&_iD length:sizeof(_iD)];
    [writer appendBytes:&_unk3 length:sizeof(_unk3)];
    [writer appendBytes:&_stringObjectCount length:sizeof(_stringObjectCount)];
    [writer appendBytes:&_isPodcast length:sizeof(_isPodcast)];
    [writer appendBytes:&_sortField length:sizeof(_sortField)];
    [writer appendBytes:_unk4 length:unk4Length];
    [writer appendBytes:&_playlistType length:sizeof(_playlistType)];
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < dataObjectCount; i++) {
        mhod = [_dataObjects objectAtIndex:i];
        [mhod write:writer];
    }
    
    IMBPlaylistItem *mhip = nil;
    for (int i = 0; i < playlistItemCount; i++) {
        mhip = [_playlistItems objectAtIndex:i];
        [mhip write:writer];
    }
}

-(int)getSectionSize {
    int size = _headerSize;
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_dataObjects count]; i++) {
        mhod = [_dataObjects objectAtIndex:i];
        size += [mhod getSectionSize];
    }
    
    IMBPlaylistItem *mhip = nil;
    for (int i = 0; i < [_playlistItems count]; i++) {
        mhip = [_playlistItems objectAtIndex:i];
        size += [mhip getSectionSize];
    }
    
    return size;
}

- (IMBStringMHOD*)getDataElement:(int)type {
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_dataObjects count]; i++) {
        mhod = [_dataObjects objectAtIndex:i];
        if ([[mhod superclass] isSubclassOfClass:[IMBStringMHOD class]] && [mhod type] == type) {
            return (IMBStringMHOD*)mhod;
        }
    }
    return nil;
}

- (void)setName:(NSString *)name {
    if ([self isPodcastPlaylist]) {
        @throw [NSException exceptionWithName:@"EX_Not_Allowed_Modify_PodcastPlistName" reason:@"Podcast playlist name is not allowed modify!" userInfo:nil];
    }
    if ([@"" isEqualToString:name] && name != nil) {
        @throw [NSException exceptionWithName:@"EX_Not_Allowed_PlistName" reason:@"Playlist name is nil or empty!" userInfo:nil];
    }
    IMBUnicodeMHOD *titleElement = (IMBUnicodeMHOD*)[self getDataElement:TITLE];
    if (titleElement != nil) {
        [titleElement setData:name];
    } else {
        titleElement = [[IMBUnicodeMHOD alloc] initWithType:TITLE];
        [titleElement setData:name];
        [titleElement setPosition:1];
        [_dataObjects addObject:titleElement];
        [titleElement release];
    }
    _isDirty = TRUE;
}

- (NSString*)name {
    IMBStringMHOD *title = [self getDataElement:TITLE];
    if (title != nil) {
        return [title data];
    }
    if ([self isMaster] == YES) {
        return @"iPod";
    }
    return @"Unnamed";
}

- (NSString*) nameAndCountString {
    int count = [self trackCount];
    if (count > 0) {
        return [NSString stringWithFormat:@"%@ (%d)",self.name,count];
    }
    return self.name;
}

- (BOOL)isMaster {
    if ((BOOL)_isMaster == true) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (BOOL)isSmartPlaylist{
    if (_isSmartPlaylist == 1) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (void)setIsPodcastPlaylist:(BOOL)isPodcastPlaylist {
    if (isPodcastPlaylist) {
        _isPodcast = 1;
    } else {
        _isPodcast = 0;
    }
}

- (BOOL)isPodcastPlaylist {
    if (_isPodcast == 1) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (BOOL)isUserDefinedPlaylist {
    if (![self isMaster] && ![self isSmartPlaylist] && ![self isPodcastPlaylist] && ![self isAudiobookPlaylist] && ![self isiTunesUPlaylist] && ![self isVoiceMemoPlaylist]) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (BOOL)isVoiceMemoPlaylist {
    if ((int)_playlistType == 17) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (BOOL)isAudiobookPlaylist {
    if ((int)_playlistType == 30) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (BOOL)isiTunesUPlaylist {
    if (_playlistType == 34) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (int)distinguishedKind {
    return (int)_playlistType;
}

- (void)setSortField:(PlaylistSortFieldEnum)sortField {
    _sortField = sortField;
    _isDirty = TRUE;
}

- (PlaylistSortFieldEnum)sortField {
    @try {
        PlaylistSortFieldEnum sortfield = (PlaylistSortFieldEnum)_sortField;
        return sortfield;
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"EX_Unknown_SortOrder" reason:@"unknown sortorder" userInfo:nil];
    }
    @finally {
        
    }
}

- (int)trackCount {
    return (int)[_bindingTrackList count];
}

- (int)itemCount {
    return (int)[_playlistItems count];
}

- (IMBTrack*)getTrackByIndex:(int)index {
    IMBPlaylistItem *mhip = [_playlistItems objectAtIndex:index];
    return [mhip track];
}

- (IMBPlaylistItem*)getPlaylistItemByIndex:(int)index {
    return [_playlistItems objectAtIndex:index];
}

- (void)setAudiobookPlaylist {
    _playlistType = 30;
}

- (void)setitunesUPlaylist {
    _playlistType = 34;
}

- (void)resolveTrack:(IMBiPod*)ipod {
    iPod = ipod;
    IMBPlaylistItem *mhip = nil;
    for (int i = 0; i < [_playlistItems count]; i++) {
        mhip = [_playlistItems objectAtIndex:i];
        [mhip resolveTrack:iPod];
        if ([mhip track] != nil) {
            if (![_bindingTrackList containsObject:[mhip track]]) {
                //过滤除music以外的类型，如pdf等
                if([mhip track].mediaType != Books && [mhip track].mediaType != VoiceMemo && [mhip track].mediaType != PDFBooks && [mhip track].mediaType != Application && [mhip track].mediaType != Photo) {
                    [_bindingTrackList addObject:[mhip track]];
                }
            }
        }
    }
}

- (void)updateSummaryData {
    long totalSize = 0;
    long totalLength = 0;
    for (IMBTrack *track in [self tracks]) {
        totalSize += [track fileSize];
        totalLength += [track length];
    }
    _sizeSummary = [[StringHelper getFileSizeString:totalSize reserved:0] retain];
    _lengthSummary = [[StringHelper getTimeString:totalLength] retain];
}

- (NSMutableArray*)tracks {
    return _bindingTrackList;
}

- (BOOL)containsTrackByItem:(IMBTrack*)track {
    for (IMBTrack *trackItem in [self tracks]) {
        if ([trackItem isEqual:track]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (BOOL)containsTrackByDBID:(long long)dbID {
    for (IMBTrack *track in [self tracks]) {
        if ([track dbID] == dbID) {
            return TRUE;
        }
    }
    return FALSE;
}

- (void)addItem:(IMBPlaylistItem*)item position:(int)position {
    if (position < 0) {
        [item setPlaylistPostion:(int)([_playlistItems count] + 1)];
        [_playlistItems addObject:item];
    } else {
        [item setPlaylistPostion:position];
        [_playlistItems insertObject:item atIndex:position];
    }
}

- (void)addTrack:(IMBTrack*)track {
    [self addTrack:track position:-1 skipChecks:FALSE];
}

- (void)addTrack:(IMBTrack *)track position:(int)position {
    [self addTrack:track position:position skipChecks:FALSE];
}

- (void)addTrack:(IMBTrack *)track position:(int)postion skipChecks:(BOOL)skipChecks {
    if (!skipChecks) {
        [self assertModificationRights];
    }
    
    if ([self containsTrackByItem:track]) {
        return;
    }
    
    IMBPlaylistItem *item = [[IMBPlaylistItem alloc] init];
    [item setTrack:track];
    
    if ([self isPodcastPlaylist]) {
        [track setRememberPlaybackPosition:TRUE];
        [track setPodcastFlag:TRUE];
    }
    
    if (postion < 0) {
        [item setPlaylistPostion:(int)([_playlistItems count] + 1)];
        [_playlistItems addObject:item];
        NSLog(@"_playlistItems count1 %lu", (unsigned long)[_playlistItems count]);
        [_bindingTrackList addObject:track];
    } else {
        [item setPlaylistPostion:postion];
        [_playlistItems insertObject:track atIndex:postion];
        [_bindingTrackList insertObject:track atIndex:postion];
    }
    
    [self updateSummaryData];
    _isDirty = TRUE;
}

- (void)removeTrack:(IMBTrack*)track {
    [self removeTrack:track skipChecks:FALSE];
}

- (void)removeTrack:(IMBTrack *)track skipChecks:(BOOL)skipChecks{
    if (!skipChecks) {
        [self assertModificationRights];
    }
    
    IMBPlaylistItem *currentItem = nil;
    int groupParent = 0;
    for (IMBPlaylistItem *item in _playlistItems) {
        if ([item track] != nil && ([[item track] dbID] == [track dbID] || [[item track] iD] == [track iD])) {
            groupParent = [item podcastGroupParent];
            currentItem = [item retain];
            [_playlistItems removeObject:item];
            [[track playlistPids] addObject:[NSNumber numberWithLongLong:[self iD]]];
            break;
        }
    }
    
    if (currentItem != nil) {
        if ([self isPodcastPlaylist] || [self isiTunesUPlaylist]) {
            IMBPlaylistItem *parentItem = [self getGroupByGroupID:[currentItem podcastGroupParent]];
            //IMBPlaylistItem *parentItem = [self getGroupByGroupID:groupParent];
            if (parentItem != nil) {
                if (![self groupHasEntries:parentItem]) {
                    [self removeItem:parentItem];
                }
            }
        }
        
        if ([_bindingTrackList containsObject:track]) {
            [_bindingTrackList removeObject:track];
        }
        [self updateSummaryData];
        _isDirty = TRUE;
        //[currentItem release];
    }
}

- (void)removeAllItems {
    [_playlistItems removeAllObjects];
    [_bindingTrackList removeAllObjects];
}

- (void)removeItem:(IMBPlaylistItem*)item {
    [_playlistItems removeObject:item];
}

- (void)moveTrackToPosition:(IMBTrack*)track newPosition:(int)newPosition {
    [track retain];
    [self removeTrack:track];
    [self addTrack:track position:newPosition];
    [track release];
}

- (BOOL)groupHasEntries:(IMBPlaylistItem*)group {
    for (IMBPlaylistItem *item in _playlistItems) {
        if ([item podcastGroupParent] == [group groupID]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (IMBPlaylistItem*)getGroupByGroupID:(int)groupID {
    for (IMBPlaylistItem *item in _playlistItems) {
        if ([item groupID] == groupID) {
            return item;
        }
    }
    return nil;
}

- (void)assertModificationRights {
    if (_isSmartPlaylist) {
        @throw [NSException exceptionWithName:@"EX_NotAllowed_Change_SmartPl" reason:@"Smartplaylist not allow change!" userInfo:nil];
    }
    
    if (_isMaster == 1) {
        @throw [NSException exceptionWithName:@"Ex_NotAllowed_Change_MasterPl" reason:@"Masterplaylist not allow change!" userInfo:nil];
    }
}

- (void)clearTable {
    if (_isMaster) {
        for (int i = (int)[_dataObjects count] - 1; i >= 0; i--) {
            IMBBaseMHODElement *mhod = [_dataObjects objectAtIndex:i];
            if ([mhod type] == MENUINDEXTABLE ||
                [mhod type] == LETTERJUMPTABLE) {
                [_dataObjects removeObjectAtIndex:i];
            }
        }
    }
}

@end

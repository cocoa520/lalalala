//
//  IMBPlaylistList.m
//  MediaTrans
//
//  Created by Pallas on 12/20/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBPlaylistList.h"
#import "IMBSession.h"
#import "IMBPodcastListAdapter.h"

@implementation IMBPlaylistList
@synthesize playlistArray = _playlistArray;
@synthesize isDirty = _isDirty;

- (id)init {
    self = [super init];
    if (self) {
        identifierLength = 4;
        _requiredHeaderSize = 12;
        _playlistArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_playlistArray release];
    [super dealloc];
}

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
    [self validateHeader:@"mhlp"];
    
    readLength = sizeof(_playlistCount);
    [reader getBytes:&_playlistCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < _playlistCount; i++) {
        IMBPlaylist *playlist = [[IMBPlaylist alloc] init];
        currPosition = [playlist read:iPod reader:reader currPosition:currPosition];
        if (playlist.isUserDefinedPlaylist != false ||(playlist.isMaster == true)) {
             [_playlistArray addObject:playlist];
        }
       
        [playlist release];
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer{
    [writer appendBytes:_identifier length:identifierLength];
    
    identifierLength = 4;
    _identifier = (char*)malloc(identifierLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhlp", malloc_size(_identifier));
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    int childCount = (int)[_playlistArray count];
    [writer appendBytes:&childCount length:sizeof(childCount)];
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    
    IMBPlaylist *playlist = nil;
    for (int i = 0; i < [_playlistArray count]; i++) {
        playlist = [_playlistArray objectAtIndex:i];
        [playlist write:writer];
    }
    _isDirty = FALSE;
}

- (int)getSectionSize{
    int size = _headerSize;
    IMBPlaylist *playlist = nil;
    for (int i = 0; i < [_playlistArray count]; i++) {
        playlist = [_playlistArray objectAtIndex:i];
        size += [playlist getSectionSize];
    }
    return size;
}

- (void)resolveTracks {
    for (IMBPlaylist *pItem in _playlistArray) {
        [pItem resolveTrack:iPod];
        [pItem updateSummaryData];
    }
}

- (IMBPlaylist*)getPlaylistByName:(NSString*)playlistName {
    IMBPlaylist *playlist = nil;
    for (IMBPlaylist *item in _playlistArray) {
        if ([[item name] isEqualToString:playlistName]) {
            playlist = item;
        }
    }
    return playlist;
}

- (IMBPlaylist*)getPlaylistByID:(long long)playlistID {
    NSLog(@"playlistID %lld", playlistID);
    for (IMBPlaylist *pItem in _playlistArray) {
        NSLog(@"pItem %lld", pItem.iD);
        if ([pItem iD] == playlistID) {
            NSLog(@"pItem  true");
            return pItem;
        }
    }
    return nil;
}

- (IMBPlaylist*)getMasterPlaylist {
    for (IMBPlaylist *pItem in _playlistArray) {
        if ([pItem isMaster]) {
            NSLog(@"pItem isMaster is true");
            return pItem;
        }
    }
    return nil;
}

- (BOOL)contains:(IMBPlaylist*)item {
    return [_playlistArray containsObject:item];
}

- (IMBPlaylist*)addPlaylist:(long)playlistID playlistName:(NSString*)playlistName {
    if ([self getPlaylistByName:playlistName] != nil) {
        @throw [NSException exceptionWithName:@"EX_Playlist_Already_Exists" reason:@"Playlist's name already exists!" userInfo:nil];
    }
    
    IMBPlaylist *newPlaylist = [[IMBPlaylist alloc] initWithIPod:iPod];
    [newPlaylist setName:playlistName];
    if ([@"Podcasts" isEqualToString:playlistName]) {
        [newPlaylist setIsPodcastPlaylist:YES];
    }
    
    [newPlaylist setID:playlistID];
    [newPlaylist updateSummaryData];
    [_playlistArray addObject:newPlaylist];
    
    [newPlaylist autorelease];
    _isDirty = YES;
    return newPlaylist;
}

- (IMBPlaylist*)addPlaylist:(NSString*)playlistName {
    if ([self getPlaylistByName:playlistName] != nil) {
        @throw [NSException exceptionWithName:@"EX_Playlist_Already_Exists" reason:@"Playlist's name already exists!" userInfo:nil];
    }
    
    IMBPlaylist *newPlaylist = [[[IMBPlaylist alloc] initWithIPod:iPod] autorelease];
    [newPlaylist setName:playlistName];
    if ([playlistName isEqualToString:@"Podcasts"]) {
        [newPlaylist setIsPodcastPlaylist:TRUE];
    }
    
    // 在这里需要进行判断pid是否有重复的重复了就重新生成
    uint64_t pid = 0;
    while(YES) {
        srandom((unsigned int)time((time_t *)NULL));
        pid = [[NSString stringWithFormat:@"%ld%ld", random(), random()] longLongValue];
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ([(IMBPlaylist *)evaluatedObject iD] == pid);
        }];
        NSArray *tmp = [_playlistArray filteredArrayUsingPredicate:pre];
        if (tmp != nil && [tmp count] > 0) {
        } else {
            break;
        }
    }
    [newPlaylist setID:pid];
    [newPlaylist updateSummaryData];
    [_playlistArray addObject:newPlaylist];
    
    _isDirty = TRUE;
    return newPlaylist;
}

- (void)removeTrackFromAllPlaylists:(IMBTrack*)track {
    for (IMBPlaylist *playlist in _playlistArray) {
        [playlist removeTrack:track skipChecks:TRUE];
    }
}

- (BOOL)removePlaylist:(IMBPlaylist*)playlist deleteTracks:(BOOL)deleteTracks {
    bool shipChecks = false;
    return [self removePlaylist:playlist deleteTracks:FALSE skipChecks:shipChecks];
}

- (BOOL)removePlaylist:(IMBPlaylist*)playlist deleteTracks:(BOOL)deleteTracks skipChecks:(BOOL)skipChecks {
    if (!skipChecks) {
        if ([playlist isMaster]) {
            @throw [NSException exceptionWithName:@"EX_NotAllowed_Remove_MasterPl" reason:@"Master playlist dont allowed remove" userInfo:nil];
        }
    }
    
    if (deleteTracks) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (IMBTrack *track in [playlist tracks]) {
            [temp addObject:track];
        }
        
        for (IMBTrack *track in temp) {
            [[iPod tracks] removeTrack:track];
        }
    }
    //todo 需要将要删除的playlisy加入到Session的删除playlist队列当中
    [[[iPod session] deletedPlaylists] addObject:playlist];
    [_playlistArray removeObject:playlist];
    _isDirty = TRUE;
    return TRUE;
}

- (NSMutableArray*)getPlaylist {
    return _playlistArray;
}

- (NSArray*)getUserDefinedPlaylists {
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (IMBPlaylist *pItem in _playlistArray) {
        if ([pItem isUserDefinedPlaylist]) {
            [array addObject:pItem];
                    }
    }
    return array;
}

- (void)followChanges:(IMBPlaylistList*)otherPlaylistList {
    for (IMBPlaylist *otherPlaylist in [otherPlaylistList getPlaylist]) {
        if ([self getPlaylistByID:[otherPlaylist iD]] == nil) {
            [_playlistArray addObject:otherPlaylist];
        }
    }
    
    for (int count = (int)([_playlistArray count] -1); count >= 0; count--) {
        IMBPlaylist *thisPlaylist = [_playlistArray objectAtIndex:count];
        IMBPlaylist *otherPlaylist = [otherPlaylistList getPlaylistByID:[thisPlaylist iD]];
        NSLog(@"thisPlaylist count:%lu" ,(unsigned long)[[thisPlaylist playlistItems] count]);
        NSLog(@"otherPlaylist count:%lu" ,(unsigned long)[[otherPlaylist playlistItems] count]);
        
        if (otherPlaylist == nil) {
            [self removePlaylist:thisPlaylist deleteTracks:FALSE skipChecks:TRUE];
        } else {
            if ([thisPlaylist isPodcastPlaylist] == FALSE) {
                [_playlistArray replaceObjectAtIndex:count withObject:otherPlaylist];
                NSLog(@"pl name:%@" ,[(IMBPlaylist*)[_playlistArray objectAtIndex:count] name]);
                NSLog(@"item count:%lu" ,(unsigned long)[[(IMBPlaylist*)[_playlistArray objectAtIndex:count] playlistItems] count]);
            } else {
                [thisPlaylist resolveTrack:iPod];
                IMBPodcastListAdapter *podcastsAdapter = [[IMBPodcastListAdapter alloc] initWithPlaylist:iPod playList:thisPlaylist];
                [podcastsAdapter followChanges:otherPlaylist];
            }
        }
    }
}

- (IMBPlaylist*)getPodcastPlaylist {
    for (IMBPlaylist *playlist in _playlistArray) {
        if ([playlist isPodcastPlaylist] == TRUE) {
            return playlist;
        }
    }
    return [self addPlaylist:@"Podcasts"];
}

- (IMBPlaylist*)getAudioBookPlaylist:(NSString*)name {
    NSString *aName = nil;
    if ([name isEqualToString:@""] || name == nil) {
        aName = UnknownName;
    } else {
        aName = name;
    }
    
    for (IMBPlaylist *playlist in _playlistArray) {
        if ([playlist isAudiobookPlaylist] == TRUE && [[playlist name] isEqualToString:aName]) {
            return playlist;
        }
    }
    
    IMBPlaylist *newPlaylist = [self addPlaylist:aName];
    [newPlaylist setAudiobookPlaylist];
    return newPlaylist;
}

- (IMBPlaylist*)getiTunesUPlaylist {
    for (IMBPlaylist *playlist in _playlistArray) {
        if ([playlist isiTunesUPlaylist] == TRUE) {
            return playlist;
        }
    }
    IMBPlaylist *newPlaylist = [self addPlaylist:@"iTunes U"];
    [newPlaylist setitunesUPlaylist];
    return newPlaylist;
}

@end

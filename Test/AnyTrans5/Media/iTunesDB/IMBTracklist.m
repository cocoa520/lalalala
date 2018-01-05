//
//  IMBTracklist.m
//  MediaTrans
//
//  Created by Pallas on 12/11/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBTracklist.h"
#import "IMBNewTrack.h"
#import "IMBPlaylistList.h"
#import "IMBArtworkDB.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import "IMBTransferError.h"


@implementation IMBTracklist
@synthesize trackArray = _trackArray;
@synthesize isDirty = _isDirty;
@synthesize freespace = _freespace;
#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if (self) {
        identifierLength = 4;
        _requiredHeaderSize = 12;
        _trackArray = [[NSMutableArray alloc] init];
        _artistOfTrackDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc{
    free(_identifier);
    if (_trackArray != nil) {
        [_trackArray release];
        _trackArray = nil;
    }
    if (_artistOfTrackDic != nil) {
        [_artistOfTrackDic release];
        _artistOfTrackDic = nil;
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
    [self validateHeader:@"mhlt"];
    
    readLength = sizeof(_trackCount);
    [reader getBytes:&_trackCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < _trackCount; i++) {
        IMBTrack *track = [[IMBTrack alloc] init];
        currPosition = [track read:iPod reader:reader currPosition:currPosition];
        [track setTitleAttributedString];
        [_trackArray addObject:track];
    
        if ([MediaHelper stringIsNilOrEmpty:track.artist]) {
            track.artist = @"";
        }
        NSMutableArray *array = [[_artistOfTrackDic objectForKey:track.artist] mutableCopy];
        if (array == nil) {
            array = [[[NSMutableArray alloc]init]autorelease];
        }
        [array addObject:track];
        [_artistOfTrackDic setObject:array forKey:track.artist];
        
        [track release];
        track = nil;
    }
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    identifierLength = 4;
    _identifier = (char*)malloc(identifierLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhlt", malloc_size(_identifier));
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    int childCount = (int)[_trackArray count];
    [writer appendBytes:&childCount length:sizeof(childCount)];
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    
    IMBTrack *track = nil;
    for (int i = 0; i < [_trackArray count]; i++) {
        track = [_trackArray objectAtIndex:i];
        [track write:writer];
    }
    _isDirty = FALSE;
}

-(int)getSectionSize{
    int size = _headerSize;
    IMBTrack *track = nil;
    for (int i = 0; i < [_trackArray count]; i++) {
        track = [_trackArray objectAtIndex:i];
        size += [track getSectionSize];
    }
    return size;
}

#pragma mark - 实现声明方法
- (int)getTrackCount {
    return (int)[_trackArray count];
}

- (IMBTrack*)getTrackByIndex:(int)index {
    return [_trackArray objectAtIndex:index];
}

-(IMBTrack*)findByID:(int)trackID{
    IMBTrack *track = nil;
    for (IMBTrack *item in _trackArray) {
        if ([item iD] == trackID) {
            track = item;
            break;
        }
    }
    return track;
}

-(IMBTrack*)findByDBID:(long long)dbID{
    IMBTrack *track = nil;
    for (IMBTrack *item in _trackArray) {
        if ([item dbID] == dbID) {
            track = item;
            break;
        }
    }
    return track;
}

-(BOOL)contains:(IMBTrack*)item{
    return [_trackArray containsObject:item];
}

- (IMBTrack*)getExistingTrack:(IMBNewTrack*)newTrack {
    if ([MediaHelper stringIsNilOrEmpty:[newTrack title]] == TRUE) {
        [newTrack setTitle:@""];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack artist]] == TRUE) {
        [newTrack setArtist:@""];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack album]] == TRUE) {
        [newTrack setAlbum:@""];
    }
    for (IMBTrack *existing in _trackArray)
    {
//        BOOL fileIsExist = [[iPod fileSystem] fileExistsAtPath:[[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:[existing filePath]]];
//        NSLog(@"%@ %@",[existing filePath],[[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:[existing filePath]]);
        
        if ([[existing title] isEqualToString:[newTrack title]]
            && [[existing artist] isEqualToString:[newTrack artist]]
            && [[existing album] isEqualToString:[newTrack album]]
            && ([existing length] / 1000) == ([newTrack length] / 1000)
            && [existing mediaType] == [newTrack dBMediaType]
            && existing.fileIsExist) {
            return existing;
        }
    }
    return nil;
}

- (IMBTrack*)getExistingTrack2:(IMBNewTrack*)newTrack {
    if ([MediaHelper stringIsNilOrEmpty:[newTrack title]] == TRUE) {
        [newTrack setTitle:@""];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack artist]] == TRUE) {
        [newTrack setArtist:@""];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack album]] == TRUE) {
        [newTrack setAlbum:@""];
    }
    NSArray *array = [_artistOfTrackDic objectForKey:newTrack.artist];
    if (array!= nil && array.count > 0) {
        for (IMBTrack *track in array) {
            if (track.album == nil) {
                track.album = @"";
            }
            if (track.title == nil) {
                track.title = @"";
            }
            BOOL fileIsExist = [[iPod fileSystem] fileExistsAtPath:[[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:[track filePath]]];

            if ([track.album isEqualToString:newTrack.album] && [track.title isEqualToString:newTrack.title] && ([track length] / 1000) == ([newTrack length] / 1000) && [track mediaType] == [newTrack dBMediaType] && fileIsExist) {
                return track;
            }
        }
    }
    return nil;
}

- (void)freshFreeSpace
{
    _freespace = [[iPod deviceInfo] availableFreeSpace];
}

- (IMBTrack *)addTrack:(IMBNewTrack *)newItem calcuTotalSize:(long long)calcuTotalSize srcPod:(IMBiPod*)srciPod {
    IMBTrack *existing = [self getExistingTrack:newItem];
    if (existing != nil) {
        NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:existing, @"Exsit_Track", [existing title], @"Track_Title", [existing artist], @"Track_Artist", [existing album], @"Track_Album", existing, @"Track",nil];
        [[IMBTransferError singleton] addAnErrorWithErrorName:existing.title WithErrorReson:CustomLocalizedString(@"Ex_Op_file_exist", nil)];
        @throw [NSException exceptionWithName:@"EX_Track_Already_Exists" reason:@"Track already exists" userInfo:userDic];
        return nil;
    }
    
    IMBTrack *track = [[IMBTrack alloc] init];
    @autoreleasepool {
        [track create:iPod newTrack:newItem srciPod:srciPod];
        _freespace -= track.fileSize;
        if (_freespace <= 10000000) {//设备剩余空间小于10M
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[[iPod deviceInfo] deviceName], @"DeviceName", nil];
            @throw [NSException exceptionWithName:@"EX_OutOfDiskSpace" reason:@"Device freespace isn't enougth" userInfo:userDic];
        }
        if (![MediaHelper stringIsNilOrEmpty:[newItem artworkFile]] ) {
//        if (newItem.artworkData != nil) {
            @try {
                [track setArtworkPath:newItem.artworkFile];
                [track setArtworkByPath:[newItem artworkFile]];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception reason]);
            }
        }
    }
    return [track autorelease];
}

- (IMBTrack *)addTrack:(IMBNewTrack *)newItem calcuTotalSize:(long long)calcuTotalSize {
    
    return [self addTrack:newItem calcuTotalSize:calcuTotalSize srcPod:nil];
}

- (void)addTrackToPlaylist:(IMBTrack *)track {
    @try {
        
        [_trackArray addObject:track];
        IMBPlaylist *master = [[iPod playlists] getMasterPlaylist];
        NSLog(@"master name:%@",master.name);
        [master addTrack:track position:-1 skipChecks:TRUE];
        NSLog(@"master name:%@",master.name);
        //[[[iPod playlists] getMasterPlaylist] addTrack:track :-1 :TRUE];
        if ([track mediaType] == Podcast || [track mediaType] == VideoPodcast) {
            [[[iPod playlists] getPodcastPlaylist] addTrack:track];
        }
        if ([track mediaType] == iTunesU || [track mediaType] == iTunesUVideo) {
            [[[iPod playlists] getiTunesUPlaylist] addTrack:track];
        }
    }
    @catch (NSException *exception) {
        if ([exception.name isEqualToString:@"EX_NotAllowed_Change_SmartPl"]) {
            NSLog(@"%@",exception.reason);
        }
        else if([exception.name isEqualToString:@"Ex_NotAllowed_Change_MasterPl"]){
            NSLog(@"%@",exception.reason);
        }
    }

}

- (IMBTrack*)addTrack:(IMBNewTrack*)newItem copyToDevice:(BOOL)copyToDevice cacuTotalSize:(long long)calcuTotalSize {
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //文件系统中不存在新曲目路径
    if ([fileManager fileExistsAtPath:[newItem filePath]] == NO) {
        @throw [NSException exceptionWithName:@"EX_File_Not_Exist" reason:[NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_File_Not_Exist", nil), [newItem filePath]] userInfo:nil];
    }
    IMBTrack *track;
    track = [self addTrack:newItem calcuTotalSize:calcuTotalSize];
    [self addTrackToPlaylist:track];
//    [track autorelease];
    return track;
}

//
- (IMBTrack*)addTrack:(IMBNewTrack*)newItem copyToDevice:(BOOL)copyToDevice calcuTotalSize:(long long)calcuTotalSize WithSrciPod:(IMBiPod*)srciPod{
    /*if ([newItem isVideo] == NO) {
     @throw [NSException exceptionWithName:@"EX_Property_Not_Set" reason:@"NewTrack's IsVideo property must be set" userInfo:nil];
     }*/
    NSString *mediaPath = [srciPod.fileSystem.driveLetter stringByAppendingPathComponent:newItem.filePath];
    if(![srciPod.fileSystem fileExistsAtPath:mediaPath]) {
        @throw [NSException exceptionWithName:@"EX_File_Not_Exist" reason:[NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_File_Not_Exist", nil), [newItem filePath]] userInfo:nil];
    }
    IMBTrack *track;
    //Todo: 这个地方需要retain吗。
    track = [self addTrack:newItem calcuTotalSize:calcuTotalSize srcPod:srciPod];
    [self addTrackToPlaylist:track];
    [track autorelease];
    return track;
}

-(BOOL)removeTrack:(IMBTrack*)track {
    IMBTrack *trackToRemove = [track retain];
    if ([iPod artworkDB] != nil) {
        [[iPod artworkDB] removeArtwork:trackToRemove];
    }
    [[iPod playlists] removeTrackFromAllPlaylists:trackToRemove];
    [[[iPod session] deletedTracks] addObject:trackToRemove];
    NSString *ipodFileName = [[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:[trackToRemove filePath]];
    [_trackArray removeObject:track];
    if ([_trackArray containsObject:trackToRemove] == NO) {
        if ([[iPod fileSystem] fileExistsAtPath:ipodFileName] == YES) {
            [[iPod fileSystem] unlink:ipodFileName];
        }
    }
    _isDirty = TRUE;
    [trackToRemove release];
    return TRUE;
}
@end

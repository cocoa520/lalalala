//
//  IMBMusicDatabase.m
//  MediaTrans
//
//  Created by Pallas on 12/18/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBMusicDatabase.h"
#import "IMBDatabaseHasher.h"
#import "IMBFileSystem.h"
#import "IMBLogManager.h"
#import "IMBDeviceInfo.h"
@implementation IMBMusicDatabase
@synthesize tracklist = _tracklist;
@synthesize playlistList = _playlistList;

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [self init];
    if (self) {
        iPod = [ipod retain];
        NSString *CDBPath = [ipod.fileSystem.iTunesFolderPath stringByAppendingPathComponent:@"iTunesCDB"];
        NSString *DBPath = [ipod.fileSystem.iTunesFolderPath stringByAppendingPathComponent:@"iTunesDB"];
        if ([ipod.fileSystem fileExistsAtPath:CDBPath]) {
            databaseFilePath = CDBPath;
        } else {
            if (!ipod.deviceInfo.isIOSDevice) {
                databaseFilePath = DBPath;
            }else {
                databaseFilePath = CDBPath;
            }
        }
        [databaseFilePath retain];
    }
    return self;
}

-(void)dealloc{
    if (databaseRoot != nil) {
        [databaseRoot release];
        databaseRoot = nil;
    }
    if (databaseFilePath != nil) {
        [databaseFilePath release];
        databaseFilePath = nil;
    }
    if (iPod != nil) {
        [iPod release];
        iPod = nil;
    }
    [super dealloc];
}

-(int)version{
    return databaseRoot.versionNumber;
}

-(int)hashingScheme{
    return databaseRoot.hashingScheme;
}

-(BOOL)isDirty {
    if ([self tracklist] != nil) {
        if ([[self tracklist] isDirty] == YES || [[self playlistList] isDirty] == YES) {
            return YES;
        }
        for (IMBTrack *track in [[self tracklist] trackArray]) {
            if ([track isDirty] == YES) {
                return YES;
            }
        }
        for (IMBPlaylist *playlist in [[self playlistList] playlistArray]) {
            if ([playlist isDirty] == YES) {
                return YES;
            }
        }
        return NO;
    } else {
        return NO;
    }
}

-(void)parse{
    if ([[iPod fileSystem] fileExistsAtPath:databaseFilePath] == NO) {
        [[IMBLogManager singleton] writeInfoLog:@"itunes CDB file not exsit"];
        NSString *bundelPath = [[NSBundle mainBundle] pathForResource:@"iTunesCDB" ofType:@""];
        if ([[NSFileManager defaultManager] fileExistsAtPath:bundelPath]) {
            if (![[iPod fileSystem] copyLocalFile:bundelPath toRemoteFile:databaseFilePath]) {
                [[IMBLogManager singleton] writeInfoLog:@"itunes CDB file not exsit(copy)"];
                @throw [[NSException alloc] initWithName:@"EX_InvalidiPodDriver_DB_Not_Found" reason:@"CDB file not exsit!" userInfo:nil];
            }
        }else {
            [[IMBLogManager singleton] writeInfoLog:@"itunes CDB file not exsit(local)"];
            @throw [[NSException alloc] initWithName:@"EX_InvalidiPodDriver_DB_Not_Found" reason:@"CDB file not exsit!" userInfo:nil];
        }
    }
    
    if ([[iPod fileSystem] getFileLength:databaseFilePath]== 0) {
        @throw [[NSException alloc] initWithName:@"EX_InvalidIpodDriver_DB_Empty" reason:@"CDB filesize is 0!" userInfo:nil];
    }
    
    if ([[iPod fileSystem] fileExistsAtPath:[[iPod fileSystem] iTunesLockPath]] == YES) {
        @try {
            [[iPod fileSystem] unlink:[[iPod fileSystem] iTunesLockPath]];
        }
        @catch (NSException *exception) {
            NSLog(@"Unlock error: %@", [exception description]);
        }
    }
    
    if ([databaseFilePath hasSuffix:@"iTunesCDB"] == YES) {//后缀；；；prefix ： 前缀
        databaseRoot = [[IMBiTunesCDBRoot alloc] init];
    } else {
        databaseRoot = [[IMBiTunesDBRoot alloc] init];
    }
    [self readDatabase:databaseRoot];
    tracksContainer = (IMBTrackListContainer*)[[databaseRoot getChildSection:Tracks] getListContainer];
    _tracklist = [tracksContainer getTracklist];
    _playlistList = [databaseRoot getPlaylistList];
    if (_playlistList != nil)
    {
        [_playlistList resolveTracks];
    }
}

- (void)save {
    IMBPlaylistListV2Container *playlistV2Container = nil;
    if ([databaseRoot getChildSection:PlaylistsV2] != nil) {
        playlistV2Container = (IMBPlaylistListV2Container*)[[databaseRoot getChildSection:PlaylistsV2] getListContainer];
        IMBPlaylistList *playlistV2List = [playlistV2Container getPlaylistList];
        if (![[self playlistList] isEqual:playlistV2List]) {
            IMBPlaylist *playlist = nil;
            for (int i = (int)([[[self playlistList] playlistArray] count] - 1); i >= 0; i--) {
                playlist = [[[self playlistList] playlistArray] objectAtIndex:i];
                if (([playlist isAudiobookPlaylist] == TRUE || [playlist isPodcastPlaylist] == TRUE ||
                     [playlist isiTunesUPlaylist] == TRUE) && [[playlist tracks] count] == 0) {
                    [[self playlistList] removePlaylist:playlist deleteTracks:FALSE skipChecks:TRUE];
                }
            }
            [playlistV2List followChanges:[self playlistList]];
        }
    }
    
    IMBPlaylist *playlist = nil;
    for (int i = (int)([[[self playlistList] playlistArray] count] - 1); i >= 0; i--) {
        playlist = [[[self playlistList] playlistArray] objectAtIndex:i];
        if (([playlist isAudiobookPlaylist] == TRUE || [playlist isPodcastPlaylist] == TRUE ||
             [playlist isiTunesUPlaylist] == TRUE) && [[playlist tracks] count] == 0) {
            [[self playlistList] removePlaylist:playlist deleteTracks:FALSE skipChecks:TRUE];
        }
    }
    
    [[[[self playlistList] playlistArray] objectAtIndex:0] clearTable];
    [super writeDatabase:databaseRoot];
}

- (void)doActionOnWriteDatabase:(NSString *)filePath {
    [[IMBLogManager singleton] writeInfoLog:@"++++++++++++hashAB begin++++++"];
    [IMBDatabaseHasher hash:filePath ipod:iPod];
    [[IMBLogManager singleton] writeInfoLog:@"++++++++++++hashAB end++++++"];
}

@end

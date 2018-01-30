//
//  IMBSyncPlaylistToCDB_BelowIOS5.m
//  iMobieTrans
//
//  Created by Pallas on 1/29/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSyncPlaylistToCDB_BelowIOS5.h"
#import "IMBIPod.h"
#import "IMBSession.h"
#import "IMBPlaylist.h"
#import "IMBPlaylistList.h"
#import "IMBFileSystem.h"

@implementation IMBSyncPlaylistToCDB_BelowIOS5

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [self init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)startSync {
    NSArray *fileArray = [[iPod fileSystem] getItemInDirectory:[[iPod fileSystem] iTunesFolderPath]];
    for (AMFileEntity *fileInfo in fileArray) {
        //对应Playlist_10467720660495263200.plist这类的文件
        if ([[fileInfo Name] hasPrefix:@"Playlist_"] &&
            [[fileInfo Name] hasSuffix:@"cig"]) {
            [filePaths addObject:[fileInfo FilePath]];
            [self snycPlaylist:[fileInfo Name] filePath:[fileInfo FilePath]];
            continue;
        }
    }
    
    //对应Playlist.plist这类的文件
    if ([[iPod fileSystem] fileExistsAtPath:[[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"Playlist.plist"]]) {
        NSString *filePath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"Playlist.plist"];
        [filePaths addObject:filePath];
        [self snycPlaylist:@"Playlist.plist" filePath:filePath];
    }
}

- (void)snycPlaylist:(NSString*)fileName filePath:(NSString*)filePath {
    if ([[iPod fileSystem] fileExistsAtPath:filePath]) {
        NSString *localPath = [[[iPod session] sessionFolderPath] stringByAppendingPathComponent:fileName];
        [[iPod fileSystem] copyRemoteFile:filePath toLocalFile:localPath];
        NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:localPath];
        NSString *playlistName = nil;
        if (dataDic != nil && [dataDic count] > 0) {
            if ([[dataDic allKeys] containsObject:@"name"]) {
                playlistName = [dataDic valueForKey:@"name"];
                if ([@"SYNC_MARKER" isEqualToString:playlistName]) {
                    return;
                }
                long plID = [[dataDic valueForKey:@"playlistPersistentID"] longValue];
                NSArray *trackDBIds = nil;
                if ([dataDic objectForKey:@"trackPersistentIDs"] != nil) {
                    trackDBIds = [dataDic objectForKey:@"trackPersistentIDs"];
                }
                
                IMBPlaylist *playlist = [[[iPod playlists] getPlaylistByID:plID] retain];
                if (playlist == nil) {
                    playlist = [[[iPod playlists] addPlaylist:plID playlistName:playlistName] retain];
                } else {
                    [playlist removeAllItems];
                }
                
                for (NSNumber *item in trackDBIds) {
                    IMBTrack *track = [[iPod tracks] findByDBID:[item longValue]];
                    if (track != nil) {
                        [playlist addTrack:track];
                    }
                }
                [playlist release];
                playlist = nil;
            } else {
                if ([[dataDic allKeys] containsObject:@"playlistDeleted"]) {
                    BOOL deleteFlag = [[dataDic valueForKey:@"playlistDeleted"] boolValue];
                    long plID = [[dataDic valueForKey:@"playlistPersistentID"] longValue];
                    if (deleteFlag) {
                        IMBPlaylist *playlist = [[[iPod playlists] getPlaylistByID:plID] retain];
                        if (playlist != nil) {
                            [[iPod playlists] removePlaylist:playlist deleteTracks:NO];
                        }
                        [playlist release];
                        playlist = nil;
                    }
                }
            }
        }
    }
}

- (void)cleanup {
    for (NSString *filePath in filePaths) {
        [[iPod fileSystem] unlink:filePath];
    }
}


@end

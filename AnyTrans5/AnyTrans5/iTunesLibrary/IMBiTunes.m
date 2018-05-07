//
//  IMBiTunes.m
//  iMobieTrans
//
//  Created by Pallas on 3/12/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBiTunes.h"
//#import "IMBTrack.h"
#import "IMBiTLTrack.h"
#import "IMBiTunesEnum.h"
#import "NSString+Category.h"
#import "IMBZipHelper.h"
#import "TempHelper.h"
#import "IMBMediaInfo.h"
#import "IMBTransferToiTunes.h"

@implementation IMBiTunes
@synthesize isLibraryParsed = _isLibraryParsed;
@synthesize isOpeniTunes = _isOpeniTunes;
- (id)init {
    self = [super init];
    if (self) {
        _loadiTunes = NO;
        _isOpeniTunes = NO;
        fm = [NSFileManager defaultManager];
        logHandle = [IMBLogManager singleton];
        nc = [NSNotificationCenter defaultCenter];
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(appDidLaunch:) name:NSWorkspaceDidLaunchApplicationNotification object:nil];
        [nc addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
        NSArray *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.iTunes"];
        iTunesApp = [[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];
        if (apps != nil && apps.count > 0) {
            sources = [[iTunesApp sources] retain];
            if (sources != nil && sources.count > 0 && !_loadiTunes) {
                // 通知界面可以加载iTunes Library
                int time = 0;
                while (YES) {
                    if (time > 3) {
                        break;
                    } else {
                        time += 1;
                    }
                    @try {
                        iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
                        if (librarySource != nil) {
//                            [nc postNotificationName:NOTIFY_ITUNES_STARTED object:nil userInfo:nil];
                            _loadiTunes = YES;
                            _isOpeniTunes = YES;
                            break;
                        }
                    }
                    @catch (NSException *exception) {
                        usleep(1000);
                    }
                }
            }
        } else {
            [iTunesApp run];
        }
        
        iTLTracks = [[NSMutableArray alloc] init];
        iTLPlaylists = [[NSMutableArray alloc] init];
        //[self parserLibrary];
    }
    return self;
}

+ (IMBiTunes*)singleton {
    static IMBiTunes *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBiTunes alloc] init];
		}
	}
	return _singleton;
}

- (void)appDidLaunch:(NSNotification*)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo != nil && userInfo.allKeys.count > 0) {
        NSArray* allkeys = userInfo.allKeys;
        if ([allkeys containsObject:@"NSApplicationBundleIdentifier"]) {
            NSString *bundleID = [userInfo objectForKey:@"NSApplicationBundleIdentifier"];
            if ([bundleID isEqualToString:@"com.apple.iTunes"]) {
//                if (iTunesApp != nil) {
//                    [iTunesApp release];
//                    iTunesApp = nil;
//                }
                if (sources != nil) {
                    [sources release];
                    sources = nil;
                }
//                iTunesApp = [[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];
                sources = [[iTunesApp sources] retain];
                if (sources != nil && sources.count > 0) {
                    if (!_loadiTunes) {
                        // 通知界面可以加载iTunes Library
                        int time = 0;
                        while (YES) {
                            if (time > 3) {
                                break;
                            } else {
                                time += 1;
                            }
                            @try {
                                iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
                                if (librarySource != nil) {
                                    //                                [nc postNotificationName:NOTIFY_ITUNES_STARTED object:nil userInfo:nil];
                                    _loadiTunes = YES;
                                    _isOpeniTunes = YES;
                                    break;
                                }
                            } @catch (NSException *exception) {
                                usleep(1000);
                            }
                        }
                    }
                }else {
                    [iTunesApp quit];
                    //提示用户iTunes打开失败
                    [logHandle writeInfoLog:@"itunes open error"];
                    _isOpeniTunes = NO;
                    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self name:NSWorkspaceDidLaunchApplicationNotification object:nil];
                }
            }
        }
    }
}

- (void)applicationWillTerminate:(NSNotification*)notification
{
    if (nc != nil) {
        [nc removeObserver:self];
        nc = nil;
    }
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    
    if (iTunesApp != nil) {
        [iTunesApp release];
        iTunesApp = nil;
    }
    
    if (sources != nil) {
        [sources release];
        sources = nil;
    }
}

- (void)dealloc {
    if (iTLTracks != nil) {
        [iTLTracks release];
        iTLTracks = nil;
    }
    
    if (iTLPlaylists != nil) {
        [iTLPlaylists release];
        iTLPlaylists = nil;
    }
    [super dealloc];
}

- (iTunesSource*)getLibrarySource:(iTunesESrc)kind {
    iTunesSource *librarySource = nil;
    if (sources != nil && sources.count > 0) {
        for (iTunesSource *source in sources) {
            if ([source kind] == iTunesESrcLibrary) {
                librarySource = source;
                break;
            }
        }
    }
    return librarySource;
}

//zhangyang
//得到所有的itlPlaylist
-(NSArray*)getiTLPlaylists {
    return iTLPlaylists;
}

-(NSArray*)getCategoryiTLPlaylists {
    if (iTLPlaylists != nil) {
        NSArray *distinguishedArray = [[NSArray alloc] initWithObjects:
                                       [NSNumber numberWithInt:(int)iTunes_Music],
                                       [NSNumber numberWithInt:(int)iTunes_Movie],
                                       [NSNumber numberWithInt:(int)iTunes_TVShow],
                                       [NSNumber numberWithInt:(int)iTunes_Podcast],
                                       [NSNumber numberWithInt:(int)iTunes_iTunesU],
                                       [NSNumber numberWithInt:(int)iTunes_Books],
                                       [NSNumber numberWithInt:(int)iTunes_Audiobook],
                                       [NSNumber numberWithInt:(int)iTunes_Apps],
                                       [NSNumber numberWithInt:(int)iTunes_Ring],
                                       [NSNumber numberWithInt:(int)iTunes_VoiceMemos],
                                       [NSNumber numberWithInt:(int)iTunes_HomeVideo],
                                       nil];
        NSArray *categoryPlaylist = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"distinguishedKindId IN %@",distinguishedArray]];
        return categoryPlaylist;
    }
    return nil;
}

//TODO AudioBook需要跟上
-(NSArray*)getMediaCategoryiTLPlaylists {
    if (iTLPlaylists != nil) {
        NSArray *distinguishedArray = [[NSArray alloc] initWithObjects:
                                       [NSNumber numberWithInt:(int)iTunes_Music],
                                       [NSNumber numberWithInt:(int)iTunes_Movie],
                                       [NSNumber numberWithInt:(int)iTunes_TVShow],
                                       [NSNumber numberWithInt:(int)iTunes_Podcast],
                                       [NSNumber numberWithInt:(int)iTunes_iTunesU],
                                       nil];
        NSArray *categoryPlaylist = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"distinguishedKindId IN %@",distinguishedArray]];
        return categoryPlaylist;
    }
    return nil;
}

-(IMBiTLPlaylist*)getAppCategoryiTLPlaylist {
    if (iTLPlaylists != nil) {
        NSArray *distinguishedArray = [[NSArray alloc] initWithObjects:
                                       [NSNumber numberWithInt:(int)iTunes_Apps],
                                       nil];
        NSArray *categoryPlaylists = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"distinguishedKindId IN %@",distinguishedArray]];
        if (categoryPlaylists.count > 0) {
            return [categoryPlaylists objectAtIndex:0];
        } else {
            return nil;
        }
    }
    return nil;
}

//得到Master的playlist
-(IMBiTLPlaylist*)getMasterCategoryiTLPlaylist {
    if (iTLPlaylists != nil) {
        NSArray *categoryPlaylists = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMaster == true"]];
        if (categoryPlaylists.count > 0) {
            return [categoryPlaylists objectAtIndex:0];
        } else {
            return nil;
        }
    }
    return nil;
}

-(IMBiTLPlaylist*)getBookCategoryiTLPlaylist {
    if (iTLPlaylists != nil) {
        NSArray *distinguishedArray = [[NSArray alloc] initWithObjects:
                                       [NSNumber numberWithInt:(int)iTunes_Books],
                                       nil];
        NSArray *categoryPlaylists = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"distinguishedKindId IN %@",distinguishedArray]];
        if (categoryPlaylists.count > 0) {
            return [categoryPlaylists objectAtIndex:0];
        } else {
            return nil;
        }
    }
    return nil;
}

-(IMBiTLPlaylist*)getRingtoneCategoryiTLPlaylist {
    if (iTLPlaylists != nil) {
        NSArray *distinguishedArray = [[NSArray alloc] initWithObjects:
                                       [NSNumber numberWithInt:(int)iTunes_Ring],
                                       nil];
        NSArray *categoryPlaylists = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"distinguishedKindId IN %@",distinguishedArray]];
        if (categoryPlaylists.count > 0) {
            return [categoryPlaylists objectAtIndex:0];
        } else {
            return nil;
        }
    }
    return nil;
}

-(NSArray*)getNotCategoryiTLPlaylists {
    if (iTLPlaylists != nil) {
        NSArray *distinguishedArray = [[NSArray alloc] initWithObjects:
                                       [NSNumber numberWithInt:(int)iTunes_Music],
                                       [NSNumber numberWithInt:(int)iTunes_Movie],
                                       [NSNumber numberWithInt:(int)iTunes_TVShow],
                                       [NSNumber numberWithInt:(int)iTunes_Podcast],
                                       [NSNumber numberWithInt:(int)iTunes_iTunesU],
                                       [NSNumber numberWithInt:(int)iTunes_Books],
                                       [NSNumber numberWithInt:(int)iTunes_Apps],
                                       [NSNumber numberWithInt:(int)iTunes_Ring],
                                       [NSNumber numberWithInt:(int)iTunes_VoiceMemos],
                                       [NSNumber numberWithInt:(int)iTunes_Audiobook],
                                       nil];
        NSArray *PlaylistArray = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (distinguishedKindId IN %@) && isMaster != true ",distinguishedArray]];
        return PlaylistArray;
    }
    return nil;
}

-(NSArray*)getUserDefinediTLPlaylists {
    if (iTLPlaylists != nil) {
        NSArray *PlaylistArray = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"checkUserDefined == true"]];
        return PlaylistArray;
    }
    return nil;
}


//得到所有的itlTracks
-(NSArray*)getiTLTracks {
    return iTLTracks;
}

// 根据名称去获取Playlist对象
- (IMBiTLPlaylist*)getUserPlaylistByName:(NSString*)playlistName {
    for (IMBiTLPlaylist *item in iTLPlaylists) {
        if ([[item name] isEqualToString:playlistName] && item.isUserDefined) {
            return item;
        }
    }
    return nil;
}

- (IMBiTLPlaylist*)getPlaylistByName:(NSString*)playlistName {
    for (IMBiTLPlaylist *item in iTLPlaylists) {
        if ([[item name] isEqualToString:playlistName]) {
            return item;
        }
    }
    return nil;
}

-(IMBiTLPlaylist*)getiTLPlaylistByID:(int)playlistID {
    for (IMBiTLPlaylist *item in iTLPlaylists) {
        if (item.playlistID == playlistID) {
            return item;
        }
    }
    return nil;
}

- (IMBiTLPlaylist*)getPlaylistByDistinguished:(int)distinguishedKindId {
    for (IMBiTLPlaylist *item in iTLPlaylists) {
        if ([item distinguishedKindId] == distinguishedKindId) {
            return item;
        }
    }
    return nil;
}

//通过id得到iTunesPlaylist
-(iTunesUserPlaylist*)getPlaylistByID:(int)playlistID {
    iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
    if (librarySource == nil) {
        return nil;
    }
    SBElementArray *userplaylists = [librarySource userPlaylists];
    NSArray *upl = [userplaylists get];
    for (iTunesUserPlaylist *item in upl) {
        if (playlistID == item.id) {
            return item;
        }
    }
    return nil;
}

// 得到所有的Track对象
- (NSArray*)getAllTracks {
    iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
    if (librarySource == nil) {
        return nil;
    }
    NSMutableArray *tracksArray = [[NSMutableArray alloc] init];
    SBElementArray *playlists = [librarySource libraryPlaylists];
    NSArray *lpls = [playlists get];
    for (iTunesLibraryPlaylist *item in lpls) {
        SBElementArray *tracks =[item fileTracks];
        NSArray *trackArray = [tracks get];
        for (iTunesFileTrack *track in trackArray) {
            [tracksArray addObject:track];
        }
        tracks = [item URLTracks];
        trackArray = [tracks get];
        for (iTunesURLTrack *track in trackArray) {
            [tracksArray addObject:track];
        }
        tracks = [item sharedTracks];
        trackArray = [tracks get];
        for (iTunesSharedTrack *track in trackArray) {
            [tracksArray addObject:track];
        }
    }
    [tracksArray autorelease];
    return tracksArray;
}

/*暂时不要，后面添加IMBTrack再加上
// 检查Track是否存在于iTunes中
- (iTunesTrack*)checkTrackExsit:(IMBTrack*)track itunesTracks:(NSArray*)itunesTracks {
    iTunesTrack *itrack =nil;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        BOOL resut = NO;
        iTunesTrack *itrack = (iTunesTrack*)evaluatedObject;
        if ([[itrack name] isEqualToString:[track title]] &&
            [[itrack album] isEqualToString:[track album]] &&
            [[itrack artist] isEqualToString:[track artist]] &&
            [itrack size] == track.fileSize  ) {
            resut = YES;
        } else {
            resut = NO;
        }
        return resut;
    }];
    NSArray *filteredArr = [itunesTracks filteredArrayUsingPredicate:pre];
    if (filteredArr != nil && [filteredArr count] > 0) {
        itrack = [filteredArr objectAtIndex:0];
    }
    return itrack;
}
*/
 
// 得到的是所有的Playlists
- (NSArray*)getAllPlaylists {
    iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
    if (librarySource == nil) {
        return nil;
    }
    NSMutableArray *allPlaylists = [[NSMutableArray alloc] init];
    SBElementArray *userplaylists = [librarySource playlists];
    NSArray *upl = [userplaylists get];
    for (iTunesUserPlaylist *item in upl) {
        IMBiTunesPlaylistInfo *plInfo = [[IMBiTunesPlaylistInfo alloc] init];
        plInfo.playlistName = [item name];
        plInfo.playlistID = [item id];
        [allPlaylists addObject:plInfo];
        [plInfo release];
    }
    [allPlaylists autorelease];
    return allPlaylists;
}

// 得到的是不可以编辑的Playlists
- (NSArray*)getSmartPlaylists {
    iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
    if (librarySource == nil) {
        return nil;
    }
    NSMutableArray *smartPlaylists = [[NSMutableArray alloc] init];
    SBElementArray *userplaylists = [librarySource userPlaylists];
    NSArray *upl = [userplaylists get];
    for (iTunesUserPlaylist *item in upl) {
        if ([item smart]){
            [smartPlaylists addObject:item];
        }
    }
    [smartPlaylists autorelease];
    return smartPlaylists;
}

// 得到的是用户自定义的Playlists
- (NSArray*)getCustomPlaylists {
    iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
    if (librarySource == nil) {
        return nil;
    }
    NSMutableArray *customPlaylists = [[NSMutableArray alloc] init];
    SBElementArray *userplaylists = [librarySource userPlaylists];
    NSArray *upl = [userplaylists get];
    for (iTunesUserPlaylist *item in upl) {
        if (![item smart]){
            [customPlaylists addObject:item];
        }
    }
    [customPlaylists autorelease];
    return customPlaylists;
}



// Tracks包含了iTunesFileTrack、iTunesURLTrack和iTunesSharedTrack三种Track，绑定的时候要区分不同的类对象，他们的属性不一样
- (NSArray*)getTracksByPlaylistName:(NSString*)playlistName {
    NSMutableArray *tracksArray = [[NSMutableArray alloc] init];
    NSArray *allPlaylist = [self getAllPlaylists];
    iTunesUserPlaylist *currPlaylist = nil;
    for (iTunesUserPlaylist *playlist in allPlaylist) {
        if ([[playlist name] isEqualToString:playlistName]) {
            currPlaylist = playlist;
            [currPlaylist retain];
            break;
        }
    }
    if (currPlaylist != nil) {
        SBElementArray *tracks =[currPlaylist fileTracks];
        NSArray *trackArray = [tracks get];
        for (iTunesFileTrack *track in trackArray) {
            [tracksArray addObject:track];
        }
        tracks = [currPlaylist URLTracks];
        trackArray = [tracks get];
        for (iTunesURLTrack *track in trackArray) {
            [tracksArray addObject:track];
        }
        tracks = [currPlaylist sharedTracks];
        trackArray = [tracks get];
        for (iTunesSharedTrack *track in trackArray) {
            [tracksArray addObject:track];
        }
        [currPlaylist release];
    }
    return tracksArray;
}

//导入tracks到iTunes中。
- (void)importFilesToiTunes:(NSArray*)fileInfos toPlaylist:(int)playlistID containRatingAndPlayCount:(BOOL)containRatingAndPlayCount {
    iTunesUserPlaylist *itunesPl = nil;
    if (playlistID > 0) {
        itunesPl = [self getPlaylistByID:playlistID];
    }
    //遍历导入itunes文件的曲目信息
    for (IMBiTunesImportFileInfo *fileInfo in fileInfos) {
        //如果已经存在了则不导入到playlist中
        if (fileInfo.trackStatues == iTunesTrackExsit) {
            //如果文件已存在
            NSArray *result = [[itunesPl fileTracks] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"databaseID == %d",fileInfo.trackiTunesID]];
            if (result.count > 0) {
                continue;
            }
        }
        
        iTunesTrack *track = [iTunesApp add:[NSArray arrayWithObjects:fileInfo.itunesFileUrl, nil] to:itunesPl];
        if (track != nil) {
            if (containRatingAndPlayCount) {
                [track setPlayedCount:[fileInfo playedCount]];
                [track setRating:[fileInfo rating]];
            }
            [fileInfo setItunesFileUrl:[(iTunesFileTrack*)track location]];
            if (fileInfo.trackStatues != iTunesTrackExsit) {
                [fileInfo setTrackStatues:iTunesTrackAddSuccess];
            }

        } else {
            [fileInfo setTrackStatues:iTunesTrackAddFailed];
        }
        //Todo这个地方需要删除吗
        if ([fm fileExistsAtPath:[fileInfo desFilePath]]) {
            [fm removeItemAtPath:[fileInfo desFilePath] error:nil];
        }

    }
}

// 导入单元数量的文件到iTunes中去
- (int)importFilesToiTunes:(NSArray*)unitFiles containRatingAndPlayCount:(BOOL)containRatingAndPlayCount withDelegate:(id)delegate {
    int successCount = 0;
    for (id item in unitFiles) {
        if ([item isKindOfClass:[IMBiTunesImportFileInfo class]]) {
            [logHandle writeInfoLog:@"import files To iTunes."];
            IMBiTunesImportFileInfo *fileItem = (IMBiTunesImportFileInfo*)item;
            [delegate sendItemProgressToView:fileItem.trackName];
            NSURL *fileUrl = [NSURL fileURLWithPath:[fileItem desFilePath]];
            if (fileItem.isNeedCopy) {
                [logHandle writeInfoLog:@"add files to iTunesApp"];
                iTunesTrack *track = [iTunesApp add:[NSArray arrayWithObjects:fileUrl, nil] to:nil];
                if (track != nil) {
                    [logHandle writeInfoLog:@"add files success to iTunesApp"];
                    if (containRatingAndPlayCount) {
                        [track setPlayedCount:[fileItem playedCount]];
                        [track setRating:[fileItem rating]];
                    }
                    
                    if (([track.artist isEqualToString:@""]||track.artist == nil)) {
                        [track setArtist:fileItem.artist];
                    }
                    
                    if (([track.album isEqualToString:@""]||track.album == nil)) {
                        [track setAlbum:fileItem.album];
                    }
                    //track.album
                    [fileItem setItunesFileUrl:[(iTunesFileTrack*)track location]];
                    [fileItem setTrackStatues:iTunesTrackAddSuccess];
                    
                    // 依次加入到iTunes中的Playlist中去
                    if (fileItem.playlistArray != nil && fileItem.playlistArray.count > 0) {
                        for (IMBiTunesPlaylistInfo *plInfo in fileItem.playlistArray) {
                            iTunesUserPlaylist *itunesPl = nil;
                            if (plInfo.iTunesPlaylistID > 0) {
                                itunesPl = [self getPlaylistByID:plInfo.iTunesPlaylistID];
                                if (itunesPl != nil) {
                                    [iTunesApp add:[NSArray arrayWithObjects:[fileItem itunesFileUrl], nil] to:itunesPl];
                                }
                            }
                        }
                    }
                    //sleep(3);
                    successCount ++;
                } else {
                    [logHandle writeInfoLog:@"add failed to iTunesApp"];
                    [fileItem setTrackStatues:iTunesTrackAddFailed];
                }
                //判断itunes是否是自动导入到媒体库，如果是则删除导出的临时文件
                if (![fileUrl isEqual:fileItem.itunesFileUrl]) {
                    if ([fm fileExistsAtPath:[fileItem desFilePath]]) {
                        [fm removeItemAtPath:[fileItem desFilePath] error:nil];
                    }
                }
            } else if (fileItem.trackStatues != DeviceFileNotExsit) {
                [logHandle writeInfoLog:@"add files to iTunesApp playlist"];
                if (fileItem.playlistArray != nil && fileItem.playlistArray.count > 0) {
                    for (IMBiTunesPlaylistInfo *plInfo in fileItem.playlistArray) {
                        iTunesUserPlaylist *itunesPl = nil;
                        if (plInfo.iTunesPlaylistID > 0) {
                            itunesPl = [self getPlaylistByID:(int)plInfo.iTunesPlaylistID];
                            if (itunesPl != nil) {
                                BOOL isExsit = NO;
                                NSArray *ifTrackArray = [[itunesPl fileTracks] get];
                                if (ifTrackArray != nil && ifTrackArray.count > 0) {
                                    for (iTunesFileTrack *ift in ifTrackArray) {
                                        if (ift.databaseID == fileItem.trackiTunesID) {
                                            isExsit = YES;
                                            break;
                                        }
                                    }
                                }
                                if (!isExsit) {
                                    [iTunesApp add:[NSArray arrayWithObjects:[fileItem itunesFileUrl], nil] to:itunesPl];
                                    successCount ++;
                                }
                            }
                        }
                    }
                }
            }
        } else if ([item isKindOfClass:[IMBiTunesImportAppInfo class]]) {
            [logHandle writeInfoLog:@"import app To iTunes."];
            IMBiTunesImportAppInfo *appItem = (IMBiTunesImportAppInfo*)item;
            [delegate sendItemProgressToView:appItem.appName];
            NSURL *fileUrl = [NSURL fileURLWithPath:[appItem desFilePath]];
            if (appItem.isNeedCopy) {
                [logHandle writeInfoLog:@"add app to iTunesApp"];
                
                iTunesPlaylist *playlists = [iTunesApp currentPlaylist];
                if (playlists) {
                    
                }
                iTunesTrack *track = [iTunesApp add:[NSArray arrayWithObjects:fileUrl, nil] to:nil];
                if (track != nil) {
                    [logHandle writeInfoLog:@"add app success to iTunesApp"];
                    [appItem setItunesFileUrl:[(iTunesFileTrack*)track location]];
                    [appItem setTrackStatues:iTunesTrackAddSuccess];
                    successCount ++;
                } else {
                    [logHandle writeInfoLog:@"add app failed to iTunesApp"];
                    [appItem setTrackStatues:iTunesTrackAddFailed];
                }
                
                if (![fileUrl isEqual:appItem.itunesFileUrl]) {
                    if ([fm fileExistsAtPath:[appItem desFilePath]]) {
                        [fm removeItemAtPath:[appItem desFilePath] error:nil];
                    }
                }
            }
        } else if([item isKindOfClass:[IMBiBookImportItemInfo class]]) {
            [logHandle writeInfoLog:@"import book To iTunes."];
            IMBiBookImportItemInfo *fileItem = (IMBiBookImportItemInfo*)item;
            [delegate sendItemProgressToView:fileItem.bookName];
            NSURL *fileUrl = [NSURL fileURLWithPath:[fileItem desFilePath]];
            if (fileItem.isNeedCopy) {
                [logHandle writeInfoLog:@"add book to iTunesApp"];
                iTunesTrack *track = [iTunesApp add:[NSArray arrayWithObjects:fileUrl, nil] to:nil];
                if (track != nil) {
                    [logHandle writeInfoLog:@"add book success to iTunesApp"];
                    [fileItem setItunesFileUrl:[(iTunesFileTrack*)track location]];
                    [fileItem setTrackStatues:iTunesTrackAddSuccess];
                    successCount ++;
                } else {
                    [logHandle writeInfoLog:@"add book failed to iTunesApp"];
                    [fileItem setTrackStatues:iTunesTrackAddFailed];
                }
                //判断itunes是否是自动导入到媒体库，如果是则删除导出的临时文件
                if (![fileUrl isEqual:fileItem.itunesFileUrl]) {
                    if ([fm fileExistsAtPath:[fileItem desFilePath]]) {
                        [fm removeItemAtPath:[fileItem desFilePath] error:nil];
                    }
                }
            }
        } else {
            // Other class
        }
//        sleep(3);
    }
    return successCount;
}

// 导入Playlist到iTunes中---file数组中存放的是IMBImportFileInfo对象
- (void)importPlaylistToiTunes:(NSArray*)playlists files:(NSArray*)files {
    //取得当前iTunes中的对象
    //NSArray *playlistArr = [[self getAllPlaylists] retain];
    NSArray *playlistArr = [self getAllPlaylists];
    
    
    NSMutableArray *fileForPl = [[NSMutableArray alloc] init];
    NSMutableArray *validFileForPl = [[NSMutableArray alloc] init];
    iTunesUserPlaylist *currPlaylist = nil;
    
    //遍历所有需要处理的Playlist信息的对象
    for (IMBiTunesPlaylistInfo *plInfo in playlistArr) {
        //清理上一次Playlist中包含Track的URL
        if (fileForPl != nil && [fileForPl count] > 0) {
            [fileForPl removeAllObjects];
        }
        if (validFileForPl != nil && [validFileForPl count] > 0) {
            [validFileForPl removeAllObjects];
        }
        
        //取得playlistInfo描述信息中的所有iTunesTrack对象的URL地址
        for (IMBiTunesImportFileInfo *ifile in files) {
            if ([[plInfo items] containsObject:[NSNumber numberWithInt:[ifile trackID]]]) {
                [fileForPl addObject:[ifile itunesFileUrl]];
            }
        }
        
        if (fileForPl != nil && [fileForPl count] > 0) {
            //查询出iTunes中对应该Playlist的Playlist对象
            NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                BOOL result = NO;
                iTunesUserPlaylist *playlist = (iTunesUserPlaylist*)evaluatedObject;
                result = ([[playlist name] isEqualToString:[plInfo playlistName]] && [playlist smart] == NO);
                return result;
            }];
            NSArray *perArr = [playlistArr filteredArrayUsingPredicate:pre];
            
            // 对该Playlist进行检查，以排出同一个Track多次导入的情况
            if (perArr != nil && [perArr count] > 0) {
                currPlaylist = [perArr objectAtIndex:0];
                //查询出并未在该Palylist中存在的Track的URL
                SBElementArray *tracks =[currPlaylist fileTracks];
                NSArray *trackArray = [tracks get];
                NSString *urlPath = nil;
                for (IMBiTunesImportFileInfo *ifi in fileForPl) {
                    urlPath = [[[ifi itunesFileUrl] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    BOOL isExsit = NO;
                    NSString *tPath = nil;
                    for (iTunesFileTrack *track in trackArray) {
                        tPath = [[[track location] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        if ([urlPath isEqualToString:tPath]) {
                            isExsit = YES;
                            break;
                        }
                    }
                    if (!isExsit) {
                        [validFileForPl addObject:[ifi itunesFileUrl]];
                    }
                }
            } else {
                for (IMBiTunesImportFileInfo *ifi in files) {
                    [validFileForPl addObject:[ifi itunesFileUrl]];
                }
            }
        } else {
            NSLog(@"%@ can't contain track", [plInfo playlistName]);
        }
        //对单个的Playlist进行导入操作
        plInfo.playlistStatues = [self createPlaylistAndAddTrack:[plInfo playlistName] filesUrl:validFileForPl];
    }
    [fileForPl release];
    [validFileForPl release];
    [playlistArr release];
}

// 创建Playlist并且将Track导入到Playlist中去
- (iTunesPSts)createPlaylistAndAddTrack:(NSString*)playlistName filesUrl:(NSArray*)filesUrl {
    iTunesPSts result = iTunesPlaylistAddFailed;
    //得到用户非smart的Playlist对象
    iTunesUserPlaylist *userPlaylist = [self getCustomPlaylistByName:playlistName];
    if (userPlaylist == nil) {
        userPlaylist = [self createPlaylistByName:playlistName];
        if (userPlaylist != nil) {
            result = iTunesPlaylistAddSuccess;
        } else {
            result = iTunesPlaylistAddFailed;
        }
    } else {
        result = iTunesPlaylistExsit;
    }
    if (userPlaylist != nil) {
        if (filesUrl != nil && [filesUrl count] > 0) {
            [iTunesApp add:filesUrl to:userPlaylist];
        }
    }
    return result;
}

// 根据Playlist Name取得用户自定义的Playlist对象，如果没有取到就为nil了
- (iTunesUserPlaylist*)getCustomPlaylistByName:(NSString*)playlistName {
    iTunesUserPlaylist *userPlayList = nil;
    
    IMBiTLPlaylist *playlist = [self getPlaylistByName:playlistName];
    userPlayList = (iTunesUserPlaylist *)playlist;
    if (![userPlayList smart]) {
        return userPlayList;
    }
    return nil;
}

// 根据名称创建Playlist对象,返回playlistID
- (int)createPlaylistByName:(NSString*)playlistName {
    iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
    if (librarySource == nil) {
        return -1;
    }
    
    SBElementArray *userplaylists = [librarySource userPlaylists];
    if (userplaylists != nil) {
        iTunesUserPlaylist *playlist = [[[iTunesApp classForScriptingClass:@"playlist"] alloc] init];
        [userplaylists addObject:playlist];
        [playlist setName:playlistName];
        return (int)playlist.id;
    }
    return 0;
}


/*
// 根据名称创建Playlist对象
- (iTunesUserPlaylist*)createPlaylistByName:(NSString*)playlistName {
    NSArray *plArray = [[self getPlaylistByName:playlistName] retain];
    iTunesUserPlaylist *playlist = nil;
    if (plArray == nil) {
        SBElementArray *userplaylists = [[self getLibrarySource:iTunesESrcLibrary] userPlaylists];
        if (userplaylists != nil) {
            playlist = [[[iTunesApp classForScriptingClass:@"playlist"] alloc] init];
            [userplaylists addObject:playlist];
            [playlist setName:playlistName];
        }
    } else {
        BOOL isSmart = YES;
        for (iTunesUserPlaylist *item in plArray) {
            if (![item smart]) {
                isSmart = NO;
                break;
            }
        }
        //如果查询出来的Playlist是smart的Playlist
        if (isSmart) {
            SBElementArray *userplaylists = [[self getLibrarySource:iTunesESrcLibrary] userPlaylists];
            if (userplaylists != nil) {
                playlist = [[[iTunesApp classForScriptingClass:@"playlist"] alloc] init];
                [userplaylists addObject:playlist];
                [playlist setName:playlistName];
            }
        }
    }
    return playlist;
}
*/

/*
// 根据名称去获取Playlist对象
- (NSArray*)getPlaylistByName:(NSString*)playlistName {
    NSMutableArray *plArray = [[NSMutableArray alloc] init];
    NSArray *allPlaylist = [self getAllPlaylists];
    for (iTunesUserPlaylist *item in allPlaylist) {
        if ([[item name] isEqualToString:playlistName]) {
            [plArray addObject:item];
        }
    }
    [plArray autorelease];
    return plArray;
}
*/

- (BOOL) parserLibrary {
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(appDidLaunch:) name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    @try {
        return [self parserLibraryPrivate];
    }
    @catch (NSException *exception) {
        [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary exception %@", exception.reason]];
        return FALSE;
    }

}
- (BOOL) parserLibraryPrivate {
    [logHandle writeInfoLog:@"Before parserLibrary"];
    _isLibraryParsed = FALSE;
    //1.先释放以前的playlistist，track等东东。
    if (iTLPlaylists != nil && iTLPlaylists.count > 0) {
        [iTLPlaylists removeAllObjects];
    }
    if (iTLTracks != nil && iTLTracks.count > 0) {
        [iTLTracks removeAllObjects];
    }
    
    //2.读入playlists，并且把track添加到playlists中
    iTunesSource *librarySource = [self getLibrarySource:iTunesESrcLibrary];
    if (librarySource != nil) {
        SBElementArray *allPlaylists = [librarySource playlists];
        NSArray *apl = [allPlaylists get];
        for (iTunesUserPlaylist *item in apl) {
            IMBiTLPlaylist *iTLPlaylist = [[IMBiTLPlaylist alloc] init];
            iTLPlaylist.playlistID = (int)item.id;
            iTLPlaylist.playlistPersistentID = item.persistentID;
            iTLPlaylist.name = item.name;
            //iTLPlaylist.isSmartPlaylist = item.smart;
            iTLPlaylist.isVisible = item.visible;
            if (item.tracks != nil && item.tracks.count > 0) {
                for (iTunesTrack *track in item.tracks) {
                    [iTLPlaylist.playlistTrackIds addObject:[NSNumber numberWithInteger:track.databaseID]];
                    
                    /*
                     NSLog(@"Before NSPredicate.");
                     NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBiTLTrack* evaluatedObject, NSDictionary *bindings) {
                     BOOL result = NO;
                     result = (evaluatedObject.databaseID == track.databaseID);
                     return result;
                     }];
                     NSArray *resArray = [iTLTracks filteredArrayUsingPredicate:pre];
                     NSLog(@"After NSPredicate.");
                     if (resArray != nil && resArray.count > 0) {
                     [iTLPlaylist.playlistItems addObject:[resArray objectAtIndex:0]];
                     }
                     //NSLog(@"iTLPlaylist.playlistItems count %d",[iTLPlaylist.playlistItems count]);
                     */
                }
            }
            if (![iTLPlaylist.name isEqualToString:@"Genius"]) {
                [iTLPlaylists addObject:iTLPlaylist];
            }
            [iTLPlaylist release];
            
        }
        //playlist的件数
        [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary iTLPlaylist count %lu", (unsigned long)iTLPlaylists.count]];
    }
    
    //3.playlist中的部分内容从xml读取入。
    NSURL *libraryURL;
    NSString *normalLibraryPath = [@"~/Music/iTunes/iTunes Music Library.xml" stringByExpandingTildeInPath];
    NSString *olderLibraryPath = [@"~/Documents/iTunes/iTunes Music Library.xml" stringByExpandingTildeInPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:normalLibraryPath]) {
        libraryURL = [self resolvedFileURLWithPath:normalLibraryPath];
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:olderLibraryPath]) {
        libraryURL = [self resolvedFileURLWithPath:olderLibraryPath];
    } else {
        libraryURL = nil;
    }
    
    if (libraryURL != nil) { // If an iTunes Library was found
        //libraryURL
        [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary libraryURL %@", libraryURL.path]];
        NSDictionary *libraryDictionary = [NSDictionary dictionaryWithContentsOfURL:libraryURL];
        NSArray *xmlPlaylists = [libraryDictionary objectForKey:@"Playlists"];
        if (xmlPlaylists != nil && xmlPlaylists.count > 0) {
            for (NSDictionary* playlistDic in xmlPlaylists) {
                
                if ([playlistDic objectForKey:@"Playlist ID"] != nil) {
                    NSString *playlistPID = [playlistDic objectForKey:@"Playlist Persistent ID"];
                    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBiTLPlaylist* evaluatedObject, NSDictionary *bindings) {
                        BOOL result = NO;
                        result = ([evaluatedObject.playlistPersistentID isEqualToString: playlistPID]);
                        return result;
                    }];
                    NSArray *resArray = [iTLPlaylists filteredArrayUsingPredicate:pre];
                    if (resArray != nil && resArray.count > 0) {
                        IMBiTLPlaylist *p = [resArray objectAtIndex:0];
                        if([playlistDic objectForKey:@"Master"] != nil){
                            bool isMaster = [(NSNumber*)[playlistDic objectForKey:@"Master"] boolValue];
                            p.isMaster = isMaster;
                        }
                        
                        if([playlistDic objectForKey:@"Distinguished Kind"] != nil){
                            int disKind = [(NSNumber*)[playlistDic objectForKey:@"Distinguished Kind"] intValue];
                            p.distinguishedKindId = disKind;
                        }
                        
                        if([playlistDic objectForKey:@"Smart Info"] != nil){
                            p.isSmartPlaylist = true;
                        }
                    }
                }
            }
        }
    }
    //libraryURL
    [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary after read xml "]];
    //4.先读入tracks,把itunes的track转换为IMBiTLTrack,再导入到playlist中。
    if (librarySource != nil) {
        SBElementArray *sbeArrays = [librarySource libraryPlaylists];
        NSArray *lpls = [sbeArrays get];
        for (iTunesLibraryPlaylist *item in lpls) {
            SBElementArray *tracks =[item fileTracks];
            NSArray *trackArray = [tracks get];
            for (iTunesFileTrack *track in trackArray) {
                IMBiTLTrack *atrack = [[IMBiTLTrack alloc] init];
                atrack.trackKind = iTLTrackKind_FileTrack;
                atrack.location = [track location];
                //判断文件存在与否
                if ([[NSFileManager defaultManager] fileExistsAtPath:atrack.location.path]) {
                    atrack.fileIsExist = TRUE;
                } else {
                    atrack.fileIsExist = FALSE;
                }
                [self parseriTLTrack:track WithiTlTrack:atrack];
                [self addiTLTrackToPlaylist:atrack];
                [iTLTracks addObject:atrack];
                [atrack release];
            }
            tracks = [item URLTracks];
            trackArray = [tracks get];
            for (iTunesURLTrack *track in trackArray) {
                IMBiTLTrack *atrack = [[IMBiTLTrack alloc] init];
                atrack.trackKind = iTLTrackKind_URLTrack;
                atrack.address = [track address];
                [self parseriTLTrack:track WithiTlTrack:atrack];
                [self addiTLTrackToPlaylist:atrack];
                [iTLTracks addObject:atrack];
                [atrack release];
            }
            tracks = [item sharedTracks];
            trackArray = [tracks get];
            for (iTunesSharedTrack *track in trackArray) {
                IMBiTLTrack *atrack = [[IMBiTLTrack alloc] init];
                atrack.trackKind = iTLTrackKind_SharedTrack;
                [self parseriTLTrack:track WithiTlTrack:atrack];
                [self addiTLTrackToPlaylist:atrack];
                [iTLTracks addObject:atrack];
                [atrack release];
            }
            //[atrack release];
        }
    }
   
    //track
    [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary iTLTracks count %lu",(unsigned long)iTLTracks.count]];
    
    //5.把book拆分为audiobook与ibook
    if (iTLPlaylists != nil) {
        NSArray *categoryPlaylists = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"distinguishedKindId == %d",iTunes_Books]];
        if([[self getiTunesVersion] isVersionMajorEqual:@"12.5"]){//iTunes具体取消book,改为audiobook的版本大概在12.5，具体的版本不确定
            if ([categoryPlaylists count]>0) {
                IMBiTLPlaylist *bookPlayst = [categoryPlaylists objectAtIndex:0];
                bookPlayst.distinguishedKindId = iTunes_Audiobook;
                bookPlayst.iTunesType = iTunes_Audiobook;
            }
        }else {
            if (categoryPlaylists.count > 0) {
               IMBiTLPlaylist *bookPlayst = [categoryPlaylists objectAtIndex:0];
                if (bookPlayst.playlistItems != nil && bookPlayst.playlistItems.count > 0) {
                    NSArray *audioBookArray = [bookPlayst.playlistItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"iTunesMediaType == %d",iTunesMedia_Audiobook]];
                    if (audioBookArray.count > 0) {
                        IMBiTLPlaylist *abPlaylist = [[IMBiTLPlaylist alloc] init];
                        //TODO 多语言
                        abPlaylist.name = CustomLocalizedString(@"MenuItem_id_3", nil);
                        abPlaylist.distinguishedKindId = iTunes_Audiobook;
                        abPlaylist.iTunesType = iTunes_Audiobook;
                        [abPlaylist.playlistItems addObjectsFromArray:audioBookArray];
                        [bookPlayst.playlistItems removeObjectsInArray:audioBookArray];
                        [iTLPlaylists addObject:abPlaylist];
                        [abPlaylist release];
                    }
                }
            }
            //track
            [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary after create audiobook playlist"]];
        }
        
        //6.添加App
        //得到App的目录
        NSURL *AppURL;
        NSString *normalAppPath = [@"~/Music/iTunes/iTunes Media/Mobile Applications" stringByExpandingTildeInPath];
        NSString *olderAppPath = [@"~/Documents/iTunes Media/Mobile Applications" stringByExpandingTildeInPath];
        if ([fm fileExistsAtPath:normalAppPath]) {
            AppURL = [self resolvedFileURLWithPath:normalAppPath];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:olderAppPath]) {
            AppURL = [self resolvedFileURLWithPath:olderAppPath];
        } else {
            AppURL = nil;
        }
        
        if (AppURL != nil) {
            NSArray *appArray = [fm contentsOfDirectoryAtPath:AppURL.path error:nil];
            if (appArray != nil && [appArray count] > 0) {
                //创建AppArray
                IMBiTLPlaylist *appPlaylist = [[IMBiTLPlaylist alloc] init];
                appPlaylist.name = CustomLocalizedString(@"MenuItem_id_14", nil);
                appPlaylist.distinguishedKindId = iTunes_Apps;
                appPlaylist.iTunesType = iTunes_Apps;
                
                NSString *temPath = @"";
                for (NSString *item in appArray) {
                    temPath = [AppURL.path stringByAppendingPathComponent:item];
                    NSString *extension = [temPath pathExtension];
                    if ([extension containsString:@"ipa" options:NSCaseInsensitiveSearch] ||
                        [extension containsString:@"ipx" options:NSCaseInsensitiveSearch]
                        ) {
                        IMBiTLTrack *itlTrack = [self getAppInfoFromLocal:temPath];
                        if (itlTrack != nil) {
                            [appPlaylist.playlistItems addObject:itlTrack];
                        }
                    }
                }
                [iTLPlaylists addObject:appPlaylist];
                [appPlaylist release];
            }
        }
        //app
        [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary after create app playlist"]];
        
        //7.添加Ringtone
        NSURL *rtURL;
        NSString *normalRtPath = [@"~/Music/iTunes/iTunes Media/Tones" stringByExpandingTildeInPath];
        NSString *olderRtPath = [@"~/Documents/iTunes Media/Tones" stringByExpandingTildeInPath];
        if ([fm fileExistsAtPath:normalRtPath]) {
            rtURL = [self resolvedFileURLWithPath:normalRtPath];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:olderRtPath]) {
            rtURL = [self resolvedFileURLWithPath:olderRtPath];
        } else {
            rtURL = nil;
        }
        
        if (rtURL != nil) {
            NSArray *rtArray = [fm contentsOfDirectoryAtPath:rtURL.path error:nil];
            if (rtArray != nil && [rtArray count] > 0) {
                //创建ringtone playlist
                IMBiTLPlaylist *rtPlaylist = [[IMBiTLPlaylist alloc] init];
                //TODO 多语言
                rtPlaylist.name = CustomLocalizedString(@"MenuItem_id_2", nil);
                rtPlaylist.distinguishedKindId = iTunes_Ring;
                rtPlaylist.iTunesType = iTunes_Ring;
                
                NSString *temPath = @"";
                for (NSString *item in rtArray) {
                    temPath = [rtURL.path stringByAppendingPathComponent:item];
                    
                    //NSArray *track = [iTunesApp convert:[NSArray arrayWithObjects:[NSURL fileURLWithPath:temPath], nil]];
                    //NSLog(@"track %@:", track.description);
                    //iTunesTrack *track = [iTunesApp add:[NSArray arrayWithObjects:[NSURL fileURLWithPath:temPath], nil] to:nil];
                    //if (track != nil) {
                        IMBiTLTrack *atrack = [[IMBiTLTrack alloc] init];
                        atrack.trackKind = iTLTrackKind_FileTrack;
                        atrack.location = [NSURL fileURLWithPath:temPath];
                        atrack.fileIsExist = TRUE;
                        atrack.name = [[temPath lastPathComponent] stringByDeletingPathExtension];
                        atrack.size = [[fm attributesOfItemAtPath:temPath error:nil] fileSize];
                        //[self parseriTLTrack:track WithiTlTrack:atrack];
                        atrack.iTunesMediaType = iTunesMedia_Ringtone;
                        //获取Ringtone的时间
                        IMBMediaInfo *mediainfo = [IMBMediaInfo singleton];
                        [mediainfo openWithFilePath:temPath];
                        atrack.duration = [mediainfo.length doubleValue]/1000;
                        [iTLTracks addObject:atrack];
                        [rtPlaylist.playlistItems addObject:atrack ];
                        [iTLTracks addObject:atrack];
                        [atrack release];
                    //}
                }
                [iTLPlaylists addObject:rtPlaylist];
                [rtPlaylist release];
            }
        }
        //rongtone
        [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary after create ringtone playlist"]];
        
        //8.移除master中的所有非媒体信息，如ibook,app,ringtone
        NSArray *masterPlaylists = [iTLPlaylists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMaster == true"]];
        if (categoryPlaylists.count > 0) {
            IMBiTLPlaylist *mpl = [masterPlaylists objectAtIndex:0];
            if (mpl.playlistItems != nil && mpl.playlistItems.count > 0) {
                
                NSArray *distinguishedArray = [[NSArray alloc] initWithObjects:
                                               [NSNumber numberWithInt:(int)iTunesMedia_PDFBooks],
                                               [NSNumber numberWithInt:(int)iTunesMedia_Books],
                                               [NSNumber numberWithInt:(int)iTunesMedia_Ringtone],
                                               nil];
                NSArray *deleteTrackArray = [mpl.playlistItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"iTunesMediaType in %@",distinguishedArray]];
                if (deleteTrackArray.count > 0) {
                    [mpl.playlistItems removeObjectsInArray:deleteTrackArray];
                }
            }
        }
        //rongtone
        [logHandle writeInfoLog:[NSString stringWithFormat:@"iTunes parserLibrary after create remove some media"]];
    }
    
    
    for (IMBiTLPlaylist *list in iTLPlaylists) {
        NSLog(@"****************%@,%d",list.name,list.distinguishedKindId);
    }
    
    _isLibraryParsed = TRUE;
    [logHandle writeInfoLog:@"End parserLibrary"];
    return true;
}


- (IMBiTLTrack*) getAppInfoFromLocal:(NSString*)filepath {
    if ([fm fileExistsAtPath:filepath]) {
        IMBiTLTrack *appInfo = [[[IMBiTLTrack alloc] init] autorelease];
        appInfo.location = [NSURL fileURLWithPath:filepath];
        appInfo.fileIsExist = true;
        appInfo.size = [[fm attributesOfItemAtPath:filepath error:nil] fileSize];
        
        NSString *metaFolderPath = [TempHelper getAppTempPath];
        NSString *metaPlistPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"/iTunesMetadata.plist"];
        
        [IMBZipHelper unzipByFile:filepath filePath:@"iTunesMetadata.plist" decFolderPath:metaFolderPath];
        if ([fm fileExistsAtPath:metaPlistPath]) {
            NSDictionary *metaDic = [[NSDictionary alloc] initWithContentsOfFile:metaPlistPath];
            //TODO 这个地方MinOS的版本号读不了。可能通过导入设备来。
            if (metaDic != nil) {
                /*
                if ([metaDic objectForKey:@"softwareVersionBundleId"] != nil) {
                    appInfo.appKey = [metaDic objectForKey:@"softwareVersionBundleId"];
                }
                */
                if ([metaDic objectForKey:@"itemName"]!= nil) {
                    appInfo.name = [metaDic objectForKey:@"itemName"];
                } else if ([metaDic objectForKey:@"playlistName"] != nil) {
                    appInfo.name = [metaDic objectForKey:@"playlistName"];
                } 
                if ([metaDic objectForKey:@"softwareVersionBundleId"] != nil) {
                    [appInfo setPersistentID:[metaDic objectForKey:@"softwareVersionBundleId"]];
                } else {
                    [appInfo setPersistentID:@""];
                }
                /*
                if ([metaDic objectForKey:@"bundleShortVersionString"] != nil) {
                    appInfo.version = [metaDic objectForKey:@"bundleShortVersionString"];
                } else if ([metaDic objectForKey:@"bundleVersion"] != nil) {
                    appInfo.version = [metaDic objectForKey:@"bundleVersion"];
                }
                */
                
                /*
                 if ([metaDic objectForKey:@"softwareSupportedDeviceIds"] != nil) {
                 NSArray *familyArray = [metaDic objectForKey:@"softwareSupportedDeviceIds"];
                 bool isSptiPhone = [familyArray containsObject:[NSNumber numberWithInt:1]];
                 bool isSptiPad = [familyArray containsObject:[NSNumber numberWithInt:2]];
                 bool isSptiAll = [familyArray containsObject:[NSNumber numberWithInt:9]];
                 if (isSptiAll == true) {
                 appInfo.uiDeviceFamily = AppUIDeviceFamily_All;
                 } else
                 if (isSptiPhone && isSptiPad) {
                 appInfo.uiDeviceFamily = AppUIDeviceFamily_All;
                 } else if (isSptiPhone == false &&  isSptiPad == true) {
                 appInfo.uiDeviceFamily = AppUIDeivceFamily_iPad;
                 } else {
                 appInfo.uiDeviceFamily = AppUIDeivceFamily_iPhone;
                 }
                 }
                 */
            }
        }
        return appInfo;
        
    }
    return nil;
}

- (void) addiTLTrackToPlaylist:(IMBiTLTrack*)atrack {
    //1.得到Playlist，并且把track添加到playlist中
    for (IMBiTLPlaylist *playlist in iTLPlaylists) {
        if (playlist.playlistTrackIds.count > 0) {
            NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSNumber *trackDBid, NSDictionary *bindings) {
                BOOL result = NO;
                result = (trackDBid.intValue == atrack.databaseID);
                return result;
            }];
            NSArray *resArray = [playlist.playlistTrackIds filteredArrayUsingPredicate:pre];
            if (resArray != nil && resArray.count > 0) {
                //这里编辑媒体文件类型
                [self setTrackMediaType:atrack WithPlaylist:playlist];
                [playlist.playlistItems addObject:atrack];
            }
        }
    }
}

- (void) setTrackMediaType:(IMBiTLTrack*)itlTrack WithPlaylist:(IMBiTLPlaylist*)playlist {
    if (playlist != nil) {
        switch (playlist.distinguishedKindId) {
            case (int)iTunes_Music:
                
                if (itlTrack.isMusicVideo) {
                    itlTrack.iTunesMediaType = iTunesMedia_MusicVideo;
                } else {
                    itlTrack.iTunesMediaType = iTunesMedia_Audio;
                }
                break;
            case (int)iTunes_Movie:
                itlTrack.iTunesMediaType = iTunesMedia_Video;
                break;
            case (int)iTunes_TVShow:
                itlTrack.iTunesMediaType = iTunesMedia_TVShow;
                break;
            case (int)iTunes_iTunesU:
                itlTrack.iTunesMediaType = iTunesMedia_iTunesU;
                break;
            case (int)iTunes_Podcast:
                itlTrack.iTunesMediaType = iTunesMedia_Podcast;
                break;
            case (int)iTunes_Ring:
                itlTrack.iTunesMediaType = iTunesMedia_Ringtone;
                break;
            case (int)iTunes_VoiceMemos:
                itlTrack.iTunesMediaType = iTunesMedia_Audio;
                break;
            case (int)iTunes_Books:
                if (itlTrack.duration > 0) {
                    itlTrack.iTunesMediaType = iTunesMedia_Audiobook;
                } else {
                    itlTrack.iTunesMediaType = iTunesMedia_Books;
                }
                break;
            default:
                //itlTrack.iTunesMediaType = iTunesMedia_Audio;
                //NSLog(@"itlTrack.iTunesMediaType: Audio");
                break;
        }
    }
}




- (void) parseriTLTrack:(iTunesTrack*)aITunesTrack WithiTlTrack:(IMBiTLTrack*)iTLTrack{
    //IMBiTLTrack *iTLTrack = [[[IMBiTLTrack alloc] init] autorelease];
    //1.track的分类需要再做一下
    //2.其他地方的编辑
    
    iTLTrack.album = aITunesTrack.album;
    iTLTrack.artist = aITunesTrack.artist;
    iTLTrack.genre = aITunesTrack.genre;
    iTLTrack.dateAdded = aITunesTrack.dateAdded;
    iTLTrack.duration = aITunesTrack.duration;
    iTLTrack.rating = aITunesTrack.rating;
    iTLTrack.size = aITunesTrack.size;
    iTLTrack.playedCount = aITunesTrack.playedCount;
 //   iTLTrack.isPodcast = aITunesTrack.podcast;
    iTLTrack.kind = aITunesTrack.kind;
    iTLTrack.databaseID = aITunesTrack.databaseID;
    iTLTrack.name = aITunesTrack.name;
    iTLTrack.persistentID = aITunesTrack.persistentID;

    switch (aITunesTrack.videoKind) {
        case iTunesEVdKMovie:
            iTLTrack.isVideo = TRUE;
            iTLTrack.isMovie = TRUE;
            iTLTrack.isMusicVideo = FALSE;
            iTLTrack.isTVShow = FALSE;
            break;
        case iTunesEVdKMusicVideo:
            iTLTrack.isVideo = TRUE;
            iTLTrack.isMovie = FALSE;
            iTLTrack.isMusicVideo = TRUE;
            iTLTrack.isTVShow = FALSE;
            break;
        case iTunesEVdKTVShow:
            iTLTrack.isVideo = TRUE;
            iTLTrack.isMovie = FALSE;
            iTLTrack.isMusicVideo = FALSE;
            iTLTrack.isTVShow = FALSE;
            break;
        case iTunesEVdKNone:
        default:
            iTLTrack.isVideo = FALSE;
            iTLTrack.isMovie = FALSE;
            iTLTrack.isMusicVideo = FALSE;
            iTLTrack.isTVShow = FALSE;
            break;
    }
}

- (NSURL *) resolvedFileURLWithPath:(NSString *)path {
    
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, NO);
    NSString *resolvedPath = nil;
    
    if (url != NULL) {
        FSRef fsRef;
        if (CFURLGetFSRef(url, &fsRef)) {
            Boolean targetIsFolder, wasAliased;
            FSResolveAliasFile (&fsRef, true, &targetIsFolder, &wasAliased);
            CFURLRef resolvedUrl = CFURLCreateFromFSRef(kCFAllocatorDefault, &fsRef);
            if (resolvedUrl != NULL) {
                resolvedPath = [NSString stringWithString:
                                (NSString *)CFURLCopyFileSystemPath(resolvedUrl, kCFURLPOSIXPathStyle)];
                CFRelease(resolvedUrl);
            }
        }
        CFRelease(url);
    }
    
    if (resolvedPath != nil) {
        NSURL *resolvedURL = [NSURL fileURLWithPath:resolvedPath];
        return resolvedURL;
    }
    
    return nil;
    
}

- (NSString*)getiTunesVersion {
    NSTask *versionTask = [[NSTask alloc] init];
    versionTask.launchPath = @"/usr/bin/defaults";
    versionTask.arguments = @[@"read", @"/Applications/iTunes.app/Contents/version.plist", @"CFBundleShortVersionString"];
    NSPipe *versionPipe = [NSPipe pipe];
    [versionTask setStandardOutput:versionPipe];
    [versionTask setStandardInput:[NSPipe pipe]];
    [versionTask launch];
    NSData *versionData = [[[versionTask standardOutput] fileHandleForReading] availableData];
    NSString *version = nil;
    if (versionData != nil && versionData.length > 0) {
        version = [[[NSString alloc] initWithData:versionData encoding:NSUTF8StringEncoding] autorelease];
        if (version != nil && version.length >= 1 && [version hasSuffix:@"\n"]) {
            version = [version substringToIndex:version.length - 1];
        }
    }
    return version;
}

@end

@implementation IMBiTunesPlaylistInfo
@synthesize playlistName = _playlistName;
@synthesize playlistID = _playlistID;
@synthesize isSysPlaylist = _isSysPlaylist;
@synthesize items = _items;
@synthesize playlistStatues = _playlistStatues;
@synthesize iTunesPlaylistID = _iTunesPlaylistID;
@synthesize isExist = _isExist;

- (id)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_items != nil) {
        [_items release];
        _items = nil;
    }
    [super dealloc];
}

@end

@implementation IMBiTunesImportFileInfo
@synthesize sourceFilePath = _sourceFilePath;
@synthesize desFilePath = _desFilePath;
@synthesize itunesFileUrl = _itunesFileUrl;
@synthesize isNeedCopy = _isNeedCopy;
@synthesize trackName = _trackName;
@synthesize trackID = _trackID;
@synthesize mediaType = _mediaType;
@synthesize playedCount = _playedCount;
@synthesize rating = _rating;
@synthesize trackStatues = _trackStatues;
@synthesize trackiTunesID = _trackiTunesID;
@synthesize playlistArray = _playlistArray;
@synthesize artist = _artist;
@synthesize album = _album;
@synthesize oriName = _oriName;
- (id)init {
    self = [super init];
    if (self) {
        _isNeedCopy = NO;
        _playlistArray = [[NSMutableArray alloc] init];
        _mediaType = AudioAndVideo;
    }
    return self;
}

- (void)dealloc {
    if (_playlistArray != nil) {
        [_playlistArray release];
        _playlistArray = nil;
    }
    [super dealloc];
}

@end

@implementation IMBiBookImportItemInfo
@synthesize sourceFilePath = _sourceFilePath;
@synthesize desFilePath = _desFilePath;
@synthesize itunesFileUrl = _itunesFileUrl;
@synthesize isNeedCopy = _isNeedCopy;
@synthesize bookName = _bookName;
@synthesize extension = _extension;
@synthesize bookID = _bookID;
@synthesize mediaType = _mediaType;
@synthesize trackStatues = _trackStatues;

- (id)init {
    self = [super init];
    if (self) {
        _isNeedCopy = NO;
        _mediaType = Books;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

@implementation IMBiTunesImportAppInfo
@synthesize appKey = _appKey;
@synthesize isNeedCopy = _isNeedCopy;
@synthesize appName = _appName;
@synthesize desFilePath = _desFilePath;
@synthesize itunesFileUrl = _itunesFileUrl;
@synthesize trackStatues = _trackStatues;
@synthesize appEntity = _appEntity;

- (id)init {
    if (self = [super init]) {
        _appKey = nil;
        _isNeedCopy = NO;
        _appName = nil;
        _desFilePath = nil;
        _itunesFileUrl = nil;
        _appEntity = nil;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

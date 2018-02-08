//
//  IMBPlayCounts.m
//  iMobieTrans
//
//  Created by Pallas on 1/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBPlayCounts.h"
#import "IMBMusicDatabase.h"
#import "IMBIPod.h"
#import "IMBPlayCountHeader.h"
#import "IMBSession.h"
#import "IMBPlayCountEntry.h"
#import "IMBTrack.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"

@implementation IMBPlayCounts

- (id)initWithMusicDB:(IMBMusicDatabase*)itunesdb {
    self = [super init];
    if (self) {
        _iTunesDB = itunesdb;
        NSString *playCountsPath = [[[_iTunesDB IPod] fileSystem] playCountPath];
        NSString *localPlayCountsPath = nil;
        if ([[[_iTunesDB IPod] fileSystem] fileExistsAtPath:playCountsPath] == NO) {
            
        } else {
            if ([playCountsPath hasSuffix:@"plist"] == YES) {
                localPlayCountsPath = [[[[_iTunesDB IPod] session] sessionFolderPath] stringByAppendingPathComponent:@"PlayCounts.plist"];
                isPlist = TRUE;
            } else {
                localPlayCountsPath = [[[[_iTunesDB IPod] session] sessionFolderPath] stringByAppendingPathComponent:@"Play Counts"];
                isPlist = FALSE;
            }
            
            [[[_iTunesDB IPod] fileSystem] copyRemoteFile:playCountsPath toLocalFile:localPlayCountsPath];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:localPlayCountsPath]){
                if (isPlist == TRUE) {
                    _header = [[IMBPlayCountHeader alloc] init];
                    [_header readPlist:[_iTunesDB IPod] playCountsPath:playCountsPath];
                } else {
                    reader = [NSData dataWithContentsOfFile:localPlayCountsPath];
                    if ([reader length] < 16) {
                        reader = nil;
                    } else {
                        _header = [[IMBPlayCountHeader alloc] init];
                        [_header read:[_iTunesDB IPod] reader:reader currPosition:0];
                    }
                }
            }
        }
    }
    return self;
}

- (void)dealloc {
    if (_header != nil) {
        [_header release];
        _header = nil;
    }
    [super dealloc];
}

- (void)syncSqliteRatingCDB {
    NSMutableArray *entryList = [[NSMutableArray alloc] init];
    if ([[[_iTunesDB IPod] deviceInfo] airSync] == TRUE) {
        //读取Sqlite中的信息
        
    } else {
        //读取Sqlite中的信息
    }
    
    IMBTrack *track = nil;
    for (IMBPlayCountEntry *entry in entryList) {
        if ([MediaHelper stringIsNilOrEmpty:[entry persistentID]] == TRUE) {
            continue;
        }
        
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ([(IMBTrack*)evaluatedObject dbID] == [[entry persistentID] longLongValue]);
        }];
        
        NSArray *preArray = [[[_iTunesDB tracklist] trackArray] filteredArrayUsingPredicate:pre];
        if (preArray != nil && [preArray count] > 0) {
            track = [preArray objectAtIndex:0];
        }
        if (track != nil) {
            [track setPlayCount:[entry playCount]];
            [track setDateLastPalyed:[entry lastPlayed]];
        }
        if ([track ratingInt] != [entry rating]) {
            [track setRating:(Byte)[entry rating]];
        }
    }
    [entryList release];
    entryList = nil;
}

- (void)mergeChanges {
    if (_header == nil) {
        return;
    }
    
    if ([_header entryCount] != [[_iTunesDB tracklist] getTrackCount]) {
        return;
    }
    
    int currentIndex = 0;
    for (IMBPlayCountEntry *entry in [_header entries]) {
        IMBTrack *track = [[_iTunesDB tracklist] getTrackByIndex:currentIndex];
        if (track != nil) {
            if ([entry playCount] > 0) {
                [track setPlayCount:([track playCount] + [entry playCount])];
                [track setDateLastPalyed:[entry lastPlayed]];
            }
            
            if ([track ratingInt] != [entry rating]) {
                [track setRating:(Byte)[entry rating]];
            }
            currentIndex++;
        }
    }
    NSString *playCountsPath = [[[_iTunesDB IPod] fileSystem] playCountPath];
    if ([[[_iTunesDB IPod] fileSystem] fileExistsAtPath:playCountsPath]) {
        [[[_iTunesDB IPod] fileSystem] unlink:playCountsPath];
    }
}

@end

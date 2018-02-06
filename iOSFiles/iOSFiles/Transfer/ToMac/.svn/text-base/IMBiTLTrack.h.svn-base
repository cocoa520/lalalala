//
//  IMBiTLTrack.h
//  iMobieTrans
//
//  Created by zhang yang on 13-4-17.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiTunesEnum.h"
#import "IMBCommonEnum.h"
enum iTLTrackKind {
	iTLTrackKind_FileTrack = 'kFTk',
	iTLTrackKind_URLTrack = 'kUTk',
	iTLTrackKind_SharedTrack = 'kSTk'
};
typedef enum iTLTrackKind iTLTrackKind;



@interface IMBiTLTrack : NSObject {
	NSString *album;
	NSString *artist;
    NSString *genre;
    NSDate *dateAdded;
    double duration;  // the length of the track in seconds
    NSInteger rating;  // the rating of this track (0 to 100)
    long long size;  // the size of the track (in bytes)
    NSInteger playedCount;  // number of times this track has been played
    BOOL isPodcast;  // is this track a podcast episode?
    BOOL isVideo;
    BOOL isMusicVideo;
    BOOL isMovie;
    BOOL isTVShow;
    BOOL fileIsExist;
    //iTunesEVdK videoKind;  // kind of video track
    NSString *kind;  // a text description of the track
    NSInteger databaseID;  // the common, unique ID for this track. If two tracks in different playlists have the same database ID, they are sharing the same data.
    NSString *name;  // the name of the item
    NSString *persistentID;  // the id of the item as a hexidecimal string. This id does not change over time.
    iTLTrackKind trackKind;
    NSURL *location;
    NSString *address;
    iTunesMediaTypeEnum iTunesMediaType;
    CheckStateEnum checkState;
}

@property (copy) NSString *album;
@property (copy) NSString *artist;
@property (copy) NSString *genre;
@property (copy) NSDate *dateAdded;
@property (nonatomic) double duration;  // the length of the track in seconds
@property (nonatomic) NSInteger rating;  // the rating of this track (0 to 100)
@property (nonatomic) long long size;  // the size of the track (in bytes)
@property (nonatomic) NSInteger playedCount;  // number of times this track has been played
@property (nonatomic) BOOL isPodcast;  // is this track a podcast episode?
//iTunesEVdK videoKind;  // kind of video track
@property (nonatomic) BOOL isVideo;
@property (nonatomic) BOOL isMusicVideo;
@property (nonatomic) BOOL isMovie;
@property (nonatomic) BOOL isTVShow;
@property (nonatomic,copy) NSString *kind;  // a text description of the track
@property (nonatomic) NSInteger databaseID;  // the common, unique ID for this track. If two tracks in different playlists have the same database ID, they are sharing the same data.
@property (copy) NSString *name;  // the name of the item
@property (copy) NSString *persistentID;  // the id of the item as a hexidecimal string. This id does not change over time.
@property (nonatomic) iTLTrackKind trackKind;
@property (copy) NSURL *location;
@property (copy) NSString *address;
@property (nonatomic) iTunesMediaTypeEnum iTunesMediaType;
@property (nonatomic) BOOL fileIsExist;
@property (nonatomic, readwrite) CheckStateEnum checkState;

@end

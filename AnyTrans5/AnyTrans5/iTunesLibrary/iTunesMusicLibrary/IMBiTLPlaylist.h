//
//  IMBiTLPlaylist.h
//  iMobieTrans
//
//  Created by zhang yang on 13-4-17.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiTunesEnum.h"


@interface IMBiTLPlaylist : NSObject {
    /*
    <key>Name</key><string>资料库</string>
    <key>Master</key><true/>
    <key>Playlist ID</key><integer>934</integer>
    <key>Playlist Persistent ID</key><string>17040A47610D3D0D</string>
    <key>Visible</key><false/>
    <key>All Items</key><true/>
    <key>Playlist Items</key>
    
     <key>Name</key><string>音乐</string>
     <key>Playlist ID</key><integer>1273</integer>
     <key>Playlist Persistent ID</key><string>E771D699520A5572</string>
     <key>Distinguished Kind</key><integer>4</integer>
     <key>Music</key><true/>
     <key>All Items</key><true/>
     <key>Playlist Items</key>
     
     <dict>
     <key>Name</key><string>影片</string>
     <key>Playlist ID</key><integer>1545</integer>
     <key>Playlist Persistent ID</key><string>94ECAEF8BC88C88C</string>
     <key>Distinguished Kind</key><integer>2</integer>
     <key>Movies</key><true/>
     <key>All Items</key><true/>
     </dict>
     <dict>
     <key>Name</key><string>电视节目</string>
     <key>Playlist ID</key><integer>1548</integer>
     <key>Playlist Persistent ID</key><string>8AB23848C561C8E9</string>
     <key>Distinguished Kind</key><integer>3</integer>
     <key>TV Shows</key><true/>
     <key>All Items</key><true/>
     </dict>
     <dict>
     <key>Name</key><string>Podcast</string>
     <key>Playlist ID</key><integer>1260</integer>
     <key>Playlist Persistent ID</key><string>711000C3E1BE26A0</string>
     <key>Distinguished Kind</key><integer>10</integer>
     <key>Podcasts</key><true/>
     <key>All Items</key><true/>
     <key>Playlist Items</key>
     <array>
     </array>
     </dict>
     <dict>
     <key>Name</key><string>图书</string>
     <key>Playlist ID</key><integer>1551</integer>
     <key>Playlist Persistent ID</key><string>E059040275E365DF</string>
     <key>Distinguished Kind</key><integer>5</integer>
     <key>Audiobooks</key><true/>
     <key>Books</key><true/>
     <key>All Items</key><true/>
     <key>Playlist Items</key>
     <array>
     </array>
     </dict>
     <dict>
     <key>Name</key><string>已购买</string>
     <key>Playlist ID</key><integer>1641</integer>
     <key>Playlist Persistent ID</key><string>1D6EEAC290BACDFF</string>
     <key>Distinguished Kind</key><integer>19</integer>
     <key>Purchased Music</key><true/>
     <key>All Items</key><true/>
     <key>Playlist Items</key>
     <array>
     <dict>
     <key>Track ID</key><integer>506</integer>
     </dict>
     </array>
     </dict>
     <dict>
     <key>Name</key><string>在“Zhangyang 的 iPhone”上购买的项目</string>
     <key>Playlist ID</key><integer>1652</integer>
     <key>Playlist Persistent ID</key><string>6EE89F10C3F528DF</string>
     <key>Distinguished Kind</key><integer>20</integer>
     <key>All Items</key><true/>
     <key>Playlist Items</key>
     <array>
     </array>
     </dict>
    */
    NSString* name;
    BOOL isMaster;
    int playlistID;
    NSString *playlistPersistentID;
    BOOL isVisible;
    BOOL isAllItems;
    NSMutableArray *playlistItems;
    BOOL isMusic;
    BOOL isAudiobooks;
    BOOL isBooks;
    BOOL isPodcasts;
    BOOL isTVShows;
    BOOL isSmartPlaylist;
    int distinguishedKindId;
    iTunesTypeEnum iTunesType;
    
    NSMutableArray *playlistTrackIds;
    
    //<key>Music</key><true/>
    //<key>Audiobooks</key><true/>
    //<key>Books</key><true/>
    //<key>Podcasts</key><true/>
    //<key>TV Shows</key><true/>
}

@property(nonatomic, readwrite, copy) NSString* name;
@property(nonatomic, readwrite) BOOL isMaster;
@property(nonatomic, readwrite) int playlistID;
@property(nonatomic, readwrite,copy) NSString *playlistPersistentID;
@property(nonatomic, readwrite) BOOL isVisible;
@property(nonatomic, readwrite) BOOL isAllItems;
@property(nonatomic, readwrite, retain) NSMutableArray *playlistItems;
@property(nonatomic, readwrite) BOOL isMusic;
@property(nonatomic, readwrite) BOOL isAudiobooks;
@property(nonatomic, readwrite) BOOL isBooks;
@property(nonatomic, readwrite) BOOL isPodcasts;
@property(nonatomic, readwrite) BOOL isTVShows;
@property(nonatomic, readwrite) BOOL isSmartPlaylist;
@property(nonatomic, readwrite) int distinguishedKindId;
@property(nonatomic, readwrite) iTunesTypeEnum iTunesType;
@property(nonatomic, readwrite, retain) NSMutableArray *playlistTrackIds;
@property(readonly,getter = checkUserDefined ) BOOL isUserDefined;
@property (nonatomic, readonly) NSString *nameAndCountString;

- (BOOL) containsTrackByPersistentID:(NSString*)persistentID;


@end

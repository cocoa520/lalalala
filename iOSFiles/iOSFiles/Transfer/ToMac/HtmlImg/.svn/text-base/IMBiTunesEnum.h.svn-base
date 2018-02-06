//
//  IMBiTunesEnum.h
//  iMobieTrans
//
//  Created by zhang yang on 13-6-20.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"

typedef enum iTunesType{
    iTunes_Material = 0,
    iTunes_Music90 = 200,
    iTunes_Favorites = 201,
    iTunes_GoldenSong25 = 202,
    iTunes_RecentlyPlayed = 203,
    iTunes_RecentlyAdded = 204,
    iTunes_MusicVideo = 205,
    iTunes_ClassicalMusic = 206,
    iTunes_iTunesDJ = 22,
    iTunes_Podcast = 10,
    iTunes_iTunesU = 31,
    iTunes_Music = 4,
    iTunes_Movie = 2,
    iTunes_TVShow = 3,
    iTunes_Books = 5,
    iTunes_Audiobook = 2001,
    iTunes_Ring = 6,
    iTunes_LeaseProject = 7,
    iTunes_Genius = 26,
    iTunes_Apps = 18,
    iTunes_VoiceMemos = 17,
    iTunes_Others = 9999,
    iTunes_All = 10000,
    iTunes_HomeVideo = 48
} iTunesTypeEnum;

typedef enum iTunesMediaType{
    iTunesMedia_Unknown = -0x00000001,
    iTunesMedia_AudioAndVideo = 0x00000000,
    iTunesMedia_Audio = 0x00000001,
    iTunesMedia_Video = 0x00000002,
    iTunesMedia_Podcast = 0x00000004,
    iTunesMedia_VideoPodcast = 0x00000006,
    iTunesMedia_Audiobook = 0x00000008,
    iTunesMedia_MusicVideo = 0x00000020,
    iTunesMedia_TVShow = 0x00000040,
    iTunesMedia_TVAndMusic = 0x00000060,
    iTunesMedia_Ringtone = 0x4000,
    iTunesMedia_Books = 0x400000,
    iTunesMedia_iTunesUGroup = 0x200000,
    iTunesMedia_iTunesU = 0x200001,
    iTunesMedia_iTunesUVideo = 0x200002,
    iTunesMedia_PDFBooks = 0x800000,
    iTunesMedia_Application = 0x01000001

} iTunesMediaTypeEnum;


@interface IMBiTunesEnum : NSObject

+(NSString*) iTunesMediaTypeEnumToString:(iTunesMediaTypeEnum)mediaType;
+(int) getDistinguishedKindId:(CategoryNodesEnum)category;
+(NSArray*) itunesTypeToiTunesMediaTyps:(iTunesTypeEnum)itunesType;
@end

//
//  IMBiTunesEnum.m
//  iMobieTrans
//
//  Created by zhang yang on 13-6-20.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBiTunesEnum.h"


@implementation IMBiTunesEnum

+(NSString*) iTunesMediaTypeEnumToString:(iTunesMediaTypeEnum)mediaType {
    switch (mediaType) {
        case iTunesMedia_AudioAndVideo:
        case iTunesMedia_Audio:
            return @"Music";
            break;
        case iTunesMedia_Video:
            return @"Movie";
            break;
        case iTunesMedia_Podcast:
        case iTunesMedia_VideoPodcast:
            return @"Podcast";
            break;
        case iTunesMedia_Audiobook:
            return @"Audiobook";
            break;
        case iTunesMedia_MusicVideo:
            return @"MusicVideo";
            break;
        case iTunesMedia_TVShow:
        case iTunesMedia_TVAndMusic:
            return @"TVShow";
            break;
        case iTunesMedia_Ringtone:
            return @"Ringtone";
            break;
        case iTunesMedia_Books:
        case iTunesMedia_PDFBooks:
            return @"iBook";
            break;
        case iTunesMedia_iTunesUGroup:
        case iTunesMedia_iTunesU:
        case iTunesMedia_iTunesUVideo:
            return @"iTunesU";
            break;
        case iTunesMedia_Unknown:
            return @"Unknown";
            break;
        default:
            return @"Music";
    }
}

+(int) getDistinguishedKindId:(CategoryNodesEnum)category {
    switch (category) {
        case Category_iTunes_Music:
            return (int)iTunes_Music;
            break;
        case Category_iTunes_Movie:
            return (int)iTunes_Movie;
            break;
        case Category_iTunes_TVShow:
            return (int)iTunes_TVShow;
            break;
        case Category_iTunes_PodCasts:
            return (int)iTunes_Podcast;
            break;
        case Category_iTunes_iTunesU:
            return (int)iTunes_iTunesU;
            break;
        case Category_iTunes_iBooks:
            return (int)iTunes_Books;
            break;
        case Category_iTunes_Ringtone:
            return (int)iTunes_Ring;
            break;
        case Category_iTunes_VoiceMemos:
            return (int)iTunes_VoiceMemos;
            break;
        case Category_iTunes_Audiobook:
            return (int)iTunes_Audiobook;
            break;
        case Category_iTunes_App:
            return (int)iTunes_Apps;
            break;
        case Catrgory_iTunes_HomeVideo:
            return (int)iTunes_HomeVideo;
            break;
        default:
            return 0;
            break;
    }
}

+(NSArray*) itunesTypeToiTunesMediaTyps:(iTunesTypeEnum)itunesType {
    NSMutableArray* mediatypes = [[[NSMutableArray alloc] init] autorelease];
    switch (itunesType) {
        case iTunes_All:
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_AudioAndVideo]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Audio]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Video]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_TVShow]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_TVAndMusic]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_MusicVideo]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Podcast]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_VideoPodcast]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_iTunesU]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_iTunesUVideo]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Audiobook]];
            return mediatypes;
            break;
        case iTunes_Music:
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Audio]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_MusicVideo]];
            return mediatypes;
            break;
        case iTunes_Movie:
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Video]];
            return mediatypes;
            break;
        case iTunes_TVShow:
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_TVShow]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_TVAndMusic]];
            return mediatypes;
            break;
        case iTunes_Podcast:
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Podcast]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_VideoPodcast]];
            return mediatypes;
            break;
        case iTunes_iTunesU:
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_iTunesU]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_iTunesUVideo]];
            return mediatypes;
            break;
        case iTunes_Books:
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_PDFBooks]];
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Books]];
            return mediatypes;
            break;
        //TODO
        /*
        case Category_Audiobook:
            [mediatypes addObject:[NSNumber numberWithInt:(int)Audiobook]];
            return mediatypes;
            break;
        */
        case iTunes_Ring:
            [mediatypes addObject:[NSNumber numberWithInt:(int)iTunesMedia_Ringtone]];
            return mediatypes;
            break;
        default:
            return nil;
            break;
    }
}



@end

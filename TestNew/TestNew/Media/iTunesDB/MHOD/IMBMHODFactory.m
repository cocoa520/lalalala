//
//  IMBMHODFactory.m
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBMHODFactory.h"

@implementation IMBMHODFactory

+(IMBBaseMHODElement*)readMHOD:(IMBiPod*)ipod reader:(NSData *)reader currPosition:(long*)currPosition {
    IMBBaseMHODElement *mhod = [[IMBBaseMHODElement alloc] init];
    long tempPosition = *currPosition;
    tempPosition = [mhod read:ipod reader:reader currPosition:tempPosition];
    IMBBaseMHODElement *newMHOD = nil;
    
    switch ([mhod type]) {
        case PODCASTFILEURL:
        case PODCASTRSSURL:
            newMHOD = [[[IMBUnknownMHOD alloc] init] autorelease];
            break;
            
        case ID:
        case TITLE:
        case FILEPATH:
        case ALBUM:
        case ARTIST:
        case GENRE:
        case FILETYPE:
        case COMMENT:
        case COMPOSER:
        case ALUMARTIST:
        case DESCRIPTIONTEXT:
        case ARTISTSORTBY:
            newMHOD = [[[IMBUnicodeMHOD alloc] init] autorelease];
            break;
            
        case MENUINDEXTABLE:
            newMHOD = [[[IMBMenuIndexMHOD alloc] init] autorelease];
            break;
            
        case PLAYLISTPOSITION:
            newMHOD = [[[IMBPlaylistPositionMHOD alloc] init] autorelease];
            break;
            
        default:
            newMHOD = [[[IMBUnknownMHOD alloc] init] autorelease];
            break;
    }
    [newMHOD setHeader:mhod];
    tempPosition = [newMHOD read:ipod reader:reader currPosition:tempPosition];
    *currPosition = tempPosition;
    [mhod release];
    return newMHOD;
}

@end

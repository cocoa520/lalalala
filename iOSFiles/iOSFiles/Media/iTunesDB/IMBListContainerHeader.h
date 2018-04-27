//
//  IMBListContainerHeader.h
//  MediaTrans
//
//  Created by Pallas on 12/16/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBTrackListContainer.h"
#import "IMBAlbumListContainer.h"
#import "IMBPlaylistListContainer.h"
#import "IMBPlaylistListV2Container.h"
#import "IMBUnknownListContainer.h"
#import "IMBType5Container.h"
#import "IMBType6Container.h"

typedef enum MHSDSectionType{
    Tracks = 1,
    Playlists = 2,
    PlaylistsV2 =3,
    Albums = 4,
    Type5 = 5,
    Type6 = 6,
    Unknown = 999
}MHSDSectionTypeEnum;

@interface IMBListContainerHeader : IMBBaseDatabaseElement{
@protected
    MHSDSectionTypeEnum _type;
    IMBBaseDatabaseElement *_childElement;
}

@property (nonatomic,readonly) MHSDSectionTypeEnum type;

-(IMBBaseDatabaseElement*)getListContainer;
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition;
@end

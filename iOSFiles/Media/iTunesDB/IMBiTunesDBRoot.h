//
//  IMBiTunesDBRoot.h
//  MediaTrans
//
//  Created by Pallas on 12/16/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBListContainerHeader.h"
#import "IMBPlaylistList.h"

@interface IMBiTunesDBRoot : IMBBaseDatabaseElement{
@protected
    int _unk1;
    int _versionNumber;
    int _listContainerCount;
    UInt64 _iD;
    Byte *_unk2;
    int unk2Length;
    int16_t _hashingScheme;
    NSMutableArray *_childSections;
}

@property (nonatomic,readonly) int versionNumber;
@property (nonatomic,readonly) int16_t hashingScheme;

-(IMBListContainerHeader*)getChildSection:(MHSDSectionTypeEnum)type;
-(IMBPlaylistList*)getPlaylistList;
-(IMBPlaylistList*)getPlaylistListV2;

@end

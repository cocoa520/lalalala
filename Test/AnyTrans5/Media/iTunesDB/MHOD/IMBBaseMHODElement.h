//
//  IMBBaseMHODElement.h
//  MediaTrans
//
//  Created by Pallas on 12/11/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseDatabaseElement.h"
#import "IMBBaseMHODElement.h"

#pragma mark - 定义了元素的类型
#define ID 0
#define TITLE 1
#define FILEPATH 2
#define ALBUM 3
#define ARTIST 4
#define GENRE 5
#define FILETYPE 6
#define COMMENT 8
#define COMPOSER 12
#define DESCRIPTIONTEXT 14
#define PODCASTFILEURL 15
#define PODCASTRSSURL 16
#define CHAPTERDATA 17
#define ALUMARTIST 22
#define ARTISTSORTBY 23
#define TITLESORTBY 27
#define ALBUMSORTBY 28
#define ALBUMARTISTSORTBY 29
#define SMARTPLAYLISTDATA 50
#define SMARTPLAYLISTRULE 51
#define MENUINDEXTABLE 52
#define LETTERJUMPTABLE 53
#define PLAYLISTPOSITION 100

@interface IMBBaseMHODElement : IMBBaseDatabaseElement {
@protected
    int _type;
    int _unk1;
    int _unk2;
}

@property (nonatomic,readonly) int unk1;
@property (nonatomic,readonly) int unk2;
@property (nonatomic,readonly) int type;

-(id)initWithElementType:(int)type;
-(void)setHeader:(IMBBaseDatabaseElement*)header;

@end

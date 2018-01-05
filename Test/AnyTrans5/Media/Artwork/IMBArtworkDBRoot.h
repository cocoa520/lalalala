//
//  IMBArtworkDBRoot.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBArtworkListContainerHeader.h"

@interface IMBArtworkDBRoot : IMBBaseDatabaseElement {
@private
    int _unk1, _unk2, _unk3, _listContainerCount;
    uint _nextImageId;
    //存放IMBArtworkListContainerHeader对象
    NSMutableArray *_childSections;
}

@property (nonatomic, readwrite) uint nextImageId;

- (IMBArtworkListContainerHeader*)getChildSection:(ArtworkMHSDSectionTypeEnum)type;

@end

//
//  IMBArtworkListContainerHeader.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"

typedef enum ArtworkMHSDSectionType {
    ArtworkImages = 1,
    ArtworkAlbums = 2,
    ArtworkFiles = 3
} ArtworkMHSDSectionTypeEnum;

@interface IMBArtworkListContainerHeader : IMBBaseDatabaseElement {
@private
    ArtworkMHSDSectionTypeEnum _type;
    IMBBaseDatabaseElement *_childSection;
}

@property (nonatomic, readonly) ArtworkMHSDSectionTypeEnum type;

- (IMBBaseDatabaseElement*)getListContainer;

@end

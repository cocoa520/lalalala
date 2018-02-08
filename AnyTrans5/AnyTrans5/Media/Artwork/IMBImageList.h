//
//  IMBImageList.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"

@class IMBTrack;
@class IMBIPodImage;

@interface IMBImageList : IMBBaseDatabaseElement {
@private
    NSMutableArray *_childSections;
}

- (IMBIPodImage*)getArtworkByTrackID:(int64_t)trackID;
- (IMBIPodImage*)getArtworkByID:(uint)iD;
- (void)addNewArtwork:(IMBTrack*)track image:(NSImage*)image;
- (NSMutableArray*)getImages;
- (void)removeArtwork:(IMBIPodImage*)existingArtwork;

@end

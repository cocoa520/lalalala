//
//  IMBArtworkDB.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabase.h"
#import "IMBArtworkEntity.h"

@class IMBArtworkDBRoot;
@class IMBImageList;
@class IMBIThmbFileList;
@class IMBTrack;
@class IMBIPodImageFormat;

@interface IMBArtworkDB : IMBBaseDatabase {
@private
    IMBArtworkDBRoot *_databaseRoot;
    IMBImageList *_artworkList;
    IMBIThmbFileList *_ithmbFileList;
    BOOL _isDirty;
    NSFileManager *fm;
    uint _nextImageID;
}

@property (nonatomic, readonly) IMBImageList *artworkList;
@property (nonatomic, readwrite) uint nextImageID;

- (BOOL)isDirty;
- (void)setNextImageID:(uint)nextImageID;
- (uint)nextImageID;

- (id)initWithIPod:(IMBiPod*)ipod;
- (void)setArtwork:(IMBTrack*)track image:(NSImage*)image;
- (void)removeArtwork:(IMBTrack*)track;
- (void)getIThmbRepository:(IMBIPodImageFormat*)format fileName:(NSString**)fileName fileOffset:(uint*)fileOffset;
- (uint)getNextFreeBlockInIThmb:(NSString*)fileName ithmbBlockSize:(uint)ithmbBlockSize;

@end

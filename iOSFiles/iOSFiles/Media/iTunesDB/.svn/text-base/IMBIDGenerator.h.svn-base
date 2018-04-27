//
//  IMBIDGenerator.h
//  iMobieTrans
//
//  Created by Pallas on 1/6/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMBiPod;
@class IMBTrack;

@interface IMBIDGenerator : NSObject {
@private
    IMBiPod *iPod;
    int _lastTrackID;
    int64_t _lastDBID;
    int _lastPodcastGroupID;
}

- (id)initWithIPod:(IMBiPod*)ipod;
- (int)getNewTrackID;
- (int64_t)getNewDBID;
- (NSString*)getNewIPodFilePath:(IMBTrack*)track fileExtension:(NSString*)fileExtension;
- (NSString*)getNewRandomFileName;
- (uint)getNewArtworkID;
- (int)getNewPodcastGroupID;

@end

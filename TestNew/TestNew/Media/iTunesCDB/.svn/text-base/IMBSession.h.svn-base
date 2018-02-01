//
//  IMBSession.h
//  iMobieTrans
//
//  Created by Pallas on 1/4/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMBiPod;

@interface IMBSession : NSObject {
@private
    IMBiPod *iPod;
    
@public
    NSMutableArray *_deletedTracks;
    NSMutableArray *_deletedPlaylists;
}

@property (nonatomic, readwrite, retain) NSMutableArray *deletedTracks;
@property (nonatomic, readwrite, retain) NSMutableArray *deletedPlaylists;

- (id)initWithIPod:(IMBiPod*)ipod;
- (NSString*)sessionFolderPath;
- (void)clear;

@end

//
//  IMBPlayCounts.h
//  iMobieTrans
//
//  Created by Pallas on 1/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMBHeader;
@class IMBMusicDatabase;
@class IMBPlayCountHeader;

@interface IMBPlayCounts : NSObject {
    IMBPlayCountHeader *_header;
    IMBMusicDatabase *_iTunesDB;
    NSData *reader;
    BOOL isPlist;
}

- (id)initWithMusicDB:(IMBMusicDatabase*)itunesdb;
- (void)syncSqliteRatingCDB;
- (void)mergeChanges;

@end

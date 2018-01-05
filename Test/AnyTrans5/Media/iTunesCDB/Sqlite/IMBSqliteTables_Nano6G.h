//
//  IMBSqliteTables_Nano5G.h
//  iMobieTrans
//
//  Created by zhang yang on 13-4-27.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBSqliteTables_Above3.h"

@interface IMBSqliteTables_Nano6G : IMBSqliteTables_Above3 {
@protected
    NSMutableArray *_trackArtists;
    long long _nextTrackArtistId;
}

- (id)initWithIPod:(IMBiPod *)ipod;

@end

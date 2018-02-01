//
//  IMBSqliteTables_Above3.m
//  iMobieTrans
//
//  Created by Pallas on 1/13/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSqliteTables_Above3.h"
#import "IMBIPod.h"
#import "IMBSession.h"
#import "IMBTrack.h"

@implementation IMBSqliteTables_Above3

- (id)initWithIPod:(IMBiPod *)ipod {
    self = [super initWithIPod:ipod];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)removeDeletedTracks {
    NSString *deleteLocationQuery = @"delete from location where item_pid = :pid";
    NSString *delSql = nil;
    for (IMBTrack *track in [[iPod session] deletedTracks]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithLongLong:[track dbID]], @"pid"
                                , nil];
        NSLog(@"pid %lld", track.dbID);
        delSql = @"delete from item where pid = :pid;";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        delSql = @"delete from item_to_container where item_pid = :pid;";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        delSql = @"delete from avformat_info where item_pid = :pid;";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        delSql = @"delete from video_characteristics where item_pid = :pid;";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        delSql = @"delete from delete from video_info where item_pid = :pid";
        [_libraryConnection executeUpdate:delSql withParameterDictionary:params];
        [_locationsConnection executeUpdate:deleteLocationQuery withParameterDictionary:params];
        _updatedLocationsDb = TRUE;
    }
}

@end

//
//  IMBSyncPlaylistFactory.m
//  iMobieTrans
//
//  Created by Pallas on 1/28/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSyncPlaylistFactory.h"
#import "IMBiPod.h"
#import "IMBSyncPlaylistToCDB_BelowIOS4.h"
#import "IMBSyncPlaylistToCDB_BelowIOS5.h"
#import "IMBSyncPlaylistToCDB_AboveIOS5.h"
#import "IMBDeviceInfo.h"

@implementation IMBISyncPlaylistToCDB

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)startSync {
    return;
}

- (void)cleanup {
    return;
}

@end

@implementation IMBSyncPlaylistFactory

+ (IMBISyncPlaylistToCDB*)getSyncInstance:(IMBiPod*)ipod {
    if (ipod != nil) {
        if ([[ipod deviceInfo] airSync]) {
            return [[[IMBSyncPlaylistToCDB_AboveIOS5 alloc] initWithIPod:ipod] autorelease];
        } else if ([[ipod deviceInfo] isIOSDevice]) {
            if ([[[ipod deviceInfo] productVersion] compare:@"4.0" options:NSNumericSearch] == NSOrderedAscending) {
                //前面的版本小于后面的版本
                return [[[IMBSyncPlaylistToCDB_BelowIOS4 alloc] initWithIPod:ipod] autorelease];
            } else {
                //前面的版本大于后面的版本
                return [[[IMBSyncPlaylistToCDB_BelowIOS5 alloc] initWithIPod:ipod] autorelease];
            }
        }
    }
    return nil;
}

@end

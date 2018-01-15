//
//  IMBSession.m
//  iMobieTrans
//
//  Created by Pallas on 1/4/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSession.h"
#import "IMBiPod.h"
#import "TempHelper.h"
#import "IMBDeviceInfo.h"

@implementation IMBSession
@synthesize deletedPlaylists = _deletedPlaylists;
@synthesize deletedTracks = _deletedTracks;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [self init];
    if (self) {
        iPod = ipod;
        _deletedTracks = [[NSMutableArray alloc] init];
        _deletedPlaylists = [[NSMutableArray alloc] init];
        //TODO:对session删除做出了修改
        NSFileManager *fileManager = [NSFileManager defaultManager ];
        NSString *sessionPath = [self sessionFolderPath];
        BOOL isDir = YES;
        if ([fileManager fileExistsAtPath:sessionPath isDirectory:(&isDir)]) {
            NSArray *arr = [fileManager contentsOfDirectoryAtPath:sessionPath error:NULL];
            for (NSString *file in arr) {
                if (![file.lastPathComponent.lowercaseString isEqualToString:@"video"]) {
                    [fileManager removeItemAtPath:file error:NULL];
                }
            }
//            [fileManager removeItemAtPath:sessionPath error:nil];
        }
        [fileManager createDirectoryAtPath:sessionPath withIntermediateDirectories:TRUE attributes:nil error:nil];
    }
    return self;
}

- (NSString*)sessionFolderPath {
    NSString *deviceSessionPath = [[TempHelper getAppSupportPath] stringByAppendingPathComponent:@"Session"];
    deviceSessionPath = [deviceSessionPath stringByAppendingPathComponent:[[iPod deviceInfo] serialNumber]];
    return deviceSessionPath;
}

- (void)clear {
    [_deletedPlaylists removeAllObjects];
    [_deletedTracks removeAllObjects];
}

@end

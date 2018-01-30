//
//  IMBiTunesSD.m
//  iMobieTrans
//
//  Created by Pallas on 1/23/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBiTunesSD.h"
#import "IMBSDHeader.h"
#import "IMBFileSystem.h"

@implementation IMBiTunesSD

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
        _header = [[IMBSDHeader alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_header != nil) {
        [_header release];
        _header = nil;
    }
    [super dealloc];
}

- (void)backup {
    NSString *iTunesSDPath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunesSD"];
    // ToDo设备的SD备份
    if ([[iPod fileSystem] fileExistsAtPath:iTunesSDPath]) {
    
    }
}

- (void)generate {
    NSString *iTunesSDPath = [[iPod fileSystem] combinePath:[[iPod fileSystem] iTunesFolderPath] pathComponent:@"iTunesSD"];
    NSMutableData *writer = [[NSMutableData alloc] init];
    [_header write:writer];
    [writer writeToFile:iTunesSDPath atomically:YES];
    [writer release];
    writer = nil;
}

@end

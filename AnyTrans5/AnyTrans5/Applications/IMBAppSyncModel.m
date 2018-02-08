//
//  IMBAppSyncModel.m
//  iMobieTrans
//
//  Created by iMobie on 8/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBAppSyncModel.h"

@implementation IMBAppSyncModel
@synthesize identifier = _identifier;
@synthesize appName = _appName;
@synthesize appVersion = _appVersion;
@synthesize appFilePath = _appFilePath;
@synthesize appCachePath = _appCachePath;


- (void)dealloc{
    if (_identifier != nil) {
        [_identifier release];
        _identifier = nil;
    }
    if (_appName != nil){
        [_appName release];
        _appName = nil;
    }
    if (_appVersion != nil) {
        [_appVersion release];
        _appVersion = nil;
    }
    if (_appFilePath != nil) {
        [_appFilePath release];
        _appFilePath = nil;
    }
    if (_appCachePath != nil) {
        [_appCachePath release];
        _appCachePath = nil;
    }
    [super dealloc];
}
@end

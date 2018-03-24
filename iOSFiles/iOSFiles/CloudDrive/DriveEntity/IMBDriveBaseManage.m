//
//  IMBDriveBaseManage.m
//  iOSFiles
//
//  Created by JGehry on 4/16/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDriveBaseManage.h"

@implementation IMBDriveBaseManage
@synthesize driveWindowDelegate = _driveWindowDelegate;
@synthesize driveDataAry = _driveDataAry;
@synthesize downloadPath = _downloadPath;

- (id)initWithUserID:(NSString *) userID WithPassID:(NSString*) passID WithDelegate:(id)delegate {
    if ([self init]) {

    }
    return self;
}

- (id)initWithUserID:(NSString *)userID withDelegate:(id)delegate{
    if ([super init]) {

    }
    return self;
}

- (void)userDidLogout {

}


-(void)dealloc {
    [super dealloc];
    [_driveDataAry release];
    _driveDataAry = nil;
    [_userID release];
    _userID = nil;
}

@end

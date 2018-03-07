//
//  AppDelegate.m
//  ATHHostSync32
//
//  Created by LuoLei on 2017-03-24.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _ath = [[ATHHostSync32 alloc] init];
    //软件启动成功
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceStartSuccess object:nil userInfo:nil deliverImmediately:YES];
}


- (void)dealloc
{
    [_ath release],_ath = nil;
    [super dealloc];
}
@end

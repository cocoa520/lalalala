//
//  AppDelegate.m
//  iOS File
//
//  Created by 龙凡 on 2018/1/15.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "AppDelegate.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"
#import "IMBViewManager.h"
#import <sqlite3.h>
#import "TempHelper.h"

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithObject:@"ja"] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Insert code here to initialize your application
    IMBViewManager *viewManager = [IMBViewManager singleton];
    viewManager.mainWindowController = [[IMBMainWindowController alloc] initWithWindowNibName:@"IMBMainWindowController"];
    [viewManager.mainWindowController.window setMinSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    [viewManager.mainWindowController.window setMaxSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    [viewManager.mainWindowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)dealloc {
    [super dealloc];
}


@end

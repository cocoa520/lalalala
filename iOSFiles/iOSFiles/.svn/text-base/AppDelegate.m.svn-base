//
//  AppDelegate.m
//  iOS File
//
//  Created by 龙凡 on 2018/1/15.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _mainWindowController = [[IMBMainWindowController alloc] initWithWindowNibName:@"IMBMainWindowController"];
//    [self.window setContentSize:NSMakeSize(1060, 635)];
    [_mainWindowController.window setContentSize:NSMakeSize(1060, 635)];
    [_mainWindowController showWindow:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)dealloc {
    [super dealloc];
    if (_mainWindowController) {
        [_mainWindowController release];
        _mainWindowController = nil;
    }
}
@end

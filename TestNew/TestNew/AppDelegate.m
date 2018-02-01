//
//  AppDelegate.m
//  TestNew
//
//  Created by iMobie on 18/1/8.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "AppDelegate.h"
#import "ZLMainWindowController.h"


@interface AppDelegate ()
{
    @private
    ZLMainWindowController *_mainWindowController;
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
    
    _mainWindowController = [[ZLMainWindowController alloc] initWithWindowNibName:@"ZLMainWindowController"];
    [[_mainWindowController window] center];
    [[_mainWindowController window] makeMainWindow];
    [[_mainWindowController window] makeKeyWindow];
    //    [[_mainWindowController window] orderFront:nil];
    
    [_mainWindowController showWindow:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
}

//实现这个方法并且返回YES，则会自动调用- (void)applicationWillTerminate:(NSNotification *)aNotification，让app结束进程
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}
@end

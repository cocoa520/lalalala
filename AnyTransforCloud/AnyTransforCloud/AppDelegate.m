//
//  AppDelegate.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/8.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "AppDelegate.h"
#import "IMBSoftWareInfo.h"
#import "IMBNoTitleBarWindow.h"
#import "IMBNotificationDefine.h"
#import <Carbon/Carbon.h>

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [IMBSoftWareInfo singleton];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"zh"] forKey:@"AppleLanguages"];
    _loginViewController = [[IMBLoginViewController alloc] initWithDelegate:self];
    [_contentBox setContentView:_loginViewController.view];
    
    windowLargeWidth = [[[NSUserDefaults standardUserDefaults] objectForKey:@"windowWidth"] intValue];
    windowLargeHeight = [[[NSUserDefaults standardUserDefaults] objectForKey:@"windowHeight"] intValue];
    windowLargeWidth = windowLargeWidth > 1080 ? windowLargeWidth : 1080;
    windowLargeHeight = windowLargeHeight > 640 ? windowLargeHeight : 640;
    
    //添加鼠标全局的监听
    [self addMouseMonitor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_window setFrame:NSMakeRect(_window.frame.origin.x + ceil((_window.frame.size.width-WindowMinSizeWidth)/2), _window.frame.origin.y + ceil((_window.frame.size.height-WindowMinSizeHigh)/2), WindowMinSizeWidth, WindowMinSizeHigh) display:YES animate:YES];
        [_window setContentSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    });
}

- (void)addMouseMonitor {
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask |NSLeftMouseDownMask | NSMouseEnteredMask | NSRightMouseDownMask | NSMouseMovedMask | NSLeftMouseDraggedMask | NSRightMouseDraggedMask | NSLeftMouseUpMask | NSScrollWheelMask | NSMouseMovedMask
                                          handler:^NSEvent*(NSEvent* event) {
                                              switch (event.type) {
                                                  case NSLeftMouseDown:
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:GLOBAL_MOUSE_DOWN object:event];
                                                        break;
                                                  case NSLeftMouseUp:
                                                      break;
                                                  case NSRightMouseDown:
                                                      break;
                                                  case NSMouseMoved:
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:GLOBAL_MOUSE_MOVE object:event];
                                                      break;
                                                  case NSLeftMouseDragged:
                                                      break;
                                                  case NSRightMouseDragged:
                                                      break;
                                                  case NSScrollWheel:
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:GLOBAL_MOUSE_SCROLLWHELL object:event];
                                                      break;
                                                  default:
                                                      break;
                                              }
                                              if (event.type == NSKeyDown) {
                                                  if ([event keyCode] == kVK_Return) {
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:GLOBAL_KEY_ENTER object:event];
                                                  }
                                              }
                                              
                                              return event;
                                          }];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    windowLargeWidth = (int)self.window.frame.size.width;
    windowLargeHeight = (int)self.window.frame.size.height;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:windowLargeWidth] forKey:@"windowWidth"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:windowLargeHeight] forKey:@"windowHeight"];
    
    // Insert code here to tear down your application
}

- (void)changeWindowFrame:(BOOL)isUnlock {
    NSRect screenRect = [NSScreen mainScreen].frame;
    [[(IMBNoTitleBarWindow *)_window maxButton] setHidden:NO];
    [(IMBNoTitleBarWindow *)_window setTrackingArea:3];
    
    int width = windowLargeWidth > 1080 ? windowLargeWidth : 1080;
    int height =  windowLargeHeight > 640 ? windowLargeHeight : 640;
    
    [_window setMinSize:NSMakeSize(WindowMaxSizeWidth, WindowMaxSizeHigh)];
    [_window setMaxSize:NSMakeSize(screenRect.size.width, screenRect.size.height)];
    if (!isUnlock) {
        if (_mainViewController) {
            [_mainViewController release];
            _mainViewController = nil;
        }
        _mainViewController = [[IMBMainViewController alloc] initWithDelegate:self];
    }
    [_contentBox setContentView:_mainViewController.view];
    [_window setFrame:NSMakeRect(_window.frame.origin.x + ceil((_window.frame.size.width-width)/2), _window.frame.origin.y + ceil((_window.frame.size.height-height)/2), width, height) display:YES animate:YES];
    [_window setContentSize:NSMakeSize(width, height)];
    [_contentBox setContentView:_mainViewController.view];
}

- (void)backLoginView:(BOOL)isLogin {
//    NSRect screenRect = [NSScreen mainScreen].frame;
    windowLargeWidth = (int)self.window.frame.size.width;
    windowLargeHeight = (int)self.window.frame.size.height;
    
    [[(IMBNoTitleBarWindow *)_window maxButton] setHidden:YES];
    [(IMBNoTitleBarWindow *)_window setTrackingArea:2];
    [_window setMinSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    [_window setMaxSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    
    [_contentBox setContentView:_loginViewController.view];
    [_loginViewController addLoginViewOrUnlockView:isLogin];
    [_window setFrame:NSMakeRect(_window.frame.origin.x + ceil((_window.frame.size.width-WindowMinSizeWidth)/2), _window.frame.origin.y + ceil((_window.frame.size.height-WindowMinSizeHigh)/2), WindowMinSizeWidth, WindowMinSizeHigh) display:YES animate:YES];
    [_window setContentSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
}

@end

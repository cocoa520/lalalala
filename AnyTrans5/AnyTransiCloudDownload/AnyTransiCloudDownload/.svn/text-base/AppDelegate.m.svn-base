//
//  AppDelegate.m
//  AnyTransiCloudDownload
//
//  Created by iMobie on 10/8/16.
//  Copyright (c) 2016 IMB. All rights reserved.
//

#import "AppDelegate.h"
#import "IMBSocketServer.h"
#import "IMBConfigurationEntity.h"
#import "IMBLogManager.h"
@interface AppDelegate ()

@property (retain) IBOutlet NSWindow *window;
@property (nonatomic, readwrite, assign) int serverPort;

@end

@implementation AppDelegate
@synthesize serverPort = _serverPort;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    [[IMBLogManager singleton] writeInfoLog:@"anytrans Close"];
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSArray *array = [[NSProcessInfo processInfo] arguments];
    if (array && array.count > 1) {
        NSString *portStr = [array objectAtIndex:1];
        [self setServerPort:[portStr intValue]];
    } else {
        [self setServerPort:8888];
    }
    //监听socket消息
    [self listenSocketMessage];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[IMBLogManager singleton] writeInfoLog:@"applicationWillTerminate"];
    IMBSocketServer *socketServer = [IMBSocketServer singleton];
    [socketServer closeSocketdfd];
    [[IMBLogManager singleton] writeInfoLog:@"socketServer Close"];
    // Insert code here to tear down your application
}



- (void)awakeFromNib {
    [self.window setOpaque:NO];
    [[IMBLogManager singleton] writeInfoLog:@"Product Start!!!"];
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setStyleMask:NSBorderlessWindowMask];
    [self.window setAutodisplay:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeApp) name:@"closeApp" object:nil];
}

- (void)closeApp{
    [[IMBLogManager singleton] writeInfoLog:@"closeApp Close"];
    [self.window close];
}

- (void)listenSocketMessage {
    //监听socket消息
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int i = 3;
        IMBSocketServer *socketServer = [IMBSocketServer singleton];
        [socketServer setPort:self.serverPort];
        while (i--) {
            if ([socketServer listenServer]) {
                [socketServer setIsListen:YES];
                [socketServer acceptConnect];
                break;
            }
        }
    });
}

@end

//
//  IMBMainWindowController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMainWindowController.h"
#import "IMBCommonDefine.h"
#import "IMBMainPageViewController.h"
#import "IMBViewManager.h"


@interface IMBMainWindowController ()<NSPopoverDelegate,NSAnimationDelegate>

@end

@implementation IMBMainWindowController


- (id)initWithWindowNibName:(NSString *)windowNibName {
    if (self = [super initWithWindowNibName:windowNibName]) {
     
    }
    return self;
}

- (id)initWithNewWindowiPod:(IMBiPod *)ipod WithNewWindow:(BOOL)isNewWindow withLogMedleEnum:(ChooseLoginModelEnum)logMedleEnum {
    if ([super initWithWindowNibName:@"IMBMainWindowController"]) {
        _newiPod = [ipod retain];
        _isNewWindow = isNewWindow;
        _loginModelEnum = logMedleEnum;
    }
    return self;
}

- (id)initWithNewWindow {
    if ([super initWithWindowNibName:@"IMBMainWindowController"]) {
        _isNewWindow = NO;
    }
    return self;
}

/**
 *  初始化操作
 */
- (void)awakeFromNib {
    
    [_whiteView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    [[self window] setMovableByWindowBackground:YES];
    [self.window setContentSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    IMBViewManager *viewManager = [IMBViewManager singleton];
    if (_isNewWindow) {
        IMBViewManager *viewManager = [IMBViewManager singleton];
        IMBMainPageViewController *mainPageViewController = nil;
        if (_loginModelEnum == iCloudLogEnum) {
            mainPageViewController = [viewManager.allMainControllerDic objectForKey:@"iCloud"];
        }else if (_loginModelEnum == DropBoxLogEnum) {
            mainPageViewController = [viewManager.allMainControllerDic objectForKey:@"DropBox"];
        }else if (_loginModelEnum == DeviceLogEnum) {
            mainPageViewController = [viewManager.allMainControllerDic objectForKey:_newiPod.uniqueKey];
        }
        if (!mainPageViewController) {
            mainPageViewController = [[IMBMainPageViewController alloc]initWithiPod:_newiPod withMedleEnum:_loginModelEnum withiCloudDrvieBase:nil withDelegate:self];
            if (_loginModelEnum == iCloudLogEnum) {
                NSLog(@"========iCloudLogEnum========");
                [viewManager.windowDic setObject:self forKey:@"iCloud"];
                [viewManager.allMainControllerDic setObject:mainPageViewController forKey:@"iCloud"];
            }else if (_loginModelEnum == DropBoxLogEnum) {
                NSLog(@"========DropBoxLogEnum========");
                [viewManager.windowDic setObject:self forKey:@"DropBox"];
                [viewManager.allMainControllerDic setObject:mainPageViewController forKey:@"DropBox"];
            }else if (_loginModelEnum == DeviceLogEnum) {
                [viewManager.windowDic setObject:self forKey:_newiPod.uniqueKey];
                [viewManager.allMainControllerDic setObject:mainPageViewController forKey:_newiPod.uniqueKey];
            }
        }else {
            [mainPageViewController setDelegate:self];
            if (_loginModelEnum == iCloudLogEnum) {
                [viewManager.windowDic setObject:self forKey:@"iCloud"];
            }else if (_loginModelEnum == DropBoxLogEnum) {
                [viewManager.windowDic setObject:self forKey:@"DropBox"];
            }else if (_loginModelEnum == DeviceLogEnum) {
                [viewManager.windowDic setObject:self forKey:_newiPod.uniqueKey];
            }
        }
        
        [_rootBox setContentView:mainPageViewController.view];
//        [mainPageViewController release];
//        mainPageViewController = nil;
        [self.window setMinSize:NSMakeSize(WindowMaxSizeWidth, WindowMaxSizeHigh)];
        [self.window setMaxSize:NSMakeSize(WindowMaxSizeWidth, WindowMaxSizeHigh)];
        [self.window setContentSize:NSMakeSize(WindowMaxSizeWidth, WindowMaxSizeHigh)];
    }else {
        if (!viewManager.mainViewController) {
            viewManager.mainViewController = [[IMBDeviceViewController alloc] initWithDelegate:self];
        }else {
            [viewManager.mainViewController setDelegate:self];
        }
        [_rootBox setContentView:viewManager.mainViewController.view];
        [self.window setMinSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
        [self.window setMaxSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
        [self.window setContentSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    }
//    [self.window setStyleMask:NSPopUpMenuWindowLevel];
}

//-(void)windowDidLoad {
//    [super windowDidLoad];
////    [self.window setContentSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
//}

- (void)changeMainFrame:(IMBiPod *)iPod withMedleEnum:(ChooseLoginModelEnum )logMedleEnum withiCloudDrvieBase:(IMBDriveBaseManage*)baseManage {
    IMBViewManager *viewManager = [IMBViewManager singleton];
    IMBMainPageViewController *mainPageViewController = nil;
    IMBMainWindowController *mainWindowController = nil;
    if (logMedleEnum == iCloudLogEnum) {
        mainWindowController = [viewManager.windowDic objectForKey:@"iCloud"];
        mainPageViewController = [viewManager.allMainControllerDic objectForKey:@"iCloud"];
    }else if (logMedleEnum == DropBoxLogEnum) {
        mainWindowController = [viewManager.windowDic objectForKey:@"DropBox"];
        mainPageViewController = [viewManager.allMainControllerDic objectForKey:@"DropBox"];
    }else if (logMedleEnum == DeviceLogEnum) {
        mainWindowController = [viewManager.windowDic objectForKey:iPod.uniqueKey];
        mainPageViewController = [viewManager.allMainControllerDic objectForKey:iPod.uniqueKey];
    }
    if (mainWindowController) {
        [mainWindowController showWindow:self];
    }else {
        if (!mainPageViewController) {
            mainPageViewController = [[IMBMainPageViewController alloc]initWithiPod:iPod withMedleEnum:logMedleEnum withiCloudDrvieBase:baseManage withDelegate:self];
            if (logMedleEnum == iCloudLogEnum) {
                [viewManager.windowDic setObject:self forKey:@"iCloud"];
                [viewManager.allMainControllerDic setObject:mainPageViewController forKey:@"iCloud"];
            }else if (logMedleEnum == DropBoxLogEnum) {
                [viewManager.windowDic setObject:self forKey:@"DropBox"];
                [viewManager.allMainControllerDic setObject:mainPageViewController forKey:@"DropBox"];
            }else if (logMedleEnum == DeviceLogEnum) {
                [viewManager.windowDic setObject:self forKey:iPod.uniqueKey];
                [viewManager.allMainControllerDic setObject:mainPageViewController forKey:iPod.uniqueKey];
            }
        }else {
            [mainPageViewController setDelegate:self];
            if (logMedleEnum == iCloudLogEnum) {
                [viewManager.windowDic setObject:self forKey:@"iCloud"];
            }else if (logMedleEnum == DropBoxLogEnum) {
                [viewManager.windowDic setObject:self forKey:@"DropBox"];
            }else if (logMedleEnum == DeviceLogEnum) {
                [viewManager.windowDic setObject:self forKey:iPod.uniqueKey];
            }
        }
       
        [_rootBox setContentView:mainPageViewController.view];
        NSRect startFrame = [self.window frame];
        NSRect endFrame = NSMakeRect(startFrame.origin.x - (WindowMaxSizeWidth - startFrame.size.width)/2, startFrame.origin.y - (WindowMaxSizeHigh - startFrame.size.height)/2, WindowMaxSizeWidth, WindowMaxSizeHigh);
        [self.window setMinSize:endFrame.size];
        [self.window setMaxSize:endFrame.size];
        [self.window setFrame:endFrame display:YES animate:YES];
        
        if (viewManager.mainWindowController) {
            [viewManager.mainWindowController release];
            viewManager.mainWindowController = nil;
        }
    }
}

- (void)backMainViewChooseLoginModelEnum {
    IMBViewManager *viewManager = [IMBViewManager singleton];
    if (viewManager.mainWindowController) {
        [self closeWindow:nil];
        [viewManager.mainWindowController showWindow:self];
    }else {
        [viewManager.mainViewController setDelegate:self];
        [_rootBox setContentView:viewManager.mainViewController.view];
        NSRect startFrame = [self.window frame];
        NSRect endFrame = NSMakeRect(startFrame.origin.x + (startFrame.size.width - WindowMinSizeWidth)/2, startFrame.origin.y + (startFrame.size.height - WindowMinSizeHigh)/2, WindowMinSizeWidth, WindowMinSizeHigh);
        [self.window setMinSize:endFrame.size];
        [self.window setMaxSize:endFrame.size];
        [self.window setFrame:endFrame display:YES animate:YES];
        
        viewManager.mainWindowController = [self retain];
        [self removeObject:self];
    }
}

- (void)switchMainPageViewControllerWithiPod:(IMBiPod *)ipod withKey:(NSString *)key withCloud:(NSString *)cloudStr{
    
    IMBViewManager *viewManager = [IMBViewManager singleton];
    IMBMainPageViewController *mainPageViewController = nil;
    if (ipod) {
        mainPageViewController = [viewManager.allMainControllerDic objectForKey:ipod.uniqueKey];
        if (!mainPageViewController) {
            mainPageViewController = [[IMBMainPageViewController alloc]initWithiPod:ipod withMedleEnum:DeviceLogEnum withiCloudDrvieBase:nil withDelegate:self];
            [viewManager.allMainControllerDic setObject:mainPageViewController forKey:ipod.uniqueKey];
        }
    }else{
        if ([key isEqualToString:@"iCloud"]) {
            mainPageViewController = [viewManager.allMainControllerDic objectForKey:@"iCloud"];
        } else if ([key isEqualToString:@"DropBox"]) {
            mainPageViewController = [viewManager.allMainControllerDic objectForKey:@"DropBox"];
        }
    }
    [viewManager.windowDic setObject:self forKey:key];
    [mainPageViewController setDelegate:self];
    if ([viewManager.windowDic.allKeys containsObject:cloudStr]) {
        [viewManager.windowDic removeObjectForKey:cloudStr];
    }
    [_rootBox setContentView:mainPageViewController.view];
    [self.window setMinSize:NSMakeSize(WindowMaxSizeWidth, WindowMaxSizeHigh)];
    [self.window setMaxSize:NSMakeSize(WindowMaxSizeWidth, WindowMaxSizeHigh)];
}
/**
 *  关闭window
 */
- (void)closeWindow:(id)sender {
    [self.window close];
    BOOL ret = [self removeObject:self];
    if (!ret) {//点击关闭的是主页的小的window，然后移除
        IMBViewManager *viewManager = [IMBViewManager singleton];
        if (viewManager.mainWindowController) {
            if (viewManager.mainWindowController.window.frame.size.width == WindowMinSizeWidth && viewManager.mainWindowController.window.frame.size.height == WindowMinSizeHigh) {
                [viewManager.mainWindowController release];
                viewManager.mainWindowController = nil;
            }
        }
    }
}

- (BOOL)removeObject:(id)object {
    BOOL ret = NO;
    IMBViewManager *viewManager = [IMBViewManager singleton];
    for (NSString *key in viewManager.windowDic.allKeys) {
        id item = [viewManager.windowDic objectForKey:key];
        if ([object isEqual:item]) {
            NSLog(@"remove key:%@",key);
            [viewManager.windowDic removeObjectForKey:key];
            ret = YES;
            break;
        }
    }
    return ret;
}

- (void)dealloc {
    [_newiPod release],_newiPod = nil;
    [super dealloc];
}


@end

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
#import "IMBAboutWindowController.h"
#import "IMBSendLogWindowController.h"
#import "ATTracker.h"
#import "IMBLimitation.h"


@implementation AppDelegate
@synthesize infoDict = _infoDict;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:3 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:COpenOrClose action:AClose label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [ATTracker setupWithTrackingID:@"UA-85633510-4"];//UA-117271111-1(真实的)  UA-85633510-4（测试）
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:3 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:COpenOrClose action:AOpen label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *infoP = [[bundlePath stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Info.plist"];
    _infoDict = [[NSDictionary dictionaryWithContentsOfFile:infoP] mutableCopy];
    if ([[_infoDict allKeys] containsObject:@"IsFirstLaunch"]) {
        if ([[_infoDict objectForKey:@"IsFirstLaunch"] intValue] == 0) {
            [ATTracker event:COpenOrClose action:AFirstLaunch label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithObject:@"ja"] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Insert code here to initialize your application
    IMBViewManager *viewManager = [IMBViewManager singleton];
    viewManager.mainWindowController = [[IMBMainWindowController alloc] initWithWindowNibName:@"IMBMainWindowController"];
    [viewManager.mainWindowController.window setMinSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    [viewManager.mainWindowController.window setMaxSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
    [viewManager.mainWindowController showWindow:self];
    
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_global_queue(0, 0), ^{
//        //软件启动就自动检查是否有更新
//        [self checkForUpdateOnbackground];
//    });
    
    ProductMenuItem.title = CustomLocalizedString(@"Menu_Title", nil);
    AboutMenuItem.title = CustomLocalizedString(@"Menu_About", nil);
    CheckUpdate.title = CustomLocalizedString(@"Menu_Updates", nil);
    SendLogMenuItem.title = CustomLocalizedString(@"Menu_SendLog", nil);
    HideMenuItem.title = CustomLocalizedString(@"Menu_Hide", nil);
    hideOtherMenuItem.title = CustomLocalizedString(@"Menu_HideOthers", nil);
    showAllMenuItem.title = CustomLocalizedString(@"Menu_ShowAll", nil);
    quitMenuItem.title = CustomLocalizedString(@"Menu_Quit", nil);
    windowMenuItem.title = CustomLocalizedString(@"Menu_Window", nil);
    minimizeMenuItem.title = CustomLocalizedString(@"Menu_Minimize", nil);
    zoomMenuItem.title = CustomLocalizedString(@"Menu_Zoom", nil);
    bringAllToFrontMenuItem.title = CustomLocalizedString(@"Menu_BringAlltoFront", nil);
    helpMenuItem.title = CustomLocalizedString(@"Menu_Help", nil);
    HomeMenuItem.title = CustomLocalizedString(@"Menu_Home", nil);
    OnlineGuideMenuItem.title = CustomLocalizedString(@"Menu_Guide", nil);
    FAQMenuItem.title = CustomLocalizedString(@"Menu_FAQ", nil);
    SubmitRqMenuItem.title = CustomLocalizedString(@"Menu_Submit", nil);
    
    //初始化配置信息
    [[IMBLimitation sharedLimitation] initializeConfigurationInfo];
    [[IMBLimitation sharedLimitation] getRestNumsWithNum];
//    [[IMBLimitation sharedLimitation] saveRegisterStatus];
    [[IMBLimitation sharedLimitation] getRegisterStatus];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSString *appTempPath = [TempHelper getAppTempPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:appTempPath]) {
        [fm removeItemAtPath:appTempPath error:nil];
    }
    //这里要做限制的剩余个数存储
}

- (void)awakeFromNib {
    [IMBSoftWareInfo singleton];
    [IMBNotiCenter addObserver:self selector:@selector(saveFirstLaunch:) name:NOTIFY_FIRST_LAUNCH object:nil];
}

- (IBAction)aboutAnyTransMenuClick:(id)sender {
    IMBAboutWindowController *abouWd = [[IMBAboutWindowController alloc]initWithWindowNibName:@"IMBAboutWindowController"];
    NSWindow *mainWindow = [NSApp mainWindow];
    NSRect rect = mainWindow.frame;
    NSPoint point = mainWindow.frame.origin;
    float height = abouWd.window.frame.size.height;
    float width = abouWd.window.frame.size.width;
    [abouWd.window setFrameOrigin:NSMakePoint(point.x+(rect.size.width-width)/2, point.y+(rect.size.height-height)/2)];
    [NSApp runModalForWindow:[abouWd window]];
}

- (IBAction)checkUpdateMenuClick:(id)sender {
    [self showUpgradeWindow];
}

#pragma mark - check update
- (void)showUpgradeWindow {
    _hasCheckUpdateBymanual = YES;
    if (_checkUpdateController != nil) {
        [_checkUpdateController release];
        _checkUpdateController = nil;
    }
    _checkUpdateController = [[IMBUpgradeWindowController alloc] init];
    if (_checkUpdater) {
        [_checkUpdater release];
        _checkUpdater = nil;
    }
    _checkUpdater = [[IMBCheckUpdater alloc] initWithManual:YES];
    [_checkUpdater setListener:self];
    [_checkUpdater checkUpdate];
    NSModalSession session =  [NSApp beginModalSessionForWindow:[_checkUpdateController window]];
    NSInteger result = NSRunContinuesResponse;
    while ((result= [NSApp runModalSession:session]) == NSRunContinuesResponse) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    [self checkIfMustUpdate];
}

- (void)checkForUpdateOnbackground {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_checkUpdater) {
            [_checkUpdater release];
            _checkUpdater = nil;
        }
        _checkUpdater = [[IMBCheckUpdater alloc] initWithManual:NO];
        [_checkUpdater setListener:self];
        [_checkUpdater checkUpdate];
    });
}

- (void)showUpdatewindowByBackGround:(IMBUpdateInfo *)info {
    if (_checkUpdateController != nil) {
        [_checkUpdateController release];
        _checkUpdateController = nil;
    }
    _checkUpdateController = [[IMBUpgradeWindowController alloc] initWithUpdateInfo:info];
    [NSApp runModalForWindow:[_checkUpdateController window]];
}

- (void)UpdaterStatus:(UpdaterStatus)status UpdateInfo:(IMBUpdateInfo *)info Manual:(BOOL)isManual {
    if (isManual) {
        [_checkUpdateController updaterStatus:status UpdateInfo:info];
    } else {
        if (status == UpdaterStatus_Skip_Version && !_hasCheckUpdateBymanual && info.isauto == YES) {
            return;
        } else if (status == UpdaterStatus_HasUpdate && !_hasCheckUpdateBymanual && info.isauto == YES) {
            [self performSelectorOnMainThread:@selector(showUpdatewindowByBackGround:) withObject:info waitUntilDone:NO];
        } else {
            BOOL result = [self checkIfMustUpdate];
            if (result) {
                [self performSelectorOnMainThread:@selector(showUpdatewindowByBackGround:) withObject:info waitUntilDone:NO];
            }
        }
    }
}

- (BOOL)checkIfMustUpdate {
    //检查当前是否是必须更新，如果是则回到设备未链接界面。
    IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
    if (software.mustUpdate) {
        return YES;
    }
    return NO;
}

- (void)saveFirstLaunch:(NSNotification *)obj {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *infoP = [[bundlePath stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Info.plist"];
    [_infoDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsFirstLaunch"];
    [_infoDict writeToFile:infoP atomically:YES];
}

- (IBAction)sendLogMenuClick:(id)sender {
    IMBSendLogWindowController *abouWd = [[IMBSendLogWindowController alloc] initWithWindowNibName:@"IMBSendLogWindowController"];
    NSWindow *mainWindow = [NSApp mainWindow];
    NSRect rect = mainWindow.frame;
    NSPoint point = mainWindow.frame.origin;
    float height = abouWd.window.frame.size.height;
    float width = abouWd.window.frame.size.width;
    [abouWd.window setFrameOrigin:NSMakePoint(point.x+(rect.size.width-width)/2, point.y+(rect.size.height-height)/2)];
    [NSApp runModalForWindow:[abouWd window]];
}

- (IBAction)submitRequestMenuClick:(id)sender {
    NSString *submitStr = CustomLocalizedString(@"submit_request", nil);
    if (!([submitStr containsString:@"http:"] || [submitStr containsString:@"https:"])) {
        submitStr = [NSString stringWithFormat:@"https://%@",submitStr];
    }
    NSURL *url = [NSURL URLWithString:submitStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)anyTransHomeMenuClick:(id)sender {
    NSURL *url = nil;
    url = [NSURL URLWithString:CustomLocalizedString(@"anytrans_common_home", nil)];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)onlineGuideMenuClick:(id)sender {
    NSURL *url = nil;
    url = [NSURL URLWithString:CustomLocalizedString(@"allfiles_guide", nil)];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)doFAQ:(id)sender {
    NSString *FAQStr = CustomLocalizedString(@"FAQ_Url", nil);
    NSURL *url = [NSURL URLWithString:FAQStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)dealloc {
    self.infoDict = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_FIRST_LAUNCH object:nil];
    [super dealloc];
}


@end

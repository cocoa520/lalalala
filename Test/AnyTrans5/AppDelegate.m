//
//  AppDelegate.m
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "AppDelegate.h"
#import "IMBDeviceConnection.h"
#import "IMBMainWindowController.h"
#import "IMBBackupManager.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBAboutWindowController.h"
#import "IMBChooseLanguagesWindowController.h"
#import "IMBUpgradeWindowController.h"
#import "IMBSendLogFile.h"
#import "IMBLogManager.h"
#import "MediaHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBPreferencesSettingWindowController.h"
#import "OperationLImitation.h"
#import "IMBAlertViewController.h"
#import "NSString+Category.h"
#import <ServiceManager/ServiceManager.h>
#import "ATTracker.h"
#import "CommonEnum.h"
#import "NSDictionary+Category.h"
#import "IMBSendLogWindowController.h"
#import "SystemHelper.h"
#import "IMBSocketClient.h"

#import "ZLMainWindowController.h"

@implementation AppDelegate
@synthesize deviceSettingMenuItem;
@synthesize ProductMenuItem;
@synthesize AboutMenuItem;
@synthesize LanguageMenuItem;
@synthesize CheckUpdate;
@synthesize SendLogMenuItem;
@synthesize restoreMenuItem;
@synthesize HideMenuItem;
@synthesize hideOtherMenuItem;
@synthesize showAllMenuItem;
@synthesize quitMenuItem;
@synthesize editMenuItem;
@synthesize undoMenuItem;
@synthesize redoMenuItem;
@synthesize cutMenuItem;
@synthesize copyMenuitem;
@synthesize pasteMenuItem;
@synthesize pasteMatchMenuItem;
@synthesize deleteMenuItem;
@synthesize selectAllMenuItem;
@synthesize windowMenuItem;
@synthesize minimizeMenuItem;
@synthesize zoomMenuItem;
@synthesize bringAllToFrontMenuItem;
@synthesize helpMenuItem;
@synthesize HomeMenuItem;
@synthesize OnlineGuideMenuItem;
@synthesize FacebookMenuItem;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    PFMoveToApplicationsFolderIfNecessary();
//
//    [ATTracker setupWithTrackingID:@"UA-85655135-1"];//UA-85655135-1   UA-85633510-3(测试)  UA-84363639-1
//    NSDictionary *dimensionDict = nil;
//    @autoreleasepool {
//        dimensionDict = [[TempHelper customDimension] copy];
//    }
//    [ATTracker event:AnyTrans_OpenOrClose action:ActionNone actionParams:@"Open" label:Open transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString *infoP = [[bundlePath stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Info.plist"];
//    NSMutableDictionary *infoDict = [[NSDictionary dictionaryWithContentsOfFile:infoP] mutableCopy];
//    if ([[infoDict allKeys] containsObject:@"IsFirstLaunch"]) {
//        if ([[infoDict objectForKey:@"IsFirstLaunch"] intValue] == 0) {
//            [infoDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsFirstLaunch"];
//            [infoDict writeToFile:infoP atomically:YES];
//            [ATTracker event:AnyTrans_OpenOrClose action:ActionNone actionParams:@"First Launch" label:FirstLaunch transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
//        }
//    }
//    if (dimensionDict) {
//        [dimensionDict release];
//        dimensionDict = nil;
//    }
    
    // 程序入口
//    id notfirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"first_launch"];
//    if (notfirst == nil) {
//        IMBChooseLanguagesWindowController *chooseLanguagesWindow = [[IMBChooseLanguagesWindowController alloc]init];
//        [chooseLanguagesWindow.window center];
//        [NSApp runModalForWindow:chooseLanguagesWindow.window];
//        [chooseLanguagesWindow  release];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"first_launch"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    _mainWindowController = [[ZLMainWindowController alloc] initWithWindowNibName:@"ZLMainWindowController"];
    [[_mainWindowController window] center];
//    [[_mainWindowController window] orderFront:nil];
    [_mainWindowController showWindow:nil];
}


-(void)dealloc {
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ENTER_CHANGELAGUG_IPOD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}



- (void)awakeFromNib {
//    logHandle = [IMBLogManager singleton];
//    [logHandle writeInfoLog:@"Product Start!!!"];
//    
//    //启动守护进程
//    [SystemHelper createLaunchDaemon];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIpod:) name:NOTIFY_CHANGE_IPOD object:nil];
}

-(void)getIpod:(NSNotification *)notification{
    IMBDeviceConnection *deviceConntection = [IMBDeviceConnection singleton];
    NSMutableArray *ary = [deviceConntection getAllDevice];
//    if (ary.count >0 &&_mainWindowController.curFunctionType == DeviceModule) {
//        [deviceSettingMenuItem setEnabled:YES];
//        [deviceSettingMenuItem.menu setAutoenablesItems:YES];
//    }else {
//        [deviceSettingMenuItem setEnabled:NO];
//        [deviceSettingMenuItem.menu setAutoenablesItems:NO];
//    }
}


@end

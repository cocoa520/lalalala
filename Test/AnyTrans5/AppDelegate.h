//
//  AppDelegate.h
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBMainWindowController;
@class IMBUpgradeWindowController;
@class IMBLogManager;
#import "IMBCheckUpdater.h"
#import "IMBiPod.h"
#import "IMBDownloadFile.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,IMBDownLoadProgress>
{
    IMBMainWindowController *_mainWindowController;

    NSMenu *ProductMenuItem;
    NSMenuItem *AboutMenuItem;
    NSMenuItem *LanguageMenuItem;
    NSMenuItem *CheckUpdate;
    NSMenuItem *SendLogMenuItem;
    NSMenuItem *restoreMenuItem;
    NSMenuItem *HideMenuItem;
    NSMenuItem *hideOtherMenuItem;
    NSMenuItem *showAllMenuItem;
    NSMenuItem *quitMenuItem;
    NSMenu *editMenuItem;
    NSMenuItem *undoMenuItem;
    NSMenuItem *redoMenuItem;
    NSMenuItem *cutMenuItem;
    NSMenuItem *copyMenuitem;
    NSMenuItem *pasteMenuItem;
    NSMenuItem *pasteMatchMenuItem;
    NSMenuItem *deleteMenuItem;
    NSMenuItem *selectAllMenuItem;
    NSMenu *windowMenuItem;
    NSMenuItem *minimizeMenuItem;
    NSMenuItem *zoomMenuItem;
    NSMenuItem *bringAllToFrontMenuItem;
    NSMenu *helpMenuItem;
    NSMenuItem *HomeMenuItem;
    NSMenuItem *OnlineGuideMenuItem;
    NSMenuItem *FacebookMenuItem;
    IBOutlet NSMenuItem *chooseThemeMenuItem;
    IBOutlet NSMenuItem *FAQMenuItem;
    IBOutlet NSMenuItem *tologMenuItem;

    BOOL _hasCheckUpdateBymanual;
    IMBUpgradeWindowController *_checkUpdateController;
    IMBLogManager *logHandle;
    NSMenuItem *deviceSettingMenuItem;
    IMBiPod *_iPod;
    
    IMBDownloadFile *_downloadFile;
    IMBCheckUpdater *_checkUpdater;
}
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenuItem *deviceSettingMenuItem;

@property (assign) IBOutlet NSMenu *ProductMenuItem;
@property (assign) IBOutlet NSMenuItem *AboutMenuItem;
@property (assign) IBOutlet NSMenuItem *LanguageMenuItem;
@property (assign) IBOutlet NSMenuItem *CheckUpdate;
@property (assign) IBOutlet NSMenuItem *SendLogMenuItem;
@property (assign) IBOutlet NSMenuItem *restoreMenuItem;
@property (assign) IBOutlet NSMenuItem *HideMenuItem;
@property (assign) IBOutlet NSMenuItem *hideOtherMenuItem;
@property (assign) IBOutlet NSMenuItem *showAllMenuItem;
@property (assign) IBOutlet NSMenuItem *quitMenuItem;
@property (assign) IBOutlet NSMenu *editMenuItem;
@property (assign) IBOutlet NSMenuItem *undoMenuItem;
@property (assign) IBOutlet NSMenuItem *redoMenuItem;
@property (assign) IBOutlet NSMenuItem *cutMenuItem;
@property (assign) IBOutlet NSMenuItem *copyMenuitem;
@property (assign) IBOutlet NSMenuItem *pasteMenuItem;
@property (assign) IBOutlet NSMenuItem *pasteMatchMenuItem;
@property (assign) IBOutlet NSMenuItem *deleteMenuItem;
@property (assign) IBOutlet NSMenuItem *selectAllMenuItem;
@property (assign) IBOutlet NSMenu *windowMenuItem;
@property (assign) IBOutlet NSMenuItem *minimizeMenuItem;
@property (assign) IBOutlet NSMenuItem *zoomMenuItem;
@property (assign) IBOutlet NSMenuItem *bringAllToFrontMenuItem;
@property (assign) IBOutlet NSMenu *helpMenuItem;
@property (assign) IBOutlet NSMenuItem *HomeMenuItem;
@property (assign) IBOutlet NSMenuItem *OnlineGuideMenuItem;
@property (assign) IBOutlet NSMenuItem *FacebookMenuItem;
@end

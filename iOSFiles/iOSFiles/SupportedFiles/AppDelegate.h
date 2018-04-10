//
//  AppDelegate.h
//  iOS File
//
//  Created by 龙凡 on 2018/1/15.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBMainWindowController.h"
#import "IMBUpgradeWindowController.h"
#import "IMBCheckUpdater.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    IBOutlet NSMenu *ProductMenuItem;
    IBOutlet NSMenuItem *AboutMenuItem;
    IBOutlet NSMenuItem *CheckUpdate;
    IBOutlet NSMenuItem *SendLogMenuItem;
    IBOutlet NSMenuItem *SubmitRqMenuItem;
    IBOutlet NSMenuItem *FAQMenuItem;
    IBOutlet NSMenuItem *HideMenuItem;
    IBOutlet NSMenuItem *hideOtherMenuItem;
    IBOutlet NSMenuItem *showAllMenuItem;
    IBOutlet NSMenuItem *quitMenuItem;
    
    IBOutlet NSMenu *editMenuItem;
    
    IBOutlet NSMenu *windowMenuItem;
    IBOutlet NSMenuItem *minimizeMenuItem;
    IBOutlet NSMenuItem *zoomMenuItem;
    IBOutlet NSMenuItem *bringAllToFrontMenuItem;
    
    IBOutlet NSMenu *helpMenuItem;
    IBOutlet NSMenuItem *HomeMenuItem;
    IBOutlet NSMenuItem *OnlineGuideMenuItem;
    
    BOOL _hasCheckUpdateBymanual;
    IMBUpgradeWindowController *_checkUpdateController;
    IMBCheckUpdater *_checkUpdater;
    
    IMBLogManager *_logHandle;
    NSMutableDictionary *_infoDict;
   
}

@property (nonatomic, readwrite, retain) NSMutableDictionary *infoDict;
@property (assign) IBOutlet NSWindow *window;
@end


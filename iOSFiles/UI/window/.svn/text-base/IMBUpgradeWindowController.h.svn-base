//
//  IMBUpgradeWindowController.h
//  DataRecovery
//
//  Created by Pallas on 6/4/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "IMBCheckUpdater.h"
#import "IMBSoftWareInfo.h"
#import "IMBGridientButton.h"

@class IMBUpdateInfo;

@interface IMBUpgradeWindowController : NSWindowController <NSWindowDelegate> {
@private
    IBOutlet NSImageView *logoIconImgView;
    
    IBOutlet IMBWhiteView *updateBottom;
    IBOutlet NSTextField *_mainTitle;
    IBOutlet NSTextField *lbCurrVersion;
    IBOutlet NSScrollView *textScrollView;
    IBOutlet NSTextView *_UpdateTextView;

    IBOutlet IMBGridientButton *btnSkipUpdate;
    IBOutlet IMBGridientButton *btnRemindLater;
    IBOutlet IMBGridientButton *btnUpdateNow;
    
    IMBUpdateInfo *_updateInfo;
    IMBSoftWareInfo *softInfo;
    NSButton *settingBtn;
    NSButton *settingBtn1;
    NSButton *installBtn;
    IBOutlet IMBWhiteView *_middleView;
}

- (id)initWithUpdateInfo:(IMBUpdateInfo*)info;

- (void)updaterStatus:(UpdaterStatus)status UpdateInfo:(IMBUpdateInfo *)info;

@end

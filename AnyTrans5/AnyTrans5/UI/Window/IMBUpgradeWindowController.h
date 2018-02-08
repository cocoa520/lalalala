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
#import "IMBGeneralButton.h"
@class IMBUpdateInfo;

@class IMBSoftWareInfo;

@interface IMBUpgradeWindowController : NSWindowController <NSWindowDelegate> {
@private
    IBOutlet NSImageView *topBgImgView;
    IBOutlet NSImageView *logoIconImgView;
    IBOutlet NSImageView *logoTextImgView;
    
    IBOutlet IMBWhiteView *updateBottom;
    IBOutlet NSTextField *_mainTitle;
    IBOutlet NSTextField *lbCurrVersion;
    IBOutlet NSScrollView *textScrollView;
    IBOutlet NSTextView *_UpdateTextView;

    IBOutlet IMBGeneralButton *btnSkipUpdate;
//    IMBGeneralButton *btnSkipUpdate;
//    NSButton *btnRemindLater;
//    NSButton *btnUpdateNow;
    IBOutlet IMBGeneralButton *btnRemindLater;
    IBOutlet IMBGeneralButton *btnUpdateNow;
    
    IMBUpdateInfo *_updateInfo;
    IMBSoftWareInfo *softInfo;
//    IBOutlet NSButton *_skipTheVersionBtn;
//    IBOutlet NSButton *_remindMeLaterBtn;
//    IBOutlet NSButton *_updateNowBtn;
    NSButton *settingBtn;
    NSButton *settingBtn1;
    NSButton *installBtn;
    IBOutlet IMBWhiteView *_middleView;
}

- (id)initWithUpdateInfo:(IMBUpdateInfo*)info;

- (void)updaterStatus:(UpdaterStatus)status UpdateInfo:(IMBUpdateInfo *)info;

@end

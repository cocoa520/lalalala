//
//  IMBSendLogWindowController.h
//  PhoneRescue_Android
//
//  Created by long on 5/23/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBGridientButton.h"
#import "IMBLogManager.h"
#import "IMBWhiteView.h"
#import "IMBCheckBtn.h"
#import "IMBDottedlLineView.h"

@interface IMBSendLogWindowController : NSWindowController
{
    IBOutlet NSTextField *_titleStr;
    IBOutlet NSTextField *_middleTitleStr;
    IBOutlet NSTextField *_bottomTextStr;
    IBOutlet IMBGridientButton *_canCelBtn;
    IBOutlet IMBGridientButton *_sendLogBtn;
    NSString *_logFolderPath;
    NSFileManager *fm;
    IMBLogManager *logHandle;
    NSString *_sendLogZipPath;
    IBOutlet IMBCheckBtn *_checkBoxBtn;
    IBOutlet NSTextField *_checkTitleStr;
    IBOutlet IMBDottedlLineView *_dottedLineView;
    IBOutlet NSTextField *_loadingString;
    IBOutlet NSImageView *_loadingImg;

    IBOutlet NSView *_loadingView;
}

@end

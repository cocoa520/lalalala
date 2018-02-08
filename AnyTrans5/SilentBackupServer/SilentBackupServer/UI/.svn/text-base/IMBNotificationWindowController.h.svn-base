//
//  IMBNotificationWindowController.h
//  AirBackupHelper
//
//  Created by iMobie on 10/19/17.
//  Copyright (c) 2017 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBGridientButton;
@class IMBGeneralButton;
@class IMBWhiteView;
@class IMBUnlockView;


@interface IMBNotificationWindowController : NSWindowController {
    
    IBOutlet IMBWhiteView *_firstView;
    IBOutlet NSTextField *_firstTitle;
    
    IBOutlet IMBWhiteView *_secondView;
    IBOutlet NSTextField *_secondSubTitle;
    IBOutlet IMBGridientButton *_secondUnlockBtn;
    
    IBOutlet IMBWhiteView *_thirdView;
    IBOutlet NSTextField *_thirdTitle;
    IBOutlet NSTextField *_thirdSubTitle;
    IBOutlet NSTextField *_thirdBtnLabel;
    IBOutlet IMBUnlockView *_thirdBtn;
    
    IBOutlet IMBWhiteView *_backUpView;
    IBOutlet NSTextField *_backupTitle;
    IBOutlet IMBGeneralButton *_backupOKBtn;
    
    IBOutlet IMBWhiteView *_fourView;
    IBOutlet NSTextField *_fourTitle;
    IBOutlet NSTextField *_fourSubTitle;
    IBOutlet NSTextField *_fourBtnLabel;
    IBOutlet IMBUnlockView *_fourBtn;
    
    BOOL _isShow;
    BOOL _isClosePrompt;
    NSString *_title;
    NSString *_prompt;
    int _currentMode;
    NSRect _mainRect;
}

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *prompt;
@property(nonatomic, readwrite) BOOL isShow;
@property(nonatomic, readwrite) BOOL isClosePrompt;

- (id)initWithRect:(NSRect)mainRect;

- (void)setCureentMode:(int)mode;
- (IBAction)close:(id)sender;
- (void)loadWindowWord:(NSString *)title withPrompt:(NSString *)prompt withMode:(int)mode;

@end

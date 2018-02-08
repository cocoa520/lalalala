//
//  IMBBackupAnimationViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/9/2.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBScreenClickView.h"
#import "IMBWhiteView.h"
#import "BackupViewAnimation.h"
#import "IMBAnimateProgressBar.h"
#import "IMBMyDrawCommonly.h"
#import "HoverButton.h"
#import "IMBiPod.h"
#import "IMBAlertViewController.h"
#import "IMBBackAndRestore.h"

@interface IMBBackupAnimationViewController : NSViewController
{
    IBOutlet IMBScreenClickView *_backupProView;
    IBOutlet IMBWhiteView *_contentView;
    IBOutlet BackupViewAnimation *_backupAnimationView;
    IBOutlet NSBox *_backupViewProgressView;
    
    IBOutlet NSView *_backupProgressView;
    IBOutlet NSTextField *_titleStr;
    IBOutlet NSTextField *_backUpProgressLable;
    IBOutlet IMBAnimateProgressBar *_animateProgressView;
    IBOutlet NSTextField *_promptLabel;
    IBOutlet NSImageView *_noteImageView;
    IBOutlet NSView *_backupCompleteView;
    IBOutlet NSTextField *_backupCompleteViewTitel;
    IBOutlet IMBMyDrawCommonly *_toBackupPathBtn;
    IBOutlet NSImageView *_roseProgressBgImageView;
    IBOutlet NSImageView *_bellImgView;
    
    IMBAlertViewController *_alertViewController;
    
    double _backupProgress;
    BOOL _isCanceled;
    BOOL _isError;
    BOOL _isProgressStard;
    BOOL _isOkAction;
    IMBBackAndRestore *_backRestore;
    
    HoverButton *_closebutton;
    BOOL _isBackupComplete;
    IMBiPod *_ipod;
    int _tag;
}
@property (nonatomic, assign) int tag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Withipod:(IMBiPod *)ipod withViewTag:(int)tag;
- (void)startBackupDevice;
-(void)secireOkBtnOperation:(id)sender with:(NSString *)pass;
- (void)doOkBtnOperation:(id)sender;

@end

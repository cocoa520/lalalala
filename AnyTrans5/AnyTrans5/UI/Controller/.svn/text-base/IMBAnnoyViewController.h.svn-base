//
//  IMBAnnoyViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-9-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBMonitorBtn.h"
#import "AnnoyAnimationViewOne.h"
#import "IMBDrawArcView.h"
#import "IMBAlertViewController.h"
#import "HoverButton.h"
#import "AnnoyAnimationViewTwo.h"
#import "AnnoyAnimationViewThree.h"
#import "OperationLImitation.h"
#import "AnnoyAnimationViewFour.h"
@interface IMBAnnoyViewController : NSViewController
{
    IBOutlet NSImageView *_freeTry;
    IBOutlet NSView *_animtionBGView;
    IBOutlet NSView *_nextBg;
    IBOutlet NSTextField *_freeTryTextField;
    IBOutlet HoverButton *nextButton;
    IBOutlet IMBDrawArcView *countdownView;
    IBOutlet AnnoyAnimationViewFour *_annoyAnimaitonViewFour;
    IBOutlet AnnoyAnimationViewOne *_annoyAnimaitonView;
    IBOutlet AnnoyAnimationViewTwo *_annoyAnimationViewTwo;
    IBOutlet AnnoyAnimationViewThree *_annoyAnimationViewThree;
    IBOutlet IMBWhiteView *_backGroundView;
    IBOutlet NSTextField *_annoyTitleField;
    IBOutlet NSTextField *_annoySubTilteField;
    IBOutlet IMBMonitorBtn *_registerButton;
    IBOutlet IMBMonitorBtn *_buyNowButton;
    IBOutlet NSView *_buttonBG;
    //圣诞节
    IBOutlet NSView *_annoyAnimaitonViewFive;
    IBOutlet NSImageView *_annoyBgFive;
    //感恩节
    IBOutlet NSView *_annoyAnimaitonViewSix;
    IBOutlet NSImageView *_annoyBgSix;
    
    IMBAlertViewController *_alertViewController;
    id _delegate;
    long long *_result;
    OperationLImitation *_limitation;
    BOOL _isClone;
    BOOL _isMerge;
    BOOL _isContentToMac;
    BOOL _isAddContent;
    CategoryNodesEnum _category;
}
@property (nonatomic,assign)BOOL isClone;
@property (nonatomic,assign)BOOL isMerge;
@property (nonatomic,assign)BOOL isContentToMac;
@property (nonatomic,assign)BOOL isAddContent;
@property (nonatomic,assign)CategoryNodesEnum category;

- (IBAction)registerAction:(id)sender;
- (IBAction)buyNow:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil Delegate:(id)delegate Result:(long long*)reslut;
- (void)closeWindow:(id)sender;
@end

//
//  IMBNewAnnoyViewController.h
//  AnyTrans
//
//  Created by iMobie on 3/24/18.
//  Copyright (c) 2018 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "IMBGridientButton.h"
#import "IMBCanClickText.h"
#import "OperationLImitation.h"
#import "IMBGradientTextField.h"
#import "IMBPopoverActivateViewController.h"
@interface IMBNewAnnoyViewController : NSViewController<NSTextViewDelegate> {
    id _delegate;
    long long *_result;
    OperationLImitation *_limitation;
    BOOL _isClone;
    BOOL _isMerge;
    BOOL _isContentToMac;
    BOOL _isAddContent;
    CategoryNodesEnum _category;
    
    NSPopover *_activatePopover;
    IMBPopoverActivateViewController *_popoverViewController;
    
    IBOutlet NSBox *_contentBox;
    //传输开始时的骚扰界面
    IBOutlet IMBWhiteView *_transferStartAnnoyView;
    IBOutlet NSTextField *_transferStartTitleLable;
    IBOutlet IMBWhiteView *_transferStartLineView;
    IBOutlet IMBWhiteView *_transferStartBotLineView;
    IBOutlet NSTextField *_transferStartPromptLable;
    IBOutlet NSTextField *_transferStartExplainLable1;
    IBOutlet NSTextField *_transferStartExplainLable2;
    IBOutlet NSTextField *_transferStartExplainLable3;
    IBOutlet NSTextField *_transferStartExplainLable4;
    IBOutlet NSTextField *_transferStartExplainSubLable1;
    IBOutlet NSTextField *_transferStartExplainSubLable2;
    IBOutlet NSTextField *_transferStartExplainSubLable3;
    IBOutlet NSTextField *_transferStartExplainSubLable4;
    IBOutlet IMBGridientButton *_transferStartBuyBtn;
    
    //当天额度用完的骚扰界面
    IBOutlet IMBWhiteView *_runOutDayAnnoyView;
    IBOutlet NSTextField *_runOutDayTitleLable;
    IBOutlet NSTextField *_runOutDaySubTitleLable;
    IBOutlet IMBWhiteView *_runOutDayBgView;
    IBOutlet IMBCanClickText *_runOutDayActiveTextView;
    IBOutlet IMBGridientButton *_runOutDayStartBuyBtn;
    IBOutlet NSTextField *_runOutDayExplainLable1;
    IBOutlet NSTextField *_runOutDayExplainLable2;
    IBOutlet NSTextField *_runOutDayExplainLable3;
    IBOutlet NSTextField *_runOutDayExplainLable4;
    
    //到期的骚扰界面
    IBOutlet IMBWhiteView *_expireAnnoyView;
    IBOutlet NSTextField *_expireViewMainTitle;
    IBOutlet NSTextField *_expireViewSubtitle;
    IBOutlet IMBGradientTextField *_expireViewNumberTextFiled;
    IBOutlet IMBGridientButton *_expireViewBuyBtn;
}
@property (nonatomic,assign)BOOL isClone;
@property (nonatomic,assign)BOOL isMerge;
@property (nonatomic,assign)BOOL isContentToMac;
@property (nonatomic,assign)BOOL isAddContent;
@property (nonatomic,assign)CategoryNodesEnum category;

- (id)initWithNibName:(NSString *)nibNameOrNil Delegate:(id)delegate Result:(long long*)reslut;
- (void)closeWindow:(id)sender;

@end

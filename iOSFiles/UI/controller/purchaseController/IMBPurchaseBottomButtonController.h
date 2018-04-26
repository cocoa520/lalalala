//
//  IMBPurchaseBottomButtonController.h
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBGridientButton;

@interface IMBPurchaseBottomButtonController : NSViewController
{
    IBOutlet NSButton *_toActiveViewBtn;
    
    IBOutlet NSView *_topView;
    IBOutlet IMBGridientButton *_purchaseButton;
    IBOutlet NSTextField *_msgLabel;
    IBOutlet NSTextField *_titleLabel;
    IBOutlet NSTextField *_messageLabel;
    
    NSString *_purchaseButtonTitle;
    
}

@property(nonatomic, retain)NSView *topView;
@property(nonatomic, retain)IMBGridientButton *purchaseButton;
@property(nonatomic, retain)NSTextField *msgLabel;
@property(nonatomic, retain)NSTextField *titleLabel;
@property(nonatomic, retain)NSTextField *messageLabel;
@property(nonatomic, retain)NSButton *toActiveViewBtn;

@property(nonatomic, copy)NSString *purchaseButtonTitle;

@property(nonatomic, copy) void(^btnClicked)(void);
@property(nonatomic, copy) void(^toActiveViewBtnClicked)(void);

@end

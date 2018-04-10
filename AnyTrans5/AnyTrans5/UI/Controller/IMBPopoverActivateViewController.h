//
//  IMBPopoverActivateViewController.h
//  AnyTrans
//
//  Created by iMobie on 3/27/18.
//  Copyright (c) 2018 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "customTextFiled.h"
#import "IMBGeneralButton.h"

@interface IMBPopoverActivateViewController : NSViewController<NSTextViewDelegate> {
    IBOutlet IMBWhiteView *_inputTextFiledBgView;
    IBOutlet customTextFiled *_inputTextFiled;
    IBOutlet IMBGeneralButton *_activeBtn;
    IBOutlet NSTextView *_registerLabel;
    IBOutlet NSView *_activateReslutView;
    IBOutlet NSImageView *_activateRelustImageView;
    IBOutlet NSScrollView *_activateRelustScrollview;
    IBOutlet NSTextField *_titleLable;
    
    CALayer *_loadingLayer;
    BOOL _isSucess;
    id _delegate;
}
- (id)initWithDelegate:(id)delegate;

@end

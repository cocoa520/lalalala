//
//  IMBOpenUSBDeugViewController.h
//  PhoneRescue_Android
//
//  Created by m on 17/5/8.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBAlertViewController.h"

@class IMBWhiteView;
@class IMBLackCornerView;
@interface IMBOpenUSBDeugViewController : IMBBaseViewController<NSTextViewDelegate>

{
    IBOutlet IMBLackCornerView *_rootView;
    IBOutlet NSTextField *_mainTitle;
    IBOutlet IMBWhiteView *_topLineView;
    IBOutlet NSImageView *_stepImageView;
    IBOutlet NSTextField *_firstStepTitle;
    IBOutlet NSImageView *_firstStepImageView;
    IBOutlet NSTextField *_secondStepTitle;
    IBOutlet NSImageView *_secondStepImageView;
    IBOutlet NSTextField *_thirdStepTitle;
    IBOutlet NSImageView *_thirdStepImageView;
    IBOutlet NSTextField *_fourthStepTitle;
    IBOutlet NSImageView *_fourthStepImageView;
    IBOutlet NSTextField *_fifthStepTitle;
    IBOutlet NSImageView *_fifthStepImageView;
    IBOutlet IMBWhiteView *_bottomLineView;
    IBOutlet NSTextView *_warningTextView;
    IBOutlet NSTextView *_warningTextView1;
    
    IBOutlet NSScrollView *_warningScrollView;
    IBOutlet NSScrollView *_warningScrollView1;
    float _textHeight;
}





@end

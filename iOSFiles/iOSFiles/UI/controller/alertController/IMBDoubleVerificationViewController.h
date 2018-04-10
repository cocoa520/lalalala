//
//  IMBDoubleVerificationViewController.h
//  AllFiles
//
//  Created by iMobie on 2018/4/2.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBMyDrawCommonly,IMBBorderRectAndColorView,IMBCodeTextField,IMBCanClickText,IMBWhiteView;

@interface IMBDoubleVerificationViewController : NSViewController
{
    @private
    IBOutlet IMBMyDrawCommonly *_cancelbtn;
    IBOutlet IMBMyDrawCommonly *_okBtn;
    
    //双重验证
//    IBOutlet IMBBorderRectAndColorView *_doubleVerificaView;
    IBOutlet NSTextField *_doubleVerificaTitle;
    IBOutlet NSTextField *_doubleVerificaSubTitle;
    IBOutlet NSTextField *_doubleVerificaVerfiyTitle;
    IBOutlet IMBCodeTextField *_doubleVerificaFirstNum;
    IBOutlet IMBCodeTextField *_doubleVerificaSecondNum;
    IBOutlet IMBCodeTextField *_doubleVerificaThirdNum;
    IBOutlet IMBCodeTextField *_doubleVerificaFourthNum;
    IBOutlet IMBCodeTextField *_doubleVerificaFifthNum;
    IBOutlet IMBCodeTextField *_doubleVerificaSixthNum;
    IBOutlet NSScrollView *_doubleVerificaScrollView;
    IBOutlet IMBCanClickText *_doubleVerificaTextView;
    IBOutlet NSScrollView *_doubleVerificaSendCodeScrollView;
    IBOutlet IMBCanClickText *_doubleVerificaSendCodeTextView;
    IBOutlet NSScrollView *_doubleVerificaSendmsgScrollView;
    IBOutlet NSScrollView *_doubleVerificaHelpScrollView;
    IBOutlet IMBCanClickText *_doubleVerificaHelpTextView;
    IBOutlet IMBCanClickText *_doubleVerificaSendmsgTextView;
    IBOutlet IMBWhiteView *_numBox1;
    IBOutlet IMBWhiteView *_numBox2;
    IBOutlet IMBWhiteView *_numBox3;
    IBOutlet IMBWhiteView *_numBox4;
    IBOutlet IMBWhiteView *_numBox5;
    IBOutlet IMBWhiteView *_numBox6;
    IBOutlet IMBWhiteView *_loadingBgView;
    CALayer *_imageLayer;
    
}

#pragma mark - 按钮点击

@property(nonatomic, copy)void(^okClicked)(NSString *codeId);
@property(nonatomic, copy)void(^cancelClicked)(void);

@end

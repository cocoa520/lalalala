//
//  IMBLoginViewController.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/8.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBGridientButton.h"
#import "IMBCheckButton.h"
#import "IMBCustomTextFiled.h"
#import "IMBSecireTextField.h"
#import "IMBWhiteView.h"
#import "IMBCanClickText.h"
#import "IMBCreateAccountTable.h"
#import "IMBLoginButton.h"
#import "IMBCodeTextField.h"
#import "IMBBackAnimationButton.h"

@class IMBLoginAnimationButton;
@class IMBShadowView;
@class IMBScrollView;
@class IMBImageAndColorButton;
@interface IMBLoginViewController : NSViewController<NSTextViewDelegate> {
    BOOL _viewModle;  ///判断是登录/注册界面；YES是注册界面、NO是登录界面
    BOOL _isTwoAfc;
    id _delegate;
    IMBCreateAccountTable *_accounttable;
    NSNotificationCenter *_nc;
    
    IBOutlet NSBox *_contentBox;
#pragma mark - 登录页面view
    IBOutlet NSView *_loginView;
    IBOutlet NSTextField *_loginTitle;
    IBOutlet IMBLoginButton *_signInButton;
    IBOutlet IMBCheckButton *_checkButton;
    IBOutlet NSView *_loginAnimationView;
    IBOutlet NSTextField *_rememberTextField;
    IBOutlet IMBSecireTextField *_secireTextField;
    IBOutlet IMBCustomTextFiled *_accountTextField;
    IBOutlet IMBImageAndColorButton *_accoutChooseBtn;
    IBOutlet IMBWhiteView *_oneLineView;
    IBOutlet IMBWhiteView *_twoLineView;
    IBOutlet IMBWhiteView *_threeLineView;
    IBOutlet NSTextField *_loginPwdErrorLable;
    IBOutlet NSTextField *_otherPromptTextField;
    IBOutlet IMBWhiteView *_otherPromptView;
    IBOutlet IMBGridientButton *_forgetButton;
    IBOutlet NSView *_accountAndSecireView;
    IBOutlet IMBShadowView *_chooseAccountView;
    IBOutlet IMBScrollView *_chooseAccountScrollView;
    IBOutlet NSTextField *_loginAccountErrorLable;

#pragma mark - 注册页面view
    IBOutlet NSView *_rigistrationView;
    IBOutlet IMBWhiteView *_rigOneLineView;
    IBOutlet IMBWhiteView *_rigTwoLineView;
    IBOutlet IMBWhiteView *_rigThreeLineView;
    IBOutlet IMBWhiteView *_rigFourLineView;
    IBOutlet NSTextField *_rigOtherPromptTextField;
    IBOutlet IMBWhiteView *_rigOtherPromptView;
    IBOutlet NSTextField *_rigistrationTitle;
    IBOutlet IMBLoginButton *_createButton;
    IBOutlet IMBSecireTextField *_rigSecireTextField;
    IBOutlet IMBCustomTextFiled *_rigPwdSecireTextField;
    IBOutlet IMBSecireTextField *_rigConfirmSecireTextField;
    IBOutlet IMBCustomTextFiled *_rigPwdConfirmSecireTextField;
    IBOutlet IMBCustomTextFiled *_rigAccountTextField;
    IBOutlet NSTextField *_accountError;
    IBOutlet NSTextField *_passWordError;
    IBOutlet NSTextField *_passwordVerificationError;
    BOOL _isRigSecireMode; ///第一个密码框是否显示密码
    BOOL _isConfirmSecireMode;///第二个密码框是否显示密码
    BOOL _isClickSecireMode;///判断是否是在显示密码状态内
    BOOL _isMouseDown;
    
#pragma mark - 底部view
    IBOutlet NSView *_bottomView;
    IBOutlet IMBLoginAnimationButton *_googleBtn;
    IBOutlet IMBLoginAnimationButton *_facebookBtn;
    IBOutlet IMBLoginAnimationButton *_tiwtterBtn;
    IBOutlet NSScrollView *_textScrollView;
    IBOutlet IMBCanClickText *_botTextView;
    
#pragma mark - 解锁view
    IBOutlet NSView *_unlockView;
    IBOutlet NSImageView *_unlockImageView;
    IBOutlet NSTextField *_titleTextField;
    IBOutlet NSTextField *_promptTextField;
    IBOutlet NSTextField *_unlockErrorTextField;
    IBOutlet IMBLoginButton *_unlockBtn;
    IBOutlet NSBox *_inputBox;
    
    //二次验证
    IBOutlet NSView *_doubleVerificationView;
    IBOutlet IMBBackAnimationButton *_backBtn;
    IBOutlet NSScrollView *_notReceiveView;
    IBOutlet IMBCanClickText *_notReceiveCode;
    IBOutlet IMBCodeTextField *_doubleVerificaFirstNum;
    IBOutlet IMBCodeTextField *_doubleVerificaSecondNum;
    IBOutlet IMBCodeTextField *_doubleVerificaThirdNum;
    IBOutlet IMBCodeTextField *_doubleVerificaFourthNum;
    IBOutlet IMBCodeTextField *_doubleVerificaFifthNum;
    IBOutlet IMBCodeTextField *_doubleVerificaSixthNum;
    
    //解锁
    IBOutlet NSView *_unlockInputView;
    IBOutlet IMBWhiteView *_unlockLineView;
    IBOutlet IMBSecireTextField *_unlockPasswordTextFiled;
}

- (id)initWithDelegate:(id)delegate;

/**
 *  增加登录或者锁定界面
 *
 *  @param isLogin YES是增加登录界面，NO是增加锁定界面
 */
- (void)addLoginViewOrUnlockView:(BOOL)isLogin;

@end

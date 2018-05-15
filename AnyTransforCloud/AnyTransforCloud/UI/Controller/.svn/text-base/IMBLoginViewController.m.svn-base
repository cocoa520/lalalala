//
//  IMBLoginViewController.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/8.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBLoginViewController.h"
#import "StringHelper.h"
#import "IMBSecureTextFieldCell.h"
#import "IMBCustomTextFieldCell.h"
#import "IMBSoftWareInfo.h"
#import "IMBAnimation.h"
#import "AppDelegate.h"
#import "IMBCloudManager.h"
#import "IMBLoginAnimationButton.h"
#import "NSString+Category.h"
#import "IMBImageAndColorButton.h"
#import "IMBChooseAccountView.h"
#import "IMBScrollView.h"
#import "IMBShadowView.h"
#import "IMBNotificationDefine.h"
#import "TempHelper.h"

@implementation IMBLoginViewController

- (id)initWithDelegate:(id)delegate {
    self = [super initWithNibName:@"IMBLoginViewController" bundle:nil];
    if (self) {
        _delegate = delegate;
        _nc = [NSNotificationCenter defaultCenter];
        _accounttable = [[IMBCreateAccountTable alloc] initWithPath:nil];
        [self addNotification];
        
    }
    return self;
}

- (void)addNotification {
    [_nc addObserver:self selector:@selector(loginAccountSuccessed:) name:AccountLoginSuccessedNotification object:nil];
    [_nc addObserver:self selector:@selector(loginAccountErrored:) name:AccountLoginErroredNotification object:nil];
    [_nc addObserver:self selector:@selector(logoutAccountSuccessed:) name:AccountLogoutSuccessedNotification object:nil];
    [_nc addObserver:self selector:@selector(logoutAccountErrored:) name:AccountLogoutErroredNotification object:nil];
    [_nc addObserver:self selector:@selector(createAccountSuccessed:) name:AccountCreateSuccessedNotification object:nil];
    [_nc addObserver:self selector:@selector(createAccountErrored:) name:AccountCreateErroredNotification object:nil];
    [_nc addObserver:self selector:@selector(loginInsertTabKey:) name:INSERT_TAB object:nil];
    [_nc addObserver:self selector:@selector(editEnd:) name:EDIT_END object:nil];
    [_nc addObserver:self selector:@selector(textFieldChange:) name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    [_nc addObserver:self selector:@selector(removeChooseAccountView) name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc addObserver:self selector:@selector(textfiledMouseDown:) name:TEXTFILED_MOUSE_DOWN object:nil];
    
    [_nc addObserver:self selector:@selector(editDoubleVerificationCode:) name:NOTIFY_EDIT_CODE object:nil];
    [_nc addObserver:self selector:@selector(deleteDoubleVerificationCode:) name:NOTIFY_DELETE_CODE object:nil];
    [_nc addObserver:self selector:@selector(doSecondOrUnlockVerification:) name:NOTIFY_CODE_ENTERKEY object:nil];
}

- (void)awakeFromNib {
    //查询之前登录的账号
    [_accounttable selectAccountDatail];
    _signInButton.isLogining = NO;
    _viewModle = [IMBSoftWareInfo singleton].isFirstRun;
    [self setNormalControlStaye];
    [self setRegistraTionContolStaye];
    [self setBottomViewStyle];
    
    [_bottomView setFrameOrigin:NSMakePoint((self.view.frame.size.width-_bottomView.frame.size.width)/2, 16)];
    if (_viewModle) {
        [_rigistrationView addSubview:_bottomView];
        [_contentBox setContentView:_rigistrationView];
    }else {
        [_loginView addSubview:_bottomView];
        [_contentBox setContentView:_loginView];
    }
    
    if (_accounttable.accountArray.count < 1) {
        [_accoutChooseBtn setHidden:YES];
    }
    if (_accounttable.accountArray.count > 0) {
        IMBAccountEntity *entity = [_accounttable.accountArray firstObject];
        [_accountTextField setStringValue:entity.account];
        [_secireTextField setStringValue:entity.password];
        [_checkButton setState:entity.isReminder];
    }
}

#pragma mark - 初始化界面控件
- (void)setNormalControlStaye {
    [_checkButton setState:NSOffState];
    
    [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_threeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    NSMutableAttributedString *titleAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"SoftwareName", nil) withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:30] withLineSpacing:0.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_loginTitle setAttributedStringValue:titleAs];
    
    [_signInButton setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_signInButton setButtonTitle:CustomLocalizedString(@"Login_Signin_Button", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_signInButton setSpaceWithText:4];
    [_signInButton setTarget:self];
    [_signInButton setAction:@selector(signInCloud:)];
    [_signInButton setNeedsDisplay:YES];
    
    [_forgetButton setNormalFillColor:[NSColor clearColor] WithEnterFillColor:[NSColor clearColor] WithDownFillColor:[NSColor clearColor]];
    [_forgetButton setIsRightAlignment:YES];
    [_forgetButton setButtonTitle:CustomLocalizedString(@"Login_Signin_PassForgot", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_forgetButton setAlignment:NSRightTextAlignment];
    [_forgetButton setSpaceWithText:4];
    [_forgetButton setIsNoGridient:YES];
    [_forgetButton setTarget:self];
    [_forgetButton setAction:@selector(forgetPassword:)];
    [_forgetButton setNeedsDisplay:YES];
    
    NSRect rect = [StringHelper calcuTextBounds:CustomLocalizedString(@"Login_Signin_OtherAuthorization", nil) font:[NSFont fontWithName:@"Helvetica Neue" size:14]];
    
    [_otherPromptView setFrame:NSMakeRect((_rigistrationView.frame.size.width - rect.size.width - 80)/2, _otherPromptView.frame.origin.y, rect.size.width + 80, _otherPromptView.frame.size.height)];
    NSMutableAttributedString *promptAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signin_OtherAuthorization", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_otherPromptTextField setAttributedStringValue:promptAs];
    [_otherPromptTextField setFrame:NSMakeRect(0, 0, rect.size.width + 80, _otherPromptTextField.frame.size.height)];
    
    [(IMBSecureTextFieldCell *)_secireTextField.cell setDelegate:self];
    [((IMBSecureTextFieldCell *)_secireTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signin_UserPassword", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0.0 withAlignment:NSLeftTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_secireTextField.cell setPlaceholderAttributedString:as];
    
    [_accountTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((IMBCustomTextFieldCell *)_accountTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as1 = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signin_UserName", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0.0 withAlignment:NSLeftTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_accountTextField.cell setPlaceholderAttributedString:as1];
    
    NSMutableAttributedString *remAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signin_Remember", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0.0 withAlignment:NSLeftTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_rememberTextField setAttributedStringValue:remAs];
    
    [_accoutChooseBtn mouseDownImage:[NSImage imageNamed:@"sign_arrow3"] withMouseUpImg:[NSImage imageNamed:@"sign_arrow2"] withMouseExitedImg:[NSImage imageNamed:@"sign_arrow"] mouseEnterImg:[NSImage imageNamed:@"sign_arrow2"]];
    
//    [_secireTextField setTarget:self];
//    [_secireTextField setAction:@selector(signInCloud:)];
    
    [_loginAccountErrorLable setStringValue:@""];
    [_loginPwdErrorLable setStringValue:@""];
    [_loginAccountErrorLable setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_loginPwdErrorLable setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_loginAccountErrorLable setHidden:YES];
    [_loginPwdErrorLable setHidden:YES];
}

- (void)setRegistraTionContolStaye {
    [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rigFourLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    NSMutableAttributedString *titleAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signup_Title", nil) withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:24] withLineSpacing:5.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_rigistrationTitle setAttributedStringValue:titleAs];
    
    [_createButton setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_createButton setButtonTitle:CustomLocalizedString(@"Login_Signup_Button", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_createButton setSpaceWithText:4];
    [_createButton setTarget:self];
    [_createButton setAction:@selector(createAccount:)];
    [_createButton setNeedsDisplay:YES];
    
    [(IMBSecureTextFieldCell *)_rigConfirmSecireTextField.cell setDelegate:self];
    [((IMBSecureTextFieldCell *)_rigConfirmSecireTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signin_UserConfirmPassword", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0.0 withAlignment:NSLeftTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_rigConfirmSecireTextField.cell setPlaceholderAttributedString:as];
    
    [(IMBSecureTextFieldCell *)_rigSecireTextField.cell setDelegate:self];
    [((IMBSecureTextFieldCell *)_rigSecireTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as2 = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signin_UserPassword", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0.0 withAlignment:NSLeftTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_rigSecireTextField.cell setPlaceholderAttributedString:as2];
    
    [_rigAccountTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((IMBCustomTextFieldCell *)_rigAccountTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as3 = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signup_Email", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0.0 withAlignment:NSLeftTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_rigAccountTextField.cell setPlaceholderAttributedString:as3];
    
    NSRect rect = [StringHelper calcuTextBounds:CustomLocalizedString(@"Login_Signin_OtherAuthorization", nil) font:[NSFont fontWithName:@"Helvetica Neue" size:14]];
    
    [_rigOtherPromptView setFrame:NSMakeRect((_rigistrationView.frame.size.width - rect.size.width - 80)/2, _rigOtherPromptView.frame.origin.y, rect.size.width + 80, _rigOtherPromptView.frame.size.height)];
    [_rigOtherPromptTextField setFrame:NSMakeRect(0, 0, rect.size.width + 80, _rigOtherPromptTextField.frame.size.height)];
    NSMutableAttributedString *promptAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signin_OtherAuthorization", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_rigOtherPromptTextField setAttributedStringValue:promptAs];
    
    [_accountError setStringValue:CustomLocalizedString(@"", nil)];
    [_passWordError setStringValue:CustomLocalizedString(@"", nil)];
    [_passwordVerificationError setStringValue:CustomLocalizedString(@"", nil)];
    
    [_accountError setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_passWordError setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_passwordVerificationError setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_accountError setHidden:YES];
    [_passWordError setHidden:YES];
    [_passwordVerificationError setHidden:YES];
    
    [_rigPwdSecireTextField setHidden:YES];
    [_rigPwdConfirmSecireTextField setHidden:YES];
    [((IMBCustomTextFieldCell *)_rigPwdConfirmSecireTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_rigPwdConfirmSecireTextField.cell setPlaceholderAttributedString:as];
    
    [((IMBCustomTextFieldCell *)_rigPwdSecireTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_rigPwdSecireTextField.cell setPlaceholderAttributedString:as2];
}

- (void)setBottomViewStyle {
    [_googleBtn setImageName:@"sign_google"];
    [_googleBtn setTarget:self];
    [_googleBtn setAction:@selector(googleLogin:)];
    [_googleBtn setNeedsDisplay:YES];
    
    [_facebookBtn setImageName:@"sign_facebook"];
    [_facebookBtn setTarget:self];
    [_facebookBtn setAction:@selector(facebookLogin:)];
    [_facebookBtn setNeedsDisplay:YES];
    
    [_tiwtterBtn setImageName:@"sign_twiter"];
    [_tiwtterBtn setTarget:self];
    [_tiwtterBtn setAction:@selector(tiwtterLogin:)];
    [_tiwtterBtn setNeedsDisplay:YES];
    
    [_botTextView setToolTip:@""];
    if (_viewModle) {
        NSString *promptStr = [CustomLocalizedString(@"Login_Signup_SwitchButton", nil) stringByAppendingString:CustomLocalizedString(@"Login_Signup_SwitchButton_Sub", nil)];
        [_botTextView setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"Login_Signup_SwitchButton_Sub", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    }else {
        NSString *promptStr = [CustomLocalizedString(@"Login_Signin_SwitchButton", nil) stringByAppendingString:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil)];
        [_botTextView setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    }
    [_botTextView setAlignment:NSCenterTextAlignment];
    [_botTextView setDelegate:self];
    [_botTextView setSelectable:YES];
}

- (void)setSecondVerificationContolStyle {
    _isTwoAfc = YES;
    [_doubleVerificaFirstNum setStringValue:@""];
    [_doubleVerificaSecondNum setStringValue:@""];
    [_doubleVerificaThirdNum setStringValue:@""];
    [_doubleVerificaFourthNum setStringValue:@""];
    [_doubleVerificaFifthNum setStringValue:@""];
    [_doubleVerificaSixthNum setStringValue:@""];
    
    [_doubleVerificaFirstNum setCodeTag:1];
    [_doubleVerificaSecondNum setCodeTag:2];
    [_doubleVerificaThirdNum setCodeTag:3];
    [_doubleVerificaFourthNum setCodeTag:4];
    [_doubleVerificaFifthNum setCodeTag:5];
    [_doubleVerificaSixthNum setCodeTag:6];
    
    [_backBtn setHidden:NO];

    [_backBtn setButtonWithTitle:CustomLocalizedString(@"backBtn_id", nil) WithTitleNormalColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] WithTitleEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithTitleDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
    [_backBtn setMouseExitedImg:[NSImage imageNamed:@"sign_back1"] withMouseEnterImg:[NSImage imageNamed:@"sign_back2"] withMouseDownImage:[NSImage imageNamed:@"sign_back3"]];
    
    [_backBtn setTarget:self];
    [_backBtn setAction:@selector(backLoginView:)];
    [_backBtn setNeedsDisplay:YES];
    
    [_unlockImageView setImage:[NSImage imageNamed:@"sign_secondpass"]];
    NSMutableAttributedString *titleAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"faGoogleControl_Title_Tips", nil) withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26] withLineSpacing:0.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_titleTextField setAttributedStringValue:titleAs];
    
    NSMutableAttributedString *subTitleAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"faGoogleControl_Description_Tips", nil) withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:14] withLineSpacing:2.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_promptTextField setAttributedStringValue:subTitleAs];
    
    [_unlockBtn endAnimation];
    [_unlockBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_unlockBtn setButtonTitle:CustomLocalizedString(@"faGoogleControl_BtnContent_Tips", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_unlockBtn setSpaceWithText:4];
    [_unlockBtn setTarget:self];
    [_unlockBtn setAction:@selector(doSecondOrUnlockVerification:)];
    [_unlockBtn setNeedsDisplay:YES];
    
    [_unlockErrorTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_unlockErrorTextField setHidden:YES];

    NSString *promptStr = CustomLocalizedString(@"verificationCode_notReceive", nil);
    [_notReceiveCode setNormalString:promptStr WithLinkString1:promptStr WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_notReceiveCode setAlignment:NSCenterTextAlignment];
    [_notReceiveCode setDelegate:self];
    [_notReceiveCode setSelectable:YES];
}

- (void)setUnlockViewContolStyle {
    _isTwoAfc = NO;
    [_backBtn setHidden:YES];
    
    NSString *promptStr = CustomLocalizedString(@"Login_unLock_PassForgot", nil);
    [_notReceiveCode setNormalString:promptStr WithLinkString1:promptStr WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_notReceiveCode setAlignment:NSCenterTextAlignment];
    [_notReceiveCode setDelegate:self];
    [_notReceiveCode setSelectable:YES];
    
    [_unlockImageView setImage:[NSImage imageNamed:@"sign_softlock"]];
    NSMutableAttributedString *titleAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"Lock_View_Title", nil) withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26] withLineSpacing:0.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_titleTextField setAttributedStringValue:titleAs];
    
    NSMutableAttributedString *subTitleAs = [StringHelper setTextWordStyle:CustomLocalizedString(@"Lock_View_Title2", nil) withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:14] withLineSpacing:2.0 withAlignment:NSCenterTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_promptTextField setAttributedStringValue:subTitleAs];
    
    [_unlockBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_unlockBtn setButtonTitle:CustomLocalizedString(@"Lock_View_Button", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_unlockBtn setSpaceWithText:4];
    [_unlockBtn setTarget:self];
    [_unlockBtn setAction:@selector(doSecondOrUnlockVerification:)];
    [_unlockBtn setNeedsDisplay:YES];
    
    [_unlockPasswordTextFiled setStringValue:@""];
    [_unlockPasswordTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((IMBCustomTextFieldCell *)_unlockPasswordTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as1 = [StringHelper setTextWordStyle:CustomLocalizedString(@"Login_Signin_UserPassword", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0.0 withAlignment:NSLeftTextAlignment withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_unlockPasswordTextFiled.cell setPlaceholderAttributedString:as1];
    
    [_unlockLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    [_unlockErrorTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_unlockErrorTextField setHidden:YES];
    
}

- (void)addLoginViewOrUnlockView:(BOOL)isLogin {
    if (isLogin) {
        _isTwoAfc = NO;
        NSString *promptStr = [CustomLocalizedString(@"Login_Signin_SwitchButton", nil) stringByAppendingString:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil)];
        [_botTextView setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
        
        _viewModle = NO;
        [_loginView addSubview:_bottomView];
        [_contentBox setContentView:_loginView];
        [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_loginAccountErrorLable setStringValue:@""];
        [_loginPwdErrorLable setStringValue:@""];
        
        if (!_checkButton.state) {
            [_secireTextField setStringValue:@""];
        }
    }else {
        [self setUnlockViewContolStyle];
        [_inputBox setContentView:_unlockInputView];
        [_contentBox setContentView:_unlockView];
        [_unlockPasswordTextFiled becomeFirstResponder];
    }
}

#pragma mark - 界面按钮操作事件
- (IBAction)signInCloud:(id)sender {
    /*
     1、用户名为空；
     2、不是有效用户名；（长度判断）
     3、密码为空；
     4、密码长度不够；
     */
//        IMBCloudManager *cloudManager = [IMBCloudManager singleton];
//    [_nc postNotificationName:AccountLoginSuccessedNotification object:nil];
//    [_nc postNotificationName:AccountLoginErroredNotification object:nil userInfo:@{@"two":@"google2fa"}];
    if (_signInButton.isLogining) {
        return;
    }
     NSLog(@"sign In Cloud");
    [_loginAccountErrorLable setHidden:YES];
    [_loginPwdErrorLable setHidden:YES];
    [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    if ([StringHelper stringIsNilOrEmpty:_accountTextField.stringValue]) {//账号为空
        [self windowShake];
        [_loginAccountErrorLable setHidden:NO];
        [_loginAccountErrorLable setStringValue:CustomLocalizedString(@"Login_UserNameEmptyTips", nil)];
        [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (![StringHelper checkEmailIsRight:_accountTextField.stringValue]) {//不是有效用户名
        [self windowShake];
        [_loginAccountErrorLable setHidden:NO];
        [_loginAccountErrorLable setStringValue:CustomLocalizedString(@"Login_UserNameValidTips", nil)];
        [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (![StringHelper checkEmailIslengthMore:_accountTextField.stringValue]) {//邮箱长度长了
        [self windowShake];
        [_loginAccountErrorLable setHidden:NO];
        [_loginAccountErrorLable setStringValue:CustomLocalizedString(@"Login_NameLenghtMaxTips", nil)];
        [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if ([StringHelper stringIsNilOrEmpty:_secireTextField.stringValue]) {//密码为空
        [self windowShake];
        [_loginPwdErrorLable setHidden:NO];
        [_loginPwdErrorLable setStringValue:CustomLocalizedString(@"Login_PasswordEmptyTips", nil)];
        [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (_secireTextField.stringValue.length < 6) {//密码长度不够
        [self windowShake];
        [_loginPwdErrorLable setHidden:NO];
        [_loginPwdErrorLable setStringValue:CustomLocalizedString(@"Login_LenghtTips", nil)];
        [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (![StringHelper checkPasswordIsRight:_secireTextField.stringValue]) {//密码必须包含数字和字符
        [self windowShake];
        [_loginPwdErrorLable setHidden:NO];
        [_loginPwdErrorLable setStringValue:CustomLocalizedString(@"Login_PasswordValidTips", nil)];
        [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (_secireTextField.stringValue.length > 30) {//密码长度长了
        [self windowShake];
        [_loginPwdErrorLable setHidden:NO];
        [_loginPwdErrorLable setStringValue:CustomLocalizedString(@"Login_PassLenghtMaxTips", nil)];
        [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else {
        [_signInButton loadAnimation];
        _signInButton.isLogining = YES;
        [_signInButton setNeedsDisplay:YES];
        IMBCloudManager *cloudManager = [IMBCloudManager singleton];
        [cloudManager loginAccount:_accountTextField.stringValue Password:_secireTextField.stringValue G2FCode:nil IsNeedCode:NO];
        [_botTextView setSelectable:NO];
    }
}

- (IBAction)createAccount:(id)sender {
    NSLog(@"create Account");
    /*
     1、邮箱为空；
     2、不是有效邮箱；@"^\\s*([A-Za-z0-9_-]+(\\.\\w+)*@(\\w+\\.)+\\w{2,5})\\s*$"
     3、密码为空；
     4、密码长度不够；
     5、密码输入不匹配；
     */
    [_accountError setHidden:YES];
    [_passWordError setHidden:YES];
    [_passwordVerificationError setHidden:YES];
    [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    if ([StringHelper stringIsNilOrEmpty:_rigAccountTextField.stringValue]) {//账号为空
        [self windowShake];
        [_accountError setHidden:NO];
        [_accountError setStringValue:CustomLocalizedString(@"Login_EmailEmptyTips", nil)];
        [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (![StringHelper checkEmailIsRight:_rigAccountTextField.stringValue]) {//不是有效邮箱
        [self windowShake];
        [_accountError setHidden:NO];
        [_accountError setStringValue:CustomLocalizedString(@"Login_EmailValidTips", nil)];
        [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (![StringHelper checkEmailIslengthMore:_rigAccountTextField.stringValue]) {//邮箱长度长了
        [self windowShake];
        [_accountError setHidden:NO];
        [_accountError setStringValue:CustomLocalizedString(@"Login_NameLenghtMaxTips", nil)];
        [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }
//    else if (![StringHelper checkEmailIslengthShort:_rigAccountTextField.stringValue]) {//邮箱长度短了
//        [self windowShake];
//        [_accountError setHidden:NO];
//        [_accountError setStringValue:CustomLocalizedString(@"Login_NameLenghtMixTips", nil)];
//        [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
//    }
    else if ([StringHelper stringIsNilOrEmpty:_rigSecireTextField.stringValue]) {//密码为空
        [self windowShake];
        [_passWordError setHidden:NO];
        [_passWordError setStringValue:CustomLocalizedString(@"Login_PasswordEmptyTips", nil)];
        [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (_rigSecireTextField.stringValue.length < 6) {//密码长度不够
        [self windowShake];
        [_passWordError setHidden:NO];
        [_passWordError setStringValue:CustomLocalizedString(@"Login_LenghtTips", nil)];
        [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (![StringHelper checkPasswordIsRight:_rigSecireTextField.stringValue]) {//密码必须包含数字和字符
        [self windowShake];
        [_passWordError setHidden:NO];
        [_passWordError setStringValue:CustomLocalizedString(@"Login_PasswordValidTips", nil)];
        [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (_rigSecireTextField.stringValue.length > 30) {//密码长度过长
        [self windowShake];
        [_passWordError setHidden:NO];
        [_passWordError setStringValue:CustomLocalizedString(@"Login_PassLenghtMaxTips", nil)];
        [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else if (![_rigSecireTextField.stringValue isEqualToString:_rigConfirmSecireTextField.stringValue]) {//两次密码不匹配
        [self windowShake];
        [_passwordVerificationError setHidden:NO];
        [_passwordVerificationError setStringValue:CustomLocalizedString(@"Login_PasswordComfirmErrorTips", nil)];
        [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else {
        [_createButton loadAnimation];
        [_botTextView setSelectable:NO];
        [_createButton setNeedsDisplay:YES];
        IMBCloudManager *cloudManager = [IMBCloudManager singleton];
        [cloudManager createAccount:_rigAccountTextField.stringValue Password:_rigSecireTextField.stringValue ConfirmPassword:_rigConfirmSecireTextField.stringValue];
    }
}

- (void)forgetPassword:(id)sender {
    NSLog(@"forget Password");
}

- (void)googleLogin:(id)sender {
    NSLog(@"google Login");
}

- (void)facebookLogin:(id)sender {
    NSLog(@"facebook Login");
}

- (void)tiwtterLogin:(id)sender {
    NSLog(@"tiwtter Login");
}

- (IBAction)showHistoryAccount:(id)sender {
    if (_accounttable.accountArray.count < 1) {
        return;
    }
//    [_accountAndSecireView setWantsLayer:YES];
    
    if (_accounttable.accountArray.count <= 4) {
        [_chooseAccountView setFrameSize:NSMakeSize(_chooseAccountView.frame.size.width, _accounttable.accountArray.count * 40 + 10)];
    }else {
        [_chooseAccountView setFrameSize:NSMakeSize(_chooseAccountView.frame.size.width, 4 * 40 + 10)];
    }
//    if (_accounttable.accountArray.count == 1) {
//        [_secireTextField setEnabled:YES];
//    }else {
//        [_secireTextField setEnabled:NO];
//    }
    
    [_chooseAccountView setWantsLayer:YES];
    IMBChooseAccountView *accountView = [[IMBChooseAccountView alloc] initWithFrame:NSMakeRect(0, 0, _chooseAccountView.frame.size.width, _accounttable.accountArray.count * 40 + 10)];
    [accountView setTarget:self];
    [accountView setAction:@selector(chooseAccount:)];
    [accountView setRemoveAction:@selector(removeAccount:)];
    [accountView setAccountAryM:_accounttable.accountArray];
    [accountView setNeedsDisplay:YES];
    [_chooseAccountScrollView setDocumentView:accountView];
    [_chooseAccountView setFrame:NSMakeRect(_accountAndSecireView.frame.origin.x - 5, _accountAndSecireView.frame.origin.y + _oneLineView.frame.origin.y - _chooseAccountView.frame.size.height + 2, _chooseAccountView.frame.size.width, _chooseAccountView.frame.size.height)];
    [_loginView addSubview:_chooseAccountView];
    [accountView release];
}

- (void)removeChooseAccountView {
    if (_chooseAccountView.superview) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [_secireTextField setEnabled:YES];
            [_chooseAccountView removeFromSuperview];
        });
    }
}

- (void)chooseAccount:(IMBAccountEntity *)accountEntity {
    [_chooseAccountView removeFromSuperview];
//    [_secireTextField setEnabled:YES];
    [_checkButton setState:accountEntity.isReminder];
    [_accountTextField setStringValue:accountEntity.account];
    [_secireTextField setStringValue:accountEntity.password];
    [_secireTextField becomeFirstResponder];
    
    [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_loginAccountErrorLable setStringValue:@""];
    [_loginPwdErrorLable setStringValue:@""];
}

- (void)removeAccount:(IMBAccountEntity *)accountEntity {
     [_accounttable deleteSqlite:accountEntity.account];
    if (_accounttable.accountArray.count < 1) {
        [_accoutChooseBtn setHidden:YES];
        [_accountTextField setStringValue:@""];
        [_secireTextField setStringValue:@""];
    }else {
        IMBAccountEntity *entity = [_accounttable.accountArray firstObject];
        [_accountTextField setStringValue:entity.account];
        [_secireTextField setStringValue:entity.password];
        [_secireTextField becomeFirstResponder];
        [_checkButton setState:entity.isReminder];
    }
}

- (IBAction)rigSecireDisplayTextBtnDown:(id)sender {
    _isClickSecireMode = YES;
    if (!_isRigSecireMode) {
        _isRigSecireMode = YES;
        [_rigSecireTextField setHidden:YES];
        [_rigPwdSecireTextField setHidden:NO];
    }else {
        _isRigSecireMode = NO;
        [_rigSecireTextField setHidden:NO];
        [_rigPwdSecireTextField setHidden:YES];
    }
    _isClickSecireMode = NO;
}

- (IBAction)rigConfirmSecireDisplayText:(id)sender {
    _isClickSecireMode = YES;
    if (!_isConfirmSecireMode){
        _isConfirmSecireMode = YES;
        [_rigPwdConfirmSecireTextField setHidden:NO];
        [_rigConfirmSecireTextField setHidden:YES];
//        [_rigPwdConfirmSecireTextField becomeFirstResponder];
    }else {
        _isConfirmSecireMode = NO;
        [_rigPwdConfirmSecireTextField setHidden:YES];
        [_rigConfirmSecireTextField setHidden:NO];
//        [_rigConfirmSecireTextField becomeFirstResponder];
    }
    _isClickSecireMode = NO;
    
}

- (IBAction)doSecondOrUnlockVerification:(id)sender {
    NSLog(@"do SecondOrUnlock Cerification");
    [_unlockErrorTextField setHidden:YES];
    if (_isTwoAfc) {
        
        NSString *codeStr = @"";
        if (![StringHelper stringIsNilOrEmpty:_doubleVerificaFirstNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSecondNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaThirdNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFourthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFifthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSixthNum.stringValue]) {
            codeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",_doubleVerificaFirstNum.stringValue,_doubleVerificaSecondNum.stringValue,_doubleVerificaThirdNum.stringValue,_doubleVerificaFourthNum.stringValue,_doubleVerificaFifthNum.stringValue,_doubleVerificaSixthNum.stringValue];
            [_unlockBtn loadAnimation];
            [_unlockBtn setNeedsDisplay:YES];
            IMBCloudManager *cloudManager = [IMBCloudManager singleton];
            [cloudManager loginAccount:_accountTextField.stringValue Password:_secireTextField.stringValue G2FCode:codeStr IsNeedCode:YES];
        }else {
            [self windowShake];
            [_unlockErrorTextField setHidden:NO];
            [_unlockErrorTextField setStringValue:CustomLocalizedString(@"faGoogleControl_Description_Tips", nil)];
        }
        
    }else {
        if ([StringHelper stringIsNilOrEmpty:_unlockPasswordTextFiled.stringValue]) {//密码为空
            [self windowShake];
            [_unlockErrorTextField setHidden:NO];
            [_unlockErrorTextField setStringValue:CustomLocalizedString(@"Login_PasswordEmptyTips", nil)];
            [_unlockLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else if (_unlockPasswordTextFiled.stringValue.length < 6) {//密码长度不够
            [self windowShake];
            [_unlockErrorTextField setHidden:NO];
            [_unlockErrorTextField setStringValue:CustomLocalizedString(@"Login_LenghtTips", nil)];
            [_unlockLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else if (![StringHelper checkPasswordIsRight:_unlockPasswordTextFiled.stringValue]) {//密码必须同时包含数字和字符
            [self windowShake];
            [_unlockErrorTextField setHidden:NO];
            [_unlockErrorTextField setStringValue:CustomLocalizedString(@"Login_PasswordValidTips", nil)];
            [_unlockLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else if (_unlockPasswordTextFiled.stringValue.length > 30) {//密码长度长了
            [self windowShake];
            [_unlockErrorTextField setHidden:NO];
            [_unlockErrorTextField setStringValue:CustomLocalizedString(@"Login_PassLenghtMaxTips", nil)];
            [_unlockLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else {
            IMBCloudManager *cloudManager = [IMBCloudManager singleton];
            if ([cloudManager.curPassword isEqualToString:_unlockPasswordTextFiled.stringValue]) {
                [(AppDelegate *)_delegate changeWindowFrame:YES];
            }else {
                [self windowShake];
                [_unlockErrorTextField setHidden:NO];
                [_unlockErrorTextField setStringValue:CustomLocalizedString(@"Lock_View_ErrorTips1", nil)];
                [_unlockLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
            }
        }
    }
}

- (void)backLoginView:(id)sender {
    [self addLoginViewOrUnlockView:YES];
}

#pragma mark - textView delegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    if ([link isEqualToString:CustomLocalizedString(@"Login_Signup_SwitchButton_Sub", nil)]) {
        //加载创建界面
        NSString *promptStr = [CustomLocalizedString(@"Login_Signin_SwitchButton", nil) stringByAppendingString:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil)];
        [_botTextView setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
        
        _viewModle = NO;
        if (!_accountError.isHidden && ![StringHelper stringIsNilOrEmpty:_accountError.stringValue]) {
            [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else {
            [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        }
        if (!_passWordError.isHidden && ![StringHelper stringIsNilOrEmpty:_passWordError.stringValue]) {
            [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else {
            [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        }
        if (!_passwordVerificationError.isHidden && ![StringHelper stringIsNilOrEmpty:_passwordVerificationError.stringValue]) {
            [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else {
            [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        }
        
        [_loginView addSubview:_bottomView];
        [_contentBox setContentView:_loginView];
    }else if ([link isEqualToString:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil)]) {
        //加载登录界面
        NSString *promptStr = [CustomLocalizedString(@"Login_Signup_SwitchButton", nil) stringByAppendingString:CustomLocalizedString(@"Login_Signup_SwitchButton_Sub", nil)];
        [_botTextView setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"Login_Signup_SwitchButton_Sub", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
        _viewModle = YES;
        if (!_loginAccountErrorLable.isHidden && ![StringHelper stringIsNilOrEmpty:_loginAccountErrorLable.stringValue] ) {
            [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else {
            [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        }
        if (!_loginPwdErrorLable.isHidden && ![StringHelper stringIsNilOrEmpty:_loginPwdErrorLable.stringValue]) {
            [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
        }else {
            [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        }
        
        [_rigistrationView addSubview:_bottomView];
        [_contentBox setContentView:_rigistrationView];
    } else if ([link isEqualToString:CustomLocalizedString(@"verificationCode_notReceive", nil)]) {//没有收到二次验证码
        
    }
    return YES;
}

#pragma mark - 登录通知事件
- (void)loginAccountSuccessed:(NSNotification *)notification {
    NSLog(@"login Account Successed");
    if (_isTwoAfc) {
        [_unlockBtn endAnimation];
        [_botTextView setSelectable:YES];
        [_unlockBtn setButtonTitle:CustomLocalizedString(@"faGoogleControl_BtnContent_Tips", nil)];
        [_unlockBtn setNeedsDisplay:YES];
    }else {
        if (_viewModle) {//从注册界面直接登录
            _viewModle = NO;
            [_createButton endAnimation];
            [_botTextView setSelectable:YES];
            [_createButton setButtonTitle:CustomLocalizedString(@"Login_Signup_Button", nil)];
            [_createButton setNeedsDisplay:YES];
            [_accountTextField setStringValue:_rigAccountTextField.stringValue];
            if (_checkButton.state == NSOnState) {
                [_secireTextField setStringValue:_rigPwdSecireTextField.stringValue];
            }else {
                [_secireTextField setStringValue:@""];
            }
            [_rigAccountTextField setStringValue:@""];
            [_rigPwdSecireTextField setStringValue:@""];
            [_rigSecireTextField setStringValue:@""];
            [_rigConfirmSecireTextField setStringValue:@""];
            [_rigPwdConfirmSecireTextField setStringValue:@""];
        }else {
            [_signInButton endAnimation];
            _signInButton.isLogining = NO;
            [_botTextView setSelectable:YES];
            [_signInButton setButtonTitle:CustomLocalizedString(@"Login_Signin_Button", nil)];
            [_signInButton setNeedsDisplay:YES];
            if (_checkButton.state != NSOnState) {
                [_secireTextField setStringValue:@""];
            }
        }
        [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    }
    //记住账号密码
    [self saveAccountToSqlite];
    //获取历史记录文件
    [[IMBCloudManager singleton] getContentList:@"history"];
    _isTwoAfc = NO;
    [(AppDelegate *)_delegate changeWindowFrame:NO];
}

- (void)loginAccountErrored:(NSNotification *)notification {
    NSLog(@"login Account Errored");
    if (_isTwoAfc) {
        [_unlockBtn endAnimation];
        [_botTextView setSelectable:YES];
        [_unlockBtn setButtonTitle:CustomLocalizedString(@"faGoogleControl_BtnContent_Tips", nil)];
        [_unlockBtn setNeedsDisplay:YES];
    }else {
        if (_viewModle) {//从注册界面直接登录
            [_createButton endAnimation];
            [_botTextView setSelectable:YES];
            [_createButton setButtonTitle:CustomLocalizedString(@"Login_Signup_Button", nil)];
            [_createButton setNeedsDisplay:YES];
            [_accountTextField setStringValue:_rigAccountTextField.stringValue];
            [_secireTextField setStringValue:_rigPwdSecireTextField.stringValue];
            [_rigAccountTextField setStringValue:@""];
            [_rigPwdSecireTextField setStringValue:@""];
            [_rigSecireTextField setStringValue:@""];
            [_rigConfirmSecireTextField setStringValue:@""];
            [_rigPwdConfirmSecireTextField setStringValue:@""];
            _viewModle = NO;
            NSString *promptStr = [CustomLocalizedString(@"Login_Signin_SwitchButton", nil) stringByAppendingString:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil)];
            [_botTextView setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"Login_Signin_SwitchButton_Sub", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
            [_loginView addSubview:_bottomView];
            [_contentBox setContentView:_loginView];
        }else {
            [_signInButton endAnimation];
            _signInButton.isLogining = NO;
            [_botTextView setSelectable:YES];
            [_signInButton setButtonTitle:CustomLocalizedString(@"Login_Signin_Button", nil)];
            [_signInButton setNeedsDisplay:YES];
        }
    }
    
    NSDictionary *info = [notification userInfo];
    if (info) {
        if (info.allKeys.count > 0) {
            NSString *key = [info.allKeys lastObject];
            NSString *value = [info objectForKey:key];
            if (_isTwoAfc) {
                [self windowShake];
                [_unlockErrorTextField setHidden:NO];
                [_unlockErrorTextField setStringValue:CustomLocalizedString(@"Login_AuthCode_ErrorTips", nil)];
            }else {
                if ([key isEqualToString:@"email"]) {
                    [self windowShake];
                    [_loginAccountErrorLable setHidden:NO];
                    [_loginAccountErrorLable setStringValue:value];
                    [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }else {
                    if ([value containsString:@"google2fa"]) {
                        [self setSecondVerificationContolStyle];
                        [_inputBox setContentView:_doubleVerificationView];
                        [_contentBox setContentView:_unlockView];
                        [_doubleVerificaFirstNum becomeFirstResponder];
                    }else {
                        [self windowShake];
                        [_loginPwdErrorLable setHidden:NO];
                        [_loginPwdErrorLable setStringValue:value];
                        [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                    }
                }
            }
        }
    }
}

- (void)logoutAccountSuccessed:(NSNotification *)notification {
    NSLog(@"logout Account Successed");
    
}

- (void)logoutAccountErrored:(NSNotification *)notification {
    NSLog(@"logout Account Errored");

}

- (void)createAccountSuccessed:(NSNotification *)notification {
    NSLog(@"create Account Successed");
    [_createButton endAnimation];
    [_botTextView setSelectable:YES];
    [_createButton setButtonTitle:CustomLocalizedString(@"Login_Signup_Button", nil)];
    [_createButton setNeedsDisplay:YES];
    [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    //注册成功之后直接登录
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    [cloudManager loginAccount:_rigAccountTextField.stringValue Password:_rigPwdSecireTextField.stringValue G2FCode:nil IsNeedCode:NO];
}

- (void)createAccountErrored:(NSNotification *)notification {
    NSLog(@"create Account Errored");
    [_createButton endAnimation];
    [_botTextView setSelectable:YES];
    [_createButton setButtonTitle:CustomLocalizedString(@"Login_Signup_Button", nil)];
    [_createButton setNeedsDisplay:YES];
    [self windowShake];
    NSDictionary *info = [notification userInfo];
    if (info) {
        if (info.allKeys.count > 0) {
            NSString *key = [info.allKeys lastObject];
            NSString *value = [info objectForKey:key];
            if ([key isEqualToString:@"email"]) {
                [_accountError setHidden:NO];
                [_accountError setStringValue:value];
                [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
            }else {
                [_passwordVerificationError setHidden:NO];
                [_passwordVerificationError setStringValue:value];
                [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
            }
        }
    }
}

- (void)loginInsertTabKey:(NSNotification *)notification {
    id obj = notification.object;
    if (_viewModle) {
        if ([obj isEqual:_rigAccountTextField]) {
            if (_isRigSecireMode) {
                [_rigPwdSecireTextField becomeFirstResponder];
            }else {
                [_rigSecireTextField becomeFirstResponder];
            }
        }else if ([obj isEqual:_rigSecireTextField] || [obj isEqual:_rigPwdSecireTextField]) {
            if (_isConfirmSecireMode) {
                [_rigPwdConfirmSecireTextField becomeFirstResponder];
            }else {
                [_rigConfirmSecireTextField becomeFirstResponder];
            }
        }else if ([obj isEqual:_rigConfirmSecireTextField] || [obj isEqual:_rigPwdConfirmSecireTextField]) {
            [_rigAccountTextField becomeFirstResponder];
        }
    }else {
        if ([obj isEqual:_accountTextField]) {
            [_secireTextField becomeFirstResponder];
        }else if ([obj isEqual:_secireTextField]) {
            [_accountTextField becomeFirstResponder];
        }
    }
}

- (void)editEnd:(NSNotification *)notification {
    if (_isClickSecireMode) {
        return;
    }
    id obj = notification.object;
    if (_viewModle) {
        if ([obj isEqual:_rigAccountTextField]) {
            if (![_rigOneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_rigTwoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
            if (![_rigThreeLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![StringHelper stringIsNilOrEmpty:_rigAccountTextField.stringValue]) {
                if (![StringHelper checkEmailIsRight:_rigAccountTextField.stringValue]) {//不是有效邮箱
                    [_accountError setHidden:NO];
                    [_accountError setStringValue:CustomLocalizedString(@"Login_EmailValidTips", nil)];
                    [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }else if (![StringHelper checkEmailIslengthMore:_rigAccountTextField.stringValue]) {//邮箱长度长了
                    [_accountError setHidden:NO];
                    [_accountError setStringValue:CustomLocalizedString(@"Login_NameLenghtMaxTips", nil)];
                    [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }
//                else if (![StringHelper checkEmailIslengthShort:_rigAccountTextField.stringValue]) {//邮箱长度短了
//                    [_accountError setHidden:NO];
//                    [_accountError setStringValue:CustomLocalizedString(@"Login_NameLenghtMixTips", nil)];
//                    [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
//                }
            }
        }else if ([obj isEqual:_rigSecireTextField]||[obj isEqual:_rigPwdSecireTextField]) {
            if (![_rigOneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_rigTwoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_rigThreeLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
            if (![StringHelper stringIsNilOrEmpty:_rigSecireTextField.stringValue]) {
                if (_rigSecireTextField.stringValue.length < 6) {//密码长度不够
                    [_passWordError setHidden:NO];
                    [_passWordError setStringValue:CustomLocalizedString(@"Login_LenghtTips", nil)];
                    [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }else if (![StringHelper checkPasswordIsRight:_rigSecireTextField.stringValue]) {//密码必须包含数字和字符
                    [_passWordError setHidden:NO];
                    [_passWordError setStringValue:CustomLocalizedString(@"Login_PasswordValidTips", nil)];
                    [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }else if (_rigSecireTextField.stringValue.length > 30) {
                    [_passWordError setHidden:NO];
                    [_passWordError setStringValue:CustomLocalizedString(@"Login_PassLenghtMaxTips", nil)];
                    [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }
            }
        }else if ([obj isEqual:_rigConfirmSecireTextField] || [obj isEqual:_rigPwdConfirmSecireTextField]) {
            if (![_rigOneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
            if (![_rigTwoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_rigThreeLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![StringHelper stringIsNilOrEmpty:_rigSecireTextField.stringValue] || ![StringHelper stringIsNilOrEmpty:_rigConfirmSecireTextField.stringValue]) {
                if (![_rigSecireTextField.stringValue isEqualToString:_rigConfirmSecireTextField.stringValue]) {//两次密码不匹配
                    [_passwordVerificationError setHidden:NO];
                    [_passwordVerificationError setStringValue:CustomLocalizedString(@"Login_PasswordComfirmErrorTips", nil)];
                    [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                    
                }
            }
        }
    }else {
        if ([obj isEqual:_accountTextField]) {
            if (![_twoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
            if (![_oneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![StringHelper stringIsNilOrEmpty:_accountTextField.stringValue]) {
                if (![StringHelper checkEmailIsRight:_accountTextField.stringValue]) {//不是有效用户名
                    [_loginAccountErrorLable setHidden:NO];
                    [_loginAccountErrorLable setStringValue:CustomLocalizedString(@"Login_UserNameValidTips", nil)];
                    [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }else if (![StringHelper checkEmailIslengthMore:_accountTextField.stringValue]) {//邮箱长度长了
                    [_loginAccountErrorLable setHidden:NO];
                    [_loginAccountErrorLable setStringValue:CustomLocalizedString(@"Login_NameLenghtMaxTips", nil)];
                    [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }
            }
        }else if ([obj isEqual:_secireTextField]) {
            if (![_twoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_oneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
            if (![StringHelper stringIsNilOrEmpty:_secireTextField.stringValue]) {
                if (_secireTextField.stringValue.length < 6) {//密码长度不够
                    [_loginPwdErrorLable setHidden:NO];
                    [_loginPwdErrorLable setStringValue:CustomLocalizedString(@"Login_LenghtTips", nil)];
                    [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }else if (![StringHelper checkPasswordIsRight:_secireTextField.stringValue]) {//密码必须包含数字和字符
                    [_loginPwdErrorLable setHidden:NO];
                    [_loginPwdErrorLable setStringValue:CustomLocalizedString(@"Login_PasswordValidTips", nil)];
                    [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }else if (_secireTextField.stringValue.length > 30) {
                    [_loginPwdErrorLable setHidden:NO];
                    [_loginPwdErrorLable setStringValue:CustomLocalizedString(@"Login_PassLenghtMaxTips", nil)];
                    [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
                }
            }
        }
        [_twoLineView setNeedsDisplay:YES];
        [_oneLineView setNeedsDisplay:YES];
    }
}

- (void)textFieldChange:(NSNotification *)notification {
    id obj = notification.object;
    if (_viewModle) {
        if ([obj isEqual:_rigAccountTextField]) {
            [_accountError setHidden:YES];
            [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
        }else if ([obj isEqual:_rigSecireTextField]) {
            [_passWordError setHidden:YES];
            [_rigPwdSecireTextField setStringValue: _rigSecireTextField.stringValue];
            [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
        }else if ([obj isEqual:_rigConfirmSecireTextField]) {
            [_passwordVerificationError setHidden:YES];
            [_rigPwdConfirmSecireTextField setStringValue:_rigConfirmSecireTextField.stringValue];
            [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
        }else if ([obj isEqual:_rigPwdSecireTextField]) {
            [_passWordError setHidden:YES];
            [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            [_rigSecireTextField setStringValue: _rigPwdSecireTextField.stringValue];
        }else if ([obj isEqual:_rigPwdConfirmSecireTextField]) {
            [_rigConfirmSecireTextField setStringValue:_rigPwdConfirmSecireTextField.stringValue];
            [_passwordVerificationError setHidden:YES];
            [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
        }
    }else {
        if ([obj isEqual:_accountTextField]) {
            NSString *str = [self removeSpace:_accountTextField.stringValue];
            [_accountTextField setStringValue:str];
            [_loginAccountErrorLable setHidden:YES];
            [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
        }else if ([obj isEqual:_secireTextField]) {
            [_secireTextField setNeedsDisplay:YES];
            [_loginPwdErrorLable setHidden:YES];
            [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
        }else if ([obj isEqual:_unlockPasswordTextFiled]) {
            [_unlockErrorTextField setHidden:YES];
            [_unlockLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
        }
    }
    
}

- (void)textfiledMouseDown:(NSNotification *)notification {
    id obj = notification.object;
    if (_viewModle) {
        if ([obj isEqual:_rigAccountTextField]) {
            if (![_rigOneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
            if (![_rigTwoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_rigThreeLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
        }else if ([obj isEqual:_rigSecireTextField] || [obj isEqual:_rigPwdSecireTextField]) {
            if (![_rigOneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_rigTwoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
            if (![_rigThreeLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
        }else if ([obj isEqual:_rigConfirmSecireTextField] || [obj isEqual:_rigPwdConfirmSecireTextField]) {
            if (![_rigOneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigOneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_rigTwoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigTwoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_rigThreeLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_rigThreeLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
        }
    }else {
        if ([obj isEqual:_accountTextField]) {
            if (![_oneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
            if (![_twoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
        }else if ([obj isEqual:_secireTextField]) {
            if (![_oneLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            }
            if (![_twoLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
        }else if ([obj isEqual:_unlockPasswordTextFiled]) {
            if (![_unlockLineView.backgroundColor isEqual:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]]) {
                [_unlockLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
            }
        }
    }
}

- (void)editDoubleVerificationCode:(NSNotification *)notification {
//    if (![StringHelper stringIsNilOrEmpty:_doubleVerificaFirstNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSecondNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaThirdNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFourthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFifthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSixthNum.stringValue]) {
//        [_unlockBtn setEnabled:YES];
//    }else {
//        [_unlockBtn setEnabled:NO];
//    }
    
    NSDictionary *dic = notification.object;
    int codeTag = [[dic objectForKey:@"codeTag"] intValue];
    if (codeTag == 1) {
        [_doubleVerificaSecondNum becomeFirstResponder];
    } else if (codeTag == 2) {
        [_doubleVerificaThirdNum becomeFirstResponder];
    } else if (codeTag == 3) {
        [_doubleVerificaFourthNum becomeFirstResponder];
    } else if (codeTag == 4) {
        [_doubleVerificaFifthNum becomeFirstResponder];
    } else if (codeTag == 5) {
        [_doubleVerificaSixthNum becomeFirstResponder];
    } else if (codeTag == 6) {
        return;
    }
}

- (void)deleteDoubleVerificationCode:(NSNotification *)notification {
//    if (![StringHelper stringIsNilOrEmpty:_doubleVerificaFirstNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSecondNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaThirdNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFourthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFifthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSixthNum.stringValue]) {
//        [_unlockBtn setEnabled:YES];
//    }else {
//        [_unlockBtn setEnabled:NO];
//    }
    
    NSDictionary *dic = notification.object;
    int codeTag = [[dic objectForKey:@"codeTag"] intValue];
    if (codeTag == 6) {
        [_doubleVerificaFifthNum becomeFirstResponder];
    } else if (codeTag == 5) {
        [_doubleVerificaFourthNum becomeFirstResponder];
    } else if (codeTag == 4) {
        [_doubleVerificaThirdNum becomeFirstResponder];
    } else if (codeTag == 3) {
        [_doubleVerificaSecondNum becomeFirstResponder];
    } else if (codeTag == 2) {
        [_doubleVerificaFirstNum becomeFirstResponder];
    } else if (codeTag == 1) {
        return;
    }
}

#pragma mark - window抖动
- (void)windowShake {
    NSWindow *window =  self.view.window;
    NSRect rect = window.frame;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [window setFrame:NSMakeRect(rect.origin.x + 4, rect.origin.y - 4, rect.size.width, rect.size.height) display:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [window setFrame:NSMakeRect(rect.origin.x - 1, rect.origin.y + 1, rect.size.width, rect.size.height) display:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                [window setFrame:NSMakeRect(rect.origin.x +4, rect.origin.y - 4, rect.size.width, rect.size.height) display:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                    [window setFrame:NSMakeRect(rect.origin.x - 1, rect.origin.y + 1, rect.size.width, rect.size.height) display:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                        [window setFrame:NSMakeRect(rect.origin.x +4, rect.origin.y - 4, rect.size.width, rect.size.height) display:YES];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                            [window setFrame:NSMakeRect(rect.origin.x - 1, rect.origin.y + 1, rect.size.width, rect.size.height) display:YES];
                        });
                    });
                });
            });
        });
    });
}

#pragma mark - 保存账号到数据库
- (void)saveAccountToSqlite {
    BOOL isAdd = YES;//是否增加
    NSString *accountStr = [self removeSpace:_accountTextField.stringValue];
    
    
    for (IMBAccountEntity *entity in _accounttable.accountArray) {
        if ([entity.account isEqualToString:accountStr]) {
            isAdd = NO;
            break;
        }
    }
    if (isAdd) {
        if (![StringHelper stringIsNilOrEmpty:_secireTextField.stringValue]) {
            if (_checkButton.state) {
                NSString *encStr = [_secireTextField.stringValue AES256EncryptWithKey:accountStr];
                if (![StringHelper stringIsNilOrEmpty:encStr]) {
                    [_accounttable createSqlite:accountStr Password:encStr LoginTime:[[NSDate date] timeIntervalSince1970] isReminder:YES];
                }
            }else {
                [_accounttable createSqlite:accountStr Password:@"" LoginTime:[[NSDate date] timeIntervalSince1970] isReminder:NO];
            }
        }else {
            [_accounttable createSqlite:accountStr Password:@"" LoginTime:[[NSDate date] timeIntervalSince1970] isReminder:NO];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_secireTextField.stringValue]) {
            if (_checkButton.state) {
                NSString *encStr = [_secireTextField.stringValue AES256EncryptWithKey:accountStr];
                if (![StringHelper stringIsNilOrEmpty:encStr]) {
                    [_accounttable updateSqlite:accountStr Password:encStr LoginTime:[[NSDate date] timeIntervalSince1970] isReminder:YES];
                }
            }else {
                [_accounttable updateSqlite:accountStr Password:@"" LoginTime:[[NSDate date] timeIntervalSince1970] isReminder:YES];
            }
        }else {
            [_accounttable updateSqlite:accountStr Password:@"" LoginTime:[[NSDate date] timeIntervalSince1970] isReminder:YES];
        }
    }

    [_accounttable selectAccountDatail];
    if (_accounttable.accountArray.count > 0) {
        [_accoutChooseBtn setHidden:NO];
    }
}

//取出字符串前后端的空格
- (NSString *)removeSpace:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)dealloc {
    [_nc removeObserver:self name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc removeObserver:self name:INSERT_TAB object:nil];
    [_nc removeObserver:self name:AccountLoginSuccessedNotification object:nil];
    [_nc removeObserver:self name:AccountLoginErroredNotification object:nil];
    [_nc removeObserver:self name:AccountLogoutErroredNotification object:nil];
    [_nc removeObserver:self name:AccountLogoutSuccessedNotification object:nil];
    [_nc removeObserver:self name:AccountCreateSuccessedNotification object:nil];
    [_nc removeObserver:self name:AccountCreateErroredNotification object:nil];
    [_nc removeObserver:self name:EDIT_END object:nil];
    [_nc removeObserver:self name:TEXTFILED_MOUSE_DOWN object:nil];
    [_nc removeObserver:self name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    [_nc removeObserver:self name:NOTIFY_EDIT_CODE object:nil];
    [_nc removeObserver:self name:NOTIFY_DELETE_CODE object:nil];
    [_accounttable release], _accounttable = nil;
    [super dealloc];
}

@end

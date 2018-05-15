//
//  IMBiCloudDriveLogInWindowController.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/28.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBiCloudDriveLogInWindowController.h"
#import "IMBToolbarWindow.h"
#import "StringHelper.h"
#import "IMBAllCloudViewController.h"
#import "IMBSecureTextFieldCell.h"
#import "IMBMainViewController.h"
@interface IMBiCloudDriveLogInWindowController ()

@end

@implementation IMBiCloudDriveLogInWindowController

- (id)initWithDelegate:(id)delegate {
    if ([super initWithWindowNibName:@"IMBiCloudDriveLogInWindowController"]) {
        _delegate = delegate;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)addNotification {
    [_nc addObserver:self selector:@selector(loginInsertTabKey:) name:INSERT_TAB object:nil];
}

-(void)awakeFromNib {
    _nc = [NSNotificationCenter defaultCenter];
    [self addNotification];
    [_rootBox setContentView:_logInView];
    [_checkButton setState:NSOffState];
    [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
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
    
    [_secireTextField setTarget:self];
    [_secireTextField setAction:@selector(signInCloud:)];
    
    [_loginAccountErrorLable setStringValue:@""];
    [_loginPwdErrorLable setStringValue:@""];
    [_loginAccountErrorLable setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_loginPwdErrorLable setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_loginAccountErrorLable setHidden:YES];
    [_loginPwdErrorLable setHidden:YES];
}

- (void)setNormalControlStaye {
    [_checkButton setState:NSOffState];
}

#pragma mark - 登录
- (IBAction)signInCloud:(id)sender {
    NSLog(@"sign In Cloud");
    /*
     1、用户名为空；
     2、不是有效用户名；（长度判断）
     3、密码为空；
     4、密码长度不够；
     */
    //        IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    //    [_nc postNotificationName:AccountLoginSuccessedNotification object:nil];
    //    [_nc postNotificationName:AccountLoginErroredNotification object:nil userInfo:@{@"two":@"google2fa"}];
    
    [_loginAccountErrorLable setHidden:YES];
    [_loginPwdErrorLable setHidden:YES];
    if ([StringHelper stringIsNilOrEmpty:_accountTextField.stringValue]) {//账号为空
        [self windowShake];
        [_loginAccountErrorLable setHidden:NO];
        [_loginAccountErrorLable setStringValue:CustomLocalizedString(@"Login_UserNameEmptyTips", nil)];
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
    }else if (_secireTextField.stringValue.length >16) {//密码长度长了
        [self windowShake];
        [_loginPwdErrorLable setHidden:NO];
        [_loginPwdErrorLable setStringValue:CustomLocalizedString(@"Login_PassLenghtMaxTips", nil)];
        [_twoLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    }else {
        _iCloudDriveManager = [[IMBiCloudDriveManager alloc]initWithUserID:_accountTextField.stringValue WithPassID:_secireTextField.stringValue WithDelegate:_delegate isRememberPassCode:NO];
        [[IMBCloudManager singleton] setICloudDriveManager:_iCloudDriveManager];
    }
}

#pragma mark - window抖动
- (void)windowShake {
    NSWindow *window =  self.window;
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

#pragma mark - 通知事件
- (void)loginInsertTabKey:(NSNotification *)notification {
    id obj = notification.object;
    if ([obj isEqual:_accountTextField]) {
        [_secireTextField becomeFirstResponder];
    }else if ([obj isEqual:_secireTextField]) {
        [_accountTextField becomeFirstResponder];
    }
}

- (void)forgetPassword:(id)sender {
    NSLog(@"forget Password");
}

@end

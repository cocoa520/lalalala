//
//  IMBiCloudDriveLogInWindowController.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/28.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBLoginButton.h"
#import "IMBWhiteView.h"
#import "IMBCheckButton.h"
#import "IMBCustomTextFiled.h"
#import "IMBGridientButton.h"
#import "IMBSecireTextField.h"
#import "IMBiCloudDriveManager.h"
@interface IMBiCloudDriveLogInWindowController : NSWindowController <IMBDriveDelegate>
{
    IBOutlet NSBox *_rootBox;
    IBOutlet IMBWhiteView *_logInView;
    
    IBOutlet NSTextField *_loginTitle;
    IBOutlet IMBLoginButton *_signInButton;
    IBOutlet IMBCheckButton *_checkButton;
    IBOutlet NSView *_loginAnimationView;
    IBOutlet NSTextField *_rememberTextField;
    IBOutlet IMBSecireTextField *_secireTextField;
    IBOutlet IMBCustomTextFiled *_accountTextField;
    IBOutlet IMBWhiteView *_oneLineView;
    IBOutlet IMBWhiteView *_twoLineView;
    IBOutlet NSTextField *_loginPwdErrorLable;

    IBOutlet IMBGridientButton *_forgetButton;
    IBOutlet NSView *_accountAndSecireView;
    IBOutlet NSTextField *_loginAccountErrorLable;
    NSNotificationCenter *_nc;
    IMBiCloudDriveManager *_iCloudDriveManager;
    id _delegate;
}
- (id)initWithDelegate:(id)delegate;
@end

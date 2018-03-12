//
//  IMBiCloudViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBSecireTextField.h"
#import "IMBiCloudClient.h"
#import "IMBAlertViewController.h"
#import "customTextFiled.h"
#import "IMBiCloudBackUpViewController.h"
#import "IMBDrawTextFiledView.h"
#import "IMBSelecedDeviceBtn.h"
#import "IMBiCloudManager.h"
#import "IMBDeviceConnection.h"
@class IMBiCloudMainPageViewController;

@interface IMBiCloudViewController : IMBBaseViewController
{
    IBOutlet NSImageView *_icloudImageView;
    NSString *_appleID;
    NSString *_curAppleId;
    NSString *_password;
    //    IBOutlet NSView *_icloudLogView;
    IBOutlet NSBox *_rootBox;
    IMBiCloudClient *_icloud;
    IBOutlet IMBMyDrawCommonly *_jumpCompleteBtn;
    IBOutlet NSView *_middleView;
    IBOutlet IMBWhiteView *_lineView;
    IMBWhiteView *_icloudLogView;
    BOOL _isLoginIng;
    IBOutlet NSTextField *_bommotTitle;
    IBOutlet NSTextField *_bommotSubStr;
    IBOutlet NSTextField *_signiCloudMainTitle;
    IMBiCloudBackUpViewController *_backupViewController;
    NSThread *_thread;
    BOOL _isRecv;
    NSThread *thread;

    IMBDeviceConnection *_connection;
    
//    NSMutableDictionary *_iCloudDic;//存储账户的iCloud页面
    NSPopover *devPopover;
    
    IBOutlet NSTextField *_titleTextField;
    IBOutlet NSTextField *_promptTextField;
    
    IBOutlet customTextFiled *_appleTextFiled;
    IBOutlet IMBSecireTextField *_passwordTextField;
    IBOutlet IMBDrawTextFiledView *_drawTextFiledView;
    IBOutlet IMBGridientButton *_loginBtn;
    IBOutlet NSImageView *_nonectimageView;
    
    @public
    IMBSelecedDeviceBtn *_selectDeviceButton;
    BOOL _hasTwoStepAuth;
    BOOL _accountIsLocked;//账号被锁
    
}
@property (nonatomic, assign) BOOL hasTwoStepAuth;
@property (nonatomic, assign) BOOL isLoginIng;
//@property (nonatomic, assign) NSMutableDictionary *iCloudDic;
@property (assign) IBOutlet IMBWhiteView *icloudLogView;
-(void)cleanTextField;
- (void)setiCloudTitle:(NSString *)name;
//- (void)popiCloudAccount:(id)sender;
- (void)onItemClicked:(NSString *)account;
- (NSDictionary *)getiCloudDic;
- (void)setRootBoxContentView:(IMBiCloudMainPageViewController *)icloudMainPage;
- (NSDictionary *)verifiTwoStepAuthentication:(NSString *)password;
- (void)loginiCloudWithSessiontoken:(NSString *)sessiontoken;
- (void)loginIsSuccess:(BOOL)success withAppleID:(NSString*)appledID;
- (void)showTwoStepAuthenticationAlertView;
//再次发送双重验证短信
- (int)reSendTwoStepAuthenticationMessage;
//再次发送双重验证Code
- (int)reSendTwoStepAuthenticationCode;
//取消双重验证下拉框
- (void)cancelTwoStepAuthenticationAlertView;
@end

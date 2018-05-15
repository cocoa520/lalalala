//
//  AppDelegate.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/8.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LoginAuthorizationDrive.h"
#import "IMBLoginViewController.h"
#import "IMBMainViewController.h"

#define WindowMinSizeWidth 400
#define WindowMinSizeHigh 580

#define WindowMaxSizeWidth 1080
#define WindowMaxSizeHigh 640

static int windowLargeWidth;
static int windowLargeHeight;

@interface AppDelegate : NSObject <NSApplicationDelegate,BaseDriveDelegate>
{
    IBOutlet NSBox *_contentBox;
    
    IMBLoginViewController *_loginViewController;
    LoginAuthorizationDrive *_loginDrive;
    IMBMainViewController *_mainViewController;
}
@property (assign) IBOutlet NSWindow *window;

/**
 *  设置主窗口尺寸
 *
 *  @param isUnlock YES是解锁后回到主界面，NO是登录后到主界面
 */
- (void)changeWindowFrame:(BOOL)isUnlock;

/**
 *  返回到登录界面或者
 *
 *  @param isLogin YES是返回登录界面，NO是返回锁定界面
 */
- (void)backLoginView:(BOOL)isLogin;

@end


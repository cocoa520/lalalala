//
//  IMBMainBigIcloudView.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainBigIcloudView.h"
#import "IMBCommonDefine.h"
#import "IMBMyDrawCommonly.h"
#import "customTextFiled.h"


@implementation IMBMainBigIcloudView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    _titleLabel.stringValue = CustomLocalizedString(@"MainWindow_BigSize_Icloud_TitleString", nil);
    [_titleLabel setFont:[NSFont fontWithName:IMBCommonFont size:18.0]];
    [_titleLabel setTextColor:COLOR_MAINWINDOW_TITLE_TEXT];
    
    [_messageLabel setStringValue:CustomLocalizedString(@"MainWindow_BigSize_Icloud_MessageString", nil)];
    [_messageLabel setFont:[NSFont fontWithName:IMBCommonFont size:12.0]];
    [_messageLabel setTextColor:COLOR_MAINWINDOW_MESSAGE_TEXT];
    
    [_rememberMeLabel setStringValue:CustomLocalizedString(@"MainWindow_BigSize_Icloud_Rememberme", nil)];
    [_rememberMeLabel setFont:[NSFont fontWithName:IMBCommonFont size:12.0]];
    [_rememberMeLabel setTextColor:COLOR_MAINWINDOW_REMEMBENME_TEXT];
    
    [_loginBtn setStringValue:CustomLocalizedString(@"MainWindow_BigSize_Icloud_LoginBtnString", nil)];
    
    [_icloudLoginPwdTF setPlaceholderString:CustomLocalizedString(@"MainWindow_BigSize_Icloud_LoginPsdPlaceholder", nil)];
    [_icloudLoginPwdTF setFont:[NSFont fontWithName:IMBCommonFont size:14.0]];
    
    [_icloudSecireTF setPlaceholderString:CustomLocalizedString(@"MainWindow_BigSize_Icloud_LoginPsdPlaceholder", nil)];
    [_icloudSecireTF setFont:[NSFont fontWithName:IMBCommonFont size:14.0]];
    
    [_icloudUserTF setPlaceholderString:CustomLocalizedString(@"MainWindow_BigSize_Icloud_LoginUserPlaceholder", nil)];
    [_icloudUserTF setFont:[NSFont fontWithName:IMBCommonFont size:14.0]];
    
    
}

@end

//
//  IMBNotificationWindowController.m
//  AirBackupHelper
//
//  Created by iMobie on 10/19/17.
//  Copyright (c) 2017 iMobie. All rights reserved.
//

#import "IMBNotificationWindowController.h"
#import "IMBGridientButton.h"
#import "IMBGeneralButton.h"
#import "IMBWhiteView.h"
#import "IMBUnlockView.h"
#import "IMBHelper.h"

@implementation IMBNotificationWindowController
@synthesize title = _title;
@synthesize prompt = _prompt;
@synthesize isShow = _isShow;
@synthesize isClosePrompt = _isClosePrompt;

- (id)initWithRect:(NSRect)mainRect {
    self = [super initWithWindowNibName:@"IMBNotificationWindowController"];
    if (self) {
        _isShow = NO;
        _isClosePrompt = NO;
        _mainRect = mainRect;
    }
    return self;
}

- (void)awakeFromNib {
    [self.window.contentView addSubview:_thirdView];
    [self.window setLevel:kCGStatusWindowLevel];
    [self.window setOpaque:NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setStyleMask:NSBorderlessWindowMask];
    [self.window setAutodisplay:YES];
    
    NSPoint point = NSMakePoint(_mainRect.size.width,_mainRect.size.height - self.window.frame.size.height - 30);
    [self.window setFrameOrigin:point];
    
    [self configBtn];
}

- (void)configBtn {
    [_secondUnlockBtn setCornerRadius:5];
    [_secondUnlockBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[NSColor colorWithDeviceRed:250.0/255 green:152.0/255 blue:29.0/255 alpha:1.0] withRightNormalBgColor:[NSColor colorWithDeviceRed:253.0/255 green:176.0/255 blue:61.0/255 alpha:1.0] withLeftEnterBgColor:[NSColor colorWithDeviceRed:251.0/255 green:156.0/255 blue:38.0/255 alpha:1.0] withRightEnterBgColor:[NSColor colorWithDeviceRed:252.0/255 green:179.0/255 blue:64.0/255 alpha:1.0] withLeftDownBgColor:[NSColor colorWithDeviceRed:234.0/255 green:141.0/255 blue:26.0/255 alpha:1.0] withRightDownBgColor:[NSColor colorWithDeviceRed:246.0/255 green:164.0/255 blue:33.0/255 alpha:1.0] withLeftForbiddenBgColor:[NSColor colorWithDeviceRed:254.0/255 green:198.0/255 blue:98.0/255 alpha:1.0] withRightForbiddenBgColor:[NSColor colorWithDeviceRed:254.0/255 green:176.0/255 blue:61.0/255 alpha:1.0]];
    [_secondUnlockBtn setButtonTitle:CustomLocalizedString(@"Backup_Unlock_Btn", nil) withNormalTitleColor:[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] withEnterTitleColor:[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] withDownTitleColor:[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] withForbiddenTitleColor:[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0] withTitleSize:14 WithLightAnimation:NO];
    [_secondUnlockBtn setButtonBorder:YES withNormalBorderColor:[NSColor clearColor] withEnterBorderColor:[NSColor clearColor] withDownBorderColor:[NSColor clearColor] withForbiddenBorderColor:[NSColor clearColor] withBorderLineWidth:1.0];
    [_secondUnlockBtn setFrameSize:NSMakeSize(226, 28)];
    [_secondUnlockBtn setTarget:self];
    [_secondUnlockBtn setAction:@selector(unlockSpace:)];
    [_secondUnlockBtn setNeedsDisplay:YES];
    
    [_thirdBtnLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:13]];
    [_thirdBtnLabel setTextColor:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]];
    [_thirdBtnLabel setStringValue:CustomLocalizedString(@"Backup_Unlock_Btn", nil)];
    [_thirdBtn setHasCorner:YES];
    [_thirdBtn setTarget:self];
    [_thirdBtn setAction:@selector(backupCompleteUnlockSpaceClick:)];
    
    [_fourBtnLabel setFont:[NSFont fontWithName:@"Helvetica Neue" size:13]];
    [_fourBtnLabel setTextColor:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]];
    [_fourBtnLabel setStringValue:CustomLocalizedString(@"Backup_Unlock_Btn", nil)];
    [_fourBtn setHasCorner:YES];
    [_fourBtn setTarget:self];
    [_fourBtn setAction:@selector(backupCompleteUnlockSpaceClick:)];
    
    NSString *okStr = CustomLocalizedString(@"OkBtnText", nil);
    [_backupOKBtn reSetInit:okStr WithPrefixImageName:@"cancal"];
    [_backupOKBtn.btnCell setIsDrawBg:YES];
    [_backupOKBtn setIsReslutVeiw:YES];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0] range:NSMakeRange(0, okStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_backupOKBtn setAttributedTitle:attributedTitles];
    [_backupOKBtn setTarget:self];
    [_backupOKBtn setAction:@selector(backUpOKClick:)];
}

#pragma mark - 设置当前的mode，根据当前的mode修改window的大小
- (void)setCureentMode:(int)mode {
      //mode = 1--->电量提醒; 2--->备份大小限制提醒; 3--->备份进度提醒; 4--->备份完成（注册或者未注册打开anytrans）提醒; 5--->备份完成（未注册没有打开anytrans）提醒(有标题); 6--->备份错误提醒
    if (_currentMode != mode) {
        _currentMode = mode;
        NSSize size;
        if(mode == 1 || mode == 4 || mode == 6) {
            size = NSMakeSize(300, 62);
        }else if (mode == 3) {
            size = NSMakeSize(340, 62);
        }else if (mode == 5 || mode == 2){
            NSArray *checkLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *lanStr = [checkLang objectAtIndex:0];
            if ([lanStr isEqualToString:@"de"]) {
                size = NSMakeSize(340, 160);
            }else {
                size = NSMakeSize(340, 140);
            }
        }else {
            size = NSMakeSize(340, 160);
        }

        [_firstView removeFromSuperview];
        [_backUpView removeFromSuperview];
        [_thirdView removeFromSuperview];
        [_fourView removeFromSuperview];
        [_secondView removeFromSuperview];
        
        [self.window.contentView setHidden:NO];
        NSPoint point = NSMakePoint(_mainRect.size.width,_mainRect.size.height - size.height - 30);
        NSLog(@"point:(%f,%f)",point.x,point.y);
        [self.window setFrame:NSMakeRect(point.x, point.y, size.width, size.height) display:YES];
        if(mode == 1 || mode == 4 || mode == 6) {
            [_firstView setFrameOrigin:NSMakePoint(0, 0)];
            [self.window.contentView addSubview:_firstView];
        }else if (mode == 3) {
            [_backUpView setFrameOrigin:NSMakePoint(0, 0)];
            [self.window.contentView addSubview:_backUpView];
        }else if (mode == 5 || mode == 2){
            NSArray *checkLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *lanStr = [checkLang objectAtIndex:0];
            if ([lanStr isEqualToString:@"de"]) {
                [_thirdView setFrameOrigin:NSMakePoint(0, 0)];
                [self.window.contentView addSubview:_thirdView];
            }else {
                [_fourView setFrameOrigin:NSMakePoint(0, 0)];
                [self.window.contentView addSubview:_fourView];
            }
        }else {
            [_secondView setFrameOrigin:NSMakePoint(0, 0)];
            [self.window.contentView addSubview:_secondView];
        }
    }
}

- (void)loadWindowWord:(NSString *)title withPrompt:(NSString *)prompt withMode:(int)mode {
    NSLog(@"self.window.frame:(%f,%f,%f,%f)",self.window.frame.origin.x,self.window.frame.origin.y,self.window.frame.size.width,self.window.frame.size.height);
    if (title) {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:title];
        [as addAttribute:NSForegroundColorAttributeName
                   value:[NSColor colorWithDeviceRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]
                   range:NSMakeRange(0, as.length)];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];

        if(mode == 1 || mode == 4 || mode == 6) {
            NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName,nil];
            NSRect titleRect = [title boundingRectWithSize:NSMakeSize(236, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
            if (titleRect.size.height <= 30) {//显示的是一行
                [_firstTitle setFrameOrigin:NSMakePoint(52, -18)];
            }else if (titleRect.size.height <= 50) {//显示的是两行
                [_firstTitle setFrameOrigin:NSMakePoint(52, -8)];
            }else {
                [_firstTitle setFrameOrigin:NSMakePoint(52, 2)];
            }
            [as setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as.length)];
            [_firstTitle setAttributedStringValue:as];
        }else if (mode == 3) {
            [_backupTitle setAttributedStringValue:as];
        }else if (mode == 5 || mode == 2){
            if (mode == 5) {
                [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue bold" size:12] range:NSMakeRange(0, as.length)];
            }else {
                [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue bold" size:14] range:NSMakeRange(0, as.length)];
            }
            NSArray *checkLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *lanStr = [checkLang objectAtIndex:0];
            if ([lanStr isEqualToString:@"de"]) {
                [_thirdTitle setAttributedStringValue:as];
            }else {
                [_fourTitle setAttributedStringValue:as];
            }
        }else {
            [_secondSubTitle setAttributedStringValue:as];
        }
        [as release], as = nil;
    }
    if (prompt) {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:prompt];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        if (mode == 5 || mode == 2) {
            [as addAttribute:NSForegroundColorAttributeName
                       value:[NSColor colorWithDeviceRed:125.0/255 green:125.0/255 blue:125.0/255 alpha:1.0]
                       range:NSMakeRange(0, as.length)];
            NSArray *checkLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *lanStr = [checkLang objectAtIndex:0];
            if ([lanStr isEqualToString:@"de"]) {
                [_thirdSubTitle setAttributedStringValue:as];
            }else {
                [_fourSubTitle setAttributedStringValue:as];
            }
        }else {
            [as addAttribute:NSForegroundColorAttributeName
        value:[NSColor colorWithDeviceRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]
        range:NSMakeRange(0, as.length)];
            [_secondSubTitle setAttributedStringValue:as];
        }
        [as release], as = nil;
    }
    [self.window.contentView setHidden:NO];
}

- (IBAction)close:(id)sender {
    _isShow = NO;
    NSLog(@"mainRect1:(%f,%f,%f,%f)",_mainRect.origin.x,_mainRect.origin.y,_mainRect.size.width,_mainRect.size.height);
    NSRect rect = NSMakeRect(_mainRect.size.width, _mainRect.size.height - self.window.frame.size.height - 30, self.window.frame.size.width, self.window.frame.size.height);
    NSLog(@"Rect2:(%f,%f,%f,%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    [self.window setFrame:rect display:YES animate:YES];
//    [self.window close];
    [self.window.contentView setHidden:YES];
}

#pragma mark 点击方法
//备份过程中，关闭back进度通知页面
- (void)backUpOKClick:(id)sender {
    _isClosePrompt = YES;
    [self close:nil];
}

//备份限制页面，解锁备份空间
- (void)unlockSpace:(id)sender {
    [_secondUnlockBtn setNeedsDisplay:YES];
    NSLog(@"+++++++++++++unlockSpace++++++++++++");
    [self openAnyTransApp];
}
//备份完成页面，解锁备份空间
- (void)backupCompleteUnlockSpaceClick:(id)sender {
    NSLog(@"=====backupCompleteUnlockSpaceClick++++++");
    [self openAnyTransApp];
}

- (void)openAnyTransApp {
    [self close:nil];
    if (![IMBHelper appIsRunningWithBundleIdentifier:@"com.imobie.AnyTrans"]) {
        NSURL *url = [NSURL URLWithString:@"AnyTrans.imobie.com://"];
        
        NSURL *openUrl = [[NSWorkspace sharedWorkspace] URLForApplicationToOpenURL:url];
        if (openUrl == nil) {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:CustomLocalizedString(@"SP_Download_Url", nil)]];
        }else {
            [[NSWorkspace sharedWorkspace] openURL:url];
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

@end

//
//  IMBAndroidDisconnectViewController.m
//  AnyTrans
//
//  Created by iMobie on 7/10/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBAndroidDisconnectViewController.h"
#import "SystemHelper.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"

@interface IMBAndroidDisconnectViewController ()

@end

@implementation IMBAndroidDisconnectViewController

#pragma mark - 切换多语言
-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = CustomLocalizedString(@"Android_NotConnectTitle_Tips", nil);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
        }else {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
        }
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
        
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_titleTextField setAttributedStringValue:as];
        
        NSString *str2 = CustomLocalizedString(@"AndroidNoConnect", nil);
        [self setPromptTextString:str2];
    });
    
}

#pragma mark - 切换皮肤
- (void)changeSkin:(NSNotification *)notification {
    NSString *str = CustomLocalizedString(@"Android_NotConnectTitle_Tips", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_titleTextField setAttributedStringValue:as];
    
    NSString *str2 = CustomLocalizedString(@"AndroidNoConnect", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
    [_promptTextField setAttributedStringValue:as2];
    
    [_nonectimageView1 setImage:[StringHelper imageNamed:@"toios_noconnect"]];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        NSRect frame =  _noconnectView.frame;
        frame.origin.y = self.view.frame.origin.y ;
        frame.size.width = self.view.frame.size.width;
        _noconnectView.frame = frame;
        [_nonectimageView1.cell setImageAlignment:NSImageAlignBottom];
    }else {
        NSRect frame =  _noconnectView.frame;
        frame.origin.y = self.view.frame.origin.y + 5;
        frame.size.width = self.view.frame.size.width;
        _noconnectView.frame = frame;
        [_nonectimageView1.cell setImageAlignment: NSImageAlignCenter];
    }
    [_noconnectView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
    
}

- (void)awakeFromNib {
    [_nonectimageView1 setImage:[StringHelper imageNamed:@"toios_noconnect"]];
    count = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    NSString *str = CustomLocalizedString(@"Android_NotConnectTitle_Tips", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_titleTextField setAttributedStringValue:as];
    
    NSString *str2 = CustomLocalizedString(@"AndroidNoConnect", nil);
    [self setPromptTextString:str2];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        NSRect frame =  _noconnectView.frame;
        frame.origin.y = self.view.frame.origin.y ;
        frame.size.width = self.view.frame.size.width;
        _noconnectView.frame = frame;
        [_nonectimageView1.cell setImageAlignment:NSImageAlignBottom];
    }else {
        NSRect frame =  _noconnectView.frame;
        frame.origin.y = self.view.frame.origin.y + 5;
        frame.size.width = self.view.frame.size.width;
        _noconnectView.frame = frame;
        [_nonectimageView1.cell setImageAlignment: NSImageAlignCenter];
    }
    [_noconnectView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
}

#pragma mark - 配置连接流程文字（默认、安装apk、运行apk）
- (void)setPromptTextString:(NSString *)textStr {
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSRange range = NSMakeRange(0, as.length);
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:range];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:range];
    [as setAlignment:NSCenterTextAlignment range:range];
    [_promptTextField setAttributedStringValue:as];
    [as release], as = nil;
}

#pragma mark - 配置正在连接和链接完成的文字
- (void)loadingConnectingAndConnectedCompeleteLaguages:(NSString *)deviceName {
    NSString *name = [deviceName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *devName =  [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSMutableAttributedString *as = nil;
    if ([IMBHelper stringIsNilOrEmpty:devName]) {
        devName = CustomLocalizedString(@"ConnectError_UnknownDevice", nil);
    }
    as = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:CustomLocalizedString(@"MG_connecting_tips", nil),devName]];
    
    NSRange range = NSMakeRange(0, as.length);
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:range];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:range];
    [as setAlignment:NSCenterTextAlignment range:range];
    [_promptTextField setAttributedStringValue:as];
    [as release], as = nil;
    
}

- (void)addTimer {
    if (_timer) {
        return;
    }
    _timer = [NSTimer timerWithTimeInterval:30.0/60 target:self selector:@selector(changeImageView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 切换未连接页面的背景图片
- (void)changeImageView {
    if (count == 0) {
        [_nonectimageView1 setImage:[StringHelper imageNamed:@"toios_noconnect"]];
        count = 1;
    }else if (count == 1) {
        [_nonectimageView1 setImage:[StringHelper imageNamed:@"toios_noconnect2"]];
        count = 2;
    }else if (count == 2) {
        [_nonectimageView1 setImage:[StringHelper imageNamed:@"toios_noconnect3"]];
        count = 0;
    }else {
        count = 0;
    }
}

- (void)killTimer {
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)setTimerNil {
    if (_timer) {
        _timer = nil;
    }
}

-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
}

@end

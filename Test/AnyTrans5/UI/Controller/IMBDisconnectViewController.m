//
//  IMBDisconnectViewController.m
//  
//
//  Created by ding ming on 16/7/19.
//
//

#import "IMBDisconnectViewController.h"
#import "SystemHelper.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
@interface IMBDisconnectViewController ()

@end

@implementation IMBDisconnectViewController
-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = CustomLocalizedString(@"noconnect_welcome_message", nil);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
        }else {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
        }
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
        
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_titleTextField setAttributedStringValue:as];
        
        NSString *str2 = CustomLocalizedString(@"noconnect_plugindevice", nil);
        NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
        [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, as2.length)];
        [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
        [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
        [_promptTextField setAttributedStringValue:as2];
    });

}

- (void)awakeFromNib {
    [_nonectimageView1 setImage:[StringHelper imageNamed:@"noconnect_bg"]];
    count = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    NSString *str = CustomLocalizedString(@"noconnect_welcome_message", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];

    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
   [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_titleTextField setAttributedStringValue:as];
    
    NSString *str2 = CustomLocalizedString(@"noconnect_plugindevice", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
    [_promptTextField setAttributedStringValue:as2];
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

- (void)setPromptTextString:(NSString *)textStr {
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:textStr];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:18] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
    [_promptTextField setAttributedStringValue:as2];
}

- (void)addTimer {
    if (_timer) {
        return;
    }
    _timer = [NSTimer timerWithTimeInterval:30.0/60 target:self selector:@selector(changeImageView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)changeImageView {
    if (count == 0) {
        [_nonectimageView1 setImage:[StringHelper imageNamed:@"noconnect_bg"]];
        count = 1;
    }else if (count == 1) {
        [_nonectimageView1 setImage:[StringHelper imageNamed:@"noconnect_bg1"]];
        count = 2;
    }else if (count == 2) {
        [_nonectimageView1 setImage:[StringHelper imageNamed:@"noconnect_bg2"]];
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

- (void)changeSkin:(NSNotification *)notification {
    NSString *str = CustomLocalizedString(@"noconnect_welcome_message", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:40] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:40] range:NSMakeRange(0, as.length)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_titleTextField setAttributedStringValue:as];
    
    NSString *str2 = CustomLocalizedString(@"noconnect_plugindevice", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
    [_promptTextField setAttributedStringValue:as2];
    
    [_nonectimageView1 setImage:[StringHelper imageNamed:@"noconnect_bg"]];
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

-(void)dealloc{
    [super dealloc];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
}

@end

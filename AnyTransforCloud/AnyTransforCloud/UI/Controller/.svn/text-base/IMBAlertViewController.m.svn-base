//
//  IMBAlertViewController.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/6.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBAlertViewController.h"
#import "IMBAnimation.h"
#import "StringHelper.h"

@interface IMBAlertViewController ()

@end

@implementation IMBAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)awakeFromNib {
    [_promptAlertView setIsAlertView:YES];
    [_promptAlertView2 setIsAlertView:YES];
}
#pragma mark - 窗口下拉和收回

- (void)setupAlertRect:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
}

//窗口下拉
- (void)loadAlertView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView {
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-alertView.bounds.size.height + 10]  repeatCount:0] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
}
//窗口收回
- (void)unloadAlertView:(IMBBorderRectAndColorView *)alertView {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:alertView.frame.size.height] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(_mainView.bounds) - alertView.frame.size.width) / 2), NSMaxY(_mainView.bounds), alertView.frame.size.width, alertView.frame.size.height)];
        [alertView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - 窗口配置
- (void)showAlertText:(NSString *)alertText withAlertButton:(NSString *)alertButtonStr withSuperView:(NSView *)superView {
    [(NSView *)[NSApplication sharedApplication].mainWindow.contentView addSubview:superView];
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_promptAlertView];
    
    //配置文字图片按钮
    
    [_promptAlertImage setImage:[NSImage imageNamed:@"other_alert"]];
    
    [_promptAlertTitle setStringValue:alertText];
    [_promptAlertTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_promptAlertButton setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_promptAlertButton setButtonTitle:alertButtonStr withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [_promptAlertButton setTarget:self];
    [_promptAlertButton setAction:@selector(closePromptAlertView)];
    
    //计算title位置
    NSRect titleRect = [StringHelper calcuTextBounds:_promptAlertTitle.stringValue font:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    if (titleRect.size.width <= 275) {
        [_promptAlertTitle setFrameOrigin:NSMakePoint(_promptAlertTitle.frame.origin.x,32)];
    } else {
        [_promptAlertTitle setFrameOrigin:NSMakePoint(_promptAlertTitle.frame.origin.x,40)];
    }
    
    NSRect btnRect = [StringHelper calcuTextBounds:alertButtonStr font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    float btnWidth = 80;
    if (btnRect.size.width + 40 > 80) {
        btnWidth = btnRect.size.width + 40;
    }
    [_promptAlertButton setFrame:NSMakeRect(_promptAlertView.frame.size.width - btnWidth - 20, _promptAlertButton.frame.origin.y, btnWidth, 22)];
}

- (int)showAlertText:(NSString *)alertText withCancelButton:(NSString *)cancelButtonStr withOKButton:(NSString *)okButtonStr withSuperView:(NSView *)superView {
    [(NSView *)[NSApplication sharedApplication].mainWindow.contentView addSubview:superView];
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_promptAlertView2];
    _endRunloop = NO;
    int result = -1;
    
    //配置文字图片按钮
    
    [_promptAlertImage2 setImage:[NSImage imageNamed:@"other_alert"]];
    
    [_promptAlertTitle2 setStringValue:alertText];
    [_promptAlertTitle2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_promptAlertOKBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_promptAlertOKBtn setButtonTitle:okButtonStr withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [_promptAlertOKBtn setTarget:self];
    [_promptAlertOKBtn setAction:@selector(promptAlertViewOkButtonClick)];
    
    
    [_promptAlertCancelBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_FillColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_FillColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_FillColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_FillColor", nil)]];
    [_promptAlertCancelBtn setButtonBorder:YES withNormalBorderColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_borderColor", nil)] withEnterBorderColor:[NSColor clearColor] withDownBorderColor:[NSColor clearColor] withForbiddenBorderColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_borderColor", nil)] withBorderLineWidth:1.0];
    [_promptAlertCancelBtn setButtonTitle:cancelButtonStr withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [_promptAlertCancelBtn setTarget:self];
    [_promptAlertCancelBtn setAction:@selector(promptAlertViewCancelButtonClick)];
    
    //计算title位置
    NSRect titleRect = [StringHelper calcuTextBounds:_promptAlertTitle2.stringValue font:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    if (titleRect.size.width <= 275) {
        [_promptAlertTitle2 setFrameOrigin:NSMakePoint(_promptAlertTitle2.frame.origin.x,32)];
    } else {
        [_promptAlertTitle2 setFrameOrigin:NSMakePoint(_promptAlertTitle2.frame.origin.x,40)];
    }
    
    //计算按钮位置
    NSRect cancelRect = [StringHelper calcuTextBounds:cancelButtonStr font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    NSRect okRect = [StringHelper calcuTextBounds:okButtonStr font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    float btnWidth = 80;
    if (okRect.size.width > cancelRect.size.width) {
        if (okRect.size.width + 40 > 80) {
            btnWidth = okRect.size.width + 40;
        }
    } else {
        if (cancelRect.size.width + 40 > 80) {
            btnWidth = cancelRect.size.width + 40;
        }
    }
    [_promptAlertOKBtn setFrame:NSMakeRect(_promptAlertView2.frame.size.width - btnWidth - 20, _promptAlertOKBtn.frame.origin.y, btnWidth, 22)];
    [_promptAlertCancelBtn setFrame:NSMakeRect(_promptAlertOKBtn.frame.origin.x - 15 - btnWidth, _promptAlertOKBtn.frame.origin.y, btnWidth, 22)];
    
    //加一个runloop
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
}

#pragma mark - 按钮事件
- (void)closePromptAlertView {
    [self unloadAlertView:_promptAlertView];
}

- (void)promptAlertViewOkButtonClick {
    _result = 1;
    _endRunloop = YES;
    [self unloadAlertView:_promptAlertView2];
}

- (void)promptAlertViewCancelButtonClick {
    _result = 0;
    _endRunloop = YES;
    [self unloadAlertView:_promptAlertView2];
}

@end

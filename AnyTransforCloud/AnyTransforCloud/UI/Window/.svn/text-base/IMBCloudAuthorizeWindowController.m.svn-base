//
//  IMBCloudAuthorizeWindowController.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/6.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCloudAuthorizeWindowController.h"
#import "IMBUpgradeWindow.h"
#import "StringHelper.h"
#import "IMBCloudManager.h"
#import "IMBAddCloudViewController.h"
#import "TempHelper.h"

@interface IMBCloudAuthorizeWindowController ()

@end

@implementation IMBCloudAuthorizeWindowController

- (id)initWithCloudEntity:(IMBCloudEntity *)cloudEntity withDelegate:(id)delegate {
    if (self = [super initWithWindowNibName:@"IMBCloudAuthorizeWindowController"]) {
        _cloudEntity = cloudEntity;
        _delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib {
    
    [self.window center];
    
    [[(IMBUpgradeWindow *)self.window minButton] setHidden:YES];
    [[(IMBUpgradeWindow *)self.window maxButton]  setHidden:YES];
    [(IMBBackGroundView *)((IMBUpgradeWindow *)self.window).maxAndminView setBackgroundColor:[NSColor clearColor]];
    [(NSView *)((IMBUpgradeWindow *)self.window).maxAndminView setFrameOrigin:NSMakePoint(10,NSHeight(_contentView.frame) - 26)];
    [_contentView addSubview:((IMBUpgradeWindow *)self.window).maxAndminView];
    
    [self configAuthorizedView];
}

#pragma mark - 配置视图
//点击授权视图配置
- (void)configAuthorizedView {
    [[(IMBUpgradeWindow *)self.window closeButton] setAction:@selector(closeWindow:)];
    [[(IMBUpgradeWindow *)self.window closeButton] setTarget:self];
    
    [_titleLabel setStringValue:CustomLocalizedString(@"AddCloud_Authorized_Title", nil)];
    [_titleLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_promptLabel setStringValue:CustomLocalizedString(@"AddCloud_Authorized_Describe", nil)];
    [_promptLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_bgImageView setImage:[NSImage imageNamed:@"add_allow"]];
    
    NSImage *cloudImage = [TempHelper getAuthorizateCloudImage:_cloudEntity.categoryCloudEnum];
    [_cloudImageView setImage:cloudImage];
    
    [_failedImageView setHidden:YES];
    
    [_authorizedBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_authorizedBtn setButtonTitle:CustomLocalizedString(@"AddCloud_Authorized_AuthButton", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [_authorizedBtn setSpaceWithText:4];
    [_authorizedBtn setTarget:self];
    [_authorizedBtn setAction:@selector(doAuthorizedClick:)];
    
    [_reauthorizeBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_FillColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_FillColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_FillColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_FillColor", nil)]];
    [_reauthorizeBtn setButtonBorder:YES withNormalBorderColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_borderColor", nil)] withEnterBorderColor:[NSColor clearColor] withDownBorderColor:[NSColor clearColor] withForbiddenBorderColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_borderColor", nil)] withBorderLineWidth:1.0];
    [_reauthorizeBtn setButtonTitle:CustomLocalizedString(@"AddCloud_ReAuthorized_AuthButton", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [_reauthorizeBtn setTarget:self];
    [_reauthorizeBtn setAction:@selector(doReauthorizeClick:)];
    
    //计算按钮位置
    NSRect cancelRect = [StringHelper calcuTextBounds:_reauthorizeBtn.title font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    NSRect okRect = [StringHelper calcuTextBounds:_authorizedBtn.title font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    float btnWidth = 96;
    if (okRect.size.width > cancelRect.size.width) {
        if (okRect.size.width + 40 > 96) {
            btnWidth = okRect.size.width + 40;
        }
    } else {
        if (cancelRect.size.width + 40 > 96) {
            btnWidth = cancelRect.size.width + 40;
        }
    }
    [_reauthorizeBtn setFrame:NSMakeRect((_contentView.frame.size.width - 2 * btnWidth - 12)/2, _reauthorizeBtn.frame.origin.y, btnWidth, _reauthorizeBtn.frame.size.height)];
    [_authorizedBtn setFrame:NSMakeRect(_reauthorizeBtn.frame.origin.x + 12 + btnWidth, _authorizedBtn.frame.origin.y, btnWidth, _authorizedBtn.frame.size.height)];
    
    [_reauthorizeBtn setNeedsDisplay:YES];
    [_authorizedBtn setNeedsDisplay:YES];
}

//授权失败 视图配置
- (void)configAuthorizedFailedView {
    
    [[(IMBUpgradeWindow *)self.window closeButton] setTarget:self];
    [[(IMBUpgradeWindow *)self.window closeButton] setAction:@selector(onlyCloseWindow:)];
    
    [_titleLabel setStringValue:CustomLocalizedString(@"AddCloud_AuthorizedFailed_Title", nil)];
    [_titleLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_promptLabel setStringValue:CustomLocalizedString(@"AddCloud_AuthorizedFailed_Describe", nil)];
    [_promptLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_bgImageView setImage:[NSImage imageNamed:@"add_allow"]];
    
    NSImage *cloudImage = [TempHelper getAuthorizateCloudImage:_cloudEntity.categoryCloudEnum];
    [_cloudImageView setImage:cloudImage];
    
    [_failedImageView setHidden:NO];
    [_failedImageView setImage:[NSImage imageNamed:@"add_alert"]];
    
    [_authorizedBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_leftColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_normal_rightColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_leftColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"okBtn_forbiden_rightColor", nil)]];
    [_authorizedBtn setButtonTitle:CustomLocalizedString(@"AddCloud_ReAuthorized_AuthButton", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [_authorizedBtn setSpaceWithText:4];
    [_authorizedBtn setTarget:self];
    [_authorizedBtn setAction:@selector(doReauthorizeClick:)];
    
    [_reauthorizeBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_FillColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_FillColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_enter_leftColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_enter_rightColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_down_leftColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_down_rightColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_FillColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_FillColor", nil)]];
    [_reauthorizeBtn setButtonBorder:YES withNormalBorderColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_normal_borderColor", nil)] withEnterBorderColor:[NSColor clearColor] withDownBorderColor:[NSColor clearColor] withForbiddenBorderColor:[StringHelper getColorFromString:CustomColor(@"cancelBtn_forbiden_borderColor", nil)] withBorderLineWidth:1.0];
    [_reauthorizeBtn setButtonTitle:CustomLocalizedString(@"Button_Cancel", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"btnTitle_hightLight_Color", nil)] withTitleSize:12.0 WithLightAnimation:NO];
    [_reauthorizeBtn setTarget:self];
    [_reauthorizeBtn setAction:@selector(onlyCloseWindow:)];
    
    //计算按钮位置
    NSRect cancelRect = [StringHelper calcuTextBounds:_reauthorizeBtn.title font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    NSRect okRect = [StringHelper calcuTextBounds:_authorizedBtn.title font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    float btnWidth = 96;
    if (okRect.size.width > cancelRect.size.width) {
        if (okRect.size.width + 40 > 96) {
            btnWidth = okRect.size.width + 40;
        }
    } else {
        if (cancelRect.size.width + 40 > 96) {
            btnWidth = cancelRect.size.width + 40;
        }
    }
    [_reauthorizeBtn setFrame:NSMakeRect((_contentView.frame.size.width - 2 * btnWidth - 12)/2, _reauthorizeBtn.frame.origin.y, btnWidth, _reauthorizeBtn.frame.size.height)];
    [_authorizedBtn setFrame:NSMakeRect(_reauthorizeBtn.frame.origin.x + 12 + btnWidth, _authorizedBtn.frame.origin.y, btnWidth, _authorizedBtn.frame.size.height)];
    
    [_reauthorizeBtn setNeedsDisplay:YES];
    [_authorizedBtn setNeedsDisplay:YES];
}

//刷新
- (void)doAuthorizedClick:(id)sender {
    [self closeWindow:sender];
}

//重新授权
- (void)doReauthorizeClick:(id)sender {
    [self onlyCloseWindow:sender];
    [_delegate chooseCloud:_cloudEntity];
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

- (void)onlyCloseWindow:(id)sender {
    [self.window close];
}

- (void)closeWindow:(id)sender {
    IMBCloudManager *manage = [IMBCloudManager singleton];
    [manage refresh];
    [self.window close];
}

@end

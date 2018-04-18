//
//  IMBNewAnnoyViewController.m
//  AnyTrans
//
//  Created by iMobie on 3/24/18.
//  Copyright (c) 2018 imobie. All rights reserved.
//

#import "IMBNewAnnoyViewController.h"
#import "IMBBackgroundBorderView.h"
#import "IMBNotificationDefine.h"
#import "HoverButton.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "IMBSoftWareInfo.h"
#import "IMBBaseViewController.h"
#import "IMBAddContentViewController.h"
#import "ATTracker.h"
#import "SystemHelper.h"

@interface IMBNewAnnoyViewController ()

@end

@implementation IMBNewAnnoyViewController
@synthesize isClone = _isClone;
@synthesize isMerge = _isMerge;
@synthesize isAddContent = _isAddContent;
@synthesize isContentToMac = _isContentToMac;
@synthesize category = _category;
- (id)initWithNibName:(NSString *)nibNameOrNil Delegate:(id)delegate Result:(long long*)reslut {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Initialization code here.
        _result = reslut;
        _delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    [((IMBBackgroundBorderView *)self.view) setIsGradientWithCornerPart4:YES];
    [((IMBBackgroundBorderView *)self.view) setCanScroll:NO];
    [((IMBBackgroundBorderView *)self.view) setCanClick:NO];
    [((IMBBackgroundBorderView *)self.view) setWantsLayer:YES];
    [((IMBBackgroundBorderView *)self.view).layer setCornerRadius:5];
    
    _limitation = [OperationLImitation singleton];
    NSDictionary *dimensionDict = nil;
    if (_limitation.remainderCount>0 && _limitation.remainderDays>0 && !_isClone && !_isMerge) {
        [_limitation setLimitStatus:@"start"];
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:AdAnnoy actionParams:@"start" label:LabelNone transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_limitation setLimitStatus:@""];
        //既有天数 又有个数
        [self addTransferStartAnnoyView];
        [[IMBSoftWareInfo singleton] setIsOpenAnnoy:YES];
    }else if (_limitation.remainderCount == 0 && _limitation.remainderDays>0 && !_isClone && !_isMerge){
        [_limitation setLimitStatus:@"noquote"];
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:AdAnnoy actionParams:@"noquote" label:LabelNone transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];

        //有天数 个数为0
        [self addRunOutDayAnnoyView];
    }else{
        [_limitation setLimitStatus:@"expired"];
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:AdAnnoy actionParams:@"expired" label:LabelNone transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];

        //过期
        [self addExprieAnnoyView];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

#pragma mark - 引导开始传输的骚扰页面
- (void)addTransferStartAnnoyView {
    //增加关闭按钮
    HoverButton *closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(self.view.frame) - 32 - 7)), 32, 32)];
    closebutton.tag = 121;
    closebutton.autoresizesSubviews = YES;
    closebutton.autoresizingMask = NSViewMinYMargin;
    [closebutton setEnabled:YES];
    [closebutton setTarget:self];
    [closebutton setAction:@selector(closeWindow:)];
    [closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_transferStartAnnoyView addSubview:closebutton];
    [closebutton release];
    
    //购买按钮
    [_transferStartBuyBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"download_normal_leftcolor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"download_normal_rightcolor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"download_enter_leftcolor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"download_enter_rightcolor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"download_down_leftcolor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"download_down_rightcolor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"download_normal_leftcolor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"download_normal_rightcolor", nil)]];
    [_transferStartBuyBtn setButtonTitle:CustomLocalizedString(@"Annoy_StartTransfer_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:19.0 WithLightAnimation:NO];
    [_transferStartBuyBtn setHasRightImage:YES];
    [_transferStartBuyBtn setSpaceWithText:4];
    [_transferStartBuyBtn setRightImage:[StringHelper imageNamed:@"annoy_buy_arrow"]];
    [_transferStartBuyBtn setHasBorder:NO];
    [_transferStartBuyBtn setIsiCloudCompleteBtn:YES];
    [_transferStartBuyBtn setTarget:self];
    [_transferStartBuyBtn setAction:@selector(startFreeTransfer:)];
    [_transferStartBuyBtn setNeedsDisplay:YES];
    
    
    NSRect rect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Annoy_StartTransfer_BtnTitle", nil) fontSize:19];
    int width = (int)(rect.size.width + 4 + 32 + 120);
    [_transferStartBuyBtn setFrame:NSMakeRect(ceil((_transferStartAnnoyView.frame.size.width - width) / 2.0), _transferStartBuyBtn.frame.origin.y,width,_transferStartBuyBtn.frame.size.height)];
    
    //设置文字
    [_transferStartTitleLable setStringValue:CustomLocalizedString(@"Annoy_StartTransfer_Title", nil)];
    [_transferStartPromptLable setStringValue:CustomLocalizedString(@"Annoy_StartTransfer_SubTitle", nil)];
    [_transferStartExplainLable1 setStringValue:CustomLocalizedString(@"Annoy_StartTransfer_Detail_OneTitle", nil)];
    [_transferStartExplainLable2 setStringValue:CustomLocalizedString(@"Annoy_StartTransfer_Detail_TwoTitle", nil)];
    [_transferStartExplainLable3 setStringValue:CustomLocalizedString(@"Annoy_StartTransfer_Detail_ThreeTitle", nil)];
    [_transferStartExplainLable4 setStringValue:CustomLocalizedString(@"Annoy_StartTransfer_Detail_FourTitle", nil)];
    
    //配置颜色
    [_transferStartTitleLable setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_transferStartPromptLable setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    [_transferStartExplainLable1 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_transferStartExplainLable2 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_transferStartExplainLable3 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_transferStartExplainLable4 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    
    NSString *promptStr = CustomLocalizedString(@"Annoy_StartTransfer_Detail_OneSubTitle", nil);
    [self setTextType:promptStr withTextLable:_transferStartExplainSubLable1];
    promptStr = CustomLocalizedString(@"Annoy_StartTransfer_Detail_TwoSubTitle", nil);
    [self setTextType:promptStr withTextLable:_transferStartExplainSubLable2];
    promptStr = CustomLocalizedString(@"Annoy_StartTransfer_Detail_ThreeSubTitle", nil);
    [self setTextType:promptStr withTextLable:_transferStartExplainSubLable3];
    promptStr = CustomLocalizedString(@"Annoy_StartTransfer_Detail_FourSubTitle", nil);
    [self setTextType:promptStr withTextLable:_transferStartExplainSubLable4];
    
    [_transferStartLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_transferStartBotLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    [_contentBox setContentView:_transferStartAnnoyView];
}

- (void)setTextType:(NSString *)promptStr withTextLable:(NSTextField *)textField {
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [textField setAttributedStringValue:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
}

- (void)startFreeTransfer:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [_limitation setLimitStatus:@"start"];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:@"start" label:Try transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_limitation setLimitStatus:@""];
    if ([_delegate isKindOfClass:[IMBAddContentViewController class]]) {
        ((IMBAddContentViewController *)_delegate)->_endRunloop = YES;
    }else {
        ((IMBBaseViewController *)_delegate)->_endRunloop = YES;
    }
}

#pragma mark - 当天额度用完的骚扰页面
- (void)addRunOutDayAnnoyView {
    //增加关闭按钮
    HoverButton *closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(self.view.frame) - 32 - 7)), 32, 32)];
    closebutton.tag = 121;
    closebutton.autoresizesSubviews = YES;
    closebutton.autoresizingMask = NSViewMinYMargin;
    [closebutton setEnabled:YES];
    [closebutton setTarget:self];
    [closebutton setAction:@selector(closeWindow:)];
    [closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_runOutDayAnnoyView addSubview:closebutton];
    [closebutton release];
    
    //购买按钮
    [_runOutDayStartBuyBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_normal_color", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_normal_color", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_enter_color", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_enter_color", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_down_color", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_down_color", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_normal_color", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_normal_color", nil)]];
    [_runOutDayStartBuyBtn setButtonTitle:CustomLocalizedString(@"Annoy_Activate_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:19.0 WithLightAnimation:NO];
    _runOutDayStartBuyBtn.tag = 100;
    [_runOutDayStartBuyBtn setHasRightImage:YES];
    [_runOutDayStartBuyBtn setRightImage:[StringHelper imageNamed:@"annoy_buy_arrow"]];
    [_runOutDayStartBuyBtn setHasBorder:NO];
    [_runOutDayStartBuyBtn setIsiCloudCompleteBtn:YES];
    [_runOutDayStartBuyBtn setTarget:self];
    [_runOutDayStartBuyBtn setAction:@selector(startBuyButtonClick:)];
    [_runOutDayStartBuyBtn setNeedsDisplay:YES];
    
    NSRect rect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Annoy_Activate_BtnTitle", nil) fontSize:19];
    int width = (int)(rect.size.width + 4 + 32 + 120);
    [_runOutDayStartBuyBtn setFrame:NSMakeRect(ceil((_runOutDayAnnoyView.frame.size.width - width) / 2.0), _runOutDayStartBuyBtn.frame.origin.y,width,_runOutDayStartBuyBtn.frame.size.height)];
    
    //设置文字
    [_runOutDayTitleLable setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_Title", nil)];
    [_runOutDaySubTitleLable setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SubTitle", nil)];
    [_runOutDayExplainLable1 setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SecondPart_SubTitle_1", nil)];
    [_runOutDayExplainLable2 setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SecondPart_SubTitle_2", nil)];
    [_runOutDayExplainLable3 setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SecondPart_SubTitle_3", nil)];
    [_runOutDayExplainLable4 setStringValue:CustomLocalizedString(@"Annoy_Runout_Number_SecondPart_SubTitle_4", nil)];

    //配置颜色
    [_runOutDayTitleLable setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_runOutDaySubTitleLable setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    [_runOutDayExplainLable1 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_runOutDayExplainLable2 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_runOutDayExplainLable3 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_runOutDayExplainLable4 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];

    [_runOutDayBgView setHasCorner:YES];
    [_runOutDayBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)]];
    [_runOutDayBgView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];

    [_runOutDayActiveTextView setLinkStrIsFront:NO];
    [_runOutDayActiveTextView setNormalString:CustomLocalizedString(@"Annoy_Runout_Number_ThirdPart_SubTitle_1", nil) WithLinkString:CustomLocalizedString(@"Annoy_Runout_Number_ThirdPart_SubTitle_2", nil) WithNormalColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_runOutDayActiveTextView setAlignment:NSCenterTextAlignment];
    [_runOutDayActiveTextView setDelegate:self];
    [_runOutDayActiveTextView setSelectable:YES];
    
    [_contentBox setContentView:_runOutDayAnnoyView];
}

- (void)startBuyButtonClick:(id)sender {
    _limitation = [OperationLImitation singleton];
    NSDictionary *dimensionDict = nil;
    if (_limitation.remainderCount == 0 && _limitation.remainderDays>0 && !_isClone && !_isMerge){
        @autoreleasepool {
            [_limitation setLimitStatus:@"noquote"];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@#status=noquote", [TempHelper currentSelectionLanguage]] label:Buy transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else{
        @autoreleasepool {
            [_limitation setLimitStatus:@"expired"];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@#status=expired", [TempHelper currentSelectionLanguage]] label:Buy transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
    //判读是否是折扣链接：_expireViewBuyBtn.tag = 101（折扣链接）、_runOutDayStartBuyBtn.tag = 100;
    BOOL isDisCount = NO;
    IMBGridientButton *btn = (IMBGridientButton *)sender;
    if (btn.tag == 101) {
        isDisCount = YES;
    }
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [SystemHelper openChooseBrowser:softWare.buyId withIsActivate:NO isDiscount:isDisCount isNeedAnalytics:YES];
}

#pragma mark - 试用到期的骚扰页面
- (void)addExprieAnnoyView {
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    //增加关闭按钮
    HoverButton *closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(self.view.frame) - 32 - 7)), 32, 32)];
    closebutton.tag = 121;
    closebutton.autoresizesSubviews = YES;
    closebutton.autoresizingMask = NSViewMinYMargin;
    [closebutton setEnabled:YES];
    [closebutton setTarget:self];
    [closebutton setAction:@selector(closeWindow:)];
    [closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_expireAnnoyView addSubview:closebutton];
    [closebutton release];
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Annoy_Runout_Day_Title", nil)];
    NSRange range = NSMakeRange(0, as.length);
    [as setAlignment:NSCenterTextAlignment range:range];
    [_expireViewMainTitle setAttributedStringValue:as];
    [as release], as = nil;
    [_expireViewMainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_expireViewSubtitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Annoy_Runout_Day_SubTitle", nil),soft.discount]];
    [_expireViewSubtitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    
    [_expireViewNumberTextFiled setWantsLayer:YES];
    _expireViewNumberTextFiled.layer.shadowOpacity = 1.0;
    _expireViewNumberTextFiled.layer.shadowColor = [NSColor colorWithDeviceRed:44/255.0 green:205/255.0 blue:249/255.0 alpha:1.0].CGColor;
    _expireViewNumberTextFiled.layer.shadowOffset = CGSizeMake(0, 5.0);
    _expireViewNumberTextFiled.layer.shadowRadius = 5.0;
    _expireViewNumberTextFiled.backgroundColor = [NSColor clearColor];
    [_expireViewNumberTextFiled setStringValue:[NSString stringWithFormat:@"-%@",soft.discount]];
    
    
    [_expireViewBuyBtn setCornerRadius:5];
    [_expireViewBuyBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"exprie_left_normal_color", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"exprie_right_normal_color", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"exprie_left_enter_color", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"exprie_right_enter_color", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"exprie_left_down_color", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"exprie_right_down_color", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"exprie_left_normal_color", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"exprie_right_normal_color", nil)]];
    [_expireViewBuyBtn setButtonTitle:CustomLocalizedString(@"Annoy_Runout_Day_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] withTitleSize:19 WithLightAnimation:NO];
    [_expireViewBuyBtn setButtonBorder:YES withNormalBorderColor:[NSColor clearColor] withEnterBorderColor:[NSColor clearColor] withDownBorderColor:[NSColor clearColor] withForbiddenBorderColor:[NSColor clearColor] withBorderLineWidth:1.0];
    [_expireViewBuyBtn setIsiCloudCompleteBtn:YES];
    _expireViewBuyBtn.tag = 101;
    [_expireViewBuyBtn setTarget:self];
    [_expireViewBuyBtn setAction:@selector(startBuyButtonClick:)];
    [_expireViewBuyBtn setNeedsDisplay:YES];

    [_contentBox setContentView:_expireAnnoyView];
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    if ([link isEqualToString:CustomLocalizedString(@"Annoy_Runout_Number_ThirdPart_SubTitle_2", nil)]) {
        //气泡的形式弹出注册窗口
        if (_activatePopover != nil) {
            if (_activatePopover.isShown) {
                [_activatePopover close];
                return YES;
            }
        }
        if (_activatePopover != nil) {
            [_activatePopover release];
            _activatePopover = nil;
        }
        _activatePopover = [[NSPopover alloc] init];
        
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
            _activatePopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
        }else {
            _activatePopover.appearance = NSPopoverAppearanceMinimal;
        }
        
        _activatePopover.animates = YES;
        _activatePopover.behavior = NSPopoverBehaviorApplicationDefined;
        _popoverViewController = [[IMBPopoverActivateViewController alloc] initWithDelegate:self];
        if (_activatePopover != nil) {
            _activatePopover.contentViewController = _popoverViewController;
        }
        
        [_popoverViewController release];
        NSRectEdge prefEdge = NSMinYEdge;
        
        int x = 175;
        if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
            x = 175;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
            x = 215;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
            x = 200;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
            x = 175;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
            x = 140;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
            x = 175;
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            x = 30;
        }
        NSRect rect = NSMakeRect(x, textView.bounds.origin.y - 16, 410, 84);
        [_activatePopover showRelativeToRect:rect ofView:textView preferredEdge:prefEdge];
    }
    return YES;
}

- (void)activateSuccess {
    *_result = NSIntegerMax;
    [[NSNotificationCenter defaultCenter] postNotificationName:ANNOY_REGIST_SUCCESS object:nil];
    if ([_delegate isKindOfClass:[IMBAddContentViewController class]]) {
        ((IMBAddContentViewController *)_delegate)->_endRunloop = YES;
    }else {
        ((IMBBaseViewController *)_delegate)->_endRunloop = YES;
    }
    if (_activatePopover != nil) {
        if (_activatePopover.isShown) {
            [_activatePopover close];
        }
    }
//    if ([_delegate respondsToSelector:@selector(startTransfer:)]) {
//        //由于在有传输个数的时候，不会出现注册激活的按钮，所以不会出现重复调用传输过程；
//        [_delegate startTransfer:self];
//    }
}

- (void)closeWindow:(id)sender {
    if (_activatePopover != nil) {
        if (_activatePopover.isShown) {
            [_activatePopover close];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
    *_result = 0;
    if ([_delegate isKindOfClass:[IMBAddContentViewController class]]) {
        ((IMBAddContentViewController *)_delegate)->_endRunloop = YES;
    }else {
        ((IMBBaseViewController *)_delegate)->_endRunloop = YES;
    }
    [self.view setFrame: NSMakeRect(0, -20, NSWidth(self.view.frame), NSHeight(self.view.frame)+20)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(0) Y:@(20) repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.layer addAnimation:anima1 forKey:@"moveY"];
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(20) Y:@(-NSHeight(self.view.frame)) repeatCount:1];
            anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [self.view.layer addAnimation:anima1 forKey:@"moveY"];
        } completionHandler:^{
            [self.view removeFromSuperview];
            [self release];
        }];
    }];
}

- (void)dealloc {
    if (_activatePopover != nil) {
        [_activatePopover close];
        [_activatePopover release];
        _activatePopover = nil;
    }
    [super dealloc];
}

@end

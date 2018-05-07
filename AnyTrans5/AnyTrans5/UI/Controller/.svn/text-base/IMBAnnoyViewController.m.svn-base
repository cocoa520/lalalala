//
//  IMBAnnoyViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-9-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBAnnoyViewController.h"
#import "IMBAnimation.h"
#import "IMBBackgroundBorderView.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"
#import "IMBBaseViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftWareInfo.h"
#import "SystemHelper.h"
@interface IMBAnnoyViewController ()

@end

@implementation IMBAnnoyViewController
@synthesize isClone = _isClone;
@synthesize isMerge = _isMerge;
@synthesize isAddContent = _isAddContent;
@synthesize isContentToMac = _isContentToMac;
@synthesize category = _category;
- (id)initWithNibName:(NSString *)nibNameOrNil Delegate:(id)delegate Result:(long long*)reslut
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Initialization code here.
        _result = reslut;
        _delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    [((IMBBackgroundBorderView *)self.view) setIsGradientWithCornerPart4:YES];
    _limitation = [OperationLImitation singleton];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
        [_freeTry setImage:[StringHelper imageNamed:@"annoy_freetry_en"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        [_freeTry setImage:[StringHelper imageNamed:@"annoy_freetry_jp"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [_freeTry setImage:[StringHelper imageNamed:@"annoy_freetry_de"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
        [_freeTry setImage:[StringHelper imageNamed:@"annoy_freetry_fr"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
        [_freeTry setImage:[StringHelper imageNamed:@"annoy_freetry_es"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [_freeTry setImage:[StringHelper imageNamed:@"annoy_freetry_ar"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        [_freeTry setImage:[StringHelper imageNamed:@"annoy_freetry_ch"]];
    }else{
        [_freeTry setImage:[StringHelper imageNamed:@"annoy_freetry_en"]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:-4.0f];
    [textParagraph setAlignment:NSCenterTextAlignment];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    [_freeTryTextField setHidden:YES];
    [((IMBBackgroundBorderView *)self.view) setCanScroll:NO];
    [((IMBBackgroundBorderView *)self.view) setCanClick:NO];
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    if (([soft.curUseSkin isEqualToString:@"christmasSkin"] && [StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage)) {//圣诞节活动，只针对英语版本、圣诞节皮肤在圣诞节期间显示
        //[_annoyTitleField setFrameOrigin:NSMakePoint(_annoyTitleField.frame.origin.x, _annoyTitleField.frame.origin.y - 30)];
    }
    if (_limitation.remainderCount>0&&!_isClone&&!_isMerge) {
        //既有天数 又有个数
        if ([soft.curUseSkin isEqualToString:@"christmasSkin"]) {
            [_animtionBGView setAutoresizesSubviews:YES];
            [_animtionBGView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewWidthSizable];
            [_animtionBGView addSubview:_annoyAnimaitonViewFive];
            
            if ([StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {//圣诞节活动，只针对英语版本、圣诞节皮肤在圣诞节期间显示
                [self setAnnoyZeroTitle:CustomLocalizedString(@"Christmas_Active_id_1", nil) textParagraph:textParagraph];
//                [self setAnnoyZerosubTitle:CustomLocalizedString(@"Christmas_Active_id_2", nil) textParagraph:textParagraph];
                [self setAnnoyChistmasSubTitle:CustomLocalizedString(@"Christmas_Active_id_2", nil) withTaggingTitleOne:CustomLocalizedString(@"Christmas_Active_id_2_1", nil) withOneColor:[NSColor blackColor] withTaggingTitleTwo:CustomLocalizedString(@"Christmas_Active_id_2_2", nil) withTwoColor:[NSColor colorWithDeviceRed:221.f/255 green:54.f/255 blue:53.f/255 alpha:1.f] textParagraph:textParagraph];
                [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_active"]];
            }else {
                if (_limitation.remainderDays  == 1) {
                    [self setAnnoyTitle:CustomLocalizedString(@"RegisterWindow_limitTitle_id_1", nil) textParagraph:textParagraph];
                }else{
                    [self setAnnoyTitle:CustomLocalizedString(@"RegisterWindow_limitTitles_id_1", nil) textParagraph:textParagraph];
                }
                [self setAnnoysubTitle:CustomLocalizedString(@"RegisterWindow_limitDetail_id_5", nil) textParagraph:textParagraph];

                [self setChristmasImage];
            }
        }else if ([soft.curUseSkin isEqualToString:@"thanksgivingSkin"]) {
            [_animtionBGView setAutoresizesSubviews:YES];
            [_animtionBGView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewWidthSizable];
            [_animtionBGView addSubview:_annoyAnimaitonViewSix];
            
            if (_limitation.remainderDays  == 1) {
                [self setAnnoyTitle:CustomLocalizedString(@"RegisterWindow_limitTitle_id_1", nil) textParagraph:textParagraph];
            }else{
                [self setAnnoyTitle:CustomLocalizedString(@"RegisterWindow_limitTitles_id_1", nil) textParagraph:textParagraph];
            }
            [self setAnnoysubTitle:CustomLocalizedString(@"RegisterWindow_limitDetail_id_5", nil) textParagraph:textParagraph];
            [self setThanksGivingImage];
            
        }else{
            [_animtionBGView addSubview:_annoyAnimaitonView];
            [_annoyAnimaitonView startAnimation];
            if (_limitation.remainderCount  == 1) {
                [_annoyAnimaitonView setRemainderCount:(int)_limitation.remainderCount Unit:CustomLocalizedString(@"annoy_id_2", nil)];
            }else{
                [_annoyAnimaitonView setRemainderCount:(int)_limitation.remainderCount Unit:CustomLocalizedString(@"annoy_id_3", nil)];
            }
//            if ([StringHelper chirstmasActivity]) {//圣诞节活动，只针对英语版本在圣诞节期间显示
//                if (_limitation.remainderDays  == 1) {
//                    [_annoyAnimaitonView setRemainderDays:_limitation.remainderDays Unit:CustomLocalizedString(@"MSG_Item_id_day", nil)];
//                }else{
//                    [_annoyAnimaitonView setRemainderDays:_limitation.remainderDays Unit:CustomLocalizedString(@"MSG_Item_id_days", nil)];
//                }
//                [self setAnnoyZeroTitle:CustomLocalizedString(@"Christmas_Active_id_1", nil) textParagraph:textParagraph];
////                [self setAnnoyZerosubTitle:CustomLocalizedString(@"Christmas_Active_id_2", nil) textParagraph:textParagraph];
//                [self setAnnoyChistmasSubTitle:CustomLocalizedString(@"Christmas_Active_id_2", nil) withTaggingTitleOne:CustomLocalizedString(@"Christmas_Active_id_2_1", nil) withOneColor:[NSColor blackColor] withTaggingTitleTwo:CustomLocalizedString(@"Christmas_Active_id_2_2", nil) withTwoColor:[NSColor colorWithDeviceRed:221.f/255 green:54.f/255 blue:53.f/255 alpha:1.f] textParagraph:textParagraph];
//            }else {
                if (_limitation.remainderDays  == 1) {
                    [self setAnnoyTitle:CustomLocalizedString(@"RegisterWindow_limitTitle_id_1", nil) textParagraph:textParagraph];
                    [_annoyAnimaitonView setRemainderDays:(int)_limitation.remainderDays Unit:CustomLocalizedString(@"MSG_Item_id_day", nil)];
                }else{
                    [self setAnnoyTitle:CustomLocalizedString(@"RegisterWindow_limitTitles_id_1", nil) textParagraph:textParagraph];
                    [_annoyAnimaitonView setRemainderDays:(int)_limitation.remainderDays Unit:CustomLocalizedString(@"MSG_Item_id_days", nil)];
                }
                [self setAnnoysubTitle:CustomLocalizedString(@"RegisterWindow_limitDetail_id_5", nil) textParagraph:textParagraph];
//            }
        }
    }else if (_limitation.remainderCount == 0&&_limitation.remainderDays>0&&!_isClone&&!_isMerge){
        //有天数 个数为0
        if ([soft.curUseSkin isEqualToString:@"christmasSkin"] && [StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {//圣诞节活动，只针对英语版本、圣诞节皮肤在圣诞节期间显示
            [self setAnnoyZeroTitle:CustomLocalizedString(@"Christmas_Active_id_3", nil) textParagraph:textParagraph];
//            [self setAnnoyZerosubTitle:CustomLocalizedString(@"Christmas_Active_id_4", nil) textParagraph:textParagraph];
            [self setAnnoyChistmasSubTitle:CustomLocalizedString(@"Christmas_Active_id_4", nil) withTaggingTitleOne:CustomLocalizedString(@"Christmas_Active_id_4_1", nil) withOneColor:[NSColor colorWithDeviceRed:221.f/255 green:54.f/255 blue:53.f/255 alpha:1.f] withTaggingTitleTwo:CustomLocalizedString(@"Christmas_Active_id_2_2", nil) withTwoColor:[NSColor colorWithDeviceRed:221.f/255 green:54.f/255 blue:53.f/255 alpha:1.f] textParagraph:textParagraph];
        } else {
            [self setAnnoyZeroTitle:CustomLocalizedString(@"RegisterWindow_limitTilte_id_6", nil) textParagraph:textParagraph];
            [self setAnnoyZerosubTitle:CustomLocalizedString(@"RegisterWindow_limitDetail_id_6", nil) textParagraph:textParagraph];
        }
        if ([soft.curUseSkin isEqualToString:@"christmasSkin"]) {
            [_animtionBGView setAutoresizesSubviews:YES];
            [_animtionBGView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewWidthSizable];
            [_animtionBGView addSubview:_annoyAnimaitonViewFive];
            
            if ([StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {//圣诞节活动，只针对英语版本、圣诞节皮肤在圣诞节期间显示
                [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_active"]];
            }else {
                [self setChristmasImage];
            }
        }else if ([soft.curUseSkin isEqualToString:@"thanksgivingSkin"]) {
            [_animtionBGView setAutoresizesSubviews:YES];
            [_animtionBGView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewWidthSizable];
            [_animtionBGView addSubview:_annoyAnimaitonViewSix];
            [self setThanksGivingImage];
            
        }else{
            [_animtionBGView addSubview:_annoyAnimationViewTwo];
            [_annoyAnimationViewTwo startAnimation];
            [_annoyAnimationViewTwo setRemainderCount:(int)_limitation.remainderCount Unit:CustomLocalizedString(@"annoy_id_2", nil)];
            
        }
    }else{
        //过期
        if ([soft.curUseSkin isEqualToString:@"christmasSkin"] && [StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {//圣诞节活动，只针对英语版本、圣诞节皮肤在圣诞节期间显示
            [self setAnnoyZeroTitle:CustomLocalizedString(@"Christmas_Active_id_5", nil) textParagraph:textParagraph];
            [self setAnnoyChistmasSubTitle:CustomLocalizedString(@"Christmas_Active_id_6", nil) withTaggingTitleOne:CustomLocalizedString(@"Christmas_Active_id_4_1", nil) withOneColor:[NSColor colorWithDeviceRed:221.f/255 green:54.f/255 blue:53.f/255 alpha:1.f] withTaggingTitleTwo:CustomLocalizedString(@"Christmas_Active_id_2_2", nil) withTwoColor:[NSColor colorWithDeviceRed:221.f/255 green:54.f/255 blue:53.f/255 alpha:1.f] textParagraph:textParagraph];
        }else {
            [self setAnnoyOverDueTitle:CustomLocalizedString(@"RegisterWindow_limitTilte_id_2", nil) textParagraph:textParagraph];
            [self setAnnoyZerosubTitle:CustomLocalizedString(@"RegisterWindow_limitDetail_id_2", nil) textParagraph:textParagraph];
        }
        if ([soft.curUseSkin isEqualToString:@"christmasSkin"]) {
            [_animtionBGView setAutoresizesSubviews:YES];
            [_animtionBGView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewWidthSizable];
            [_animtionBGView addSubview:_annoyAnimaitonViewFive];
            if ([StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {//圣诞节活动，只针对英语版本、圣诞节皮肤在圣诞节期间显示
                [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_active"]];
            }else {
                [self setChristmasImage];
            }
        }else if ([soft.curUseSkin isEqualToString:@"thanksgivingSkin"]) {
            [_animtionBGView setAutoresizesSubviews:YES];
            [_animtionBGView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewWidthSizable];
            [_animtionBGView addSubview:_annoyAnimaitonViewSix];
            [self setThanksGivingImage];
            
        }else{
            [_animtionBGView addSubview:_annoyAnimationViewThree];
            [_annoyAnimationViewThree startAnimation];
        }
    }
    if ([soft.curUseSkin isEqualToString:@"christmasSkin"] && [StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {//圣诞节活动，只针对英语版本、圣诞节皮肤在圣诞节期间显示
        if (_isClone) {
            [self setAnnoyZeroTitle:CustomLocalizedString(@"Christmas_Active_id_7", nil) textParagraph:textParagraph];
//            [self setAnnoyZerosubTitle:CustomLocalizedString(@"Christmas_Active_id_8", nil) textParagraph:textParagraph];
            [self setAnnoyChistmasSubTitle:CustomLocalizedString(@"Christmas_Active_id_8", nil) withTaggingTitleOne:nil withOneColor:nil withTaggingTitleTwo:CustomLocalizedString(@"Christmas_Active_id_2_2", nil) withTwoColor:[NSColor colorWithDeviceRed:221.f/255 green:54.f/255 blue:53.f/255 alpha:1.f] textParagraph:textParagraph];
        }else if (_isMerge) {
            [self setAnnoyZeroTitle:CustomLocalizedString(@"Christmas_Active_id_9", nil) textParagraph:textParagraph];
//            [self setAnnoyZerosubTitle:CustomLocalizedString(@"Christmas_Active_id_10", nil) textParagraph:textParagraph];
            [self setAnnoyChistmasSubTitle:CustomLocalizedString(@"Christmas_Active_id_10", nil) withTaggingTitleOne:nil withOneColor:nil withTaggingTitleTwo:CustomLocalizedString(@"Christmas_Active_id_2_2", nil) withTwoColor:[NSColor colorWithDeviceRed:221.f/255 green:54.f/255 blue:53.f/255 alpha:1.f] textParagraph:textParagraph];
        }
    }else {
        if (_isClone || _isMerge) {
            if (_limitation.remainderDays>0) {
                if (_limitation.remainderDays  == 1) {
                    [self setAnnoyTitle:CustomLocalizedString(@"RegisterWindow_limitTitle_id_1", nil) textParagraph:textParagraph];
                }else{
                    [self setAnnoyTitle:CustomLocalizedString(@"RegisterWindow_limitTitles_id_1", nil) textParagraph:textParagraph];
                }
            }else{
                [self setAnnoyOverDueTitle:CustomLocalizedString(@"RegisterWindow_limitTilte_id_2", nil) textParagraph:textParagraph];
            }
        }
        
        if (_isClone) {
            if (_limitation.remainderDays<=0) {
                [self setAnnoyZerosubTitle:CustomLocalizedString(@"RegisterWindow_limitDetail_id_2", nil) textParagraph:textParagraph];
            }else{
                NSString *des = [NSString stringWithFormat:@"%@ %@",CustomLocalizedString(@"RegisterWindow_limitCloneDetail_id_1", nil),CustomLocalizedString(@"RegisterWindow_limitCloneDetail_id_1_1", nil)];
                [self setAnnoyClonesubTitle:des textParagraph:textParagraph];
            }
        }
        if (_isMerge) {
            if (_limitation.remainderDays<=0) {
                [self setAnnoyZerosubTitle:CustomLocalizedString(@"RegisterWindow_limitDetail_id_2", nil) textParagraph:textParagraph];
            }else{
                NSString *des = [NSString stringWithFormat:@"%@ %@",CustomLocalizedString(@"RegisterWindow_limitMergeDetail_id_1", nil),CustomLocalizedString(@"RegisterWindow_limitMergeDetail_id_1_1", nil)];
                [self setAnnoyClonesubTitle:des textParagraph:textParagraph];

            }
        }
    }
//    [((IMBBackgroundBorderView *)self.view) setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [((IMBBackgroundBorderView *)self.view) setWantsLayer:YES];
    [((IMBBackgroundBorderView *)self.view).layer setCornerRadius:5];

    
    [_registerButton setFont:[NSFont fontWithName:@"Helvetica Neue" size:16.0]];
    [_registerButton setFontColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_registerButton setLeftImage:[StringHelper imageNamed:@"annoyregister_normal_left"]];
    [_registerButton setLeftEnterImage:[StringHelper imageNamed:@"annoyregister_enter_left"]];
    [_registerButton setLeftDownImage:[StringHelper imageNamed:@"annoyregister_down_left"]];
    [_registerButton setMiddleImage:[StringHelper imageNamed:@"annoyregister_normal_mid"]];
    [_registerButton setMiddleEnterImage:[StringHelper imageNamed:@"annoyregister_enter_mid"]];
    [_registerButton setMiddleDownImage:[StringHelper imageNamed:@"annoyregister_down_mid"]];
    [_registerButton setRightImage:[StringHelper imageNamed:@"annoyregister_normal_right"]];
    [_registerButton setRightEnterImage:[StringHelper imageNamed:@"annoyregister_enter_right"]];
    [_registerButton setRightDownImage:[StringHelper imageNamed:@"annoyregister_down_right"]];
    [_registerButton setMinWidth:140];
    [_registerButton setTitle:CustomLocalizedString(@"annoy_id_1", nil)];
    
    [_buyNowButton setFont:[NSFont fontWithName:@"Helvetica Neue" size:16.0]];
    [_buyNowButton setLeftImage:[StringHelper imageNamed:@"annoybuy_normal_left"]];
    [_buyNowButton setLeftEnterImage:[StringHelper imageNamed:@"annoybuy_enter_left"]];
    [_buyNowButton setLeftDownImage:[StringHelper imageNamed:@"annoybuy_down_left"]];
    [_buyNowButton setMiddleImage:[StringHelper imageNamed:@"annoybuy_normal_mid"]];
    [_buyNowButton setMiddleEnterImage:[StringHelper imageNamed:@"annoybuy_enter_mid"]];
    [_buyNowButton setMiddleDownImage:[StringHelper imageNamed:@"annoybuy_down_mid"]];
    [_buyNowButton setRightImage:[StringHelper imageNamed:@"annoybuy_normal_right"]];
    [_buyNowButton setRightEnterImage:[StringHelper imageNamed:@"annoybuy_enter_right"]];
    [_buyNowButton setRightDownImage:[StringHelper imageNamed:@"annoybuy_down_right"]];
    [_buyNowButton setMinWidth:140];
    
    
    if ([soft.curUseSkin isEqualToString:@"christmasSkin"]) {
        [_buyNowButton setBgImage:[StringHelper imageNamed:@"annoy_christmas_buy_bg"]];
    }
    if ([soft.curUseSkin isEqualToString:@"christmasSkin"] && [StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {//圣诞节活动，只针对英语版本在圣诞节期间显示
        [_buyNowButton setTitle:CustomLocalizedString(@"Christmas_Active_id_11", nil)];
    }else {
        [_buyNowButton setTitle:CustomLocalizedString(@"harassment_buyBtn", nil)];
    }
    
    [_registerButton setFrameOrigin:NSMakePoint(ceilf(NSWidth(_buttonBG.frame)-(20+NSWidth(_registerButton.frame)+NSWidth(_buyNowButton.frame)))/2.0, _registerButton.frame.origin.y)];
    [_buyNowButton setFrameOrigin:NSMakePoint(NSMaxX(_registerButton.frame)+20,_registerButton.frame.origin.y)];

    IMBBackgroundBorderView *arrowView = [[IMBBackgroundBorderView alloc] initWithFrame:NSMakeRect(NSWidth(_buyNowButton.frame)-8-8, ceil((NSHeight(_buyNowButton.frame) - 14)/2), 8, 14)];
    [arrowView setBackgroundImage:[StringHelper imageNamed:@"reg_buy_arrow1"]];
    [_buyNowButton addSubview:arrowView];
    [arrowView release];

    nextButton.tag = 120;
    [nextButton setAutoresizesSubviews:YES];
    [nextButton setWantsLayer:YES];
    [nextButton.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    nextButton.layer.frame = NSRectToCGRect(nextButton.frame);
    nextButton.layer.anchorPointZ = -1;
    [nextButton setAutoresizesSubviews:YES];
    [nextButton setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin|NSViewMaxYMargin];
    [nextButton setTarget:self];
    [nextButton setAction:@selector(freeTry:)];
    [nextButton setMouseEnteredImage:[StringHelper imageNamed:@"clone_next_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_next_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_next_down"]];
    [nextButton setHidden:YES];
    HoverButton *closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(self.view.frame) - 32 - 7)), 32, 32)];
    closebutton.tag = 121;
    closebutton.autoresizesSubviews = YES;
    closebutton.autoresizingMask = NSViewMinYMargin;
    [closebutton setEnabled:NO];
    [closebutton setTarget:self];
    [closebutton setAction:@selector(closeWindow:)];
    [closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [self.view addSubview:closebutton];
    [countdownView setDelegate:self];
    [countdownView startWithStartAngle:90 withSeconds:9];
    [countdownView initialTimerAndQueue];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    _alertViewController.delegate = self;
    if (([soft.curUseSkin isEqualToString:@"christmasSkin"] && [StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage)) {//圣诞节活动，只针对英语版本、圣诞节皮肤在圣诞节期间显示
        [_annoySubTilteField setFrameOrigin:NSMakePoint(_annoySubTilteField.frame.origin.x, _annoySubTilteField.frame.origin.y + 30)];
        [_buttonBG setFrameOrigin:NSMakePoint(_buttonBG.frame.origin.x, _buttonBG.frame.origin.y + 30)];
    }
}

#pragma mark - Actions
- (void)setAnnoyTitle:(NSString *)annoytitle textParagraph:(NSMutableParagraphStyle *)textParagraph
{
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *str = [NSString stringWithFormat:annoytitle,soft.productName,_limitation.remainderDays];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%d",(int)_limitation.remainderDays]];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
                  range:NSMakeRange(0, str.length)];
    [title addAttribute:NSParagraphStyleAttributeName
                  value:textParagraph
                  range:NSMakeRange(0, str.length)];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue Light" size:26]
                  range:NSMakeRange(0, str.length)];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]
                  range:range];
    [_annoyTitleField setAttributedStringValue:title];
    [title release];
}

- (void)setAnnoysubTitle:(NSString *)annoysubtitle textParagraph:(NSMutableParagraphStyle *)textParagraph
{
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];

    NSString *substr = [NSString stringWithFormat:annoysubtitle,_limitation.remainderCount,soft.productName,soft.productName];
    NSMutableAttributedString *subtitle = [[NSMutableAttributedString alloc] initWithString:substr];
    NSRange subrange = [substr rangeOfString:[NSString stringWithFormat:@"%d",(int)_limitation.remainderCount]];
    [subtitle addAttribute:NSForegroundColorAttributeName
                     value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]
                     range:NSMakeRange(0, subtitle.length)];
    [subtitle addAttribute:NSParagraphStyleAttributeName
                     value:textParagraph
                     range:NSMakeRange(0, subtitle.length)];
    [subtitle addAttribute:NSFontAttributeName
                     value:[NSFont fontWithName:@"Helvetica Neue" size:13]
                     range:NSMakeRange(0, subtitle.length)];
    [subtitle addAttribute:NSForegroundColorAttributeName
                     value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]
                     range:subrange];
    [_annoySubTilteField setAttributedStringValue:subtitle];
    [subtitle release];

}

- (void)setAnnoyZeroTitle:(NSString *)annoytitle textParagraph:(NSMutableParagraphStyle *)textParagraph
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:annoytitle];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
                  range:NSMakeRange(0, annoytitle.length)];
    [title addAttribute:NSParagraphStyleAttributeName
                  value:textParagraph
                  range:NSMakeRange(0, annoytitle.length)];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue Light" size:26]
                  range:NSMakeRange(0, annoytitle.length)];
    [_annoyTitleField setAttributedStringValue:title];
    [title release];
}

- (void)setAnnoyZerosubTitle:(NSString *)annoysubtitle textParagraph:(NSMutableParagraphStyle *)textParagraph
{
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *substr = [NSString stringWithFormat:annoysubtitle,soft.productName,soft.productName];
    NSMutableAttributedString *subtitle = [[NSMutableAttributedString alloc] initWithString:substr];
    [subtitle addAttribute:NSForegroundColorAttributeName
                     value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]
                     range:NSMakeRange(0, subtitle.length)];
    [subtitle addAttribute:NSParagraphStyleAttributeName
                     value:textParagraph
                     range:NSMakeRange(0, subtitle.length)];
    [subtitle addAttribute:NSFontAttributeName
                     value:[NSFont fontWithName:@"Helvetica Neue" size:13]
                     range:NSMakeRange(0, subtitle.length)];
    [_annoySubTilteField setAttributedStringValue:subtitle];
    [subtitle release];
    
}

- (void)setAnnoyOverDueTitle:(NSString *)annoytitle textParagraph:(NSMutableParagraphStyle *)textParagraph
{
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *str = [NSString stringWithFormat:annoytitle,soft.productName];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
                  range:NSMakeRange(0, str.length)];
    [title addAttribute:NSParagraphStyleAttributeName
                  value:textParagraph
                  range:NSMakeRange(0, str.length)];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue Light" size:26]
                  range:NSMakeRange(0, str.length)];
    [_annoyTitleField setAttributedStringValue:title];
    [title release];
}

- (void)setAnnoyClonesubTitle:(NSString *)annoysubtitle textParagraph:(NSMutableParagraphStyle *)textParagraph
{
    NSMutableAttributedString *subtitle = [[NSMutableAttributedString alloc] initWithString:annoysubtitle];
    [subtitle addAttribute:NSForegroundColorAttributeName
                     value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]
                     range:NSMakeRange(0, subtitle.length)];
    [subtitle addAttribute:NSParagraphStyleAttributeName
                     value:textParagraph
                     range:NSMakeRange(0, subtitle.length)];
    [subtitle addAttribute:NSFontAttributeName
                     value:[NSFont fontWithName:@"Helvetica Neue" size:13]
                     range:NSMakeRange(0, subtitle.length)];
    [_annoySubTilteField setAttributedStringValue:subtitle];
    [subtitle release];
}

- (void)setAnnoyChistmasSubTitle:(NSString *)annoyTitle withTaggingTitleOne:(NSString *)taggingTitle1 withOneColor:(NSColor *)color1 withTaggingTitleTwo:(NSString *)taggingTitle2 withTwoColor:(NSColor *)color2 textParagraph:(NSMutableParagraphStyle *)textParagraph {
    NSMutableAttributedString *annoyTitleAs = [StringHelper setSingleTextAttributedString:annoyTitle withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];

    if (taggingTitle1 != nil) {
        NSRange infoRange = [annoyTitle rangeOfString:taggingTitle1];
        [annoyTitleAs addAttribute:NSForegroundColorAttributeName value:color1 range:infoRange];
        [annoyTitleAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Bold" size:13.0] range:infoRange];
    }
    
    if (taggingTitle2 != nil) {
        NSRange infoRange = [annoyTitle rangeOfString:taggingTitle2];
        [annoyTitleAs addAttribute:NSForegroundColorAttributeName value:color2 range:infoRange];
        [annoyTitleAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Bold" size:13.0] range:infoRange];
    }
    [annoyTitleAs addAttribute:NSParagraphStyleAttributeName
                     value:textParagraph
                     range:NSMakeRange(0, annoyTitleAs.length)];
    [_annoySubTilteField setAttributedStringValue:annoyTitleAs];
}

- (void)setChristmasImage {
    if (_isContentToMac) {
        [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_tomac"]];
    }else if (_isAddContent) {
        [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_video"]];
    }else {
        if (_category == Category_CameraRoll || _category == Category_PhotoStream || _category == Category_PhotoLibrary || _category == Category_PhotoShare || _category == Category_Panoramas || _category == Category_MyAlbums || _category == Category_ContinuousShooting || _category == Category_LivePhoto || _category == Category_PhotoSelfies || _category == Category_Screenshot || _category == Category_Location || _category == Category_Favorite) {
            [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_photo"]];
        }else if (_category == Category_Music || _category == Category_CloudMusic || _category == Category_Audiobook || _category == Category_Ringtone || _category == Category_VoiceMemos || _category == Category_Playlist) {
            [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_music"]];
        }else if (_category == Category_Movies || _category == Category_HomeVideo || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_PhotoVideo || _category == Category_TimeLapse || _category == Category_SlowMove) {
            [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_video"]];
        }else {
            [_annoyBgFive setImage:[StringHelper imageNamed:@"annoy_christmas_all"]];
        }
    }
}

- (void)setThanksGivingImage {
    if (_isContentToMac) {
        [_annoyBgSix setImage:[StringHelper imageNamed:@"annoy_thanksgiving_tomac"]];
    }else if (_isAddContent) {
        [_annoyBgSix setImage:[StringHelper imageNamed:@"annoy_thanksgiving_all"]];
    }else {
        if (_category == Category_CameraRoll || _category == Category_PhotoStream || _category == Category_PhotoLibrary || _category == Category_PhotoShare || _category == Category_Panoramas || _category == Category_MyAlbums || _category == Category_ContinuousShooting || _category == Category_LivePhoto || _category == Category_PhotoSelfies || _category == Category_Screenshot || _category == Category_Location || _category == Category_Favorite) {
            [_annoyBgSix setImage:[StringHelper imageNamed:@"annoy_thanksgiving_photo"]];
        }else if (_category == Category_Music || _category == Category_CloudMusic || _category == Category_Audiobook || _category == Category_Ringtone || _category == Category_VoiceMemos || _category == Category_Playlist) {
            [_annoyBgSix setImage:[StringHelper imageNamed:@"annoy_thanksgiving_music"]];
        }else if (_category == Category_Movies || _category == Category_HomeVideo || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_PhotoVideo || _category == Category_TimeLapse || _category == Category_SlowMove) {
            [_annoyBgSix setImage:[StringHelper imageNamed:@"annoy_thanksgiving_movie"]];
        }else {
            [_annoyBgSix setImage:[StringHelper imageNamed:@"annoy_thanksgiving_all"]];
        }
    }
}

- (void)activateSuccess {
    *_result = NSIntegerMax;
    [[NSNotificationCenter defaultCenter] postNotificationName:ANNOY_REGIST_SUCCESS object:nil];
    ((IMBBaseViewController *)_delegate)->_endRunloop = YES;
//    if ([_delegate respondsToSelector:@selector(startTransfer:)]) {
//        [_delegate startTransfer:self];
//    }
    [_annoyAnimaitonView stopAnimation];
    [_annoyAnimationViewTwo stopAnimation];
    [_annoyAnimationViewThree stopAnimation];
}

- (void)closeWindow:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
     *_result = 0;
    ((IMBBaseViewController *)_delegate)->_endRunloop = YES;
    _nextBg.autoresizesSubviews = YES;
    [_nextBg setAutoresizingMask:NSViewMinYMargin];
    [_animtionBGView setAutoresizingMask:NSViewMinYMargin];
    [_backGroundView setAutoresizingMask:NSViewMinYMargin];
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
            [_annoyAnimaitonView stopAnimation];
            [_annoyAnimationViewTwo stopAnimation];
            [_annoyAnimationViewThree stopAnimation];
            [self.view removeFromSuperview];
            [self release];
        }];
    }];
}

- (void)freeTry:(id)sender
{
    ((IMBBaseViewController *)_delegate)->_endRunloop = YES;
    [_annoyAnimaitonView stopAnimation];
    [_annoyAnimationViewTwo stopAnimation];
    [_annoyAnimationViewThree stopAnimation];
    [countdownView setHidden:YES];
    [countdownView stopAnimation];
}

- (IBAction)registerAction:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [_alertViewController showAlertActivationView:view];
}

- (IBAction)buyNow:(id)sender {
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    NSDictionary *dimensionDict = nil;
    OperationLImitation *limit = [OperationLImitation singleton];
    @autoreleasepool {
        if (_isClone || _isMerge) {
            [limit setLimitStatus:@""];
        }else {
            if (limit.remainderDays > 0) {
                [limit setLimitStatus:@"completed"];
            }else if (limit.retainCount == 0 && limit.remainderDays > 0) {
                [limit setLimitStatus:@"noquote"];
            }else {
                [limit setLimitStatus:@"expired"];
            }
        }
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@#status=%@", [TempHelper currentSelectionLanguage], limit.limitStatus] label:Buy transferCount:0 screenView:@"go shop" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
    [SystemHelper openChooseBrowser:softWare.buyId withIsActivate:NO isDiscount:NO isNeedAnalytics:YES];
}

- (void)countdownComplete
{
    if (_limitation.remainderCount>0&&!_isClone&&!_isMerge) {
        CABasicAnimation *animation = [IMBAnimation moveX:2.0 X:@(-15)];
        [_freeTryTextField setHidden:NO];
        [_freeTry setHidden:NO];
        NSButton *button = [self.view viewWithTag:120];
        [button setHidden:NO];
        [button.layer addAnimation:animation forKey:@"comeback"];
    }
    NSButton *button1 = [self.view viewWithTag:121];
    [button1 setEnabled:YES];
    [countdownView setHidden:YES];
    [countdownView stopAnimation];
}

- (void)dealloc
{
    [_alertViewController release],_alertViewController = nil;
    [super dealloc];
}
@end

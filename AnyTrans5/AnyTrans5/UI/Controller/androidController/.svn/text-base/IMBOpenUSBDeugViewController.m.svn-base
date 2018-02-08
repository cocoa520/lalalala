//
//  IMBOpenUSBDeugViewController.m
//  PhoneRescue_Android
//
//  Created by m on 17/5/8.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBOpenUSBDeugViewController.h"
#import "SystemHelper.h"
#import "NSString+Compare.h"
#import "IMBWhiteView.h"
#import "StringHelper.h"
#import "ColorHelper.h"
#import "IMBLackCornerView.h"
#import "StringHelper.h"
#import "IMBMainWindowController.h"
#import "IMBNotificationDefine.h"
#import "IMBAndroidViewController.h"

@implementation IMBOpenUSBDeugViewController

- (void)awakeFromNib {
    [_rootView initWithLuCorner:NO LbCorner:YES RuCorner:NO RbConer:YES CornerRadius:5];
    [_rootView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    _androidAlertViewController = [[IMBAndroidAlertViewController alloc] initWithNibName:@"IMBAndroidAlertViewController" bundle:nil];
    [_androidAlertViewController setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [self configText];
}

- (void)configText {
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"OpenDebugging_top", nil)];
    NSRange range = NSMakeRange(0, as.length);
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Thin" size:18] range:range];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:18] range:range];
    }
    [as setAlignment:NSCenterTextAlignment range:range];
    [_mainTitle setAttributedStringValue:as];
    [as release], as = nil;
    [_mainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_topLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_stepImageView setImage:[StringHelper imageNamed:@"guide_step"]];
    
    [_firstStepTitle setStringValue:CustomLocalizedString(@"OpenDebugging_step1", nil)];
    [_firstStepTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_secondStepTitle setStringValue:CustomLocalizedString(@"OpenDebugging_step2", nil)];
    [_secondStepTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_thirdStepTitle setStringValue:CustomLocalizedString(@"OpenDebugging_step3", nil)];
    [_thirdStepTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_fourthStepTitle setStringValue:CustomLocalizedString(@"OpenDebugging_step4", nil)];
    [_fourthStepTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_fifthStepTitle setStringValue:CustomLocalizedString(@"OpenDebugging_step5", nil)];
    [_fifthStepTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
        [_firstStepImageView setImage:[StringHelper imageNamed:@"guide_step1_s"]];
        [_secondStepImageView setImage:[StringHelper imageNamed:@"guide_step2_s"]];
        [_thirdStepImageView setImage:[StringHelper imageNamed:@"guide_step3_s"]];
        [_fourthStepImageView setImage:[StringHelper imageNamed:@"guide_step4_s"]];
        [_fifthStepImageView setImage:[StringHelper imageNamed:@"guide_step5_s"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [_firstStepImageView setImage:[StringHelper imageNamed:@"guide_step1_sar"]];
        [_secondStepImageView setImage:[StringHelper imageNamed:@"guide_step2_sar"]];
        [_thirdStepImageView setImage:[StringHelper imageNamed:@"guide_step3_sar"]];
        [_fourthStepImageView setImage:[StringHelper imageNamed:@"guide_step4_sar"]];
        [_fifthStepImageView setImage:[StringHelper imageNamed:@"guide_step5_sar"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        [_firstStepImageView setImage:[StringHelper imageNamed:@"guide_step1_sch"]];
        [_secondStepImageView setImage:[StringHelper imageNamed:@"guide_step2_sch"]];
        [_thirdStepImageView setImage:[StringHelper imageNamed:@"guide_step3_sch"]];
        [_fourthStepImageView setImage:[StringHelper imageNamed:@"guide_step4_sch"]];
        [_fifthStepImageView setImage:[StringHelper imageNamed:@"guide_step5_sch"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [_firstStepImageView setImage:[StringHelper imageNamed:@"guide_step1_sde"]];
        [_secondStepImageView setImage:[StringHelper imageNamed:@"guide_step2_sde"]];
        [_thirdStepImageView setImage:[StringHelper imageNamed:@"guide_step3_sde"]];
        [_fourthStepImageView setImage:[StringHelper imageNamed:@"guide_step4_sde"]];
        [_fifthStepImageView setImage:[StringHelper imageNamed:@"guide_step5_sde"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
        [_firstStepImageView setImage:[StringHelper imageNamed:@"guide_step1_sfr"]];
        [_secondStepImageView setImage:[StringHelper imageNamed:@"guide_step2_sfr"]];
        [_thirdStepImageView setImage:[StringHelper imageNamed:@"guide_step3_sfr"]];
        [_fourthStepImageView setImage:[StringHelper imageNamed:@"guide_step4_sfr"]];
        [_fifthStepImageView setImage:[StringHelper imageNamed:@"guide_step5_sfr"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        [_firstStepImageView setImage:[StringHelper imageNamed:@"guide_step1_sjp"]];
        [_secondStepImageView setImage:[StringHelper imageNamed:@"guide_step2_sjp"]];
        [_thirdStepImageView setImage:[StringHelper imageNamed:@"guide_step3_sjp"]];
        [_fourthStepImageView setImage:[StringHelper imageNamed:@"guide_step4_sjp"]];
        [_fifthStepImageView setImage:[StringHelper imageNamed:@"guide_step5_sjp"]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
        [_firstStepImageView setImage:[StringHelper imageNamed:@"guide_step1_ssp"]];
        [_secondStepImageView setImage:[StringHelper imageNamed:@"guide_step2_ssp"]];
        [_thirdStepImageView setImage:[StringHelper imageNamed:@"guide_step3_sp"]];
        [_fourthStepImageView setImage:[StringHelper imageNamed:@"guide_step4_ssp"]];
        [_fifthStepImageView setImage:[StringHelper imageNamed:@"guide_step5_ssp"]];
    }

    
    if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
        [_firstStepTitle setFrame:NSMakeRect(_firstStepTitle.frame.origin.x,372, _firstStepTitle.frame.size.width, 100)];
        [_secondStepTitle setFrame:NSMakeRect(_secondStepTitle.frame.origin.x,372, _secondStepTitle.frame.size.width, 100)];
        [_thirdStepTitle setFrame:NSMakeRect(_thirdStepTitle.frame.origin.x,372, _thirdStepTitle.frame.size.width, 100)];
        [_fourthStepTitle setFrame:NSMakeRect(_fourthStepTitle.frame.origin.x,372, _fourthStepTitle.frame.size.width, 100)];
        [_fifthStepTitle setFrame:NSMakeRect(_fifthStepTitle.frame.origin.x,372, _fifthStepTitle.frame.size.width, 100)];
        [_firstStepImageView setFrame:NSMakeRect(_firstStepImageView.frame.origin.x, 140, _firstStepImageView.frame.size.width, 232)];
        [_secondStepImageView setFrame:NSMakeRect(_secondStepImageView.frame.origin.x, 140, _secondStepImageView.frame.size.width, 232)];
        [_thirdStepImageView setFrame:NSMakeRect(_thirdStepImageView.frame.origin.x, 140, _thirdStepImageView.frame.size.width, 232)];
        [_fourthStepImageView setFrame:NSMakeRect(_fourthStepImageView.frame.origin.x, 140, _fourthStepImageView.frame.size.width, 232)];
        [_fifthStepImageView setFrame:NSMakeRect(_fifthStepImageView.frame.origin.x, 140, _fifthStepImageView.frame.size.width, 232)];
        [_bottomLineView setFrameOrigin:NSMakePoint(_bottomLineView.frame.origin.x,105)];
        [_warningScrollView setFrameOrigin:NSMakePoint(_warningScrollView.frame.origin.x, 53)];
        [_warningScrollView1 setFrameOrigin:NSMakePoint(_warningScrollView1.frame.origin.x, 33)];
    }
    
    [_bottomLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_warningTextView1 setDelegate:self];
    NSString *promptStr1 = CustomLocalizedString(@"OpenDebugging_down1", nil);
    
    NSDictionary *linkAttributes1 = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_warningTextView1 setLinkTextAttributes:linkAttributes1];
    
    NSMutableAttributedString *promptAs1 = [[NSMutableAttributedString alloc] initWithString:promptStr1];
    
    NSRange promRange1 = NSMakeRange(0, promptAs1.length);
    [promptAs1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:promRange1];
    [promptAs1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:promRange1];
    [promptAs1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:promRange1];
    [promptAs1 addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:promRange1];
    [promptAs1 addAttribute:NSLinkAttributeName value:promptStr1 range:promRange1];
    NSMutableParagraphStyle *mutParaStyle1=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle1 setAlignment:NSCenterTextAlignment];
    [mutParaStyle1 setLineSpacing:5.0];
    [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
    [[_warningTextView1 textStorage] setAttributedString:promptAs1];
    [promptAs1 release], promptAs1 = nil;
    [mutParaStyle1 release],  mutParaStyle1 = nil;
    
    [_warningTextView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"OpenDebugging_Tips_1", nil);
    
    promptStr = [[CustomLocalizedString(@"OpenDebugging_Tips", nil) stringByAppendingString:@" "] stringByAppendingString:overStr];

    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
        [_warningTextView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr];
    NSRange promRange = NSMakeRange(0, promptAs.length);
        [promptAs addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0,promRange.length)];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0,promRange.length)];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0,promRange.length)];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14.0] range:infoRange];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:5.0];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_warningTextView textStorage] setAttributedString:promptAs];
        [promptAs release], promptAs = nil;
        [mutParaStyle release],  mutParaStyle = nil;
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    NSString *overStr = CustomLocalizedString(@"OpenDebugging_Tips_1", nil);
    NSString *overStr1 = CustomLocalizedString(@"OpenDebugging_down1",nil);
    NSLog(@"%@",overStr);
    if ([link isEqualToString:overStr]) {
        [_androidAlertViewController showMediaDeviceMTPAlertView:self.view.superview.window.contentView withDic:nil];
    }
    if ([link isEqualToString:overStr1]) {
         NSString *hoStr = CustomLocalizedString(@"anyTrans_open_usb", nil);
        NSURL *url = [NSURL URLWithString:hoStr];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    }
    return YES;
}

#pragma mark - 切换语言
- (void)doChangeLanguage:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configText];
    });
    
}

#pragma mark - 切换皮肤
- (void)changeSkin:(NSNotification *)notification {
    [super changeSkin:notification];
    [_rootView initWithLuCorner:NO LbCorner:YES RuCorner:NO RbConer:YES CornerRadius:5];
    [_rootView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [self configText];
}

- (void)dealloc {
    [_androidAlertViewController release],_androidAlertViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

@end

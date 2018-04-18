//
//  IMBShoppingCarViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBShoppingCarViewController.h"
#import "IMBGeneralButton.h"
#import "SystemHelper.h"
#import "IMBMonitorBtn.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "customTextFieldCell.h"
#import "IMBSoftWareInfo.h"
#import "IMBScreenClickView.h"

@implementation IMBShoppingCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        /*
        NSString *mainStr = CustomLocalizedString(@"register_window_title", nil);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:mainStr];
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:30] range:NSMakeRange(0, as.length)];
        }else {
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:30] range:NSMakeRange(0, as.length)];
        }
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
        [_mainTitle setAttributedStringValue:as];
        [as release], as = nil;
        
        
        NSString *buyString = CustomLocalizedString(@"register_window_buyBtn", nil);
        [_buyBtn reSetInit:buyString WithPrefixImageName:@"re_buy"];
        NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:buyString];
        [as2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, as2.length)];
        [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Medium" size:14] range:NSMakeRange(0, as2.length)];
        [as2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, as2.length)];
        [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] range:NSMakeRange(0, as2.length)];
        NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
        [style2 setAlignment:NSCenterTextAlignment];
        
        [_buyBtn setAttributedTitle:as2];
        [_buyBtn setIconImageName:@"reg_buy_arrow"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:13],NSFontAttributeName,style2,NSParagraphStyleAttributeName, nil];
        NSSize size = [buyString sizeWithAttributes:dic];
        [_buyBtn setFrameSize:NSMakeSize(ceilf(size.width+100), 42)];
        [_buyBtn setFrameOrigin:NSMakePoint(ceilf((self.view.frame.size.width- (size.width+100))/2.0), ceilf(_buyBtn.frame.origin.y))];
        
        if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
            [_buyBtn setBgImage:[StringHelper imageNamed:@"annoy_christmas_buy_bg"]];
        }else {
            [_buyBtn setBgImage:nil];
        }
        
        [_buyBtn setFontSize:14.0];
        [_buyBtn setTarget:self];
        [_buyBtn setAction:@selector(gotoShop)];
        [style2 release], style2 = nil;
        [as2 release], as2 = nil;
        
        NSString *enterSting = CustomLocalizedString(@"register_window_buyBtn", nil);
        [_enterLicenseTitle setStringValue:enterSting];
        NSMutableParagraphStyle *style3 = [[NSMutableParagraphStyle alloc] init];
        [style3 setAlignment:NSCenterTextAlignment];
        
        [_inputTextFiledBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
        [_inputTextFiledBgView setHasCorner:YES];
        NSMutableAttributedString *as3 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"register_text_eg", nil)] autorelease];
        [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as3.string.length)];
        [as3 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as3.string.length)];
        [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as3.string.length)];
        [_inputTextFiled.cell setPlaceholderAttributedString:as3];
        
        [_inputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];

        [style3 release], style3 = nil;
        NSString *OkText = CustomLocalizedString(@"register_window_activateBtn", nil);
        [_activeBtn reSetInit:OkText WithPrefixImageName:@"select_path"];
        NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
        [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
        [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
        [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, OkText.length)];
        [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
        [_activeBtn setAttributedTitle:attributedTitles1];
        [_activeBtn setTarget:self];
        [_activeBtn setAction:@selector(startActive)];

        NSString *subString = CustomLocalizedString(@"register_window_description", nil);
        NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:subString];
        [as1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13.0] range:NSMakeRange(0, as1.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setAlignment:NSCenterTextAlignment];
        [style setParagraphSpacing:2.0];
        [style setLineSpacing:2.0];
        [as1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, as1.length)];
        [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as1.length)];
        [_subTitle setAttributedStringValue:as1];
        [as1 release], as1 = nil;
        [style release], style = nil;
         */
        
        [self configSecondView];
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_shlogoImageView setImage:[StringHelper imageNamed:@"buy-img1"]];
    [_imageView setImage:[StringHelper imageNamed:@"Buy_logo"]];
    [_registerLabel setDelegate:self];
    [_reslutView setHidden:YES];
    _nc = [NSNotificationCenter defaultCenter];
    [_nc addObserver:self selector:@selector(inputCode) name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    
    
    [_secondViewRegisterLabel setDelegate:self];
    [_seondViewResultView setHidden:YES];
    
    //加载第二个页面
    [self configSecondView];
    [self.view addSubview:_secondView];
    
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    [self.view setWantsLayer:YES];
    
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(self.view.frame) - 32 - 7)), 32, 32)];
    _closebutton.tag = 121;
    _closebutton.autoresizesSubviews = YES;
    _closebutton.autoresizingMask = NSViewMinYMargin;
    [_closebutton setEnabled:YES];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [self.view addSubview:_closebutton];
    _loadingLayer = [[CALayer alloc] init];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
}

- (void)configFirtView {
    NSString *mainStr = CustomLocalizedString(@"register_window_title", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:mainStr];
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:30] range:NSMakeRange(0, as.length)];
    }else {
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:30] range:NSMakeRange(0, as.length)];
    }
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    [_mainTitle setAttributedStringValue:as];
    [as release], as = nil;
    
    NSString *subString = CustomLocalizedString(@"register_window_description", nil);
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:subString];
    [as1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13.0] range:NSMakeRange(0, as1.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSCenterTextAlignment];
    [style setParagraphSpacing:2.0];
    [style setLineSpacing:2.0];
    [as1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, as1.length)];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as1.length)];
    [_subTitle setAttributedStringValue:as1];
    [as1 release], as1 = nil;
    [style release], style = nil;
    
    NSString *buyString = CustomLocalizedString(@"register_window_buyBtn", nil);
    [_buyBtn reSetInit:buyString WithPrefixImageName:@"re_buy"];
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:buyString];
    [as2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, as2.length)];
    
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    [style2 setAlignment:NSCenterTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue Medium" size:13],NSFontAttributeName,style2,NSParagraphStyleAttributeName, nil];
    NSSize size = [buyString sizeWithAttributes:dic];
    [_buyBtn setFrameSize:NSMakeSize(ceilf(size.width+100), 42)];
    [_buyBtn setFrameOrigin:NSMakePoint(ceilf((self.view.frame.size.width- (size.width+100))/2.0), ceilf(_buyBtn.frame.origin.y))];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_buyBtn setBgImage:[StringHelper imageNamed:@"annoy_christmas_buy_bg"]];
    }else {
        [_buyBtn setBgImage:nil];
    }
    [_buyBtn setAttributedTitle:as2];
    [_buyBtn setIconImageName:@"reg_buy_arrow"];
    [_buyBtn setFontSize:14.0];
    [_buyBtn setTarget:self];
    [_buyBtn setAction:@selector(gotoShop)];
    [style2 release], style2 = nil;
    [as2 release], as2 = nil;
    
    NSString *enterSting = CustomLocalizedString(@"register_window_buyBtn", nil);
    [_enterLicenseTitle setStringValue:enterSting];
    NSMutableParagraphStyle *style3 = [[NSMutableParagraphStyle alloc] init];
    [style3 setAlignment:NSCenterTextAlignment];
    
    [_inputTextFiledBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_inputTextFiledBgView setHasCorner:YES];
    NSMutableAttributedString *as5 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"xxxx-xxxx-xxxx-xxxx-xxxx", nil)] autorelease];
    [as5 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as5.string.length)];
    [as5 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as5.string.length)];
    [as5 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as5.string.length)];
    [((customTextFieldCell *)_inputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_inputTextFiled.cell setPlaceholderAttributedString:as5];
    
    
    [style3 release], style3 = nil;
    NSString *OkText = CustomLocalizedString(@"register_window_activateBtn", nil);
    [_activeBtn reSetInit:OkText WithPrefixImageName:@"select_path"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_activeBtn setAttributedTitle:attributedTitles1];
    
    [_activeBtn setTarget:self];
    [_activeBtn setAction:@selector(startActive)];
    [_activeBtn setNeedsDisplay:YES];
    
    [_inputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as3 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"xxxx-xxxx-xxxx-xxxx-xxxx", nil)] autorelease];
    [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as3.string.length)];
    [as3 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as3.string.length)];
    [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as3.string.length)];
    [_inputTextFiled.cell setPlaceholderAttributedString:as3];
}

- (void)configSecondView {
    NSString *mainStr = [[[[CustomLocalizedString(@"Annoy_Activate_Title", nil) stringByAppendingString:@" " ] stringByAppendingString:CustomLocalizedString(@"Annoy_Activate_Title1", nil)]  stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"Annoy_Activate_Title2", nil)];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:mainStr];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:20] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    
    NSString *overStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        overStr = CustomLocalizedString(@"Annoy_Activate_Title", nil);
    }else {
        overStr = CustomLocalizedString(@"Annoy_Activate_Title1", nil);
    }
    NSRange range = [mainStr rangeOfString:overStr];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:range];
    [_seondViewMainTitle setAttributedStringValue:as];
    [as release], as = nil;
    
    NSString *subStr1 = CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle", nil);
    NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:subStr1];
    [as1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16.0] range:NSMakeRange(0, as1.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSCenterTextAlignment];
    [style setParagraphSpacing:2.0];
    [style setLineSpacing:2.0];
    [as1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, as1.length)];
    [as1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] range:NSMakeRange(0, as1.length)];
    [_secondViewUpSubTitle setAttributedStringValue:as1];
    [as1 release], as1 = nil;
    [style release], style = nil;
    
    
    NSRect subRect1 = [IMBHelper calcuTextBounds:subStr1 fontSize:16];
    [_secondViewUpLineView setCenterLength:(int)(subRect1.size.width + 120)];
    
    NSString *downSubStr = CustomLocalizedString(@"Annoy_Activate_ThirdPart_SubTitle_1", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:downSubStr];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:16.0] range:NSMakeRange(0, as2.length)];
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    [style2 setAlignment:NSCenterTextAlignment];
    [style2 setParagraphSpacing:2.0];
    [style2 setLineSpacing:2.0];
    [as2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)] range:NSMakeRange(0, as2.length)];
    [_secondViewDownSubTitle setAttributedStringValue:as2];
    [as2 release], as2 = nil;    [style2 release], style2 = nil;
    
    
    NSRect subRect2 = [IMBHelper calcuTextBounds:downSubStr fontSize:16];
    [_secondViewDownLineView setCenterLength:(int)(subRect2.size.width + 120)];
    
    [_secondViewInputTextFiledBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_secondViewInputTextFiledBgView setHasCorner:YES];
    NSMutableAttributedString *as5 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"xxxx-xxxx-xxxx-xxxx-xxxx", nil)] autorelease];
    [as5 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as5.string.length)];
    [as5 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as5.string.length)];
    [as5 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as5.string.length)];
    [((customTextFieldCell *)_secondViewInputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_secondViewInputTextFiled.cell setPlaceholderAttributedString:as5];

    NSString *OkText = CustomLocalizedString(@"register_window_activateBtn", nil);
    [_secondViewActiveBtn reSetInit:OkText WithPrefixImageName:@"select_path"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_secondViewActiveBtn setAttributedTitle:attributedTitles1];
    
    [_secondViewActiveBtn setTarget:self];
    [_secondViewActiveBtn setAction:@selector(startActive)];
    [_secondViewActiveBtn setNeedsDisplay:YES];
    
    [_secondViewInputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableAttributedString *as3 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"xxxx-xxxx-xxxx-xxxx-xxxx", nil)] autorelease];
    [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as3.string.length)];
    [as3 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as3.string.length)];
    [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as3.string.length)];
    [_secondViewInputTextFiled.cell setPlaceholderAttributedString:as3];
    
    [_secondViewCenterView setHasCorner:YES];
    [_secondViewCenterView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)]];
    [_secondViewCenterView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    [_seondViewSubLabel1 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_1", nil)];
    [_seondViewSubLabel2 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_2", nil)];
    [_seondViewSubLabel3 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_3", nil)];
    [_seondViewSubLabel4 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_4", nil)];
    [_seondViewSubLabel5 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_5", nil)];
    [_seondViewSubLabel6 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_6", nil)];
    [_seondViewSubLabel7 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_7", nil)];
    [_seondViewSubLabel8 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_8", nil)];
    [_seondViewSubLabel9 setStringValue:CustomLocalizedString(@"Annoy_Activate_SecondPart_SubTitle_9", nil)];
    
    //配置颜色
    [_seondViewSubLabel1 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_seondViewSubLabel2 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_seondViewSubLabel3 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_seondViewSubLabel4 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_seondViewSubLabel5 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_seondViewSubLabel6 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_seondViewSubLabel7 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_seondViewSubLabel8 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    [_seondViewSubLabel9 setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    
    [_secondViewBuyBtn setCornerRadius:5];
    [_secondViewBuyBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_normal_color", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_normal_color", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_enter_color", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_enter_color", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_down_color", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_down_color", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_left_normal_color", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"buy_license_right_normal_color", nil)]];
    [_secondViewBuyBtn setButtonTitle:CustomLocalizedString(@"Annoy_Activate_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] withTitleSize:19 WithLightAnimation:NO];
    [_secondViewBuyBtn setButtonBorder:YES withNormalBorderColor:[NSColor clearColor] withEnterBorderColor:[NSColor clearColor] withDownBorderColor:[NSColor clearColor] withForbiddenBorderColor:[NSColor clearColor] withBorderLineWidth:1.0];
    [_secondViewBuyBtn setHasRightImage:YES];
    [_secondViewBuyBtn setSpaceWithText:4];
    [_secondViewBuyBtn setIsiCloudCompleteBtn:YES];
    [_secondViewBuyBtn setRightImage:[StringHelper imageNamed:@"annoy_arrow"]];
    [_secondViewBuyBtn setNeedsDisplay:YES];
    
    NSRect rect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Annoy_Activate_BtnTitle", nil) fontSize:19];
    int width = (int)(rect.size.width + 4 + 32 + 120);
    [_secondViewBuyBtn setFrame:NSMakeRect(ceil((_secondView.frame.size.width - width) / 2.0), _secondViewBuyBtn.frame.origin.y,width,_secondViewBuyBtn.frame.size.height)];
    
    
    [_secondViewBuyBtn setTarget:self];
    [_secondViewBuyBtn setAction:@selector(chooseBrowser:)];
}

- (void)chooseBrowser:(id)sender {
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"AnyTrans Activation"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [[OperationLImitation singleton] setLimitStatus:@"notactivate"];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@#status=notactivate", [TempHelper currentSelectionLanguage]] label:Buy transferCount:0 screenView:@"go shop" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
    [SystemHelper openChooseBrowser:0 withIsActivate:YES isDiscount:NO isNeedAnalytics:YES];
}

- (void)changeSkin:(NSNotification *)notification {
    [_shlogoImageView setImage:[StringHelper imageNamed:@"buy-img1"]];
    [_imageView setImage:[StringHelper imageNamed:@"Buy_logo"]];
    [self doChangeLanguage:nil];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    [_lineView setNeedsDisplay:YES];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_closebutton setNeedsDisplay:YES];
}

- (void)startActive {
    /*
    if ([_inputTextFiled.stringValue isEqualToString:@""] || _inputTextFiled.stringValue.length == 0) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
            dimensionMutDict = [TempHelper customDimension];
            [dimensionMutDict setObject:[IMBSoftWareInfo singleton].selectModular forKey:@"cd7"];
            dimensionDict = [dimensionMutDict copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_inputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        return;
    }
    _loadingLayer.contents = [NSImage imageNamed:@"registedLoading"];

    [_inputTextFiled setWantsLayer:YES];
    [_loadingLayer setFrame:CGRectMake(_inputTextFiled.frame.size.width  -10 -8  , (_inputTextFiled.frame.size.height - 14)/2 +2 , 14,14)];
    [_inputTextFiled.layer addSublayer:_loadingLayer];
    [_loadingLayer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
    
    //JXCV-JJKS-SEXE-EIEA-KDIT
    if (![_inputTextFiled.stringValue contains:@"-"] || _inputTextFiled.stringValue.length < 18) {
        [_inputTextFiledBgView setHidden:YES];
        [_reslutView setHidden:NO];
        [_relustImageView setImage:[StringHelper imageNamed:@"registFailure"]];
        [self showReslutView:CustomLocalizedString(@"activate_error_discorrect", nil)];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
            dimensionMutDict = [TempHelper customDimension];
            [dimensionMutDict setObject:[IMBSoftWareInfo singleton].selectModular forKey:@"cd7"];
            dimensionDict = [dimensionMutDict copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_inputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        return;
    }

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (![TempHelper isInternetAvail]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_inputTextFiledBgView setHidden:YES];
                [_reslutView setHidden:NO];
                [_relustImageView setImage:[StringHelper imageNamed:@"registFailure"]];
                [self showReslutView:CustomLocalizedString(@"activate_error_disinternet", nil)];
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
                    dimensionMutDict = [TempHelper customDimension];
                    [dimensionMutDict setObject:[IMBSoftWareInfo singleton].selectModular forKey:@"cd7"];
                    dimensionDict = [dimensionMutDict copy];
                }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",CustomLocalizedString(@"activate_error_disinternet", nil)] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                return;
            });
        }
        IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
        [software setIsIllegal:NO];
        BOOL registerSuccess = [software registerSoftware:_inputTextFiled.stringValue];
        _isSucess = registerSuccess;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_loadingLayer removeFromSuperlayer];
            [_inputTextFiledBgView setHidden:YES];
            [_reslutView setHidden:NO];
            if (registerSuccess) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
                    dimensionMutDict = [TempHelper customDimension];
                    [dimensionMutDict setObject:software.selectModular forKey:@"cd7"];
                    dimensionDict = [dimensionMutDict copy];
                }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:True",_inputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_relustImageView setImage:[StringHelper imageNamed:@"registSuccess"]];
                [self showReslutView:CustomLocalizedString(@"activate_success", nil)];
                
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //跳转到设备连接页面
                     [self.view setWantsLayer:YES];
                    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
                    animation.delegate = self;
                    animation.fromValue=[NSNumber numberWithFloat:1.0];
                    animation.toValue=[NSNumber numberWithFloat:0.0];
                    animation.autoreverses= NO;
                    animation.duration=2.0;
                    animation.repeatCount= 0;
                    animation.removedOnCompletion=NO;
                    animation.fillMode=kCAFillModeForwards;
                    [self.view.layer addAnimation:animation forKey:@"remove"];
                    [self performSelector:@selector(toMainView) withObject:self afterDelay:1];
                });
            }else{
                if (software.isIllegal) {
                    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"https://www.imobie.com/landing/anytrans-official-xmas-offer.htm?%@", nil),[_inputTextFiled.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    NSURL *url = [NSURL URLWithString:str];
                    
                    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                    [ws openURL:url];
                }
                
                NSString *errorStr = @"";
                if (![TempHelper stringIsNilOrEmpty:software.rigisterErrorCode]) {
                    if ([software.rigisterErrorCode isEqualToString:@"002"]) {
                        errorStr = CustomLocalizedString(@"activate_error_expired", nil);
                    }else if ([software.rigisterErrorCode isEqualToString:@"003"]) {
                        errorStr = CustomLocalizedString(@"activate_error_overPC", nil);
                    }else if ([software.rigisterErrorCode isEqualToString:@"012"]) {
                        errorStr = CustomLocalizedString(@"activate_error_timeOutofPeriod", nil);
                    }else {
                        errorStr = [NSString stringWithFormat:CustomLocalizedString(@"activate_error_registerFailed", nil),[software.rigisterErrorCode intValue]];
                    }
                }else {
                    errorStr = [NSString stringWithFormat:CustomLocalizedString(@"activate_error_registerFailed", nil),-1];
                }
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
                    dimensionMutDict = [TempHelper customDimension];
                    [dimensionMutDict setObject:software.selectModular forKey:@"cd7"];
                    dimensionDict = [dimensionMutDict copy];
                }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_inputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_relustImageView setImage:[StringHelper imageNamed:@"registFailure"]];
                [self showReslutView:errorStr];
            }
        });
    });
     */
    
    if ([_secondViewInputTextFiled.stringValue isEqualToString:@""] || _secondViewInputTextFiled.stringValue.length == 0) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            OperationLImitation *limit = [OperationLImitation singleton];
            if (limit.remainderCount <= 0) {
                [limit setLimitStatus:@"noquote"];
            }else {
                [limit setLimitStatus:@"notactivate"];
            }
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:@"Registration code is empty" label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        return;
    }
    _loadingLayer.contents = [NSImage imageNamed:@"registedLoading"];
    
    [_secondViewInputTextFiled setWantsLayer:YES];
    [_loadingLayer setFrame:CGRectMake(_secondViewInputTextFiled.frame.size.width  -10 -8  , (_secondViewInputTextFiled.frame.size.height - 14)/2 +2 , 14,14)];
    [_secondViewInputTextFiled.layer addSublayer:_loadingLayer];
    [_loadingLayer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
    
    //JXCV-JJKS-SEXE-EIEA-KDIT
    if (![_secondViewInputTextFiled.stringValue contains:@"-"] || _secondViewInputTextFiled.stringValue.length < 18) {
        [_secondViewInputTextFiledBgView setHidden:YES];
        [_seondViewResultView setHidden:NO];
        [_secondViewRegisterLabel setHidden:NO];
        [_secondViewResultImage setHidden:NO];
        [_secondViewResultImage setImage:[StringHelper imageNamed:@"registFailure"]];
        [self showReslutView:CustomLocalizedString(@"activate_error_discorrect", nil)];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            OperationLImitation *limit = [OperationLImitation singleton];
            if (limit.remainderCount <= 0) {
                [limit setLimitStatus:@"noquote"];
            }else {
                [limit setLimitStatus:@"notactivate"];
            }
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_secondViewInputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        return;
    }
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (![TempHelper isInternetAvail]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_secondViewInputTextFiledBgView setHidden:YES];
                [_seondViewResultView setHidden:NO];
                [_secondViewRegisterLabel setHidden:NO];
                [_secondViewResultImage setHidden:NO];
                [_secondViewResultImage setImage:[StringHelper imageNamed:@"registFailure"]];
                [self showReslutView:CustomLocalizedString(@"activate_error_disinternet", nil)];
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    OperationLImitation *limit = [OperationLImitation singleton];
                    if (limit.remainderCount <= 0) {
                        [limit setLimitStatus:@"noquote"];
                    }else {
                        [limit setLimitStatus:@"notactivate"];
                    }
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",CustomLocalizedString(@"activate_error_disinternet", nil)] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                return;
            });
        }
        IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
        [software setIsIllegal:NO];
        BOOL registerSuccess = [software registerSoftware:_secondViewInputTextFiled.stringValue];
        _isSucess = registerSuccess;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_loadingLayer removeFromSuperlayer];
            [_secondViewInputTextFiledBgView setHidden:YES];
            [_seondViewResultView setHidden:NO];
            [_secondViewRegisterLabel setHidden:NO];
            [_secondViewResultImage setHidden:NO];
            if (registerSuccess) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    OperationLImitation *limit = [OperationLImitation singleton];
                    if (limit.remainderCount <= 0) {
                        [limit setLimitStatus:@"noquote"];
                    }else {
                        [limit setLimitStatus:@"notactivate"];
                    }
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:True",_secondViewInputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_secondViewResultImage setImage:[StringHelper imageNamed:@"registSuccess"]];
                [self showReslutView:CustomLocalizedString(@"activate_success", nil)];
                
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //跳转到设备连接页面
                    [self.view setWantsLayer:YES];
                    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
                    animation.delegate = self;
                    animation.fromValue=[NSNumber numberWithFloat:1.0];
                    animation.toValue=[NSNumber numberWithFloat:0.0];
                    animation.autoreverses= NO;
                    animation.duration=2.0;
                    animation.repeatCount= 0;
                    animation.removedOnCompletion=NO;
                    animation.fillMode=kCAFillModeForwards;
                    [self.view.layer addAnimation:animation forKey:@"remove"];
                    [self performSelector:@selector(toMainView) withObject:self afterDelay:1];
                });
            }else{
                if (software.isIllegal) {
                    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"https://www.imobie.com/landing/anytrans-official-xmas-offer.htm?%@", nil),[_secondViewInputTextFiled.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    NSURL *url = [NSURL URLWithString:str];
                    
                    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                    [ws openURL:url];
                }
                
                NSString *errorStr = @"";
                if (![TempHelper stringIsNilOrEmpty:software.rigisterErrorCode]) {
                    if ([software.rigisterErrorCode isEqualToString:@"002"]) {
                        errorStr = CustomLocalizedString(@"activate_error_expired", nil);
                    }else if ([software.rigisterErrorCode isEqualToString:@"003"]) {
                        errorStr = CustomLocalizedString(@"activate_error_overPC", nil);
                    }else if ([software.rigisterErrorCode isEqualToString:@"012"]) {
                        errorStr = CustomLocalizedString(@"activate_error_timeOutofPeriod", nil);
                    }else {
                        errorStr = [NSString stringWithFormat:CustomLocalizedString(@"activate_error_registerFailed", nil),[software.rigisterErrorCode intValue]];
                    }
                }else {
                    errorStr = [NSString stringWithFormat:CustomLocalizedString(@"activate_error_registerFailed", nil),-1];
                }
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    OperationLImitation *limit = [OperationLImitation singleton];
                    if (limit.remainderCount <= 0) {
                        [limit setLimitStatus:@"noquote"];
                    }else {
                        [limit setLimitStatus:@"notactivate"];
                    }
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_secondViewInputTextFiled.stringValue] label:Register transferCount:0 screenView:@"activate" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_secondViewResultImage setImage:[StringHelper imageNamed:@"registFailure"]];
                [self showReslutView:errorStr];
            }
        });
    });
    
}

- (void)showReslutView:(NSString *)errorStr {
    /*
    [_registerLabel setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"", nil)]];
    NSString *overStr = CustomLocalizedString(@"register_window_tryagainBtn", nil);
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_registerLabel setLinkTextAttributes:linkAttributes];
    NSString *str = nil;
    if (_isSucess) {
        str = [errorStr retain];
    }else {
        str = [[[errorStr stringByAppendingString:@"    "]stringByAppendingString:overStr] retain];;
    }
    
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:str withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [str rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_registerLabel textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;

    NSRect LableRect = [TempHelper calcuTextBounds:errorStr fontSize:14];

    [_textScroview setFrameSize:NSMakeSize(LableRect.size.width + 150, _textScroview.frame.size.height)];

    float ox = (_reslutView.frame.size.width - _relustImageView.frame.size.width - _textScroview.frame.size.width )/2;

    if (_isSucess) {
        [_relustImageView setFrameOrigin:NSMakePoint(ox + 40, _relustImageView.frame.origin.y)];
        [_textScroview setFrameOrigin:NSMakePoint(ox+ 70, -6)];
    }else {
        [_relustImageView setFrameOrigin:NSMakePoint(ox+40, _relustImageView.frame.origin.y)];
        [_textScroview setFrameOrigin:NSMakePoint(ox+ 70, -6)];
    }

    [str autorelease];
     */
    
    [_secondViewRegisterLabel setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"", nil)]];
    NSString *overStr = CustomLocalizedString(@"register_window_tryagainBtn", nil);
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_secondViewRegisterLabel setLinkTextAttributes:linkAttributes];
    NSString *str = nil;
    if (_isSucess) {
        str = [errorStr retain];
    }else {
        str = [[[errorStr stringByAppendingString:@"    "]stringByAppendingString:overStr] retain];;
    }
    
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:str withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [str rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_secondViewRegisterLabel textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
    
    NSRect LableRect = [TempHelper calcuTextBounds:errorStr fontSize:14];
    
    //由于计算不准，多减30
    float ox = (_seondViewResultView.frame.size.width - _secondViewResultImage.frame.size.width - LableRect.size.width - 40 )/2 - 30;
    
    [_secondViewResultImage setFrameOrigin:NSMakePoint(ox , _secondViewResultImage.frame.origin.y)];
    [_secondViewTextScrollView setFrameOrigin:NSMakePoint(ox+ _secondViewResultImage.frame.size.width  + 10, -6)];

    [str autorelease];
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    NSString *overStr = CustomLocalizedString(@"register_window_tryagainBtn", nil);

    if ([link isEqualToString:overStr]) {
        [_reslutView setHidden:YES];
        [_inputTextFiledBgView setHidden:NO];
        [_inputTextFiled setStringValue:@""];
        [_loadingLayer removeAllAnimations];
        [_loadingLayer removeFromSuperlayer];
    
        [_seondViewResultView setHidden:YES];
        [_secondViewRegisterLabel setHidden:YES];
        [_secondViewResultImage setHidden:YES];
        [_secondViewInputTextFiledBgView setHidden:NO];
        [_secondViewInputTextFiled setStringValue:@""];
    }
    return YES;
}

- (void)inputCode {
    /*
    if (_inputTextFiled.stringValue.length > 30) {
        _inputTextFiled.stringValue = [_inputTextFiled.stringValue substringToIndex:30];
    }
    [_activeBtn setEnabled:YES];
     */
    
    NSString *str = [_secondViewInputTextFiled.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_secondViewInputTextFiled.stringValue.length > 30) {
        _secondViewInputTextFiled.stringValue = [str substringFromIndex:30];
    }else {
        _secondViewInputTextFiled.stringValue = str;
    }
    [_secondViewActiveBtn setEnabled:YES];
}

- (void)toMainView {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACK_MAINVIEW object:nil];
}

- (void)gotoShop {
//    [_likeWebView setHidden:NO];
//    [[_likeWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://order.imobie.com/1366/purl-phonerescue-mac-family?x-source=imen&paymentTypeId=CCA_VIS&x-channel=direct&x-referrer=https://www.imobie.com/phonerescue/buy-mac.htm-3.2.0&__utma=1.1933093557.1478160975.1478160975.1478160975.1&__utmb=1.16.10.1478160975&__utmc=1&__utmx=-&__utmz=1.1478160975.1.1.utmcsr=(direct)%7Cutmccn=(direct)%7Cutmcmd=(none)&__utmv=-&__utmk=49033894"]]];
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [softWare setSelectModular:@"AnyTrans Activation"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [[OperationLImitation singleton] setLimitStatus:@"notactivate"];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@#status=notactivate", [TempHelper currentSelectionLanguage]] label:Buy transferCount:0 screenView:@"go shop" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }

    NSURL *url = nil;
    
    NSString *str = CustomLocalizedString(@"Buy_Url", nil);

    NSString *ver = softWare.version;
    if (softWare.isIronsrc) {
        if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
            ver = @"ironsrc3";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage){
            ver = @"ironsrc1";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
            ver = @"ironsrc2";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage){
            ver = @"ironsrc";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage){
            ver = @"ironsrc4";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage){
            ver = @"ironsrc5";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
            ver = @"ironsrc6";
        }else {
            ver = @"ironsrc";
        }
    }
    if ([StringHelper chirstmasActivity] && [IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage && [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        url = [NSURL URLWithString:@"https://www.imobie.com/anytrans/buy-mac.htm?ref=holiday"];
    }else {
        int buyId = 0;
        url = [NSURL URLWithString:[NSString stringWithFormat:str, ver, buyId]];
    }
    
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if (anim == [self.view.layer animationForKey:@"remove"]) {
            [self.view removeFromSuperview];
        }
    }
}

- (void)closeWindow:(id)sender {
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
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:CLOSE_SHOPPING_VIEW object:[NSNumber numberWithBool:YES]];
    }];
}


- (void)dealloc {
    if (_loadingLayer != nil) {
        [_loadingLayer release];
        _loadingLayer = nil;
    }
    if (_closebutton) {
        [_closebutton release];
        _closebutton = nil;
    }
    
    [_nc removeObserver:self name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    [super dealloc];
}
@end

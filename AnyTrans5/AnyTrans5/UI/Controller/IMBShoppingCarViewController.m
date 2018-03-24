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
@implementation IMBShoppingCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}
- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
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
//        [_activeBgView setBackgroundColor:IMBBG_COLOR];
//        [_activeBgView setWantsLayer:YES];
//        [_activeBgView.layer setCornerRadius:3];
        [_enterLicenseTitle setStringValue:enterSting];
        NSMutableParagraphStyle *style3 = [[NSMutableParagraphStyle alloc] init];
        [style3 setAlignment:NSCenterTextAlignment];
        
        [_inputTextFiledBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
        [_inputTextFiledBgView setHasCorner:YES];

//        [_inputTextFiled.cell setPlaceholderString:CustomLocalizedString(@"register_text_eg", nil)];
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

  

    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_nc addObserver:self selector:@selector(windowChangeSize:) name:NSWindowDidChangeScreenNotification object:nil];
    [_shlogoImageView setImage:[StringHelper imageNamed:@"buy-img1"]];
    [_imageView setImage:[StringHelper imageNamed:@"Buy_logo"]];
    [_registerLabel setDelegate:self];
    [_reslutView setHidden:YES];
//    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    _nc = [NSNotificationCenter defaultCenter];
    [_nc addObserver:self selector:@selector(inputCode) name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
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
//    [_activeBgView setBackgroundColor:IMBBG_COLOR];
//    [_activeBgView setWantsLayer:YES];
//    [_activeBgView.layer setCornerRadius:3];
    [_enterLicenseTitle setStringValue:enterSting];
    NSMutableParagraphStyle *style3 = [[NSMutableParagraphStyle alloc] init];
    [style3 setAlignment:NSCenterTextAlignment];

    [_inputTextFiledBgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_inputTextFiledBgView setHasCorner:YES];
//    NSMutableAttributedString *placeholderAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"register_text_eg", nil)] autorelease];
//    [placeholderAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil) ]range:NSMakeRange(0, placeholderAs.string.length)];
//    [_inputTextFiled.cell setPlaceholderAttributedString:placeholderAs];
//    [_inputTextFiled.cell setPlaceholderString:CustomLocalizedString(@"register_text_eg", nil)];
    NSMutableAttributedString *as5 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"register_text_eg", nil)] autorelease];
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
    NSMutableAttributedString *as3 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"register_text_eg", nil)] autorelease];
    [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as3.string.length)];
    [as3 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as3.string.length)];
    [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as3.string.length)];
    [_inputTextFiled.cell setPlaceholderAttributedString:as3];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    [self.view setWantsLayer:YES];
//    [self.view.layer setCornerRadius:5];
    
    HoverButton *closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(self.view.frame) - 32 - 7)), 32, 32)];
    closebutton.tag = 121;
    closebutton.autoresizesSubviews = YES;
    closebutton.autoresizingMask = NSViewMinYMargin;
    [closebutton setEnabled:YES];
    [closebutton setTarget:self];
    [closebutton setAction:@selector(closeWindow:)];
    [closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [self.view addSubview:closebutton];
    _loadingLayer = [[CALayer alloc] init];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
}

- (void)changeSkin:(NSNotification *)notification {
//    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_shlogoImageView setImage:[StringHelper imageNamed:@"buy-img1"]];
    [_imageView setImage:[StringHelper imageNamed:@"Buy_logo"]];
    [self doChangeLanguage:nil];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    [_lineView setNeedsDisplay:YES];
}

- (void)startActive {
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
}

- (void)showReslutView:(NSString *)errorStr {
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
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    NSString *overStr = CustomLocalizedString(@"register_window_tryagainBtn", nil);

    if ([link isEqualToString:overStr]) {
        [_reslutView setHidden:YES];
        [_inputTextFiledBgView setHidden:NO];
        [_inputTextFiled setStringValue:@""];
        [_loadingLayer removeAllAnimations];
        [_loadingLayer removeFromSuperlayer];
    }
    return YES;
}

- (void)inputCode {
    if (_inputTextFiled.stringValue.length > 30) {
        _inputTextFiled.stringValue = [_inputTextFiled.stringValue substringToIndex:30];
    }
    [_activeBtn setEnabled:YES];
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
        NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
        dimensionMutDict = [TempHelper customDimension];
        [dimensionMutDict setObject:softWare.selectModular forKey:@"cd5"];
        dimensionDict = [dimensionMutDict copy];
    }
    [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[TempHelper currentSelectionLanguage] label:Buy transferCount:0 screenView:@"go shop" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
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

- (void)windowDidResize:(NSNotification *)notification {
    
}

- (void)windowChangeSize:(NSNotification *)notification {
    
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
    
    [_nc removeObserver:self name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    [super dealloc];
}
@end

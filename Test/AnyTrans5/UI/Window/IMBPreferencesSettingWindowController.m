//
//  IMBPreferencesSettingWindowController.m
//  AnyTrans
//
//  Created by long on 16-8-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBPreferencesSettingWindowController.h"
#import "IMBToolbarWindow.h"
#import "TempHelper.h"
#import "IMBAppConfig.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
#define AppConfigName @"iMobieAppConfig.plist"
#define AppDeviceConfigPath @"iMobieConfig"
#import "HoverButton.h"
#import "IMBCommonEnum.h"
@interface IMBPreferencesSettingWindowController ()

@end

@implementation IMBPreferencesSettingWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)dealloc{
    [super dealloc];
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
}

-(id)initWithIpod:(IMBiPod *)ipod{
    if ([super initWithWindowNibName:@"IMBPreferencesSettingWindowController"]) {
        _iPod = [ipod retain];
    }
    return self;
}

-(void)awakeFromNib{
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"]) {
        [[self.window standardWindowButton:NSWindowCloseButton] setHidden:YES];
        [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
        HoverButton *closeBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(7, 2, 14, 14)];
        [closeBtn setMouseEnteredImage:[NSImage imageNamed:@"close2"] mouseExitImage:[NSImage imageNamed:@"close"] mouseDownImage:[NSImage imageNamed:@"close3"]];
        [closeBtn setTarget:self];
        [closeBtn setAction:@selector(closeWindow:)];
        [[(IMBToolbarWindow *)self.window titleBarView] addSubview:closeBtn];
        [closeBtn release], closeBtn = nil;
    }

    [_iconImageView1 setImage:[StringHelper imageNamed:@"setting_app"]];
    [_iconImageView3 setImage:[StringHelper imageNamed:@"setting_other"]];
    [_iconImageView4 setImage:[StringHelper imageNamed:@"setting_app"]];
    [_iconImageView5 setImage:[StringHelper imageNamed:@"setting_app"]];
    [_iconImageView6 setImage:[StringHelper imageNamed:@"setting_app"]];
    [_iconImageView7 setImage:[StringHelper imageNamed:@"setting_app"]];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *lanStr = [currentLocale objectForKey:NSLocaleLanguageCode];
    if ([[lanStr lowercaseString] isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [_iconImageView1 setFrame:NSMakeRect(_generalView.frame.size.width - 40, _iconImageView1.frame.origin.y, _iconImageView1.frame.size.width, _iconImageView1.frame.size.height)];
        [_iconImageView3 setFrame:NSMakeRect(_generalView.frame.size.width - 40, _iconImageView3.frame.origin.y, _iconImageView3.frame.size.width, _iconImageView3.frame.size.height)];
        [_iconImageView4 setFrame:NSMakeRect(_generalView.frame.size.width - 40, _iconImageView4.frame.origin.y, _iconImageView4.frame.size.width, _iconImageView4.frame.size.height)];
        [_iconImageView5 setFrame:NSMakeRect(_generalView.frame.size.width - 40, _iconImageView5.frame.origin.y, _iconImageView5.frame.size.width, _iconImageView5.frame.size.height)];
        [_iconImageView6 setFrame:NSMakeRect(_generalView.frame.size.width - 40, _iconImageView6.frame.origin.y, _iconImageView6.frame.size.width, _iconImageView6.frame.size.height)];
        [_iconImageView7 setFrame:NSMakeRect(_generalView.frame.size.width - 40, _iconImageView7.frame.origin.y, _iconImageView7.frame.size.width, _iconImageView7.frame.size.height)];
        //
        [_toiTunesCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _toiTunesCheckBtn.frame.origin.y, 16, 16)];
        [_toiTunesMuliCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _toiTunesMuliCheckBtn.frame.origin.y, 16, 16)];
        [_onMacOnlyAppCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _onMacOnlyAppCheckBtn.frame.origin.y, 16, 16)];
        [_onmacProAndDataCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _onmacProAndDataCheckBtn.frame.origin.y, 16, 16)];
        [_onDeviceOnlyAppProCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _onDeviceOnlyAppProCheckBtn.frame.origin.y, 16, 16)];
        [_onDeviceOnlyAppDataCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _onDeviceOnlyAppDataCheckBtn.frame.origin.y, 16, 16)];
        [_onDeviceProAndDataCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _onDeviceProAndDataCheckBtn.frame.origin.y, 16, 16)];
        [_aotoImportAppCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _aotoImportAppCheckBtn.frame.origin.y, 16, 16)];
        [_aotoUpgradeCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _aotoUpgradeCheckBtn.frame.origin.y, 16, 16)];
        [_aotoDownGradeAppCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _aotoDownGradeAppCheckBtn.frame.origin.y, 16, 16)];
        [_videoMPEGCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _videoMPEGCheckBtn.frame.origin.y, 16, 16)];
        [_videoH264CheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _videoH264CheckBtn.frame.origin.y, 16, 16)];
        [_videoDontWantCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _videoDontWantCheckBtn.frame.origin.y, 16, 16)];
        [_audioAACCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _audioAACCheckBtn.frame.origin.y, 16, 16)];
        [_audioMP3CheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _audioMP3CheckBtn.frame.origin.y, 16, 16)];
        [_audioDontWantCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _audioDontWantCheckBtn.frame.origin.y, 16, 16)];
        
        [_transQualiTyUseHighCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _transQualiTyUseHighCheckBtn.frame.origin.y, 16, 16)];
        [_transQuliTyUseNormalCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _transQuliTyUseNormalCheckBtn.frame.origin.y, 16, 16)];
        [_exportOptionCheckBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _exportOptionCheckBtn.frame.origin.y, 16, 16)];
        [_livePhotoOneBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _livePhotoOneBtn.frame.origin.y, 16, 16)];
        [_livePhotoTwoBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _livePhotoTwoBtn.frame.origin.y, 16, 16)];
        [_livePhotoThreeBtn setFrame:NSMakeRect(_generalView.frame.size.width - 40, _livePhotoThreeBtn.frame.origin.y, 16, 16)];
    }

    [_mainView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_oneLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)]];
    [_bottomlineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)]];
    [_topTitleSter setFrame:NSMakeRect((self.window.frame.size.width - _topTitleSter.frame.size.width)/2, 0, _topTitleSter.frame.size.width, _topTitleSter.frame.size.height)];
    [[(IMBToolbarWindow *)self.window titleBarView] addSubview:_topTitleSter];
    NSString *generBtnStr =CustomLocalizedString(@"setting_id_1", nil);
    NSString *trancodingBtnStr = CustomLocalizedString(@"setting_id_2", nil);
    [_generalView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    [_transCodingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)]];
    NSRect rect2 = [TempHelper calcuTextBounds:trancodingBtnStr fontSize:14];
    [_generalBtn reSetInit:@"General" WithPrefixImageName:@"preferbtn"];
    [_trancodingViewBtn reSetInit:@"Trancoding" WithPrefixImageName:@"trancodingbtn"];
    [_generalBtn setAttributedTitle:[self attributedTitle:generBtnStr withIsDown:YES] ];
    [_trancodingViewBtn setAttributedTitle:[self attributedTitle:trancodingBtnStr withIsDown:NO]];
    [_generalBtn setFrame:NSMakeRect(ceilf(self.window.frame.size.width/2 - rect2.size.width - 20), _generalBtn.frame.origin.y, ceilf(rect2.size.width +20), 22)];
    [_trancodingViewBtn setFrame:NSMakeRect(ceilf(self.window.frame.size.width/2), _trancodingViewBtn.frame.origin.y,ceilf( rect2.size.width +20), 22)];
    [_generalBtn setIsDown:YES];
    [_trancodingViewBtn setIsDown:NO];
    
    
//    [_scrollView setFrame:NSMakeRect(0, -200, _scrollView., <#CGFloat h#>)]
    [_midlleView setFrame:NSMakeRect(0, -200, _midlleView.frame.size.width, _generalView.frame.size.height)];
    [_midlleView addSubview:_generalView];
//    [_scrollView setDocumentVie_generalView];
    [_generalBtn setTarget:self];
    [_generalBtn setAction:@selector(generalView:)];
    [_trancodingViewBtn setTarget:self];
    [_trancodingViewBtn setAction:@selector(transCodingView:)];
    [self settingAllBtnAndText];
    [self settingTextWrittenWords];
}

-(void)settingTextWrittenWords{
    [_topTitleSter setStringValue:CustomLocalizedString(@"SettingMenu_Name", nil)];
    [_applicationStr setStringValue:CustomLocalizedString(@"setting_id_15", nil)];
    [iTuneslibrayStr setStringValue:CustomLocalizedString(@"setting_id_19", nil)];
    [_onlyAppstr setStringValue:CustomLocalizedString(@"setting_id_22", nil)];
    [_appppAndDataStr setStringValue:CustomLocalizedString(@"setting_id_24", nil)];
    
    [_appOnMacStr setStringValue:CustomLocalizedString(@"setting_id_20", nil)];
    [_appOnMacOnlyAppStr setStringValue:CustomLocalizedString(@"setting_id_22", nil)];
    [_appOnMacPAndDataStr setStringValue:CustomLocalizedString(@"setting_id_24", nil)];
    
    [_onDeviceTitleStr setStringValue:CustomLocalizedString(@"setting_id_21", nil)];
    [_onDeviceOnlyAppProStr setStringValue:CustomLocalizedString(@"setting_id_22", nil)];
    [_onDeviceOnlyAppDataStr setStringValue:CustomLocalizedString(@"setting_id_23", nil)];
    [_onDeviceProAndDataStr setStringValue:CustomLocalizedString(@"setting_id_24", nil)];
    
    [_autoImportAppStr setStringValue:CustomLocalizedString(@"setting_id_25", nil)];
    [_autoUpGradeAppStr setStringValue:CustomLocalizedString(@"setting_id_26", nil)];
    [_autoDowngradeAppStr setStringValue:CustomLocalizedString(@"setting_id_27", nil)];
    [_appSettingEndStr setStringValue:CustomLocalizedString(@"MSG_Device_Edition_Too_high", nil)];

    [_videoFormatTitleStr setStringValue:CustomLocalizedString(@"setting_id_3", nil)];
    [_videoMPEGStr setStringValue:CustomLocalizedString(@"setting_id_7", nil)];
    [_videoH264Str setStringValue:CustomLocalizedString(@"setting_id_8", nil)];
    [_videoDontWantStr setStringValue:CustomLocalizedString(@"setting_id_8_1", nil)];

    [_audioTitleStr setStringValue:CustomLocalizedString(@"setting_id_5", nil)];
    [_audioAACStr setStringValue:CustomLocalizedString(@"setting_id_11", nil)];
    [_audioMP3Str setStringValue:CustomLocalizedString(@"setting_id_12", nil)];
    [_audioDontWantStr setStringValue:CustomLocalizedString(@"setting_id_12_1", nil)];
    
    [_transQualiTyTitleStr setStringValue:CustomLocalizedString(@"setting_id_6", nil)];
    [_transQualiTyUseHighStr setStringValue:CustomLocalizedString(@"setting_id_13", nil)];
    [_transQuliTyUseNormalStr setStringValue:CustomLocalizedString(@"setting_id_14", nil)];
    
    [_livePhotoTitle setStringValue:CustomLocalizedString(@"setting_id_33", nil)];
    [_livePhotoOneTitle setStringValue:CustomLocalizedString(@"setting_id_34", nil)];
    [_livePhotoTwoTitle setStringValue:CustomLocalizedString(@"setting_id_35", nil)];
    [_livePhotoThreeTitle setStringValue:CustomLocalizedString(@"setting_id_36", nil)];
    
    [_exportOptionTitle setStringValue:CustomLocalizedString(@"setting_id_37", nil)];
    [_exportOptionStr setStringValue:CustomLocalizedString(@"setting_id_38", nil)];
    //设置字体颜色
    [_topTitleSter setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_applicationStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [iTuneslibrayStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_onlyAppstr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_appppAndDataStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_appOnMacStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_appOnMacStr setStringValue:CustomLocalizedString(@"setting_id_20", nil)];
    [_appOnMacOnlyAppStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_appOnMacOnlyAppStr setStringValue:CustomLocalizedString(@"setting_id_22", nil)];
    [_appOnMacPAndDataStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_appOnMacPAndDataStr setStringValue:CustomLocalizedString(@"setting_id_24", nil)];
    
    [_onDeviceTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_onDeviceOnlyAppProStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_onDeviceOnlyAppDataStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_onDeviceProAndDataStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_autoImportAppStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_autoUpGradeAppStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_autoDowngradeAppStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_appSettingEndStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_videoFormatTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_videoMPEGStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_videoH264Str setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_videoDontWantStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_audioTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_audioAACStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_audioMP3Str setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_audioDontWantStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_transQualiTyTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_transQualiTyUseHighStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_transQuliTyUseNormalStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_livePhotoTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_livePhotoOneTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_livePhotoTwoTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_livePhotoThreeTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_exportOptionTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_exportOptionStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

-(void)settingAllBtnAndText{
    NSString *cancelStr = CustomLocalizedString(@"Calendar_id_12", nil);
    [_canCelBtn reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_canCelBtn.btnCell setIsDrawBg:YES];
    [_canCelBtn setIsReslutVeiw:YES];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_canCelBtn setAttributedTitle:attributedTitles];
    [_canCelBtn setTarget:self];
    [_canCelBtn setAction:@selector(cancelBtnDown:)];
    NSString *saveStr = CustomLocalizedString(@"Calendar_id_9", nil);
    [_saveBtn reSetInit:saveStr WithPrefixImageName:@"pop"];
    [_saveBtn.btnCell setIsDrawBg:YES];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:saveStr]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_saveBtn setAttributedTitle:attributedTitles1];
    [_saveBtn setTarget:self];
    [_saveBtn setAction:@selector(saveBtnDown:)];
    
    IMBAppTransferTypeEnum toitunesStr = _iPod.appConfig.appExportToiTunesType;
    IMBAppTransferTypeEnum toMac = _iPod.appConfig.appExportToMacType;
    IMBAppTransferTypeEnum toDevice = _iPod.appConfig.appExportToDeviceType;

    [_toiTunesCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_toiTunesCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_toiTunesMuliCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_toiTunesMuliCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    if (toitunesStr == AppTransferType_ApplicationOnly) {
        [_toiTunesCheckBtn setState:YES];
        [_toiTunesMuliCheckBtn setState:NO];
    }else{
        [_toiTunesCheckBtn setState:NO];
        [_toiTunesMuliCheckBtn setState:YES];
    }
    [_toiTunesCheckBtn setIsDrawColor:YES];
    [_toiTunesMuliCheckBtn setIsDrawColor:YES];
    
    [_onMacOnlyAppCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_onMacOnlyAppCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_onmacProAndDataCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_onmacProAndDataCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    
    if (toMac == AppTransferType_ApplicationOnly) {
        [_onMacOnlyAppCheckBtn setState:YES];
        [_onmacProAndDataCheckBtn setState:NO];
    }else{
        [_onMacOnlyAppCheckBtn setState:NO];
        [_onmacProAndDataCheckBtn setState:YES];
    }
    [_onMacOnlyAppCheckBtn setIsDrawColor:YES];
    [_onmacProAndDataCheckBtn setIsDrawColor:YES];
    
    
    [_onDeviceOnlyAppProCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_onDeviceOnlyAppProCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_onDeviceOnlyAppDataCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_onDeviceOnlyAppDataCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_onDeviceProAndDataCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_onDeviceProAndDataCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    if (toDevice == AppTransferType_ApplicationOnly) {
        [_onDeviceOnlyAppProCheckBtn setState:YES];
        [_onDeviceOnlyAppDataCheckBtn setState:NO];
        [_onDeviceProAndDataCheckBtn setState:NO];
    }else if (toDevice == AppTransferType_DocumentsOnly){
        [_onDeviceOnlyAppProCheckBtn setState:NO];
        [_onDeviceOnlyAppDataCheckBtn setState:YES];
        [_onDeviceProAndDataCheckBtn setState:NO];
    }else{
        [_onDeviceOnlyAppProCheckBtn setState:NO];
        [_onDeviceOnlyAppDataCheckBtn setState:NO];
        [_onDeviceProAndDataCheckBtn setState:YES];
    }
    [_onDeviceOnlyAppProCheckBtn setIsDrawColor:YES];
    [_onDeviceOnlyAppDataCheckBtn setIsDrawColor:YES];
    [_onDeviceProAndDataCheckBtn setIsDrawColor:YES];
    
    BOOL isAppDown = _iPod.appConfig.isAppDowngrade;
    BOOL isAppImport = _iPod.appConfig.isAppImportJustData;
    BOOL isAppUpgrade = _iPod.appConfig.isAppUpgrade;
    
    [_aotoImportAppCheckBtn setUnCheckImg:[StringHelper imageNamed:@"checkbox1" ]];
    [_aotoImportAppCheckBtn setCheckImg:[StringHelper imageNamed:@"checkbox2" ]];
    if (isAppImport) {
        [_aotoImportAppCheckBtn setState:1];
    }else{
        [_aotoImportAppCheckBtn setState:0];
    }
    
    [_aotoUpgradeCheckBtn setUnCheckImg:[StringHelper imageNamed:@"checkbox1" ]];
    [_aotoUpgradeCheckBtn setCheckImg:[StringHelper imageNamed:@"checkbox2" ]];
    if (isAppUpgrade) {
        [_aotoUpgradeCheckBtn setState:1];
    }else{
        [_aotoUpgradeCheckBtn setState:0];
    }
    [_aotoDownGradeAppCheckBtn setUnCheckImg:[StringHelper imageNamed:@"checkbox1" ]];
    [_aotoDownGradeAppCheckBtn setCheckImg:[StringHelper imageNamed:@"checkbox2" ]];
    if (isAppDown) {
        [_aotoDownGradeAppCheckBtn setState:1];
    }else{
        [_aotoDownGradeAppCheckBtn setState:0];
    }
////    CvtConfigName
//   NSString *configDevicePath = [_iPod.session.sessionFolderPath stringByAppendingPathComponent:AppDeviceConfigPath];
//   NSString *ringDevicePath = [configDevicePath stringByAppendingPathComponent :RtCvtConfigName];
//    NSDictionary *ringToneDic = [NSDictionary dictionaryWithContentsOfFile:ringDevicePath];
//    NSDictionary *ringToneStr1 = [ringToneDic objectForKey:@"RingtoneConvertConfig"];
//    NSString *ringToneStr = [ringToneStr1 objectForKey:@"RingtoneSize"];
//    [_ringtoneTimeOneCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
//    [_ringtoneTimeOneCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
//    [_ringtoneTimeTwoCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
//    [_ringtoneTimeTwoCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
//    [_ringtoneTimeThreeCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
//    [_ringtoneTimeThreeCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
//    if ([ringToneStr isEqualToString:@"Sec40"]) {
//        [_ringtoneTimeOneCheckBtn setState:NO];
//        [_ringtoneTimeTwoCheckBtn setState:YES];
//        [_ringtoneTimeThreeCheckBtn setState:NO];
//    }else if ([ringToneStr isEqualToString:@"SecRest"]){
//        [_ringtoneTimeOneCheckBtn setState:NO];
//        [_ringtoneTimeTwoCheckBtn setState:NO];
//        [_ringtoneTimeThreeCheckBtn setState:YES];
//    }else{
//        [_ringtoneTimeOneCheckBtn setState:YES];
//        [_ringtoneTimeTwoCheckBtn setState:NO];
//        [_ringtoneTimeThreeCheckBtn setState:NO];
//    }
//    [_ringtoneTimeOneCheckBtn setIsDrawColor:YES];
//    [_ringtoneTimeTwoCheckBtn setIsDrawColor:YES];
//    [_ringtoneTimeThreeCheckBtn setIsDrawColor:YES];

    [_videoMPEGCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_videoMPEGCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_videoH264CheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_videoH264CheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_videoDontWantCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_videoDontWantCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    CvtMediaFormatEnum videoStr = _iPod.transCodingConfig.mediaFormat;
    if (videoStr == CvtMediaFormat_MPEG4) {
        [_videoMPEGCheckBtn setState:YES];
        [_videoH264CheckBtn setState:NO];
        [_videoDontWantCheckBtn setState:NO];
    }else if (videoStr == CvtMediaFormat_H264){
        [_videoMPEGCheckBtn setState:NO];
        [_videoH264CheckBtn setState:YES];
        [_videoDontWantCheckBtn setState:NO];
    }else{
        [_videoMPEGCheckBtn setState:NO];
        [_videoH264CheckBtn setState:NO];
        [_videoDontWantCheckBtn setState:YES];
    }

    [_videoMPEGCheckBtn setIsDrawColor:YES];
    [_videoH264CheckBtn setIsDrawColor:YES];
    [_videoDontWantCheckBtn setIsDrawColor:YES];
    
    [_audioAACCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_audioAACCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_audioMP3CheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_audioMP3CheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_audioDontWantCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_audioDontWantCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    CvtMediaFormatEnum audioStr = _iPod.transCodingConfig.audioFormat;
    if (audioStr == CvtMediaFormat_AAC) {
        [_audioAACCheckBtn setState:YES];
        [_audioMP3CheckBtn setState:NO];
        [_audioDontWantCheckBtn setState:NO];
    }else if (audioStr == CvtMediaFormat_MP){
        [_audioAACCheckBtn setState:NO];
        [_audioMP3CheckBtn setState:YES];
        [_audioDontWantCheckBtn setState:NO];
    }else{
        [_audioAACCheckBtn setState:NO];
        [_audioMP3CheckBtn setState:NO];
        [_audioDontWantCheckBtn setState:YES];
    }

    [_audioAACCheckBtn setIsDrawColor:YES];
    [_audioMP3CheckBtn setIsDrawColor:YES];
    [_audioDontWantCheckBtn setIsDrawColor:YES];
    
    [_transQualiTyUseHighCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_transQualiTyUseHighCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_transQuliTyUseNormalCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_transQuliTyUseNormalCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    CvtQualityTypeEnum transStr = _iPod.transCodingConfig.quality;
    if (transStr == CvtMediaQuality_LowQuality) {
        [_transQualiTyUseHighCheckBtn setState:NO];
        [_transQuliTyUseNormalCheckBtn setState:YES];
    }else{
        [_transQualiTyUseHighCheckBtn setState:YES];
        [_transQuliTyUseNormalCheckBtn setState:NO];
    }
    [_transQualiTyUseHighCheckBtn setIsDrawColor:YES];
    [_transQuliTyUseNormalCheckBtn setIsDrawColor:YES];
    
    NSString *livePhotoStr = [_iPod.exportSetting livePhotoType];
    [_livePhotoOneBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_livePhotoOneBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_livePhotoTwoBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_livePhotoTwoBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    [_livePhotoThreeBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1" ]];
    [_livePhotoThreeBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2" ]];
    if ([livePhotoStr isEqualToString:@"photo"]) {
        [_livePhotoOneBtn setState:YES];
        [_livePhotoTwoBtn setState:NO];
        [_livePhotoThreeBtn setState:NO];
    }else if ([livePhotoStr isEqualToString:@"mov"]){
        [_livePhotoOneBtn setState:NO];
        [_livePhotoTwoBtn setState:YES];
        [_livePhotoThreeBtn setState:NO];
    }else{
        [_livePhotoOneBtn setState:NO];
        [_livePhotoTwoBtn setState:NO];
        [_livePhotoThreeBtn setState:YES];
    }
    [_livePhotoOneBtn setIsDrawColor:YES];
    [_livePhotoTwoBtn setIsDrawColor:YES];
    [_livePhotoThreeBtn setIsDrawColor:YES];
    
    [_exportOptionCheckBtn setUnCheckImg:[StringHelper imageNamed:@"checkbox1" ]];
    [_exportOptionCheckBtn setCheckImg:[StringHelper imageNamed:@"checkbox2" ]];
    BOOL iscreadPhotoDate = [_iPod.exportSetting isCreadPhotoDate];
    if (iscreadPhotoDate) {
        _exportOptionCheckBtn.state = YES;
    }else{
        _exportOptionCheckBtn.state = NO;
    }
    [_exportOptionCheckBtn setIsDrawColor:YES];

}

-(NSMutableAttributedString *)attributedTitle:(NSString*)buttonName withIsDown:(BOOL)isdown{
 
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:buttonName]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, buttonName.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, buttonName.length)];
    if (isdown) {
        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] range:NSMakeRange(0, buttonName.length)];
    }else{
        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, buttonName.length)];
    }
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    return attributedTitles;
}


- (void)generalView:(id)sender {
    NSString *generBtnStr =CustomLocalizedString(@"setting_id_1", nil);
    NSString *trancodingBtnStr = CustomLocalizedString(@"setting_id_2", nil);
    [_transCodingView removeFromSuperview];
    [_midlleView setFrame:NSMakeRect(0, -200, _midlleView.frame.size.width, _generalView.frame.size.height)];
    [_midlleView addSubview:_generalView];
    [_generalBtn setIsDown:YES];
    [_trancodingViewBtn setIsDown:NO];
    [_generalBtn setAttributedTitle:[self attributedTitle:generBtnStr withIsDown:YES] ];
    [_trancodingViewBtn setAttributedTitle:[self attributedTitle:trancodingBtnStr withIsDown:NO]];
    [_generalBtn setNeedsDisplay:YES];
    [_trancodingViewBtn setNeedsDisplay:YES];
}

- (void)transCodingView:(id)sender {
    NSString *generBtnStr =CustomLocalizedString(@"setting_id_1", nil);
    NSString *trancodingBtnStr = CustomLocalizedString(@"setting_id_2", nil);
    [_generalView removeFromSuperview];
    [_midlleView setFrame:NSMakeRect(0, -200, _midlleView.frame.size.width, _transCodingView.frame.size.height)];
    [_midlleView addSubview:_transCodingView];
    [_generalBtn setIsDown:NO];
    [_generalBtn setAttributedTitle:[self attributedTitle:generBtnStr withIsDown:NO] ];
    [_trancodingViewBtn setAttributedTitle:[self attributedTitle:trancodingBtnStr withIsDown:YES]];
    [_trancodingViewBtn setIsDown:YES];
    [_generalBtn setNeedsDisplay:YES];
    [_trancodingViewBtn setNeedsDisplay:YES];
    
}

- (IBAction)exportOnlyAppProgramBtnDown:(id)sender {
    //    [_generalBtn setIsbackUpsettingBtn:YES];
//    appConfig.appExportToiTunesType = AppTransferType_ApplicationOnly;
    _toiTunesCheckBtn.state =YES;
    _toiTunesMuliCheckBtn.state = NO;
    [_toiTunesCheckBtn setNeedsDisplay:YES];
    [_toiTunesMuliCheckBtn setNeedsDisplay:YES];
}
- (IBAction)exportAppProgramAndAppdataBtnDown:(id)sender {
//    appConfig.appExportToiTunesType = AppTransferType_All;
    _toiTunesMuliCheckBtn.state =YES;
    _toiTunesCheckBtn.state = NO;
    [_toiTunesMuliCheckBtn setNeedsDisplay:YES];
    [_toiTunesCheckBtn setNeedsDisplay:YES];
}

- (IBAction)exportingAppsToOnMyMacOnlyAppProgramBtnDown:(id)sender {
//    appConfig.appExportToMacType = AppTransferType_ApplicationOnly;
    _onMacOnlyAppCheckBtn.state =YES;
    _onmacProAndDataCheckBtn.state = NO;
    [_onMacOnlyAppCheckBtn setNeedsDisplay:YES];
    [_onmacProAndDataCheckBtn setNeedsDisplay:YES];
}

- (IBAction)exportingAppsToOnMyMacAppProgramAndDataBtnDown:(id)sender {
//    appConfig.appExportToMacType = AppTransferType_All;
    _onmacProAndDataCheckBtn.state =YES;
    _onMacOnlyAppCheckBtn.state = NO;
    [_onmacProAndDataCheckBtn setNeedsDisplay:YES];
    [_onMacOnlyAppCheckBtn setNeedsDisplay:YES];
}

- (IBAction)transferringAnotherDevieOnlyProgramBtnDown:(id)sender {
//    appConfig.appExportToDeviceType = AppTransferType_ApplicationOnly;
     _onDeviceOnlyAppProCheckBtn.state =YES;
     _onDeviceOnlyAppDataCheckBtn.state =NO;
     _onDeviceProAndDataCheckBtn.state =NO;
    [_onDeviceOnlyAppProCheckBtn setNeedsDisplay:YES];
    [_onDeviceOnlyAppDataCheckBtn setNeedsDisplay:YES];
    [_onDeviceProAndDataCheckBtn setNeedsDisplay:YES];
}

- (IBAction)transferringAnotherDevieOnlyAppDataBtnDown:(id)sender {
//    appConfig.appExportToDeviceType = AppTransferType_DocumentsOnly;
    _onDeviceOnlyAppProCheckBtn.state =NO;
    _onDeviceOnlyAppDataCheckBtn.state =YES;
    _onDeviceProAndDataCheckBtn.state =NO;
    [_onDeviceOnlyAppProCheckBtn setNeedsDisplay:YES];
    [_onDeviceOnlyAppDataCheckBtn setNeedsDisplay:YES];
    [_onDeviceProAndDataCheckBtn setNeedsDisplay:YES];
}

- (IBAction)transferringAnotherDevieAppProgramAndAppDataBtnDown:(id)sender {
//    appConfig.appExportToDeviceType = AppTransferType_All;
    _onDeviceOnlyAppProCheckBtn.state =NO;
    _onDeviceOnlyAppDataCheckBtn.state =NO;
    _onDeviceProAndDataCheckBtn.state =YES;
    [_onDeviceOnlyAppProCheckBtn setNeedsDisplay:YES];
    [_onDeviceOnlyAppDataCheckBtn setNeedsDisplay:YES];
    [_onDeviceProAndDataCheckBtn setNeedsDisplay:YES];
}

- (IBAction)autoImportAppDataBtnDown:(id)sender {
//    appConfig.isAppImportJustData = _aotoImportAppCheckBtn.state;
}

- (IBAction)autoUpgradeAppBtndown:(id)sender {
//    appConfig.isAppUpgrade = _aotoUpgradeCheckBtn.state;
}

- (IBAction)autoDownGradeAppBtnDown:(id)sender {
//    appConfig.isAppDowngrade = _aotoDownGradeAppCheckBtn.state;
}

- (IBAction)videoMPEGBtnDown:(id)sender {

    _videoDontWantCheckBtn.state =NO;
    _videoH264CheckBtn.state =NO;
    _videoMPEGCheckBtn.state =YES;
    [_videoMPEGCheckBtn setNeedsDisplay:YES];
    [_videoH264CheckBtn setNeedsDisplay:YES];
    [_videoDontWantCheckBtn setNeedsDisplay:YES];
}
- (IBAction)videoH264BtnDown:(id)sender {

    _videoMPEGCheckBtn.state =NO;
    _videoDontWantCheckBtn.state =NO;
    _videoH264CheckBtn.state =YES;
    [_videoH264CheckBtn setNeedsDisplay:YES];
    [_videoMPEGCheckBtn setNeedsDisplay:YES];
    [_videoDontWantCheckBtn setNeedsDisplay:YES];
}
- (IBAction)videoDontWantBtnDown:(id)sender {
   
    _videoH264CheckBtn.state =NO;
    _videoMPEGCheckBtn.state =NO;
    _videoDontWantCheckBtn.state =YES;
    [_videoH264CheckBtn setNeedsDisplay:YES];
    [_videoDontWantCheckBtn setNeedsDisplay:YES];
    [_videoMPEGCheckBtn setNeedsDisplay:YES];
}

- (IBAction)audioAACBtnDown:(id)sender {
 
    _audioDontWantCheckBtn.state =NO;
    _audioMP3CheckBtn.state =NO;
    _audioAACCheckBtn.state =YES;
    [_audioAACCheckBtn setNeedsDisplay:YES];
    [_audioMP3CheckBtn setNeedsDisplay:YES];
    [_audioDontWantCheckBtn setNeedsDisplay:YES];
}
- (IBAction)audioMp3BtnDown:(id)sender {
 
    _audioDontWantCheckBtn.state =NO;
    _audioAACCheckBtn.state =NO;
    _audioMP3CheckBtn.state =YES;
    [_audioMP3CheckBtn setNeedsDisplay:YES];
    [_audioAACCheckBtn setNeedsDisplay:YES];
    [_audioDontWantCheckBtn setNeedsDisplay:YES];
}
- (IBAction)audioDontWantBtnDown:(id)sender {

    _audioAACCheckBtn.state =NO;
    _audioMP3CheckBtn.state =NO;
    _audioDontWantCheckBtn.state =YES;
    [_audioMP3CheckBtn setNeedsDisplay:YES];
    [_audioDontWantCheckBtn setNeedsDisplay:YES];
    [_audioAACCheckBtn setNeedsDisplay:YES];
}


- (IBAction)transcodingHighBtnDown:(id)sender {

    _transQuliTyUseNormalCheckBtn.state =NO;
    _transQualiTyUseHighCheckBtn.state =YES;
    [_transQuliTyUseNormalCheckBtn setNeedsDisplay:YES];
    [_transQualiTyUseHighCheckBtn setNeedsDisplay:YES];
}

- (IBAction)transcodingNormalBtnDown:(id)sender {
    _iPod.transCodingConfig.quality = CvtMediaQuality_LowQuality;
    _transQualiTyUseHighCheckBtn.state =NO;
    _transQuliTyUseNormalCheckBtn.state =YES;
    [_transQuliTyUseNormalCheckBtn setNeedsDisplay:YES];
    [_transQualiTyUseHighCheckBtn setNeedsDisplay:YES];
}

- (IBAction)livePhotoOneBtnDown:(id)sender {

    _livePhotoOneBtn.state = YES;
    _livePhotoTwoBtn.state = NO;
    _livePhotoThreeBtn.state = NO;
    [_livePhotoOneBtn setNeedsDisplay:YES];
    [_livePhotoTwoBtn setNeedsDisplay:YES];
    [_livePhotoThreeBtn setNeedsDisplay:YES];
}

- (IBAction)livePhotoTwoBtnDown:(id)sender {
 
    _livePhotoOneBtn.state = NO;
    _livePhotoTwoBtn.state = YES;
    _livePhotoThreeBtn.state = NO;
    [_livePhotoOneBtn setNeedsDisplay:YES];
    [_livePhotoTwoBtn setNeedsDisplay:YES];
    [_livePhotoThreeBtn setNeedsDisplay:YES];
}

- (IBAction)livePhotoThreeBtnDown:(id)sender {
 
    _livePhotoOneBtn.state = NO;
    _livePhotoTwoBtn.state = NO;
    _livePhotoThreeBtn.state = YES;
    [_livePhotoOneBtn setNeedsDisplay:YES];
    [_livePhotoTwoBtn setNeedsDisplay:YES];
    [_livePhotoThreeBtn setNeedsDisplay:YES];
}

- (IBAction)exportOptionBtnDown:(id)sender {
}


- (IBAction)cancelBtnDown:(id)sender {
    [self.window close];
}

- (IBAction)saveBtnDown:(id)sender {
    if (_toiTunesCheckBtn.state) {
        _iPod.appConfig.appExportToiTunesType = AppTransferType_ApplicationOnly;
    }else if (_toiTunesMuliCheckBtn.state){
        _iPod.appConfig.appExportToiTunesType = AppTransferType_All;
    }
    
    if (_onMacOnlyAppCheckBtn.state) {
        _iPod.appConfig.appExportToMacType = AppTransferType_ApplicationOnly;
    }else if (_onmacProAndDataCheckBtn.state){
        _iPod.appConfig.appExportToMacType = AppTransferType_All;
    }

    if (_onDeviceOnlyAppProCheckBtn.state) {
        _iPod.appConfig.appExportToDeviceType = AppTransferType_ApplicationOnly;
    }else if (_onDeviceOnlyAppDataCheckBtn.state){
        _iPod.appConfig.appExportToDeviceType = AppTransferType_DocumentsOnly;
    }else if (_onDeviceProAndDataCheckBtn.state){
        _iPod.appConfig.appExportToDeviceType = AppTransferType_All;
    }
    _iPod.appConfig.isAppImportJustData = _aotoImportAppCheckBtn.state;
    _iPod.appConfig.isAppUpgrade = _aotoUpgradeCheckBtn.state;
    _iPod.appConfig.isAppDowngrade = _aotoDownGradeAppCheckBtn.state;
    
    if (_videoMPEGCheckBtn.state) {
        _iPod.transCodingConfig.mediaFormat = CvtMediaFormat_MPEG4;
    }else if (_videoH264CheckBtn.state){
        _iPod.transCodingConfig.mediaFormat = CvtMediaFormat_H264;
    }else if (_videoDontWantCheckBtn.state){
        _iPod.transCodingConfig.mediaFormat = CvtMediaFormat_Unknown;
    }
    
    if (_audioAACCheckBtn.state) {
        _iPod.transCodingConfig.audioFormat = CvtMediaFormat_AAC;
    }else if (_audioMP3CheckBtn.state){
        _iPod.transCodingConfig.audioFormat = CvtMediaFormat_MP;
    }else if (_audioDontWantCheckBtn.state){
        _iPod.transCodingConfig.audioFormat = CvtMediaFormat_Unknown;
    }

    if (_transQualiTyUseHighCheckBtn.state) {
        _iPod.transCodingConfig.quality = CvtMediaQuality_HighQuality;
    }else if (_transQuliTyUseNormalCheckBtn.state){
        _iPod.transCodingConfig.quality = CvtMediaQuality_LowQuality;
    }
    
    if (_livePhotoOneBtn.state) {
        _iPod.exportSetting.livePhotoType = @"photo";
    }else if (_livePhotoTwoBtn.state){
        _iPod.exportSetting.livePhotoType = @"mov";
    }else if (_livePhotoThreeBtn.state){
        _iPod.exportSetting.livePhotoType = @"gif";
    }
    _iPod.exportSetting.isCreadPhotoDate = _exportOptionCheckBtn.state;
    [_iPod.appConfig saveToDevice];
    [_iPod.transCodingConfig saveToDevice];
    [_iPod.exportSetting saveToDeviceOrLocal];
    [self.window close];
}

- (IBAction)photoDate:(id)sender {
//    _exportOptionCheckBtn.state = !_exportOptionCheckBtn.state;
//    [_exportOptionCheckBtn ]
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

- (void)closeWindow:(id)sender {
    [self.window close];
}
@end

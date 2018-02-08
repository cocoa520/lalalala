//
//  IMBPreferencesSettingWindowController.h
//  AnyTrans
//
//  Created by long on 16-8-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBPreferencesButton.h"
#import "IMBCheckBtn.h"
#import "IMBWhiteView.h"
#import "IMBiPod.h"
#import "IMBRingtoneConfig.h"
#import "IMBCvtMediaFileEntity.h"
#import "IMBConfig.h"
#import "IMBGeneralButton.h"
#import "IMBExportSetting.h"
@interface IMBPreferencesSettingWindowController : NSWindowController
{
    IBOutlet NSImageView *_iconImageView7;
    IBOutlet NSImageView *_iconImageView6;
    IBOutlet NSImageView *_iconImageView5;
    IBOutlet NSImageView *_iconImageView4;
    IBOutlet NSImageView *_iconImageView3;
    IBOutlet NSImageView *_iconImageView1;
    IBOutlet NSTextField *_topTitleSter;
    IBOutlet IMBPreferencesButton *_generalBtn;
    IBOutlet IMBPreferencesButton *_trancodingViewBtn;
    IBOutlet IMBWhiteView *_generalView;
    IBOutlet NSScrollView *_scrollView;

    IBOutlet NSTextField *_applicationStr;
    IBOutlet NSTextField *iTuneslibrayStr;
    IBOutlet NSTextField *_onlyAppstr;
    IBOutlet NSTextField *_appppAndDataStr;
    IBOutlet IMBCheckBtn *_toiTunesCheckBtn;
    IBOutlet IMBCheckBtn *_toiTunesMuliCheckBtn;
    
    IBOutlet NSTextField *_appOnMacStr;
    IBOutlet NSTextField *_appOnMacOnlyAppStr;
    IBOutlet NSTextField *_appOnMacPAndDataStr;
    IBOutlet IMBCheckBtn *_onMacOnlyAppCheckBtn;
    IBOutlet IMBCheckBtn *_onmacProAndDataCheckBtn;
 
    IBOutlet NSTextField *_onDeviceTitleStr;
    IBOutlet NSTextField *_onDeviceOnlyAppProStr;
    IBOutlet NSTextField *_onDeviceOnlyAppDataStr;
    IBOutlet NSTextField *_onDeviceProAndDataStr;
    IBOutlet IMBCheckBtn *_onDeviceOnlyAppProCheckBtn;
    IBOutlet IMBCheckBtn *_onDeviceOnlyAppDataCheckBtn;
    IBOutlet IMBCheckBtn *_onDeviceProAndDataCheckBtn;

    IBOutlet NSTextField *_autoImportAppStr;
    IBOutlet NSTextField *_autoUpGradeAppStr;
    IBOutlet NSTextField *_autoDowngradeAppStr;
    IBOutlet NSTextField *_appSettingEndStr;
    IBOutlet IMBCheckBtn *_aotoImportAppCheckBtn;
    IBOutlet IMBCheckBtn *_aotoUpgradeCheckBtn;
    IBOutlet IMBCheckBtn *_aotoDownGradeAppCheckBtn;
    
    IBOutlet IMBWhiteView *_oneLineView;
    
    IBOutlet IMBWhiteView *_transCodingView;
    
    IBOutlet NSTextField *_videoFormatTitleStr;
    IBOutlet NSTextField *_videoMPEGStr;
    IBOutlet NSTextField *_videoH264Str;
    IBOutlet NSTextField *_videoDontWantStr;
    IBOutlet IMBCheckBtn *_videoMPEGCheckBtn;
    IBOutlet IMBCheckBtn *_videoH264CheckBtn;
    IBOutlet IMBCheckBtn *_videoDontWantCheckBtn;
    
    IBOutlet NSTextField *_audioTitleStr;
    IBOutlet NSTextField *_audioAACStr;
    IBOutlet NSTextField *_audioMP3Str;
    IBOutlet NSTextField *_audioDontWantStr;
    IBOutlet IMBCheckBtn *_audioAACCheckBtn;
    IBOutlet IMBCheckBtn *_audioMP3CheckBtn;
    IBOutlet IMBCheckBtn *_audioDontWantCheckBtn;
    
    IBOutlet NSTextField *_transQualiTyTitleStr;
    IBOutlet NSTextField *_transQualiTyUseHighStr;
    IBOutlet NSTextField *_transQuliTyUseNormalStr;
    IBOutlet IMBCheckBtn *_transQualiTyUseHighCheckBtn;
    IBOutlet IMBCheckBtn *_transQuliTyUseNormalCheckBtn;
    
    IBOutlet NSTextField *_exportOptionTitle;
    IBOutlet IMBCheckBtn *_exportOptionCheckBtn;
    IBOutlet NSTextField *_exportOptionStr;
    IBOutlet IMBWhiteView *_bottomlineView;

    IBOutlet NSTextField *_livePhotoTitle;
    IBOutlet NSTextField *_livePhotoOneTitle;
    IBOutlet NSTextField *_livePhotoTwoTitle;
    IBOutlet NSTextField *_livePhotoThreeTitle;
    IBOutlet IMBCheckBtn *_livePhotoOneBtn;
    IBOutlet IMBCheckBtn *_livePhotoTwoBtn;
    IBOutlet IMBCheckBtn *_livePhotoThreeBtn;
    IBOutlet IMBGeneralButton *_canCelBtn;
    IBOutlet IMBGeneralButton *_saveBtn;
    IMBiPod *_iPod;
    IBOutlet NSView *_midlleView;
    IBOutlet IMBWhiteView *_mainView;
}
-(id)initWithIpod:(IMBiPod *)ipod;
@end

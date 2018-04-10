//
//  IMBChooseBrowserWindowController.m
//  PhoneClean
//
//  Created by iMobie023 on 15-7-24.
//  Copyright (c) 2015年 imobie.com. All rights reserved.
//

#import "IMBChooseBrowserWindowController.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftWareInfo.h"
#import "IMBLogManager.h"
#import "IMBCommonEnum.h"
#import "StringHelper.h"
#import "HoverButton.h"
#import "IMBToolbarWindow.h"
#import "IMBSocketClient.h"
#import "IMBHelper.h"
#import "TempHelper.h"
#import "ATTracker.h"
#import "NSString+Category.h"

@implementation IMBChooseBrowserWindowController
@synthesize isDisCountBuy = _isDisCountBuy;
@synthesize installBrowsers = _installBrowsers;
@synthesize isActive = _isActive;
@synthesize isNeedAnalytics = _isNeedAnalytics;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(id)init{
    if ([super initWithWindowNibName:@"IMBChooseBrowserWindowController"]) {
        
    }
    return self;
}

- (id)initWithWindowNibName:(NSString *)windowNibName withIsNeedAnalytics:(BOOL)isNeed {
    if ([super initWithWindowNibName:windowNibName]) {
        _isNeedAnalytics = isNeed;
        return self;
    }else {
        return nil;
    }
}

- (void)dealloc
{
    if (_installBrowsers) {
        [_installBrowsers release];
        _installBrowsers = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_BROWSER object:nil];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

}

-(void)awakeFromNib{
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    
    [self.window center];
    [self.window setTitle:[[IMBSoftWareInfo singleton] getProductTitle]];
    
    [_saveBtn setButtonTitle: CustomLocalizedString(@"Annoy_Go_Btn", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withTitleSize:14 WithLightAnimation:NO];
    [_saveBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)]];
    [_saveBtn setButtonBorder:YES withNormalBorderColor:[StringHelper getColorFromString:CustomColor(@"general_border_color", nil)] withEnterBorderColor:[StringHelper getColorFromString:CustomColor(@"general_border_color", nil)] withDownBorderColor:[StringHelper getColorFromString:CustomColor(@"general_border_color", nil)] withForbiddenBorderColor:[StringHelper getColorFromString:CustomColor(@"general_border_color", nil)] withBorderLineWidth:1.0];
    [_saveBtn setTarget:self];
    [_saveBtn setAction:@selector(defaultSettings:)];
    [_saveBtn setNeedsDisplay:YES];
    [optTextField setStringValue:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Title", nil)];
    [optTextField setFont:[NSFont fontWithName:@"Helvetica Neue" size:18]];
    [optTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_googleView setImage:[StringHelper imageNamed:@"active_chorme"] withTitle:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Google", nil)];
    [_safariView setImage:[StringHelper imageNamed:@"active_safari"] withTitle:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Safari", nil)];
    [_firfoxView setImage:[StringHelper imageNamed:@"active_firefox"] withTitle:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Firfox", nil)];
    [_operaView setImage:[StringHelper imageNamed:@"active_opera"] withTitle:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Opera", nil)];
    [_googleView setTag:1];
    [_googleView setTarget:self];
    [_googleView setAction:@selector(changeBrowser:)];
    [_safariView setTag:2];
    [_safariView setTarget:self];
    [_safariView setAction:@selector(changeBrowser:)];
    [_firfoxView setTag:3];
    [_firfoxView setTarget:self];
    [_firfoxView setAction:@selector(changeBrowser:)];
    [_operaView setTag:4];
    [_operaView setTarget:self];
    [_operaView setAction:@selector(changeBrowser:)];
    

    //默认浏览器为Google
    [_safariView setIsSelected:YES];
    [_safariView setNeedsDisplay:YES]; 
}

- (void)changeBrowser:(id)sender {
    IMBChooseBrowserView *view = (IMBChooseBrowserView *)sender;
    if (view.tag == 1) {
        [_googleView setIsSelected:YES];
        [_safariView setIsSelected:NO];
        [_firfoxView setIsSelected:NO];
        [_operaView setIsSelected:NO];
    }else if (view.tag == 2) {
        [_googleView setIsSelected:NO];
        [_safariView setIsSelected:YES];
        [_firfoxView setIsSelected:NO];
        [_operaView setIsSelected:NO];
    }else if (view.tag == 3) {
        [_googleView setIsSelected:NO];
        [_safariView setIsSelected:NO];
        [_firfoxView setIsSelected:YES];
        [_operaView setIsSelected:NO];
    }else if (view.tag == 4) {
        [_googleView setIsSelected:NO];
        [_safariView setIsSelected:NO];
        [_firfoxView setIsSelected:NO];
        [_operaView setIsSelected:YES];
    }
    [_googleView setNeedsDisplay:YES];
    [_safariView setNeedsDisplay:YES];
    [_firfoxView setNeedsDisplay:YES];
    [_operaView setNeedsDisplay:YES];
}


- (IBAction)defaultSettings:(id)sender {
    NSString *identifer = nil;
    NSString *browserName = nil;
    if (_googleView.isSelected) {
        identifer = @"com.google.Chrome";
        browserName = @"Google Chrome";
    }else if (_safariView.isSelected) {
        identifer = @"com.apple.Safari";
        browserName = @"Safari";
    }else if (_firfoxView.isSelected) {
        identifer = @"org.mozilla.firefox";
        browserName = @"Firefox";
    }else if (_operaView.isSelected) {
        identifer = @"com.operasoftware.Opera";
        browserName = @"Opera Browser";
    }
    
    NSURL *url = nil;
     IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    
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
    if (_isDisCountBuy) {
        url = [NSURL URLWithString:[NSString stringWithFormat:CustomLocalizedString(@"discount_Buy_Url", nil),ver]];
    }else {
        if (_isActive) {
            url = [NSURL URLWithString:[NSString stringWithFormat:str, ver, 0]];
        }else {
            url = [NSURL URLWithString:[NSString stringWithFormat:str, ver, softWare.buyId]];
        }
    }

    NSArray *ary = @[url];
    BOOL success =  [[NSWorkspace sharedWorkspace] openURLs: ary withAppBundleIdentifier:identifer
                        options: NSWorkspaceLaunchDefault additionalEventParamDescriptor: NULL launchIdentifiers: NULL];
    // 如果打开失败，就用默认浏览器打开网页
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (!success) {
        [[NSWorkspace sharedWorkspace] openURL:url];
        if (_isNeedAnalytics) {
            [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:@"default" label:ChooseBrowser transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }

    }else {
        if (_isNeedAnalytics) {
            [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:browserName label:ChooseBrowser transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [self.window close];
}

- (void)setInstallBrowsers:(NSMutableArray *)installBrowsers {
    if (_installBrowsers) {
        [_installBrowsers release];
        _installBrowsers = nil;
    }
    [_googleView setHidden:YES];
    [_safariView setHidden:YES];
    [_firfoxView setHidden:YES];
    [_operaView setHidden:YES];
    
    _installBrowsers = [installBrowsers retain];
    if (_installBrowsers.count == 4) {
        [_googleView setFrameOrigin:NSMakePoint(43, 98)];
        [_safariView setFrameOrigin:NSMakePoint(167, 98)];
        [_firfoxView setFrameOrigin:NSMakePoint(291, 98)];
        [_operaView setFrameOrigin:NSMakePoint(415, 98)];
        [_googleView setHidden:NO];
        [_safariView setHidden:NO];
        [_firfoxView setHidden:NO];
        [_operaView setHidden:NO];
        [_safariView setIsSelected:YES];
        [_safariView setNeedsDisplay:YES];
    }else if (_installBrowsers.count == 3) {
        int count = 0;
        if ([_installBrowsers containsObject:@"google"]) {
            [_googleView setFrameOrigin:NSMakePoint(43 + 31, 98)];
            [_googleView setHidden:NO];
            count ++;
        }
        if ([_installBrowsers containsObject:@"safari"]) {
            [_safariView setFrameOrigin:NSMakePoint(43 + 31 + count * 124, 98)];
            [_safariView setHidden:NO];
            count ++;
            
        }
        if ([_installBrowsers containsObject:@"firefox"]) {
            [_firfoxView setFrameOrigin:NSMakePoint(43 + 31 + count * 124, 98)];
            [_firfoxView setHidden:NO];
            count ++;
        }
        if ([_installBrowsers containsObject:@"opera"]) {
            [_operaView setFrameOrigin:NSMakePoint(43 + 31 + count * 124, 98)];
            [_operaView setHidden:NO];
            count ++;
        }
    }else if (_installBrowsers.count == 2) {
        int count = 0;
        if ([_installBrowsers containsObject:@"google"]) {
            [_googleView setFrameOrigin:NSMakePoint(43 + 124, 98)];
            [_googleView setHidden:NO];
            count ++;
        }
        if ([_installBrowsers containsObject:@"safari"]) {
            [_safariView setFrameOrigin:NSMakePoint(43 + 124 + count * 124, 98)];
            [_safariView setHidden:NO];
            count ++;
            
        }
        if ([_installBrowsers containsObject:@"firefox"]) {
            [_firfoxView setFrameOrigin:NSMakePoint(43 + 124 + count * 124, 98)];
            [_firfoxView setHidden:NO];
            count ++;
        }
        if ([_installBrowsers containsObject:@"opera"]) {
            [_operaView setFrameOrigin:NSMakePoint(43 + 124 + count * 124, 98)];
            [_operaView setHidden:NO];
            count ++;
        }
    }
    
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

- (void)closeWindow:(id)sender {
    [self.window close];
}

@end

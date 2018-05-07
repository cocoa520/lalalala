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
#import "OperationLImitation.h"

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
    [conView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [self.window setTitle:[[IMBSoftWareInfo singleton] getProductTitle]];
    [optTextField setStringValue:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Title", nil)];
    [optTextField setFont:[NSFont fontWithName:@"Helvetica Neue" size:16]];
    [optTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_safariView setImage:[StringHelper imageNamed:@"active_safari"] withTitle:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Safari", nil)];
    [_googleView setImage:[StringHelper imageNamed:@"active_chorme"] withTitle:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Google", nil)];
    [_firfoxView setImage:[StringHelper imageNamed:@"active_firefox"] withTitle:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Firfox", nil)];
    [_operaView setImage:[StringHelper imageNamed:@"active_opera"] withTitle:CustomLocalizedString(@"Annoy_Activate_ChooseBrowser_Opera", nil)];
    
    [_safariView setIsSelected:NO];
    [_safariView setTag:1];
    [_safariView setTarget:self];
    [_safariView setAction:@selector(changeBrowser:)];
    
    [_googleView setIsSelected:NO];
    [_googleView setTag:2];
    [_googleView setTarget:self];
    [_googleView setAction:@selector(changeBrowser:)];
    
    [_firfoxView setIsSelected:NO];
    [_firfoxView setTag:3];
    [_firfoxView setTarget:self];
    [_firfoxView setAction:@selector(changeBrowser:)];
    
    [_operaView setIsSelected:NO];
    [_operaView setTag:4];
    [_operaView setTarget:self];
    [_operaView setAction:@selector(changeBrowser:)];
}

- (void)changeBrowser:(id)sender {
    IMBChooseBrowserView *view = (IMBChooseBrowserView *)sender;
    NSString *identifer = nil;
    NSString *browserName = nil;
    if (view.tag == 1) {
        identifer = @"com.apple.Safari";
        browserName = @"Safari";
    }else if (view.tag == 2) {
        identifer = @"com.google.Chrome";
        browserName = @"Google Chrome";
    }else if (view.tag == 3) {
        identifer = @"org.mozilla.firefox";
        browserName = @"Firefox";
    }else if (view.tag == 4) {
        identifer = @"com.operasoftware.Opera";
        browserName = @"Opera Browser";
    }
    
    NSURL *url = nil;
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    
    NSString *str = CustomLocalizedString(@"Buy_Url", nil);
    NSString *ver = softWare.trackTestVersionID;
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
        url = [NSURL URLWithString:[NSString stringWithFormat:CustomLocalizedString(@"discount_Buy_Url", nil),ver, softWare.buyId]];
    }else {
        NSString *annoyType = @"e";
        NSString *limitStatus = [[OperationLImitation singleton] limitStatus];
        if ([limitStatus isEqualToString:@"completed"]) {
            annoyType = @"a";
        }else if ([limitStatus isEqualToString:@"noquote"]) {
            annoyType = @"b";
        }else if ([limitStatus isEqualToString:@"notactivate"]) {
            annoyType = @"c";
        }
        if (_isActive) {
            url = [NSURL URLWithString:[NSString stringWithFormat:str, ver, 0, annoyType]];
        }else {
            url = [NSURL URLWithString:[NSString stringWithFormat:str, ver, softWare.buyId, annoyType]];
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
        [_safariView setFrameOrigin:NSMakePoint(43, 80)];
        [_googleView setFrameOrigin:NSMakePoint(167, 80)];
        [_firfoxView setFrameOrigin:NSMakePoint(291, 80)];
        [_operaView setFrameOrigin:NSMakePoint(415, 80)];
        [_googleView setHidden:NO];
        [_safariView setHidden:NO];
        [_firfoxView setHidden:NO];
        [_operaView setHidden:NO];
        [_safariView setNeedsDisplay:YES];
    }else if (_installBrowsers.count == 3) {
        int count = 0;
        if ([_installBrowsers containsObject:@"safari"]) {
            [_safariView setFrameOrigin:NSMakePoint(73 + 31, 80)];
            [_safariView setHidden:NO];
            count ++;
        }
        if ([_installBrowsers containsObject:@"chrome"]) {
            [_googleView setFrameOrigin:NSMakePoint(73 + 31 + count * 124, 80)];
            [_googleView setHidden:NO];
            count ++;
            
        }
        if ([_installBrowsers containsObject:@"firefox"]) {
            [_firfoxView setFrameOrigin:NSMakePoint(73 + 31 + count * 124, 80)];
            [_firfoxView setHidden:NO];
            count ++;
        }
        if ([_installBrowsers containsObject:@"opera"]) {
            [_operaView setFrameOrigin:NSMakePoint(73 + 31 + count * 124, 80)];
            [_operaView setHidden:NO];
            count ++;
        }
    }else if (_installBrowsers.count == 2) {
        int count = 0;
        if ([_installBrowsers containsObject:@"safari"]) {
            [_safariView setFrameOrigin:NSMakePoint(43 + 124, 80)];
            [_safariView setHidden:NO];
            count ++;
        }
        if ([_installBrowsers containsObject:@"chrome"]) {
            [_googleView setFrameOrigin:NSMakePoint(43 + 124 + count * 124, 80)];
            [_googleView setHidden:NO];
            count ++;
            
        }
        if ([_installBrowsers containsObject:@"firefox"]) {
            [_firfoxView setFrameOrigin:NSMakePoint(43 + 124 + count * 124, 80)];
            [_firfoxView setHidden:NO];
            count ++;
        }
        if ([_installBrowsers containsObject:@"opera"]) {
            [_operaView setFrameOrigin:NSMakePoint(43 + 124 + count * 124, 80)];
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

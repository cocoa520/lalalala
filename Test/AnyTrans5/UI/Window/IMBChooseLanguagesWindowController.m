//
//  IMBChooseLanguagesWindowController.m
//  PhoneClean
//
//  Created by iMobie023 on 15-7-24.
//  Copyright (c) 2015年 imobie.com. All rights reserved.
//

#import "IMBChooseLanguagesWindowController.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftWareInfo.h"
#import "IMBLogManager.h"
#import "IMBCommonEnum.h"
#import "StringHelper.h"
#import "HoverButton.h"
#import "IMBToolbarWindow.h"
#import "IMBSocketClient.h"
#import "IMBHelper.h"

@implementation IMBChooseLanguagesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(id)init{
    if ([super initWithWindowNibName:@"IMBChooseLanguagesWindowController"]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_LANGUAGE object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_LANGUAGE object:nil];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

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
    
//    [[IMBLogManager singleton] writeInfoLog:@"get info IMBChooseLanguagesWindowController"];
    [self.window center];
    [self.window setTitle:[[IMBSoftWareInfo singleton] getProductTitle]];
    [conView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
//    NSMutableAttributedString *as = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"language_setting_id", nil)] autorelease];
//    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
//    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
//    [_saveBtn setAttributedTitle:as];
    NSString *okButtonString = CustomLocalizedString(@"language_setting_id", nil);
    [_saveBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_saveBtn setAttributedTitle:attributedTitles1];
    [_saveBtn setTarget:self];
    [_saveBtn setAction:@selector(defaultSettings:)];
    [_saveBtn setNeedsDisplay:YES];
    [optTextField setStringValue:CustomLocalizedString(@"LanguageSetWinodw_id_1", nil)];
    [optTextField setFont:[NSFont fontWithName:@"Helvetica Neue" size:18]];
    [optTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [enTextStr setStringValue:CustomLocalizedString(@"Language_id_1", nil)];
    [enTextStr setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [enTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [japTectStr setStringValue:CustomLocalizedString(@"Language_id_2", nil)];
    [japTectStr setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [japTectStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [genrmanTextStr setStringValue:CustomLocalizedString(@"Language_id_3", nil)];
    [genrmanTextStr setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [genrmanTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [frenchTextStr setStringValue:CustomLocalizedString(@"Language_id_4", nil)];
    [frenchTextStr setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [frenchTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //
    
    [spanishTextStr setStringValue:CustomLocalizedString(@"Language_id_7", nil)];
    [spanishTextStr setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [spanishTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
  
    [arabTextStr setStringValue:CustomLocalizedString(@"Language_id_8", nil)];
    [arabTextStr setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [arabTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [cheseTextStr setStringValue:CustomLocalizedString(@"Language_id_9", nil)];
    [cheseTextStr setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [cheseTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
 
    [_bgImageVIew setImage:[StringHelper imageNamed:@"bg"]];
    [enimageView setChangeEnteredImageAndDownImage:@"language_background" withCategory:@"English"];
    [japImageView setChangeEnteredImageAndDownImage:@"language_background" withCategory:@"Japanese"];
    [germanImageView setChangeEnteredImageAndDownImage:@"language_background" withCategory:@"German"];
    [frenchImageView setChangeEnteredImageAndDownImage:@"language_background" withCategory:@"French"];
    
    [spanishImageView setChangeEnteredImageAndDownImage:@"language_background" withCategory:@"Spanish"];
    
    [cheseImageView setChangeEnteredImageAndDownImage:@"language_background" withCategory:@"chese"];
    
    [arabImageView setChangeEnteredImageAndDownImage:@"language_background" withCategory:@"Arabic"];

    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
        _langStr = @"en";
        [enimageView setIsClicked:YES];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        _langStr = @"ja";
        [japImageView setIsClicked:YES];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        _langStr = @"de";
        [germanImageView setIsClicked:YES];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
        _langStr = @"fr";
        [frenchImageView setIsClicked:YES];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage)
    {
        _langStr = @"es";
        [spanishImageView setIsClicked:YES];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage)
    {
        _langStr = @"ar";
        [arabImageView setIsClicked:YES];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage)
    {
        _langStr = @"zh";
        [cheseImageView setIsClicked:YES];
    }else {
        _langStr = @"en";
        [enimageView setIsClicked:YES];
    }
}



- (void)doChangeLanguage:(NSNotification *)notification {
    [[IMBLogManager singleton] writeInfoLog:@"changeLanguage IMBChooseLanguagesWindowController start"];
    NSString *object = [notification object];
    //    _langStr = @"en";
    _isSave = NO;
    if ([object isEqualToString:@"English"]) {
        [enimageView setIsClicked:YES];
        [japImageView setIsClicked:NO];
        [germanImageView setIsClicked:NO];
        [frenchImageView setIsClicked:NO];
        [spanishImageView setIsClicked:NO];
        [arabImageView setIsClicked:NO];
        [cheseImageView setIsClicked:NO];
        if ([IMBSoftWareInfo singleton].chooseLanguageType != EnglishLanguage) {
            _isSave = YES;
            _langStr = @"en";
        }
    }else if ([object isEqualToString:@"Japanese"]) {
        [enimageView setIsClicked:NO];
        [japImageView setIsClicked:YES];
        [germanImageView setIsClicked:NO];
        [frenchImageView setIsClicked:NO];
        [spanishImageView setIsClicked:NO];
        [arabImageView setIsClicked:NO];
        [cheseImageView setIsClicked:NO];
        if ([IMBSoftWareInfo singleton].chooseLanguageType != JapaneseLanguage) {
            _isSave = YES;
            _langStr = @"ja";
        }
    }else if ([object isEqualToString:@"German"]) {
        [enimageView setIsClicked:NO];
        [japImageView setIsClicked:NO];
        [germanImageView setIsClicked:YES];
        [frenchImageView setIsClicked:NO];
        [spanishImageView setIsClicked:NO];
        [arabImageView setIsClicked:NO];
        [cheseImageView setIsClicked:NO];
        if ([IMBSoftWareInfo singleton].chooseLanguageType != GermanLanguage) {
            _isSave = YES;
            _langStr = @"de";
        }
    }else if ([object isEqualToString:@"French"]) {
        [enimageView setIsClicked:NO];
        [japImageView setIsClicked:NO];
        [germanImageView setIsClicked:NO];
        [frenchImageView setIsClicked:YES];
        [spanishImageView setIsClicked:NO];
        [arabImageView setIsClicked:NO];
        [cheseImageView setIsClicked:NO];
        if ([IMBSoftWareInfo singleton].chooseLanguageType != FrenchLanguage) {
            _isSave = YES;
            _langStr = @"fr";
        }
    }else if ([object isEqualToString:@"Spanish"]) {
        [enimageView setIsClicked:NO];
        [japImageView setIsClicked:NO];
        [germanImageView setIsClicked:NO];
        [frenchImageView setIsClicked:NO];
        [spanishImageView setIsClicked:YES];
        [arabImageView setIsClicked:NO];
        [cheseImageView setIsClicked:NO];
        if ([IMBSoftWareInfo singleton].chooseLanguageType != SpanishLanguage) {
            _isSave = YES;
            _langStr = @"es";
        }
    }else if ([object isEqualToString:@"Arabic"]) {
        [enimageView setIsClicked:NO];
        [japImageView setIsClicked:NO];
        [germanImageView setIsClicked:NO];
        [frenchImageView setIsClicked:NO];
        [spanishImageView setIsClicked:NO];
        [arabImageView setIsClicked:YES];
        [cheseImageView setIsClicked:NO];
        if ([IMBSoftWareInfo singleton].chooseLanguageType != ArabLanguage) {
            _isSave = YES;
            _langStr = @"ar";
        }
    }else if ([object isEqualToString:@"chese"]) {
        [enimageView setIsClicked:NO];
        [japImageView setIsClicked:NO];
        [germanImageView setIsClicked:NO];
        [frenchImageView setIsClicked:NO];
        [spanishImageView setIsClicked:NO];
        [arabImageView setIsClicked:NO];
        [cheseImageView setIsClicked:YES];
        if ([IMBSoftWareInfo singleton].chooseLanguageType != ChinaLanguage) {
            _isSave = YES;
            _langStr = @"zh";
        }
    }
}

- (IBAction)defaultSettings:(id)sender {
  
    if (_isSave) {
        if ([_langStr isEqualToString:@"en"]) {
            [[IMBSoftWareInfo singleton] setChooseLanguageType:EnglishLanguage];
        }else if ([_langStr isEqualToString:@"ja"]) {
            [[IMBSoftWareInfo singleton] setChooseLanguageType:JapaneseLanguage];
        }else if ([_langStr isEqualToString:@"de"]) {
            [[IMBSoftWareInfo singleton] setChooseLanguageType:GermanLanguage];
        }else if ([_langStr isEqualToString:@"fr"]) {
            [[IMBSoftWareInfo singleton] setChooseLanguageType:FrenchLanguage];
        }else if ([_langStr isEqualToString:@"es"]) {
            [[IMBSoftWareInfo singleton] setChooseLanguageType:SpanishLanguage];
        }else if ([_langStr isEqualToString:@"ar"]) {
            [[IMBSoftWareInfo singleton] setChooseLanguageType:ArabLanguage];
        }else if ([_langStr isEqualToString:@"zh"]) {
            [[IMBSoftWareInfo singleton] setChooseLanguageType:ChinaLanguage];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moveToApplicationsFolderAlertSuppress"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:_langStr, nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [optTextField setStringValue:CustomLocalizedString(@"LanguageSetWinodw_id_1", nil)];
        [optTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_ALLANGUAGE object:nil userInfo:nil];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"chooseLanguages:%@",_langStr ]];
        
        //向slientBackup发送当前的语言
        IMBSocketClient *socketClient = [IMBSocketClient singleton];
        NSString *chooseStr = [NSString stringWithFormat:@"ChooseLanguage_%@",_langStr];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:chooseStr, @"MsgType", nil];
        NSString *str = [IMBHelper dictionaryToJson:dic];
        [socketClient sendData:str];
    }
    [self.window close];
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

- (void)closeWindow:(id)sender {
    [self.window close];
}

@end

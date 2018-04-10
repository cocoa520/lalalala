//
//  IMBUpgradeWindowController.m
//  DataRecovery
//
//  Created by Pallas on 6/4/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBUpgradeWindowController.h"
#import "IMBCheckUpdater.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftwareInfo.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "HoverButton.h"
#import "IMBiCloudNoTitleBarWinodw.h"
#import "IMBCommonDefine.h"

@implementation IMBUpgradeWindowController

- (id)init {
    self = [super initWithWindowNibName:@"IMBUpgradeWindowController"];
    if (self) {
        softInfo = [IMBSoftWareInfo singleton];
        btnUpdateNow = nil;
    }
    return self;
}

- (id)initWithUpdateInfo:(IMBUpdateInfo*)info {
    self = [self init];
    if (self) {
        _updateInfo = [info retain];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    if (_updateInfo != nil) {
        [_updateInfo release];
        _updateInfo = nil;
    }
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void)awakeFromNib {
    
    [[(IMBiCloudNoTitleBarWinodw *)self.window maxButton] setHidden:YES];
    [[(IMBiCloudNoTitleBarWinodw *)self.window minButton] setHidden:YES];
    
    [self.window center];
    [self loadButton];
    [_UpdateTextView setBackgroundColor:COLOR_View_NORMAL];
    [updateBottom setBackgroundColor:COLOR_View_NORMAL];
    _middleView.isDrawFrame = YES;
    [_middleView setBorderColor:COLOR_TEXT_LINE];
    [_middleView setBackgroundColor:COLOR_View_NORMAL];
    [btnSkipUpdate setHidden:YES];
    [btnRemindLater setHidden:YES];
    [btnUpdateNow setHidden:YES];
    
    [logoIconImgView setImage:[StringHelper imageNamed:@"window_logo"]];
    
     NSString *currVersion = [NSString stringWithFormat:@"%@ %@.%@",CustomLocalizedString(@"List_Header_id_Version", nil),softInfo.version,softInfo.buildDate];
    [lbCurrVersion setStringValue:currVersion];
    [lbCurrVersion setTextColor:COLOR_TEXT_EXPLAIN];
    
    //窗口title
    NSString *promptStr = CustomLocalizedString(@"MainWindow_id_7", nil);
    NSMutableAttributedString *promptAs = [TempHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:30] withColor:COLOR_TEXT_ORDINARY];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_mainTitle setAttributedStringValue:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    if (_updateInfo) {
        [self updaterStatus:UpdaterStatus_HasUpdate UpdateInfo:_updateInfo];
    } else {
        NSString *string = CustomLocalizedString(@"UpdateWindow_id_9", nil);
        _UpdateTextView.string = string;
        [_UpdateTextView setTextColor:COLOR_TEXT_ORDINARY];
    }

}

- (void)loadButton {
    //忽略更新
    [btnSkipUpdate setIsNoGridient:YES];
    [btnSkipUpdate setNormalFillColor:COLOR_CANCELBTN_NORMAL WithEnterFillColor:COLOR_CANCELBTN_ENTER WithDownFillColor:COLOR_CANCELBTN_DOWN];
    [btnSkipUpdate setButtonTitle:CustomLocalizedString(@"Update_Window_Button1", nil) withNormalTitleColor:COLOR_TEXT_ORDINARY withEnterTitleColor:COLOR_TEXT_ORDINARY withDownTitleColor:COLOR_TEXT_ORDINARY withForbiddenTitleColor:COLOR_TEXT_ORDINARY withTitleSize:12.0 WithLightAnimation:NO];
    [btnSkipUpdate setButtonBorder:YES withNormalBorderColor:COLOR_BTNBORDER_NORMAL withEnterBorderColor:COLOR_BTNBORDER_ENTER withDownBorderColor:COLOR_BTNBORDER_DOWN withForbiddenBorderColor:COLOR_BTNBORDER_NORMAL withBorderLineWidth:1];
    [btnSkipUpdate setTarget:self];
    [btnSkipUpdate setAction:@selector(onSkipVersion:)];
    [btnSkipUpdate setNeedsDisplay:YES];
    
    //稍后提醒
    [btnRemindLater setIsNoGridient:YES];
    [btnRemindLater setNormalFillColor:COLOR_CANCELBTN_NORMAL WithEnterFillColor:COLOR_CANCELBTN_ENTER WithDownFillColor:COLOR_CANCELBTN_DOWN];
    [btnRemindLater setButtonTitle:CustomLocalizedString(@"Update_Window_Button2", nil) withNormalTitleColor:COLOR_TEXT_ORDINARY withEnterTitleColor:COLOR_TEXT_ORDINARY withDownTitleColor:COLOR_TEXT_ORDINARY withForbiddenTitleColor:COLOR_TEXT_ORDINARY withTitleSize:12.0 WithLightAnimation:NO];
    [btnRemindLater setButtonBorder:YES withNormalBorderColor:COLOR_BTNBORDER_NORMAL withEnterBorderColor:COLOR_BTNBORDER_ENTER withDownBorderColor:COLOR_BTNBORDER_DOWN withForbiddenBorderColor:COLOR_BTNBORDER_NORMAL withBorderLineWidth:1];
    [btnRemindLater setTarget:self];
    [btnRemindLater setAction:@selector(onRemindLater:)];
    [btnRemindLater setNeedsDisplay:YES];
    
    //更新
    [btnUpdateNow setIsNoGridient:YES];
    [btnUpdateNow setNormalFillColor:COLOR_OKBTN_NORMAL WithEnterFillColor:COLOR_OKBTN_ENTER WithDownFillColor:COLOR_OKBTN_DOWN];
    [btnUpdateNow setButtonTitle:CustomLocalizedString(@"Update_Window_Button3", nil) withNormalTitleColor:COLOR_View_NORMAL withEnterTitleColor:COLOR_View_NORMAL withDownTitleColor:COLOR_View_NORMAL withForbiddenTitleColor:COLOR_View_NORMAL withTitleSize:12.0 WithLightAnimation:NO];
    [btnUpdateNow setTarget:self];
    [btnUpdateNow setAction:@selector(onUpdateNow:)];
    [btnUpdateNow setNeedsDisplay:YES];
    
    NSRect updateRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button3", nil) fontSize:12];
    [btnUpdateNow setFrame:NSMakeRect(ceilf(updateBottom.frame.size.width - 28 - updateRect.size.width - 30), ceilf(btnUpdateNow.frame.origin.y), ceilf(updateRect.size.width +30), btnUpdateNow.frame.size.height)];
    
    NSRect remindRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button2", nil) fontSize:12];
    [btnRemindLater setFrame:NSMakeRect(ceilf(btnUpdateNow.frame.origin.x - 30 - remindRect.size.width - 10), ceilf(btnUpdateNow.frame.origin.y), ceilf(remindRect.size.width +30), btnRemindLater.frame.size.height)];
    
    NSRect update = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button1", nil) fontSize:12];
    [btnSkipUpdate setFrame:NSMakeRect(ceilf(btnRemindLater.frame.origin.x - 10 - update.size.width - 30), ceilf(btnUpdateNow.frame.origin.y), ceilf(update.size.width +30) , btnSkipUpdate.frame.size.height)];
    
}

- (void)resetPosition:(IMBUpdateInfo *)updateInfo withStatus:(UpdaterStatus)status {
    if (status == UpdaterStatus_NetworkError || status == UpdaterStatus_GetFileError || status == UpdaterStatus_UnknownError) {
        
    } else {
        if (status == UpdaterStatus_HasUpdate) {
            if (updateInfo.isMustUpdate) {
                [btnSkipUpdate setHidden:YES];
                [btnRemindLater setHidden:YES];
                [btnUpdateNow setHidden:NO];
                
            } else {
                [btnSkipUpdate setHidden:NO];
                [btnRemindLater setHidden:NO];
                [btnUpdateNow setHidden:NO];
            }
        } else {
            // Todo 无更新的情况
        }
    }
}

- (NSMutableAttributedString*)getAttrString:(NSString*)content withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withColor:(NSColor*)color {
    NSMutableAttributedString *attrStr = [[[NSMutableAttributedString alloc] initWithString:content] autorelease];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:lineSpacing];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName, font, NSFontAttributeName, color,NSForegroundColorAttributeName, [NSColor clearColor], NSBackgroundColorAttributeName, nil];
    [attrStr addAttributes:fontDic range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}

- (void)updaterStatus:(UpdaterStatus)status UpdateInfo:(IMBUpdateInfo *)info {
    _updateInfo = [info retain];
    [self resetPosition:info withStatus:status];
    switch (status) {
        case UpdaterStatus_HasUpdate: {
            NSMutableAttributedString *mutAttrStr = [[NSMutableAttributedString alloc] init];
            
            NSString *productDescrible = [[NSString stringWithFormat:CustomLocalizedString(@"Update_Window_Text2", nil), softInfo.productName] stringByAppendingString:@"\n"];
            

            NSFont *bordLucida = [NSFont fontWithName:@"Helvetica Neue" size:14.0];

            NSMutableAttributedString *str1 = [self getAttrString:productDescrible withFont:bordLucida withLineSpacing:10 withColor:COLOR_TEXT_ORDINARY];
            [mutAttrStr appendAttributedString:str1];
            
            NSString *newVerDescrible = [[NSString stringWithFormat: CustomLocalizedString(@"Update_Window_Text3", nil), info.version, info.buildDate] stringByAppendingString:@"\n"];
            NSMutableAttributedString *str2 = [self getAttrString:newVerDescrible withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:10 withColor:COLOR_TEXT_ORDINARY];
            [mutAttrStr appendAttributedString:str2];
            
            NSArray *langArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *firstLang = @"en";
            if (langArray != nil && langArray.count > 0) {
                if ([langArray objectAtIndex:0] != nil ) {
                    firstLang = [langArray objectAtIndex:0];
                }
            }
            
            if (info.updateLogArray) {
                NSArray *listArray = [info.updateLogArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"language == %@", firstLang]];
                
                if (listArray.count > 0) {
                    IMBUpdateLogDetail *detail =  [listArray objectAtIndex:0];
                    for (NSString* str in detail.updateLogs) {
                        NSMutableAttributedString *tmpStr = [self getAttrString:[NSString stringWithFormat:@"%@\n", str] withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:8 withColor:COLOR_TEXT_ORDINARY];
                        [mutAttrStr appendAttributedString:tmpStr];
                    }
                } else {
                    IMBUpdateLogDetail *detail =  [info.updateLogArray objectAtIndex:0];
                    for (NSString* str in detail.updateLogs) {
                        NSMutableAttributedString *tmpStr = [self getAttrString:[NSString stringWithFormat:@"%@\n", str] withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:8 withColor:COLOR_TEXT_ORDINARY];
                        [mutAttrStr appendAttributedString:tmpStr];
                    }
                }
            }
            [mutAttrStr setAlignment:NSLeftTextAlignment range:NSMakeRange(0, mutAttrStr.length)];
            [_UpdateTextView.textStorage setAttributedString:mutAttrStr];
            break;
        }
        case UpdaterStatus_UpToDate: {
            NSString *string = [NSString stringWithFormat:CustomLocalizedString(@"Update_Window_Text1", nil),softInfo.productName];
            NSMutableAttributedString *attrStr = [self getAttrString:string withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:8 withColor:COLOR_TEXT_ORDINARY];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                [attrStr setAlignment:NSRightTextAlignment range:NSMakeRange(0, attrStr.length)];
            }
            [_UpdateTextView.textStorage setAttributedString:attrStr];
            break;
        }
        default: {
            NSString *string = [NSString stringWithFormat:CustomLocalizedString(@"UpdateWindow_id_10", nil),softInfo.productName];
            NSMutableAttributedString *attrStr = [self getAttrString:string withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:8 withColor:COLOR_TEXT_ORDINARY];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                [attrStr setAlignment:NSRightTextAlignment range:NSMakeRange(0, string.length)];
            }
            [_UpdateTextView.textStorage setAttributedString:attrStr];
            [btnSkipUpdate setHidden:NO];
            [btnRemindLater setHidden:NO];
            [btnUpdateNow setHidden:NO];
            break;
        }
    }
}

- (void)onSkipVersion:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:_updateInfo.version forKey:@"skip_version"];
    [[NSUserDefaults standardUserDefaults] setValue:_updateInfo.buildDate forKey:@"skip_build_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.window close];
}

- (void)onRemindLater:(id)sender {
    [self.window close];
}

- (void)onUpdateNow:(id)sender {
    NSString *url = CustomLocalizedString(@"Download_Url", nil);
    if (_updateInfo) {
        NSArray *langArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *firstLang = @"en";
        if (langArray != nil && langArray.count > 0) {
            if ([langArray objectAtIndex:0] != nil ) {
                firstLang = [langArray objectAtIndex:0];
            }
        }
        
        if (_updateInfo.updateLogArray) {
            NSArray *listArray = [_updateInfo.updateLogArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"language == %@", firstLang]];
            
            if (listArray.count > 0) {
                IMBUpdateLogDetail *detail =  [listArray objectAtIndex:0];
                url = detail.updateUrl;
            } else {
                IMBUpdateLogDetail *detail =  [_updateInfo.updateLogArray objectAtIndex:0];
                url = detail.updateUrl;
            }
        }
    }
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:[NSURL URLWithString:url]];
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

- (void)deviceDisconnected:(NSNotification *)notification {
    [self.window close];
}

- (void)closeWindow:(id)sender {
    [self.window close];
}

@end

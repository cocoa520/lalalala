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
#import "IMBToolbarWindow.h"
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
    
//    if (btnUpdateNow != nil) {
//        [btnUpdateNow release];
//        btnUpdateNow = nil;
//    }
//    if (btnSkipUpdate != nil) {
//        [btnSkipUpdate release];
//        btnSkipUpdate = nil;
//    }
//    if (btnRemindLater != nil) {
//        [btnRemindLater release];
//        btnRemindLater = nil;
//    }
//    if (btnUpdateNow != nil) {
//        [btnUpdateNow release];
//        btnUpdateNow = nil;
//    }
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)awakeFromNib {
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
    [self.window center];
    
    [_UpdateTextView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [updateBottom setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    _middleView.isDrawFrame = YES;
    [_middleView setBorderColor:[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)]];
    [_middleView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [btnSkipUpdate setHidden:YES];
    [btnRemindLater setHidden:YES];
    [btnUpdateNow setHidden:YES];
//    [self setShouldCascadeWindows:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconnected:) name:DeviceDisConnectedNotification object:nil];
    NSImage *topBgImg = [StringHelper imageNamed:@"upgrade_background"];
    if (topBgImg != nil) {
        [topBgImgView setImage:topBgImg];
    }
    
    //判断PodTransPro、PhoneTransPro、PodTrans、PhoneTrans、AnyTrans

        NSImage *logoIconImg = [StringHelper imageNamed:@"start_icon"];//名为phone_upgrade_icon.png
        if (logoIconImg != nil) {
            [logoIconImgView setImage:logoIconImg];
        }
        NSRect phoneTransRect = [logoTextImgView frame];
        [logoTextImgView setFrame:NSMakeRect(NSMinX(phoneTransRect), NSMinY(phoneTransRect), 230, 30)];
        NSImage *logoTextImg = [StringHelper imageNamed:@"upgrade_phonetrans_pro"];//phone_anytrans_upgrade.png
        if (logoTextImg != nil) {
            [logoTextImgView setImage:logoTextImg];
        }

     NSString *currVersion = [NSString stringWithFormat:@"%@ %@.%@",CustomLocalizedString(@"Version_id", nil),softInfo.version,softInfo.buildDate];
    [lbCurrVersion setStringValue:currVersion];
    [lbCurrVersion setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    //关于窗口title
    NSString *promptStr = CustomLocalizedString(@"Menu_Product", nil);
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_mainTitle setAttributedStringValue:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    
    if (_updateInfo) {
        [installBtn setHidden:NO];
        [settingBtn setHidden:NO];
        [settingBtn1 setHidden:NO];
        [self updaterStatus:UpdaterStatus_HasUpdate UpdateInfo:_updateInfo];
    } else {
        NSString *string = CustomLocalizedString(@"UpdateWindow_id_9", nil);
        _UpdateTextView.string = string;
        [_UpdateTextView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    }

}

-(void)loadButton{
//    //skip this version， button
//    NSString *settingTitle = CustomLocalizedString(@"UpdateWindow_id_1", nil);
//    NSRect btnRect = NSMakeRect(20, 20, ceil(setRect.size.width+40), 24);
//    settingBtn = [[NSButton alloc] initWithFrame:btnRect];
//    [settingBtn setTitle:settingTitle];
//    [settingBtn setBezelStyle:NSRoundedBezelStyle];
//    [settingBtn setTarget:self];
//    [settingBtn setAction:@selector(skipThisver)];
////    NSMutableAttributedString *attributedTitles = [[NSMutableAttributedString alloc]initWithString:settingTitle];
////    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, settingTitle.length)];
////    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor] range:NSMakeRange(0, settingTitle.length)];
////    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, settingTitle.length)];
////    [settingBtn setAttributedTitle:attributedTitles];
////    [attributedTitles release];
//    [updateBottom addSubview:settingBtn];
//    
//    NSString *installStr = CustomLocalizedString(@"UpdateWindow_id_3", nil);
//    NSRect rect3 = [IMBHelper calcuTextBounds:installStr fontSize:12];
//    NSRect installRect = NSMakeRect(updateBottom.frame.size.width - 20 - rect3.size.width-40, 20, ceil(rect3.size.width+40), 24);
//    installBtn = [[NSButton alloc] initWithFrame:installRect];
//    [installBtn setTitle:installStr];
//    [installBtn setBezelStyle:NSRoundedBezelStyle];
//    [installBtn setTarget:self];
//    [installBtn setAction:@selector(updateNow)];
//    [updateBottom addSubview:installBtn];
//    
//    NSString *remindBtn = CustomLocalizedString(@"UpdateWindow_id_2", nil);
//    NSRect setRect1 = [IMBHelper calcuTextBounds:remindBtn fontSize:12];
//    NSRect btnRect1 = NSMakeRect(ceil(installBtn.frame.origin.x - setRect1.size.width-40 -10) , 20, ceil(setRect1.size.width+40) , 24);
//    settingBtn1 = [[NSButton alloc] initWithFrame:btnRect1];
//    [settingBtn1 setTitle:remindBtn];
//    [settingBtn1 setBezelStyle:NSRoundedBezelStyle];
//    [settingBtn1 setTarget:self];
//    [settingBtn1 setAction:@selector(remindMeLater)];
//    [updateBottom addSubview:settingBtn1];
//    [installBtn setHidden:YES];
//    [settingBtn setHidden:YES];
//    [settingBtn1 setHidden:YES];
}


- (void)resetPosition:(IMBUpdateInfo *)updateInfo withStatus:(UpdaterStatus)status {
    if (status == UpdaterStatus_NetworkError || status == UpdaterStatus_GetFileError || status == UpdaterStatus_UnknownError) {
        
    } else {
        NSPoint orgPos;
        float totalBtnWidth = 0;
        NSSize skipBtnSize;
        NSSize remindBtnSize;
        NSSize updateBtnSize;
//        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14];
//        NSColor *color = [NSColor blackColor];
//        int maxWidth = 400; //floor((self.window.frame.size.width - 24) / 3);
//        NSMutableAttributedString *skipBtnTitle = [StringHelper measureForStringDrawing:CustomLocalizedString(@"Update_Window_Button1", nil) withFont:font withLineSpacing:0 withMaxWidth:maxWidth withSize:&skipBtnSize withColor:color];
       NSRect skipBtnRect = [TempHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button1", nil) fontSize:12];
        skipBtnSize = skipBtnRect.size;
        skipBtnSize.width += 32;
        NSRect skipBtnRect2 = [TempHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button2", nil) fontSize:12];
//        NSMutableAttributedString *remindBtnTitle = [StringHelper measureForStringDrawing:CustomLocalizedString(@"Update_Window_Button2", nil) withFont:font withLineSpacing:0 withMaxWidth:maxWidth withSize:&remindBtnSize withColor:color];
        remindBtnSize = skipBtnRect2.size;
        remindBtnSize.width += 32;
            NSRect skipBtnRect3 = [TempHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button3", nil) fontSize:12];
//        NSMutableAttributedString *updateBtnTitle = [StringHelper measureForStringDrawing:CustomLocalizedString(@"Update_Window_Button3", nil) withFont:font withLineSpacing:0 withMaxWidth:maxWidth withSize:&updateBtnSize withColor:color];
        updateBtnSize = skipBtnRect3.size;
        updateBtnSize.width += 32;
        
        if (status == UpdaterStatus_HasUpdate) {
            if (updateInfo.isMustUpdate) {
                totalBtnWidth = updateBtnSize.width;
                orgPos = NSMakePoint(floor((updateBottom.frame.size.width - totalBtnWidth) / 2), 18);
                NSString *str4 = CustomLocalizedString(@"Update_Window_Button3", nil);
                [btnUpdateNow reSetInit:str4 WithPrefixImageName:@"pop"];
                [btnUpdateNow setTarget:self];
                [btnUpdateNow setAction:@selector(onUpdateNow:)];
                [btnUpdateNow setFontSize:12];
                NSMutableAttributedString *attributedTitles3 = [[[NSMutableAttributedString alloc]initWithString:str4]autorelease];
                [attributedTitles3 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str4.length)];
                [attributedTitles3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, str4.length)];
                [attributedTitles3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] range:NSMakeRange(0, str4.length)];
                [btnUpdateNow setAttributedTitle:attributedTitles3];
                [btnUpdateNow setHidden:NO];
            } else {
                totalBtnWidth = skipBtnSize.width + remindBtnSize.width + updateBtnSize.width + 24;
                if (totalBtnWidth > self.window.frame.size.width) {
                    NSRect oldRect = self.window.frame;
                    NSRect newRect = NSZeroRect;
                    newRect.size = NSMakeSize(totalBtnWidth + 40, oldRect.size.height);
                    newRect.origin = NSMakePoint(oldRect.origin.x - ceil((newRect.size.width - oldRect.size.width) / 2.f), oldRect.origin.y);
//                    [topBgImgView setFrameOrigin:NSMakePoint(newRect.size.width - topBgImgView.frame.size.width, topBgImgView.frame.origin.y)];
//                    [updateBottom setFrameSize:NSMakeSize(newRect.size.width, updateBottom.frame.size.height)];
//                    NSSize newSize = NSMakeSize(newRect.size.width - 40, _UpdateTextView.frame.size.height);
//                    [textScrollView setFrameSize:newSize];
//                    [_UpdateTextView setFrameSize:newSize];
//                    [self.window setFrame:newRect display:YES];
                }
                
                orgPos = NSMakePoint(floor((updateBottom.frame.size.width - totalBtnWidth) / 2), 18);
//                btnSkipUpdate = [[NSButton alloc] initWithFrame:NSMakeRect(orgPos.x, orgPos.y, skipBtnSize.width, 34)];
//                [btnSkipUpdate setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
//                [btnSkipUpdate setBezelStyle:NSRoundedBezelStyle];
//                [btnSkipUpdate setTitle:skipBtnTitle.string];
//                [btnSkipUpdate setEnabled:YES];
//                [btnSkipUpdate setTarget:self];
     
                [btnSkipUpdate setFrame:NSMakeRect(ceilf(orgPos.x), ceilf(orgPos.y), ceilf(skipBtnSize.width) , 22)];
                NSString *str2 = CustomLocalizedString(@"Update_Window_Button1", nil);
                [btnSkipUpdate reSetInit:str2 WithPrefixImageName:@"cancal"];
                [btnSkipUpdate setTarget:self];
                [btnSkipUpdate setIsReslutVeiw:YES];
                [btnSkipUpdate setAction:@selector(onSkipVersion:)];
                [btnSkipUpdate setFontSize:12];
                NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:str2]autorelease];
                [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str2.length)];
                [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, str2.length)];
                [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, str2.length)];
                [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
                [btnSkipUpdate setAttributedTitle:attributedTitles1];

                
                
                
                orgPos = NSMakePoint(orgPos.x + skipBtnSize.width + 12, orgPos.y);
//                btnRemindLater = [[NSButton alloc] initWithFrame:NSMakeRect(orgPos.x, orgPos.y, remindBtnSize.width, 34)];
                
                [btnRemindLater setFrame:NSMakeRect(ceilf(orgPos.x) , ceilf(orgPos.y), ceilf(remindBtnSize.width) , 22)];
                NSString *str3 = CustomLocalizedString(@"Update_Window_Button2", nil);
                [btnRemindLater reSetInit:str3 WithPrefixImageName:@"cancal"];
                [btnRemindLater setTarget:self];
                [btnRemindLater setIsReslutVeiw:YES];
                [btnRemindLater setFontSize:12];
                [btnRemindLater setAction:@selector(onRemindLater:)];
                NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:str3]autorelease];
                [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str3.length)];
                [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, str3.length)];
                [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, str3.length)];
                [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
                [btnRemindLater setAttributedTitle:attributedTitles2];

//                [btnRemindLater setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
//                [btnRemindLater setBezelStyle:NSRoundedBezelStyle];
//                [btnRemindLater setTitle:remindBtnTitle.string];
//                [btnRemindLater setEnabled:YES];
//                [btnRemindLater setTarget:self];
//                [btnRemindLater setAction:@selector(onRemindLater:)];
                
                orgPos = NSMakePoint(orgPos.x + remindBtnSize.width + 12, orgPos.y);
                
                [btnUpdateNow setFrame:NSMakeRect(ceilf(orgPos.x) , ceilf(orgPos.y), ceilf(updateBtnSize.width), 22)];
                NSString *str4 = CustomLocalizedString(@"Update_Window_Button3", nil);
                [btnUpdateNow reSetInit:str4 WithPrefixImageName:@"pop"];
                [btnUpdateNow setTarget:self];
                [btnUpdateNow setAction:@selector(onUpdateNow:)];
                [btnUpdateNow setFontSize:12];
                NSMutableAttributedString *attributedTitles3 = [[[NSMutableAttributedString alloc]initWithString:str4]autorelease];
                [attributedTitles3 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str4.length)];
                [attributedTitles3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, str4.length)];
                [attributedTitles3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)] range:NSMakeRange(0, str4.length)];
                [attributedTitles3 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles3.length)];
                [btnUpdateNow setAttributedTitle:attributedTitles3];
                
//                btnUpdateNow = [[NSButton alloc] initWithFrame:NSMakeRect(orgPos.x, orgPos.y, updateBtnSize.width, 34)];
//                [btnUpdateNow setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
//                [btnUpdateNow setBezelStyle:NSRoundedBezelStyle];
//                [btnUpdateNow setTitle:updateBtnTitle.string];
//                [btnUpdateNow.cell setKeyEquivalent:@"\r"];
//                [btnUpdateNow setEnabled:YES];
//                [btnUpdateNow setTarget:self];
//                [btnUpdateNow setAction:@selector(onUpdateNow:)];
                
                if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
                    NSRect updateRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button3", nil) fontSize:12];
                    [btnUpdateNow setFrame:NSMakeRect(ceilf(updateBottom.frame.size.width - 18 - updateRect.size.width - 38), ceilf(btnUpdateNow.frame.origin.y), ceilf(updateRect.size.width +38), btnUpdateNow.frame.size.height)];
                    
                    NSRect remindRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button2", nil) fontSize:12];
                    [btnRemindLater setFrame:NSMakeRect(ceilf(btnUpdateNow.frame.origin.x - 38 - remindRect.size.width - 10), ceilf(btnRemindLater.frame.origin.y), ceilf(remindRect.size.width +38), btnRemindLater.frame.size.height)];
                    
                    NSRect update = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button1", nil) fontSize:12];
                    [btnSkipUpdate setFrame:NSMakeRect(ceilf(btnRemindLater.frame.origin.x - 20 - update.size.width - 38), ceilf(btnSkipUpdate.frame.origin.y), ceilf(update.size.width +38) , btnSkipUpdate.frame.size.height)];
                }else{
                    NSRect updateRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button3", nil) fontSize:12];
                    [btnUpdateNow setFrame:NSMakeRect(ceilf(updateBottom.frame.size.width - 18 - updateRect.size.width - 30), ceilf(btnUpdateNow.frame.origin.y), ceilf(updateRect.size.width +30), btnUpdateNow.frame.size.height)];
                    
                    NSRect remindRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button2", nil) fontSize:12];
                    [btnRemindLater setFrame:NSMakeRect(ceilf(btnUpdateNow.frame.origin.x - 30 - remindRect.size.width - 10), ceilf(btnRemindLater.frame.origin.y), ceilf(remindRect.size.width +30), btnRemindLater.frame.size.height)];
                    
                    NSRect update = [StringHelper calcuTextBounds:CustomLocalizedString(@"Update_Window_Button1", nil) fontSize:12];
                    [btnSkipUpdate setFrame:NSMakeRect(ceilf(btnRemindLater.frame.origin.x - 10 - update.size.width - 30), ceilf(btnSkipUpdate.frame.origin.y), ceilf(update.size.width +30) , btnSkipUpdate.frame.size.height)];
                }
                [btnSkipUpdate setHidden:NO];
                [btnRemindLater setHidden:NO];
                [btnUpdateNow setHidden:NO];
                [updateBottom addSubview:btnSkipUpdate];
                [updateBottom addSubview:btnRemindLater];
                [updateBottom addSubview:btnUpdateNow];
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
            [installBtn setHidden:NO];
            [settingBtn setHidden:NO];
            [settingBtn1 setHidden:NO];
            NSMutableAttributedString *mutAttrStr = [[NSMutableAttributedString alloc] init];
            
            NSString *productDescrible = [[NSString stringWithFormat:CustomLocalizedString(@"Update_Window_Text2", nil), softInfo.productName] stringByAppendingString:@"\n"];

            NSFont *bordLucida = [NSFont fontWithName:@"Helvetica Neue" size:14.0];

            NSMutableAttributedString *str1 = [self getAttrString:productDescrible withFont:bordLucida withLineSpacing:10 withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [mutAttrStr appendAttributedString:str1];
            
            NSString *newVerDescrible = [[NSString stringWithFormat: CustomLocalizedString(@"Update_Window_Text3", nil), info.version, info.buildDate] stringByAppendingString:@"\n"];
            NSMutableAttributedString *str2 = [self getAttrString:newVerDescrible withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:10 withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
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
                        NSMutableAttributedString *tmpStr = [self getAttrString:[NSString stringWithFormat:@"%@\n", str] withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:8 withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                        [mutAttrStr appendAttributedString:tmpStr];
                    }
                } else {
                    IMBUpdateLogDetail *detail =  [info.updateLogArray objectAtIndex:0];
                    for (NSString* str in detail.updateLogs) {
                        NSMutableAttributedString *tmpStr = [self getAttrString:[NSString stringWithFormat:@"%@\n", str] withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:8 withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
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
            NSMutableAttributedString *attrStr = [self getAttrString:string withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:8 withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                [attrStr setAlignment:NSRightTextAlignment range:NSMakeRange(0, attrStr.length)];
            }
            [_UpdateTextView.textStorage setAttributedString:attrStr];
            break;
        }
        default: {
            NSString *string = [NSString stringWithFormat:CustomLocalizedString(@"UpdateWindow_id_10", nil),softInfo.productName];
            NSMutableAttributedString *attrStr = [self getAttrString:string withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:8 withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
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
    NSString *url = CustomLocalizedString(@"SP_Download_Url", nil);
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

- (void)deviceDisconnected:(NSNotification *)notification
{
    [self.window close];
}

- (void)closeWindow:(id)sender {
    [self.window close];
}

@end

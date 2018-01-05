//
//  IMBAboutWindowController.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-31.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBAboutWindowController.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"
#import "IMBToolbarWindow.h"
#import "HoverButton.h"
@implementation IMBAboutWindowController

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

-(void)awakeFromNib{
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"]) {
        [[self.window standardWindowButton:NSWindowCloseButton] setHidden:YES];
        [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
        HoverButton *closeBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(7, 2, 12, 12)];
        [closeBtn setMouseEnteredImage:[NSImage imageNamed:@"close2"] mouseExitImage:[NSImage imageNamed:@"close"] mouseDownImage:[NSImage imageNamed:@"close3"]];
        [closeBtn setTarget:self];
        [closeBtn setAction:@selector(closeWindow:)];
        [[(IMBToolbarWindow *)self.window titleBarView] addSubview:closeBtn];
        [closeBtn release], closeBtn = nil;
    }
    
    [self.window center];
    [_titleCustomView setImage:[StringHelper imageNamed:@"start_icon"]];
    [_bgView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_titleStr setStringValue:@"AnyTrans"];
    [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_subTitleVersion setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
    [_subTitleVersion setStringValue: [NSString stringWithFormat:@"%@ %@ %@", CustomLocalizedString(@"Version_id", nil), software.version,  software.buildDate]];
    [_supportStr setStringValue:CustomLocalizedString(@"about_window_1", nil)];
    [_supportStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_honePageStr setStringValue:CustomLocalizedString(@"about_window_2", nil)];
    [_honePageStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_bottomLable setStringValue:CustomLocalizedString(@"about_window_3", nil)];
    [_bottomLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    NSMutableAttributedString* supportAttrStr = [[NSMutableAttributedString alloc] initWithString: CustomLocalizedString(@"sendlog_url", nil)];
    NSRange range = NSMakeRange(0, [supportAttrStr length]);
    // make the text appear in blue
    

    [supportAttrStr addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:range];
    // next make the text appear with an underline
    [supportAttrStr addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSNoUnderlineStyle] range:range];
    [supportAttrStr setAlignment:NSLeftTextAlignment range:NSMakeRange(0, supportAttrStr.length)];
    [_suportUrlBtn setAttributedTitle:supportAttrStr];
//    [_suportUrlBtn sizeToFit];
    [supportAttrStr release];
    supportAttrStr = nil;

    NSMutableAttributedString* homeAttrStr = [[NSMutableAttributedString alloc] initWithString: CustomLocalizedString(@"imobie_home", nil)];
    range = NSMakeRange(0, [homeAttrStr length]);
    // make the text appear in blue
    [homeAttrStr addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:range];
    // next make the text appear with an underline
    [homeAttrStr addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSNoUnderlineStyle] range:range];
    [homeAttrStr setAlignment:NSLeftTextAlignment range:NSMakeRange(0, homeAttrStr.length)];
    [_homePageUrlBtn setAttributedTitle:homeAttrStr];
//    [_homePageUrlBtn sizeToFit];
    [homeAttrStr release];
}
- (IBAction)supportBtnDown:(id)sender {
    NSString *hoStr = CustomLocalizedString(@"support_url", nil);
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)homeBtnDown:(id)sender {
    NSString *hoStr = CustomLocalizedString(@"imobie_home", nil);
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

- (void)closeWindow:(id)sender {
    [self.window close];
}


@end

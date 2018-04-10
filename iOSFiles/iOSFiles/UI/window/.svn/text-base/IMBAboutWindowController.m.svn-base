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
#import "IMBCommonDefine.h"
#import "IMBToolbarWindow.h"
#import "HoverButton.h"
#import "TempHelper.h"
#import "IMBiCloudNoTitleBarWinodw.h"

@implementation IMBAboutWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib {
    
    [self.window center];
    
    [[(IMBiCloudNoTitleBarWinodw *)self.window maxButton] setHidden:YES];
    [[(IMBiCloudNoTitleBarWinodw *)self.window minButton] setHidden:YES];
    
    [_titleCustomView setImage:[StringHelper imageNamed:@"window_logo"]];
    [_lineView setBackgroundColor:COLOR_TEXT_LINE];
    
    //关于窗口title
    [_titleStr setStringValue:CustomLocalizedString(@"MainWindow_id_7", nil)];
    [_titleStr setTextColor:COLOR_TEXT_ORDINARY];
    
    [_subTitleVersion setTextColor:COLOR_TEXT_EXPLAIN];
    IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
    [_subTitleVersion setStringValue: [NSString stringWithFormat:@"%@ %@ %@", CustomLocalizedString(@"List_Header_id_Version", nil), software.version,  software.buildDate]];
    
    [_supportStr setStringValue:CustomLocalizedString(@"about_window_1", nil)];
    [_supportStr setTextColor:COLOR_TEXT_ORDINARY];
    
    [_honePageStr setStringValue:CustomLocalizedString(@"about_window_2", nil)];
    [_honePageStr setTextColor:COLOR_TEXT_ORDINARY];
    
    [_bottomLable setStringValue:CustomLocalizedString(@"about_window_3", nil)];
    [_bottomLable setTextColor:COLOR_TEXT_EXPLAIN];
    
    NSMutableAttributedString* supportAttrStr = [[NSMutableAttributedString alloc] initWithString: CustomLocalizedString(@"support_url", nil)];
    NSRange range = NSMakeRange(0, [supportAttrStr length]);
    // make the text appear in blue
    

    [supportAttrStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_PASSAFTER range:range];
    // next make the text appear with an underline
    [supportAttrStr addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSNoUnderlineStyle] range:range];
    [supportAttrStr setAlignment:NSLeftTextAlignment range:NSMakeRange(0, supportAttrStr.length)];
    [_suportUrlBtn setAttributedTitle:supportAttrStr];
    [supportAttrStr release];
    supportAttrStr = nil;

    NSMutableAttributedString* homeAttrStr = [[NSMutableAttributedString alloc] initWithString: CustomLocalizedString(@"imobie_home", nil)];
    range = NSMakeRange(0, [homeAttrStr length]);
    // make the text appear in blue
    [homeAttrStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_PASSAFTER range:range];
    // next make the text appear with an underline
    [homeAttrStr addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSNoUnderlineStyle] range:range];
    [homeAttrStr setAlignment:NSLeftTextAlignment range:NSMakeRange(0, homeAttrStr.length)];
    [_homePageUrlBtn setAttributedTitle:homeAttrStr];
    [homeAttrStr release];
    
    NSRect supportRect = NSZeroRect;
    NSRect homeRect = NSZeroRect;
    supportRect = [StringHelper calcuTextBounds:_supportStr.stringValue fontSize:12.0];
    homeRect = [StringHelper calcuTextBounds:_honePageStr.stringValue fontSize:12.0];
    [_suportUrlBtn setFrameOrigin:NSMakePoint(_supportStr.frame.origin.x + supportRect.size.width + 3, _suportUrlBtn.frame.origin.y)];
    [_homePageUrlBtn setFrameOrigin:NSMakePoint(_honePageStr.frame.origin.x + homeRect.size.width + 3, _homePageUrlBtn.frame.origin.y)];
}

- (IBAction)supportBtnDown:(id)sender {
    NSString *hoStr = CustomLocalizedString(@"mailto_sendLog_url", nil);
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

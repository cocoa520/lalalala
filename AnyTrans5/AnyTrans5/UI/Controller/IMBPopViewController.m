//
//  IMBPopViewController.m
//  AnyTrans
//
//  Created by iMobie on 8/30/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBPopViewController.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"

@implementation IMBPopViewController
@synthesize isSkin = _isSkin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithPromptName:(NSString *)name {
    self = [super initWithNibName:@"IMBPopViewController" bundle:nil];
    if (self) {
        _promptName = name;
    }
    return self;
}

- (void)setPromptNameFrame:(NSRect)rect {
    [_textView setFrame:rect];
}

- (void)awakeFromNib {
    if (_isSkin) {
        _str1 = CustomLocalizedString(@"SkinWindow_morpt_update", nil);
        _str2 = [CustomLocalizedString(@"Update_Window_Button3", nil) stringByAppendingString:@">"];
        [_textView setDelegate:self];
        NSString *promptStr = @"";
        NSString *overStr = _str2;
        
        promptStr = [[_str1 stringByAppendingString:@"\n"] stringByAppendingString:_str2];
        
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
        [_textView setLinkTextAttributes:linkAttributes];
        
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
        
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:5.0];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_textView textStorage] setAttributedString:promptAs];
        [mutParaStyle release];
        mutParaStyle = nil;
    }else {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:_promptName];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [[_textView textStorage]setAttributedString:as];
        [as release], as = nil;
    }
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    NSString *overStr = [CustomLocalizedString(@"Update_Window_Button3", nil) stringByAppendingString:@">"];
    if ([link isEqualToString:overStr]) {
        NSString *url = CustomLocalizedString(@"SP_Download_Url", nil);
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:[NSURL URLWithString:url]];
    }
    return YES;
}

@end

//
//  IMBTipPopoverViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/31.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBTipPopoverViewController.h"
#import "IMBColorDefine.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"

@implementation IMBTipPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)awakeFromNib {
//    [_bgView setBackgroundColor:[NSColor colorWithDeviceRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]];
//    [_textView setBackgroundColor:[NSColor colorWithDeviceRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]];
    _textView.delegate = self;
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"tip_id_1", nil)];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setAlignment:NSCenterTextAlignment];
    [style setLineSpacing:2.0];
    [as addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
    [_tipTitle setAttributedStringValue:as];
    [as release], as = nil;
    [style release], style = nil;
    
    
    NSString *promptStr = CustomLocalizedString(@"tip_id_2", nil);
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = NSMakeRange(0, promptAs.length);
    [promptAs addAttribute:NSLinkAttributeName value:promptStr range:infoRange];
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
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    NSString *overStr = CustomLocalizedString(@"tip_id_2", nil);
    NSLog(@"%@",overStr);
    if ([link isEqualToString:overStr]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_CLOSE_TIP object:nil];
    }
    return YES;
}



@end

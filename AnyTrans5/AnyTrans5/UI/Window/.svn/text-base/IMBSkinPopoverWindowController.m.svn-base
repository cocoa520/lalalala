//
//  IMBSkinPopoverWindowController.m
//  AnyTrans
//
//  Created by m on 11/8/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBSkinPopoverWindowController.h"
#import "StringHelper.h"

@implementation IMBSkinPopoverWindowController
@synthesize  title = _title;
@synthesize isUP = _isUP;
- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void)awakeFromNib {
    self.window.opaque = NO;
    self.window.backgroundColor=[NSColor clearColor];
    if (_title) {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:_title];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setAlignment:NSCenterTextAlignment];
        [style setLineSpacing:2.0];
        [as addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, as.length)];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];
        [_lable setAttributedStringValue:as];
        [as release], as = nil;
        [style release], style = nil;
        
        NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
        [textParagraph setLineBreakMode:NSLineBreakByCharWrapping];
        NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:13],NSFontAttributeName,nil];
        
        NSSize size = [_title sizeWithAttributes:fontDic];
        [_mainView setFrameSize:NSMakeSize(size.width+ 20, 34)];
        [_mainView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
        [_mainView setWantsLayer:YES];
        [_mainView.layer setCornerRadius:5];
    }
}

- (void)setTitle:(NSString *)title {
    _title = [title retain];
}

- (void)setIsUP:(BOOL)isUP {
    if (!isUP) {
        [_mainView setIsUP:NO];
        NSRect oringnFrame = _lable.frame;
        oringnFrame.origin.y -= 7;
        [_lable setFrame:oringnFrame];
        [_lable setNeedsDisplay:YES];
    }
}

- (void)dealloc {
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    [super dealloc];
}

@end

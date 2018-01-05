//
//  IMBMenuPopupButton.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMenuPopupButton.h"
#import "IMBMenuItemView.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"

static float minWidth = 155;
@implementation IMBMenuPopupButton



- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _maxWidth = 1000;
    }
    return self;
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
    _maxWidth = maxWidth;
}

- (void)awakeFromNib
{
    _hasBorder = YES;
    _maxWidth = 1000;
}

- (void)setHasBorder:(BOOL)hasBorder
{
    _hasBorder = hasBorder;
    [self setNeedsDisplay:YES];
}

- (void)setTitle:(NSString *)aString
{
    [super setTitle:@""];
    if (_title != aString) {
        [_title release];
        _title = [aString retain];
    }
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(aString?aString:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName, nil]];
    int width = 0;
    width = title.size.width + 10*3;
    if (width>_maxWidth) {
        width = _maxWidth;
    }else if (width < minWidth) {
        width = minWidth;
    }
    [self setFrameSize:NSMakeSize(width, 22)];
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [self setFrameSize:NSMakeSize(width+8, 22)];
    }
    [title release];
    [self setNeedsDisplay:YES];

}

- (NSString *)title
{
    return _title;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if (_hasBorder) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path appendBezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] setStroke];
        [path addClip];
        [path setLineWidth:2];
        [path stroke];

    }
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
     NSAttributedString *title = [[NSAttributedString alloc] initWithString:(_title?_title:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil]];
    
    int width = title.size.width + 10*3;
    if (width>_maxWidth) {
        width = _maxWidth - 10*3;
    }else{
        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            width -= 10*2;
        }else {
            width -= 10*3;
        }
    }
//    NSRect rect = NSMakeRect(ceilf((NSWidth(self.frame) - width - 8)/2.0), ceilf((NSHeight(self.frame) - title.size.height)/2.0)-2, width, title.size.height);
    NSRect rect = NSMakeRect(8, ceilf((NSHeight(self.frame) - title.size.height)/2.0)-2, width, title.size.height);

    [title drawInRect:rect];
}

@end

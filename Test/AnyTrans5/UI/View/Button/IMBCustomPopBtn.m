//
//  IMBCustomPopBtn.m
//  AnyTrans
//
//  Created by smz on 17/10/19.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBCustomPopBtn.h"
#import "StringHelper.h"
#import "IMBAirWifiBackupViewController.h"

@implementation IMBCustomPopBtn
@synthesize hasBorder = _hasBorder;
@synthesize hasMinWidth = _hasMinWidth;
@synthesize hasMaxWidth = _hasMaxWidth;
@synthesize fontSize = _fontSize;
@synthesize arrowImage = _arrowImage;
@synthesize minWidth = _minWidth;
@synthesize maxWidth = _maxWidth;
@synthesize btnHeight = _btnHeight;
@synthesize borderColor = _borderColor;
@synthesize titleColor = _titleColor;
@synthesize titleSpaceWidth = _titleSpaceWidth;
@synthesize normalWidth = _normalWidth;
@synthesize arrowSpace = _arrowSpace;
@synthesize isAlertView = _isAlertView;
@synthesize isBackupTime = _isBackupTime;
@synthesize delegete = _delegete;

- (void)awakeFromNib {
    [self setTarget:self];
    [self setAction:@selector(selectionChanged:)];
}

#pragma mark - 设置属性
- (void)setBorderColor:(NSColor *)borderColor {
    if (_borderColor != nil) {
        [_borderColor release];
        _borderColor = nil;
    }
    _borderColor = [borderColor retain];
    
}

- (void)setTitleColor:(NSColor *)titleColor {
    if (_titleColor != nil) {
        [_titleColor release];
        _titleColor = nil;
    }
    _titleColor = [titleColor retain];
}

- (void)setArrowImage:(NSImage *)arrowImage {
    if (_arrowImage != nil) {
        [_arrowImage release];
        _arrowImage = nil;
    }
    _arrowImage = [arrowImage retain];

}

- (void)setTitleSpaceWidth:(float)titleSpaceWidth {
    _titleSpaceWidth = titleSpaceWidth;
    _tempSpace = titleSpaceWidth;
}

- (void)dealloc {
    if (_borderColor != nil) {
        [_borderColor release];
        _borderColor = nil;
    }
    if (_titleColor != nil) {
        [_titleColor release];
        _titleColor = nil;
    }
    if (_displayedTitle != nil) {
        [_displayedTitle retain];
        _displayedTitle = nil;
    }
    if (_arrowImage != nil) {
        [_arrowImage release];
        _arrowImage = nil;
    }
    [super dealloc];
}

+ (NSFont *)getTitleFontWithFontSize:(float)fontSize {
    NSFont *font = nil;
    if (fontSize < 19) {
        font = [NSFont fontWithName:@"Helvetica Neue" size:fontSize];
    } else if (fontSize >= 19 && fontSize <= 28) {
        font = [NSFont fontWithName:@"Helvetica Neue Light" size:fontSize];
    } else {
        font = [NSFont fontWithName:@"Helvetica Neue Thin" size:fontSize];
    }
    return font;
}

- (void)calculateTitleWidth {
    NSString *title = self.title;
    float titleWidth = [IMBCustomPopBtn calcuTextBounds:title fontSize:_fontSize].size.width;
    _normalWidth = titleWidth;
}

- (void)selectionChanged:(id)sender {
    [self calculateTitleWidth];
    [self resizeRect];
    if (_displayedTitle != nil) {
        [_displayedTitle release];
        _displayedTitle = nil;
    }
    _displayedTitle = [self.title retain];
}

- (void)setTitle:(NSString *)aString {
    [super setTitle:aString];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:aString];
    [as addAttribute:NSForegroundColorAttributeName value:_titleColor range:NSMakeRange(0, as.length)];
    [as setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as.length)];
    [self setAttributedTitle:as];
    [as release], as = nil;
    
    if (_displayedTitle != nil) {
        [_displayedTitle release];
        _displayedTitle = nil;
    }
    _displayedTitle = [aString retain];
    [self selectionChanged:self];
    [self setNeedsDisplay:YES];
}

- (void)resizeRect {
    float btnWidth = _normalWidth + _tempSpace*2 + _arrowImage.size.width + _arrowSpace;
    if (_hasMinWidth) {
        if (_minWidth > btnWidth) {
            btnWidth = _minWidth;
            _titleSpaceWidth = ceil((btnWidth - _normalWidth - _arrowImage.size.width - _arrowSpace)/2.0);
        }
    } else if (_hasMaxWidth) {
        if (_maxWidth < btnWidth) {
            btnWidth = _maxWidth;
            _titleSpaceWidth = ceil((btnWidth - _normalWidth - _arrowImage.size.width - _arrowSpace)/2.0);
        }
        
    }
    [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, btnWidth,_btnHeight)];
    
}

+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize {
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [IMBCustomPopBtn getTitleFontWithFontSize:fontSize], NSFontAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName,
                                    nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
    }
    return textBounds;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(_displayedTitle?_displayedTitle:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[IMBCustomPopBtn getTitleFontWithFontSize:_fontSize], NSFontAttributeName,_titleColor, NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil]];
    NSRect rect;
    if (_isAlertView) {
        rect = NSMakeRect(10, (self.frame.size.height - title.size.height)/2.0 - 2, _normalWidth, title.size.height);
    } else {
        rect = NSMakeRect(_titleSpaceWidth, (self.frame.size.height - title.size.height)/2.0 - 2, _normalWidth, title.size.height);
    }
    [title drawInRect:rect];
    if (_arrowImage != nil) {
        NSRect originRect = NSMakeRect(self.frame.size.width - _arrowSpace - _arrowImage.size.width, (self.frame.size.height - _arrowImage.size.height)/2.0, _arrowImage.size.width, _arrowImage.size.height);
        [_arrowImage drawInRect:originRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    if (_hasBorder) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [path setLineWidth:2.0];
        [path addClip];
        [path setWindingRule:NSEvenOddWindingRule];
        [[StringHelper getColorFromString:CustomColor(@"airWifi_popBtn_line_Color", nil)] setStroke];
        [path stroke];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (_isBackupTime) {
        [_delegete backupTimeButtonClick];
    } else {
        [super mouseDown:theEvent];
    }
    
}

@end

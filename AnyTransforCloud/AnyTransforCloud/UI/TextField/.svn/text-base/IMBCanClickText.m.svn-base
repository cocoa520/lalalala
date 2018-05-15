//
//  IMBCanClickText.m
//  PhoneRescue
//
//  Created by smz on 17/9/12.
//  Copyright (c) 2017年 iMobie Inc. All rights reserved.
//

#import "IMBCanClickText.h"
#import "StringHelper.h"

@implementation IMBCanClickText
@synthesize lineSpace = _lineSpace;

- (void)setNormalString:(NSString *)normalString WithLinkString1:(NSString *)linkString1 WithLinkString2:(NSString *)linkString2 WithNormalColor:(NSColor *)normalColor WithLinkNormalColor:(NSColor *)linkNormalColor WithLinkEnterColor:(NSColor *)linkEnterColor WithLinkDownColor:(NSColor *)linkDownColor WithFont:(NSFont *)font {
    if (_font != nil) {
        [_font release];
        _font = nil;
    }
    _font = [font retain];
    if (_normalColor != nil) {
        [_normalColor release];
        _normalColor = nil;
    }
    _normalColor = [normalColor retain];
    if (_linkNormalColor != nil) {
        [_linkNormalColor release];
        _linkNormalColor = nil;
    }
    _linkNormalColor = [linkNormalColor retain];
    if (_linkEnterColor != nil) {
        [_linkEnterColor release];
        _linkEnterColor = nil;
    }
    _linkEnterColor = [linkEnterColor retain];
    if (_linkDownColor != nil) {
        [_linkDownColor release];
        _linkDownColor = nil;
    }
    _linkDownColor = [linkDownColor retain];
    if (_normalString != nil) {
        [_normalString release];
        _normalString = nil;
    }
    _normalString = [normalString retain];
    if (_linkString1 != nil) {
        [_linkString1 release];
        _linkString1 = nil;
    }
    _linkString1 = [linkString1 retain];
    if (_linkString2 != nil) {
        [_linkString2 release];
        _linkString2 = nil;
    }
    _linkString2 = [linkString2 retain];
    [self setDrawsBackground:NO];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_mouseType == MouseEnter || _mouseType == MouseUp) {
        _linkColor = _linkEnterColor;
    } else if (_mouseType == MouseDown) {
        _linkColor = _linkDownColor;
    } else {
        _linkColor = _linkNormalColor;
    }
    
    if (_linkColor) {
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName:_linkColor, (id)kCTUnderlineStyleAttributeName:[NSNumber numberWithInt:kCTUnderlineStyleNone],NSToolTipAttributeName:[NSNull null]};
        [self setLinkTextAttributes:linkAttributes];
        
        if (![StringHelper stringIsNilOrEmpty:_normalString]) {
            NSMutableAttributedString *promptAs = [StringHelper setTextWordStyle:_normalString withFont:_font withLineSpacing:_lineSpace withAlignment:self.alignment withColor:_normalColor];
            [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
            [promptAs addAttribute:NSToolTipAttributeName value:[NSNull null] range:NSMakeRange(0, promptAs.length)];
            
            if (![StringHelper stringIsNilOrEmpty:_linkString1]) {
                NSRange infoRange1 = [_normalString rangeOfString:_linkString1];
                [promptAs addAttribute:NSLinkAttributeName value:_linkString1 range:infoRange1];
                [promptAs addAttribute:NSForegroundColorAttributeName value:_linkColor range:infoRange1];
                [promptAs addAttribute:NSFontAttributeName value:_font range:infoRange1];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange1];
            }
            
            if (![StringHelper stringIsNilOrEmpty:_linkString2]) {
                NSRange infoRange2 = [_normalString rangeOfString:_linkString2];
                [promptAs addAttribute:NSLinkAttributeName value:_linkString2 range:infoRange2];
                [promptAs addAttribute:NSForegroundColorAttributeName value:_linkColor range:infoRange2];
                [promptAs addAttribute:NSFontAttributeName value:_font range:infoRange2];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange2];
            }
            
            NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
            [mutParaStyle setAlignment:self.alignment];
            [mutParaStyle setLineSpacing:5.0];
            [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
            [[self textStorage] setAttributedString:promptAs];
            [mutParaStyle release], mutParaStyle = nil;
        }
    }
    [super drawRect:dirtyRect];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [self performSelector:@selector(mouseclick:) withObject:theEvent afterDelay:0.01];
    [self setNeedsDisplay:YES];
}

- (void)mouseclick:(id)sender {
    [super mouseDown:sender];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    if (_font != nil) {
        [_font release];
        _font = nil;
    }
    if (_normalColor != nil) {
        [_normalColor release];
        _normalColor = nil;
    }
    if (_linkNormalColor != nil) {
        [_linkNormalColor release];
        _linkNormalColor = nil;
    }
    if (_linkEnterColor != nil) {
        [_linkEnterColor release];
        _linkEnterColor = nil;
    }
    if (_linkDownColor != nil) {
        [_linkDownColor release];
        _linkDownColor = nil;
    }
    if (_normalString != nil) {
        [_normalString release];
        _normalString = nil;
    }
    if (_linkString1 != nil) {
        [_linkString1 release];
        _linkString1 = nil;
    }
    if (_linkString2 != nil) {
        [_linkString2 release];
        _linkString2 = nil;
    }
    [super dealloc];
}

@end

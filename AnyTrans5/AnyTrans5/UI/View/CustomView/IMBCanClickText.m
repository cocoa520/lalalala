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

- (void)setNormalString:(NSString *)normalString WithLinkString:(NSString *)linkString WithNormalColor:(NSColor *)normalColor WithLinkNormalColor:(NSColor *)linkNormalColor WithLinkEnterColor:(NSColor *)linkEnterColor WithLinkDownColor:(NSColor *)linkDownColor WithFont:(NSFont *)font {
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
    if (_linkString != nil) {
        [_linkString release];
        _linkString = nil;
    }
    _linkString = [linkString retain];
    [self setDrawsBackground:NO];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_mouseType == MouseEnter) {
        _linkColor = _linkEnterColor;
    } else if (_mouseType == MouseDown) {
        _linkColor = _linkDownColor;
    } else {
        _linkColor = _linkNormalColor;
    }
    NSString *promptStr = @"";
    if ([_normalString isEqualToString:_linkString]) {
        promptStr = _normalString;
    } else {
        promptStr = [_normalString stringByAppendingString:_linkString];
    }
    
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName:_linkColor, (id)kCTUnderlineStyleAttributeName:[NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [self setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:_font withColor:_normalColor];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:_linkString];
    [promptAs addAttribute:NSLinkAttributeName value:_linkString range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:_linkColor range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:_font range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:self.alignment];
    [mutParaStyle setLineSpacing:3.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[self textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    [super drawRect:dirtyRect];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [super mouseDown:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
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
    if (_linkString != nil) {
        [_linkString release];
        _linkString = nil;
    }
    [super dealloc];
}

@end

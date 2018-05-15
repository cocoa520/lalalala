//
//  IMBTextLinkButton.m
//  AnyTrans
//
//  Created by smz on 17/11/1.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBTextLinkButton.h"
#import "StringHelper.h"

@implementation IMBTextLinkButton

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setTransparent:YES];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [[NSColor clearColor] set];
    [path fill];
    [path closePath];
    if (_buttonTitle != nil) {
        NSColor *titleColor = nil;
        if (self.enabled) {
            if (_mouseType == MouseUp || _mouseType == MouseOut) {
                titleColor = _titleColor;
            } else if (_mouseType == MouseEnter) {
                titleColor = _titleEnterColor;
            } else if (_mouseType == MouseDown) {
                titleColor = _titleDownColor;
            } else {
                titleColor = _titleColor;
            }
        } else {
            titleColor = _titleColor;
        }
        
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:_fontSize];
        NSRect titleRect = [StringHelper calcuTextBounds:_buttonTitle font:font];
        
        NSAttributedString *title = [StringHelper setTextWordStyle:_buttonTitle withFont:font withAlignment:NSTextAlignmentCenter withLineBreakMode:NSLineBreakByTruncatingMiddle withColor:titleColor];
        if (titleRect.size.width > 112) {
            titleRect.size.width = 112;
        }
        [title drawInRect:NSMakeRect(dirtyRect.origin.x,(dirtyRect.size.height - titleRect.size.height) / 2.0, titleRect.size.width, titleRect.size.height)];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [super mouseEntered:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [super mouseExited:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [super mouseDown:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    [super mouseUp:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)setButtonWithTitle:(NSString *)buttonTitle WithFontSize:(float)fontSize WithTitleColor:(NSColor *)titleColor WithTitleEnterColor:(NSColor *)titleEnterColor WithTitleDownColor:(NSColor *)titleDownColor {
    if (_buttonTitle != nil) {
        [_buttonTitle release];
        _buttonTitle = nil;
    }
    _buttonTitle = [buttonTitle retain];
    if (_titleColor != nil) {
        [_titleColor release];
        _titleColor = nil;
    }
    _titleColor = [titleColor retain];
    if (_titleEnterColor != nil) {
        [_titleEnterColor release];
        _titleEnterColor = nil;
    }
    _titleEnterColor = [titleEnterColor retain];
    if (_titleDownColor != nil) {
        [_titleDownColor release];
        _titleDownColor = nil;
    }
    _titleDownColor = [titleDownColor retain];
    _fontSize = fontSize;
}

- (void)dealloc {
    if (_buttonTitle != nil) {
        [_buttonTitle release];
        _buttonTitle = nil;
    }
    if (_titleColor != nil) {
        [_titleColor release];
        _titleColor = nil;
    }
    if (_titleEnterColor != nil) {
        [_titleEnterColor release];
        _titleEnterColor = nil;
    }
    if (_titleDownColor != nil) {
        [_titleDownColor release];
        _titleDownColor = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end

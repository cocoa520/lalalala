//
//  IMBHeadImageButton.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/18.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBHeadImageButton.h"

@implementation IMBHeadImageButton

- (void)dealloc {
    if (_normalColor) {
        [_normalColor release];
        _normalColor = nil;
    }
    if (_enterColor) {
        [_enterColor release];
        _enterColor = nil;
    }
    if (_downColor) {
        [_downColor release];
        _downColor = nil;
    }
    if (_headImage) {
        [_headImage release];
        _headImage = nil;
    }
    if (_subscriptImage) {
        [_subscriptImage release];
        _subscriptImage = nil;
    }
    [super dealloc];
}

- (void)setMouseNormalColor:(NSColor *)normalColor WithMouseEnterColor:(NSColor *)enterColor WithMouseDownColor:(NSColor *)downColor WithHeadImage:(NSImage *)headImage WithSubscriptImage:(NSImage *)subscriptImage {
    if (_normalColor) {
        [_normalColor release];
        _normalColor = nil;
    }
    _normalColor = [normalColor retain];
    
    if (_enterColor) {
        [_enterColor release];
        _enterColor = nil;
    }
    _enterColor = [enterColor retain];
    
    if (_downColor) {
        [_downColor release];
        _downColor = nil;
    }
    _downColor = [downColor retain];
    
    if (_headImage) {
        [_headImage release];
        _headImage = nil;
    }
    _headImage = [headImage retain];
    
    if (_subscriptImage) {
        [_subscriptImage release];
        _subscriptImage = nil;
    }
    _subscriptImage = [subscriptImage retain];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *bgColor = nil;
    if (_mouseType == MouseOut) {
        bgColor = _normalColor;
    } else if (_mouseType == MouseEnter || _mouseType == MouseUp) {
        bgColor = _enterColor;
    } else if (_mouseType == MouseDown) {
        bgColor = _downColor;
    } else {
        bgColor = _normalColor;
    }
    
    NSRect imageFrame = NSMakeRect(4, 4, 38, 38);
    [_headImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
    NSRect subImageFrame = NSMakeRect(35, 35, 6, 6);
    [_subscriptImage drawInRect:subImageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:imageFrame xRadius:17 yRadius:17];
    [bgPath addClip];
    [bgPath setWindingRule:NSEvenOddWindingRule];
    [bgColor set];
    [bgPath fill];
    [bgPath closePath];
    
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
        [_trackingArea release];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    [self setNeedsDisplay:YES];
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner) {
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

@end

//
//  IMBToolBarButton.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBToolBarButton.h"

@implementation IMBToolBarButton
@synthesize mouseExitedImage = _mouseExitedImage;
@synthesize curEventPoint = _curEventPoint;

- (void)setMouseExitedImg:(NSImage *)mouseExiteImg withMouseEnterImg:(NSImage *)mouseEnterImg withMouseDownImage:(NSImage *)mouseDownImg withMouseDisableImage:(NSImage *)mouseDisableImg {
    if (_mouseDownImage) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseExitedImage) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    if (_mouseDisableImage) {
        [_mouseDisableImage release];
        _mouseDisableImage = nil;
    }
    _mouseDownImage = [mouseDownImg retain];
    _mouseExitedImage = [mouseExiteImg retain];
    _mouseEnteredImage = [mouseEnterImg retain];
    _mouseDisableImage = [mouseDisableImg retain];
    
    [self setNeedsDisplay:YES];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSImage *btnImage = nil;
    if (self.isEnabled) {
        if (_mouseType == MouseEnter || _mouseType == MouseUp) {
            btnImage = _mouseEnteredImage;
        } else if (_mouseType == MouseDown) {
            btnImage = _mouseDownImage;
        } else {
            btnImage = _mouseExitedImage;
        }
    } else {
        btnImage = _mouseDisableImage;
    }
    NSRect imageFrame = NSMakeRect(0, 0, btnImage.size.width, btnImage.size.height);
    [btnImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
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
    if (self.isEnabled) {
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            _curEventPoint = theEvent.locationInWindow;
            [NSApp sendAction:self.action to:self.target from:self];
            _mouseType = MouseOut;
            [self setNeedsDisplay:YES];
        }
    }
}

@end

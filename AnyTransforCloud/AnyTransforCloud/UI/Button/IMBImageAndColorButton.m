//
//  IMBImageAndColorButton.m
//  AnyTrans for Android
//
//  Created by smz on 18/1/31.
//  Copyright (c) 2018年 iMobie. All rights reserved.
//

#import "IMBImageAndColorButton.h"

@implementation IMBImageAndColorButton
@synthesize buttonType = _buttonType;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setEnabled:(BOOL)flag {
    if (flag != self.isEnabled) {
        [super setEnabled:flag];
        _buttonType = 1;
        if (!self.isEnabled) {
            [self setAlphaValue:0.5];
        }else {
            [self setAlphaValue:1];
        }
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseDownImage:(NSImage*) mouseDownImg withMouseUpImg:(NSImage *) mouseUpImg withMouseExitedImg:(NSImage *) mouseExiteImg mouseEnterImg:(NSImage *) mouseEnterImg {
    if (_mouseDownImage != nil) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseUpImage != nil) {
        [_mouseUpImage release];
        _mouseUpImage = nil;
    }
    if (_mouseExitedImage != nil) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage != nil) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    _mouseDownImage = [mouseDownImg retain];
    _mouseUpImage = [mouseUpImg retain];
    _mouseExitedImage = [mouseExiteImg retain];
    _mouseEnteredImage = [mouseEnterImg retain];
}

- (void)setLineNormalColor:(NSColor *)lineNormalColor withLineEnterColor:(NSColor *)lineEnterColor withLineDownColor:(NSColor *)lineDownColor {
    if (_lineNormalColor != nil) {
        [_lineNormalColor release];
        _lineNormalColor = nil;
    }
    if (_lineEnterColor != nil) {
        [_lineEnterColor release];
        _lineEnterColor = nil;
    }
    if (_lineDownColor != nil) {
        [_lineDownColor release];
        _lineDownColor = nil;
    }
    
    _lineNormalColor = [lineNormalColor retain];
    _lineEnterColor = [lineEnterColor retain];
    _lineDownColor = [lineDownColor retain];
    
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

-(void)dealloc {
    if (_mouseDownImage != nil) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseUpImage != nil) {
        [_mouseUpImage release];
        _mouseUpImage = nil;
    }
    if (_mouseExitedImage != nil) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage != nil) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    if (_lineNormalColor != nil) {
        [_lineNormalColor release];
        _lineNormalColor = nil;
    }
    if (_lineEnterColor != nil) {
        [_lineEnterColor release];
        _lineEnterColor = nil;
    }
    if (_lineDownColor != nil) {
        [_lineDownColor release];
        _lineDownColor = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

- (BOOL)isFlipped {
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSRect sourceimageRect;
    NSRect desImageRect;
    NSImage *image = nil;
    NSColor *lineColor = nil;
    float lineWidth = 0;
    if (_buttonType == 1) {
        image = _mouseExitedImage;
        lineColor = _lineNormalColor;
    } else if (_buttonType == 2 || _buttonType == 4) {
        image = _mouseEnteredImage;
        lineColor = _lineEnterColor;
    } else if (_buttonType == 3) {
        image = _mouseDownImage;
        lineColor = _lineDownColor;
        lineWidth = 2;
    } else {
        image = _mouseExitedImage;
        lineColor = _lineNormalColor;
    }
    NSRect lineRect = NSMakeRect(dirtyRect.size.width - lineWidth, 0, lineWidth, dirtyRect.size.height);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:lineRect];
    
    if (image !=nil) {
        sourceimageRect.origin = NSZeroPoint;
        sourceimageRect.size = NSMakeSize(image.size.width, image.size.height);
        desImageRect.origin = NSMakePoint(ceil((self.bounds.size.width - image.size.width)/2.0), ceil((self.bounds.size.height - image.size.height)/2.0));
        desImageRect.size = image.size;
        [image drawInRect:desImageRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    if (lineColor != nil && lineWidth != 0) {
        [lineColor setFill];
        [path setLineWidth:lineWidth];
        [path fill];
    }
    [path closePath];
}

-(void)mouseUp:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _buttonType = 4;
        [self setNeedsDisplay:YES];
        
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = 3;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = 1;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseEntered:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = 2;
        [self setNeedsDisplay:YES];
    }
}

@end

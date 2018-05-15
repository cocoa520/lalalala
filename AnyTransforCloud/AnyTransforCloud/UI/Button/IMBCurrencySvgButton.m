//
//  IMBCurrencySvgButton.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/18.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCurrencySvgButton.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
@implementation IMBCurrencySvgButton

- (void)setSvgFileName:(NSString *)svgName withUseFillColor:(BOOL)isFill withSVGSize:(NSSize)svgSize withEnterColor:(NSColor *)enterColor withOutColor:(NSColor *) outColor withDownColor:(NSColor *)downColor {
    _isFill = isFill;
    _enterColor = [enterColor retain];
    _outColor = [outColor retain];
    _downColor = [downColor retain];
    [self setWantsLayer:YES];
    _myVectorDrawing = [[PocketSVG alloc] initFromSVGFileNamed:svgName];
    _subLayer = [[CALayer alloc] init];
    [self setWantsLayer:YES];
    //[self.layer setBackgroundColor:[NSColor clearColor].CGColor];
    [self.layer addSublayer:_subLayer];
    [_subLayer setFrame:NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height)];

    NSBezierPath *allPath = [NSBezierPath bezierPath];
    for (NSBezierPath *bezier in _myVectorDrawing.bezierAry) {
        //2: Its bezier property is the corresponding NSBezierPath:
        NSBezierPath *myBezierPath2 = bezier;
        [allPath appendBezierPath:myBezierPath2];
    }
//    [allPath setWindingRule:NSEvenOddWindingRule];
    
    _myShapeLayer2 = [CAShapeLayer layer];
    _myShapeLayer2.frame = NSMakeRect(ceil((self.bounds.size.width - svgSize.width)/2.0), ceil((self.bounds.size.height - svgSize.height)/2.0), svgSize.width, svgSize.height);
    CGPathRef path2 = [_myVectorDrawing getCGPathFromNSBezierPath:allPath];
    _myShapeLayer2.path = path2;
    if (_isFill) {
         _myShapeLayer2.fillColor = _outColor.CGColor;
    }else if (_isBorderView){
        _myShapeLayer2.fillColor = _outColor.CGColor;
        _myShapeLayer2.lineWidth = 0;
    } else {
        _myShapeLayer2.strokeColor = _outColor.CGColor;
    }
   
    [_subLayer addSublayer:_myShapeLayer2];
    [_subLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
//    [super mouseEntered:theEvent];
    _mouseState = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    //    [super mouseUp:theEvent];
    _mouseState = MouseUp;
    [self setNeedsDisplay:YES];
    if (self.isEnabled &&theEvent.clickCount == 1) {
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseState = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
//    [super mouseExited:theEvent];
    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *color = nil;
    if (_mouseState == MouseEnter) {
        color = _enterColor;
    }else if (_mouseState == MouseOut) {
        color = _outColor;
    }else if (_mouseState == MouseDown) {
        color = _downColor;
    }else if (_mouseState == MouseUp) {
        color = _outColor;
    }else {
        color = [NSColor clearColor];
    }
    if (_isFill) {
        _myShapeLayer2.fillColor = color.CGColor;
    } else if (_isBorderView) {
        _myShapeLayer2.fillColor = color.CGColor;
    } else {
        _myShapeLayer2.strokeColor = color.CGColor;
    }
}

- (void)dealloc  {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_enterColor) {
        [_enterColor release];
        _enterColor = nil;
    }
    if (_outColor) {
        [_outColor release];
        _outColor = nil;
    }
    if (_downColor) {
        [_downColor release];
        _downColor = nil;
    }
    [super dealloc];
}

@end

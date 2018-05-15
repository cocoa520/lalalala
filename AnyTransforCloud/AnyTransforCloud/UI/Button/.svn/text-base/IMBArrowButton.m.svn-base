//
//  IMBArrowButton.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/3.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBArrowButton.h"
#import "StringHelper.h"

@implementation IMBArrowButton

- (void)setIsAscending:(BOOL)isAscending {
    _isAscending = isAscending;
    [self setNeedsDisplay:YES];
}

- (void)setIsHightLight:(BOOL)isHightLight {
    _isHightLight = isHightLight;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:1];
    if (_isAscending) { //画升序箭头
        [path moveToPoint:NSMakePoint(4, 24)];
        NSPoint p1 = NSMakePoint(8, 19);
        [path lineToPoint:p1];

        NSPoint p2 = NSMakePoint(12, 24);
        [path lineToPoint:p2];
        [path moveToPoint:p2];
    } else { //画降序箭头
        [path moveToPoint:NSMakePoint(4, 19)];
        NSPoint p1 = NSMakePoint(8, 24);
        [path lineToPoint:p1];
        
        NSPoint p2 = NSMakePoint(12, 19);
        [path lineToPoint:p2];
        [path moveToPoint:p2];
    }
    if (_isHightLight) {
        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    } else {
        [[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] set];
    }
    [path stroke];
    [path closePath];
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
    
    if (_mouseType == MouseDown) {
        [self setIsAscending:!_isAscending];
    }
    _mouseType = MouseUp;
    [self setNeedsDisplay:YES];
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner) {
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

@end

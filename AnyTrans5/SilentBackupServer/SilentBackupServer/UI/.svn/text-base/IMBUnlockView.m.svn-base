//
//  IMBUnlockView.m
//  AirBackupHelper
//
//  Created by m on 17/10/22.
//  Copyright (c) 2017年 iMobie. All rights reserved.
//

#import "IMBUnlockView.h"

@implementation IMBUnlockView
@synthesize target = _target;
@synthesize action = _action;
@synthesize hasCorner = _hasCorner;

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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = nil;
    if (_hasCorner) {
        path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    }else {
        path = [NSBezierPath bezierPathWithRect:dirtyRect];
    }
    [path setLineWidth:2.0];
    [path setClip];
    
    if (_mouseState == MouseEnter) {
        [[NSColor colorWithDeviceRed:212.0/255 green:238.0/255 blue:252.0/255 alpha:1.0] setFill];
        [path fill];
    }else if (_mouseState == MouseDown) {
        [[NSColor colorWithDeviceRed:194.0/255 green:230.0/255 blue:250.0/255 alpha:1.0] setFill];
        [path fill];
    }
    [[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]  setStroke];
    [path stroke];
}

- (void)setHasCorner:(BOOL)hasCorner {
    _hasCorner = hasCorner;
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseState = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseState = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
    _mouseState = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end

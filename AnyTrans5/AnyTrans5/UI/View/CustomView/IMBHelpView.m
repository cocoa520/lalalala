//
//  IMBHelpView.m
//  AnyTrans
//
//  Created by m on 17/8/23.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBHelpView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"

@implementation IMBHelpView

- (void)awakeFromNib {
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited| NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:dirtyRect.size.height / 2.0 yRadius:dirtyRect.size.height / 2.0];
    [path setWindingRule:NSEvenOddWindingRule];
    [path addClip];
    if (_mouseState == MouseDown) {
        [[StringHelper getColorFromString:CustomColor(@"popover_bgDownColor", nil)] setFill];
        [path fill];
    }else if (_mouseState == MouseEnter) {
        [[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] setFill];
        [path fill];
    }else {
        [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] setStroke];
        [path stroke];
    }
    NSImage *image = [StringHelper imageNamed:@"nav_help"];
    [image drawInRect:NSMakeRect((dirtyRect.size.width - image.size.width) / 2.0, (dirtyRect.size.height - image.size.height) / 2.0, image.size.width, image.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    _mouseState = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    _mouseState = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
    _mouseState = MouseUp;
    [self setNeedsDisplay:YES];
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (void)changeSkin:(NSNotification *)notification{
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

@end

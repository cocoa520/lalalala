//
//  IMBCloudHistoryView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBCloudHistoryView.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "IMBCloudManager.h"

@implementation IMBCloudHistoryView
@synthesize target = _target;
@synthesize action = _action;

- (void)dealloc {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    [super dealloc];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setWantsLayer:YES];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    
    //投影效果
    if (_mouseType == MouseEnter || _mouseType == MouseDown) {
        if (_shadow) {
            [_shadow release];
            _shadow = nil;
        }
        _shadow = [[NSShadow alloc] init];
        [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        [_shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
        [_shadow setShadowBlurRadius:5.0];
        [_shadow set];
    } else {
        if (_shadow) {
            [_shadow release];
            _shadow = nil;
        }
        _shadow = [[NSShadow alloc] init];
        [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        [_shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
        [_shadow setShadowBlurRadius:3.0];
        [_shadow set];
    }
    
    NSRect newRect = NSMakeRect(dirtyRect.origin.x + 5, dirtyRect.origin.y + 5, self.frame.size.width-10, self.frame.size.height - 10);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
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

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    [self setNeedsDisplay:YES];
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner&&theEvent.clickCount <= 1) {
        [super mouseUp:theEvent];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
    [IMBAnimation animationMouseEnteredExitedWithView:self fromValue:0 toValue:@3 timeInterval:0.3];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
    [IMBAnimation animationMouseEnteredExitedWithView:self fromValue:@3 toValue:0 timeInterval:0.3];
    
}

@end

@implementation IMBCloudItemView

- (void)awakeFromNib {
    NSColor *color = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
    [_nameTextField setTextColor:color];
    color = [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)];
    [_emailTextField setTextColor:color];
    [_sizeTextField setTextColor:color];
}

- (void)dealloc {
    [super dealloc];
}

@end

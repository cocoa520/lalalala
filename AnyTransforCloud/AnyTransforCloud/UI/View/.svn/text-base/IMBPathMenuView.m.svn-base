//
//  IMBPathMenuView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/2.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBPathMenuView.h"
#import "StringHelper.h"
#import "IMBAnimation.h"

@implementation IMBPathMenuView
@synthesize action = _action;
@synthesize target = _target;

- (void)dealloc {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    _shadow = [[NSShadow alloc] init];
    [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_deepColor", nil)]];
    [_shadow setShadowOffset:NSMakeSize(0.0, 0.0)];
    [_shadow setShadowBlurRadius:5.0];
    [_shadow set];
    NSRect newRect = NSMakeRect(dirtyRect.origin.x + 5, dirtyRect.origin.y + 5, self.frame.size.width-10, self.frame.size.height - 10);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [path closePath];
}

@end

@implementation IMBPathItem

- (void)drawRect:(NSRect)dirtyRect {
    
    NSColor *titleColor = nil;
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_mouseType == MouseEnter || _mouseType == MouseUp) {
        
        [[StringHelper getColorFromString:CustomColor(@"tableView_enter_color", nil)] set];
        titleColor = [StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)];
    }else if (_mouseType == MouseDown) {
        
        [[StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)] set];
        titleColor = [StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)];
    }else {
        
        [[NSColor clearColor] set];
        titleColor = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
    }
    [path fill];
    [path closePath];
    
    //画图片
    NSRect imageFrame = NSMakeRect(10, (dirtyRect.size.height - 27)/2, 29, 27);
    if (_itemTag == 1) {
        imageFrame = NSMakeRect(9, (dirtyRect.size.height - 30)/2 - 1, 32, 30);
    }
    [_pathImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
    //画标题
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    NSRect textRect = [StringHelper calcuTextBounds:_pathTitle font:font];
    textRect = NSMakeRect(imageFrame.origin.x + 29 + 9, (dirtyRect.size.height - textRect.size.height)/2.0, textRect.size.width, textRect.size.height);
    if (textRect.size.width > 112) {
        textRect.size.width = 112;
    }
    
    NSAttributedString *attrTimeStr = [StringHelper setTextWordStyle:_pathTitle withFont:font withAlignment:NSTextAlignmentLeft withLineBreakMode:NSLineBreakByTruncatingTail withColor:titleColor];
    [attrTimeStr drawInRect:textRect];
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
    if (inner&&theEvent.clickCount ==1) {
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
//    [self setWantsLayer:YES];
//    [self.layer removeAllAnimations];
//    CABasicAnimation *animation = [IMBAnimation moveX:0.3 X:@3 repeatCount:0 beginTime:0.0];
//    [self.layer addAnimation:animation forKey:@"2"];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
//    [self setWantsLayer:YES];
//    CABasicAnimation *animation = [IMBAnimation moveX:0.3 X:@0 repeatCount:0 beginTime:0.0];
//    [self.layer addAnimation:animation forKey:@"1"];
}

@end

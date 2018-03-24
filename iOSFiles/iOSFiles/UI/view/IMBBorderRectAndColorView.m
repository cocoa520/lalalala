//
//  IMBBorderRectAndColorView.m
//  MacClean
//
//  Created by Gehry on 4/17/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import "IMBBorderRectAndColorView.h"
#import "StringHelper.h"
#import "IMBCommonDefine.h"


@implementation IMBBorderRectAndColorView

@synthesize background = _background;
@synthesize borderLineSize = _borderLineSize;
@synthesize lineColor = _lineColor;
@synthesize isOffSetY = _isOffSetY;
@synthesize offsetY = _offsetY;
@synthesize blurRadius = _blurRadius;

- (id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    if (_background != nil) {
        [_background release];
    }
    if (_lineColor != nil) {
        [_lineColor release];
    }
    [super dealloc];
}

- (void)setOffsetY:(float)offsetY {
    if (_offsetY != offsetY) {
        _offsetY = offsetY;
    }
}

- (void)setBlurRadius:(float)blurRadius {
    if (_blurRadius != blurRadius) {
        _blurRadius = blurRadius;
    }
}

- (void)setLineColor:(NSColor *)lineColor {
    if (_lineColor != lineColor) {
        if (_lineColor != nil) {
            [_lineColor release];
            _lineColor = nil;
        }
        _lineColor = [lineColor retain];
    }
    [self setNeedsDisplay:YES];
}

-(void)setBackground:(NSColor *)aColor
{
    if(_background != aColor) {
        if (_background) {
            [_background release];
            _background = nil;
        }
        _background = [aColor retain];
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    // Drawing code here.
    [super drawRect:dirtyRect];
    //投影效果
    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
    [shadow setShadowColor:COLOR_ALERT_SHADOWCOLOR];
    if (!_isOffSetY) {
        [shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
    }
    if (_blurRadius) {
        [shadow setShadowBlurRadius:_blurRadius];
    }else {
        [shadow setShadowBlurRadius:4];
    }
    [shadow set];
    
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+5, dirtyRect.origin.y+5, self.frame.size.width-10, self.frame.size.height -10);
    NSBezierPath *text = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];
    if (_background) {
        [_background setFill];
    }else {
        [IMBGrayColor(255) setFill];
    }
    [text fill];
    if (_lineColor) {
        [[NSColor clearColor] setStroke];
        [text addClip];
        [_lineColor setStroke];
    }else {
        [[NSColor clearColor] setStroke];
    }
    [text stroke];
}



@end

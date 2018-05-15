//
//  IMBBorderRectAndColorView.m
//  MacClean
//
//  Created by Gehry on 4/17/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import "IMBBorderRectAndColorView.h"
#import "StringHelper.h"
@implementation IMBBorderRectAndColorView

@synthesize background = _background;
@synthesize borderLineSize = _borderLineSize;
@synthesize lineColor = _lineColor;
@synthesize isOffSetY = _isOffSetY;
@synthesize offsetY = _offsetY;
@synthesize blurRadius = _blurRadius;
@synthesize isAlertView = _isAlertView;
@synthesize rightShadow = _rightShadow;

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    if (_background != nil) {
        [_background release];
    }
    if (_lineColor != nil) {
        [_lineColor release];
    }
    [super dealloc];
}

- (void)setLuCorner:(BOOL)luCorner LbCorner:(BOOL)lbConer RuCorner:(BOOL)ruConer RbConer:(BOOL)rbConer CornerRadius:(float)cornerRadius {
    _luCorner = luCorner;
    _lbCorner = lbConer;
    _ruCorner = ruConer;
    _rbCorner = rbConer;
    _cornerRadius = cornerRadius;
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

-(void)setBackground:(NSColor *)aColor {
    if(_background != aColor) {
        if (_background) {
            [_background release];
            _background = nil;
        }
        _background = [aColor retain];
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    // Drawing code here.
    [super drawRect:dirtyRect];
    
    //投影效果

    if (_isAlertView) {
        //投影效果
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_deepColor", nil)]];
        [shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
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
            [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
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
    }else if (_isOffSetY) {
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        if (!_isOffSetY) {
            [shadow setShadowOffset:NSMakeSize(0.0, 0.0)];
        }else {
            [shadow setShadowOffset:NSMakeSize(0, 0)];
        }
        if (_blurRadius) {
            [shadow setShadowBlurRadius:_blurRadius];
        }else {
            [shadow setShadowBlurRadius:4];
        }
        [shadow set];
        
        NSBezierPath *path = nil;
        float width;
        float height;
        
        path = [NSBezierPath bezierPath];
        width = dirtyRect.size.width;
        height = dirtyRect.size.height;
        
        if (_lbCorner) {
            [path moveToPoint:NSMakePoint(_cornerRadius, 3)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(_cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:270 endAngle:180 clockwise:YES];
        }else {
            [path moveToPoint:NSMakePoint(0, 3)];
        }
        
        if (_luCorner) {
            [path lineToPoint:NSMakePoint(0, height - _cornerRadius)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(_cornerRadius, height - _cornerRadius) radius:_cornerRadius startAngle:180 endAngle:90 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(0, height)];
        }
        
        if (_ruCorner) {
            [path lineToPoint:NSMakePoint(width - _cornerRadius, height)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(width - _cornerRadius, height - _cornerRadius) radius:_cornerRadius startAngle:90 endAngle:0 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(width, height)];
        }
        
        if (_rbCorner) {
            [path lineToPoint:NSMakePoint(width , _cornerRadius + 3)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(width - _cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:0 endAngle:270 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(width, 3)];
        }
        [path closePath];
        
        if (_background) {
            [_background setFill];
        }else {
            [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
        }
        [path fill];
        
        if (_lineColor) {
            [[NSColor clearColor] setStroke];
            [path addClip];
            [_lineColor setStroke];
        }else {
            [[NSColor clearColor] setStroke];
        }
        [path stroke];
    }else if (_rightShadow) {
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        if (!_isOffSetY) {
            [shadow setShadowOffset:NSMakeSize(0.0, 0.0)];
        }else {
            [shadow setShadowOffset:NSMakeSize(0, 0)];
        }
        if (_blurRadius) {
            [shadow setShadowBlurRadius:_blurRadius];
        }else {
            [shadow setShadowBlurRadius:4];
        }
        [shadow set];
        
        NSBezierPath *path = nil;
        float width;
        float height;
        
        path = [NSBezierPath bezierPath];
        width = dirtyRect.size.width - 4;
        height = dirtyRect.size.height;
        
        if (_lbCorner) {
            [path moveToPoint:NSMakePoint(4 +_cornerRadius, 0)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(_cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:270 endAngle:180 clockwise:YES];
        }else {
            [path moveToPoint:NSMakePoint(4, 0)];
        }
        
        if (_luCorner) {
            [path lineToPoint:NSMakePoint(4, height - _cornerRadius)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(_cornerRadius, height - _cornerRadius) radius:_cornerRadius startAngle:180 endAngle:90 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(4, height)];
        }
        
        if (_ruCorner) {
            [path lineToPoint:NSMakePoint(width + 4 - _cornerRadius, height)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(width - _cornerRadius, height - _cornerRadius) radius:_cornerRadius startAngle:90 endAngle:0 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(width + 4, height)];
        }
        
        if (_rbCorner) {
            [path lineToPoint:NSMakePoint(width + 4 , _cornerRadius)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(width - _cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:0 endAngle:270 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(width + 4, 0)];
        }
        [path closePath];
        
        if (_background) {
            [_background setFill];
        }else {
            [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
        }
        [path fill];
        
        if (_lineColor) {
            [[NSColor clearColor] setStroke];
            [path addClip];
            [_lineColor setStroke];
        }else {
            [[NSColor clearColor] setStroke];
        }
        [path stroke];
    }else {
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        if (!_isOffSetY) {
            [shadow setShadowOffset:NSMakeSize(0.0, 0.0)];
        }else {
            [shadow setShadowOffset:NSMakeSize(0, 0)];
        }
        if (_blurRadius) {
            [shadow setShadowBlurRadius:_blurRadius];
        }else {
            [shadow setShadowBlurRadius:4];
        }
        [shadow set];
        
        NSBezierPath *path = nil;
        float width;
        float height;
        
        path = [NSBezierPath bezierPath];
        width = dirtyRect.size.width - 4;
        height = dirtyRect.size.height;
        
        if (_lbCorner) {
            [path moveToPoint:NSMakePoint(_cornerRadius, 0)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(_cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:270 endAngle:180 clockwise:YES];
        }else {
            [path moveToPoint:NSZeroPoint];
        }
        
        if (_luCorner) {
            [path lineToPoint:NSMakePoint(0, height - _cornerRadius)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(_cornerRadius, height - _cornerRadius) radius:_cornerRadius startAngle:180 endAngle:90 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(0, height)];
        }
        
        if (_ruCorner) {
            [path lineToPoint:NSMakePoint(width - _cornerRadius, height)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(width - _cornerRadius, height - _cornerRadius) radius:_cornerRadius startAngle:90 endAngle:0 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(width, height)];
        }
        
        if (_rbCorner) {
            [path lineToPoint:NSMakePoint(width , _cornerRadius)];
            [path appendBezierPathWithArcWithCenter:NSMakePoint(width - _cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:0 endAngle:270 clockwise:YES];
        }else {
            [path lineToPoint:NSMakePoint(width, 0)];
        }
        [path closePath];
        
        if (_background) {
            [_background setFill];
        }else {
            [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
        }
        [path fill];
        
        if (_lineColor) {
            [[NSColor clearColor] setStroke];
            [path addClip];
            [_lineColor setStroke];
        }else {
            [[NSColor clearColor] setStroke];
        }
        [path stroke];
    }

    

//    [path addClip];
    

    

}



@end

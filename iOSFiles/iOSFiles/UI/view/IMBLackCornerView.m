//
//  IMBLackCornerView.m
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/26.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import "IMBLackCornerView.h"
#import "StringHelper.h"
#import "NSBezierPath+BezierPathQuartzUtilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation IMBLackCornerView
@synthesize backgroundColor = _backgroundColor;
@synthesize backgroundImage = _backgroundImage;
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithLuCorner:(BOOL)luCorner LbCorner:(BOOL)lbConer RuCorner:(BOOL)ruConer RbConer:(BOOL)rbConer CornerRadius:(float)cornerRadius {
    if (self) {
        _luCorner = luCorner;
        _lbCorner = lbConer;
        _ruCorner = ruConer;
        _rbCorner = rbConer;
        _cornerRadius = cornerRadius;
    }
    return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    if (_backgroundColor != backgroundColor) {
        [_backgroundColor release];
        _backgroundColor = [backgroundColor retain];
        
    }
    
    [self setNeedsDisplay:YES];
}

- (void)setBackgroundImage:(NSImage *)backgroundImage {
    if (_backgroundImage != nil) {
        [_backgroundImage release];
        _backgroundImage = nil;
    }
    _backgroundImage = [backgroundImage retain];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPath];
    float width = dirtyRect.size.width;
    float height = dirtyRect.size.height;
    
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
    [path addClip];
    if (_backgroundColor != nil) {
        [_backgroundColor setFill];
    }else
    {
        [[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1] setFill];
    }
    [path fill];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path quartzPath];
    shapeLayer.backgroundColor = [NSColor redColor].CGColor;
    [self setWantsLayer:YES];
    [self.layer setMask:shapeLayer];
    [self.layer setMasksToBounds:YES];
    
}

- (void)dealloc {
    if (_backgroundColor != nil) {
        [_backgroundColor release];
        _backgroundColor = nil;
    }
    [super dealloc];
}
@end

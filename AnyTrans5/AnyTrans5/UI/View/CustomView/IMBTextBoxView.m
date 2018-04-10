//
//  IMBTextBoxView.m
//  AnyTrans
//
//  Created by smz on 17/8/1.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBTextBoxView.h"
#import "StringHelper.h"

@implementation IMBTextBoxView
@synthesize borderColor = _borderColor;
@synthesize isHaveCorner = _isHaveCorner;

- (void)setBorderColor:(NSColor *)borderColor {
    if (borderColor) {
        _borderColor = [borderColor retain];
    }else {
        _borderColor = [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] retain];
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = nil;
    if (_isHaveCorner) {
        path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
    } else {
        path = [NSBezierPath bezierPathWithRect:dirtyRect];
    }
    
    [path addClip];
    [path setWindingRule:NSEvenOddWindingRule];
    [path setLineWidth:2.0];
    [_borderColor setStroke];
    [path stroke];
    [path closePath];
    
}

- (void)dealloc {
    if (_borderColor != nil) {
        [_borderColor release];
        _borderColor = nil;
    }
    [super dealloc];
}

@end

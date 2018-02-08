//
//  IMBDotView.m
//  AnyTrans
//
//  Created by smz on 17/10/25.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBDotView.h"

@implementation IMBDotView
@synthesize circleRadius = _circleRadius;
@synthesize fillColor = _fillColor;
@synthesize highLightColor = _highLightColor;
@synthesize isNowPage = _isNowPage;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_circleRadius yRadius:_circleRadius];
    [path addClip];
    [path setWindingRule:NSEvenOddWindingRule];
    if (_isNowPage) {
        [_highLightColor set];
    } else {
        [_fillColor set];
    }
    [path fill];
    [path closePath];
}

- (void)setFillColor:(NSColor *)fillColor {
    if (_fillColor != nil) {
        [_fillColor release];
        _fillColor = nil;
    }
    _fillColor = [fillColor retain];
}

- (void)setHighLightColor:(NSColor *)highLightColor {
    if (_highLightColor != nil) {
        [_highLightColor release];
        _highLightColor = nil;
    }
    _highLightColor = [highLightColor retain];
}

- (void)dealloc {
    if (_fillColor != nil) {
        [_fillColor release];
        _fillColor = nil;
    }
    if (_highLightColor != nil) {
        [_highLightColor release];
        _highLightColor = nil;
    }
    [super dealloc];
}

@end

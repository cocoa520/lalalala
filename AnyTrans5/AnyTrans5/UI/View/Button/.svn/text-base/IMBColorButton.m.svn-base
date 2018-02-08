//
//  IMBColorButton.m
//  AnyTrans
//
//  Created by smz on 17/7/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBColorButton.h"
#import "StringHelper.h"

@implementation IMBColorButton
@synthesize isHasBorder = _isHasBorder;
@synthesize fillColor = _fillColor;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize newTag = _newTag;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_isHasBorder) {
            [self setBordered:NO];
        }
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSNoImage];
    }
    return self;
}

- (void)setFillColor:(NSColor *)fillColor {
    if (fillColor) {
        _fillColor = [fillColor retain];
    } else {
        _fillColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)];
    }
    [self setNeedsDisplay:YES];
}

- (void)setBorderColor:(NSColor *)borderColor {
    if (borderColor) {
        _borderColor = [borderColor retain];
    } else {
        _borderColor = [StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)];
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self setWantsLayer:YES];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
    [path setWindingRule:NSEvenOddWindingRule];
    if (_isHasBorder && _borderWidth) {
        [path setLineWidth:_borderWidth];
    }
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
    [path addClip];
    [path fill];
    [_borderColor setStroke];
    [path stroke];
    [path closePath];
    
    if (_shapeLayer != nil) {
        [_shapeLayer removeFromSuperlayer];
        [_shapeLayer release];
        _shapeLayer = nil;
    }
    _shapeLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddEllipseInRect(ref, NULL, CGRectMake((self.bounds.size.width - 10)/2.0,(self.bounds.size.height - 10)/2.0,10,10));
    _shapeLayer.frame = self.bounds;
    _shapeLayer.path = ref;
    _shapeLayer.fillColor = _fillColor.CGColor;
    [self.layer addSublayer:_shapeLayer];
    CGPathRelease(ref);
    
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

}

- (void)dealloc {
    if (_fillColor != nil) {
        [_fillColor release];
        _fillColor = nil;
    }
    if (_borderColor != nil) {
        [_borderColor release];
        _borderColor = nil;
    }
    if (_shapeLayer != nil) {
        [_shapeLayer release];
        _shapeLayer = nil;
    }
    [super dealloc];
}

@end

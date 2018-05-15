//
//  IMBCheckBtn.m
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCheckButton.h"
#import "StringHelper.h"
#import "NSBezierPath+BezierPathQuartzUtilities.h"

@implementation IMBCheckButton

- (void)awakeFromNib {
    [self setWantsLayer:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"text_lineColor", nil)] setStroke];
    [path addClip];
    [path setWindingRule:NSEvenOddWindingRule];
    [path setLineWidth:2.0];
    [path stroke];
    [path closePath];
}

- (void)setState:(NSInteger)value {
    if (value == NSOnState) {
        if (_checkLayer) {
            [_checkLayer removeAllAnimations];
            [_checkLayer removeFromSuperlayer];
        }
        if (_semiLayer) {
            [_semiLayer removeFromSuperlayer];
        }
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        //对号第一部分直线的起始
        [path moveToPoint:NSMakePoint(3.3, 7)];
        NSPoint p1 = NSMakePoint(6.3, 10);
        [path lineToPoint:p1];
        
        //对号第二部分起始
        NSPoint p2 = NSMakePoint(11.8, 4);
        [path lineToPoint:p2];
        [path moveToPoint:p2];
        
        if (!_checkLayer) {
            _checkLayer = [[CAShapeLayer alloc] init];
        }
        //内部填充颜色
        _checkLayer.fillColor = [NSColor clearColor].CGColor;
        //线条颜色
        _checkLayer.strokeColor = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)].CGColor;
        //线条宽度
        _checkLayer.lineWidth = 1.5;
        
        _checkLayer.path = path.quartzPath;
        //动画设置
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.duration = 0.3;
        [_checkLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
        [self.layer addSublayer:_checkLayer];
    }
    else if(value == NSOffState) {
        if (_checkLayer) {
            [_checkLayer removeAllAnimations];
            [_checkLayer removeFromSuperlayer];
        }
        if (_semiLayer) {
            [_semiLayer removeFromSuperlayer];
        }
    }
    else if(value == NSMixedState) {
        if (_checkLayer) {
            [_checkLayer removeAllAnimations];
            [_checkLayer removeFromSuperlayer];
        }
        if (_semiLayer) {
            [_semiLayer removeFromSuperlayer];
        }
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(4, 7.5)];
        NSPoint p1 = NSMakePoint(11.4, 7.5);
        [path lineToPoint:p1];
        [path moveToPoint:p1];
        
        if (!_semiLayer) {
            _semiLayer = [[CAShapeLayer alloc] init];
        }
        //内部填充颜色
        _semiLayer.fillColor = [NSColor clearColor].CGColor;
        //线条颜色
        _semiLayer.strokeColor = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)].CGColor;
        //线条宽度
        _semiLayer.lineWidth = 1.5;
        _semiLayer.path = path.quartzPath;
        [self.layer addSublayer:_semiLayer];
    }
    [self setNeedsDisplay:YES];
    [super setState:value];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (![self isEnabled]) {
        return;
    }
    if (self.state == NSMixedState) {
        self.state = NSOnState;
    }
    else{
        [self setState:self.state == NSOnState?NSOffState:NSOnState];
    }
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)dealloc {
    if (_checkLayer) {
        [_checkLayer release];
        _checkLayer = nil;
    }
    if (_semiLayer) {
        [_semiLayer release];
        _semiLayer = nil;
    }
    [super dealloc];
}

@end

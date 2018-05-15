//
//  IMBSVGButton.m
//  AnyTransforCloud
//
//  Created by hym on 13/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBSVGButton.h"
#import "PocketSVG.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBAnimation.h"
#import "StringHelper.h"
#import "IMBMainNavigationView.h"
@implementation IMBSVGButton
@synthesize cloudAry = _cloudAry;
@synthesize backgroundColor = _backgroundColor;
@synthesize isClick = _isClick;
@synthesize isDownOtherBtn = _isDownOtherBtn;
@synthesize cloudEntity = _cloudEntity;
@synthesize delegate = _delegate;
@synthesize toolTipStr = _toolTipStr;
@synthesize isUnlockBtn = _isUnlockBtn;

- (void)setCloudEntity:(IMBCloudEntity *)cloudEntity {
    if (_cloudEntity) {
        [_cloudEntity release];
        _cloudEntity = nil;
    }
    _cloudEntity = [cloudEntity retain];
}

- (void)setSvgFileName:(NSString *)svgName {
    [self setWantsLayer:YES];
    _myVectorDrawing = [[PocketSVG alloc] initFromSVGFileNamed:svgName];
    _subLayer = [[CALayer alloc] init];
    [self setWantsLayer:YES];
//    [self.layer setBackgroundColor:[NSColor clearColor].CGColor];
    [_subLayer setFrame:NSMakeRect((self.bounds.size.width - 36)/2.0, (self.bounds.size.height - 36)/2.0, 36, 36)];

    
    NSBezierPath *allPath = [NSBezierPath bezierPath];
    for (NSBezierPath *bezier in _myVectorDrawing.bezierAry) {
        //2: Its bezier property is the corresponding NSBezierPath:
        NSBezierPath *myBezierPath2 = bezier;
        [allPath appendBezierPath:myBezierPath2];

        //3: To display it on screen, create a CAShapeLayer:
        //   and call getCGPathFromNSBezierPath to get the
        //   SVG's CGPath

    }
    [allPath setWindingRule:NSNonZeroWindingRule];
    
    _myShapeLayer2 = [[CAShapeLayer alloc] init];
    _myShapeLayer2.frame = NSMakeRect(0, 0, 36, 36);
    CGPathRef path2 = [_myVectorDrawing getCGPathFromNSBezierPath:allPath];
    _myShapeLayer2.path = path2;

    _myShapeLayer2.fillColor = [StringHelper getColorFromString:CustomColor(@"menu_normal_color", nil)].CGColor;

    [_subLayer addSublayer:_myShapeLayer2];
    [_subLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];

    CAAnimation *animation1 = [IMBAnimation scale:@1 orgin:@0.8 durTimes:0.1 Rep:0];
    animation1.autoreverses = NO;
    animation1.beginTime = 0.0;
    [_subLayer addAnimation:animation1 forKey:@"down"];

    _backgroundLayer = [[CALayer alloc]init];
    [_backgroundLayer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)].CGColor];
    [_backgroundLayer setCornerRadius:46];
    [_backgroundLayer setFrame:NSMakeRect(-20, -20, self.frame.size.width + 40, self.frame.size.height +40)];
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_subLayer];
    [_backgroundLayer setHidden:YES];
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (self.isEnabled&& !_isClick) {
        [super mouseEntered:theEvent];
        CAAnimation *animation1 = [IMBAnimation scale:@0.8 orgin:@1.0 durTimes:0.2 Rep:0];
        animation1.autoreverses = NO;
        animation1.beginTime = 0.0;
        [_subLayer addAnimation:animation1 forKey:@"down"];
        _mouseState = MouseEnter;
        _isDownOtherBtn = NO;
        [self setNeedsDisplay:YES];
    }
    int64_t delayInSeconds = 0.00005;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [self setNeedsDisplay:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(showToolTip:withToolTip:)]) {
                [self.delegate showToolTip:self withToolTip:_toolTipStr];
            }
        }
    });

}

- (void)mouseUp:(NSEvent *)theEvent {
//    [super mouseUp:theEvent];
    if (self.isEnabled&& !_isClick) {
        
        _mouseState = MouseUp;
        [self setNeedsDisplay:YES];
        if (self.isEnabled &&theEvent.clickCount == 1) {
            NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
            BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
            if (inner) {
                [NSApp sendAction:self.action to:self.target from:self];
            }
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled && !_isClick ) {
        _isFristAnimation = YES;
        _isDown = YES;
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
     
            [_backgroundLayer removeAllAnimations];
            [_subLayer removeAllAnimations];
            [_backgroundLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
            [_subLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
            if (_isUnlockBtn) {
                CAAnimation *animation3 = [IMBAnimation scale:@1.0 orgin:@0.8 durTimes:0.1 Rep:0];
                animation3.autoreverses = NO;
                [_subLayer addAnimation:animation3 forKey:@"enter1"];
            }else {
                CAAnimation *animation3 = [IMBAnimation scale:@1.0 orgin:@0.6 durTimes:0.1 Rep:0];
                animation3.autoreverses = NO;
                [_subLayer addAnimation:animation3 forKey:@"enter1"];
            }
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                CAAnimation *animation = [IMBAnimation scale:@0 orgin:@1.0 durTimes:0.3 Rep:0];
                animation.autoreverses = NO;
                if (!_isUnlockBtn) {
                    [_backgroundLayer addAnimation:animation forKey:@"enter"];
                    [_backgroundLayer setHidden:NO];
                    CAAnimation *animation2 = [IMBAnimation scale:@0.4 orgin:@0.8 durTimes:0.1 Rep:0];
                    animation2.autoreverses = NO;
                    [_subLayer addAnimation:animation2 forKey:@"enter1"];
                }
            });
//        });
        _mouseState = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (self.isEnabled&& !_isClick&&!_isDown) {
        CAAnimation *animation1 = [IMBAnimation scale:@1.0 orgin:@0.8 durTimes:0.2 Rep:0];
        animation1.autoreverses = NO;
        animation1.beginTime = 0.0;
        [_subLayer addAnimation:animation1 forKey:@"down"];
        _mouseState = MouseOut;
        [self setNeedsDisplay:YES];
    }
    _isDown = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolTipViewClose)]) {
        [self.delegate toolTipViewClose];
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    NSColor *color = nil;
    if (_isClick) {
        
        if (_backgroundColor) {
            color = _backgroundColor ;
        }else {
            color = [NSColor clearColor];
        }
    }else {
        if (_backgroundColor) {
            color = _backgroundColor;
        }else {
            color = [NSColor clearColor];
        }
    }
    [color set];
    [clipPath fill];
    if (!_isClick) {
        _isFristAnimation = NO;
        _myShapeLayer2.fillColor = [StringHelper getColorFromString:CustomColor(@"menu_normal_color", nil)].CGColor;
        [_backgroundLayer setHidden:YES];
    }else {
        [_backgroundLayer setHidden:NO];
        _myShapeLayer2.fillColor = [StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)].CGColor;
    }
}

- (void)dealloc  {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_cloudEntity) {
        [_cloudEntity release];
        _cloudEntity = nil;
    }
    if (_myShapeLayer2) {
        [_myShapeLayer2 release];
        _myShapeLayer2 = nil;
    }
    [super dealloc];
}

@end




































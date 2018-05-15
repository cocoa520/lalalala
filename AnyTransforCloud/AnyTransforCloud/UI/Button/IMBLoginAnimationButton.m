//
//  IMBLoginAnimationButton.m
//  AnyTransforCloud
//
//  Created by hym on 15/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBLoginAnimationButton.h"
#import "IMBAnimation.h"
@implementation IMBLoginAnimationButton

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

- (void)setImageName:(NSString *)imgName {
    [self setBordered:NO];
    [self setImagePosition:NSImageOnly];
    _subLayer = [[CALayer alloc] init];
    NSImage *image = [NSImage imageNamed:imgName];
    [_subLayer setFrame:NSMakeRect((self.frame.size.width - image.size.width)/2.0, (self.frame.size.height - image.size.height)/2.0, image.size.width, image.size.height)];
    [_subLayer setContents:image];
    [self setWantsLayer:YES];
    [self.layer addSublayer:_subLayer];

    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _mouseState = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseUp:(NSEvent *)theEvent{
    if (self.isEnabled) {
        [super mouseUp:theEvent];
        _mouseState = MouseUp;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _mouseState = MouseOut;
        [self setNeedsDisplay:YES];
    }
    
}

-(void)mouseEntered:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _mouseState = MouseEnter;
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [_subLayer removeAllAnimations];
    [_subLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
    if (_mouseState == MouseEnter) {
        CAAnimation *animation = [IMBAnimation scale:@0.8 orgin:@1 durTimes:0.2 Rep:0];
        animation.autoreverses = NO;
        [_subLayer addAnimation:animation forKey:@"enter"];
    }else if (_mouseState == MouseOut) {
        CAAnimation *animation = [IMBAnimation scale:@1 orgin:@0.8 durTimes:0.2 Rep:0];
        animation.autoreverses = NO;
        [_subLayer addAnimation:animation forKey:@"out"];
    }else if (_mouseState == MouseDown) {
        CAAnimation *animation1 = [IMBAnimation scale:@1.0 orgin:@0.6 durTimes:0.2 Rep:0];
        animation1.autoreverses = NO;
        animation1.beginTime = 0.0;
        [_subLayer addAnimation:animation1 forKey:@"down"];
    }else if (_mouseState == MouseUp) {
        CAAnimation *animation1 = [IMBAnimation scale:@0.6 orgin:@1.2 durTimes:0.2 Rep:0];
        animation1.autoreverses = NO;
        animation1.beginTime = 0;
        CAAnimation *animation2 = [IMBAnimation scale:@1.2 orgin:@1 durTimes:0.2 Rep:0];
        animation2.autoreverses = NO;
        animation2.beginTime = 0.2;
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[animation1,animation2];
        group.duration = 0.4;
        group.autoreverses = NO;
        group.removedOnCompletion=NO;
        group.fillMode=kCAFillModeForwards;
        group.beginTime = 0.0;
        group.repeatCount = 0;
        [_subLayer addAnimation:group forKey:@"up"];
    }
}

@end

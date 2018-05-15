//
//  IMBAddCloudAnimationView.m
//  AnyTransforCloud
//
//  Created by hym on 18/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBAddCloudAnimationView.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
@implementation IMBAddCloudAnimationView
@synthesize target = _target;
@synthesize action = _action;

- (void)awakeFromNib {
    [self setupLayer];
}

- (void)setupLayer {
    [self setWantsLayer:YES];
    if (!_bgAnimationLayer) {
        _bgAnimationLayer = [[CALayer alloc]init];
        [_bgAnimationLayer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"AddCloud_bg_AnimationColor", nil)].CGColor];
        [_bgAnimationLayer setCornerRadius:46];
        [_bgAnimationLayer setFrame:NSMakeRect(-20, -20, self.frame.size.width + 40, self.frame.size.height +40)];
        [self.layer addSublayer:_bgAnimationLayer];
        [_bgAnimationLayer setHidden:YES];
    }
    
    if (!_imageLayer) {
        _imageLayer = [[CALayer alloc] init];
        NSImage *image1 = [NSImage imageNamed:@"addcloud_add"];
        _imageLayer.contents = image1;
        [_imageLayer setFrame:CGRectMake((self.frame.size.width - image1.size.width) / 2.0 , self.frame.size.height / 2.0 + 10, image1.size.width, image1.size.height)];
        [self.layer addSublayer:_imageLayer];
        [_imageLayer setHidden:YES];
    }

    if (!_titleLayer) {
        _titleLayer = [[CATextLayer alloc] init];
        
        _titleLayer.string = CustomLocalizedString(@"AddCloud_Button_Content", nil);
        _titleLayer.fontSize = 14;
        _titleLayer.foregroundColor = [NSColor blackColor].CGColor;
        _titleLayer.font = (__bridge CFTypeRef)(@"Helvetica Neue");
        _titleLayer.alignmentMode = @"center";
        _titleLayer.backgroundColor = [NSColor clearColor].CGColor;
        [_titleLayer setFrame:CGRectMake(2,  ceil(_imageLayer.frame.origin.y - 25), self.bounds.size.width - 4, 20)];
        [self.layer addSublayer:_titleLayer];
        [_titleLayer setHidden:YES];
    }
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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    if (_buttonType == MouseEnter || _buttonType == MouseDown || _buttonType == MouseUp) {
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
        [path stroke];
        [path addClip];
        [path closePath];
    }
    [_bgAnimationLayer setHidden:YES];
    if (_buttonType == MouseUp) {
        [_bgAnimationLayer removeAllAnimations];
        [_bgAnimationLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
        CAAnimation *animation = [IMBAnimation scale:@0 orgin:@1.0 durTimes:0.3 Rep:0];
        animation.autoreverses = NO;
        [animation setDelegate:self];
        [_bgAnimationLayer addAnimation:animation forKey:@"bgscal"];
        [_bgAnimationLayer setHidden:NO];
    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    _buttonType = MouseDown;
    [self setNeedsDisplay:YES];
}

-(void)mouseUp:(NSEvent *)theEvent{
    _buttonType = MouseUp;
    [self setNeedsDisplay:YES];
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner&&theEvent.clickCount <= 1) {
        if (self.action&&self.target) {
            [NSApp sendAction:self.action to:self.target from:self];
            _buttonType = MouseOut;
            [self setNeedsDisplay:YES];
        }else {
            [super mouseUp:theEvent];
        }
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    _buttonType = MouseOut;
    [self setNeedsDisplay:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(_buttonType == MouseOut) {
            for (id item in self.subviews) {
                [item setAlphaValue:1.0];
            }
        }
    });

    [_imageLayer setHidden:YES];
    [_titleLayer setHidden:YES];
}

-(void)mouseEntered:(NSEvent *)theEvent{
    [self setupLayer];
    _buttonType = MouseEnter;
    for (id item in self.subviews) {
        [item setAlphaValue:0.04];
    }
    [_imageLayer setHidden:NO];
    [_titleLayer setHidden:NO];
    [_imageLayer removeAllAnimations];
    [_titleLayer removeAllAnimations];
    
    CAAnimation *animation = [IMBAnimation moveY:0.5 X:@0 Y:@-10 repeatCount:0];
    [_imageLayer addAnimation:animation forKey:@"1"];
    
    CAAnimation *animation2 = [IMBAnimation moveY:0.65 X:@0 Y:@-14 repeatCount:0];
    [_titleLayer addAnimation:animation2 forKey:@"1"];
    
    [self setNeedsDisplay:YES];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if ([_bgAnimationLayer animationForKey:@"bgscal"] == anim) {
            [_bgAnimationLayer setHidden:YES];
        }
    }
}

- (void)dealloc {
    if (_imageLayer) {
        [_imageLayer release];
        _imageLayer = nil;
    }
    if (_titleLayer) {
        [_titleLayer release];
        _titleLayer = nil;
    }
    if (_bgAnimationLayer) {
        [_bgAnimationLayer release];
        _bgAnimationLayer = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end

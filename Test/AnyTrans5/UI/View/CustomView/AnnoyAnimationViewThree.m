//
//  AnnoyAnimationViewThree.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-9-22.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "AnnoyAnimationViewThree.h"
#import "CALayer+Animation.h"
#import "IMBAnimation.h"
#import "StringHelper.h"
@implementation AnnoyAnimationViewThree

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    _bglayer = [[CALayer layer] retain];
    [_bglayer setAnchorPoint:CGPointMake(0, 0)];
    [_bglayer setMasksToBounds:YES];
    [_bglayer setFrame:NSRectToCGRect(self.bounds)];
    _bglayer.contents = [StringHelper imageNamed:@"annoy_bg_three"];
    
    _maskLayer = [[CALayer layer] retain];
    [_maskLayer setAnchorPoint:CGPointMake(0, 0)];
    [_maskLayer setMasksToBounds:YES];
    [_maskLayer setFrame:NSRectToCGRect(self.bounds)];
    _maskLayer.contents = [StringHelper imageNamed:@"annoy_mask"];
    
    _freecarBGLayer = [[CALayer layer] retain];
    [_freecarBGLayer setAnchorPoint:CGPointMake(0, 0)];
    [_freecarBGLayer setMasksToBounds:YES];
    [_freecarBGLayer setFrame:CGRectMake(-168, 54, 168, 130)];
    
    _toolLayer = [[CALayer layer] retain];
    [_toolLayer setAnchorPoint:CGPointMake(0, 0)];
    [_toolLayer setFrame:CGRectMake(103, 60, 64, 10)];
    _toolLayer.contents = [StringHelper imageNamed:@"annoy_tool_three"];
    
    _fileLayer = [[CALayer layer] retain];
    [_fileLayer setAnchorPoint:CGPointMake(0, 0)];
    [_fileLayer setFrame:CGRectMake(114, 70, 50, 46)];
    _fileLayer.contents = [StringHelper imageNamed:@"annoy_file_three"];
    
    _freecarLayer = [[CALayer layer] retain];
    [_freecarLayer setAnchorPoint:CGPointMake(0, 0)];
    [_freecarLayer setFrame:CGRectMake(0, 0, 104, 100)];
    _freecarLayer.contents = [StringHelper imageNamed:@"annoy_car_three"];
    _backfreecarwheelLayer = [[CALayer layer] retain];
    [_backfreecarwheelLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_backfreecarwheelLayer setFrame:CGRectMake(10, 6, 22, 22)];
    _backfreecarwheelLayer.contents = [StringHelper imageNamed:@"annoy_carwheel_three"];
    _frontfreecarwheelLayer = [[CALayer layer] retain];
    [_frontfreecarwheelLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_frontfreecarwheelLayer setFrame:CGRectMake(75, 6, 22, 22)];
    _frontfreecarwheelLayer.contents = [StringHelper imageNamed:@"annoy_carwheel_three"];
    [_freecarLayer addSublayer:_backfreecarwheelLayer];
    [_freecarLayer addSublayer:_frontfreecarwheelLayer];
    [_freecarBGLayer addSublayer:_freecarLayer];
    [_freecarBGLayer addSublayer:_toolLayer];
    [_freecarBGLayer addSublayer:_fileLayer];
    
    _vipcarLayer = [[CALayer layer] retain];
    [_vipcarLayer setAnchorPoint:CGPointMake(0, 0)];
    [_vipcarLayer setFrame:CGRectMake(230, 50, 520, 144)];
    _vipcarLayer.contents = [StringHelper imageNamed:@"annoy_vipcar_three"];
    _vipcarwheelLayer1 = [[CALayer layer] retain];
    [_vipcarwheelLayer1 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer1 setFrame:CGRectMake(122, 10, 30, 30)];
    _vipcarwheelLayer1.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_three"];
    _vipcarwheelLayer2 = [[CALayer layer] retain];
    [_vipcarwheelLayer2 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer2 setFrame:CGRectMake(160, 10, 30, 30)];
    _vipcarwheelLayer2.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_three"];
    _vipcarwheelLayer3 = [[CALayer layer] retain];
    [_vipcarwheelLayer3 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer3 setFrame:CGRectMake(320, 10, 30, 30)];
    _vipcarwheelLayer3.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_three"];
    _vipcarwheelLayer4 = [[CALayer layer] retain];
    [_vipcarwheelLayer4 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer4 setFrame:CGRectMake(358, 10, 30, 30)];
    _vipcarwheelLayer4.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_three"];
    _vipcarwheelLayer5 = [[CALayer layer] retain];
    [_vipcarwheelLayer5 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer5 setFrame:CGRectMake(474, 10, 30, 30)];
    _vipcarwheelLayer5.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_three"];
    [_vipcarLayer addSublayer:_vipcarwheelLayer1];
    [_vipcarLayer addSublayer:_vipcarwheelLayer2];
    [_vipcarLayer addSublayer:_vipcarwheelLayer3];
    [_vipcarLayer addSublayer:_vipcarwheelLayer4];
    [_vipcarLayer addSublayer:_vipcarwheelLayer5];
    [_bglayer addSublayer:_freecarBGLayer];
    [_bglayer addSublayer:_vipcarLayer];
    [_bglayer addSublayer:_maskLayer];
    [self.layer addSublayer:_bglayer];
}

- (void)startAnimation
{
    [self animation1];
}

- (void)animation1
{
    [_toolLayer removeAllAnimations];
    float circleTime = 0.8;
    [_backfreecarwheelLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    [_frontfreecarwheelLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    [_fileLayer setHidden:NO];
    [IMBAnimation resumeAnimation:_backfreecarwheelLayer];
    [IMBAnimation resumeAnimation:_frontfreecarwheelLayer];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
        CGMutablePathRef path1 = CGPathCreateMutable();
        CGPathMoveToPoint(path1, &transform, -168,_freecarBGLayer.frame.origin.y);
        CGPathAddLineToPoint(path1, &transform,211, _freecarBGLayer.frame.origin.y);
        CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation1.duration = 5.0;
        animation1.fillMode = kCAFillModeForwards;
        animation1.repeatCount = 1;
        animation1.removedOnCompletion = NO;
        animation1.autoreverses = NO;
        animation1.path = path1;
        CGPathRelease(path1);
        [_freecarBGLayer addAnimation:animation1 forKey:@"vipcarLayer"];
    } completionHandler:^{
        [_fileLayer setHidden:YES];
        if (!_isStop) {
            [self animation2];
        }
    }];

}

- (void)animation2
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
        CGMutablePathRef path1 = CGPathCreateMutable();
        CGPathMoveToPoint(path1, &transform, _toolLayer.frame.origin.x,_toolLayer.frame.origin.y);
        CGPathAddLineToPoint(path1, &transform,_toolLayer.frame.origin.x, _toolLayer.frame.origin.y - 25);
        CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation1.duration = 5.0;
        animation1.fillMode = kCAFillModeForwards;
        animation1.repeatCount = 1;
        animation1.removedOnCompletion = NO;
        animation1.autoreverses = NO;
        animation1.path = path1;
        CGPathRelease(path1);
        [_toolLayer addAnimation:animation1 forKey:@"vipcarLayer"];
        [IMBAnimation pauseAnimation:_backfreecarwheelLayer];
        [IMBAnimation pauseAnimation:_frontfreecarwheelLayer];
    } completionHandler:^{
        if (!_isStop) {
            [self animation3];
        }
    }];
}

- (void)animation3
{
    [_backfreecarwheelLayer animateKey:@"transform.rotation.z"  fromValue:@(-2*M_PI) toValue:@(0) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = 0.8;
    }];
    [_frontfreecarwheelLayer animateKey:@"transform.rotation.z"  fromValue:@(-2*M_PI) toValue:@(0) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = 0.8;
    }];
    [IMBAnimation resumeAnimation:_backfreecarwheelLayer];
    [IMBAnimation resumeAnimation:_frontfreecarwheelLayer];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
        CGMutablePathRef path1 = CGPathCreateMutable();
        CGPathMoveToPoint(path1, &transform, 211,_freecarBGLayer.frame.origin.y);
        CGPathAddLineToPoint(path1, &transform,-168, _freecarBGLayer.frame.origin.y);
        CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation1.duration = 5.0;
        animation1.fillMode = kCAFillModeForwards;
        animation1.repeatCount = 1;
        animation1.removedOnCompletion = NO;
        animation1.autoreverses = NO;
        animation1.path = path1;
        CGPathRelease(path1);
        [_freecarBGLayer addAnimation:animation1 forKey:@"vipcarLayer"];
        
    } completionHandler:^{
        if (!_isStop) {
            [self animation1];
        }
    }];
}

- (void)stopAnimation
{
    _isStop = YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)dealloc
{
    [_bglayer release],_bglayer = nil;
    [_freecarBGLayer release],_freecarBGLayer = nil;
    [_freecarLayer release],_freecarLayer = nil;
    [_backfreecarwheelLayer release],_backfreecarwheelLayer = nil;
    [_frontfreecarwheelLayer release],_frontfreecarwheelLayer = nil;
    [_vipcarLayer release],_vipcarLayer = nil;
    [_vipcarwheelLayer1 release],_vipcarwheelLayer1 = nil;
    [_vipcarwheelLayer2 release],_vipcarwheelLayer2 = nil;
    [_vipcarwheelLayer3 release],_vipcarwheelLayer3 = nil;
    [_vipcarwheelLayer4 release],_vipcarwheelLayer4 = nil;
    [_vipcarwheelLayer5 release],_vipcarwheelLayer5 = nil;
    [_maskLayer release],_maskLayer = nil;
    [_fileLayer release],_fileLayer = nil;
    [_toolLayer release],_toolLayer = nil;
    [super dealloc];
}


@end

//
//  CarAnimationView.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "CarAnimationView.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
@implementation CarAnimationView

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
    _bgLayer = [[CALayer layer] retain];
    [_bgLayer setAnchorPoint:CGPointMake(0, 0)];
    [_bgLayer setMasksToBounds:YES];
    [_bgLayer setFrame:NSRectToCGRect(self.bounds)];
    
    _bgimageLayer1 = [[CALayer layer] retain];
    [_bgimageLayer1 setAnchorPoint:CGPointMake(0, 0)];
    [_bgimageLayer1 setFrame:CGRectMake(0, 48, 1500, 200)];
    _bgimageLayer1.contents = [StringHelper imageNamed:@"car_animation_bg"];
    
    _bgimageLayer2 = [[CALayer layer] retain];
    [_bgimageLayer2 setAnchorPoint:CGPointMake(0, 0)];
    [_bgimageLayer2 setFrame:CGRectMake(1500, 48, 1500, 200)];
    _bgimageLayer2.contents = [StringHelper imageNamed:@"car_animation_bg"];
    
    _lineLayer1 = [[CALayer layer] retain];
    [_lineLayer1 setAnchorPoint:CGPointMake(0, 0)];
    [_lineLayer1 setFrame:CGRectMake(0, 22, 1920, 1)];
    _lineLayer1.contents = [StringHelper imageNamed:@"car_animation_line"];
    
    _lineLayer2 = [[CALayer layer] retain];
    [_lineLayer2 setAnchorPoint:CGPointMake(0, 0)];
    [_lineLayer2 setFrame:CGRectMake(1920, 22, 1920, 1)];
    _lineLayer2.contents = [StringHelper imageNamed:@"car_animation_line"];
    
    _carLayer = [[CALayer layer] retain];
    [_carLayer setAnchorPoint:CGPointMake(0, 0)];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_carLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 250)/2) + 2, 20, 250, 112)];
    }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        [_carLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 250)/2) + 2, 20, 250, 166)];
    }else {
        [_carLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 250)/2), 16, 250, 100)];
    }
    _carLayer.contents = [StringHelper imageNamed:@"car_animation_car"];

    _backwheelLayer = [[CALayer layer] retain];
    [_backwheelLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        [_backwheelLayer setFrame:CGRectMake(29, 2, 38, 38)];
    }else {
        [_backwheelLayer setFrame:CGRectMake(31, 8, 38, 38)];
    }
    _backwheelLayer.contents = [StringHelper imageNamed:@"car_animation_wheel"];
    
    _frontwheelLayer = [[CALayer layer] retain];
    [_frontwheelLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        [_frontwheelLayer setFrame:CGRectMake(250 - 59, 2, 38, 38)];
    }else {
        [_frontwheelLayer setFrame:CGRectMake(250 - 79, 8, 38, 38)];
    }
    _frontwheelLayer.contents = [StringHelper imageNamed:@"car_animation_wheel"];
    
    _groundLayer = [[CALayer layer] retain];
    [_groundLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_groundLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 664)/2), 0, 664, 48)];
    _groundLayer.contents = [StringHelper imageNamed:@"car_animation_ground"];
    
    _maskLayer = [[CALayer layer] retain];
    [_maskLayer setAnchorPoint:CGPointMake(0, 0)];
    [_maskLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 1000)/2), ceil((NSHeight(self.frame) - 350)/2), 1000, 350)];
    _maskLayer.contents = [StringHelper imageNamed:@"car_animation_mask"];
    
    _envelopeBackground = [[CALayer layer] retain];
    [_envelopeBackground setAnchorPoint:CGPointMake(0, 0)];
    [_envelopeBackground setFrame:CGRectMake(0, 22, NSWidth(self.frame), NSHeight(self.frame) - 22)];
    [_envelopeBackground setMasksToBounds:YES];
    
    _envelopeLayer1 = [[CALayer layer] retain];
    [_envelopeLayer1 setAnchorPoint:CGPointMake(0, 0)];
    [_envelopeLayer1 setFrame:CGRectMake(0, -108,108,108)];
    _envelopeLayer1.contents = [StringHelper imageNamed:@"car_animation_envelope1"];
    
    _categoryLayer = [[CALayer layer] retain];
    [_categoryLayer setAnchorPoint:CGPointMake(0, 0)];
    [_categoryLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_envelopeLayer1.frame)) - 62)/2.0),ceil((NSHeight(NSRectFromCGRect(_envelopeLayer1.frame)) - 62)/2.0),62,62)];
    
    _envelopeLayer2 = [[CALayer layer] retain];
    [_envelopeLayer2 setAnchorPoint:CGPointMake(0, 0)];
    [_envelopeLayer2 setFrame:CGRectMake(0, 0,108,108)];
    _envelopeLayer2.contents = [StringHelper imageNamed:@"car_animation_envelope2"];
    [_envelopeLayer1 addSublayer:_categoryLayer];
    [_envelopeLayer1 addSublayer:_envelopeLayer2];
    
    [_carLayer addSublayer:_backwheelLayer];
    [_carLayer addSublayer:_frontwheelLayer];
    [_bgLayer addSublayer:_lineLayer1];
    [_bgLayer addSublayer:_lineLayer2];
    [_bgLayer addSublayer:_bgimageLayer1];
    [_bgLayer addSublayer:_bgimageLayer2];
    [_bgLayer addSublayer:_groundLayer];
    [_bgLayer addSublayer:_carLayer];
    [_bgLayer addSublayer:_envelopeBackground];
    [_bgLayer addSublayer:_maskLayer];
    [self.layer addSublayer:_bgLayer];
}

- (void)setCategoryImage:(NSImage *)image
{
    _categoryLayer.contents = image;
}

- (void)startAnimation
{
    [_backwheelLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = 1.0;
    }];
    
    [_frontwheelLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = 1.0;
    }];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, &transform, 0, _bgimageLayer1.frame.origin.y);
    CGPathAddLineToPoint(path1, &transform,-1500, _bgimageLayer1.frame.origin.y);
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation1.duration = 7.0;
    animation1.fillMode = kCAFillModeForwards;
    animation1.repeatCount = NSIntegerMax;
    animation1.removedOnCompletion = NO;
    animation1.autoreverses = NO;
    animation1.path = path1;
    CGPathRelease(path1);
    [_bgimageLayer1 addAnimation:animation1 forKey:@"bgimageLayer1"];
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, &transform, 1500, _bgimageLayer2.frame.origin.y);
    CGPathAddLineToPoint(path2, &transform,0, _bgimageLayer2.frame.origin.y);
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation2.duration = 7.0;
    animation2.fillMode = kCAFillModeForwards;
    animation2.repeatCount = NSIntegerMax;
    animation2.removedOnCompletion = NO;
    animation2.autoreverses = NO;
    animation2.path = path2;
    CGPathRelease(path2);
    [_bgimageLayer2 addAnimation:animation2 forKey:@"bgimageLayer2"];
    
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, &transform, 0, _lineLayer1.frame.origin.y);
    CGPathAddLineToPoint(path3, &transform,-1920, _lineLayer1.frame.origin.y);
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation3.duration = 7.0;
    animation3.fillMode = kCAFillModeForwards;
    animation3.repeatCount = NSIntegerMax;
    animation3.removedOnCompletion = NO;
    animation3.autoreverses = NO;
    animation3.path = path3;
    CGPathRelease(path3);
    [_lineLayer1 addAnimation:animation3 forKey:@"lineLayer1"];
    
    CGMutablePathRef path4 = CGPathCreateMutable();
    CGPathMoveToPoint(path4, &transform, 1920, _lineLayer2.frame.origin.y);
    CGPathAddLineToPoint(path4, &transform,0, _lineLayer2.frame.origin.y);
    CAKeyframeAnimation *animation4 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation4.duration = 7.0;
    animation4.fillMode = kCAFillModeForwards;
    animation4.repeatCount = NSIntegerMax;
    animation4.removedOnCompletion = NO;
    animation4.autoreverses = NO;
    animation4.path = path4;
    CGPathRelease(path4);
    [_lineLayer2 addAnimation:animation4 forKey:@"lineLayer2"];
}

- (void)stopAnimation
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_carLayer animateKey:@"opacity" fromValue:@1.0 toValue:@0.0 customize:^(CABasicAnimation *animation) {
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.duration = 0.3;
            
        }];
        [_bgimageLayer1 removeAllAnimations];
        [_bgimageLayer2 removeAllAnimations];
        [_lineLayer1 removeAllAnimations];
        [_lineLayer2 removeAllAnimations];
    } completionHandler:^{
        [_carLayer removeAllAnimations];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_envelopeBackground addSublayer:_envelopeLayer1];
            CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            keyframeAnimation.duration = 0.6;
            keyframeAnimation.repeatCount = 1;
            keyframeAnimation.removedOnCompletion = NO;
            keyframeAnimation.fillMode = kCAFillModeBoth;
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, &transform, ceilf((NSWidth(self.frame) - 108)/2.0), -108);
            CGPathAddLineToPoint(path, &transform, ceilf((NSWidth(self.frame) - 108)/2.0), 40);
            keyframeAnimation.path = path;
            CGPathRelease(path);
            [_envelopeLayer1 addAnimation:keyframeAnimation forKey:@"animabar"];
            
        } completionHandler:^{
            CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            keyframeAnimation.duration = 0.3;
            keyframeAnimation.repeatCount = 1;
            keyframeAnimation.removedOnCompletion = NO;
            keyframeAnimation.fillMode = kCAFillModeBoth;
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, &transform, ceilf((NSWidth(self.frame) - 108)/2.0), 40);
            CGPathAddLineToPoint(path, &transform, ceilf((NSWidth(self.frame) - 108)/2.0), 0);
            keyframeAnimation.path = path;
            CGPathRelease(path);
            [_envelopeLayer1 addAnimation:keyframeAnimation forKey:@"animabar1"];
        }];
    }];
}

- (void)dealloc
{
    [_envelopeLayer1 removeAllAnimations];
    [_bgLayer release],_bgLayer = nil;
    [_bgimageLayer1 release],_bgimageLayer1 = nil;
    [_bgimageLayer2 release],_bgimageLayer2 = nil;
    [_carLayer release],_carLayer = nil;
    [_backwheelLayer release],_backwheelLayer = nil;
    [_frontwheelLayer release],_frontwheelLayer = nil;
    [_groundLayer release],_groundLayer = nil;
    [_lineLayer1 release],_lineLayer1 = nil;
    [_lineLayer2 release],_lineLayer2 = nil;
    [_maskLayer release],_maskLayer = nil;
    [_envelopeBackground release],_envelopeBackground = nil;
    [_envelopeLayer1 release],_envelopeLayer1 = nil;
    [_envelopeLayer2 release],_envelopeLayer2 = nil;
    [_categoryLayer release],_categoryLayer = nil;
    [super dealloc];
}

@end

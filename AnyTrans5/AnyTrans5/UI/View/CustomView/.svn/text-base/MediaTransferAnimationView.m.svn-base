//
//  MediaTransferAnimationView.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-8.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "MediaTransferAnimationView.h"
#import "CALayer+Animation.h"
#import "StringHelper.h"
@implementation MediaTransferAnimationView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setWantsLayer:YES];
    _bglayer = [[CALayer layer] retain];
    [_bglayer setAnchorPoint:CGPointMake(0, 0)];
    [_bglayer setFrame:NSRectToCGRect(self.bounds)];
    _bglayer.contents = [StringHelper imageNamed:@"transfer_music_bg"];
    
    _peoplelayer = [[CALayer layer] retain];
    [_peoplelayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_peoplelayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 128)/2.0), 48, 128,176)];
    _peoplelayer.contents = [StringHelper imageNamed:@"transfer_people"];
    _cdBackground = [[CALayer layer] retain];
    [_cdBackground setAnchorPoint:CGPointMake(0, 0)];
    [_cdBackground setFrame:CGRectMake(0, 44, NSWidth(self.frame), NSHeight(self.frame) - 58)];
    [_cdBackground setMasksToBounds:YES];
    
    _cdlayer = [[CALayer layer] retain];
    [_cdlayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_cdlayer setFrame:CGRectMake(59, ceil((NSHeight(NSRectFromCGRect(_peoplelayer.frame)) - 48)/2)+28, 48, 48)];
    _cdlayer.contents = [StringHelper imageNamed:@"transfer_music_cd"];
    
    _musiclayer1 = [[CALayer layer] retain];
    [_musiclayer1 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_musiclayer1 setFrame:CGRectMake(0, 0, 20, 20)];
    _musiclayer1.contents = [StringHelper imageNamed:@"transfer_music"];
    
    _musiclayer2 = [[CALayer layer] retain];
    [_musiclayer2 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_musiclayer2 setFrame:CGRectMake(0, 0, 20, 20)];
    _musiclayer2.contents = [StringHelper imageNamed:@"transfer_music"];
    
    _musiclayer3 = [[CALayer layer] retain];
    [_musiclayer3 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_musiclayer3 setFrame:CGRectMake(0, 0, 20, 20)];
    _musiclayer3.contents = [StringHelper imageNamed:@"transfer_music"];
    [_peoplelayer addSublayer:_cdlayer];
    [_bglayer addSublayer:_peoplelayer];
    [_bglayer addSublayer:_cdBackground];
    [self.layer addSublayer:_bglayer];
    
    _compeleteCD = [[CALayer layer] retain];
    [_compeleteCD setFrame:CGRectMake(0, -114, 162, 114)];
    [_compeleteCD setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_compeleteCD setPosition:CGPointMake(ceilf(NSWidth(self.frame)/2.0), 50)];
    _compeleteCD.contents = [StringHelper imageNamed:@"transfer_compelete_CD"];

}

- (void)startAnimation
{
    [_cdlayer removeAllAnimations];
    [_cdlayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = 5.0;
    }];
    [_bglayer addSublayer:_musiclayer1];
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, &transform, 425, 118);
    CGPathAddCurveToPoint(path1, &transform, 405, 280, 100, 100, 320, 370);
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation1.duration = 6.0;
    animation1.fillMode = kCAFillModeForwards;
    animation1.repeatCount = NSIntegerMax;
    animation1.removedOnCompletion = NO;
    animation1.autoreverses = NO;
    animation1.path = path1;
    CGPathRelease(path1);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, &transform, 425, 118);
    CGPathAddCurveToPoint(path2, &transform, 415, 310, 200, 100, 350, 370);
    CAKeyframeAnimation *animation12 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation12.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation12.duration = 6.0;
    animation12.fillMode = kCAFillModeForwards;
    animation12.repeatCount = NSIntegerMax;
    animation12.removedOnCompletion = NO;
    animation12.autoreverses = NO;
    animation12.path = path2;
    CGPathRelease(path2);
    
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, &transform, 425, 118);
    CGPathAddCurveToPoint(path3, &transform, 425, 330, 150, 100, 425, 370);
    CAKeyframeAnimation *animation13 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation13.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation13.duration = 6.0;
    animation13.fillMode = kCAFillModeForwards;
    animation13.repeatCount = NSIntegerMax;
    animation13.removedOnCompletion = NO;
    animation13.autoreverses = NO;
    animation13.path = path3;
    CGPathRelease(path3);
   
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation2.fromValue = @(0);
    animation2.toValue = @(-1*M_PI);
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation2.duration = 5.0;
    animation2.autoreverses = NO;
    animation2.removedOnCompletion = NO;
    animation2.repeatCount = NSIntegerMax;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = YES;
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation3.fromValue = @(1.0);
    animation3.toValue = @(0);
    [animation3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation3.duration = 5.0;
    animation3.autoreverses = NO;
    animation3.removedOnCompletion = NO;
    animation3.repeatCount = NSIntegerMax;
    animation3.fillMode = kCAFillModeForwards;
    animation3.removedOnCompletion = YES;
    
    CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation4.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
    animation4.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    [animation4 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation4.duration = 5.0;
    animation4.autoreverses = NO;
    animation4.removedOnCompletion = NO;
    animation4.repeatCount = NSIntegerMax;
    animation4.fillMode = kCAFillModeForwards;
    animation4.removedOnCompletion = YES;
    
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group1.duration = 5.0;
    group1.autoreverses = NO;
    group1.removedOnCompletion = NO;
    group1.repeatCount = NSIntegerMax;
    group1.animations = [NSArray arrayWithObjects:animation1,animation2,animation3,animation4, nil];
    
    CAAnimationGroup *group2 = [CAAnimationGroup animation];
    group2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group2.duration = 5.0;
    group2.autoreverses = NO;
    group2.removedOnCompletion = NO;
    group2.repeatCount = NSIntegerMax;
    group2.animations = [NSArray arrayWithObjects:animation12,animation2,animation3,animation4, nil];
    
    CAAnimationGroup *group3 = [CAAnimationGroup animation];
    group3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group3.duration = 5.0;
    group3.autoreverses = NO;
    group3.removedOnCompletion = NO;
    group3.repeatCount = NSIntegerMax;
    group3.animations = [NSArray arrayWithObjects:animation13,animation2,animation3,animation4, nil];
    
    [_musiclayer1 addAnimation:group1 forKey:@"music1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_bglayer addSublayer:_musiclayer2];
        [_musiclayer2 addAnimation:group2 forKey:@"music2"];

    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_bglayer addSublayer:_musiclayer3];
        [_musiclayer3 addAnimation:group3 forKey:@"music3"];
    });
    
}


- (void)stopAnimation
{
    [self performSelectorOnMainThread:@selector(stop) withObject:nil waitUntilDone:NO];
}

- (void)stop
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_peoplelayer animateKey:@"opacity" fromValue:@1.0 toValue:@0.0 customize:^(CABasicAnimation *animation) {
            animation.removedOnCompletion = YES;
            animation.fillMode = kCAFillModeForwards;
            animation.duration = 0.3;
            
        }];
        [_musiclayer1 setHidden:YES];
        [_musiclayer2 setHidden:YES];
        [_musiclayer3 setHidden:YES];
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_cdBackground addSublayer:_compeleteCD];
            CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            keyframeAnimation.duration = 0.6;
            keyframeAnimation.repeatCount = 1;
            keyframeAnimation.removedOnCompletion = NO;
            keyframeAnimation.fillMode = kCAFillModeBoth;
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), -114);
            CGPathAddLineToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), 100);
            keyframeAnimation.path = path;
            CGPathRelease(path);
            [_compeleteCD addAnimation:keyframeAnimation forKey:@"animabar"];
            
        } completionHandler:^{
            [_musiclayer1 removeAllAnimations];
            [_musiclayer2 removeAllAnimations];
            [_musiclayer3 removeAllAnimations];
            [_musiclayer1 removeFromSuperlayer];
            [_musiclayer2 removeFromSuperlayer];
            [_musiclayer3 removeFromSuperlayer];

            CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            keyframeAnimation.duration = 0.3;
            keyframeAnimation.repeatCount = 1;
            keyframeAnimation.removedOnCompletion = NO;
            keyframeAnimation.fillMode = kCAFillModeBoth;
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), 100);
            CGPathAddLineToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), 57);
            keyframeAnimation.path = path;
            CGPathRelease(path);
            [_compeleteCD addAnimation:keyframeAnimation forKey:@"animabar1"];
        }];
    }];

}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (void)dealloc
{
    [_compeleteCD removeAllAnimations];
    [_cdBackground release],_cdBackground = nil;
    [_bglayer release],_bglayer = nil;
    [_cdlayer release],_cdlayer = nil;
    [_peoplelayer release],_peoplelayer = nil;
    [_musiclayer1 release],_musiclayer1 = nil;
    [_musiclayer2 release],_musiclayer2 = nil;
    [_musiclayer3 release],_musiclayer3 = nil;
    [super dealloc];
   
}

@end

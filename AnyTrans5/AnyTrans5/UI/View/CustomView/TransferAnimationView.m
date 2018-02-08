//
//  TransferAnimationView.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-6.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "TransferAnimationView.h"
#import "CALayer+Animation.h"
#import "StringHelper.h"
@implementation TransferAnimationView

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
    _bglayer.contents = [StringHelper imageNamed:@"transfer_animation_bg"];
    [_bglayer setMasksToBounds:YES];
    
    _cdBackground = [[CALayer layer] retain];
    [_cdBackground setAnchorPoint:CGPointMake(0, 0)];
    [_cdBackground setFrame:CGRectMake(0, 58, NSWidth(self.frame), NSHeight(self.frame) - 58)];
    [_cdBackground setMasksToBounds:YES];
    
    _windmillbody = [[CALayer layer] retain];
    [_windmillbody setAnchorPoint:CGPointMake(0, 0)];
    [_windmillbody setFrame:CGRectMake(ceilf((NSWidth(self.frame) - 83)/2.0), 58, 83, 151)];
    _windmillbody.contents = [StringHelper imageNamed:@"transfer_windmill_body"];
    
    _windmillheader = [[CALayer layer] retain];
    [_windmillheader setFrame:CGRectMake(0, 0, 235, 232)];
    [_windmillheader setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_windmillheader setPosition:CGPointMake(ceilf(NSWidth(self.frame)/2.0), 174 -2)];
    _windmillheader.contents = [StringHelper imageNamed:@"transfer_windmill_header"];
    
    _compeleteCD = [[CALayer layer] retain];
    [_compeleteCD setFrame:CGRectMake(0, -114, 114, 114)];
    [_compeleteCD setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_compeleteCD setPosition:CGPointMake(ceilf(NSWidth(self.frame)/2.0), 50)];
//    _compeleteCD.contents = [StringHelper imageNamed:@"transfer_compelete_CD"];

    _categoryLayer = [[CALayer layer] retain];
    [_categoryLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_categoryLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_compeleteCD.frame)) - 62)/2.0),44,62,62)];
    _categoryLayer.contents = [StringHelper imageNamed:@"btn_appsnew1"];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue= [NSNumber numberWithFloat:M_PI/3];
    animation.duration= 0;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= 1;
    [_categoryLayer addAnimation:animation forKey:@""];
    
    [_compeleteCD addSublayer:_categoryLayer];
    
    CALayer *layer = [[CALayer layer] retain];
    [layer setAnchorPoint:CGPointMake(0, 0)];
    [layer setFrame:CGRectMake(0, 0, 114, 74)];
    layer.contents = [StringHelper imageNamed:@"transfer_animation_complete"];
    [_compeleteCD addSublayer:layer];
    [layer release];
    
    [_bglayer addSublayer:_windmillbody];
    [_bglayer addSublayer:_windmillheader];
    [_bglayer addSublayer:_cdBackground];
    [self.layer addSublayer:_bglayer];

}

- (void)setCategoryImage:(NSImage *)image
{
    _categoryLayer.contents = image;
}

- (void)startAnimation
{
    [_windmillheader animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = 2.0;
    }];
}

- (void)stopAnimation
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_windmillheader animateKey:@"opacity" fromValue:@1.0 toValue:@0.0 customize:^(CABasicAnimation *animation) {
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.duration = 0.3;
            
        }];
        [_windmillbody animateKey:@"opacity" fromValue:@1.0 toValue:@0.0 customize:^(CABasicAnimation *animation) {
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.duration = 0.3;
            
        }];
    } completionHandler:^{
        [_windmillheader removeAllAnimations];
        [_windmillbody removeAllAnimations];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_cdBackground addSublayer:_compeleteCD];
            CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            //        keyframeAnimation.values = @[@0,@(129),@(62)];
            //        keyframeAnimation.keyTimes = @[@0,@0.8,@1];
            keyframeAnimation.duration = 0.6;
            keyframeAnimation.repeatCount = 1;
            keyframeAnimation.removedOnCompletion = NO;
            keyframeAnimation.fillMode = kCAFillModeBoth;
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), -114);
            CGPathAddLineToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), 100);
            //        CGPathAddLineToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), 62);
            keyframeAnimation.path = path;
            CGPathRelease(path);
            [_compeleteCD addAnimation:keyframeAnimation forKey:@"animabar"];
            
        } completionHandler:^{
            [_cdBackground addSublayer:_compeleteCD];
            CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            //        keyframeAnimation.values = @[@0,@(129),@(62)];
            //        keyframeAnimation.keyTimes = @[@0,@0.8,@1];
            keyframeAnimation.duration = 0.3;
            keyframeAnimation.repeatCount = 1;
            keyframeAnimation.removedOnCompletion = NO;
            keyframeAnimation.fillMode = kCAFillModeBoth;
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), 100);
            CGPathAddLineToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), 57);
            //        CGPathAddLineToPoint(path, &transform, ceilf(NSWidth(self.frame)/2.0), 62);
            keyframeAnimation.path = path;
            CGPathRelease(path);
            [_compeleteCD addAnimation:keyframeAnimation forKey:@"animabar1"];
            
        }];
        
    }];
}

- (void)dealloc
{
    [_compeleteCD removeAllAnimations];
    [_cdBackground release],_cdBackground = nil;
    [_bglayer release],_bglayer = nil;
    [_windmillbody release],_windmillbody = nil;
    [_windmillheader release],_windmillheader = nil;
    [_compeleteCD release],_compeleteCD = nil;
    [_categoryLayer release],_categoryLayer = nil;
    [super dealloc];
}
@end

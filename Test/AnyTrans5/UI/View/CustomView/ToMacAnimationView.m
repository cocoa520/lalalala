//
//  ToMacAnimationView.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-16.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "ToMacAnimationView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
@implementation ToMacAnimationView

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
    [_bglayer setFrame:NSRectToCGRect(self.bounds)];
    
    _sourceLayer = [[CALayer layer] retain];
    [_sourceLayer setAnchorPoint:CGPointMake(0, 0)];
    [_sourceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
    
    _targetLayer = [[CALayer layer] retain];
    [_targetLayer setAnchorPoint:CGPointMake(0, 0)];
    [_targetLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
    
    _dataLayer1 = [[CALayer layer] retain];
    [_dataLayer1 setAnchorPoint:CGPointMake(0, 0)];
    [_dataLayer1 setFrame:CGRectMake(30,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2)+40 , 68, 28)];
    _dataLayer1.contents = [StringHelper imageNamed:@"clone_data1"];
    
    _dataLayer2 = [[CALayer layer] retain];
    [_dataLayer2 setAnchorPoint:CGPointMake(0, 0)];
    [_dataLayer2 setFrame:CGRectMake(30,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2), 68, 28)];
    _dataLayer2.contents = [StringHelper imageNamed:@"clone_data2"];
    
    _dataLayer3 = [[CALayer layer] retain];
    [_dataLayer3 setAnchorPoint:CGPointMake(0, 0)];
    [_dataLayer3 setFrame:CGRectMake(30,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2)-40 , 68, 28)];
    _dataLayer3.contents = [StringHelper imageNamed:@"clone_data3"];
    
    [_bglayer addSublayer:_dataLayer1];
    [_bglayer addSublayer:_dataLayer2];
    [_bglayer addSublayer:_dataLayer3];
    [_dataLayer1 setHidden:YES];
    [_dataLayer2 setHidden:YES];
    [_dataLayer3 setHidden:YES];
    [self.layer addSublayer:_bglayer];
}

- (void)setSourceImage:(NSImage *)sourceImage targetImage:(NSImage *)targetImage
{
    _sourceLayer.contents = [sourceImage retain];
    _targetLayer.contents = [targetImage retain];
    [_sourceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) -  sourceImage.size.width)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - sourceImage.size.height)/2), sourceImage.size.width, sourceImage.size.height)];
     [_targetLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - targetImage.size.width)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - targetImage.size.height)/2),  targetImage.size.width, targetImage.size.height)];
    [_bglayer setFrame:NSRectToCGRect(self.bounds)];
}

- (void)resetDataLayer
{
    [_dataLayer1 setFrame:CGRectMake(30,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2)+35 , 68, 28)];
    [_dataLayer3 setFrame:CGRectMake(30,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2)-35 , 68, 28)];
}

- (void)startAnimation
{
    [_bglayer addSublayer:_sourceLayer];
    [_bglayer addSublayer:_targetLayer];
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(0.0);
    opacity.toValue = @(1.0);
    [opacity setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    opacity.duration = 1.0;
    opacity.autoreverses = NO;
    opacity.removedOnCompletion = NO;
    opacity.repeatCount = 1;
    opacity.fillMode = kCAFillModeForwards;
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef pathtoleft = CGPathCreateMutable();
    CGPathMoveToPoint(pathtoleft, &transform, _sourceLayer.frame.origin.x, _sourceLayer.frame.origin.y);
    CGPathAddLineToPoint(pathtoleft, &transform,0, _sourceLayer.frame.origin.y);
    CAKeyframeAnimation *animationtoleft = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animationtoleft.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationtoleft.duration = 1.0;
    animationtoleft.fillMode = kCAFillModeForwards;
    animationtoleft.repeatCount = 1;
    animationtoleft.removedOnCompletion = NO;
    animationtoleft.autoreverses = NO;
    animationtoleft.path = pathtoleft;
    CGPathRelease(pathtoleft);
    
    CGMutablePathRef pathtoright = CGPathCreateMutable();
    CGPathMoveToPoint(pathtoright, &transform, _targetLayer.frame.origin.x, _targetLayer.frame.origin.y);
    CGPathAddLineToPoint(pathtoright, &transform,_bglayer.frame.size.width - _targetLayer.frame.size.width , _targetLayer.frame.origin.y);
    CAKeyframeAnimation *animationtoright = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animationtoright.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationtoright.duration = 1.0;
    animationtoright.fillMode = kCAFillModeForwards;
    animationtoright.repeatCount = 1;
    animationtoright.removedOnCompletion = NO;
    animationtoright.autoreverses = NO;
    animationtoright.path = pathtoright;
    CGPathRelease(pathtoright);
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_sourceLayer addAnimation:opacity forKey:@"opacity"];
        [_sourceLayer addAnimation:animationtoleft forKey:@"position"];
        [_targetLayer addAnimation:opacity forKey:@"opacity"];
        [_targetLayer addAnimation:animationtoright forKey:@"position"];
    } completionHandler:^{
        [_dataLayer1 setHidden:NO];
        [_dataLayer2 setHidden:NO];
        [_dataLayer3 setHidden:NO];
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, &transform, 30, _dataLayer2.frame.origin.y);
        CGPathAddLineToPoint(path2, &transform,_bglayer.frame.size.width-100, _dataLayer2.frame.origin.y);
        CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation2.duration = 1.8;
        animation2.fillMode = kCAFillModeForwards;
        animation2.repeatCount = NSIntegerMax;
        animation2.removedOnCompletion = NO;
        animation2.autoreverses = NO;
        animation2.path = path2;
        CGPathRelease(path2);
        [_dataLayer2 addAnimation:animation2 forKey:@"data2"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
            CGMutablePathRef path1 = CGPathCreateMutable();
            CGPathMoveToPoint(path1, &transform, 30, _dataLayer1.frame.origin.y);
            CGPathAddLineToPoint(path1, &transform,_bglayer.frame.size.width-100, _dataLayer1.frame.origin.y);
            CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            animation1.duration = 1.8;
            animation1.fillMode = kCAFillModeForwards;
            animation1.repeatCount = NSIntegerMax;
            animation1.removedOnCompletion = NO;
            animation1.autoreverses = NO;
            animation1.path = path1;
            CGPathRelease(path1);
            [_dataLayer1 addAnimation:animation1 forKey:@"data1"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGMutablePathRef path3 = CGPathCreateMutable();
            CGPathMoveToPoint(path3, &transform, 30, _dataLayer3.frame.origin.y);
            CGPathAddLineToPoint(path3, &transform,_bglayer.frame.size.width-100, _dataLayer3.frame.origin.y);
            CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            animation3.duration = 1.8;
            animation3.fillMode = kCAFillModeForwards;
            animation3.repeatCount = NSIntegerMax;
            animation3.removedOnCompletion = NO;
            animation3.autoreverses = NO;
            animation3.path = path3;
            CGPathRelease(path3);
            [_dataLayer3 addAnimation:animation3 forKey:@"data3"];
        });
    }];
}

- (void)stopAnimation
{
    [_dataLayer1 removeAllAnimations];
    [_dataLayer2 removeAllAnimations];
    [_dataLayer3 removeAllAnimations];
    [_sourceLayer removeAllAnimations];
    [_targetLayer removeAllAnimations];
}


- (void)dealloc
{
    [_bglayer release],_bglayer = nil;
    [_sourceLayer release],_sourceLayer = nil;
    [_targetLayer release],_targetLayer = nil;
    [_dataLayer1 release],_dataLayer1 = nil;
    [_dataLayer2 release],_dataLayer2 = nil;
    [_dataLayer3 release],_dataLayer3 = nil;
    [super dealloc];

}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

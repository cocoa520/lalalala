//
//  BoatAnimationView.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "BoatAnimationView.h"
#import "CALayer+Animation.h"
#import "IMBAnimation.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
@implementation BoatAnimationView
//248
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
    //设置锚点
    [_bgLayer setAnchorPoint:CGPointMake(0, 0)];
    //是否裁剪
    [_bgLayer setMasksToBounds:YES];
    
    [_bgLayer setFrame:NSRectToCGRect(self.bounds)];
    
    _waveLayer = [[CALayer layer] retain];
    [_waveLayer setAnchorPoint:CGPointMake(0, 0)];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_waveLayer setFrame:CGRectMake(100, 10, 760, 64)];
    }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        [_waveLayer setFrame:CGRectMake(148, 16, 664, 48)];
    }else {
        [_waveLayer setFrame:CGRectMake(100, 10, 760, 64)];
    }
    _waveLayer.contents = [StringHelper imageNamed:@"boat_animation_wave"];
    
    _mountainLayer1 = [[CALayer layer] retain];
    [_mountainLayer1 setAnchorPoint:CGPointMake(0, 0)];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        [_mountainLayer1 setFrame:CGRectMake(0, 64, 1240, 204)];
    }else {
        [_mountainLayer1 setFrame:CGRectMake(0, 64, 1240, 24)];
    }
    _mountainLayer1.contents = [StringHelper imageNamed:@"boat_animation_mountain"];
    _mountainLayer2 = [[CALayer layer] retain];
    [_mountainLayer2 setAnchorPoint:CGPointMake(0, 0)];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        [_mountainLayer2 setFrame:CGRectMake(1240, 64, 1240, 204)];
    }else {
        [_mountainLayer2 setFrame:CGRectMake(1240, 64, 1240, 24)];
    }
    _mountainLayer2.contents = [StringHelper imageNamed:@"boat_animation_mountain"];
    
    _stoneLayer1 = [[CALayer layer] retain];
    [_stoneLayer1 setAnchorPoint:CGPointMake(0, 0)];
    [_stoneLayer1 setFrame:CGRectMake(0, 24, 1002, 30)];
    _stoneLayer1.contents = [StringHelper imageNamed:@"boat_animation_stone"];
    _stoneLayer2 = [[CALayer layer] retain];
    [_stoneLayer2 setAnchorPoint:CGPointMake(0, 0)];
    [_stoneLayer2 setFrame:CGRectMake(1002, 24, 1002, 30)];
    _stoneLayer2.contents = [StringHelper imageNamed:@"boat_animation_stone"];
    
    _boatLayer = [[CALayer layer] retain];
    [_boatLayer setAnchorPoint:CGPointMake(0.0, 0.0)];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_boatLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 138)/2), 6, 138, 162)];
    }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        [_boatLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 138)/2), 26, 138, 162)];
    }else {
        [_boatLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 138)/2), 56, 138, 162)];
    }
    _boatLayer.contents = [StringHelper imageNamed:@"boat_animation_boat"];
    
    _maskLayer = [[CALayer layer] retain];
    [_maskLayer setAnchorPoint:CGPointMake(0, 0)];
    [_maskLayer setFrame:CGRectMake(ceil((NSWidth(self.frame) - 999)/2), ceil((NSHeight(self.frame) - 349)/2), 999, 349)];
    _maskLayer.contents = [StringHelper imageNamed:@"car_animation_mask"];
    
    _cloudLayer1 = [[CALayer layer] retain];
    [_cloudLayer1 setAnchorPoint:CGPointMake(0, 0)];
    [_cloudLayer1 setFrame:CGRectMake(NSWidth(self.frame) - 250, NSHeight(self.frame) - 38 - 40, 68, 38)];
    _cloudLayer1.contents = [StringHelper imageNamed:@"boat_animation_cloud2"];
    
    _cloudLayer3 = [[CALayer layer] retain];
    [_cloudLayer3 setAnchorPoint:CGPointMake(0, 0)];
    [_cloudLayer3 setFrame:CGRectMake(NSWidth(self.frame) - 250 + 50, NSHeight(self.frame) - 38 - 40, 40, 24)];
    _cloudLayer3.contents = [StringHelper imageNamed:@"boat_animation_cloud1"];
    
    _cloudLayer2 = [[CALayer layer] retain];
    [_cloudLayer2 setAnchorPoint:CGPointMake(0, 0)];
    [_cloudLayer2 setFrame:CGRectMake(180, NSHeight(self.frame) - 38 - 90, 68, 38)];
    _cloudLayer2.contents = [StringHelper imageNamed:@"boat_animation_cloud2"];
    
    _cloudLayer4 = [[CALayer layer] retain];
    [_cloudLayer4 setAnchorPoint:CGPointMake(0, 0)];
    [_cloudLayer4 setFrame:CGRectMake(180 + 40, NSHeight(self.frame) - 38 - 90, 40, 24)];
    _cloudLayer4.contents = [StringHelper imageNamed:@"boat_animation_cloud1"];
    
    _cloudLayer5 = [[CALayer layer] retain];
    [_cloudLayer5 setAnchorPoint:CGPointMake(0, 0)];
    [_cloudLayer5 setFrame:CGRectMake(120, NSHeight(self.frame) - 38 - 40, 40, 24)];
    _cloudLayer5.contents = [StringHelper imageNamed:@"boat_animation_cloud1"];
    
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        _islandLayer = [[CALayer layer] retain];
        [_islandLayer setAnchorPoint:CGPointMake(0, 0)];
        [_islandLayer setFrame:CGRectMake(NSWidth(self.frame), 36, 82, 106)];

        _categoryLayer = [[CALayer layer] retain];
        [_categoryLayer setAnchorPoint:CGPointMake(0, 0)];
        [_categoryLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_islandLayer.frame)) - 62)/2.0) + 6,2,62,62)];
        _categoryLayer.contents = [StringHelper imageNamed:@"btn_appsnew1"];
        [_islandLayer addSublayer:_categoryLayer];
        
        CALayer *layer = [[CALayer layer] retain];
        [layer setAnchorPoint:CGPointMake(0, 0)];
        [layer setFrame:CGRectMake(0, 0, 82, 106)];
        layer.contents = [StringHelper imageNamed:@"boat_animation_compelete"];
        [_islandLayer addSublayer:layer];
        [layer release];
    }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        _islandLayer = [[CALayer layer] retain];
        [_islandLayer setAnchorPoint:CGPointMake(0, 0)];
        [_islandLayer setFrame:CGRectMake(NSWidth(self.frame), 36, 82, 106)];
        
        _categoryLayer = [[CALayer layer] retain];
        [_categoryLayer setAnchorPoint:CGPointMake(0, 0)];
        [_categoryLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_islandLayer.frame)) - 62)/2.0) + 6,2,62,62)];
        _categoryLayer.contents = [StringHelper imageNamed:@"btn_appsnew1"];
        [_islandLayer addSublayer:_categoryLayer];
        
        CALayer *layer = [[CALayer layer] retain];
        [layer setAnchorPoint:CGPointMake(0, 0)];
        [layer setFrame:CGRectMake(6, -6, 82, 106)];
        layer.contents = [StringHelper imageNamed:@"boat_animation_compelete"];
        [_islandLayer addSublayer:layer];
        [layer release];
    }else {
        _islandLayer = [[CALayer layer] retain];
        [_islandLayer setAnchorPoint:CGPointMake(0, 0)];
        [_islandLayer setFrame:CGRectMake(NSWidth(self.frame), 36, 188, 132)];
        _islandLayer.contents = [StringHelper imageNamed:@"boat_animation_compelete"];
        
        _categoryLayer = [[CALayer layer] retain];
        [_categoryLayer setAnchorPoint:CGPointMake(0, 0)];
        [_categoryLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_islandLayer.frame)) - 62)/2.0),ceil((NSHeight(NSRectFromCGRect(_islandLayer.frame)) - 62)/2.0),62,62)];
        _categoryLayer.contents = [StringHelper imageNamed:@"btn_appsnew1"];
        [_islandLayer addSublayer:_categoryLayer];
    }
    
    [_bgLayer addSublayer:_mountainLayer1];
    [_bgLayer addSublayer:_mountainLayer2];
    [_bgLayer addSublayer:_waveLayer];
    [_bgLayer addSublayer:_stoneLayer1];
    [_bgLayer addSublayer:_stoneLayer2];
    [_bgLayer addSublayer:_cloudLayer1];
    [_bgLayer addSublayer:_cloudLayer2];
    [_bgLayer addSublayer:_cloudLayer3];
    [_bgLayer addSublayer:_cloudLayer4];
    [_bgLayer addSublayer:_cloudLayer5];
    [_bgLayer addSublayer:_islandLayer];
    [_bgLayer addSublayer:_boatLayer];
    [_bgLayer addSublayer:_maskLayer];
    [self.layer addSublayer:_bgLayer];
}

- (void)setCategoryImage:(NSImage *)image
{
    _categoryLayer.contents = image;
}

- (void)startAnimation
{
    if (![[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] && ![[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        [_boatLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@((-M_PI)/80) customize:^(CABasicAnimation *animation) {
            animation.repeatCount = NSIntegerMax;
            animation.duration = 1.0;
            animation.autoreverses = YES;
        }];
    }

    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, &transform, 0, _mountainLayer1.frame.origin.y);
    CGPathAddLineToPoint(path1, &transform,-1240, _mountainLayer1.frame.origin.y);
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        animation1.duration = 6;
    }else {
        animation1.duration = 18.0;
    }
    animation1.fillMode = kCAFillModeForwards;
    animation1.repeatCount = NSIntegerMax;
    animation1.removedOnCompletion = NO;
    animation1.autoreverses = NO;
    animation1.path = path1;
    CGPathRelease(path1);
    [_mountainLayer1 addAnimation:animation1 forKey:@"mountainLayer1"];
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, &transform, 1240, _mountainLayer2.frame.origin.y);
    CGPathAddLineToPoint(path2, &transform,0, _mountainLayer2.frame.origin.y);
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        animation2.duration = 6;
    }else {
        animation2.duration = 18.0;
    }
    animation2.fillMode = kCAFillModeForwards;
    animation2.repeatCount = NSIntegerMax;
    animation2.removedOnCompletion = NO;
    animation2.autoreverses = NO;
    animation2.path = path2;
    CGPathRelease(path2);
    [_mountainLayer2 addAnimation:animation2 forKey:@"mountainLayer2"];
    
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, &transform, 0, _stoneLayer1.frame.origin.y);
    CGPathAddLineToPoint(path3, &transform,-1002, _stoneLayer1.frame.origin.y);
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        animation3.duration = 6;
    }else {
        animation3.duration = 18.0;
    }
    animation3.fillMode = kCAFillModeForwards;
    animation3.repeatCount = NSIntegerMax;
    animation3.removedOnCompletion = NO;
    animation3.autoreverses = NO;
    animation3.path = path3;
    CGPathRelease(path3);
    [_stoneLayer1 addAnimation:animation3 forKey:@"stoneLayer1"];
    
    CGMutablePathRef path4 = CGPathCreateMutable();
    CGPathMoveToPoint(path4, &transform, 1002, _stoneLayer2.frame.origin.y);
    CGPathAddLineToPoint(path4, &transform,0, _stoneLayer2.frame.origin.y);
    CAKeyframeAnimation *animation4 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
        animation4.duration = 6;
    }else {
        animation4.duration = 18.0;
    }
    animation4.fillMode = kCAFillModeForwards;
    animation4.repeatCount = NSIntegerMax;
    animation4.removedOnCompletion = NO;
    animation4.autoreverses = NO;
    animation4.path = path4;
    CGPathRelease(path4);
    [_stoneLayer2 addAnimation:animation4 forKey:@"stoneLayer2"];
    
    //给云加动画
    CGMutablePathRef path5 = CGPathCreateMutable();
    CGPathMoveToPoint(path5, &transform, _cloudLayer1.frame.origin.x+8, _cloudLayer1.frame.origin.y);
    CGPathAddLineToPoint(path5, &transform,_cloudLayer1.frame.origin.x-8, _cloudLayer1.frame.origin.y);
    CAKeyframeAnimation *animation5 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation5.duration = 4.0;
    animation5.fillMode = kCAFillModeForwards;
    animation5.repeatCount = NSIntegerMax;
    animation5.removedOnCompletion = NO;
    animation5.autoreverses = YES;
    animation5.path = path5;
    CGPathRelease(path5);
    [_cloudLayer1 addAnimation:animation5 forKey:@"cloudLayer1"];
    
    CGMutablePathRef path6 = CGPathCreateMutable();
    CGPathMoveToPoint(path6, &transform, _cloudLayer2.frame.origin.x+8, _cloudLayer2.frame.origin.y);
    CGPathAddLineToPoint(path6, &transform,_cloudLayer2.frame.origin.x-8, _cloudLayer2.frame.origin.y);
    CAKeyframeAnimation *animation6 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation6.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation6.duration = 4.0;
    animation6.fillMode = kCAFillModeForwards;
    animation6.repeatCount = NSIntegerMax;
    animation6.removedOnCompletion = NO;
    animation6.autoreverses = YES;
    animation6.path = path6;
    CGPathRelease(path6);
    [_cloudLayer2 addAnimation:animation6 forKey:@"cloudLayer2"];
    
    CGMutablePathRef path7 = CGPathCreateMutable();
    CGPathMoveToPoint(path7, &transform, _cloudLayer3.frame.origin.x, _cloudLayer3.frame.origin.y+12);
    CGPathAddLineToPoint(path7, &transform,_cloudLayer3.frame.origin.x, _cloudLayer3.frame.origin.y-4);
    CAKeyframeAnimation *animation7 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation7.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation7.duration = 4.0;
    animation7.fillMode = kCAFillModeForwards;
    animation7.repeatCount = NSIntegerMax;
    animation7.removedOnCompletion = NO;
    animation7.autoreverses = YES;
    animation7.path = path7;
    CGPathRelease(path7);
    [_cloudLayer3 addAnimation:animation7 forKey:@"cloudLayer3"];
    
    CGMutablePathRef path8 = CGPathCreateMutable();
    CGPathMoveToPoint(path8, &transform, _cloudLayer4.frame.origin.x, _cloudLayer4.frame.origin.y+12);
    CGPathAddLineToPoint(path8, &transform,_cloudLayer4.frame.origin.x, _cloudLayer4.frame.origin.y-4);
    CAKeyframeAnimation *animation8 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation8.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation8.duration = 4.0;
    animation8.fillMode = kCAFillModeForwards;
    animation8.repeatCount = NSIntegerMax;
    animation8.removedOnCompletion = NO;
    animation8.autoreverses = YES;
    animation8.path = path8;
    CGPathRelease(path8);
    [_cloudLayer4 addAnimation:animation8 forKey:@"cloudLayer4"];
    
    CGMutablePathRef path9 = CGPathCreateMutable();
    CGPathMoveToPoint(path9, &transform, _cloudLayer5.frame.origin.x+8, _cloudLayer5.frame.origin.y);
    CGPathAddLineToPoint(path9, &transform,_cloudLayer5.frame.origin.x-8, _cloudLayer5.frame.origin.y);
    CAKeyframeAnimation *animation9 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation9.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation9.duration = 4.0;
    animation9.fillMode = kCAFillModeForwards;
    animation9.repeatCount = NSIntegerMax;
    animation9.removedOnCompletion = NO;
    animation9.autoreverses = YES;
    animation9.path = path9;
    CGPathRelease(path9);
    [_cloudLayer5 addAnimation:animation9 forKey:@"cloudLayer5"];
}

- (void)stopAnimation
{
   
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
        CGMutablePathRef path1 = CGPathCreateMutable();
        CGPathMoveToPoint(path1, &transform, _islandLayer.frame.origin.x, _islandLayer.frame.origin.y);
        CGPathAddLineToPoint(path1, &transform,ceil((NSWidth(self.frame) - _islandLayer.frame.size.width)/2), _islandLayer.frame.origin.y);
        CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation1.duration = 4.0;
        animation1.fillMode = kCAFillModeForwards;
        animation1.repeatCount = 1;
        animation1.removedOnCompletion = NO;
        animation1.autoreverses = NO;
        animation1.path = path1;
        CGPathRelease(path1);
        [_islandLayer addAnimation:animation1 forKey:@"islandLayer"];
        
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, &transform, _boatLayer.frame.origin.x, _boatLayer.frame.origin.y);
        CGPathAddLineToPoint(path2, &transform,NSWidth(self.frame), _boatLayer.frame.origin.y);
        CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation2.duration = 4.0;
        animation2.fillMode = kCAFillModeForwards;
        animation2.repeatCount = 1;
        animation2.removedOnCompletion = NO;
        animation2.autoreverses = NO;
        animation2.path = path2;
        CGPathRelease(path2);
        [_boatLayer addAnimation:animation2 forKey:@"boatLayer1"];
        [_boatLayer animateKey:@"opacity" fromValue:@1.0 toValue:@0.0 customize:^(CABasicAnimation *animation) {
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.duration = 4.0;
            
        }];
        
    } completionHandler:^{
        [IMBAnimation pauseAnimation:_mountainLayer1];
        [IMBAnimation pauseAnimation:_mountainLayer2];
        [IMBAnimation pauseAnimation:_stoneLayer1];
        [IMBAnimation pauseAnimation:_stoneLayer2];
        [_boatLayer removeAllAnimations];
    }];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)dealloc
{
    [_bgLayer release],_bgLayer = nil;
    [_waveLayer release],_waveLayer = nil;
    [_mountainLayer1 removeAllAnimations];
    [_mountainLayer2 removeAllAnimations];
    [_stoneLayer1 removeAllAnimations];
    [_stoneLayer2 removeAllAnimations];
    [_mountainLayer1 release],_mountainLayer1 = nil;
    [_mountainLayer2 release],_mountainLayer2 = nil;
    [_stoneLayer1 release],_stoneLayer1 = nil;
    [_stoneLayer2 release],_stoneLayer2 = nil;
    [_boatLayer release],_boatLayer = nil;
    [_maskLayer release],_maskLayer = nil;
    [_cloudLayer1 removeAllAnimations];
    [_cloudLayer2 removeAllAnimations];
    [_cloudLayer3 removeAllAnimations];
    [_cloudLayer4 removeAllAnimations];
    [_cloudLayer5 removeAllAnimations];
    [_cloudLayer1 release],_cloudLayer1 = nil;
    [_cloudLayer3 release],_cloudLayer3 = nil;
    [_cloudLayer2 release],_cloudLayer2 = nil;
    [_cloudLayer4 release],_cloudLayer4 = nil;
    [_cloudLayer5 release],_cloudLayer5 = nil;
    [_islandLayer release],_islandLayer = nil;
    [_categoryLayer release],_categoryLayer = nil;
    [super dealloc];
}

@end

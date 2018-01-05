//
//  AnnoyAnimationView.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-9-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "AnnoyAnimationViewOne.h"
#import "StringHelper.h"
@implementation AnnoyAnimationViewOne

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
    _bglayer.contents = [StringHelper imageNamed:@"annoy_bg_one"];
    
    _maskLayer = [[CALayer layer] retain];
    [_maskLayer setAnchorPoint:CGPointMake(0, 0)];
    [_maskLayer setMasksToBounds:YES];
    [_maskLayer setFrame:NSRectToCGRect(self.bounds)];
    _maskLayer.contents = [StringHelper imageNamed:@"annoy_mask"];
    
    _freecarLayer = [[CALayer layer] retain];
    [_freecarLayer setAnchorPoint:CGPointMake(0, 0)];
    [_freecarLayer setFrame:CGRectMake(-122, 45, 122, 68)];
    _freecarLayer.contents = [StringHelper imageNamed:@"annoy_freecar_one"];
    
    _backfreecarwheelLayer = [[CALayer layer] retain];
    [_backfreecarwheelLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_backfreecarwheelLayer setFrame:CGRectMake(25, 8, 20, 20)];
    _backfreecarwheelLayer.contents = [StringHelper imageNamed:@"annoy_freecarwheel_one"];
    
    _frontfreecarwheelLayer = [[CALayer layer] retain];
    [_frontfreecarwheelLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_frontfreecarwheelLayer setFrame:CGRectMake(90, 8, 20, 20)];
    _frontfreecarwheelLayer.contents = [StringHelper imageNamed:@"annoy_freecarwheel_one"];
    
    [_freecarLayer addSublayer:_backfreecarwheelLayer];
    [_freecarLayer addSublayer:_frontfreecarwheelLayer];
    
    _vipcarLayer = [[CALayer layer] retain];
    [_vipcarLayer setAnchorPoint:CGPointMake(0, 0)];
    [_vipcarLayer setFrame:CGRectMake(-316, 10, 316, 108)];
    _vipcarLayer.contents = [StringHelper imageNamed:@"annoy_vipcar_one"];
    
    _vipcarwheelLayer1 = [[CALayer layer] retain];
    [_vipcarwheelLayer1 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer1 setFrame:CGRectMake(22, 10, 22, 22)];
    _vipcarwheelLayer1.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_one"];
    
    _vipcarwheelLayer2 = [[CALayer layer] retain];
    [_vipcarwheelLayer2 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer2 setFrame:CGRectMake(50, 10, 22, 22)];
    _vipcarwheelLayer2.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_one"];
    
    _vipcarwheelLayer3 = [[CALayer layer] retain];
    [_vipcarwheelLayer3 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer3 setFrame:CGRectMake(160, 10, 22, 22)];
    _vipcarwheelLayer3.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_one"];
    
    _vipcarwheelLayer4 = [[CALayer layer] retain];
    [_vipcarwheelLayer4 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer4 setFrame:CGRectMake(188, 10, 22, 22)];
    _vipcarwheelLayer4.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_one"];
    
    _vipcarwheelLayer5 = [[CALayer layer] retain];
    [_vipcarwheelLayer5 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_vipcarwheelLayer5 setFrame:CGRectMake(282, 10, 22, 22)];
    _vipcarwheelLayer5.contents = [StringHelper imageNamed:@"annoy_vipcarwheel_one"];
    
    _countTextLayer = [[CATextLayer layer] retain];
    [_countTextLayer setAnchorPoint:CGPointMake(0, 0)];
    [_countTextLayer setFrame:CGRectMake(342, 165, 64, 42)];
    _countTextLayer.alignmentMode = kCAAlignmentCenter;
    _countTextLayer.truncationMode = kCATruncationMiddle;
    _countTextLayer.contentsScale = 1.0;
    
    _dayTextLayer = [[CATextLayer layer] retain];
    [_dayTextLayer setAnchorPoint:CGPointMake(0, 0)];
    [_dayTextLayer setFrame:CGRectMake(644, 165, 64, 42)];
    _dayTextLayer.alignmentMode = kCAAlignmentCenter;
    _dayTextLayer.truncationMode = kCATruncationMiddle;
    _dayTextLayer.contentsScale = 1.0;
    [_vipcarLayer addSublayer:_vipcarwheelLayer1];
    [_vipcarLayer addSublayer:_vipcarwheelLayer2];
    [_vipcarLayer addSublayer:_vipcarwheelLayer3];
    [_vipcarLayer addSublayer:_vipcarwheelLayer4];
    [_vipcarLayer addSublayer:_vipcarwheelLayer5];
    [_bglayer addSublayer:_freecarLayer];
    [_bglayer addSublayer:_vipcarLayer];
    [_bglayer addSublayer:_maskLayer];
    [_bglayer addSublayer:_countTextLayer];
    [_bglayer addSublayer:_dayTextLayer];
    [self.layer addSublayer:_bglayer];
}

- (void)setRemainderCount:(int)remainderCount Unit:(NSString *)unit
{
    NSString *str = [NSString stringWithFormat:@"%d\n%@",remainderCount,unit];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str?:@""];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%d",remainderCount]];
    NSRange range1 =  [str rangeOfString:unit];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[StringHelper getColorFromString:CustomColor(@"remainDay", nil)]
                  range:range1];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue" size:14]
                  range:range1];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[StringHelper getColorFromString:CustomColor(@"remainCount", nil)]
                  range:range];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue" size:22]
                  range:range];
    [_countTextLayer setString:title];
    [title release];

}
- (void)setRemainderDays:(int)remainderDays Unit:(NSString *)unit
{
    NSString *str = [NSString stringWithFormat:@"%d\n%@",remainderDays,unit];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str?:@""];
    NSRange range2 = [str rangeOfString:[NSString stringWithFormat:@"%d",remainderDays]];
    NSRange range3 =  [str rangeOfString:unit];
    [title addAttribute:NSForegroundColorAttributeName
                     value:[StringHelper getColorFromString:CustomColor(@"remainDay", nil)]
                     range:range3];
    [title addAttribute:NSFontAttributeName
                     value:[NSFont fontWithName:@"Helvetica Neue" size:14]
                     range:range3];
    
    [title addAttribute:NSForegroundColorAttributeName
                     value:[StringHelper getColorFromString:CustomColor(@"remainCount", nil)]
                     range:range2];
    [title addAttribute:NSFontAttributeName
                     value:[NSFont fontWithName:@"Helvetica Neue" size:22]
                     range:range2];
    [_dayTextLayer setString:title];
    [title release];
}

- (void)startAnimation
{
    float circleTime = 0.8;
    [_backfreecarwheelLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    [_frontfreecarwheelLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    [_vipcarwheelLayer1 animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    [_vipcarwheelLayer2 animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    [_vipcarwheelLayer3 animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    [_vipcarwheelLayer4 animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    [_vipcarwheelLayer5 animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = circleTime;
    }];
    //匀速
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, &transform, -316,_vipcarLayer.frame.origin.y);
    CGPathAddLineToPoint(path1, &transform,NSWidth(self.frame), _vipcarLayer.frame.origin.y);
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation1.duration = 5.0;
    animation1.fillMode = kCAFillModeForwards;
    animation1.repeatCount = NSIntegerMax;
    animation1.removedOnCompletion = NO;
    animation1.autoreverses = NO;
    animation1.path = path1;
    CGPathRelease(path1);
    [_vipcarLayer addAnimation:animation1 forKey:@"vipcarLayer"];
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, &transform, -122, _freecarLayer.frame.origin.y);
    CGPathAddLineToPoint(path2, &transform,300, _freecarLayer.frame.origin.y);
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation2.duration = 4.0;
    animation2.fillMode = kCAFillModeForwards;
    animation2.repeatCount = NSIntegerMax;
    animation2.removedOnCompletion = NO;
    animation2.autoreverses = NO;
    animation2.path = path2;
    CGPathRelease(path2);
    
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, &transform, 300, _freecarLayer.frame.origin.y);
    CGPathAddLineToPoint(path3, &transform,NSWidth(self.frame), _freecarLayer.frame.origin.y);
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation3.delegate = self;
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation3.duration = 3.0;
    animation3.beginTime = 4.0;
    animation3.fillMode = kCAFillModeForwards;
    animation3.repeatCount = NSIntegerMax;
    animation3.removedOnCompletion = NO;
    animation3.autoreverses = NO;
    animation3.path = path3;
    CGPathRelease(path3);
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group.duration = 7.0;
    group.autoreverses = NO;
    group.removedOnCompletion = YES;
    group.repeatCount = NSIntegerMax;
    group.animations = [NSArray arrayWithObjects:animation2,animation3, nil];
    [_freecarLayer addAnimation:group forKey:@"group"];
}



- (void)stopAnimation
{
    [_freecarLayer removeAllAnimations];
    [_backfreecarwheelLayer removeAllAnimations];
    [_frontfreecarwheelLayer removeAllAnimations];
    [_vipcarLayer removeAllAnimations];
    [_vipcarwheelLayer1 removeAllAnimations];
    [_vipcarwheelLayer2 removeAllAnimations];
    [_vipcarwheelLayer3 removeAllAnimations];
    [_vipcarwheelLayer4 removeAllAnimations];
    [_vipcarwheelLayer5 removeAllAnimations];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
}
- (void)dealloc
{
    [_maskLayer release],_maskLayer = nil;
    [_frontfreecarwheelLayer release],_frontfreecarwheelLayer = nil;
    [_bglayer release],_bglayer = nil;
    [_freecarLayer release],_freecarLayer = nil;
    [_backfreecarwheelLayer release],_backfreecarwheelLayer = nil;
    [_vipcarLayer release],_vipcarLayer = nil;
    [_vipcarwheelLayer1 release],_vipcarwheelLayer1 = nil;
    [_vipcarwheelLayer2 release],_vipcarwheelLayer1 = nil;
    [_vipcarwheelLayer3 release],_vipcarwheelLayer1 = nil;
    [_vipcarwheelLayer4 release],_vipcarwheelLayer1 = nil;
    [_vipcarwheelLayer5 release],_vipcarwheelLayer1 = nil;
    [_countTextLayer release],_countTextLayer = nil;
    [_dayTextLayer release],_dayTextLayer = nil;
    [super dealloc];
}
@end

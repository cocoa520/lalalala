//
//  AnnoyAnimationViewTwo.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-9-22.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "AnnoyAnimationViewTwo.h"
#import "StringHelper.h"

@implementation AnnoyAnimationViewTwo

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
    _bglayer.contents = [StringHelper imageNamed:@"annoy_bg_two"];
    
    _maskLayer = [[CALayer layer] retain];
    [_maskLayer setAnchorPoint:CGPointMake(0, 0)];
    [_maskLayer setMasksToBounds:YES];
    [_maskLayer setFrame:NSRectToCGRect(self.bounds)];
    _maskLayer.contents = [StringHelper imageNamed:@"annoy_mask"];
    
    _freecarLayer = [[CALayer layer] retain];
    [_freecarLayer setAnchorPoint:CGPointMake(0, 0)];
    [_freecarLayer setFrame:CGRectMake(-200, 40, 200, 111)];
    _freecarLayer.contents = [StringHelper imageNamed:@"annoy_freecar_two"];
    
    _backfreecarwheelLayer = [[CALayer layer] retain];
    [_backfreecarwheelLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_backfreecarwheelLayer setFrame:CGRectMake(50, 15, 32, 32)];
    _backfreecarwheelLayer.contents = [StringHelper imageNamed:@"annoy_freecarwheel_two"];
    
    _frontfreecarwheelLayer = [[CALayer layer] retain];
    [_frontfreecarwheelLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_frontfreecarwheelLayer setFrame:CGRectMake(150, 15, 32, 32)];
    _frontfreecarwheelLayer.contents = [StringHelper imageNamed:@"annoy_freecarwheel_two"];
    
    [_freecarLayer addSublayer:_backfreecarwheelLayer];
    [_freecarLayer addSublayer:_frontfreecarwheelLayer];
    
    _countTextLayer = [[CATextLayer layer] retain];
    [_countTextLayer setAnchorPoint:CGPointMake(0, 0)];
    [_countTextLayer setFrame:CGRectMake(514, 196, 90, 64)];
    _countTextLayer.alignmentMode = kCAAlignmentCenter;
    _countTextLayer.truncationMode = kCATruncationMiddle;
    _countTextLayer.contentsScale = 1.0;
    [self setRemainderCount:0 Unit:@"items"];
    [_bglayer addSublayer:_freecarLayer];
    [_bglayer addSublayer:_maskLayer];
    [_bglayer addSublayer:_countTextLayer];
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
                  value:[NSFont fontWithName:@"Helvetica Neue" size:20]
                  range:range1];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[StringHelper getColorFromString:CustomColor(@"remainCount", nil)]
                  range:range];
    [title addAttribute:NSFontAttributeName
                  value:[NSFont fontWithName:@"Helvetica Neue" size:32]
                  range:range];
    [_countTextLayer setString:title];
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
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, &transform, -200, _freecarLayer.frame.origin.y);
        CGPathAddLineToPoint(path2, &transform,320, _freecarLayer.frame.origin.y);
        CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation2.duration = 4.0;
        animation2.fillMode = kCAFillModeForwards;
        animation2.repeatCount = 1;
        animation2.removedOnCompletion = NO;
        animation2.autoreverses = NO;
        animation2.path = path2;
        CGPathRelease(path2);
        [_freecarLayer addAnimation:animation2 forKey:@"freecarLayer"];
    } completionHandler:^{
        [_backfreecarwheelLayer removeAllAnimations];
        [_frontfreecarwheelLayer removeAllAnimations];
    }];
}

- (void)stopAnimation
{
    [_freecarLayer removeAllAnimations];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)dealloc
{
    [_bglayer release],_bglayer = nil;
    [_freecarLayer release],_freecarLayer = nil;
    [_backfreecarwheelLayer release],_backfreecarwheelLayer = nil;
    [_frontfreecarwheelLayer release],_frontfreecarwheelLayer = nil;
    [_maskLayer release],_maskLayer = nil;
    [super dealloc];
}

@end

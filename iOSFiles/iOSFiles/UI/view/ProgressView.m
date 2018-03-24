//
//  ProgressView.m
//  ProgressIndicator
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 iMobie. All rights reserved.
//

#import "ProgressView.h"
#import "StringHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBNotificationDefine.h"
#import "IMBCommonDefine.h"
@implementation ProgressView
@synthesize backgroundColor = _backgroundColor;
@synthesize leftFillColor = _leftFillColor;
@synthesize rightFillColor = _rightFillColor;
@synthesize height = _height;
@synthesize fillimage = _fillimage;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setUp];
        
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = Progress_BgColor;
    [self setWantsLayer:YES];
    [self.layer setFrame:NSRectToCGRect(self.bounds)];
    [self.layer setAnchorPoint:CGPointMake(0, 0)];
    _lightLayer = [[CALayer layer] retain];
    [_lightLayer setAnchorPoint:CGPointMake(0, 0)];
    [_lightLayer setFrame:CGRectMake(0, 0, 100, 6)];
    _lightLayer.contents = [StringHelper imageNamed:@"download_light"];
    
    _tansferFinishlightLayer = [[CALayer layer] retain];
    [_tansferFinishlightLayer setAnchorPoint:CGPointMake(0, 0)];
    [_tansferFinishlightLayer setFrame:CGRectMake(0, 0, 100, 6)];
    _tansferFinishlightLayer.contents = [StringHelper imageNamed:@"download_light"];
    _height = 6;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)startFinishWait
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.duration = 4; // 持续时间
    animation1.repeatCount = NSIntegerMax; // 重复次数
    animation1.autoreverses = NO;
    animation1.fromValue = [NSValue valueWithPoint:NSMakePoint(-100, 0)]; // 起始帧
    animation1.toValue = [NSValue valueWithPoint:NSMakePoint(self.frame.size.width +100 , 0)];
    if (![_tansferFinishlightLayer superlayer]) {
        _isTansferFinishWait = YES;
        [self setDoubleValue:100];
        [self.layer addSublayer:_tansferFinishlightLayer];
       
        [_tansferFinishlightLayer addAnimation:animation1 forKey:@"move-layer"];
    }
    [_tansferFinishlightLayer addAnimation:animation1 forKey:@"move-layer"];
    [self setNeedsDisplay:YES];
}


- (void)endFinishWait
{
    _isTansferFinishWait = NO;
    [_tansferFinishlightLayer removeFromSuperlayer];
    [_tansferFinishlightLayer removeAllAnimations];
    [self setNeedsDisplay:YES];

}

- (void)startWati
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.duration = 4; // 持续时间
    animation1.repeatCount = NSIntegerMax; // 重复次数
    animation1.autoreverses = NO;
    animation1.fromValue = [NSValue valueWithPoint:NSMakePoint(-100, 0)]; // 起始帧
    animation1.toValue = [NSValue valueWithPoint:NSMakePoint(self.frame.size.width +100 , 0)];
    if (![_lightLayer superlayer]) {
        _iswait = YES;
        [self setDoubleValue:100];
        [self.layer addSublayer:_lightLayer];
    }
    [_lightLayer addAnimation:animation1 forKey:@"move-layer"];
    [self setNeedsDisplay:YES];

}
- (void)endWait
{
    _iswait = NO;
    [_lightLayer removeFromSuperlayer];
    [_lightLayer removeAllAnimations];
    [self setNeedsDisplay:YES];
}

- (void)setDoubleValue:(double)doubleValue
{
    [super setDoubleValue:doubleValue];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect slideRect = dirtyRect;
    slideRect.size.height = _height;
    NSBezierPath *bpath = [NSBezierPath bezierPathWithRoundedRect:slideRect xRadius:3 yRadius:3];
    [_backgroundColor set];
    [bpath addClip];
    [bpath fill];
    slideRect.size.width = slideRect.size.width*[self doubleValue]/[self maxValue];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:slideRect xRadius:3 yRadius:3];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (self.doubleValue !=0) {
        CGContextAddPath(context, [path quartzPath]);
        CGContextClip(context);
        CGContextSaveGState(context);
        {
            const CGFloat glossGradientComponents[] = {_leftFillColor.redComponent,_leftFillColor.greenComponent,_leftFillColor.blueComponent, 1.0f, _rightFillColor.redComponent, _rightFillColor.greenComponent, _rightFillColor.blueComponent, 1.0f};
            const CGFloat glossGradientLocations[] = {0.2,1.0};
            //创建颜色渐变对象
            CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations, 2);
            CGContextDrawLinearGradient(context, glossCradient, CGPointMake(slideRect.origin.x, slideRect.origin.y), CGPointMake(slideRect.origin.x + slideRect.size.width, slideRect.size.height), kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(glossCradient);
        }
        CGContextRestoreGState(context);
    }
    CGColorSpaceRelease(colorSpace);
    if (_fillimage != nil&&!_iswait) {
        [_fillimage drawInRect:slideRect fromRect:slideRect operation:NSCompositeSourceOver fraction:1.0];
    }
    if (_fillimage != nil&&_isTansferFinishWait) {
        [_fillimage drawInRect:slideRect fromRect:slideRect operation:NSCompositeSourceOver fraction:1.0];
    }
}

- (void)changeSkin:(NSNotification *) noti {
    self.backgroundColor = Progress_BgColor;
    _lightLayer.contents = [StringHelper imageNamed:@"download_light"];
    [self setNeedsDisplay:YES];
}

-(void)dealloc
{
    [_backgroundColor release],_backgroundColor = nil;
    [_leftFillColor release],_leftFillColor = nil;
    [_rightFillColor release],_rightFillColor = nil;
    [_fillimage release],_fillimage = nil;
    [_lightLayer release],_lightLayer = nil;
    [_tansferFinishlightLayer release],_tansferFinishlightLayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}
@end

//
//  LoadingView.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/1.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "NSColor+Category.h"

#define sizewith 100
@implementation LoadingView

@synthesize isAnimating = _isAnimating;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setupView];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
//    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
//    if (_bgColor) {
//        [_bgColor setFill];
//    }else {
//        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
//    }
//    [path fill];
}

- (void)awakeFromNib {
    [self setupView];

}

- (void)setupView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:@"Change_Skin" object:nil];
    [self setWantsLayer:YES];
    float midX = self.bounds.size.width/2;
    float midH = self.bounds.size.height/2;
    
    drawingLayer = [[CALayer layer] retain];
    drawingLayer.frame = CGRectMake(midX-sizewith/2, midH-sizewith/2, sizewith, sizewith);
    //    if (_bgColor) {
    //        drawingLayer.backgroundColor = _bgColor.toCGColor;
    //    }else {
    //        drawingLayer.backgroundColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)].toCGColor;
    //    }
    drawingLayer.masksToBounds = YES;
    drawingLayer.cornerRadius = sizewith/2;
    
    drawingLayer.borderColor = IMBRgbColor(1, 150, 235).toCGColor;
    drawingLayer.borderWidth = 2.0;
    
    drawingLayer2 = [[CALayer layer] retain];
    drawingLayer2.frame = CGRectMake(midX-sizewith/2, midH-sizewith/2, sizewith, sizewith);
    //    if (_bgColor) {
    //        drawingLayer.backgroundColor = _bgColor.toCGColor;
    //    }else {
    //        drawingLayer.backgroundColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)].toCGColor;
    //    }
    drawingLayer2.masksToBounds = YES;
    drawingLayer2.cornerRadius = sizewith/2;
    drawingLayer2.borderColor = IMBRgbColor(1, 150, 235).toCGColor;
    drawingLayer2.borderWidth = 2.0;
}

-(void)startAnimation {
//    if (_bgColor) {
//        drawingLayer.backgroundColor = _bgColor.toCGColor;
//    }else {
//        drawingLayer.backgroundColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)].toCGColor;
//    }
    drawingLayer.borderColor = IMBRgbColor(1, 150, 235).toCGColor;
//    if (_bgColor) {
//        drawingLayer.backgroundColor = _bgColor.toCGColor;
//    }else {
//        drawingLayer.backgroundColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)].toCGColor;
//    }
    
    [self.layer addSublayer:drawingLayer];
    [drawingLayer setHidden:YES];
    [self.layer addSublayer:drawingLayer2];
    [drawingLayer2 setHidden:YES];
    [self animation];
    _isAnimating = YES;
}

- (void)animation {
    [self setWantsLayer:YES];
    [drawingLayer setHidden:NO];
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.duration = 1.4;
    animation1.autoreverses = NO;
    animation1.repeatCount = 0;
    animation1.fromValue = [NSNumber numberWithFloat:0.1];
    animation1.toValue = [NSNumber numberWithFloat:1.0];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.duration = 1.4;
    animation2.autoreverses = NO;
    animation2.repeatCount = 0;//NSIntegerMax
    animation2.fromValue = [NSNumber numberWithFloat:1];
    animation2.toValue = [NSNumber numberWithFloat:0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation1,animation2];
    group.duration =1.4;
    group.repeatCount = FLT_MAX;//HUGE_VALF
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [drawingLayer addAnimation:group forKey:nil];
    
    double delayInSeconds = 0.7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [drawingLayer2 setHidden:NO];
        [drawingLayer2 addAnimation:group forKey:@""];
    });
}

-(void)endAnimation {
    [drawingLayer removeAllAnimations];
    [drawingLayer2 removeAllAnimations];
    [drawingLayer removeFromSuperlayer];
    [drawingLayer2 removeFromSuperlayer];
    
    _isAnimating = NO;
}

- (void)setbackColor:(NSColor *)backgroundColor {
    if (_bgColor != nil) {
        [_bgColor release];
        _bgColor = [backgroundColor retain];
    }else {
         _bgColor = [backgroundColor retain];
    }
}

- (void)changeSkin:(NSNotification *)notification
{
//    if (_bgColor) {
//        drawingLayer.backgroundColor = _bgColor.toCGColor;
//    }else {
//        drawingLayer.backgroundColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)].toCGColor;
//    }
    drawingLayer.borderColor = IMBRgbColor(1, 150, 235).toCGColor;
//    if (_bgColor) {
//        drawingLayer.backgroundColor = _bgColor.toCGColor;
//    }else {
//        drawingLayer.backgroundColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)].toCGColor;
//    }
    drawingLayer2.borderColor = IMBRgbColor(1, 150, 235).toCGColor;
    [self setNeedsDisplay:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Change_Skin" object:nil];
    [_bgColor release], _bgColor = nil;
    [drawingLayer release],drawingLayer = nil;
    [drawingLayer2  release],drawingLayer2 = nil;
    [super dealloc];
}

@end

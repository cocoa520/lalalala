//
//  IMBGrayCapacityView.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/22.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBGrayCapacityView.h"
#import "CapacityView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
@implementation IMBGrayCapacityView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSRect rect = dirtyRect;
    rect.size.height = _width;
    rect.origin.y = (dirtyRect.size.height- _width)/2;
    _rect = rect;
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:3 yRadius:3];
    [_bgColor set];
    [path fill];
    //圆角头部
    NSRect capacityRect = rect;
    capacityRect.size.width = 5;
    NSBezierPath *capacityPath = [NSBezierPath bezierPathWithRoundedRect:capacityRect xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)] set];
    [capacityPath fill];
}

- (void)setLineBgColor:(NSColor *)bgcolor WithLineWidth:(float)width WithRadius:(float)radius WithPercent:(float)percent{
    _bgColor = [bgcolor retain];
    _width = width;
    _radius = radius;
    _percent = percent;

}

- (void)loadCapacity {
    CapacityView *view = [[CapacityView alloc]initWithFrame:NSMakeRect(2, (self.frame.size.height-_width)/2, self.frame.size.width * _percent, _width) WithFillColor:[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)] withPercent:_percent];
    [self addSubview:view];

    [view setWantsLayer:YES];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale.x"];//transform.scale.x = 闊的比例轉換
    animation.fromValue=@0;
    animation.toValue=@1;
    animation.duration=1.0;
    animation.autoreverses=NO;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:nil];
}

- (void)dealloc {
    if (_bgColor != nil) {
        [_bgColor release];
        _bgColor = nil;
    }
    [super dealloc];
}
@end

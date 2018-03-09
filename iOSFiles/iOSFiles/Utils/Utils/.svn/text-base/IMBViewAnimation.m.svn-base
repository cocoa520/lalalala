//
//  IMBViewAnimation.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/8.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBViewAnimation.h"
#import <Quartz/Quartz.h>
#import "IMBGradientComponentView.h"

static CGFloat const IMBViewAnimInterval = 0.15f;

@implementation IMBViewAnimation

+ (void)animationWithView:(NSView *)view frame:(NSRect)frame completion:(void(^)(void))completion {
    [self animationWithViews:[NSArray arrayWithObject:view] frames:[NSArray arrayWithObject:[NSValue valueWithRect:frame]] timeInterval:0.05f completion:completion];
}

+ (void)animationWithView:(NSView *)view frame:(NSRect)frame timeInterval:(CGFloat)timeInterval completion:(void(^)(void))completion {
    [self animationWithViews:[NSArray arrayWithObject:view] frames:[NSArray arrayWithObject:[NSValue valueWithRect:frame]] timeInterval:timeInterval completion:completion];
}


+ (void)animationWithViews:(NSArray <NSView *>*)views frames:(NSArray *)frames completion:(void(^)(void))completion {
    
    [self animationWithViews:views frames:frames timeInterval:IMBViewAnimInterval completion:completion];
    
}

+ (void)animationWithViews:(NSArray <NSView *>*)views frames:(NSArray *)frames timeInterval:(CGFloat)timeInterval completion:(void(^)(void))completion {
    
    NSMutableArray *animations = [NSMutableArray array];
    
    NSInteger count = views.count;
    
    for (NSInteger i = 0; i < count; i++) {
        NSView *view = [views objectAtIndex:i];
        NSRect frame = [view frame];
        
        NSMutableDictionary *viewDict = [NSMutableDictionary dictionaryWithCapacity:3];
        
        
        [viewDict setObject:view forKey:NSViewAnimationTargetKey];
        
        //设置视图的起始位置
        [viewDict setObject:[NSValue valueWithRect:frame] forKey:NSViewAnimationStartFrameKey];
        
        
        [viewDict setObject:[frames objectAtIndex:i] forKey:NSViewAnimationEndFrameKey];
//        [viewDict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationFadeOutEffect];
        [animations addObject:viewDict];
    }
    
    
    NSViewAnimation *theAnim = [[NSViewAnimation alloc] initWithViewAnimations:animations];
    
    // 设置动画的一些属性.比如持续时间0.5秒
    [theAnim setDuration:timeInterval];    // a half seconds.
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    // 启动动画
    [theAnim startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
    
    [theAnim release];
    theAnim = nil;
    
    
}

+ (void)animation2WithViews:(NSArray <NSView *>*)views frames:(NSArray *)frames completion:(void(^)(void))completion {
    
    NSInteger count = views.count;
    
    for (NSInteger i = 0; i < count; i++) {
        NSView *view = [views objectAtIndex:i];
        NSRect frame = [view frame];
        NSRect newFrame = [[frames objectAtIndex:i] rectValue];
        view.frame = newFrame;
        
        //位移动画
        CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"position"];
        [anima1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        //        anima1.fromValue = [NSValue valueWithPoint:frame.origin];
        //        anima1.toValue = [NSValue valueWithPoint:newFrame.origin];
        //        anima1.beginTime = CACurrentMediaTime() + 0.03;
        //        anima1.fillMode = kCAFillModeBackwards;
        
        //缩放动画
        CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        [anima2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        anima2.fromValue = [NSNumber numberWithFloat:frame.size.width/newFrame.size.width];
        anima2.toValue = [NSNumber numberWithFloat:1.0f];
        //        anima2.beginTime = CACurrentMediaTime() + 0.03;
        //        anima2.fillMode = kCAFillModeBackwards;
        
        CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        [anima3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        anima3.fromValue = [NSNumber numberWithFloat:frame.size.height/newFrame.size.height];
        anima3.toValue = [NSNumber numberWithFloat:1.0f];
        //        anima3.beginTime = CACurrentMediaTime() + 0.03;
        //        anima3.fillMode = kCAFillModeBackwards;
        
        //组动画
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
        groupAnimation.duration = IMBViewAnimInterval;
        
        view.wantsLayer = YES;
        [view.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
    }
    
}

@end

//
//  ZLAnimation.m
//  TestAnimation
//
//  Created by iMobie on 18/3/2.
//  Copyright © 2018年 TsinHzl. All rights reserved.
//

#import "ZLAnimation.h"
#import "NSView+Extension.h"

#import <QuartzCore/QuartzCore.h>

typedef enum : NSUInteger {
    ZLAnimationScaleTypeX,
    ZLAnimationScaleTypeY
} ZLAnimationScaleType;


@implementation ZLAnimation

+ (void)testWithView:(NSView *)view frame:(NSRect)frame {
    // scale animation
    CGFloat scaleX = frame.size.width/view.zl_width;
    CGFloat scaleY = frame.size.height/view.zl_height;
    view.zl_size = NSMakeSize(frame.size.width, frame.size.height);
    CABasicAnimation *scaleAnimationX = [self scaleAnimationWithScaleType:ZLAnimationScaleTypeX scale:scaleX];
    [view setWantsLayer:YES];
    [view.layer addAnimation:scaleAnimationX forKey:@"scaleAnimationX"];
    
    CABasicAnimation *scaleAnimationY = [self scaleAnimationWithScaleType:ZLAnimationScaleTypeY scale:scaleY];
    
    [view.layer addAnimation:scaleAnimationY forKey:@"scaleAnimationY"];
    
}

+ (CABasicAnimation *)scaleAnimationWithScaleType:(ZLAnimationScaleType)scaleType scale:(CGFloat)scale {
    
    CABasicAnimation *scaleAnimation;
    if (scaleType == ZLAnimationScaleTypeX) {
        scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    }else {
        scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    }
    
    
    scaleAnimation.duration = 1.2f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0/scale];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    scaleAnimation.beginTime = CACurrentMediaTime() + 0.03;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    //    scaleAnimation.repeatCount = 2;
    return scaleAnimation;
    
}
@end

//
//  IMBAnimation.m
//  MacClean
//
//  Created by Gehry on 1/12/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import "IMBAnimation.h"

@implementation IMBAnimation

+(CABasicAnimation *)opacityForever_Animation:(float)time //永久闪烁的动画
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:1.0];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.autoreverses = YES;
    return animation;
}

+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time beginTime:(float)beginTime //有闪烁次数的动画
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.repeatCount=repeatTimes;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.beginTime = CACurrentMediaTime()+beginTime;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.autoreverses=YES;
    return  animation;
}

+(CABasicAnimation *)opacityChange_Animation:(float)repeatTimes fromValue:(NSNumber *)from toValue:(NSNumber *)to durTimes:(float)time
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=from;
    animation.toValue=to;
    animation.repeatCount=repeatTimes;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x //横向往返移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue=x;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.autoreverses = YES;
    animation.repeatCount = FLT_MAX;
    return animation;
}

+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x repeatCount:(float)repeat beginTime:(float)beginTime //横向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue=x;
    animation.duration=time;
    animation.repeatCount = repeat;
    animation.beginTime= CACurrentMediaTime() + beginTime;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)moveX:(float)time fromX:(NSNumber *)x toX:(NSNumber *)toX repeatCount:(float)repeat beginTime:(float)beginTime //横向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue=x;
    animation.toValue=toX;
    animation.duration=time;
    animation.repeatCount = repeat;
    animation.beginTime= CACurrentMediaTime() + beginTime;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}


+(CABasicAnimation *)moveY:(float)time X:(NSNumber *)x Y:(NSNumber *)y repeatCount:(float)repeat //纵向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue=x;
    animation.toValue=y;
    animation.duration=time;
    animation.repeatCount = repeat;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)moveY:(float)time X:(NSNumber *)x Y:(NSNumber *)y //提示框纵向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue=x;
    animation.toValue=y;
    animation.duration=time;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBackwards;
    return animation;
}



+(CABasicAnimation *)moveY:(float)time X:(NSNumber *)x Y:(NSNumber *)y repeatCount:(float)repeat beginTime:(float)beginTime isAutoreverses:(BOOL)autoreverses //往返移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue=x;
    animation.toValue=y;
    animation.duration=time;
    animation.repeatCount=repeat;
    animation.removedOnCompletion=NO;
    animation.beginTime= CACurrentMediaTime() + beginTime;
    animation.fillMode=kCAFillModeForwards;
    animation.autoreverses = autoreverses;
    return animation;
}

+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes beginTime:(float)beginTime //缩放
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale.z"];
    animation.fromValue = orginMultiple;
    animation.toValue = Multiple;
    animation.duration = time;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    animation.repeatCount = repeatTimes;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes //指定缩放
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale.z"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue=Multiple;
    animation.toValue=orginMultiple;
    animation.duration=time;
    animation.autoreverses=YES;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.delegate=self;
    return animation;
}

+(CAAnimationGroup *)groupAnimationChips:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes beginTime:(float)beginTime //碎片组合动画
{
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations=animationAry;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    return animation;
}


+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes beginTime:(float)beginTime //组合动画
{
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations=animationAry;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.autoreverses = YES;
    animation.fillMode=kCAFillModeForwards;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    return animation;
}

//+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path endPointX:(float)endPointX endPointY:(float)endPointY layer:(CALayer *)layer //路径动画
//{
//    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
//    NSPoint endPoint = NSMakePoint(endPointX, endPointY);
//    CGMutablePathRef paths = path;
//    CGPathMoveToPoint(paths, NULL, layer.position.x, layer.position.y);
//    CGPathAddCurveToPoint(paths, NULL, 290, 280, 100, 300, endPoint.x, endPoint.y);
//    animation.path = paths;
//    CGPathRelease(path);
//    [animation setValue:[NSValue valueWithPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
//    return animation;
//}

+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path cp1x:(CGFloat)firstX cp1y:(CGFloat)firstY cp2x:(CGFloat)secondX cp2y:(CGFloat)secondY endPointX:(float)endPointX endPointY:(float)endPointY layer:(CALayer *)layer{//路径动画
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSPoint endPoint = NSMakePoint(endPointX, endPointY);
    CGMutablePathRef paths = path;
    CGPathMoveToPoint(paths, NULL, firstX, firstY);
    CGPathAddCurveToPoint(paths, NULL, firstX, firstY, secondX, secondY, endPoint.x, endPoint.y);
    animation.path = paths;
    animation.duration = 0.5;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CGPathRelease(path);
    [animation setValue:[NSValue valueWithPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
    return animation;

}


+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path duration:(float)time cp1x:(CGFloat)firstX cp1y:(CGFloat)firstY cp2x:(CGFloat)secondX cp2y:(CGFloat)secondY endPointX:(float)endPointX endPointY:(float)endPointY layer:(CALayer *)layer //路径动画
{
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSPoint endPoint = NSMakePoint(endPointX, endPointY);
    CGMutablePathRef paths = path;
    CGPathMoveToPoint(paths, NULL, layer.position.x, layer.position.y);
    CGPathAddCurveToPoint(paths, NULL, firstX, firstY, secondX, secondY, endPoint.x, endPoint.y);
    animation.path = paths;
    animation.duration = time;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.autoreverses = YES;
    animation.repeatCount = FLT_MAX;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CGPathRelease(path);
    [animation setValue:[NSValue valueWithPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPosition"];
    return animation;
}

+(CABasicAnimation *)rotation:(float )repeatTimes toValue:(NSNumber *)to //指定旋转
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    CGFloat toValue = M_PI_2*3;
    animation.toValue = to;
    animation.duration = 4.0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount = repeatTimes;
    [animation setValue:[NSNumber numberWithFloat:toValue] forKey:@"KCBasicAnimationProperty_ToValue"];
    return animation;
}

+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount beginTime:(float)beginTime //旋转
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(((degree * M_PI)/180.0), 0.0, 0.0,direction);
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= dur;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
    animation.delegate= self;
    return animation;
}

+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount //图片旋转
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(((degree * M_PI)/180.0), 0.0, 0.0,direction);
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= dur;
    animation.cumulative= NO;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
    animation.delegate= self;
    return animation;
}

+(void)endAnimation:(CALayer *)layer //停止动画
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillRuleEvenOdd;
    [layer removeAllAnimations];
}

+(void)pauseAnimation:(CALayer *)layer //暂停动画
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

+(void)resumeAnimation:(CALayer *)layer //继续动画
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

+(void) destoryAnimation:(CALayer *)layer{
    [layer removeFromSuperlayer];
}

+(CATransition *)pushAnimation:(NSView *)view durTimes:(float)time //推动动画
{
    CATransition *transition = [CATransition animation];
    transition.duration = time;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    transition.startProgress = 0.0;
    transition.endProgress = 0.4;
    transition.removedOnCompletion = NO;
    transition.fillMode = kCAFillModeForwards;
    return transition;
}

+(CABasicAnimation *)rotation:(float )repeatTimes toValue:(NSNumber *)to durTimes:(float)time //指定旋转
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = to;
    animation.duration = time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount = repeatTimes;
    return animation;
}
@end

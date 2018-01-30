//
//  IMBAnimation.h
//  MacClean
//
//  Created by Gehry on 1/12/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface IMBAnimation : NSObject

+(CABasicAnimation *)opacityForever_Animation:(float)time; //永久闪烁的动画

+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time beginTime:(float)beginTime; //有闪烁次数的动画

+(CABasicAnimation *)opacityChange_Animation:(float)repeatTimes fromValue:(NSNumber *)from toValue:(NSNumber *)to durTimes:(float)time; //出现和消失的动画

+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x; //横向往返移动

+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x repeatCount:(float)repeat beginTime:(float)beginTime; //横向移动

+(CABasicAnimation *)moveX:(float)time fromX:(NSNumber *)x toX:(NSNumber *)toX repeatCount:(float)repeat beginTime:(float)beginTime;

+(CABasicAnimation *)moveY:(float)time X:(NSNumber *)x Y:(NSNumber *)y repeatCount:(float)repeat; //纵向移动

+(CABasicAnimation *)moveY:(float)time X:(NSNumber *)x Y:(NSNumber *)y;//提示框纵向移动

+(CABasicAnimation *)moveY:(float)time X:(NSNumber *)x Y:(NSNumber *)y repeatCount:(float)repeat beginTime:(float)beginTime isAutoreverses:(BOOL)autoreverses; //往返移动

+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes beginTime:(float)beginTime; //缩放

+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes;//指定缩放

+(CAAnimationGroup *)groupAnimationChips:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes beginTime:(float)beginTime; //碎片组合动画

+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes beginTime:(float)beginTime; //组合动画

+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path cp1x:(CGFloat)firstX cp1y:(CGFloat)firstY cp2x:(CGFloat)secondX cp2y:(CGFloat)secondY endPointX:(float)endPointX endPointY:(float)endPointY layer:(CALayer *)layer; //路径动画

+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path duration:(float)time cp1x:(CGFloat)firstX cp1y:(CGFloat)firstY cp2x:(CGFloat)secondX cp2y:(CGFloat)secondY endPointX:(float)endPointX endPointY:(float)endPointY layer:(CALayer *)layer; //路径动画

+(CABasicAnimation *)rotation:(float )repeatTimes toValue:(NSNumber *)to; //指定旋转

+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount beginTime:(float)beginTime; //旋转

+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount;//图片旋转

+(void)endAnimation:(CALayer *)layer; //停止动画

+(void)pauseAnimation:(CALayer *)layer; //暂停动画

+(void)resumeAnimation:(CALayer *)layer; //继续动画

+(CATransition *)pushAnimation:(NSView *)view durTimes:(float)time; //推动动画

+(void) destoryAnimation:(CALayer *)layer;

+(CABasicAnimation *)rotation:(float )repeatTimes toValue:(NSNumber *)to durTimes:(float)time;

@end

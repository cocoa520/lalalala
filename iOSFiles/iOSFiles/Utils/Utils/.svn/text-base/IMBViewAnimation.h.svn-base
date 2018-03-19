//
//  IMBViewAnimation.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/8.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>

APPKIT_EXTERN CGFloat const MidiumSizeAnimationTimeInterval;

@interface IMBViewAnimation : NSObject

/** 多个view的动画 **/
+ (void)animationWithViews:(NSArray <NSView *>*)views frames:(NSArray *)frames disable:(BOOL)disable completion:(void(^)(void))completion;
+ (void)animation2WithViews:(NSArray <NSView *>*)views frames:(NSArray *)frames disable:(BOOL)disable completion:(void(^)(void))completion;
+ (void)animationWithViews:(NSArray <NSView *>*)views frames:(NSArray *)frames timeInterval:(CGFloat)timeInterval disable:(BOOL)disable completion:(void(^)(void))completion;
/** 单个view的动画 **/
+ (void)animationWithView:(NSView *)view frame:(NSRect)frame disable:(BOOL)disable completion:(void(^)(void))completion;
+ (void)animationWithView:(NSView *)view frame:(NSRect)frame  timeInterval:(CGFloat)timeInterval disable:(BOOL)disable completion:(void(^)(void))completion;

+ (void)animationMouseMovedWithView:(NSView *)view frame:(NSRect)frame disable:(BOOL)disable completion:(void(^)(void))completion;
+ (void)animationMouseMovedWithView:(NSView *)view frame:(NSRect)frame timeInterval:(CGFloat)timeInterval disable:(BOOL)disable completion:(void(^)(void))completion;


+ (void)animationMouseEnteredExitedWithView:(NSView *)view frame:(NSRect)frame disable:(BOOL)disable completion:(void(^)(void))completion;
+ (void)animationMouseEnteredExitedWithView:(NSView *)view frame:(NSRect)frame timeInterval:(CGFloat)timeInterval disable:(BOOL)disable completion:(void(^)(void))completion;

+ (void)animationMouseMovedAnimWithView:(NSView *)view frame:(NSRect)frame timeInterval:(CGFloat)timeInterval disable:(BOOL)disable isHidden:(BOOL)isHidden completion:(void(^)(void))completion;

+ (void)animationScaleWithView:(NSView *)view frame:(NSRect)frame disable:(BOOL)disable completion:(void(^)(void))completion;
+ (void)animationScaleWithView:(NSView *)view frame:(NSRect)frame timeInterval:(CGFloat)timeInterval disable:(BOOL)disable completion:(void(^)(void))completion;

@end

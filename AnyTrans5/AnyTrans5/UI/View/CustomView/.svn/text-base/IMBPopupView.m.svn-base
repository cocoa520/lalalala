//
//  IMBPopupView.m
//  iMobieTrans
//
//  Created by iMobie on 14-4-30.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBPopupView.h"
#import "IMBCategoryBarButtonView.h"
#import "StringHelper.h"
@implementation IMBPopupView
@synthesize startPoint = _startPoint;
@synthesize containerView = _containerView;
@synthesize categoryBarView = _categoryBarView;
@synthesize isTwoBtn = _isTwoBtn;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _startPoint = frame.size.width/2.0;  //_startPoint默认值
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePopupView:) name:@"notify_close_popupview" object:nil];
        
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
    int popUpHeight = 0;
    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
    [shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"popover_shadowColor", nil)]];
    [shadow setShadowOffset:NSMakeSize(0.0, -1)];
    [shadow setShadowBlurRadius:2];
    [shadow set];
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    if (_isTwoBtn) {
        popUpHeight =PopUpViewHeight*2;
        [path moveToPoint:NSMakePoint(_startPoint, 0)];
        [path lineToPoint:NSMakePoint(_startPoint-ArrowSize, ArrowSize)];
        [path lineToPoint:NSMakePoint(0, ArrowSize)];
        [path lineToPoint:NSMakePoint(0, dirtyRect.size.height - 40)];
        [path lineToPoint:NSMakePoint(_startPoint-ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize)), dirtyRect.size.height - 40)];
        [path lineToPoint:NSMakePoint(_startPoint, (dirtyRect.size.height - ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize))) - 40)];
        [path lineToPoint:NSMakePoint(_startPoint+ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize)), dirtyRect.size.height-40)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - 40)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, ArrowSize)];
        [path lineToPoint:NSMakePoint(_startPoint+ArrowSize, ArrowSize)];

    }else{
        popUpHeight =PopUpViewHeight;
        [path moveToPoint:NSMakePoint(_startPoint, 0)];
        [path lineToPoint:NSMakePoint(_startPoint-ArrowSize, ArrowSize)];
        [path lineToPoint:NSMakePoint(0, ArrowSize)];
        [path lineToPoint:NSMakePoint(0, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(_startPoint-ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize)), dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(_startPoint, (dirtyRect.size.height - ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize))))];
        [path lineToPoint:NSMakePoint(_startPoint+ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize)), dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, ArrowSize)];
        [path lineToPoint:NSMakePoint(_startPoint+ArrowSize, ArrowSize)];
    }
    
    //    float curFloat = (self.frame.size.width - 1000)/2 + _startPoint;
    //    [path moveToPoint:NSMakePoint(curFloat - ArrowSize, ArrowSize)];
    //    [path lineToPoint:NSMakePoint(0, ArrowSize)];
    //    [path lineToPoint:NSMakePoint(0, dirtyRect.size.height - 40)];
    //    [path lineToPoint:NSMakePoint(curFloat-ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize)), dirtyRect.size.height - 40)];
    //    [path lineToPoint:NSMakePoint(curFloat, (dirtyRect.size.height - ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize))) - 40)];
    //    [path lineToPoint:NSMakePoint(curFloat+ArrowSize*(1-(dirtyRect.size.height-ArrowSize)/(popUpHeight - ArrowSize)), dirtyRect.size.height - 40)];
    //    [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - 40)];
    //    [path lineToPoint:NSMakePoint(dirtyRect.size.width, ArrowSize)];
    //    [path lineToPoint:NSMakePoint(curFloat+ArrowSize, ArrowSize)];
    
    [path closePath];
    [path addClip];
    [[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)] setFill];
    [path fill];
    [[StringHelper getColorFromString:CustomColor(@"popover_borderColor", nil)]  setStroke];
    [path stroke];
}

- (void)animation:(BOOL)isTwo {
    if (self.frame.size.height == PopUpViewHeight||self.frame.size.height == PopUpViewHeight*2) {
        
        //属性字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //设置目标对象
        [dict setObject:self forKey:NSViewAnimationTargetKey];
        //设置其实大小
        if (isTwo) {
            [dict setObject:[NSValue valueWithRect:NSMakeRect(0,  self.frame.origin.y, self.frame.size.width, PopUpViewHeight * 2)] forKey:NSViewAnimationStartFrameKey];
        }else {
            [dict setObject:[NSValue valueWithRect:NSMakeRect(0,  self.frame.origin.y, self.frame.size.width, PopUpViewHeight)] forKey:NSViewAnimationStartFrameKey];
        }
        //设置最终大小
        [dict setObject:[NSValue valueWithRect:NSMakeRect(0,  self.frame.origin.y, self.frame.size.width, 1)] forKey:NSViewAnimationEndFrameKey];
        //属性字典
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        //设置目标对象
        [dict1 setObject:_containerView forKey:NSViewAnimationTargetKey];
        //设置其实大小
        [dict1 setObject:[NSValue valueWithRect:NSMakeRect(0,  _containerView.frame.origin.y, self.frame.size.width,  _containerView.frame.size.height)] forKey:NSViewAnimationStartFrameKey];
        //设置最终大小
        if (isTwo) {
            [dict1 setObject:[NSValue valueWithRect:NSMakeRect(0,  _containerView.frame.origin.y+PopUpViewHeight * 2 , self.frame.size.width,  _containerView.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
        }else {
            [dict1 setObject:[NSValue valueWithRect:NSMakeRect(0,  _containerView.frame.origin.y+PopUpViewHeight , self.frame.size.width,  _containerView.frame.size.height)] forKey:NSViewAnimationEndFrameKey];
        }
        //设置动画效果
        // [dict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
        //设置动画
        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:dict,nil]];
        animation.delegate = self;
        [animation setDuration:0.3];
        //启动动画
        [animation startAnimation];
    }
}

- (void)animationDidEnd:(NSAnimation *)animation
{
    
    if ([self superview]) {
        [self removeFromSuperview];
    }
    
    if ([self superview]) {
        [self removeFromSuperview];
    }
    
}

- (void)closePopupView:(NSNotification *)notification
{
    NSDictionary *infor = notification.userInfo;
    NSEvent *event = [infor objectForKey:@"theEvent"];
    NSPoint mousePt = [self convertPoint:[event locationInWindow] fromView:nil];
    BOOL overClose = NSMouseInRect(mousePt,[self bounds], [self isFlipped]);
    if (!overClose) {
       NSString *claseType = [infor objectForKey:@"classType"];
       if([claseType isEqualToString:@"other"])
        {
            if ((self.frame.size.height == PopUpViewHeight||self.frame.size.height == PopUpViewHeight*2)&&[self canDraw]) {
                [_categoryBarView clickCategory:_categoryBarView.currentButton];
            }
        }
    }
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    //[super mouseDown:theEvent];
    
}

- (void)mouseUp:(NSEvent *)theEvent
{
    //注销mouseup事件，防止事件传递给父类
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notify_close_popupview" object:nil];
    [super dealloc];
}

@end

@implementation IMBPopupContentView
@synthesize startPoint = _startPoint;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _startPoint = frame.size.width/2.0;  //_startPoint默认值
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
//    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
//    [clipPath setWindingRule:NSEvenOddWindingRule];
//    [clipPath addClip];
//    [[NSColor redColor] set];
//    [clipPath fill];
//    [clipPath closePath];

//    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
//    [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.571 alpha:1.000]];
//    [shadow setShadowOffset:NSMakeSize(0.0, 1.0)];
//    [shadow setShadowBlurRadius:4];
//    [shadow set];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(_startPoint-ArrowSize, ArrowSize+2)];
    [path lineToPoint:NSMakePoint(_startPoint, 0)];
    [path lineToPoint:NSMakePoint(_startPoint+ArrowSize, ArrowSize+2)];
    [path addClip];
    [[NSColor colorWithCalibratedRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0] setStroke];
    [path stroke];
    
    [[NSColor colorWithCalibratedRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:0.11] setFill];
    [path fill];
}


- (BOOL)isFlipped
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    //[super mouseDown:theEvent];
    
}

- (void)mouseUp:(NSEvent *)theEvent
{
    //注销mouseup事件，防止事件传递给父类
}

- (void)dealloc
{
    [super dealloc];
}

@end

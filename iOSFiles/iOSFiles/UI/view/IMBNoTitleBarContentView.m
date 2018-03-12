//
//  IMBNoTitleBarContentView.m
//  MacClean
//
//  Created by LuoLei on 15-11-23.
//  Copyright (c) 2015年 iMobie. All rights reserved.
//

#import "IMBNoTitleBarContentView.h"
#import "IMBCommonDefine.h"


static int R = 5;
@implementation IMBNoTitleBarContentView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationViewChanged:) name:NSViewFrameDidChangeNotification object:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationViewChanged:) name:NSViewBoundsDidChangeNotification object:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationViewChanged:) name:NSViewGlobalFrameDidChangeNotification object:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationViewChanged:) name:NSViewFocusDidChangeNotification object:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationViewChanged:) name:NSViewDidUpdateTrackingAreasNotification object:self];
}

- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//    NSBezierPath *path=[NSBezierPath new];
//    [path appendBezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
//    [path addClip];
//    [path fill];
    
    
    
    int c = NSWidth(dirtyRect) / 2;
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    //在计算机设置中，直接选择rgb即可，其他颜色空间暂时不用考虑。
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //1.创建渐变
    /*
     1.<#CGColorSpaceRef space#> : 颜色空间 rgb
     2.<#const CGFloat *components#> ： 数组 每四个一组 表示一个颜色 ｛r,g,b,a ,r,g,b,a｝
     3.<#const CGFloat *locations#>:表示渐变的开始位置
     
     */
    
//    [COLOR_MAIN_WINDOW_BG set];
//    NSRectFill(dirtyRect);
    
    float r1 = 248.0f/255;
    float g1 = 248.0f/255;
    float b1 = 248.0f/255;
    float a1 = 1;
    float r2 = 248.0f/255;
    float g2 = 248.0f/255;
    float b2 = 248.0f/255;
    float a2 = 1;
    
    
    CGFloat components[8] = {r1,g1,b1,a1,r2,g2,b2,a2};
    CGFloat locations[2] = {0.0,1.0};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //渐变区域裁剪

    CGContextMoveToPoint(context, NSWidth(dirtyRect)- R, 0);
    CGContextAddLineToPoint(context, R, 0);
    CGContextAddArc(context, R, R, R, M_PI_2 , M_PI , YES);
    CGContextAddLineToPoint(context,  0, NSHeight(dirtyRect) - R);
    CGContextAddArc(context, R, NSHeight(dirtyRect) - R,R, M_PI, M_PI_2, YES);
    CGContextAddLineToPoint(context, NSWidth(dirtyRect) - R, NSHeight(dirtyRect));
    CGContextAddArc(context, NSWidth(dirtyRect) - R, NSHeight(dirtyRect) - R, R, M_PI_2, 0, YES);
    CGContextAddLineToPoint(context, NSWidth(dirtyRect), R);
    CGContextAddArc(context, NSWidth(dirtyRect) - R, R, R, 0, M_PI_2, YES);
    CGContextClip(context);//context裁剪路径,后续操作的路径
    
    //绘制渐变
    CGContextDrawLinearGradient(context, gradient, CGPointMake(c, 0), CGPointMake(c, NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
    //释放对象
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

- (void)mouseDragged:(NSEvent *)theEvent {
    [super mouseDragged:theEvent];
    [self setNeedsDisplay:YES];
}

- (BOOL)canBecomeKeyView {
    return YES;
}

- (void)notificationViewChanged:(NSNotification *)notify {
    [self setNeedsDisplay:YES];
}


@end

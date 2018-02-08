//
//  IMBBackgroundBorderView.h
//  MacClean
//
//  Created by Gehry on 12/29/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface IMBBackgroundBorderView : NSView{
    NSColor *_backgroundColor;
    NSColor *_topBorderColor;
    NSColor *_leftBorderColor;
    NSColor *_bottomBorderColor;
    NSColor *_rightBorderColor;
    NSColor *_borderColor;
    BOOL _hasTopBorder;
    BOOL _hasLeftBorder;
    BOOL _hasBottomBorder;
    BOOL _hasRightBorder;
    BOOL _hasRadius;
    BOOL _hasStrokeRadius;
    BOOL _hasStrokeRadiusAndBgColor;
    NSImage *_backgroundImage;
    CGFloat _xRadius;
    CGFloat _yRadius;
    BOOL _canScroll;
    BOOL _canClick;
    NSTrackingArea *trackingArea;
    IBOutlet NSViewController *_controller;
    BOOL _isGradientWithCornerPart1;//将背景颜色设置为渐变颜色,带有圆角,最上面一部分
    BOOL _isGradientNoCornerPart1;//将背景颜色设置为渐变颜色,没有圆角,最上面一部分
    BOOL _isGradientWithCornerPart2;//将背景颜色设置为渐变颜色,带有圆角,中间一部分
    BOOL _isGradientNoCornerPart2;//将背景颜色设置为渐变颜色,没有圆角,中间一部分
    BOOL _isGradientWithCornerPart3;//将背景颜色设置为渐变颜色,带有圆角,最下面一部分
    BOOL _isGradientNoCornerPart3;//将背景颜色设置为渐变颜色,没有圆角,最下面一部分
    BOOL _isGradientWithCornerPart4;//将背景颜色设置为渐变颜色,带有圆角,下面两个在一起
    BOOL _isGradientNoCornerPart4;//将背景颜色设置为渐变颜色,没有圆角,下面两个在一起

}
@property (nonatomic,assign)NSViewController *controller;
@property(nonatomic,retain)NSColor *backgroundColor;
@property(nonatomic,retain)NSColor *topBorderColor;
@property(nonatomic,retain)NSColor *leftBorderColor;
@property(nonatomic,retain)NSColor *bottomBorderColor;
@property(nonatomic,retain)NSColor *rightBorderColor;
@property(nonatomic,retain)NSColor *borderColor;
@property(nonatomic,assign)BOOL hasTopBorder;
@property(nonatomic,assign)BOOL hasLeftBorder;
@property(nonatomic,assign)BOOL hasBottomBorder;
@property(nonatomic,assign)BOOL hasRightBorder;
@property(nonatomic,assign)BOOL hasRadius;
@property(nonatomic,assign)BOOL hasStrokeRadius;
@property(nonatomic,assign)BOOL hasStrokeRadiusAndBgColor;

@property(nonatomic,retain)NSImage *backgroundImage;

@property (nonatomic, assign) BOOL isGradientWithCornerPart1;
@property (nonatomic, assign) BOOL isGradientNoCornerPart1;
@property (nonatomic, assign) BOOL isGradientWithCornerPart2;
@property (nonatomic, assign) BOOL isGradientNoCornerPart2;
@property (nonatomic, assign) BOOL isGradientWithCornerPart3;
@property (nonatomic, assign) BOOL isGradientNoCornerPart3;
@property (nonatomic, assign) BOOL isGradientWithCornerPart4;
@property (nonatomic, assign) BOOL isGradientNoCornerPart4;

- (void)setXRadius:(CGFloat)xRadius YRadius:(CGFloat)yRadius;
- (void)setCanScroll:(BOOL)canScroll;
- (void)setCanClick:(BOOL)canClick;
@end

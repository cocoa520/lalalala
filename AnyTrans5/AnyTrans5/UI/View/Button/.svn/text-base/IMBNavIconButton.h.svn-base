//
//  IMBNavIconButton.h
//  AnyTrans
//
//  Created by m on 17/8/15.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PocketSVG.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBNavPopoverWindowController.h"

@interface IMBNavIconButton : NSButton
{
    NSTrackingArea *trackingArea;
    NSImage *_mouseExitImage;
    NSImage *_mouseEnteredImage;
    NSImage *_mouseDownImage;
    NSImage *_forBidImage;
    BOOL _isSelected;
    
    BOOL _isDrawBorder;
    int _status;
    BOOL _hasPopover;
    id _delegate;
    BOOL _isShowTips;
    BOOL _hasExite;
    BOOL _hasSpot;
    BOOL _isDrawRectLine;
    CALayer *_subLayer;
    CAGradientLayer *_gradientLayer;
    
    CALayer *_animationLayer;
    NSString *_svgAnimationName;
    BOOL _isAnimation;
    
    PocketSVG *_myVectorDrawing;
@public
    IMBNavPopoverWindowController *_navPopWindow;
}
@property (assign) int status;
@property (assign,nonatomic)BOOL isSelected;
@property (retain) NSImage *MouseExitImage;
@property (retain) NSImage *MouseEnteredImage;
@property (retain) NSImage *MouseDownImage;
@property (nonatomic,retain) NSImage *forBidImage;
@property (nonatomic, assign) BOOL hasPopover;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL isShowTips;
@property (nonatomic, assign) BOOL hasSpot;
@property (nonatomic, assign) BOOL isDrawRectLine;

//设置按钮的图片
-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3 forBidImage:(NSImage *)forBidImage;
-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3;

- (void)setIsDrawBorder:(BOOL)isDraw;
- (void)setSvgFileName:(NSString *)svgName;

@end

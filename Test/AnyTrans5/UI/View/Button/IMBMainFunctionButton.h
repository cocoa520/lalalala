//
//  IMBMainFunctionButton.h
//  AnyTrans
//
//  Created by iMobie on 7/18/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@class IMBMainFunctionBackgroundView;

@interface IMBMainFunctionButton : NSButton {
    MouseStatusEnum _buttonType;    //按钮状态
    NSString *_titleName;           //按钮名字
    float _interval;                //图片与文字间距
    NSFont *_font;                  //文字字体
    NSColor *_textColor;            //文字颜色
    NSTrackingArea *_trackingArea;
    NSColor *_backgroundColor;      //背景颜色
    NSImage *_buttonImage;
    
    //渐变颜色值
    CGFloat _r1;
    CGFloat _g1;
    CGFloat _b1;
    CGFloat _a1;
    CGFloat _r2;
    CGFloat _g2;
    CGFloat _b2;
    CGFloat _a2;
    
    IMBMainFunctionBackgroundView *_backgroundView;
    IMBMainFunctionBackgroundView *_imageTitleView;
//    NSTextField *_titleField;
//    NSImageView *_icon;
//    CALayer *_maskLayer;
    NSRect _oringalFrame;
    
    NSInteger _evNum;
    BOOL _isDown;
    BOOL _isToiOSBtn;
}
@property (nonatomic, assign) BOOL isToiOSBtn;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic,assign)NSRect oringalFrame;
@property (nonatomic, assign) MouseStatusEnum buttonType;
@property (nonatomic, assign) float interval;
@property (nonatomic, retain) NSString *titleName;
@property (nonatomic, retain) NSImage *buttonImage;
@property (nonatomic, retain) NSColor *backgroundColor;

-(void)setTitleName:(NSString *)titleName WithDarwInterval:(float)interval withFont:(NSFont *)textFont withButtonImage:(NSImage *)image withTextColor:(NSColor *)color;

- (void)setComponentColor:(float)r1 withG1:(float)g1 withB1:(float)b1 withAlpha1:(float)a1 withR2:(float)r2 withG2:(float)g2 withB2:(float)b2 withAlpha2:(float)a2;
- (void)setTrackingAreaEnable:(BOOL)trackingAreaEnable;

@end

@interface IMBMainFunctionBackgroundView : NSView
{
    CGFloat _r1;
    CGFloat _g1;
    CGFloat _b1;
    CGFloat _a1;
    CGFloat _r2;
    CGFloat _g2;
    CGFloat _b2;
    CGFloat _a2;
    
    NSString *_titleName;
    NSImage *_buttonImage;
    float _interval;                //图片与文字间距
    NSFont *_font;                  //文字字体
    NSColor *_textColor;            //文字颜色
    MouseStatusEnum _buttonType;    //按钮状态
    
    BOOL _isImage;
    BOOL _isToiOSBtn;
}
@property (nonatomic,assign)BOOL isToiOSBtn;
@property (nonatomic,assign)CGFloat r1;
@property (nonatomic,assign)CGFloat g1;
@property (nonatomic,assign)CGFloat b1;
@property (nonatomic,assign)CGFloat a1;
@property (nonatomic,assign)CGFloat r2;
@property (nonatomic,assign)CGFloat g2;
@property (nonatomic,assign)CGFloat b2;
@property (nonatomic,assign)CGFloat a2;
@property (nonatomic, retain) NSString *titleName;
@property (nonatomic, retain) NSImage *buttonImage;
@property (nonatomic, assign) MouseStatusEnum buttonType;

-(void)setTitleName:(NSString *)titleName WithDarwInterval:(float)interval withFont:(NSFont *)textFont withButtonImage:(NSImage *)image withTextColor:(NSColor *)color withIsImage:(BOOL)isImage withIsToiOSBtn:(BOOL) isToiOSBtn;

@end

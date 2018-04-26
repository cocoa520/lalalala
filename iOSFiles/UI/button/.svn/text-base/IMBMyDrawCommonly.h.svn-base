//
//  LFButtn.h
//  NSDraw
//
//  Created by iMobie023 on 16-3-2.
//  Copyright (c) 2016年 iMobie023. All rights reserved.
//
//自己draw按钮，不用图片

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBMyDrawCommonly : NSButton
{
    MouseStatusEnum _buttonType;
    NSString *_titleName;
    float _darwRoundedRect;
    NSFont *font;
    //现宽
    int _lineWidth;
    //文字的颜色
    NSColor *_mouseDowntextColor;
    NSColor *_mouseUptextColor;
    NSColor *_mouseEnteredtextColor;
    NSColor *_mouseExitedtextColor;
    
    NSColor *textColor;
    NSTrackingArea *_trackingArea;
    
    //线的颜色
    NSColor *_mouseDownLineColor;
    NSColor *_mouseUpLineColor;
    NSColor *_mouseEnteredLineColor;
    NSColor *_mouseExitedLineColor;
    
    //填充的颜色
    NSColor *_mouseDownfillColor;
    NSColor *_mouseUpfillColor;
    NSColor *_mouseEnteredfillColor;
    NSColor *_mouseExitedfillColor;
    NSColor *_backgroundColor;
}
@property (nonatomic, assign) MouseStatusEnum buttonType;
@property (nonatomic, assign) int lineWidth;
@property (nonatomic, assign) float darwRoundedRect;
@property (nonatomic, retain) NSColor *mouseDownLineColor;
@property (nonatomic, retain) NSColor *mouseUpLineColor;
@property (nonatomic, retain) NSColor *mouseEnteredLineColor;
@property (nonatomic, retain) NSColor *mouseExitedLineColor;

@property (nonatomic, retain) NSColor *mouseDownfillColor;
@property (nonatomic, retain) NSColor *mouseUpfillColor;
@property (nonatomic, retain) NSColor *mouseEnteredfillColor;
@property (nonatomic, retain) NSColor *mouseExitedfillColor;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSString *titleName;
//文字颜色
-(void)WithMouseExitedtextColor:(NSColor *)exitedtextColor WithMouseUptextColor:(NSColor *)uptextColor WithMouseDowntextColor:(NSColor *)downtextColor withMouseEnteredtextColor:(NSColor *)enteredtextColor;
//线的颜色
-(void)WithMouseExitedLineColor:(NSColor *)exitedLineColor WithMouseUpLineColor:(NSColor *)upLineColor WithMouseDownLineColor:(NSColor *)downLineColor withMouseEnteredLineColor:(NSColor *)enteredLineColor;
//填充的颜色
-(void)WithMouseExitedfillColor:(NSColor *)exitedfillColor WithMouseUpfillColor:(NSColor *)upfillColor WithMouseDownfillColor:(NSColor *)downfillColor withMouseEnteredfillColor:(NSColor *)enteredfillColor;
//设置各种属性 btn titile 弧度 线宽 字体样式
-(void)setTitleName:(NSString *)titleName WithDarwRoundRect:(float)roundRect WithLineWidth:(int) width withFont:(NSFont *)textFont;
@end

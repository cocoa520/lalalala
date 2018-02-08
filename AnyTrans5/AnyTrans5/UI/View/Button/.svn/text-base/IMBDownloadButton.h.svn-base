//
//  IMBDownloadButton.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface IMBDownloadButton : NSButton
{
    NSTrackingArea *_trackingArea;
    BOOL _mouseDown;
    BOOL _mouseEnter;
    NSFont *_font;
    NSColor *_fontColor;
    NSColor *_fontEnterColor;
    NSColor *_fontDownColor;
    float _minWidth;
    CGFloat _cornerRadius;
    NSImage *_iconImage;
    CALayer *_parseLayer;
    BOOL _variableWidth;
    //normal 渐变色
    NSColor *_leftnormalFillColor;
    NSColor *_rightnormalFillColor;
    //enter
    NSColor *_leftenterFillColor;
    NSColor *_rightenterFillColor;
    //down
    NSColor *_leftdownFillColor;
    NSColor *_rightdownFillColor;
    NSColor *_borderColor;
    BOOL _isleftright;
}
@property (nonatomic,assign)BOOL isleftright;
@property (nonatomic,assign)BOOL variableWidth;
@property (nonatomic, readwrite, retain) NSFont *font;
@property (nonatomic, readwrite, retain) NSColor *fontColor;
@property (nonatomic, readwrite, retain) NSColor *fontEnterColor;
@property (nonatomic, readwrite, retain) NSColor *fontDownColor;
@property (nonatomic, readwrite, retain) NSColor *borderColor;
@property (nonatomic,retain)NSImage *iconImage;
@property (nonatomic,retain)NSColor *leftnormalFillColor;
@property (nonatomic,retain)NSColor *rightnormalFillColor;
@property (nonatomic,retain)NSColor *leftenterFillColor;
@property (nonatomic,retain)NSColor *rightenterFillColor;
@property (nonatomic,retain)NSColor *leftdownFillColor;
@property (nonatomic,retain)NSColor *rightdownFillColor;

- (void)resetColor;
- (void)startParseAnimation;
- (void)stopParseAnimation;
@end

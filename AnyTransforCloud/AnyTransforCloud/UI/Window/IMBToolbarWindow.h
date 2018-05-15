//
//  IMBToolbarWindow.h
//  iMobieTrans
//
//  Created by Pallas on 3/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IMBWindowButton;
@class IMBToolbarWindowDelegateProxy;
@class IMBTitlebarContainer;

@class IMBTabView;
@interface IMBTitlebarView : NSView {
    
}

@end

typedef void (^IMBToolbarWindowTitleBarDrawingBlock)(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath);

@interface IMBToolbarWindow : NSWindow {
@private
    CGFloat _titleBarHeight;
    NSView *_titleBarView;
    BOOL _centerFullScreenButton;
    BOOL _centerTrafficLightButtons;
    BOOL _verticalTrafficLightButtons;
    BOOL _verticallyCenterTitle;
    BOOL _hideTitleBarInFullScreen;
    BOOL _showsBaselineSeparator;
    CGFloat _trafficLightButtonsLeftMargin;
    CGFloat _trafficLightButtonsTopMargin;
    CGFloat _fullScreenButtonRightMargin;
    CGFloat _fullScreenButtonTopMargin;
    CGFloat _trafficLightSeparation;
    CGFloat _mouseDragDetectionThreshold;
    BOOL _showsTitle;
    BOOL _showsTitleInFullscreen;
    BOOL _showsDocumentProxyIcon;
    IMBWindowButton *_closeButton;
    IMBWindowButton *_minimizeButton;
    IMBWindowButton *_zoomButton;
    IMBWindowButton *_fullScreenButton;
    NSFont *_titleFont;
    NSColor *_titleBarStartColor;
    NSColor *_titleBarEndColor;
    NSColor *_baselineSeparatorColor;
    NSColor *_titleTextColor;
    NSShadow *_titleTextShadow;
    NSColor *_inactiveTitleBarStartColor;
    NSColor *_inactiveTitleBarEndColor;
    NSColor *_inactiveBaselineSeparatorColor;
    NSColor *_inactiveTitleTextColor;
    NSShadow *_inactiveTitleTextShadow;
    IMBToolbarWindowTitleBarDrawingBlock _titleBarDrawingBlock;
    
    CGFloat _cachedTitleBarHeight;
	BOOL _setFullScreenButtonRightMargin;
	BOOL _preventWindowFrameChange;
	IMBToolbarWindowDelegateProxy *_delegateProxy;
	IMBTitlebarContainer *_titlebarContainer;
    
    id _regTarget;
    SEL _regAction;
    NSColor *_windowTitleColor;
    
}
@property (nonatomic, retain) NSColor *windowTitleColor;

@property (nonatomic) CGFloat titleBarHeight;

@property (nonatomic, strong) NSView *titleBarView;

@property (nonatomic) BOOL centerFullScreenButton;

@property (nonatomic) BOOL centerTrafficLightButtons;

@property (nonatomic) BOOL verticalTrafficLightButtons;

@property (nonatomic) BOOL verticallyCenterTitle;

@property (nonatomic) BOOL hideTitleBarInFullScreen;

@property (nonatomic) BOOL showsBaselineSeparator;

@property (nonatomic) CGFloat trafficLightButtonsLeftMargin;

@property (nonatomic) CGFloat trafficLightButtonsTopMargin;

@property (nonatomic) CGFloat fullScreenButtonRightMargin;

@property (nonatomic) CGFloat fullScreenButtonTopMargin;

@property (nonatomic) CGFloat trafficLightSeparation;

@property (nonatomic) CGFloat mouseDragDetectionThreshold;

@property (nonatomic) BOOL showsTitle;

@property (nonatomic) BOOL showsTitleInFullscreen;

@property (nonatomic) BOOL showsDocumentProxyIcon;

@property (nonatomic, strong) IMBWindowButton *closeButton;

@property (nonatomic, strong) IMBWindowButton *minimizeButton;

@property (nonatomic, strong) IMBWindowButton *zoomButton;

@property (nonatomic, strong) IMBWindowButton *fullScreenButton;

@property (nonatomic, strong) NSFont *titleFont;

@property (nonatomic, strong) NSColor *titleBarStartColor;

@property (nonatomic, strong) NSColor *titleBarEndColor;

@property (nonatomic, strong) NSColor *baselineSeparatorColor;

@property (nonatomic, strong) NSColor *titleTextColor;

@property (nonatomic, strong) NSShadow *titleTextShadow;

@property (nonatomic, strong) NSColor *inactiveTitleBarStartColor;

@property (nonatomic, strong) NSColor *inactiveTitleBarEndColor;

@property (nonatomic, strong) NSColor *inactiveBaselineSeparatorColor;

@property (nonatomic, strong) NSColor *inactiveTitleTextColor;

@property (nonatomic, strong) NSShadow *inactiveTitleTextShadow;

@property (nonatomic, copy) IMBToolbarWindowTitleBarDrawingBlock titleBarDrawingBlock;

@property (nonatomic) CGFloat cachedTitleBarHeight;

@property (nonatomic) BOOL setFullScreenButtonRightMargin;

@property (nonatomic) BOOL preventWindowFrameChange;

@property (nonatomic, copy) IMBToolbarWindowDelegateProxy *delegateProxy;

@property (nonatomic, copy) IMBTitlebarContainer *titlebarContainer;

@property (nonatomic, readwrite, strong) id regTarget;

@property (nonatomic, readwrite) SEL regAction;

+ (NSColor *)defaultTitleBarStartColor:(BOOL)drawsAsMainWindow;

+ (NSColor *)defaultTitleBarEndColor:(BOOL)drawsAsMainWindow;

+ (NSColor *)defaultBaselineSeparatorColor:(BOOL)drawsAsMainWindow;

+ (NSColor *)defaultTitleTextColor:(BOOL)drawsAsMainWindow;

- (void)setTitleBarHeight:(CGFloat)titleBarHeight adjustWindowFrame:(BOOL)adjustWindowFrame;

@end

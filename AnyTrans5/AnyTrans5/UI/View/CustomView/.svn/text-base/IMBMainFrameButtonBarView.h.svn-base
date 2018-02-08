//
//  IMBMainFrameButtonBarView.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBNavIconButton.h"
#import "IMBNavPopoverWindowController.h"
#import "IMBPopOverView.h"
#import "IMBCommonEnum.h"

typedef void (^FunctionModuleBlock)(FunctionType);
#define FunctionButtonWdith 46.0
#define FunctionButtonHight 46.0
#define SeparationWidth 20.0
#define OriginPointX 0.0

@class IMBNavPopSuperView;
@interface IMBMainFrameButtonBarView : NSView<NSPopoverDelegate>
{
    NSMutableArray *_functionButtonsArray;
    FunctionModuleBlock _buttonblock;
    IMBNavPopoverWindowController *_navPopWindow;
    IMBPopOverView *_navPopView;
    IMBNavPopSuperView *_navPopSuperView;
    
    NSTrackingArea *_trackingArea;
    BOOL _mouseOver;
    BOOL _mouseOverWindow;
    BOOL _hasNavPopover;
    FunctionType _currentType;
    FunctionType _selectType;
    BOOL _isTimer;
    BOOL _isShowing;
    
    NSTimer *_timer;
    FunctionType _lastFuntionType;
}

@property (nonatomic, assign) BOOL hasNavPopover;
@property (nonatomic, readwrite, retain) NSMutableArray *functionButtonsArray;
@property (nonatomic, readwrite, retain) IMBNavPopoverWindowController *navPopWindow;

- (id)initwithFunctionModulBlock:(FunctionModuleBlock)block;
- (void)clickFunctionButton:(IMBNavIconButton *)sender;
- (void)closeNavPopover:(id)sender;
@end
@interface FunctionTypeEnum : NSObject
+(NSString *)functionTypeToString:(FunctionType)type;

@end

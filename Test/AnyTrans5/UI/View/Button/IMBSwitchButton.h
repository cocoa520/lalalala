//
//  IMBSwitchButton.h
//  MacClean
//
//  Created by LuoLei on 15-5-6.
//  Copyright (c) 2015年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface IMBSwitchButton : NSControl {
    NSColor *_tintColor;
    NSColor *_tintBorderColor;
    NSColor *_noTintColor;
    NSColor *_noTintBorderColor;

    CALayer *_rootLayer;
    CALayer *_backgroundLayer;
    CALayer *_knobLayer;
    CALayer *_knobInsideLayer;
     id _target;
    SEL _action;
    BOOL hasDragged;
    BOOL _isOn;
    BOOL isActive;
    BOOL isDraggingTowardsOn;
}
@property (nonatomic, setter = setOn:) BOOL isOn;
@property (nonatomic, setter = setActive:) BOOL isActive;
@property (nonatomic, setter = setDragged:) BOOL hasDragged;
@property (nonatomic, setter = setDraggingTowardsOn:) BOOL isDraggingTowardsOn;
@property (nonatomic, readonly, retain) CALayer *rootLayer;
@property (nonatomic, readonly, retain) CALayer *backgroundLayer;
@property (nonatomic, readonly, retain) CALayer *knobLayer;
@property (nonatomic, readonly, retain) CALayer *knobInsideLayer;

//设置颜色
//打开
@property (nonatomic, retain) NSColor *tintColor;
//打开边框
@property (nonatomic, retain) NSColor *tintBorderColor;
//没打开
@property (nonatomic, retain) NSColor *noTintColor;
//没打开边框
@property (nonatomic, retain) NSColor *noTintBorderColor;
@property (nonatomic,setter = setEnabled:,getter = isEnabled)BOOL enabled;

- (BOOL)isEnabled;
- (void)setEnabled:(BOOL)enabled;
@end

//
//  IMBSelecedDeviceBtn.h
//  PhotoManage
//
//  Created by iMobie023 on 16-1-19.
//  Copyright (c) 2016年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBSelecedDeviceBtn : NSButton
{
    MouseStatusEnum _mouseStatus;
    NSTrackingArea *_trackingArea;
    NSNotificationCenter *nc;
    BOOL _isShowIcon;
    BOOL _isShowTrangle;
    BOOL _isDisable;
    float _textSize;
    NSSize _sizeWidth;
    NSColor *_textColor;
    NSString *_buttonName;
    IPodFamilyEnum _connectTpye;
}
@property (nonatomic, retain) NSString *buttonName;
@property (nonatomic, retain) NSColor *textColor;
@property (nonatomic, assign) float textSize;
@property (nonatomic, setter = setIsDisable:) BOOL isDisable;
@property (nonatomic, setter = setMouseStatus:) MouseStatusEnum mouseStatus;
@property (nonatomic, setter = setIsShowIcon:) BOOL isShowIcon;
@property (nonatomic, setter = setIsShowTangle:) BOOL isShowTrangle;
@property (nonatomic, assign) IPodFamilyEnum connectType;

- (void)setIsDisable:(BOOL)isDisable;
- (void)setMouseStatus:(MouseStatusEnum)mouseStatus;
- (void)setInitFrame:(NSRect)frameRect withButtonTitle:(NSString *)buttonTitle;
- (void)configButtonName:(NSString *)buttonName WithTextColor:(NSColor *)textColor WithTextSize:(float)size WithIsShowIcon:(BOOL)showIcon WithIsShowTrangle:(BOOL)showTrangle  WithIsDisable:(BOOL)isDisable withConnectType:(IPodFamilyEnum)connectType;
@end

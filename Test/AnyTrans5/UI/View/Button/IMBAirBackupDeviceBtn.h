//
//  IMBAirBackupDeviceBtn.h
//  AnyTrans
//
//  Created by smz on 17/10/20.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
@interface IMBAirBackupDeviceBtn : NSButton
{
    MouseStatusEnum _mouseStatus;
    NSTrackingArea *_trackingArea;
    NSNotificationCenter *nc;
    float _textSize;
    NSSize _sizeWidth;
    NSColor *_textColor;
    NSString *_buttonName;
    BOOL _hasBorder;
    BOOL _isDisable;
    BOOL _isOnline;
}
@property (nonatomic, retain) NSString *buttonName;
@property (nonatomic, retain) NSColor *textColor;
@property (nonatomic, assign) float textSize;
@property (nonatomic, setter = setMouseStatus:) MouseStatusEnum mouseStatus;
@property (nonatomic, setter = setIsDisable:) BOOL isDisable;
@property (nonatomic, assign) BOOL isOnline;

- (void)setIsDisable:(BOOL)isDisable;
- (void)setMouseStatus:(MouseStatusEnum)mouseStatus;
- (void)configButtonName:(NSString *)buttonName WithTextColor:(NSColor *)textColor WithTextSize:(float)size WithOnline:(BOOL)online;
@end

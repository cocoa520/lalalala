//
//  IMBSelectedButton.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBSelectedButton : NSButton {
    NSString *_buttonTitle;
    NSColor *_enterColor;
    NSColor *_exitColor;
    NSColor *_downColor;
    NSColor *_selectColor;
    NSFont *_font;
    BOOL _isSelect;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}

@property (nonatomic, assign) BOOL isSelect;

- (void)setEnterColor:(NSColor *)enterColor downColor:(NSColor *)downColor ExitColor:(NSColor *)exitColor SelectColor:(NSColor *)selectColor titleFont:(NSFont *)font buttonTitle:(NSString *)buttonTitle;

@end

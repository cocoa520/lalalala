//
//  IMBHeadImageButton.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/18.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBHeadImageButton : NSButton {
    NSImage *_headImage;
    NSImage *_subscriptImage;//下标图片
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
    NSColor *_normalColor;
    NSColor *_enterColor;
    NSColor *_downColor;
}
/**
 *  按钮属性设置
 *
 *  @param normalColor    普通背景颜色
 *  @param enterColor     鼠标经过背景颜色
 *  @param downColor      鼠标点击背景颜色
 *  @param headImage      头像图片
 *  @param subscriptImage 下标图片
 */
- (void)setMouseNormalColor:(NSColor *)normalColor WithMouseEnterColor:(NSColor *)enterColor WithMouseDownColor:(NSColor *)downColor WithHeadImage:(NSImage *)headImage WithSubscriptImage:(NSImage *)subscriptImage;

@end

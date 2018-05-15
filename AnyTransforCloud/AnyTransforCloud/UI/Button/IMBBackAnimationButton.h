//
//  IMBBackAnimationButton.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/19.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBBackAnimationButton : NSButton {
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
    
    NSImage *_mouseExitedImage;
    NSImage *_mouseEnteredImage;
    NSImage *_mouseDownImage;
    
    NSString *_buttonTitle;
    NSColor *_titleNormalColor;
    NSColor *_titleEnterColor;
    NSColor *_titleDownColor;
    CALayer *_imageLayer;
}
/**
 *  设置按钮图片属性
 *
 *  @param mouseExiteImg 正常显示图片
 *  @param mouseEnterImg 进入显示图片
 *  @param mouseDownImg  点击显示图片
 */
- (void)setMouseExitedImg:(NSImage *)mouseExiteImg withMouseEnterImg:(NSImage *)mouseEnterImg withMouseDownImage:(NSImage*)mouseDownImg;

/**
 *  设置按钮文字属性
 *
 *  @param buttonTitle         按钮名字
 *  @param titleNormalColor    一般文字颜色
 *  @param titleEnterColor     进入文字颜色
 *  @param titleDownColor      点击文字颜色
 */
- (void)setButtonWithTitle:(NSString *)buttonTitle WithTitleNormalColor:(NSColor *)titleNormalColor WithTitleEnterColor:(NSColor *)titleEnterColor WithTitleDownColor:(NSColor *)titleDownColor;

@end

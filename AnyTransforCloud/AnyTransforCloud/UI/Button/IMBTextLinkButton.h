//
//  IMBTextLinkButton.h
//  AnyTrans
//
//  Created by smz on 17/11/1.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBTextLinkButton : NSButton {
    NSString *_buttonTitle;
    float _fontSize;
    NSColor *_titleColor;
    NSColor *_titleEnterColor;
    NSColor *_titleDownColor;
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, retain) NSString *buttonTitle;
/**
 *  配置按钮属性
 *
 *  @param buttonTitle     按钮标题
 *  @param fontSize        标题字体大小
 *  @param titleColor      标题一般颜色
 *  @param titleEnterColor 标题进入颜色
 *  @param titleDownColor  标题点击颜色
 */
- (void)setButtonWithTitle:(NSString *)buttonTitle WithFontSize:(float)fontSize WithTitleColor:(NSColor *)titleColor WithTitleEnterColor:(NSColor *)titleEnterColor WithTitleDownColor:(NSColor *)titleDownColor;

@end

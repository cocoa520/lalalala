//
//  IMBCanClickText.h
//  PhoneRescue
//
//  Created by smz on 17/9/12.
//  Copyright (c) 2017年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBCanClickText : NSTextView {
    NSString *_normalString;
    NSString *_linkString1;
    NSColor *_linkNormalColor;
    NSColor *_linkEnterColor;
    NSColor *_linkDownColor;
    NSColor *_normalColor;
    NSFont *_font;
    MouseStatusEnum _mouseType;
    NSColor *_linkColor;
    NSString *_linkString2;
    float _lineSpace;
}
@property (nonatomic ,assign) float lineSpace;
/**
 *  可点击文字属性配置
 *
 *  @param normalString    已经拼接完整的整句话
 *  @param linkString1     第一段可点击文字
 *  @param linkString2     第二段可点击文字（如没有就填 @""）
 *  @param normalColor     文字的普通颜色
 *  @param linkNormalColor 可点击文字一般颜色
 *  @param linkEnterColor  可点击文字进入颜色
 *  @param linkDownColor   可点击文字点击颜色
 *  @param font            文字样式
 */
- (void)setNormalString:(NSString *)normalString WithLinkString1:(NSString *)linkString1 WithLinkString2:(NSString *)linkString2 WithNormalColor:(NSColor *)normalColor WithLinkNormalColor:(NSColor *)linkNormalColor WithLinkEnterColor:(NSColor *)linkEnterColor WithLinkDownColor:(NSColor *)linkDownColor WithFont:(NSFont *)font;

@end

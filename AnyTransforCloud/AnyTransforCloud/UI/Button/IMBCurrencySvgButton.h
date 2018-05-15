//
//  IMBCurrencySvgButton.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/18.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"
#import "PocketSVG.h"
#import <QuartzCore/QuartzCore.h>
@interface IMBCurrencySvgButton : NSButton
{
    PocketSVG *_myVectorDrawing;
    MouseStatusEnum _mouseState;
    NSTrackingArea *_trackingArea;
    NSColor *_enterColor;
    NSColor *_outColor;
    NSColor *_downColor;
    CALayer *_subLayer;
    CAShapeLayer *_myShapeLayer2;
    BOOL _isFill;
}
@property (nonatomic, assign) BOOL isBorderView;
/**
 *  设置SVG名称，颜色
 *
 *  @param svgName    svg名称
 *  @param isFill     是否用填充颜色，如果是YES，用填充颜色设置图案颜色，如果NO，用stoke颜色设置图案颜色
 *  @param svgSize    SVG图片的大小
 *  @param enterColor 进入时候的颜色
 *  @param outColor   退出时候的颜色
 *  @param downColor  点击时候的颜色
 */
- (void)setSvgFileName:(NSString *)svgName withUseFillColor:(BOOL)isFill withSVGSize:(NSSize)svgSize withEnterColor:(NSColor *)enterColor withOutColor:(NSColor *) outColor withDownColor:(NSColor *)downColor;
@end

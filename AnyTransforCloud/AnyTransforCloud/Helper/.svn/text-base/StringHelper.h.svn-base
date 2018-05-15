//
//  StringHelper.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
@interface StringHelper : NSObject

+ (BOOL)stringIsNilOrEmpty:(NSString*)string;
+ (NSString*)getTimeString:(long)totalLength;
+ (NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints;
+ (NSString *)dataToString:(NSData *)data;
+ (NSColor *)getColorFromString:(NSString *)str;//将String 转为Color

/**
 *  设置文本样式
 *
 *  @param promptStr    文本内容
 *  @param font         字体样式
 *  @param lineSpace    行间距
 *  @param alignment    位置偏向
 *  @param color        文字颜色
 */
+ (NSMutableAttributedString *)setTextWordStyle:(NSString *)promptStr withFont:(NSFont *)font withLineSpacing:(float)lineSpace withAlignment:(NSTextAlignment)alignment withColor:(NSColor *)color;

/**
 *  计算文本size
 *
 *  @param text    文本内容
 *  @param font    字体样式 [NSFont fontWithName:@"Helvetica Neue" size:14.0]
 */
+ (NSRect)calcuTextBounds:(NSString *)text font:(NSFont *)font;

/**
 *  设置带省略号的文本样式
 *
 *  @param promptStr     文本内容
 *  @param font          字体样式
 *  @param alignment     位置偏向
 *  @param lineBreakMode 省略模式
 *  @param color         文字颜色
 *
 *  @return 属性字符串
 */
+ (NSAttributedString *)setTextWordStyle:(NSString *)promptStr withFont:(NSFont *)font withAlignment:(NSTextAlignment)alignment withLineBreakMode:(NSLineBreakMode)lineBreakMode withColor:(NSColor *)color;

/**
 *  检查邮箱是否合法
 *
 *  @param email 邮箱地址
 *
 *  @return YES，是合法的；
 */
+ (BOOL)checkEmailIsRight:(NSString *)email;

/**
 *  检查密码是否同时包含数字和字母
 *
 *  @param password 输入密码
 *
 *  @return YES，是包含的;
 */
+ (BOOL)checkPasswordIsRight:(NSString *)password;

/**
 *  检查邮箱长度是否超长
 *
 *  @param email 邮箱地址
 *
 *  @return YES，是没有超长；
 */
+ (BOOL)checkEmailIslengthMore:(NSString *)email;

/**
 *  检查邮箱长度是否过短
 *
 *  @param email 邮箱地址
 *
 *  @return NO，过短；
 */
+ (BOOL)checkEmailIslengthShort:(NSString *)email;

@end

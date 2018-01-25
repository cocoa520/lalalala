//
//  StringHelper.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface StringHelper : NSObject

+ (BOOL)stringIsNilOrEmpty:(NSString*)string;
+ (NSImage *)imageNamed:(NSString *)name;
+ (NSMutableAttributedString*)TruncatingTailForStringDrawing:(NSString*)myString withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withMaxWidth:(float)maxWidth withSize:(NSSize*)size withColor:(NSColor*)color withAlignment:(NSTextAlignment)alignment;
//计算文字的尺寸
+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize;

@end

//
//  NSColor+Category.h
//  AnyTrans
//
//  Created by LuoLei on 16-11-1.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Category)
- (CGColorRef)toCGColor;
+ (NSColor*)colorFromCGColor:(CGColorRef)CGColor;
@end

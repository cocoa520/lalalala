//
//  NSColor+Category.m
//  AnyTrans
//
//  Created by LuoLei on 16-11-1.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "NSColor+Category.h"
@implementation NSColor (Category)
- (CGColorRef)toCGColor {
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    
    [self getComponents:(CGFloat*)&components];
    return (CGColorRef)[(id)CGColorCreate(colorSpace, components) autorelease];
}

+ (NSColor*)colorFromCGColor:(CGColorRef)CGColor {
    if (CGColor == NULL) return nil;
    return [NSColor colorWithCIColor:[CIColor colorWithCGColor:CGColor]];
}

@end

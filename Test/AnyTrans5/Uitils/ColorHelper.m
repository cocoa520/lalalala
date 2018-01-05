//
//  ColorHelper.m
//  AnyTrans
//
//  Created by m on 11/11/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "ColorHelper.h"

@implementation ColorHelper

+ (void)setGrientColorWithRect:(NSRect) dirtyRect withCorner:(BOOL)hasCorner withPart:(int)part{
    int c = NSWidth(dirtyRect) / 2;
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    //在计算机设置中，直接选择rgb即可，其他颜色空间暂时不用考虑。
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //1.创建渐变
    /*
     1.<#CGColorSpaceRef space#> : 颜色空间 rgb
     2.<#const CGFloat *components#> ： 数组 每四个一组 表示一个颜色 ｛r,g,b,a ,r,g,b,a｝
     3.<#const CGFloat *locations#>:表示渐变的开始位置
     
     */
    
    float r1;
    float g1;
    float b1;
    float a1;
    float r2;
    float g2;
    float b2;
    float a2;
    if (part == 1) {
        r1 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:0];
        g1 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:1];
        b1 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:2];
        a1 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:3];
        r2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:0];
        g2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:1];
        b2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:2];
        a2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:3];
    }else if (part == 2) {
        r1 = [self getColorFromColorString:@"mainView_bgColor_middle" WithIndex:0];
        g1 = [self getColorFromColorString:@"mainView_bgColor_middle" WithIndex:1];
        b1 = [self getColorFromColorString:@"mainView_bgColor_middle" WithIndex:2];
        a1 = [self getColorFromColorString:@"mainView_bgColor_middle" WithIndex:3];
        r2 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:0];
        g2 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:1];
        b2 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:2];
        a2 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:3];
    }else if (part == 3){
        r1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:0];
        g1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:1];
        b1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:2];
        a1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:3];
        r2 = [self getColorFromColorString:@"mainView_bgColor_middle" WithIndex:0];
        g2 = [self getColorFromColorString:@"mainView_bgColor_middle" WithIndex:1];
        b2 = [self getColorFromColorString:@"mainView_bgColor_middle" WithIndex:2];
        a2 = [self getColorFromColorString:@"mainView_bgColor_middle" WithIndex:3];
    }else if (part == 4){
        r1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:0];
        g1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:1];
        b1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:2];
        a1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:3];
        r2 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:0];
        g2 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:1];
        b2 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:2];
        a2 = [self getColorFromColorString:@"mainView_bgColor_top" WithIndex:3];
    }else {
        r1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:0];
        g1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:1];
        b1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:2];
        a1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:3];
        r2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:0];
        g2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:1];
        b2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:2];
        a2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:3];
    }

    CGFloat components[8] = {r1,g1,b1,a1,r2,g2,b2,a2};
    CGFloat locations[2] = {0.0,1.0};
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //渐变区域裁剪
    if (hasCorner) {
        int radius = 5;
        CGContextMoveToPoint(context, NSWidth(dirtyRect)- radius, 0);
        CGContextAddLineToPoint(context, radius, 0);
        CGContextAddArc(context, radius, radius, radius, M_PI_2 , M_PI , YES);
        CGContextAddLineToPoint(context,  0, NSHeight(dirtyRect) - radius);
        CGContextAddArc(context, radius, NSHeight(dirtyRect) - radius,radius, M_PI, M_PI_2, YES);
        CGContextAddLineToPoint(context, NSWidth(dirtyRect) - radius, NSHeight(dirtyRect));
        CGContextAddArc(context, NSWidth(dirtyRect) - radius, NSHeight(dirtyRect) - radius, radius, M_PI_2, 0, YES);
        CGContextAddLineToPoint(context, NSWidth(dirtyRect), radius);
        CGContextAddArc(context, NSWidth(dirtyRect) - radius, radius, radius, 0, M_PI_2, YES);
        CGContextClip(context);//context裁剪路径,后续操作的路径
    }else {
        CGContextAddRect(context, CGRectMake(dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, dirtyRect.size.height));
    }
    //绘制渐变
    CGContextDrawLinearGradient(context, gradient, CGPointMake(c, 0), CGPointMake(c, NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
    //释放对象
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

+ (float)getColorFromColorString:(NSString *)str WithIndex:(int)index {
    NSString *string = CustomColor(str, nil);
    NSArray *array = [string componentsSeparatedByString:@","];
    if (index <= 2) {
        return [[array objectAtIndex:index] floatValue]/255.0;
    }else {
        return [[array objectAtIndex:index] floatValue];
    }
}


+ (NSColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [NSColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [NSColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [NSColor colorWithCalibratedRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end

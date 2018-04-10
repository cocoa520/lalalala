//
//  IMBGradientTextField.m
//  AnyTrans
//
//  Created by hym on 25/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "IMBGradientTextField.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
@implementation IMBGradientTextField


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGImageRef alphaMask = NULL;
    CGContextSetTextDrawingMode(context, kCGTextFill);
    [[NSColor whiteColor] setFill];
    

    alphaMask = CGBitmapContextCreateImage(context);
//
//    // Clear the content.
    CGContextClearRect(context, dirtyRect);
//
    
    CGContextTranslateCTM(context, 0.0f, dirtyRect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
     //Clip the current context to alpha mask.
    CGContextClipToMask(context, dirtyRect, alphaMask);
    
    // Invert back to draw the gradient correctly.
    CGContextTranslateCTM(context, 0.0f, dirtyRect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    // Get gradient colors as CGColor.
    NSMutableArray *gradientColors = [NSMutableArray arrayWithObjects:((__bridge id)[NSColor colorWithDeviceRed:44/255.0 green:205/255.0 blue:249/255.0 alpha:1.0].CGColor),((__bridge id)[NSColor colorWithDeviceRed:40/255.0 green:158/255.0 blue:249/255.0 alpha:1.0].CGColor), nil];

     //Create gradient.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, NULL);
    CGPoint startPoint = CGPointMake(0,0);
    CGPoint endPoint = CGPointMake(dirtyRect.size.width,0);
    //如果是上下渐变，就改为CGPoint endPoint = CGPointMake(0,dirtyRect.size.height);
    
    // Draw gradient.
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    // Clean up, because ARC doesn't handle CG.
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    
//    //阴影
//    
//    CGContextSaveGState(context);
//    
//    // Create an image from the text.
//    CGImageRef image = CGBitmapContextCreateImage(context);
//    
//    // Clear the content.
//    CGContextClearRect(context, dirtyRect);
//    
//    // Invert everything, because CG works with an inverted coordinate system.
//    CGContextTranslateCTM(context, 0.0f, dirtyRect.size.height);
//    CGContextScaleCTM(context, 1.0f, -1.0f);
//    
//    // Set shadow attributes.
//    CGContextSetShadowWithColor(context, NSMakeSize(0, 1), 1, [NSColor colorWithDeviceRed:86/255.0 green:175/255.0 blue:244/255.0 alpha:1.0].CGColor);
//    
//    // Draw the saved image, which throws off a shadow.
//    CGContextDrawImage(context, NSMakeRect(dirtyRect.origin.x, dirtyRect.origin.y + 4, dirtyRect.size.width, dirtyRect.size.height), image);
//    
//    // Clean up, because ARC doesn't handle CG.
//    CGImageRelease(image);
//    
////    CGContextRestoreGState(context);
    
}

@end

//
//  NSImage+IMBCropExtensions.m
//  iMobieTrans
//
//  Created by zhang yang on 13-5-6.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "NSImage+IMBCropExtensions.h"

@implementation NSImage (IMBCropExtensions)

- (void)drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op fraction:(float)delta method:(IMBImageResizingMethod)resizeMethod
{
	float sourceWidth = [self size].width;
    float sourceHeight = [self size].height;
    float targetWidth = dstRect.size.width;
    float targetHeight = dstRect.size.height;
    BOOL cropping = !(resizeMethod == IMBImageResizeScale);
    
    // Calculate aspect ratios
    float sourceRatio = sourceWidth / sourceHeight;
    float targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
    // Proportionally scale source image
    float scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    float scaleFactor = scaledHeight / sourceHeight;
    
    // Calculate compositing rectangles
    NSRect sourceRect;
    if (cropping) {
        float destX = 0.0, destY = 0.0;
        if (resizeMethod == IMBImageResizeCrop) {
            // Crop center
            destX = round((scaledWidth - targetWidth) / 2.0);
            destY = round((scaledHeight - targetHeight) / 2.0);
        } else if (resizeMethod == IMBImageResizeCropStart) {
            // Crop top or left (prefer top)
            if (scaleWidth) {
				// Crop top
				destX = round((scaledWidth - targetWidth) / 2.0);
				destY = round(scaledHeight - targetHeight);
            } else {
				// Crop left
                destX = 0.0;
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        } else if (resizeMethod == IMBImageResizeCropEnd) {
            // Crop bottom or right
            if (scaleWidth) {
				// Crop bottom
				destX = 0.0;
				destY = 0.0;
            } else {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0);
            }
        }
        sourceRect = NSMakeRect(destX / scaleFactor, destY / scaleFactor,
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = NSMakeRect(0, 0, sourceWidth, sourceHeight);
		dstRect.origin.x += (targetWidth - scaledWidth) / 2.0;
		dstRect.origin.y += (targetHeight - scaledHeight) / 2.0;
		dstRect.size.width = scaledWidth;
		dstRect.size.height = scaledHeight;
    }
    
    [self drawInRect:dstRect fromRect:sourceRect operation:op fraction:delta];
}

- (NSImage *)imageToFitSize:(NSSize)size method:(IMBImageResizingMethod)resizeMethod
{
    NSImage *result = [[NSImage alloc] initWithSize:size];
    
    // Composite image appropriately
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[self drawInRect:NSMakeRect(0,0,size.width,size.height) operation:NSCompositeSourceOver fraction:1.0 method:resizeMethod];
    [result unlockFocus];
    
    return [result autorelease];
}

- (NSImage *)imageToFitRect:(NSRect)rect method:(IMBImageResizingMethod)resizeMethod
{
    NSImage *result = [[NSImage alloc] initWithSize:rect.size];
    
    // Composite image appropriately
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[self drawInRect:rect operation:NSCompositeSourceOver fraction:1.0 method:resizeMethod];
    [result unlockFocus];
    
    return [result autorelease];
}


- (NSImage *)imageCroppedToFitSize:(NSSize)size
{
    return [self imageToFitSize:size method:IMBImageResizeCrop];
}

- (NSImage *)imageScaledToFitSize:(NSSize)size
{
    return [self imageToFitSize:size method:IMBImageResizeScale];
}

- (NSImage *) imageFromRect: (NSRect) rect
{
    NSAffineTransform * xform = [NSAffineTransform transform];
	
    // translate reference frame to map rectangle 'rect' into first quadrant
    [xform translateXBy: -rect.origin.x
                    yBy: -rect.origin.y];
    
    NSSize canvas_size = [xform transformSize: rect.size];
	
    NSImage * canvas = [[NSImage alloc] initWithSize: canvas_size];
    [canvas lockFocus];
	
    [xform concat];
    
    // Get NSImageRep of image
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSImageRep * rep = [self bestRepresentationForDevice: nil];
#pragma clang diagnostic pop
    [rep drawAtPoint: NSZeroPoint];
    
    [canvas unlockFocus];
    return [canvas autorelease];
}

@end

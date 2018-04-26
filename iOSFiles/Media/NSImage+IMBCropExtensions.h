//
//  NSImage+IMBCropExtensions.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-6.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (IMBCropExtensions)

typedef enum {
    IMBImageResizeCrop,
    IMBImageResizeCropStart,
    IMBImageResizeCropEnd,
    IMBImageResizeScale
} IMBImageResizingMethod;

- (void)drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op fraction:(float)delta method:(IMBImageResizingMethod)resizeMethod;
- (NSImage *)imageToFitSize:(NSSize)size method:(IMBImageResizingMethod)resizeMethod;
- (NSImage *)imageToFitRect:(NSRect)rect method:(IMBImageResizingMethod)resizeMethod;
- (NSImage *)imageCroppedToFitSize:(NSSize)size;
- (NSImage *)imageScaledToFitSize:(NSSize)size;
- (NSImage *) imageFromRect: (NSRect) rect;

@end

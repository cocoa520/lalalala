/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the "CloudItemBorderView" class implementation.
*/

#import "CloudItemBorderView.h"
#import "CloudItemView.h"

@implementation CloudItemBorderView

#pragma mark Property Accessors

- (NSColor *)borderColor {
    return borderColor;
}

- (void)setBorderColor:(NSColor *)newBorderColor {
    if (borderColor != newBorderColor) {
        borderColor = [newBorderColor copy];
        [self setNeedsDisplay:YES];
    }
}

#pragma mark Visual State

// A CloudItemView wants to receive -updateLayer so it can set its backing layer's contents property, instead of being sent -drawRect: to draw its content procedurally.
- (BOOL)wantsUpdateLayer {
    return YES;
}

- (void)updateLayer {
    CALayer *layer = self.layer;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = (borderColor ? SLIDE_BORDER_WIDTH : 0.0);
    layer.cornerRadius = SLIDE_CORNER_RADIUS;
}

@end

@implementation CloudItemSelectedView

#pragma mark Property Accessors

- (NSColor *)selectedColor {
    return selectedColor;
}

- (void)setSelectedColor:(NSColor *)newSelectedColor {
    if (selectedColor != newSelectedColor) {
        selectedColor = [newSelectedColor copy];
        [self setNeedsDisplay:YES];
    }
}

#pragma mark Visual State

// A CloudItemView wants to receive -updateLayer so it can set its backing layer's contents property, instead of being sent -drawRect: to draw its content procedurally.
- (BOOL)wantsUpdateLayer {
    return YES;
}

- (void)updateLayer {
    CALayer *layer = self.layer;
    layer.backgroundColor = selectedColor.CGColor;
    layer.cornerRadius = SLIDE_CORNER_RADIUS;
}

@end

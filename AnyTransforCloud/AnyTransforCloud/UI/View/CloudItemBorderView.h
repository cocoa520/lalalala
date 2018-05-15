/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the "CloudItemBorderView" class declaration.
*/

#import <Cocoa/Cocoa.h>

// Added as a subview of a AAPLSlideCarrierView, when we want to frame the slide's shape with a stroked outline to indicate selection or highlighting.
@interface CloudItemBorderView : NSView
{
    NSColor *borderColor;
}

@property(copy) NSColor *borderColor;

@end


@interface CloudItemSelectedView : NSView
{
    NSColor *selectedColor;
}

@property(copy) NSColor *selectedColor;

@end

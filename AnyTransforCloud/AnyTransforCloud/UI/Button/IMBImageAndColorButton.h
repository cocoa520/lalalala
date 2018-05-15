//
//  IMBImageAndColorButton.h
//  AnyTrans for Android
//
//  Created by smz on 18/1/31.
//  Copyright (c) 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBImageAndColorButton : NSButton {
    NSTrackingArea *_trackingArea;
    int _buttonType;
    NSImage *_mouseDownImage;
    NSImage *_mouseUpImage;
    NSImage *_mouseExitedImage;
    NSImage *_mouseEnteredImage;
    NSColor *_lineNormalColor;
    NSColor *_lineEnterColor;
    NSColor *_lineDownColor;
}
@property (nonatomic, assign) int buttonType;
- (void)mouseDownImage:(NSImage*) mouseDownImg withMouseUpImg:(NSImage *) mouseUpImg withMouseExitedImg:(NSImage *) mouseExiteImg mouseEnterImg:(NSImage *) mouseEnterImg;

- (void)setLineNormalColor:(NSColor *)lineNormalColor withLineEnterColor:(NSColor *)lineEnterColor withLineDownColor:(NSColor *)lineDownColor;

@end

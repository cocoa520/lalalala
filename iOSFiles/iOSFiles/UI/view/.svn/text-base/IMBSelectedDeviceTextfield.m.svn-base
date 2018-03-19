//
//  IMBSelectedDeviceTextfield.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/16.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBSelectedDeviceTextfield.h"
#import "StringHelper.h"


@implementation IMBSelectedDeviceTextfield
#pragma mark - synthesize
@synthesize iconX = _iconX;
@synthesize textX = _textX;
@synthesize textString = _textString;

#pragma mark - draw
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSImage *iconImage = [NSImage imageNamed:@"device_icon_iPhone_gray.png"];
    [iconImage setResizingMode:NSImageResizingModeStretch];
    int xPos = _iconX;
    NSRect imageRect;
    imageRect.origin = NSZeroPoint ;
    imageRect.size = iconImage.size;
    NSRect drawingRect = NSZeroRect;
    drawingRect.origin = NSMakePoint(NSMinX(dirtyRect) + xPos - 2.f , (dirtyRect.size.height - imageRect.size.height)/2.f + 4.f );
    drawingRect.size = imageRect.size;
    [iconImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
    if (_textString && self.textColor && self.font) {
        NSDictionary *textAttr = @{NSForegroundColorAttributeName : self.textColor, NSFontAttributeName : self.font};
        //    CGFloat textW = [_textString boundingRectWithSize:NSMakeSize(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttr].size.width;
        [_textString drawInRect:NSMakeRect(_textX, (dirtyRect.size.height - imageRect.size.height)/2.f, dirtyRect.size.width - _textX, drawingRect.size.height) withAttributes:textAttr];
    }
    
}

@end

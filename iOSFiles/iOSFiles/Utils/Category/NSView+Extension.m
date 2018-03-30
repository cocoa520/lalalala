//
//  NSView+Extension.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "NSView+Extension.h"

@implementation NSView (Extension)

- (void)setImb_x:(CGFloat)imb_x {
    NSRect f = self.frame;
    f.origin.x = imb_x;
    self.frame = f;
}
- (CGFloat)imb_x {
    return self.frame.origin.x;
}


- (void)setImb_y:(CGFloat)imb_y {
    NSRect f = self.frame;
    f.origin.x = imb_y;
    self.frame = f;
}
- (CGFloat)imb_y {
    return self.frame.origin.y;
}


- (void)setImb_width:(CGFloat)imb_width {
    NSRect f = self.frame;
    f.size.width = imb_width;
    self.frame = f;
}
- (CGFloat)imb_width {
    return self.frame.size.width;
}


- (void)setImb_height:(CGFloat)imb_height {
    NSRect f = self.frame;
    f.size.height = imb_height;
    self.frame = f;
}
- (CGFloat)imb_height {
    return self.frame.size.height;
}


- (void)setImb_size:(NSSize)imb_size {
    NSRect f = self.frame;
    f.size = imb_size;
    self.frame = f;
}
- (NSSize)imb_size {
    return self.frame.size;
}

- (void)setImb_origin:(NSPoint)imb_origin {
    NSRect f = self.frame;
    f.origin = imb_origin;
    self.frame = f;
}
- (NSPoint)imb_origin {
    return self.frame.origin;
}


- (void)setImb_center:(NSPoint)imb_center {
    NSRect f = self.frame;
    f.origin.x = imb_center.x - NSWidth(self.frame)/2.f;
    f.origin.y = imb_center.y - NSHeight(self.frame)/2.f;
    self.frame = f;
}
- (NSPoint)imb_center {
    CGFloat centerX = NSMinX(self.frame) + NSWidth(self.frame)/2.f;
    CGFloat centerY = NSMinY(self.frame) + NSHeight(self.frame)/2.f;
    return NSMakePoint(centerX, centerY);
}


- (void)setImb_centerX:(CGFloat)imb_centerX {
    NSRect f = self.frame;
    f.origin.x = imb_centerX - NSWidth(self.frame)/2.f;
    self.frame = f;
}
- (CGFloat)imb_centerX {
    return NSMinX(self.frame) + NSWidth(self.frame)/2.f;
}


- (void)setImb_centerY:(CGFloat)imb_centerY {
    NSRect f = self.frame;
    f.origin.y = imb_centerY - NSHeight(self.frame)/2.f;
    self.frame = f;
}
- (CGFloat)imb_centerY {
    return NSMinY(self.frame) + NSHeight(self.frame)/2.f;
}


@end

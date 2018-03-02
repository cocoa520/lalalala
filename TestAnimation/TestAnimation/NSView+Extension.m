//
//  NSView+Extension.m
//  TestAnimation
//
//  Created by iMobie on 18/3/2.
//  Copyright © 2018年 TsinHzl. All rights reserved.
//

#import "NSView+Extension.h"

@implementation NSView (Extension)

- (void)setZl_x:(CGFloat)zl_x {
    NSRect f = self.frame;
    f.origin.x = zl_x;
    self.frame = f;
}

- (CGFloat)zl_x {
    return self.frame.origin.x;
}


- (void)setZl_y:(CGFloat)zl_y {
    NSRect f = self.frame;
    f.origin.x = zl_y;
    self.frame = f;
}
- (CGFloat)zl_y {
    return self.frame.origin.y;
}


- (void)setZl_width:(CGFloat)zl_width {
    NSRect f = self.frame;
    f.size.width = zl_width;
    self.frame = f;
}
- (CGFloat)zl_width {
    return self.frame.size.width;
}


- (void)setZl_height:(CGFloat)zl_height {
    NSRect f = self.frame;
    f.size.height = zl_height;
    self.frame = f;
}
- (CGFloat)zl_height {
    return self.frame.size.height;
}


- (void)setZl_center:(CGPoint)zl_center {
    NSRect f = self.frame;
    f.origin.x = zl_center.x - f.size.width/2.f;
    f.origin.y = zl_center.y - f.size.height/2.f;
    self.frame = f;
}
- (CGPoint)zl_center {
    CGFloat x = self.frame.size.width/2.f + self.frame.origin.x;
    CGFloat y = self.frame.size.height/2.f + self.frame.origin.y;
    return CGPointMake(x, y);
}


- (void)setZl_origin:(CGPoint)zl_origin {
    NSRect f = self.frame;
    f.origin = zl_origin;
    self.frame = f;
}
- (CGPoint)zl_origin {
    return self.frame.origin;
}


- (void)setZl_size:(CGSize)zl_size {
    NSRect f = self.frame;
    f.size = zl_size;
    self.frame = f;
}
- (CGSize)zl_size {
    return self.frame.size;
}



@end

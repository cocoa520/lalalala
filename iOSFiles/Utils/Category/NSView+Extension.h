//
//  NSView+Extension.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (Extension)

@property(nonatomic, assign)CGFloat imb_x;
@property(nonatomic, assign)CGFloat imb_y;
@property(nonatomic, assign)NSPoint imb_origin;
@property(nonatomic, assign)NSSize imb_size;
@property(nonatomic, assign)CGFloat imb_width;
@property(nonatomic, assign)CGFloat imb_height;
@property(nonatomic, assign)NSPoint imb_center;
@property(nonatomic, assign)CGFloat imb_centerX;
@property(nonatomic, assign)CGFloat imb_centerY;

@end

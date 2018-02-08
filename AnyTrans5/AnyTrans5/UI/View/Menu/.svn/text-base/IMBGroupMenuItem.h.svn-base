//
//  IMBGroupMenuItem.h
//  AnyTrans
//
//  Created by smz on 17/7/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface IMBGroupMenuItem : NSView {
    
    NSColor *_mouseEnterColor;
    NSTrackingArea *_trackingArea;
    BOOL _isMouseEnter;
    id _target;
    SEL _action;
    NSString *_title;
    NSMenuItem *_menuItem;
    NSColor *_groupColor;
    NSInteger _tag;
    CAShapeLayer *_shapeLayer;
    BOOL _isThis;
    NSImageView *_imageView;
}
@property (nonatomic,retain) NSColor *groupColor;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,assign) id menuItem;
@property (nonatomic,assign) BOOL isMouseEnter;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) BOOL isThis;

@end

//
//  IMBMenuItemView.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface IMBMenuItemView : NSView
{
    NSColor *_mouseEnterColor;
    NSTrackingArea *_trackingArea;
    BOOL _isMouseEnter;
    id _target;
    SEL _action;
    NSString *_title;
    NSString *_countText;
    NSMenuItem *_menuItem;
    BOOL _enable;
    NSImage *_iconImage;
    NSImage *_triangleImage;
}
@property (nonatomic,assign)id target;
@property (nonatomic,assign)SEL action;
@property (nonatomic,assign)id menuItem;
@property (nonatomic,assign)BOOL isMouseEnter;
@property (nonatomic,assign)BOOL enable;
- (void)setTitle:(NSString *)title;
- (void)setIcon:(NSImage *)image;
- (void)setCount:(NSString *)count;
- (void)setTriangle:(NSImage *)image;
@end

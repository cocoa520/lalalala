//
//  IMBDevicePopoverViewController.m
//  iOSFiles
//
//  Created by hym on 31/03/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDevicePopoverViewController.h"
#import "IMBCommonDefine.h"
#import "StringHelper.h"
#define DEVICEITEMHEIGHT 30

@implementation IMBDevicePopoverViewController
@synthesize action = _action;
@synthesize target = _target;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDeviceAry:(NSMutableArray *)deviceAry {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _deviceAry = [deviceAry retain];
    }
    return self;
}

- (void)awakeFromNib {
    NSRect f = self.view.frame;
    f.size.height = _deviceAry.count * DEVICEITEMHEIGHT + 10;
    f.size.width = 160;
    self.view.frame = f;
    [self loadDeviceInfo];
}

- (void)loadDeviceInfo {
    NSRect f = self.view.frame;
    if (_deviceAry != nil && _deviceAry.count > 0) {
        int allCount = (int)_deviceAry.count;
        for (int i = 0; i < allCount; i++) {
            IMBBaseInfo *baseInfo = [_deviceAry objectAtIndex:i];
            NSRect itemRect;
            itemRect.origin.x = f.origin.x;
            itemRect.origin.y = (allCount - i - 1) * DEVICEITEMHEIGHT+ 5;
            itemRect.size.width = f.size.width;
            itemRect.size.height = DEVICEITEMHEIGHT;
            IMBDeviceItemView *deviceView = [[IMBDeviceItemView alloc] initWithFrame:itemRect withBaseinfo:baseInfo];
            [deviceView setTarget:self.target];
            [deviceView setAction:self.action];
            [self.view addSubview:deviceView];
            [deviceView release];
            deviceView = nil;
        }
    }
}

- (void)dealloc {
    if (_deviceAry) {
        [_deviceAry release];
        _deviceAry = nil;
    }
    [super dealloc];
}

@end



@implementation IMBDeviceItemView

- (instancetype)initWithFrame:(NSRect)frameRect withBaseinfo:(IMBBaseInfo *)baseInfo {
    if (self = [super initWithFrame:frameRect]) {
        _baseInfo = [baseInfo retain];
    }
    return self;
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}


- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [[NSColor clearColor] set];
    [path fill];
    
    
    int xPos;
    int yPos;
    
    xPos = 14;
    yPos = 0;
    
    
    //背景
    NSBezierPath *path1 = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_mouseSatue == MouseEnter || _mouseSatue == MouseUp) {
        [COLOR_TABLEVIEW_ENTER set];
        [path1 fill];
        
        //画设备的名字
        if (_baseInfo.deviceName != nil) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:self.frame.size.width - 30 withSize:&size withColor:COLOR_TEXT_PRIORITY withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(30 , 2, size.width, 22);
            [attrStr drawInRect:textRect2];
        }
        
        NSImage *image = [NSImage imageNamed:@"device_icon_iPhone_selected"];
        [image drawInRect:NSMakeRect(5, 2, image.size.width, image.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        
        
    }else if (_mouseSatue == MouseDown) {
        [COLOR_TABLEVIEW_CLICK set];
        [path1 fill];
        
        //画设备的名字
        if (_baseInfo.deviceName != nil) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:self.frame.size.width - 30 withSize:&size withColor:COLOR_TEXT_PRIORITY withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(30 , 2, size.width, 22);
            [attrStr drawInRect:textRect2];
        }
        
        NSImage *image = [NSImage imageNamed:@"device_icon_iPhone_selected"];
        [image drawInRect:NSMakeRect(5, 2, image.size.width, image.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }else {
        [[NSColor clearColor] set];
        [path1 fill];
        
        
        //画设备的名字
        if (_baseInfo.deviceName != nil) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:self.frame.size.width - 30 withSize:&size withColor:COLOR_TEXT_ORDINARY withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(30 , 2, size.width, 22);
            [attrStr drawInRect:textRect2];
        }
        
        NSImage *image = [NSImage imageNamed:@"device_icon_iPhone_gray"];
        [image drawInRect:NSMakeRect(5, 2, image.size.width, image.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
    
    


    
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseSatue = MouseUp;
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner) {
        if (self.target != nil && self.action != nil) {
            if ([self.target respondsToSelector:self.action]) {
                [self.target performSelector:self.action withObject:self.baseInfo];
            }
        }
    }
}

-(void)mouseDown:(NSEvent *)theEvent {
    _mouseSatue = MouseDown;
    [self setNeedsDisplay:YES];
}

-(void)mouseExited:(NSEvent *)theEvent{
    _mouseSatue = MouseOut;
    [self setNeedsDisplay:YES];
}

-(void)mouseEntered:(NSEvent *)theEvent{
    _mouseSatue = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    if (_baseInfo != nil) {
        [_baseInfo release];
        _baseInfo = nil;
    }
    [super dealloc];
}

@end

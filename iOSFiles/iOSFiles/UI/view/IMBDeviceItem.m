//
//  IMBDeviceItem.m
//  iMobieTrans
//
//  Created by Pallas on 3/18/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBDeviceItem.h"
#import "CapacityView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "IMBCommonDefine.h"
@implementation IMBDeviceItem
@synthesize index = _index;
@synthesize baseInfo = _baseInfo;
@synthesize exitbutton = _exitbutton;
@synthesize isSelected = _isSelected;
@synthesize isAddContent = _isAddContent;
@synthesize isTitle = _isTitle;
@synthesize isAndroidView = _isAndroidView;
@synthesize isiCloudView = _isiCloudView;
@synthesize isShowLine = _isShowLine;
@synthesize delegate = _delegate;
@synthesize target = _target;
@synthesize action = _action;


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _btnStatus = @"ExitStatus";
        nc = [NSNotificationCenter defaultCenter];
        _isSelected = NO;
        _isTitle = NO;
        _isAndroidView = NO;
        _isiCloudView = NO;
        _isShowLine = NO;
        _openWindowBtn = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(217 , 40, 24, 24)];
        _openWindowBtn.mouseEnteredImage = [StringHelper imageNamed:@"icon_newwindow_hover"];
        _openWindowBtn.mouseDownImage = [StringHelper imageNamed:@"icon_newwindow_hover"];
        _openWindowBtn.mouseExitedImage = [StringHelper imageNamed:@"icon_newwindow_default"];
        [_openWindowBtn setTarget:self];
        [_openWindowBtn setAction:@selector(openWindow)];
        
        _signOutBtn = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(200 , 40, 24, 24)];
        _signOutBtn.mouseEnteredImage = [StringHelper imageNamed:@" topbox_icon_signout_hover"];
        _signOutBtn.mouseDownImage = [StringHelper imageNamed:@" topbox_icon_signout_default"];
        _signOutBtn.mouseExitedImage = [StringHelper imageNamed:@" topbox_icon_signout_default"];
        [_signOutBtn setTarget:self];
        [_signOutBtn setAction:@selector(signOutDrive)];

        
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

-(void)doChangeLanguage{
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_isShowLine) {
        //背景
        NSBezierPath *strokePath = [NSBezierPath bezierPathWithRect:NSMakeRect(NSMinX(dirtyRect), NSMaxY(dirtyRect), dirtyRect.size.width, 0.5)];
        [COLOR_TEXT_LINE set];
        [strokePath stroke];
    }
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
    [[NSColor clearColor] set];
    [path fill];
    //背景
    NSBezierPath *path1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
    if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp) {
        [COLOR_TABLEVIEW_ENTER set];
    }else if (_mouseStatus == MouseDown) {
        [COLOR_TABLEVIEW_CLICK set];
    }else {
        [[NSColor clearColor] set];
    }
    [path1 fill];
    
    if (_baseInfo.leftImage && _baseInfo.leftHoverImage) {
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp || _mouseStatus == MouseDown) {
            NSRect imageFrame = NSMakeRect(10, 8, _baseInfo.leftHoverImage.size.width, _baseInfo.leftHoverImage.size.height);
            [_baseInfo.leftHoverImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }else {
            NSRect imageFrame = NSMakeRect(10, 8, _baseInfo.leftImage.size.width, _baseInfo.leftImage.size.height);
            [_baseInfo.leftImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }
    //画设备的名字
    if (_baseInfo.deviceName != nil) {
        NSSize size ;
        NSColor *color = nil;
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp || _mouseStatus == MouseDown) {
            color = COLOR_TEXT_PRIORITY;
        }else {
            color = COLOR_TEXT_ORDINARY;
        }
        NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:92 withSize:&size withColor:color withAlignment:NSLeftTextAlignment];
        NSRect textRect2 = NSMakeRect(20+18  , 8, size.width, 22);
        [attrStr drawInRect:textRect2];
    }
    if (_baseInfo.chooseModelEnum == DeviceLogEnum) {
        NSColor *color = nil;
        NSSize size ;
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp || _mouseStatus == MouseDown) {
            color = COLOR_TEXT_PRIORITY;
        }else {
            color = COLOR_TEXT_ORDINARY;
        }
        NSRect sizeRect = NSMakeRect(130, 8, 100, 22);
        NSString *str = nil;
        if (_baseInfo.kyDeviceSize) {
            str = [[[StringHelper getFileSizeString:_baseInfo.kyDeviceSize reserved:0] stringByAppendingString:@"/" ] stringByAppendingString:[StringHelper getFileSizeString:_baseInfo.allDeviceSize reserved:0]];
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:str withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:92 withSize:&size withColor:color withAlignment:NSLeftTextAlignment];
//            NSRect textRect2 = NSMakeRect(20+18  , 8, size.width, 22);
            [attrStr drawInRect:sizeRect];
        }
    }else {
        NSColor *color = nil;
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp || _mouseStatus == MouseDown) {
            color = COLOR_TEXT_PRIORITY;
        }else {
            color = COLOR_TEXT_ORDINARY;
        }
         NSSize size ;
        NSRect sizeRect = NSMakeRect(130, 8, 100, 22);
        NSString *str = nil;
        if (_baseInfo.kyDeviceSize) {
            str = [[[StringHelper getFileSizeString:_baseInfo.kyDeviceSize reserved:0] stringByAppendingString:@"/"] stringByAppendingString:[StringHelper getFileSizeString:_baseInfo.allDeviceSize reserved:0]];
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:str withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withLineSpacing:0 withMaxWidth:92 withSize:&size withColor:color withAlignment:NSLeftTextAlignment];
            [attrStr drawInRect:sizeRect];
        }
    }
    if (![_baseInfo.deviceName isEqualToString:CustomLocalizedString(@"icloud_addAcount", nil)]) {
        //退出按钮
        [_openWindowBtn setFrame:NSMakeRect(268 , 8, 24, 24)];
        [self addSubview:_openWindowBtn];
        
        [_signOutBtn setFrame:NSMakeRect(244 , 8, 24, 24)];
        [self addSubview:_signOutBtn];
    }
}

- (void)setExitbutton:(NSButton *)exitbutton {
    if (_exitbutton != exitbutton) {
        if (_exitbutton != nil) {
            [_exitbutton removeFromSuperview];
        }
        _exitbutton = exitbutton;
        [self refresh];
    }
}

- (NSButton*)exitbutton {
    return _exitbutton;
}

- (void)refresh {
    if (self.exitbutton) {
        if (!_baseInfo.isLoaded) {
            [self.exitbutton removeFromSuperview];
            NSPoint exitPoint;
            exitPoint.x = floor(self.frame.size.width - self.exitbutton.bounds.size.width - 10);
            exitPoint.y = floor(self.frame.size.height - self.exitbutton.frame.size.height) / 2.f;
            [self.exitbutton setFrameOrigin:exitPoint];
            [self addSubview:self.exitbutton];
        } else {
            [self.exitbutton removeFromSuperview];
        }
    }
    [self setNeedsDisplay:YES];
}

- (void)drawLeftText:(NSString *)text withFrame:(NSRect)frame withFontSize:(float)withFontSize withColor:(NSColor *)color {
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:withFontSize];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName ,sysFont ,NSFontAttributeName,style,NSParagraphStyleAttributeName, nil];
    
    NSSize textSize = [as.string sizeWithAttributes:attributes];
    NSSize maxSize = NSMakeSize(140, 20);
    if (textSize.width > maxSize.width ) {
        textSize = maxSize;
        NSAttributedString *as2 = [[NSAttributedString alloc]initWithString:@"..."];
        NSRect rect = NSMakeRect(frame.origin.x + textSize.width, frame.origin.y + (frame.size.height - textSize.height) / 2, 20, textSize.height);
        [as2.string drawInRect:rect withAttributes:attributes];
        [as2 release];
        as2 = nil;
    }
    NSRect f = NSMakeRect(frame.origin.x , frame.origin.y + (frame.size.height - textSize.height) / 2, textSize.width, textSize.height);
    [as.string drawInRect:f withAttributes:attributes];
    
    [as release];
    as = nil;
    [style release];
    style = nil;
}

-(NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints {
    double mbSize = (double)totalSize / 1048576;
    double kbSize = (double)totalSize / 1024;
    if (totalSize < 1024) {
        return [NSString stringWithFormat:@" %.0f%@", (double)totalSize,CustomLocalizedString(@"MSG_Size_B", nil)];
    } else {
        if (mbSize > 1024) {
            double gbSize = (double)totalSize / 1073741824;
            return [StringHelper Rounding:gbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"MSG_Size_GB", nil)];
        } else if (kbSize > 1024) {
            return [StringHelper Rounding:mbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"MSG_Size_MB", nil)];
        } else {
            return [StringHelper Rounding:kbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"MSG_Size_KB", nil)];
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    _btnStatus = @"ExitStatus";
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
    _mouseStatus = MouseDown;
    [self setNeedsDisplay:YES];
}

-(void)mouseExited:(NSEvent *)theEvent{
    _mouseStatus = MouseOut;
    [self setNeedsDisplay:YES];
    
}

-(void)mouseEntered:(NSEvent *)theEvent{
    _mouseStatus = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseMoveOutView:(NSNotification *)sender {
    NSDictionary *userInfo= [sender userInfo];
    NSEvent *event = [userInfo objectForKey:@"MouseEvent"];
    [self mouseMoved:event];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSPoint mouseLocation = [self.window mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation fromView: nil];
    
    if (NSPointInRect(mouseLocation, [self bounds])) {
        _btnStatus = @"EnteredStatus";
        [self setNeedsDisplay:YES];
    } else {
        _btnStatus = @"ExitStatus";
        [self setNeedsDisplay:YES];
    }
}

- (void)showDeviceInfo {
    [_delegate showInfo:_baseInfo];
    NSLog(@"==========%@",_baseInfo.deviceName);
}

- (void)reStartDevice {
    [_delegate restartDeviceBase:_baseInfo];
}

- (void)shutdownDevice {
    [_delegate shutdownDeviceBase:_baseInfo];
}

-(void)signOutDrive {
    [_delegate backdrive:_baseInfo];
}

- (void)openWindow {
    [_delegate openWindow:_baseInfo];
}

- (int)getDeviceCapcityType:(long long)totalSize {
    double type = (double)(totalSize/(1024*1024*1024));
    if (type>0.0&&type<=8.0) {
        return 8;
    }else if (type>8.0&&type<=16.0)
    {
        return 16;
    }else if (type>16.0&&type<=32.0)
    {
        return 32;
    }else if (type>32.0&&type<=64.0)
    {
        return 64;
    }else if (type>64&&type<=128.0)
    {
        return 128;
    }else if (type>128.0&&type<=256.0)
    {
        return 256;
    }
    
    return 8;
}

- (void)dealloc {
    if (_openWindowBtn != nil) {
        [_openWindowBtn release];
        _openWindowBtn = nil;
    }
    if (_signOutBtn != nil) {
        [_signOutBtn release];
        _signOutBtn = nil;
    }
    [_trackingArea release],_trackingArea = nil;
    [super dealloc];
}


@end

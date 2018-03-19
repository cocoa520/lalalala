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
        _signOutBtn = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(217 , 40, 14, 14)];
        _signOutBtn.mouseEnteredImage = [StringHelper imageNamed:@"exit2"];
        _signOutBtn.mouseDownImage = [StringHelper imageNamed:@"exit3"];
        _signOutBtn.mouseExitedImage = [StringHelper imageNamed:@"exit"];
        [_signOutBtn setTarget:self];
        [_signOutBtn setAction:@selector(signOutDrive)];
        _deviceInfoBtn = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(200 , 39, 14, 14)];
        _deviceInfoBtn.mouseEnteredImage = [StringHelper imageNamed:@"device_info2"];
        _deviceInfoBtn.mouseDownImage = [StringHelper imageNamed:@"device_info3"];
        _deviceInfoBtn.mouseExitedImage = [StringHelper imageNamed:@"device_info"];
        [_deviceInfoBtn setTarget:self];
        [_deviceInfoBtn setAction:@selector(showDeviceInfo)];
        _deviceRestartBtn = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(167 , 38, 14, 14)];
        _deviceRestartBtn.mouseEnteredImage = [StringHelper imageNamed:@"box_restart2"];
        _deviceRestartBtn.mouseDownImage = [StringHelper imageNamed:@"box_restart3"];
        _deviceRestartBtn.mouseExitedImage = [StringHelper imageNamed:@"box_restart1"];
        [_deviceRestartBtn setTarget:self];
        [_deviceRestartBtn setAction:@selector(reStartDevice)];
        _deviceShutdownBtn = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(184 , 38, 14, 14)];
        _deviceShutdownBtn.mouseEnteredImage = [StringHelper imageNamed:@"box_close2"];
        _deviceShutdownBtn.mouseDownImage = [StringHelper imageNamed:@"box_close3"];
        _deviceShutdownBtn.mouseExitedImage = [StringHelper imageNamed:@"box_close1"];
        [_deviceShutdownBtn setTarget:self];
        [_deviceShutdownBtn setAction:@selector(shutdownDevice)];
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
    if (_isTitle) {
        if (_isShowLine) {
            //背景
            NSBezierPath *strokePath = [NSBezierPath bezierPathWithRect:NSMakeRect(NSMinX(dirtyRect), NSMaxY(dirtyRect), dirtyRect.size.width, 0.5)];
            [COLOR_TEXT_LINE set];
            [strokePath stroke];
        }
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        [[NSColor clearColor] set];
        [path fill];
        
    }else {
        //背景
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp) {
            [DEVICEITEMVIEW_ENTER_BGCOLOR set];
        }else if (_mouseStatus == MouseDown) {
            [DEVICEITEMVIEW_DOWN_BGCOLOR set];
        }else {
            [[NSColor clearColor] set];
        }
        [path fill];
    }
    
    if (_isTitle) {
        if (_isiCloudView) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:CustomLocalizedString(@"nav_iCloudAccount", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:135 withSize:&size withColor:COLOR_TEXT_EXPLAIN withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(6 , 8, size.width, 20);
            [attrStr drawInRect:textRect2];
        }else {
            if (!_isAndroidView) {
                NSSize size ;
                NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:CustomLocalizedString(@"nav_IOSDevcie", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:135 withSize:&size withColor:COLOR_TEXT_EXPLAIN withAlignment:NSLeftTextAlignment];
                NSRect textRect2 = NSMakeRect(6 , 8, size.width, 20);
                [attrStr drawInRect:textRect2];
            }else {
                NSSize size ;
                NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:CustomLocalizedString(@"nav_AndroidDevcie", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:135 withSize:&size withColor:COLOR_TEXT_EXPLAIN withAlignment:NSLeftTextAlignment];
                NSRect textRect2 = NSMakeRect(6 , 8, size.width, 20);
                [attrStr drawInRect:textRect2];
            }
        }
    } else {
        
        //设备图片
        NSImage *iconImg = nil;
        iconImg = [StringHelper getDeviceImage:_baseInfo.connectType];
        int xPos;
        int yPos;
        if (iconImg != nil) {
            xPos = 8;
            yPos = 10;
            NSRect drawingRect;
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = iconImg.size;
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size.width = imageRect.size.width;
            drawingRect.size.height = imageRect.size.height;
            [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            
            int xPosSelect;
            int yPosSelect;
            NSImage *iconSelectImg = nil;
            //选中图片
            if (_isSelected) {
                iconSelectImg = [StringHelper imageNamed:@"device_selete"];
            }
            xPosSelect = 9;
            yPosSelect = 12;
            NSRect drawingRectWithSelected;
            // 用来苗素图片信息
            NSRect imageRectWithSelected;
            imageRectWithSelected.origin = NSZeroPoint;
            imageRectWithSelected.size = iconSelectImg.size;
            drawingRectWithSelected.origin.x = NSMaxX(drawingRect) - xPosSelect;
            drawingRectWithSelected.origin.y = NSMaxY(drawingRect) - yPosSelect;
            drawingRectWithSelected.size.width = imageRectWithSelected.size.width;
            drawingRectWithSelected.size.height = imageRectWithSelected.size.height;
            [iconSelectImg drawInRect:drawingRectWithSelected fromRect:imageRectWithSelected operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
        
        xPos = 14;
        yPos = 0;
        
        //画设备的名字
        if (_baseInfo.deviceName != nil) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:112 withSize:&size withColor:COLOR_TEXT_ORDINARY withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(52 , 38, size.width, 22);
            [attrStr drawInRect:textRect2];
        }
        
        //剩余空间
        NSRect sizeRect = NSMakeRect(52, 5, 124, 16);
        NSString *str = nil;
        if (!_baseInfo.isLoaded) {
            str = [[[StringHelper getFileSizeString:_baseInfo.kyDeviceSize reserved:0] stringByAppendingString:@" " ] stringByAppendingString:CustomLocalizedString(@"MainWindow_id_1", nil)];
        }else{
            str = CustomLocalizedString(@"Device_Main_id_7", nil);
        }
        [self drawLeftText:str withFrame:sizeRect withFontSize:12 withColor:COLOR_TEXT_EXPLAIN];
        
        //容量条
        //背景灰色
        NSRect bgRect = NSMakeRect(52, 28, 178, 4);
        NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:bgRect xRadius:3 yRadius:3];
        [PROGRESS_ANIMATION_COLOR set];
        [bgPath fill];
        //容量条圆角头部
        NSRect capacityRect = NSMakeRect(52, 28, 4, 4);
        NSBezierPath *capacityPath = [NSBezierPath bezierPathWithRoundedRect:capacityRect xRadius:3 yRadius:3];
        [PROGRESS_ANIMATION_COLOR set];
        [capacityPath fill];
        
        //退出按钮
        [_signOutBtn setFrame:NSMakeRect(220 , 42, 14, 14)];
        [self addSubview:_signOutBtn];
        
        if (!_isAndroidView) {
            [_deviceInfoBtn setFrame:NSMakeRect(202 , 42, 14, 14)];
            [_deviceRestartBtn setFrame:NSMakeRect(166 , 42, 14, 14)];
            [_deviceShutdownBtn setFrame:NSMakeRect(184 , 42, 14, 14)];
            [self addSubview:_deviceInfoBtn];
            [self addSubview:_deviceRestartBtn];
            [self addSubview:_deviceShutdownBtn];
            
        }
    }
}
  
- (void)loadCapacity:(float)percent {
    CapacityView *view = [[CapacityView alloc] initWithFrame:NSMakeRect(0, 0, percent*178-4, 4) WithFillColor:PROGRESS_ANIMATION_COLOR withPercent:(float)percent];
    [view setFrameOrigin:NSMakePoint(54, 28)];
    [self addSubview:view];
    [view setWantsLayer:YES];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale.x"];//transform.scale.x = 闊的比例轉換
    animation.fromValue=@0;
    animation.toValue=@1;
    animation.duration=1.0;
    animation.autoreverses=NO;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:nil];
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
    }
    NSRect f = NSMakeRect(frame.origin.x , frame.origin.y + (frame.size.height - textSize.height) / 2, textSize.width, textSize.height);
    [as.string drawInRect:f withAttributes:attributes];

    [as release];
    [style release];
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
    [_trackingArea release],_trackingArea = nil;
    [super dealloc];
}


@end

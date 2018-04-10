//
//  ToDeviceViewItem.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/24.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "ToDeviceViewItem.h"
//#import "IMBColorDefine.h"
#import "StringHelper.h"

@implementation ToDeviceViewItem
@synthesize index = _index;
@synthesize baseInfo = _baseInfo;
@synthesize isSelected = _isSelected;
@synthesize delegate = _delegate;
@synthesize target = _target;
@synthesize action = _action;
@synthesize needIcon = _needIcon;
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _needIcon = YES;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];

    if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp) {
        [[StringHelper getColorFromString:CustomColor(@"deviceItemView_enter_bgColor", nil)] set];
    }else if (_mouseStatus == MouseDown) {
        [[StringHelper getColorFromString:CustomColor(@"deviceItemView_down_bgColor", nil)] set];
    }else {
        [[NSColor clearColor] set];
    }
    [path fill];
    
    //画设备的名字
    if (_baseInfo.deviceName != nil) {
        NSSize size ;
        NSMutableAttributedString *attrStr = nil;
        if (_baseInfo.isicloudView) {
            attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:85 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSCenterTextAlignment];
        }else{
            attrStr = [StringHelper TruncatingTailForStringDrawing:_baseInfo.deviceName withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:85 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
        }

        NSRect textRect2;
        if (_needIcon) {
            if (_baseInfo.isicloudView) {
                textRect2 = NSMakeRect(20, 9, size.width, 22);
            }else{
                textRect2 = NSMakeRect(36 , 9, size.width, 22);
            }
            
        }else{
            textRect2 = NSMakeRect(5 , 1, size.width, 22);
        }
        [attrStr drawInRect:textRect2];
    }
    
    //画设备图片
    if (_needIcon&&!_baseInfo.isicloudView) {
        NSImage *iconImg = nil;
        if ( _baseInfo.connectType == iPod_Unknown||_baseInfo.connectType == iPod_Gen1_Gen2||_baseInfo.connectType == iPod_Gen3||_baseInfo.connectType == iPod_Mini||_baseInfo.connectType == iPod_Gen4||_baseInfo.connectType == iPod_Gen4_2||_baseInfo.connectType == iPod_Gen5||_baseInfo.connectType ==iPod_Nano_Gen1||_baseInfo.connectType ==iPod_Nano_Gen2||_baseInfo.connectType ==iPod_Classic||_baseInfo.connectType ==iPod_Nano_Gen3||_baseInfo.connectType ==iPod_Nano_Gen4||_baseInfo.connectType ==iPod_Nano_Gen5||_baseInfo.connectType ==iPod_Nano_Gen6||_baseInfo.connectType ==iPod_Nano_Gen7||_baseInfo.connectType ==iPod_Shuffle_Gen1||_baseInfo.connectType ==iPod_Shuffle_Gen2||_baseInfo.connectType ==iPod_Shuffle_Gen3||_baseInfo.connectType ==iPod_Shuffle_Gen4||_baseInfo.connectType ==iPod_Touch_1||_baseInfo.connectType ==iPod_Touch_2||_baseInfo.connectType ==iPod_Touch_3||_baseInfo.connectType ==iPod_Touch_4||_baseInfo.connectType ==iPod_Touch_5) {
            iconImg = [StringHelper imageNamed:@"ipod_touch"];
        }else if (_baseInfo.connectType == iPhone||_baseInfo.connectType == iPhone_3G||_baseInfo.connectType == iPhone_3GS||_baseInfo.connectType == iPhone_4||_baseInfo.connectType == iPhone_4S||_baseInfo.connectType == iPhone_5||_baseInfo.connectType == iPhone_5C||_baseInfo.connectType == iPhone_5S ||
                  _baseInfo.connectType == iPhone_6 || _baseInfo.connectType == iPhone_6_Plus|| _baseInfo.connectType == iPhone_6S|| _baseInfo.connectType == iPhone_6S_Plus|| _baseInfo.connectType == iPhone_SE|| _baseInfo.connectType == iPhone_7|| _baseInfo.connectType == iPhone_7_Plus || _baseInfo.connectType == iPhone_8 || _baseInfo.connectType == iPhone_8_Plus || _baseInfo.connectType == iPhone_X) {
            iconImg = [StringHelper imageNamed:@"iPhone"];
        }else if (_baseInfo.connectType == iPad_1||_baseInfo.connectType == iPad_2||_baseInfo.connectType == The_New_iPad||_baseInfo.connectType == iPad_4||_baseInfo.connectType == iPad_Air||_baseInfo.connectType == iPad_Air2||_baseInfo.connectType == iPad_Pro||_baseInfo.connectType == iPad_5||_baseInfo.connectType == iPad_6||_baseInfo.connectType == iPad_mini||_baseInfo.connectType == iPad_mini_2||_baseInfo.connectType == iPad_mini_3){
            iconImg= [StringHelper imageNamed:@"ipad"];
        }else {
            iconImg = [StringHelper imageNamed:@"iPhone"];
        }
        
        iconImg.size = NSMakeSize(20, 28);
        int xPos;
        int yPos;
        if (iconImg != nil) {
            xPos = 10;
            yPos = 4;
            NSRect drawingRect;
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = NSMakeSize(20, 28);
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size.width = imageRect.size.width;
            drawingRect.size.height = imageRect.size.height;
            [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
    }
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

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseStatus = MouseUp;
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

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseStatus = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent{
    _mouseStatus = MouseOut;
    [self setNeedsDisplay:YES];
    
}

- (void)mouseEntered:(NSEvent *)theEvent{
    _mouseStatus = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    [_trackingArea release],_trackingArea = nil;
    [super dealloc];
}
@end

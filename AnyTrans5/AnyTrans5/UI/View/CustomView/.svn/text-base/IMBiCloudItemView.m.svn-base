//
//  IMBiCloudItemView.m
//  AnyTrans
//
//  Created by LuoLei on 17-1-18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBiCloudItemView.h"
#import "StringHelper.h"
#import "CapacityView.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBNotificationDefine.h"
@implementation IMBiCloudItemView
@synthesize isSelected = _isSelected;
@synthesize target = _target;
@synthesize accountName = _accountName;
@synthesize action = _action;
@synthesize client = _client;
@synthesize isAddContent = _isAddContent;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _signOutBtn = [[IMBSignOutButton alloc] initWithFrame:NSMakeRect(217 , 40, 10, 10)];
        _signOutBtn.mouseEnteredImage = [StringHelper imageNamed:@"exit2"];
        _signOutBtn.mouseDownImage = [StringHelper imageNamed:@"exit3"];
        _signOutBtn.mouseExitedImage = [StringHelper imageNamed:@"exit"];
        [_signOutBtn setTarget:self];
        [_signOutBtn setAction:@selector(signOutDrive)];
    }
    return self;
}

- (void)updateTrackingAreas{
	[super updateTrackingAreas];
	if (_trackingArea == nil)
	{
		NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
        _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
        [self addTrackingArea:_trackingArea];
	}
}

- (void)setClient:(IMBiCloudNetClient *)client {
    if (_client != nil) {
        [_client release];
        _client = nil;
    }
    _client = [client retain];
}

- (void)setAccountName:(NSString *)accountName {
    if (_accountName != nil) {
        [_accountName release];
        _accountName = nil;
    }
    _accountName = [accountName retain];
}

-(void)mouseDown:(NSEvent *)theEvent {
    _mouseStatus = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner) {
        if (self.target != nil && self.action != nil) {
            if ([self.target respondsToSelector:self.action]) {
                [self.target performSelector:self.action withObject:_accountName];
            }
        }
    }
}


-(void)mouseExited:(NSEvent *)theEvent{
    _mouseStatus = MouseOut;
    [self setNeedsDisplay:YES];
    
}

-(void)mouseEntered:(NSEvent *)theEvent{
    _mouseStatus = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if (_client == nil && !_isAddContent) {
        return;
    }
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
    if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp) {
        [[StringHelper getColorFromString:CustomColor(@"deviceItemView_enter_bgColor", nil)] set];
    }else if (_mouseStatus == MouseDown) {
        [[StringHelper getColorFromString:CustomColor(@"deviceItemView_down_bgColor", nil)] set];
    }else {
        [[NSColor clearColor] set];
    }
    [path fill];
    
    //设备图片
    NSImage *iconImg = nil;
    if (_isAddContent) {
        iconImg = [StringHelper imageNamed:@"iCloud_addcontent"];
        int xPos;
        int yPos;
        if (iconImg != nil) {
            xPos = 25;
            yPos = 5;
            NSRect drawingRect;
            // 用来苗素图片信息
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = iconImg.size;//NSMakeSize(32, 50);
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size.width = imageRect.size.width;
            drawingRect.size.height = imageRect.size.height;
            [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
    }else {
        if (_client != nil && _client.loginInfo.headImage != nil) {
            iconImg = _client.loginInfo.headImage;
            int xPos;
            int yPos;
            NSRect drawingRect;
            // 用来苗素图片信息
            NSRect imageRect;
            if (iconImg != nil) {
                xPos = 25;
                yPos = (dirtyRect.size.height - iconImg.size.height) / 2;
                imageRect.origin = NSZeroPoint;
                imageRect.size = iconImg.size;
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size.width = imageRect.size.width;
                drawingRect.size.height = imageRect.size.height;
                [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }else {
            iconImg = [StringHelper imageNamed:@"iCloud_iCloud"];
            int xPos;
            int yPos;
            if (iconImg != nil) {
                xPos = 25;
                yPos = 5;
                NSRect drawingRect;
                // 用来苗素图片信息
                NSRect imageRect;
                imageRect.origin = NSZeroPoint;
                imageRect.size = iconImg.size;//NSMakeSize(32, 50);
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size.width = imageRect.size.width;
                drawingRect.size.height = imageRect.size.height;
                [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }
    }
    
    //选中图片
    if (_isSelected) {
        int xPos;
        int yPos;
        NSImage *iconImg = [StringHelper imageNamed:@"device_selete"];
        iconImg.size = NSMakeSize(14, 14);
        xPos = 5;
        yPos = 5;
        NSRect drawingRect;
        // 用来苗素图片信息
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = NSMakeSize(14, 14);
        drawingRect.origin.x = xPos;
        drawingRect.origin.y = yPos+18;
        drawingRect.size.width = imageRect.size.width;
        drawingRect.size.height = imageRect.size.height;
        [iconImg drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }

    if (_isAddContent) {
        //画设备的名字
        if (_accountName != nil) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_accountName withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:135 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(62 , (NSHeight(dirtyRect) - size.height)/2.0 - 4, size.width, 22);
            [attrStr drawInRect:textRect2];
        }
    }else {
        //画设备的名字
//        if (_accountName != nil) {
        NSString *str = _client.loginInfo.loginInfoEntity.fullName;
        if (str != nil) {
            NSSize size ;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:str withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:135 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
            NSRect textRect2 = NSMakeRect(62 , (NSHeight(dirtyRect) - size.height)/2.0 + 10, size.width, 22);
            [attrStr drawInRect:textRect2];
        }

//        }
        
        //剩余空间
        NSRect sizeRect = NSMakeRect(62, 5, 124, 16);
        NSString *str2 = nil;
        
        //    if (!_baseInfo.isLoaded) {
        str2 = [[[self getFileSizeString:(_client.loginInfo.loginInfoEntity.totalStorageInBytes - _client.loginInfo.loginInfoEntity.usedStorageInBytes) reserved:2] stringByAppendingString:@" " ] stringByAppendingString:CustomLocalizedString(@"MainWindow_id_1", nil)];
        //    }else{
        //        str = CustomLocalizedString(@"Device_Main_id_7", nil);
        //    }
        [self drawLeftText:str2 withFrame:sizeRect withFontSize:12 withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        
        //容量条
        //背景灰色
        NSRect bgRect = NSMakeRect(62, 22, 168, 4);
        NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:bgRect xRadius:3 yRadius:3];
        [[StringHelper getColorFromString:CustomColor(@"progress_bgColor", nil)] set];
        [bgPath fill];
        //容量条圆角头部
        NSRect capacityRect = NSMakeRect(62, 22, 4, 4);
        NSBezierPath *capacityPath = [NSBezierPath bezierPathWithRoundedRect:capacityRect xRadius:3 yRadius:3];
        [[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)] set];
        [capacityPath fill];
        
        //退出按钮
        [_signOutBtn setFrame:NSMakeRect(220 , 42, 10, 10)];
        [self addSubview:_signOutBtn];
    }
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

- (void)loadCapacity:(float)percent {
    CapacityView *view = [[CapacityView alloc] initWithFrame:NSMakeRect(0, 0, percent*172-4, 4) WithFillColor:[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)] withPercent:(float)percent];
    [view setFrameOrigin:NSMakePoint(64, 22)];
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

-(void)signOutDrive {
    [_client logoutiCould];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_ICLOUD_EXIT_LOGIN object:self userInfo:@{@"client":_client}];
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

- (void)dealloc
{
    [_trackingArea release],_trackingArea = nil;
    if (_client != nil) {
        [_client release];
        _client = nil;
    }
    if (_accountName) {
        [_accountName release];
        _accountName = nil;
    }
    [super dealloc];
}

@end

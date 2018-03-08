//
//  IMBSelecedDeviceBtn.m
//  PhotoManage
//
//  Created by iMobie023 on 16-1-19.
//  Copyright (c) 2016年 iMobie. All rights reserved.
//

#import "IMBSelecedDeviceBtn.h"
//#import "IMBColorDefine.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#define SPOTRADIUS 3
@implementation IMBSelecedDeviceBtn
@synthesize isDisable = _isDisable;
@synthesize mouseStatus = _mouseStatus;
@synthesize buttonName = _buttonName;
@synthesize textSize = _textSize;
@synthesize textColor = _textColor;
@synthesize isShowIcon = _isShowIcon;
@synthesize isShowTrangle = _isShowTrangle;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    nc = [NSNotificationCenter defaultCenter];
    _isShowIcon = YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    //背景
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:14 yRadius:14];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    if (!_isDisable) {
        if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp ) {
//            [[StringHelper getColorFromString:CustomColor(@"popover_bgEnterColor", nil)] set];
            [IMBGrayColor(242) set];
            [clipPath fill];
            [clipPath closePath];
        }else if (_mouseStatus == MouseDown) {
//            [[StringHelper getColorFromString:CustomColor(@"popover_bgDownColor", nil)] set];
            [IMBGrayColor(235) set];
            [clipPath fill];
            [clipPath closePath];
        }
    }
//    [[StringHelper getColorFromString:CustomColor(@"popover_borderColor", nil)] set];
    [IMBGrayColor(204) set];
    [clipPath stroke];
    [clipPath closePath];
    
    //图片
    int arrowWith = 0;
    if (_isShowTrangle) {
        NSImage *image = nil;
        if (self.isEnabled) {
            image = [NSImage imageNamed:@"arrow"];
        }
        arrowWith = image.size.width;
    }
    
    //Icon图标
    NSRect drawingRect = NSMakeRect(0, 0, 0, 0);
    if (_isShowIcon) {
        NSImage *iconImage = nil;
        if (_connectTpye == general_Android) {
            iconImage = [NSImage imageNamed:@"device_name_android"];
            int  xPos = 0;
            if (_isShowTrangle) {
                xPos = (NSWidth(dirtyRect) - (iconImage.size.width + _sizeWidth.width + arrowWith + 14)) / 2;
            }else {
                xPos = (NSWidth(dirtyRect) - (iconImage.size.width + _sizeWidth.width + arrowWith + 4)) / 2;
            }
            NSRect imageRect;
            imageRect.origin = NSZeroPoint ;
            imageRect.size = iconImage.size;
            drawingRect.origin = NSMakePoint(NSMinX(dirtyRect) + xPos , 5);
            drawingRect.size = imageRect.size;
            [iconImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }else if (_connectTpye == general_iCloud || _connectTpye == 7000) {
            iconImage = [NSImage imageNamed:@"device_name_icloud"];
            int  xPos = 0;
            if (_isShowTrangle) {
                xPos = (NSWidth(dirtyRect) - (iconImage.size.width + _sizeWidth.width + arrowWith + 14)) / 2;
            }else {
                xPos = (NSWidth(dirtyRect) - (iconImage.size.width + _sizeWidth.width + arrowWith + 4)) / 2;
            }
            NSRect imageRect;
            imageRect.origin = NSZeroPoint ;
            imageRect.size = iconImage.size;
            drawingRect.origin = NSMakePoint(NSMinX(dirtyRect) + xPos , 5);
            drawingRect.size = imageRect.size;
            [iconImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }else if (_connectTpye == 0) {
            iconImage = [NSImage imageNamed:@"device_name_noconnect"];
            int  xPos = 0;
            if (_isShowTrangle) {
                xPos = (NSWidth(dirtyRect) - (iconImage.size.width + _sizeWidth.width + arrowWith + 16)) / 2 ;
            }else {
                xPos = (NSWidth(dirtyRect) - (iconImage.size.width + _sizeWidth.width + arrowWith + 18)) / 2 ;
            }
            NSRect imageRect;
            imageRect.origin = NSZeroPoint ;
            imageRect.size = iconImage.size;
            drawingRect.origin = NSMakePoint(NSMinX(dirtyRect) + xPos , 4);
            drawingRect.size = imageRect.size;
            [iconImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }else {
            iconImage = [NSImage imageNamed:@"device_name_apple"];
            int  xPos = 0;
            if (_isShowTrangle) {
                xPos = (NSWidth(dirtyRect) - (iconImage.size.width + _sizeWidth.width + arrowWith + 14)) / 2;
            }else {
                xPos = (NSWidth(dirtyRect) - (iconImage.size.width + _sizeWidth.width + arrowWith + 4)) / 2;
            }
            NSRect imageRect;
            imageRect.origin = NSZeroPoint ;
            imageRect.size = iconImage.size;
            drawingRect.origin = NSMakePoint(NSMinX(dirtyRect) + xPos , 4);
            drawingRect.size = imageRect.size;
            [iconImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }

    //文字
    if (_buttonName != nil) {
        if (_isShowTrangle) {
            NSSize size;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_buttonName withFont:[NSFont fontWithName:@"Helvetica Neue" size:_textSize] withLineSpacing:0 withMaxWidth:100 withSize:&size withColor:_textColor withAlignment:NSCenterTextAlignment];
            NSRect textRect = NSMakeRect(NSMaxX(drawingRect) + 4 , 3, size.width, 22);
            if (_connectTpye == 0) {
                textRect = NSMakeRect(NSMaxX(drawingRect) + 6 , 3, size.width, 22);
            }
            drawingRect = textRect;
            [attrStr drawInRect:textRect];
            //            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_buttonName withFont:[NSFont fontWithName:@"Helvetica Neue" size:_textSize] withLineSpacing:0 withMaxWidth:150 withSize:&size withColor:_textColor withAlignment:NSLeftTextAlignment];
            //            NSRect textRect = NSMakeRect(30 , 1, size.width, 22);
        }else {
            NSSize size;
            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_buttonName withFont:[NSFont fontWithName:@"Helvetica Neue" size:_textSize] withLineSpacing:0 withMaxWidth:155 withSize:&size withColor:_textColor withAlignment:NSCenterTextAlignment];
            NSRect textRect = NSMakeRect(NSMaxX(drawingRect) + 4 , 3, size.width, 22);
            if (_connectTpye == 0) {
                textRect = NSMakeRect(NSMaxX(drawingRect) + 6 , 3, size.width, 22);
            }
            drawingRect = textRect;
            [attrStr drawInRect:textRect];
            //            NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_buttonName withFont:[NSFont fontWithName:@"Helvetica Neue" size:_textSize] withLineSpacing:0 withMaxWidth:155 withSize:&size withColor:_textColor withAlignment:NSLeftTextAlignment];
            //            NSRect textRect = NSMakeRect(30 , 1, size.width, 22);
        }
    }
    
    if (_isShowTrangle) {
        NSImage *image = nil;
        if (self.isEnabled) {
            image = [NSImage imageNamed:@"arrow"];
        }
        NSRect drawingArrowRect;
        NSRect imageRect;
        imageRect.origin = NSZeroPoint ;
        imageRect.size = image.size;
        drawingArrowRect.origin = NSMakePoint(NSMaxX(drawingRect) + 8 , 12);
        drawingArrowRect.size = imageRect.size;
        [image drawInRect:drawingArrowRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
}

- (void)configButtonName:(NSString *)buttonName WithTextColor:(NSColor *)textColor WithTextSize:(float)size WithIsShowIcon:(BOOL)showIcon WithIsShowTrangle:(BOOL)showTrangle  WithIsDisable:(BOOL)isDisable withConnectType:(IPodFamilyEnum)connectType {
    _buttonName = [buttonName retain];
    if (showTrangle) {
        NSSize textsize;
        [StringHelper TruncatingTailForStringDrawing:buttonName withFont:[NSFont fontWithName:@"Helvetica Neue" size:size] withLineSpacing:0 withMaxWidth:100 withSize:&textsize withColor:textColor withAlignment:NSLeftTextAlignment];
        [self setFrameSize:NSMakeSize(180, NSHeight(self.frame))];
        _sizeWidth = textsize;
    }else {
        NSSize textsize;
        [StringHelper TruncatingTailForStringDrawing:buttonName withFont:[NSFont fontWithName:@"Helvetica Neue" size:size] withLineSpacing:0 withMaxWidth:100 withSize:&textsize withColor:textColor withAlignment:NSLeftTextAlignment];
        [self setFrameSize:NSMakeSize(180, NSHeight(self.frame))];
        _sizeWidth = textsize;
//        [StringHelper TruncatingTailForStringDrawing:buttonName withFont:[NSFont fontWithName:@"Helvetica Neue" size:size] withLineSpacing:0 withMaxWidth:150 withSize:&textsize withColor:textColor withAlignment:NSLeftTextAlignment];
//        [self setFrameSize:NSMakeSize(44+textsize.width, NSHeight(self.frame))];
    }
    _textColor = [textColor retain];
    _textSize = size;
    _isShowIcon = showIcon;
    _isShowTrangle = showTrangle;
    _isDisable = isDisable;
    _connectTpye = connectType;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setNeedsDisplay:YES];
    });
}

- (void)setInitFrame:(NSRect)frameRect withButtonTitle:(NSString *)buttonTitle {
    [self setFrame:frameRect];
    _buttonName = [buttonTitle retain];
    [self setTitle:buttonTitle];
    [self setBordered:NO];
    [self setImagePosition:NSImageAbove];
    _isDisable = YES;
    _mouseStatus = MouseOut;
}

- (void)drawLeftText:(NSString *)text withFrame:(NSRect)frame withFontSize:(float)withFontSize withColor:(NSColor *)color {
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:withFontSize];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSLeftTextAlignment];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName ,sysFont ,NSFontAttributeName,style,NSParagraphStyleAttributeName, nil];
    
    NSSize textSize = [as.string sizeWithAttributes:attributes];
    NSSize maxSize = NSMakeSize(156, 20);
    if (textSize.width > maxSize.width ) {
        textSize = maxSize;
    }
    NSRect f = NSMakeRect(frame.origin.x + 22 , frame.origin.y + ceil((frame.size.height - textSize.height) / 2) - 2, textSize.width, textSize.height);
    [as.string drawInRect:f withAttributes:attributes];
    
    [as release];
    [style release];
}

-(void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc]initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)setIsDisable:(BOOL)isDisable {
    if (_isDisable != isDisable) {
        _isDisable = isDisable;
        [self setNeedsDisplay:YES];
    }
}

- (void)setMouseStatus:(MouseStatusEnum)mouseStatus {
    if (_mouseStatus != mouseStatus) {
        _mouseStatus = mouseStatus;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseStatus = MouseEnter;
    [[NSNotificationCenter defaultCenter] postNotificationName:REFREASH_TOPVIEW object:nil];
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseStatus = MouseOut;
    [[NSNotificationCenter defaultCenter] postNotificationName:REFREASH_TOPVIEW object:nil];
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseStatus = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (!_isDisable) {
        [self setMouseStatus:MouseUp];
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [self setNeedsDisplay:YES];
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

-(NSMutableAttributedString *)attributedTitle{
    if (_buttonName) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc] initWithString:_buttonName] autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, _buttonName.length)];
        if (_isDisable) {//禁用状态
            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:77.0/255 green:131.0/255 blue:213.0/255 alpha:1.0] range:NSMakeRange(0, _buttonName.length)];
        }
        
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:_textSize] range:NSMakeRange(0, _buttonName.length)];
        return attributedTitles;
    }
    return nil;
}

- (void)dealloc{
    if (_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    
    [super dealloc];
}
@end

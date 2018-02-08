//
//  IMBAirBackupDeviceBtn.m
//  AnyTrans
//
//  Created by smz on 17/10/20.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAirBackupDeviceBtn.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#define ARROWSPACE 30
#define TITLESPACE 20
#define BTNHEIGHT 36

@implementation IMBAirBackupDeviceBtn
@synthesize mouseStatus = _mouseStatus;
@synthesize buttonName = _buttonName;
@synthesize textSize = _textSize;
@synthesize textColor = _textColor;
@synthesize isDisable = _isDisable;


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    nc = [NSNotificationCenter defaultCenter];
    _isDisable = NO;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    //背景
    if (_hasBorder) {
        NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:dirtyRect.size.height / 2.0 yRadius:dirtyRect.size.height / 2.0];
        [clipPath setWindingRule:NSEvenOddWindingRule];
        [clipPath addClip];
        if (!_isDisable) {
            if (_mouseStatus == MouseEnter || _mouseStatus == MouseUp ) {
                [[StringHelper getColorFromString:CustomColor(@"popover_bgEnterColor", nil)] set];
                [clipPath fill];
                [clipPath closePath];
            }else if (_mouseStatus == MouseDown) {
                [[StringHelper getColorFromString:CustomColor(@"popover_bgDownColor", nil)] set];
                [clipPath fill];
                [clipPath closePath];
            }
        }
        [[StringHelper getColorFromString:CustomColor(@"popover_borderColor", nil)] set];
        [clipPath stroke];
        [clipPath closePath];
    }
    
    
    NSRect drawingRect;
    //文字
    if (_buttonName != nil) {
        NSSize size;
        NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:_buttonName withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:_textSize] withLineSpacing:0 withMaxWidth:200 withSize:&size withColor:_textColor withAlignment:NSCenterTextAlignment];
            drawingRect = NSMakeRect(TITLESPACE + 10 , (BTNHEIGHT - size.height)/2.0 - 2, size.width, size.height);
            [attrStr drawInRect:drawingRect];
    }
    NSImage *image = [StringHelper imageNamed:@"arrow"];
    NSRect drawingArrowRect;
    NSRect imageRect;
    imageRect.origin = NSZeroPoint ;
    imageRect.size = image.size;
    drawingArrowRect.origin = NSMakePoint(NSMaxX(drawingRect) + ARROWSPACE , (BTNHEIGHT - image.size.height)/2.0);
    drawingArrowRect.size = imageRect.size;
    [image drawInRect:drawingArrowRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
    NSBezierPath *circle = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(TITLESPACE - 2, (dirtyRect.size.height - 8)/2.0, 8, 8) xRadius:4 yRadius:4];
    if (_isOnline) {
        [[StringHelper getColorFromString:CustomColor(@"airWifi_device_online", nil)] setFill];
    }else {
         [[StringHelper getColorFromString:CustomColor(@"airWifi_device_disonline", nil)] setFill];
    }
    [circle setClip];
    [circle fill];
    
}

- (void)configButtonName:(NSString *)buttonName WithTextColor:(NSColor *)textColor WithTextSize:(float)size WithOnline:(BOOL)online; {
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    _buttonName = [buttonName retain];
    NSSize textsize;
    [StringHelper TruncatingTailForStringDrawing:buttonName withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:size] withLineSpacing:0 withMaxWidth:200 withSize:&textsize withColor:textColor withAlignment:NSLeftTextAlignment];
    [self setFrameSize:NSMakeSize(TITLESPACE * 2 + ARROWSPACE + textsize.width + 6, BTNHEIGHT)];
    _sizeWidth = textsize;
    
    _textColor = [textColor retain];
    _textSize = size;
    _isOnline = online;
    [self setNeedsDisplay:YES];
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

- (void)setMouseStatus:(MouseStatusEnum)mouseStatus {
    if (_mouseStatus != mouseStatus) {
        _mouseStatus = mouseStatus;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseStatus = MouseEnter;
    _hasBorder = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseStatus = MouseOut;
    _hasBorder = NO;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseStatus = MouseDown;
    _hasBorder = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (!_isDisable) {
        [self setMouseStatus:MouseUp];
        _hasBorder = NO;
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
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:_textSize] range:NSMakeRange(0, _buttonName.length)];
        return attributedTitles;
    }
    return nil;
}

- (void)setIsDisable:(BOOL)isDisable {
    if (_isDisable != isDisable) {
        _isDisable = isDisable;
        [self setNeedsDisplay:YES];
    }
}

- (void)dealloc {
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

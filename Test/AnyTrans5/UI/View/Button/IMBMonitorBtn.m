//
//  IMBMonitorBtn.m
//  MacClean
//
//  Created by JGehry on 9/12/15.
//  Copyright (c) 2015 imobie. All rights reserved.
//

#import "IMBMonitorBtn.h"
#import "StringHelper.h"
@implementation IMBMonitorBtn
@synthesize leftImage = _leftImage;
@synthesize middleImage = _middleImage;
@synthesize rightImage = _rightImage;
@synthesize leftEnterImage = _leftEnterImage;
@synthesize middleEnterImage = _middleEnterImage;
@synthesize rightEnterImage = _rightEnterImage;
@synthesize leftDownImage = _leftDownImage;
@synthesize middleDownImage = _middleDownImage;
@synthesize rightDownImage = _rightDownImage;
@synthesize isBigButton = _isBigButton;
@synthesize isMouseEnter = _isMouseEnter;
@synthesize isMouseDown = _isMouseDown;
@synthesize font = _font;
@synthesize fontColor = _fontColor;
@synthesize fontEnterColor = _fontEnterColor;
@synthesize fontDownColor = _fontDownColor;
@synthesize minWidth = _minWidth;
@synthesize bgImage = _bgImage;
- (void)dealloc
{
    self.leftImage = nil;
    self.middleImage = nil;
    self.rightImage = nil;
    self.leftEnterImage = nil;
    self.middleEnterImage = nil;
    self.rightEnterImage = nil;
    self.leftDownImage = nil;
    self.middleDownImage = nil;
    self.rightDownImage = nil;
    self.font = nil;
    self.fontColor = nil;
    self.fontEnterColor = nil;
    self.fontDownColor = nil;
    self.bgImage = nil;
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self.cell setHighlightsBy:NSNoCellMask];
        _minWidth = 0;
    }
    return self;
}


- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
        [_trackingArea release];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSImage *leftImage = nil;
    NSImage *middleImage = nil;
    NSImage *rightImage = nil;
    if (_isMouseEnter) {
        leftImage = _leftEnterImage;
        middleImage = _middleEnterImage;
        rightImage = _rightEnterImage;
    }else if(_isMouseDown) {
        leftImage = _leftDownImage;
        middleImage = _middleDownImage;
        rightImage = _rightDownImage;
    }else {
        leftImage = _leftImage;
        middleImage = _middleImage;
        rightImage = _rightImage;
    }
    
    if (leftImage != nil && rightImage != nil && middleImage != nil) {
        float xPos = 0;
        float yPos = 0;
        NSRect drawingRect;
        NSRect imageRect;
        // 开始绘制左边的部分
        imageRect.origin = NSZeroPoint;
        imageRect.size = leftImage.size;
        drawingRect.origin.x = xPos;
        drawingRect.origin.y = yPos;
        drawingRect.size = imageRect.size;
        xPos += imageRect.size.width;
        if (drawingRect.size.width > 0) {
            [leftImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
        
        // 开始绘制中间的部分
        imageRect.size = middleImage.size;
        int drawCount = ceil((dirtyRect.size.width - leftImage.size.width - rightImage.size.width) / imageRect.size.width);
        for (int i = 0; i < drawCount; i++) {
            drawingRect.origin.x = xPos;
            drawingRect.origin.y = yPos;
            drawingRect.size = imageRect.size;
            xPos += imageRect.size.width;
            if (drawingRect.size.width > 0) {
                [middleImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            }
        }
        
        // 开始绘制右边的部分
        imageRect.size = rightImage.size;
        drawingRect.origin.x = xPos;
        drawingRect.origin.y = yPos;
        drawingRect.size = imageRect.size;
        if (drawingRect.size.width > 0) {
            [rightImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
    }
    
    if (_bgImage != nil) {
        NSRect drawingRect;
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = _bgImage.size;
        drawingRect.origin = NSMakePoint(dirtyRect.size.width - imageRect.size.width, 0);
        drawingRect.size = imageRect.size;
        [_bgImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
    
    /**
     *  文字垂直居中
     */
    NSString *str = self.title;
    NSColor *color = nil;
    if (!self.fontColor) {
        if (_isMouseDown) {
            if (!_isBigButton) {
                color = self.fontDownColor;
            }
        }else {
            color = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
        }
    }else {
        color = self.fontColor;
    }
    if (_isMouseEnter) {
        color = self.fontEnterColor;
    }else if (_isMouseDown){
        color = self.fontDownColor;
    }
    NSRect drawRect = dirtyRect;
    NSRect titleRect = [StringHelper calcuTextBounds:str fontSize:_font.pointSize];
    if (titleRect.size.width<dirtyRect.size.width-4) {
        drawRect.size.width = titleRect.size.width;
        drawRect.origin.x = ceil((dirtyRect.size.width - titleRect.size.width)/2);
        if (self.font.pointSize == 12.0) {
            drawRect.origin.y = ceil((dirtyRect.size.height - titleRect.size.height - 5)/2);
        }else if (self.font.pointSize == 16.0||self.font.pointSize == 24.0) {
            drawRect.origin.y = ceil((dirtyRect.size.height - titleRect.size.height)/2-2);
        }
    }else {
        drawRect.size.width = dirtyRect.size.width-4;
        drawRect.origin.x = 2;
        drawRect.origin.y = ceil((dirtyRect.size.height - titleRect.size.height)/2);
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_font, color] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    [str drawInRect:drawRect withAttributes:dic];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    IMBMonitorBtn *btn = (IMBMonitorBtn *)[super allocWithZone:zone];
    return btn;
}

- (void)awakeFromNib {
    _minWidth = 0;
    self.font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
//    self.fontEnterColor = [NSColor colorWithDeviceRed:79.0/255 green:125.0/255 blue:196.0/255 alpha:1.000];
//    self.fontDownColor = [NSColor colorWithDeviceRed:71.0/255 green:114.0/255 blue:178.0/255 alpha:1.000] ;
    self.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    self.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    self.fontColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    [self.cell setHighlightsBy:NSNoCellMask];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _isMouseEnter = YES;
        //[super mouseEntered:theEvent];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _isMouseEnter = NO;
        _isMouseDown = NO;
        [super mouseExited:theEvent];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _isMouseDown = YES;
        _isMouseEnter = NO;
        [self setNeedsDisplay:YES];
        [super mouseDown:theEvent];
        _isMouseDown = NO;
        _isMouseEnter = NO;
        [self setNeedsDisplay:YES];
    }
}

- (void)setEnabled:(BOOL)flag
{
    [super setEnabled:flag];
    if (flag) {
        [self setAlphaValue:1.0];
    }else{
        [self setAlphaValue:0.5];
    }
}


- (void)setTitle:(NSString *)aString {
    [super setTitle:aString];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(aString?aString:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,nil]];
    int lengthInt = 0;
    if (title.size.width < 56) {
        lengthInt = 56;
    }else {
        lengthInt = title.size.width;
        if (lengthInt % 2 != 0) {
            lengthInt = title.size.width + 1;
        }
    }
    if (lengthInt >= 56) {
        if (_isBigButton) {
            lengthInt += 28;
        }else {
            lengthInt += 24;
        }
    }
    if (self.font.pointSize == 14.0) {
        lengthInt += 4;
        if (lengthInt<80) {
            lengthInt = 80;
        }
    }else if (self.font.pointSize == 16.0) {
        lengthInt += 16;
        if (lengthInt<100) {
            lengthInt = 100;
        }
    }else if (self.font.pointSize == 18.0) {
        lengthInt += 20;
        if (lengthInt<100) {
            lengthInt = 100;
        }
    }else if (self.font.pointSize == 24.0) {
        lengthInt += 52;
        if (lengthInt<200) {
            lengthInt = 200;
        }
    }
    if (lengthInt<_minWidth) {
        lengthInt = _minWidth;
    }
    [self setFrameSize:NSMakeSize(lengthInt, self.frame.size.height)];
    [self setNeedsDisplay:YES];
    [title release];
    title = nil;
}


@end

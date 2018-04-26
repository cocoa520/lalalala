//
//  IMBScrollView.m
//  AnyTrans
//
//  Created by long on 16-7-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBScrollView.h"
//#import "IMBColorDefine.h"
#import "StringHelper.h"
@implementation IMBScrollView

@synthesize imageName = _imageName;

-(id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib{
    
    [self setBackgroundColor:[NSColor clearColor]];
    [self setDrawsBackground:NO];
    [self setScrollerStyle:NSScrollerStyleOverlay];
    [self setAutohidesScrollers:YES];
}

- (void)setImageName:(NSString *)imageName{
    [_imageName release];
    _imageName = [imageName retain];
    [self setNeedsDisplay:YES];
}

- (void)setHastopBorder:(BOOL)topBorder leftBorder:(BOOL)leftBorder BottomBorder:(BOOL)bottomBorder rightBorder:(BOOL)rightBorder;
{
    _topBorder = topBorder;
    _leftBorder = leftBorder;
    _bottomBorder = bottomBorder;
    _rightBorder = rightBorder;
    [self setNeedsDisplay:YES];

}

- (void)drawRect:(NSRect)dirtyRect{
    [self setScrollerStyle:NSScrollerStyleOverlay];
    if(_imageName.length == 0){
        [[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1] set];
        NSRectFill(dirtyRect);
    }
    [[NSColor clearColor] set];
    NSRectFill(dirtyRect);
    NSImage *image = [NSImage imageNamed:_imageName];
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    int xCount = ceil(self.frame.size.width / imageWidth);
    int yCount = ceil(self.frame.size.height / imageHeight);
    for (int i = 0; i < xCount; i ++) {
        for (int j = 0; j < yCount; j ++) {
            [image drawAtPoint:NSMakePoint(i*imageWidth, j*imageHeight) fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0];
        }
    }
    
    NSRect Rect = self.bounds;
    
    if (_topBorder) {
        
        NSBezierPath *topBorderPath = [NSBezierPath bezierPath];
        [topBorderPath setLineWidth:2.0];
        [topBorderPath moveToPoint:NSMakePoint(0, Rect.size.height)];
        [topBorderPath lineToPoint:NSMakePoint(Rect.size.width, Rect.size.height)];
        [[NSColor colorWithDeviceRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1] setStroke];
        [topBorderPath stroke];
        
    }
    
    if (_leftBorder) {
        
        NSBezierPath *leftBorderPath = [NSBezierPath bezierPath];
        [leftBorderPath setLineWidth:2.0];
        [leftBorderPath moveToPoint:NSMakePoint(0, Rect.size.height)];
        [leftBorderPath lineToPoint:NSMakePoint(0, 0)];
        [[NSColor colorWithDeviceRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1] setStroke];
        [leftBorderPath stroke];
        
    }
    
    if (_bottomBorder) {
        
        NSBezierPath *bottomBorderPath = [NSBezierPath bezierPath];
        [bottomBorderPath setLineWidth:2.0];
        [bottomBorderPath moveToPoint:NSMakePoint(0, 0)];
        [bottomBorderPath lineToPoint:NSMakePoint(Rect.size.width, 0)];
        [[NSColor colorWithDeviceRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1] setStroke];
        [bottomBorderPath stroke];
        
    }
    
    if (_rightBorder) {
        
        NSBezierPath *rightBorderPath = [NSBezierPath bezierPath];
        [rightBorderPath setLineWidth:2.0];
        [rightBorderPath moveToPoint:NSMakePoint(Rect.size.width, 0)];
        [rightBorderPath lineToPoint:NSMakePoint(Rect.size.width, Rect.size.height)];
        [[NSColor colorWithDeviceRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1] setStroke];
        [rightBorderPath stroke];
        
    }
}

- (void)setListener:(id<IMBCollectionListener>)listener {
    _listener = listener;
}

- (void)viewWillDraw {
    [super viewWillDraw];
    [self setScrollerStyle:NSScrollerStyleOverlay];
    
   
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [super scrollWheel:theEvent];
    if ([_listener respondsToSelector:@selector(showVisibleRextPhoto)]) {
        [_listener showVisibleRextPhoto];
    }
   
}


- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

//- (void)mouseDown:(NSEvent *)theEvent
//{
//    
//}

@end

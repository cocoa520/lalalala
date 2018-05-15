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
#import "IMBCloudCollectionView.h"
#import "CloudItemView.h"
#import "IMBCustomTableView.h"
#import "IMBTableRowView.h"
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
        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
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
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
        [topBorderPath stroke];
        
    }
    
    if (_leftBorder) {
        
        NSBezierPath *leftBorderPath = [NSBezierPath bezierPath];
        [leftBorderPath setLineWidth:2.0];
        [leftBorderPath moveToPoint:NSMakePoint(0, Rect.size.height)];
        [leftBorderPath lineToPoint:NSMakePoint(0, 0)];
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
        [leftBorderPath stroke];
        
    }
    
    if (_bottomBorder) {
        
        NSBezierPath *bottomBorderPath = [NSBezierPath bezierPath];
        [bottomBorderPath setLineWidth:2.0];
        [bottomBorderPath moveToPoint:NSMakePoint(0, 0)];
        [bottomBorderPath lineToPoint:NSMakePoint(Rect.size.width, 0)];
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
        [bottomBorderPath stroke];
        
    }
    
    if (_rightBorder) {
        
        NSBezierPath *rightBorderPath = [NSBezierPath bezierPath];
        [rightBorderPath setLineWidth:2.0];
        [rightBorderPath moveToPoint:NSMakePoint(Rect.size.width, 0)];
        [rightBorderPath lineToPoint:NSMakePoint(Rect.size.width, Rect.size.height)];
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
        [rightBorderPath stroke];
        
    }
}

- (void)setListener:(id)listener {
    _listener = listener;
}

- (void)viewWillDraw {
    [super viewWillDraw];
    [self setScrollerStyle:NSScrollerStyleOverlay];
    
   
}

- (void)scrollWheel:(NSEvent *)theEvent {
    [super scrollWheel:theEvent];
    if ([_listener isKindOfClass:[IMBCloudCollectionView class]]) {
        NSPoint mousePt = [_listener convertPoint:[theEvent locationInWindow] fromView:nil];
        BOOL overClose = NO;
        for (CloudItemView *view in [(IMBCloudCollectionView *)_listener subviews]) {
            overClose = NSMouseInRect(mousePt,[view frame], [self isFlipped]);
            if (overClose) {
                [view mouseEntered:theEvent];
            }else {
                [view mouseExited:theEvent];
            }
        }
    }else if ([_listener isKindOfClass:[IMBCustomTableView class]]) {
        NSPoint mousePt = [_listener convertPoint:[theEvent locationInWindow] fromView:nil];
        BOOL overClose = NO;
        NSInteger totalRow = [(IMBCustomTableView *)_listener numberOfRows];
        for (int index=0;index<totalRow;index++) {
            IMBTableRowView *rowView = [(IMBCustomTableView *)_listener rowViewAtRow:index makeIfNecessary:NO];
            overClose = NSMouseInRect(mousePt,[rowView frame], [self isFlipped]);
            if (overClose) {
                [rowView mouseEntered:theEvent];
                if (rowView.subviews) {
                    NSView *view = [rowView.subviews objectAtIndex:0];
                    [view mouseEntered:theEvent];
                }
            }else {
                [rowView mouseExited:theEvent];
                if (rowView.subviews) {
                    NSView *view = [rowView.subviews objectAtIndex:0];
                    [view mouseExited:theEvent];
                }
            }
        }
    }else {
        if (_listener && [_listener respondsToSelector:@selector(showVisibleRextPhoto)]) {
            [_listener showVisibleRextPhoto];
        }
    }
   
}


- (BOOL)mouseDownCanMoveWindow {
    return NO;
}


@end

//
//  IMBCustomScrollView.m
//  AnyTrans
//
//  Created by iMobie on 7/18/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBCustomScrollView.h"
#import "StringHelper.h"
#import "ColorHelper.h"
@implementation IMBCustomScrollView
@synthesize imageName = _imageName;
@synthesize borderColor = _borderColor;
@synthesize isdown = _isdown;
@synthesize isScroll = _isScroll;
-(id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib{
    
//    [self setBackgroundColor:[NSColor clearColor]];
//    [self setDrawsBackground:NO];
    _borderColor = [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] retain];
//    [self setScrollerStyle:NSScrollerStyleOverlay];
}

- (void)setBorderColor:(NSColor *)borderColor
{
    if (_borderColor != borderColor) {
        [_borderColor release];
        _borderColor = [borderColor retain];
        [self setNeedsDisplay:YES];
    }
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
    //    [self setScrollerStyle:NSScrollerStyleOverlay];
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//    NSRectFill(dirtyRect);
    [ColorHelper setGrientColorWithRect:dirtyRect withCorner:NO withPart:4];
    if (_imageName != nil) {
        if(_imageName.length == 0){
            [[NSColor whiteColor] set];
            NSRectFill(dirtyRect);
        }
        [[NSColor clearColor] set];
        NSRectFill(dirtyRect);
        NSImage *image = [StringHelper imageNamed:_imageName];
        float imageWidth = image.size.width;
        float imageHeight = image.size.height;
        int xCount = ceil(self.frame.size.width / imageWidth);
        int yCount = ceil(self.frame.size.height / imageHeight);
        for (int i = 0; i < xCount; i ++) {
            for (int j = 0; j < yCount; j ++) {
                [image drawAtPoint:NSMakePoint(i*imageWidth, j*imageHeight) fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0];
            }
        }
    }
    NSRect Rect = self.bounds;
    
    if (_topBorder) {
        
        NSBezierPath *topBorderPath = [NSBezierPath bezierPath];
        [topBorderPath setLineWidth:2.0];
        [topBorderPath moveToPoint:NSMakePoint(0, Rect.size.height)];
        [topBorderPath lineToPoint:NSMakePoint(Rect.size.width, Rect.size.height)];
        [[NSColor clearColor] setStroke];
        [topBorderPath stroke];
        [_borderColor setStroke];
        [topBorderPath stroke];
        
    }
    
    if (_leftBorder) {
        
        NSBezierPath *leftBorderPath = [NSBezierPath bezierPath];
        [leftBorderPath setLineWidth:2.0];
        [leftBorderPath moveToPoint:NSMakePoint(0, Rect.size.height)];
        [leftBorderPath lineToPoint:NSMakePoint(0, 0)];
        [[NSColor clearColor] setStroke];
        [leftBorderPath stroke];
        [_borderColor setStroke];
        [leftBorderPath stroke];
        
    }
    
    if (_bottomBorder) {
        
        NSBezierPath *bottomBorderPath = [NSBezierPath bezierPath];
        [bottomBorderPath setLineWidth:2.0];
        [bottomBorderPath moveToPoint:NSMakePoint(0, 0)];
        [bottomBorderPath lineToPoint:NSMakePoint(Rect.size.width, 0)];
        [[NSColor clearColor] setStroke];
        [bottomBorderPath stroke];
        [_borderColor setStroke];
        [bottomBorderPath stroke];
        
    }
    
    if (_rightBorder) {
        
        NSBezierPath *rightBorderPath = [NSBezierPath bezierPath];
        [rightBorderPath setLineWidth:2.0];
        [rightBorderPath moveToPoint:NSMakePoint(Rect.size.width, 0)];
        [rightBorderPath lineToPoint:NSMakePoint(Rect.size.width, Rect.size.height)];
        [[NSColor clearColor] setStroke];
        [rightBorderPath stroke];
        [_borderColor setStroke];
        [rightBorderPath stroke];
        
    }
}

- (void)setCollectionView:(NSView *)collectionView {
    _collectionView = collectionView;
}

- (void)viewWillDraw {
    [super viewWillDraw];
    //    [_collectionView showVisibleRextPhoto];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    
}

- (void)scrollWheel:(NSEvent *)theEvent {
    
    if (theEvent.scrollingDeltaY == 0) {
        return;
    }
    BOOL curIsDown = NO;
    if (theEvent.scrollingDeltaY < 0) {
        curIsDown = YES;
    }
    
    if (curIsDown != _isdown && !_isScroll) {
        _isScroll = YES;
        _isdown = curIsDown;
        if ([_delegate respondsToSelector:@selector(scrollerView:withDown:)]) {
            [_delegate scrollerView:self withDown:_isdown];
        }
    }
}

- (void)setDelegate:(id<IMBScrollerProtocol>)delegate {
    _delegate = delegate;
}

@end

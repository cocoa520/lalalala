//
//  IMBClickedImageView.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBClickedImageView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBClickedImageView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    [self.layer setCornerRadius:5];
    _maskView = [[IMBBackgroundBorderView alloc] initWithFrame:self.bounds];
    [_maskView setCanClick:YES];
    [_maskView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"addplaylistBtn_title_downColor", nil)]];
    [_maskView setHasRadius:YES];
    [_maskView setXRadius:5.0 YRadius:5.0];
    [_maskView setAlphaValue:0.0];
//    [self addSubview:_maskView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
    [path addClip];
    [path stroke];
    
    // Drawing code here.
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

#pragma mark - Mouse Actions
- (void)mouseEntered:(NSEvent *)theEvent
{
    [self performSelector:@selector(doChangeCursor:) withObject:@(0) afterDelay:0.1];
    if (self.isEnabled) {
        [_maskView setAlphaValue:0.1];

    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self performSelector:@selector(doChangeCursor:) withObject:@(1) afterDelay:0.1];
    if (self.isEnabled) {
        [_maskView setAlphaValue:0.0];

    }
}

- (void)doChangeCursor:(NSNumber *)number{
    if (number.intValue == 0) {
        [[NSCursor pointingHandCursor] set];
    }else if (number.intValue == 1){
        [[NSCursor arrowCursor] set];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.isEnabled) {
        _eventNumber = theEvent.eventNumber;
        [_maskView setAlphaValue:0.2];

    }
}


- (void)mouseUp:(NSEvent *)theEvent
{
    if (theEvent.eventNumber == _eventNumber&&self.isEnabled) {
        [_maskView setAlphaValue:0.0];

        [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (void)changeSkin:(NSNotification *) noti {
    [_maskView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"addplaylistBtn_title_downColor", nil)]];
    [self setNeedsDisplay:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [_maskView release],_maskView = nil;
    [super dealloc];
}

@end

//
//  IMBCheckBtn.m
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCheckBtn.h"
#import "StringHelper.h"
@implementation IMBCheckBtn
@synthesize checkImg = _checkImg;
@synthesize unCheckImg = _unCheckImg;
@synthesize trackingArea = _trackingArea;
@synthesize mixImg = _mixImg;
@synthesize shouldNotChangeState = _shouldNotChangeState;
@synthesize isDrawColor = _isDrawColor;
- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg mixImg:(NSImage *)mixImg{
    if (self = [super init]) {
        _checkImg = [checkImg retain];
        _unCheckImg = [uncheckImg retain];
        _mixImg = [mixImg retain];
       NSButtonCell *btnCell = [[NSButtonCell alloc] initImageCell:_unCheckImg];
        btnCell.imageScaling = NSImageScaleProportionallyUpOrDown;
        btnCell.bezelStyle = NSTexturedRoundedBezelStyle;
        [btnCell setButtonType:NSToggleButton];
        [btnCell setBordered:NO];
        [self setAllowsMixedState:false];
        [self setButtonType:NSToggleButton];
        [self setCell:btnCell];
        [btnCell release];
        [self setImage:_unCheckImg];
    }
    return self;
}

- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg
{
    if (self = [super init]) {
        _checkImg = [checkImg retain];
        _unCheckImg = [uncheckImg retain];
        NSButtonCell *btnCell = [[NSButtonCell alloc] initImageCell:_unCheckImg];
        btnCell.imageScaling = NSImageScaleProportionallyUpOrDown;
        btnCell.bezelStyle = NSTexturedRoundedBezelStyle;
        [btnCell setButtonType:NSToggleButton];
        [btnCell setBordered:NO];
        [self setAllowsMixedState:false];
        [self setButtonType:NSToggleButton];
        [self setCell:btnCell];
        [btnCell release];
        [self setImage:_unCheckImg];
    }
    return self;
}
- (id)init{
    NSImage *unCheckImage = [StringHelper imageNamed:@"checkbox1"];
    NSImage *checkImg = [StringHelper imageNamed:@"checkbox2"];
    NSImage *mixImg = [StringHelper imageNamed:@"checkbox3"];
    if (self = [self initWithCheckImg:checkImg unCheckImg:unCheckImage mixImg:mixImg]) {
        
    }
    return self;
}

- (void)setCheckImg:(NSImage *)checkImg {
    if (_checkImg != nil) {
        [_checkImg release];
        _checkImg = nil;
    }
    _checkImg = [checkImg retain];
}

- (void)setUnCheckImg:(NSImage *)unCheckImg {
    if (_unCheckImg != nil) {
        [_unCheckImg release];
        _unCheckImg = nil;
    }
    _unCheckImg = [unCheckImg retain];
}

-(void)drawRect:(NSRect)dirtyRect{
    if (_isDrawColor) {
//        NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
//        [clipPath setWindingRule:NSEvenOddWindingRule];
//        [clipPath addClip];
//        [PLAYLIST_BACKGROUND_COLOR set];
//        [clipPath fill];
    }
    [super drawRect:dirtyRect];

}

- (void)updateTrackingAreas
{
    //这里不要跟踪区域
//    [super updateTrackingAreas];
//    NSTrackingAreaOptions options = NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow;
//    self.trackingArea = [[NSTrackingArea alloc]initWithRect:self.bounds options:options owner:self userInfo:nil];
//    [self addTrackingArea:self.trackingArea];
}

- (void)setState:(NSInteger)value
{
    if (value == NSOnState) {
        [self setImage:_checkImg];
    }
    else if(value == NSOffState){
        [self setImage:_unCheckImg];
    }
    else if(value == NSMixedState){
        [self setImage:_mixImg];
    }
    [super setState:value];
}

- (void)mouseDown:(NSEvent *)theEvent{
    if (![self isEnabled]) {
        return;
    }
    if (self.state == NSMixedState) {
        self.state = NSOffState;
    }
    else{
        [self setState:self.state == NSOnState?NSOffState:NSOnState];
        NSLog(@"%ld",(long)self.state);
    }
    [NSApp sendAction:self.action to:self.target from:self];
}



- (void)dealloc
{
     [super dealloc];
    if (_checkImg) {
        [_checkImg release];
        _checkImg = nil;
    }
    if (_unCheckImg) {
        [_unCheckImg release];
        _unCheckImg = nil;
    }
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_mixImg) {
        [_mixImg release];
        _mixImg = nil;
    }
}

@end

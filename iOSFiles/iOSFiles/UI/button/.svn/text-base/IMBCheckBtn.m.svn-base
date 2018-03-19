//
//  IMBCheckBtn.m
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCheckBtn.h"

@implementation IMBCheckBtn
@synthesize checkImg = _checkImg;
@synthesize unCheckImg = _unCheckImg;
@synthesize mixImg = _mixImg;
@synthesize shouldNotChangeState = _shouldNotChangeState;
@synthesize isbackUpsettingBtn = _isbackUpsettingBtn;
@synthesize isDFUView = _isDFUView;
@synthesize isIosFixView = _isIosFixView;
@synthesize isiOsFixMainView = _isiOsFixMainView;
@synthesize isMouseEnter = _isMouseEnter;
- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg mixImg:(NSImage *)mixImg {
    if (self = [super init]) {
        _checkImg = [checkImg retain];
        _unCheckImg = [uncheckImg retain];
        _mixImg = [mixImg retain];
        NSButtonCell *btnCell = [[NSButtonCell alloc] initImageCell:_unCheckImg];
        btnCell.imageScaling = NSImageScaleProportionallyUpOrDown;
        btnCell.bezelStyle = NSTexturedRoundedBezelStyle;
        [btnCell setButtonType:NSToggleButton];
        [btnCell setBordered:NO];
        [btnCell setAllowsMixedState:YES];
        [self setAllowsMixedState:YES];
        [self setButtonType:NSToggleButton];
        [self setCell:btnCell];
        [btnCell release];
        [self setImage:_unCheckImg];
    }
    return self;
}

- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg {
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

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	
	if (_trackingArea)
	{
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (id)init {
    NSImage *unCheckImage = [NSImage imageNamed:@"mod_icon_checkbox"];
    NSImage *checkImg = [NSImage imageNamed:@"mod_icon_checkbox_selected"];
    NSImage *mixImg = [NSImage imageNamed:@"mod_icon_checkbox_selected"];
    if (self = [self initWithCheckImg:checkImg unCheckImg:unCheckImage mixImg:mixImg]) {
        
    }
    return self;
}

- (void)setCheckStateImage:(NSString *)btnName {
    _checkImg = [[NSImage imageNamed:[NSString stringWithFormat:@"%@2",btnName]] retain];
    _unCheckImg = [[NSImage imageNamed:[NSString stringWithFormat:@"%@1",btnName]] retain];
   [self setImage:_unCheckImg];
}

- (void)setState:(NSInteger)value
{
    if (_isIosFixView) {
        if (value == NSOnState) {
            [self setImage:[NSImage imageNamed:@"sel2"]];
        }
        else if(value == NSOffState){
            [self setImage:[NSImage imageNamed:@"sel1"]];
        }
        else if(value == NSMixedState){
            [self setImage:[NSImage imageNamed:@"box_mix_select1"]];
        }
    }else if (_isiOsFixMainView){
        if (_buttonType == MouseEnter) {
            if (value == NSOnState) {
                [self setImage:[NSImage imageNamed:@"fix_select2"]];
            }
            else if(value == NSOffState){
                [self setImage:[NSImage imageNamed:@"fix_noselect2"]];
            }
            else if(value == NSMixedState){
                [self setImage:[NSImage imageNamed:@"box_mix_select1"]];
            }
        }else{
            if (value == NSOnState) {
                [self setImage:[NSImage imageNamed:@"fix_select1"]];
            }
            else if(value == NSOffState){
                [self setImage:[NSImage imageNamed:@"fix_noselect1"]];
            }
            else if(value == NSMixedState){
                [self setImage:[NSImage imageNamed:@"box_mix_select1"]];
            }
        }
    }else{
        if (_isDFUView) {
            if (value == NSOnState) {
                [self setImage:[NSImage imageNamed:@"seleteItem"]];
            }
            else if(value == NSOffState){
                [self setImage:[NSImage imageNamed:@"selete_none"]];
            }
            else if(value == NSMixedState){
                [self setImage:[NSImage imageNamed:@"box_mix_select1"]];
            }
        }else{
            if (value == NSOnState) {
                [self setImage:[NSImage imageNamed:@"mod_icon_checkbox_selected"]];
            }
            else if(value == NSOffState){
                [self setImage:[NSImage imageNamed:@"mod_icon_checkbox"]];
            }
            else if(value == NSMixedState){
                [self setImage:[NSImage imageNamed:@"box_mix_select1"]];
            }
        }
    }


    [self setNeedsDisplay:YES];
    [super setState:value];
}

- (void)mouseDown:(NSEvent *)theEvent{
    if (!_isbackUpsettingBtn) {
        if (![self isEnabled]) {
            return;
        }
        if (self.state == NSMixedState) {
            self.state = NSOnState;
        }
        else{
            [self setState:self.state == NSOnState?NSOffState:NSOnState];
            NSLog(@"%ld",(long)self.state);
        }
    }
    _buttonType = MouseDown;
    [self setState:self.state];
    [self setNeedsDisplay:YES];
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)mouseExited:(NSEvent *)theEvent{
    [super mouseExited:theEvent];
    _buttonType = MouseOut;
    [self setState:self.state];
    [self setNeedsDisplay:YES];
}

-(void)mouseEntered:(NSEvent *)theEvent{
    [super mouseEntered:theEvent];
    _buttonType = MouseEnter;
    [self setState:self.state];
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent{
    [super mouseUp:theEvent];
    _buttonType = MouseUp;
    [self setState:self.state];
    [self setNeedsDisplay:YES];

}

- (void)dealloc
{
    if (_checkImg) {
        [_checkImg release];
        _checkImg = nil;
    }
    if (_unCheckImg) {
        [_unCheckImg release];
        _unCheckImg = nil;
    }
    if (_mixImg) {
        [_mixImg release];
        _mixImg = nil;
    }
    
    [super dealloc];
}

@end

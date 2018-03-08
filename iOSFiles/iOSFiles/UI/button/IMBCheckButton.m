//
//  IMBCheckBtn.m
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCheckButton.h"
#import "StringHelper.h"

@implementation IMBCheckButton
@synthesize checkImg = _checkImg;
@synthesize unCheckImg = _unCheckImg;
@synthesize mixImg = _mixImg;
@synthesize shouldNotChangeState = _shouldNotChangeState;
@synthesize isbackUpsettingBtn = _isbackUpsettingBtn;
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

- (id)init {
    NSImage *unCheckImage = [NSImage imageNamed:@"sel_non"];
    NSImage *checkImg = [NSImage imageNamed:@"sel_all"];
    NSImage *mixImg = [NSImage imageNamed:@"sel_sem"];
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
    if (value == NSOnState) {
        [self setImage:[NSImage imageNamed:@"sel_all"]];//box_select1
    }
    else if(value == NSOffState){
        [self setImage:[NSImage imageNamed:@"sel_non"]];//box_default1
    }
    else if(value == NSMixedState){
        [self setImage:[NSImage imageNamed:@"sel_sem"]];//box_mix_select1
    }
    [self setNeedsDisplay:YES];
    [self setNeedsDisplay];
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
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)dealloc
{
    if (_checkImg != nil) {
        [_checkImg release];
        _checkImg = nil;
    }
    if (_unCheckImg != nil) {
        [_unCheckImg release];
        _unCheckImg = nil;
    }
    if (_mixImg != nil) {
        [_mixImg release];
        _mixImg = nil;
    }
    
    [super dealloc];
}

@end

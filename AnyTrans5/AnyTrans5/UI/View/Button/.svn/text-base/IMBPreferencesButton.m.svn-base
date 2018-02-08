//
//  IMBPreferencesButton.m
//  AnyTrans
//
//  Created by long on 16-8-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBPreferencesButton.h"
#import "StringHelper.h"

@implementation IMBPreferencesButton
@synthesize buttonType = _buttonType;
@synthesize isDown = _isDown;
@synthesize buttonName = _buttonName;
- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:buttonName];
        _btnCell = [[IMBGeneralBtnCell alloc] init];
        [_btnCell setIsDrawBg:YES];
        [self setCell:_btnCell];
        _buttonName = [buttonName retain];
        _buttonType = MouseOut;
        //        [self setButtonType:NSMomentaryPushInButton];
        //        [self setBezelStyle:NSTexturedSquareBezelStyle];
        //        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSNoImage];
        [self setBordered:NO];
        [self setButtonImageName:prefixImageName];
        [self setNeedsDisplay:YES];
    }
    return self;
}

- (void)dealloc
{
    if (_leftImageName != nil) {
        [_leftImageName release];
        _leftImageName = nil;
    }
    if (_rightImageName != nil) {
        [_rightImageName release];
        _rightImageName = nil;
    }
    if (_middleImageName != nil) {
        [_middleImageName release];
        _middleImageName = nil;
    }
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    if (_btnCell != nil) {
        [_btnCell release];
        _btnCell = nil;
    }
    [super dealloc];
}

- (void)reSetInit:(NSString *)btnName WithPrefixImageName:(NSString *)prefixImageName {
    [self setTitle:btnName];
    _buttonName = [btnName retain];
    _buttonType = MouseOut;
    _btnCell = [[IMBGeneralBtnCell alloc] init];
    [_btnCell setIsDrawBg:YES];
    [self setCell:_btnCell];
    //    [self setButtonType:NSMomentaryPushInButton];
    //    [self setBezelStyle:NSTexturedSquareBezelStyle];
    //    [self setAlignment:NSCenterTextAlignment];
    [self setImagePosition:NSNoImage];
    [self setBordered:NO];
    [self setButtonImageName:prefixImageName];
    [self setNeedsDisplay:YES];
}

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	if (_trackingArea)
	{
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)setButtonImageName:(NSString *)prefixImageName {
    _leftImageName = [[NSString stringWithFormat:@"%@_left",prefixImageName] retain];
    _rightImageName = [[NSString stringWithFormat:@"%@_right",prefixImageName] retain];
    _middleImageName = [[NSString stringWithFormat:@"%@_min",prefixImageName] retain];
}


- (void)drawRect:(NSRect)dirtyRect {
    if (_isDown) {
        _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_leftImageName]];
        _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_rightImageName]];
        _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",_middleImageName]];
    }else{
        if (_buttonType == MouseDown) {
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",_middleImageName]];
        }else{
            _btnCell.leftImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_leftImageName]];
            _btnCell.rightImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_rightImageName]];
            _btnCell.middleImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",_middleImageName]];
        }

    }
    [super drawRect:dirtyRect];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled) {
        _buttonType = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseUp:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseUp;
        [self setNeedsDisplay:YES];
        //        [self setAttributedTitle:[self attributedTitle:self.isEnabled]];
        NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
        BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
        if (mouseInside) {
            if (theEvent.clickCount == 1&&self.target != nil && self.action != nil && self.isEnabled) {
                if ([self.target respondsToSelector:self.action]) {
                    [self.target performSelector:self.action withObject:self];
                }
            }
        }
    }
}



@end

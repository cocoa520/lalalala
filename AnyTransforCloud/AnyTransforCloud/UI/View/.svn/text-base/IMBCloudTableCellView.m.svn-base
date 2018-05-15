//
//  IMBCloudTableCellView.m
//  AnyTransforCloud
//
//  Created by hym on 19/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBCloudTableCellView.h"
#import "StringHelper.h"
#import "IMBWhiteView.h"
#import "IMBImageAndColorButton.h"
#import "IMBAddCloudViewController.h"
@implementation IMBCloudTableCellView
@synthesize cloudImageView = _cloudImageView;
@synthesize cloudName = _cloudName;
@synthesize cloudPerson = _cloudPerson;
@synthesize cloudSize = _cloudSize;
@synthesize cloudTime = _cloudTime;
@synthesize deleteBtn = _deleteBtn;
@synthesize isEditingName = _isEditingName;
@synthesize delegate = _delegate;
@synthesize driveID = _driveID;

- (void)awakeFromNib {
    [_cloudName setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_cloudPerson setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_cloudTime setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_cloudSize setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_underLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_deleteBtn mouseDownImage:[NSImage imageNamed:@"mycloud_icon_cancel_pressed"] withMouseUpImg:[NSImage imageNamed:@"mycloud_icon_cancel_hover"] withMouseExitedImg:[NSImage imageNamed:@"mycloud_icon_cancel_normal"] mouseEnterImg:[NSImage imageNamed:@"mycloud_icon_cancel_hover"]];
    [_editBtn mouseDownImage:[NSImage imageNamed:@"mycloud_icon_rename_pressed"] withMouseUpImg:[NSImage imageNamed:@"mycloud_icon_rename_hover"] withMouseExitedImg:[NSImage imageNamed:@"mycloud_icon_rename_normal"] mouseEnterImg:[NSImage imageNamed:@"mycloud_icon_rename_hover"]];
    [_cloudName setEditable:NO];
    [_cloudName setSelectable:NO];
    _isEditingName = NO;
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_buttonType == MouseEnter || _buttonType == MouseDown || _buttonType == MouseUp) {
        if (_shadow) {
            [_shadow release];
            _shadow = nil;
        }
        _shadow = [[NSShadow alloc] init];
        [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        [_shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
        [_shadow setShadowBlurRadius:5.0];
        [_shadow set];
        [_underLineView setHidden:YES];
        [_editBtn setHidden:NO];
    }else {
        [_underLineView setHidden:NO];
        [_editBtn setHidden:YES];
    }
    
    NSRect newRect = NSMakeRect(dirtyRect.origin.x + 5, dirtyRect.origin.y + 5, self.frame.size.width-10, self.frame.size.height - 2);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [path closePath];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _buttonType = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _buttonType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _buttonType = MouseDown;
    _isEditingName = NO;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _buttonType = MouseUp;
    [self setNeedsDisplay:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(jumpCloudView:)]) {
        [_delegate jumpCloudView:_driveID];
    }
}

- (void)dealloc {
    if(_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end

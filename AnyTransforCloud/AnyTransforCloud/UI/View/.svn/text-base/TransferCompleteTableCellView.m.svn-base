//
//  TransferCompleteTableCellView.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "TransferCompleteTableCellView.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBDriveModel.h"
#import "IMBTransferProgressView.h"
@implementation TransferCompleteTableCellView
@synthesize titleField = _titleField;
@synthesize icon = _icon;
@synthesize cloudiCon = _cloudiCon;
@synthesize sizeField = _sizeField;
@synthesize timeFiled = _timeFiled;
@synthesize completeButton = _completeButton;
@synthesize findButton = _findButton;
@synthesize closeButton = _closeButton;
@synthesize downOrUpImage = _downOrUpImage;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [_titleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_sizeField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_timeFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
   
    [_completeButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_complete"] mouseExitImage:[NSImage imageNamed:@"transfer_complete"] mouseDownImage:[NSImage imageNamed:@"transfer_complete"]];
    [_closeButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_delete"] mouseExitImage:[NSImage imageNamed:@"transfer_delete"] mouseDownImage:[NSImage imageNamed:@"transfer_delete"]];
    [_closeButton setTag:103];
    [_findButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_find"] mouseExitImage:[NSImage imageNamed:@"transfer_find"] mouseDownImage:[NSImage imageNamed:@"transfer_find"]];
    NSEvent *event = nil;
    [self mouseExited:event];
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

- (void)setDriveModel:(IMBDriveModel *)driveModel {
    _driveModel = driveModel;
}

- (IMBDriveModel *)getDriveModel {
    return _driveModel;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [_closeButton setHidden:NO];
    [_completeButton setHidden:YES];
    if (_driveModel.state == DownloadStateComplete) {
        [_findButton setHidden:NO];
    }
    _buttonType = MouseEnter;
     [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [_closeButton setHidden:YES];
    [_findButton setHidden:YES];
    [_completeButton setHidden:NO];
    _buttonType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)dealloc {
    if(_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end

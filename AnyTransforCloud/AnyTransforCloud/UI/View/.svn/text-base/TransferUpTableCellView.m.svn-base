//
//  TransferUpTableCellView.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "TransferUpTableCellView.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBDriveModel.h"
#import "IMBTransferProgressView.h"
@implementation TransferUpTableCellView
@synthesize titleField = _titleField;
@synthesize icon = _icon;
@synthesize cloudiCon = _cloudiCon;
@synthesize progessField = _progessField;
@synthesize downloadFaildField = _downloadFaildField;
@synthesize reUpLoad = _reUpLoad;
@synthesize downOrUpImage = _downOrUpImage;
@synthesize progressView = _progressView;
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [_titleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_progessField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_downloadFaildField setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_closeButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_delete"] mouseExitImage:[NSImage imageNamed:@"transfer_delete"] mouseDownImage:[NSImage imageNamed:@"transfer_delete"]];
    [_closeButton setTag:101];
    [_reUpLoad setMouseEnteredImage:[NSImage imageNamed:@"transfer_refresh"] mouseExitImage:[NSImage imageNamed:@"transfer_refresh"] mouseDownImage:[NSImage imageNamed:@"transfer_refresh"]];
    [_reUpLoad setHidden:YES];
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
    if (_driveModel.isDownLoad) {
        _progressView.isDownLoad = YES;
    }else {
        _progressView.isDownLoad = NO;
    }
    [_progressView setNeedsDisplay:YES];
}

- (IMBDriveModel *)getDriveModel {
    return _driveModel;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [_closeButton setHidden:NO];
    [_progressView setHidden:YES];
}
- (void)mouseExited:(NSEvent *)theEvent {
    [_closeButton setHidden:YES];
    if (_driveModel.state == UploadStateError) {
        [_progressView setHidden:YES];
    }else {
        [_progressView setHidden:NO];
    }
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

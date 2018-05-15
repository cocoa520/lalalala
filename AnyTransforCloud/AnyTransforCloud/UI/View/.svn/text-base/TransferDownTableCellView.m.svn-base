//
//  TransferTableCellView.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "TransferDownTableCellView.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBDriveModel.h"
#import "IMBTransferProgressView.h"
@implementation TransferDownTableCellView
@synthesize titleField = _titleField;
@synthesize icon = _icon;
@synthesize cloudiCon = _cloudiCon;
@synthesize progessField = _progessField;
@synthesize downloadFaildField = _downloadFaildField;
@synthesize contiuneDownLoadButton = _contiuneDownLoadButton;
@synthesize closeButton = _closeButton;
@synthesize pauseButton = _pauseButton;
@synthesize reDownLoad = _reDownLoad;
@synthesize downOrUpImage = _downOrUpImage;
@synthesize progressView = _progressView;
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
    [_progessField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_downloadFaildField setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_closeButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_delete"] mouseExitImage:[NSImage imageNamed:@"transfer_delete"] mouseDownImage:[NSImage imageNamed:@"transfer_delete"]];
    [_closeButton setTag:102];
    [_pauseButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_pause"] mouseExitImage:[NSImage imageNamed:@"transfer_pause"] mouseDownImage:[NSImage imageNamed:@"transfer_pause"]];
    [_reDownLoad setMouseEnteredImage:[NSImage imageNamed:@"transfer_refresh"] mouseExitImage:[NSImage imageNamed:@"transfer_refresh"] mouseDownImage:[NSImage imageNamed:@"transfer_refresh"]];
    [_contiuneDownLoadButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_start"] mouseExitImage:[NSImage imageNamed:@"transfer_start"] mouseDownImage:[NSImage imageNamed:@"transfer_start"]];
    
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
    if (_driveModel.state == DownloadStateError) {
        
    }else if (_driveModel.state == DownloadStatePaused) {
        
    }else {
        [_pauseButton setHidden:NO];
    }
    
}
- (void)mouseExited:(NSEvent *)theEvent {
    [_closeButton setHidden:YES];
    [_pauseButton setHidden:YES];
    if (_driveModel.state == DownloadStateError) {
        [_progressView setHidden:YES];
    }else if (_driveModel.state == DownloadStatePaused) {
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

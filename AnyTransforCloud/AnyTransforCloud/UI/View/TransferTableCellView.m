//
//  TransferTableCellView.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "TransferTableCellView.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBDriveModel.h"
#import "IMBTransferProgressView.h"
@implementation TransferTableCellView
@synthesize titleField = _titleField;
@synthesize icon = _icon;
@synthesize progessField = _progessField;
@synthesize downloadFaildField = _downloadFaildField;
@synthesize completeButton = _completeButton;
@synthesize contiuneDownLoadButton = _contiuneDownLoadButton;
@synthesize findButton = _findButton;
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
    [_progessField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_downloadFaildField setTextColor:[StringHelper getColorFromString:CustomColor(@"signin_error_color", nil)]];
    [_completeButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_complete"] mouseExitImage:[NSImage imageNamed:@"transfer_complete"] mouseDownImage:[NSImage imageNamed:@"transfer_complete"]];
    [_closeButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_delete"] mouseExitImage:[NSImage imageNamed:@"transfer_delete"] mouseDownImage:[NSImage imageNamed:@"transfer_delete"]];
    [_findButton setMouseEnteredImage:[NSImage imageNamed:@"transfer_find"] mouseExitImage:[NSImage imageNamed:@"transfer_find"] mouseDownImage:[NSImage imageNamed:@"transfer_find"]];
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
//    [_driveModel addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"progress"]) {
//        double progress = [[change objectForKey:@"new"] doubleValue];
//        [_progressView setProgress:progress];
//    }
//}

- (void)mouseEntered:(NSEvent *)theEvent {
    [_closeButton setHidden:NO];
    if (_driveModel.isDownLoad) {
//        if (_driveModel.state == DownloadStateComplete) {
//            [_findButton setHidden:NO];
//        }
//        if (_driveModel.state == DownloadStateError) {
//            [_reDownLoad setHidden:NO];
//        }
//        [_contiuneDownLoadButton setHidden:NO];
        //TODO: HUYUMIN 暂停继续按钮
    }
}
- (void)mouseExited:(NSEvent *)theEvent {
    [_closeButton setHidden:YES];
    [_findButton setHidden:YES];
    [_reDownLoad setHidden:YES];
    [_contiuneDownLoadButton setHidden:YES];
    [_pauseButton setHidden:YES];
}

- (void)scrollWheel:(NSEvent *)theEvent {
    [super scrollWheel:theEvent];
    NSEvent *event = nil;
    [self mouseExited:event];
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

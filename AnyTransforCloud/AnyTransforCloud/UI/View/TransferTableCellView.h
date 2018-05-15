//
//  TransferTableCellView.h
//  AnyTrans
//
//  Created by ; on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HoverButton.h"
#import "IMBWhiteView.h"
@class IMBDriveModel;
@class IMBTransferProgressView;
@interface TransferTableCellView : NSTableCellView
{
    IBOutlet NSImageView *_icon;
    IBOutlet NSTextField *_titleField;
    IBOutlet NSImageView *_downOrUpImage;
    IBOutlet NSTextField *_progessField;
    IBOutlet NSTextField *_downloadFaildField;
    IBOutlet HoverButton *_completeButton;
    IBOutlet HoverButton *_contiuneDownLoadButton;
    IBOutlet HoverButton *_findButton;
    IBOutlet HoverButton *_closeButton;
    IBOutlet HoverButton *_pauseButton;
    IBOutlet HoverButton *_reDownLoad;
    IBOutlet IMBTransferProgressView *_progressView;
    long long _downSize;
    NSTrackingArea *_trackingArea;
    BOOL _isEnter;
    IMBDriveModel *_driveModel;
}

@property (nonatomic, retain) NSImageView *icon;
@property (nonatomic, retain) NSImageView *downOrUpImage;
@property (nonatomic, assign) NSTextField *titleField;
@property (nonatomic, assign) NSTextField *progessField;
@property (nonatomic, assign) NSTextField *downloadFaildField;
@property (nonatomic, assign) HoverButton *completeButton;
@property (nonatomic, assign) HoverButton *contiuneDownLoadButton;
@property (nonatomic, assign) HoverButton *findButton;
@property (nonatomic, assign) HoverButton *closeButton;
@property (nonatomic, assign) HoverButton *pauseButton;
@property (nonatomic, assign) HoverButton *reDownLoad;
@property (nonatomic, retain) IMBTransferProgressView *progressView;
- (void)setDriveModel:(IMBDriveModel *)driveModel;
//- (void)adjustSpaceX:(float)x Y:(float)y;
@end

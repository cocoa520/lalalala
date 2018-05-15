//
//  TransferUpTableCellView.h
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
@interface TransferUpTableCellView : NSTableCellView
{
    IBOutlet NSImageView *_icon;
    IBOutlet NSImageView *_cloudiCon;
    IBOutlet NSTextField *_titleField;
    IBOutlet NSImageView *_downOrUpImage;
    IBOutlet NSTextField *_downloadFaildField;
    IBOutlet HoverButton *_closeButton;
    IBOutlet HoverButton *_reUpLoad;
    IBOutlet IMBTransferProgressView *_progressView;
    long long _downSize;
    NSTrackingArea *_trackingArea;
    BOOL _isEnter;
    IMBDriveModel *_driveModel;
}

@property (nonatomic, retain) NSImageView *icon;
@property (nonatomic, retain) NSImageView *cloudiCon;
@property (nonatomic, retain) NSImageView *downOrUpImage;
@property (nonatomic, assign) NSTextField *titleField;
@property (nonatomic, assign) NSTextField *progessField;
@property (nonatomic, assign) NSTextField *downloadFaildField;
@property (nonatomic, assign) HoverButton *closeButton;
@property (nonatomic, assign) HoverButton *reUpLoad;
@property (nonatomic, retain) IMBTransferProgressView *progressView;
- (void)setDriveModel:(IMBDriveModel *)driveModel;
- (IMBDriveModel *)getDriveModel;
//- (void)adjustSpaceX:(float)x Y:(float)y;
@end

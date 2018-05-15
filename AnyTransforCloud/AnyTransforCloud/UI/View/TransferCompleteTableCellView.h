//
//  TransferCompleteTableCellView.h
//  AnyTrans
//
//  Created by ; on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HoverButton.h"
#import "IMBWhiteView.h"
#import "IMBCommonEnum.h"
@class IMBDriveModel;
@class IMBTransferProgressView;
@interface TransferCompleteTableCellView : NSTableCellView
{
    IBOutlet NSImageView *_icon;
    IBOutlet NSImageView *_cloudiCon;
    IBOutlet NSTextField *_titleField;
    IBOutlet NSTextField *_sizeField;
    IBOutlet NSTextField *_timeFiled;
    IBOutlet NSImageView *_downOrUpImage;
    IBOutlet HoverButton *_closeButton;
    IBOutlet HoverButton *_completeButton;
    IBOutlet HoverButton *_findButton;
    long long _downSize;
    NSTrackingArea *_trackingArea;
    BOOL _isEnter;
    IMBDriveModel *_driveModel;
    MouseStatusEnum _buttonType;
}

@property (nonatomic, retain) NSImageView *icon;
@property (nonatomic, retain) NSImageView *cloudiCon;
@property (nonatomic, retain) NSImageView *downOrUpImage;
@property (nonatomic, assign) NSTextField *titleField;
@property (nonatomic, assign) NSTextField *sizeField;
@property (nonatomic, assign) NSTextField *timeFiled;
@property (nonatomic, assign) HoverButton *completeButton;
@property (nonatomic, assign) HoverButton *findButton;
@property (nonatomic, assign) HoverButton *closeButton;
- (void)setDriveModel:(IMBDriveModel *)driveModel;
- (IMBDriveModel *)getDriveModel;
@end

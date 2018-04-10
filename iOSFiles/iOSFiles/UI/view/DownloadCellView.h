//
//  DownloadCellView.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressView.h"
#import "DownloadTextFieldView.h"
#import "HoverButton.h"
#import "IMBGeneralButton.h"
#import "DriveItem.h"
#import "IMBWhiteView.h"
@interface DownloadCellView : NSTableCellView
{
    IBOutlet NSImageView *_icon;
    IBOutlet ProgressView *_progessView;
    IBOutlet ProgressView *_transferProgressView;
  
    IBOutlet NSImageView *_downOrUpImage;
    IBOutlet IMBWhiteView *_bgView;
    IBOutlet NSTextField *_titleField;
    IBOutlet NSTextField *_progessField;
    IBOutlet NSTextField *_transferResultField;
    IBOutlet NSTextField *_downloadFaildField;
    IBOutlet NSImageView *_transferResultImageView;
    IBOutlet HoverButton *_finderButton;
    IBOutlet HoverButton *_deleteButton;
    IBOutlet IMBGeneralButton *_downloadButton;
    IBOutlet HoverButton *_closeButton;
    IBOutlet HoverButton *_closeTransferButton;
    IBOutlet HoverButton *_reDownLoad;
    long long _downSize;
    DriveItem *_downLoadDriveItem;
        NSTrackingArea *_trackingArea;
    BOOL _isEnter;
    NSMutableArray *_propertityViewArray;//属性不为空的控件集合
}
@property (nonatomic,retain)DriveItem *downLoadDriveItem;
@property (nonatomic,retain)NSMutableArray *propertityViewArray;
@property (nonatomic,assign)IMBGeneralButton *downloadButton;
@property (nonatomic,assign)NSImageView *icon;
@property (nonatomic,assign)NSImageView *transferResultImageView;

@property (nonatomic,assign)DownloadTextFieldView *TypeTextField;
@property (nonatomic,assign)DownloadTextFieldView *DurationTextField;
@property (nonatomic,assign)NSTextField *progessField;
@property (nonatomic,assign)NSTextField *titleField;
@property (nonatomic,assign)NSTextField *transferResultField;
@property (nonatomic,assign)NSTextField *downloadFaildField;
@property (nonatomic,assign)ProgressView *progessView;
@property (nonatomic,assign)ProgressView *transferProgressView;
@property (nonatomic,assign)HoverButton *finderButton;
@property (nonatomic,assign)HoverButton *deleteButton;
@property (nonatomic,assign)HoverButton *closeButton;
@property (nonatomic,assign)HoverButton *closeTransferButton;
@property (nonatomic,assign)HoverButton *reDownLoad;
@property (nonatomic, retain) NSImageView *downOrUpImage;
- (void)adjustSpaceX:(float)x Y:(float)y;
@end

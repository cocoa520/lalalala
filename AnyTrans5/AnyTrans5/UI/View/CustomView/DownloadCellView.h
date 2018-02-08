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
@interface DownloadCellView : NSTableCellView
{
    IBOutlet NSImageView *_icon;
    IBOutlet ProgressView *_progessView;
    IBOutlet ProgressView *_transferProgressView;
    IBOutlet DownloadTextFieldView *_sizeTextField;
    IBOutlet DownloadTextFieldView *_resolutionTextField;
    IBOutlet DownloadTextFieldView *_TypeTextField;
    IBOutlet DownloadTextFieldView *_DurationTextField;
    IBOutlet NSTextField *_titleField;
    IBOutlet NSTextField *_progessField;
    IBOutlet NSTextField *_transferResultField;
    IBOutlet NSTextField *_downloadFaildField;
    IBOutlet NSImageView *_transferResultImageView;
    IBOutlet HoverButton *_finderButton;
    IBOutlet HoverButton *_toDeviceButton;
    IBOutlet HoverButton *_deleteButton;
    IBOutlet IMBGeneralButton *_downloadButton;
    IBOutlet HoverButton *_closeButton;
    IBOutlet HoverButton *_closeTransferButton;
    IBOutlet HoverButton *_reDownLoad;
    NSMutableArray *_propertityViewArray;//属性不为空的控件集合
}
@property (nonatomic,retain)NSMutableArray *propertityViewArray;
@property (nonatomic,assign)IMBGeneralButton *downloadButton;
@property (nonatomic,assign)NSImageView *icon;
@property (nonatomic,assign)NSImageView *transferResultImageView;

@property (nonatomic,assign)DownloadTextFieldView *sizeTextField;
@property (nonatomic,assign)DownloadTextFieldView *resolutionTextField;
@property (nonatomic,assign)DownloadTextFieldView *TypeTextField;
@property (nonatomic,assign)DownloadTextFieldView *DurationTextField;
@property (nonatomic,assign)NSTextField *progessField;
@property (nonatomic,assign)NSTextField *titleField;
@property (nonatomic,assign)NSTextField *transferResultField;
@property (nonatomic,assign)NSTextField *downloadFaildField;
@property (nonatomic,assign)ProgressView *progessView;
@property (nonatomic,assign)ProgressView *transferProgressView;
@property (nonatomic,assign)HoverButton *finderButton;
@property (nonatomic,assign)HoverButton *toDeviceButton;
@property (nonatomic,assign)HoverButton *deleteButton;
@property (nonatomic,assign)HoverButton *closeButton;
@property (nonatomic,assign)HoverButton *closeTransferButton;
@property (nonatomic,assign)HoverButton *reDownLoad;

- (void)adjustSpaceX:(float)x Y:(float)y;
@end

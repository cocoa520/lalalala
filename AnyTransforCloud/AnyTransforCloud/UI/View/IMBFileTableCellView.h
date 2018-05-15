//
//  IMBFileTableCellView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCheckButton.h"
#import "IMBToolBarButton.h"
#import "IMBDriveModel.h"
#import "IMBLineView.h"

@interface IMBFileTableCellView : NSTableCellView {
    IBOutlet IMBCheckButton *_checkButton;
    IBOutlet NSImageView *_fileImageView;
    IBOutlet NSTextField *_fileName;
    IBOutlet IMBToolBarButton *_collectionBtn;
    IBOutlet IMBToolBarButton *_shareBtn;
    IBOutlet IMBToolBarButton *_syncBtn;
    IBOutlet IMBToolBarButton *_moreBtn;
    IBOutlet NSTextField *_fileSize;
    IBOutlet NSTextField *_fileLastTime;
    IBOutlet NSTextField *_fileExtension;
    
    IBOutlet IMBLineView *_lineView;
    
    NSTrackingArea *_trackingArea;
    MouseStatusEnum _buttonType;
    
    NSInteger _cellRow;
    BOOL _isDisable;
}
@property (nonatomic, assign) BOOL isOpenMenu;
@property (nonatomic, assign) NSInteger cellRow;
@property (nonatomic, retain) IMBDriveModel *model;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) CheckStateEnum checkState;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
@property (nonatomic, retain) IMBCheckButton *checkButton;
@property (nonatomic, retain) NSImageView *fileImageView;
@property (nonatomic, retain) NSTextField *fileName;
@property (nonatomic, retain) IMBToolBarButton *collectionBtn;
@property (nonatomic, retain) IMBToolBarButton *shareBtn;
@property (nonatomic, retain) IMBToolBarButton *syncBtn;
@property (nonatomic, retain) IMBToolBarButton *moreBtn;
@property (nonatomic, retain) NSTextField *fileSize;
@property (nonatomic, retain) NSTextField *fileLastTime;
@property (nonatomic, retain) NSTextField *fileExtension;

@end

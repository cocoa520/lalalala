//
//  IMBMoveAlertViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IMBDriveModel;
@class IMBBaseManager;
@class IMBBorderRectAndColorView;
@class IMBOutlineTriangleView;
@class IMBOutlineView;
@class IMBGridientButton;
@class IMBWhiteView;
@class IMBCanClickText;
@class IMBScrollView;
typedef void(^MoveBlock)(IMBDriveModel *model);
@interface IMBMoveAlertViewController : NSViewController <NSOutlineViewDelegate,NSOutlineViewDataSource,NSTextViewDelegate>
{
    MoveBlock _block;
    IMBBaseManager *_baseManager;
    IMBDriveModel *_rootItem;
    IMBDriveModel *_currentModel;
    BOOL _isLoading;
    NSView *_mainView;
    
    IBOutlet NSTextField *_mainTitle;
    IBOutlet IMBWhiteView *_borderView;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet IMBCanClickText *_textView;
    IBOutlet IMBOutlineView *_outLineView;
    IBOutlet IMBBorderRectAndColorView *_moveAlertView;
    IBOutlet IMBGridientButton *_cancelBtn;
    IBOutlet IMBGridientButton *_okBtn;
    BOOL _isMove;
    NSMutableArray *_selectedAryM;
}

- (void)changeDriveState:(IMBDriveModel *)model;

- (void)showMoveDestinationWith:(IMBBaseManager *)baseManager SuperView:(NSView *)superView withSeletedAyM:(NSMutableArray *)seletedArM isMove:(BOOL)isMove MoveBlock:(MoveBlock)block;

@end

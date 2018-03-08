//
//  IMBCustomHeaderTableView.h
//  MacClean
//
//  Created by Gehry on 1/20/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCheckHeaderCell.h"
#import "IMBCommonEnum.h"

@protocol IMBImageRefreshListListener
@optional
- (void)loadingThumbnilImage:(NSRange)oldVisibleRows withNewVisibleRows:(NSRange)newVisibleRows;
- (void)setAllselectState:(CheckStateEnum)checkState;
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index;
- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index;
-(void)setselectState:(CheckStateEnum)state WithTableView:(NSTableView *)tableView;
@end
@interface IMBCustomHeaderTableView : NSTableView<NSAnimationDelegate>{
    IMBCheckHeaderCell *_checkBoxCell;
    NSTrackingArea *_trackingArea;
    id _listener;
    NSRange _visibleRows;
    IMBCheckHeaderCell *_headCheckCell;
    NSColor *_selectionColor; ///< 选中的高亮颜色
    NSColor *_alternatingEvenRowBackgroundColor;   //偶数行背景颜色
    NSColor *_alternatingOddRowBackgroundColor;    //奇数行背景颜色
    BOOL _isHighLight;
    BOOL _clickCheckBox;
    BOOL _canSelect;
    BOOL _refresh;
    BOOL _isNote;
  
}

@property (nonatomic, assign) BOOL isHighLight;
@property (nonatomic, assign) BOOL clickCheckBox;
@property (nonatomic, retain) IMBCheckHeaderCell *checkBoxCell;
@property (nonatomic, retain) IMBCheckHeaderCell *headCheckCell;
@property (nonatomic, assign) BOOL canSelect;
@property (nonatomic,retain) NSColor *selectionColor;
@property (nonatomic,retain) NSColor *alternatingEvenRowBackgroundColor;
@property (nonatomic,retain) NSColor *alternatingOddRowBackgroundColor;
@property (assign) BOOL refresh;
@property (assign) BOOL isNote;

- (void)setupHeaderCell;
- (void)setHeaderTextAlignment:(NSTextAlignment)alignment;
- (void)clickHeadCheckButton:(id)sender;
- (void)changeHeaderCheckState:(NSInteger)state;
- (void)setListener:(id<IMBImageRefreshListListener>)listener;
-(void)showVisibleRextPhoto;
@end

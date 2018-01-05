//
//  IMBBackUpTableView.h
//  AnyTrans
//
//  Created by long on 16-7-26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCheckHeaderCell.h"
@interface IMBBackUpTableView : NSTableView
{
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
    NSInteger _clikeRow;
}
@property (nonatomic, assign) NSInteger clikeRow;
@property (nonatomic, assign) BOOL isHighLight;
@property (nonatomic, assign) BOOL clickCheckBox;
@property (nonatomic, retain) IMBCheckHeaderCell *checkBoxCell;
@property (nonatomic, retain) IMBCheckHeaderCell *headCheckCell;
@property (nonatomic, assign) BOOL canSelect;
@property (nonatomic,retain) NSColor *selectionColor;
@property (nonatomic,retain) NSColor *alternatingEvenRowBackgroundColor;
@property (nonatomic,retain) NSColor *alternatingOddRowBackgroundColor;
@property (assign)BOOL refresh;
- (void)setupHeaderCell;
- (void)setHeaderTextAlignment:(NSTextAlignment)alignment;
- (void)setListener:(id)listener;

@end

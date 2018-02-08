//
//  IMBiCloudTableView.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-19.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCheckHeaderCell.h"
@class IMBiCloudTableCell;

@protocol NSTableViewMouseCallback
@optional
- (void)changeFromBindingData:(id)fromBindingData toBindingData:(id)toBindingData withControlView:(NSView *)controlView;

- (void)clickTableViewRow:(NSTableView *)tableView withRow:(int)row;

@end

@interface IMBiCloudTableView : NSTableView{
@private
    id _mouseDelegate;
    IMBCheckHeaderCell *_checkBoxCell;
    BOOL _isSelectAll;
    long curRow;
    long curColumn;
    
    NSTrackingArea *_trackingArea;
    NSMutableArray *_dataAry;
    
    NSColor *_alternatingEvenRowBackgroundColor;   //偶数行背景颜色
    NSColor *_alternatingOddRowBackgroundColor;    //奇数行背景颜色
}
@property (nonatomic, assign) BOOL isSelectAll;
@property (nonatomic, readwrite, assign) id mouseDelegate;
@property (nonatomic,retain) IMBCheckHeaderCell *checkBoxCell;
@property (nonatomic, retain) NSMutableArray *dataAry;
- (void)selectRowIndexes:(NSIndexSet *)indexes;
- (void)changeAllCheckState:(NSInteger)state;
- (void) uncheckAllButton ;
- (void) doSelectAll:(id)sender;
- (void)doChangeLanguage:(NSNotification *)notification;

@end

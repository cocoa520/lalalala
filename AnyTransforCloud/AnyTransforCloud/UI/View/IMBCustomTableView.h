//
//  IMBCustomTableView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/26.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@protocol IMBTableViewListener
@optional
/**
 *  单击某一行
 *
 *  @param tableView 目标列表
 *  @param index     行标
 */
- (void)tableViewSingleClick:(NSTableView *)tableView row:(NSInteger)index;

/**
 *  双击某一行
 *
 *  @param tableView 目标列表
 *  @param index     行标
 */
- (void)tableViewDoubleClick:(NSTableView *)tableView row:(NSInteger)index;

/**
 *  右键点击某一行
 *
 *  @param tableView 目标列表
 *  @param index     行标
 */
- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index;

@end
@interface IMBCustomTableView : NSTableView {
    NSTrackingArea *_trackingArea;
    id _listener;
}
@property (nonatomic, assign) int selectedCount;

- (void)setListener:(id<IMBTableViewListener>)listener;

@end

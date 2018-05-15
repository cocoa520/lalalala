//
//  IMBHomeFileViewController.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/5/6.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBlankDraggableCollectionView.h"

@interface IMBHomeFileViewController : NSViewController {
    NSMutableArray *_dataAry;
    id _delegate;
    
    IBOutlet NSScrollView *_scrollView;
    IBOutlet IMBBlankDraggableCollectionView *_collectionView;
    IBOutlet NSArrayController *_arrayController;
}

@property (nonatomic, retain) NSMutableArray *dataAry;

- (id)initWithDelegate:(id)delegate;

/**
 *  加载数据源数据
 *
 *  @param showCount 显示的个数
 */
- (void)loadDataAry:(int)showCount;

@end

@interface IMBHomeFileCollectionViewItem : NSCollectionViewItem

@end

//
//  IMBHomeCloudViewController.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/5/4.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBHomeCloudViewController : NSViewController <NSCollectionViewDelegate,NSCollectionViewDataSource> {
    NSMutableArray *_dataAry;
    
    IBOutlet NSArrayController *_arrayController;
    IBOutlet NSCollectionView *_collectionView;
    IBOutlet NSScrollView *_scrollView;
}
@property (nonatomic, retain) NSMutableArray *dataAry;

/**
 *  加载数据源数据
 *
 *  @param showCount 显示的个数
 */
- (void)loadDataAry:(int)showCount;

@end

@interface IMBHomeCollectionViewItem : NSCollectionViewItem

@end

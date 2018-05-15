//
//  IMBAddCloudViewController.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCloudCategoryView.h"
#import "IMBScrollView.h"
#import "IMBCanClickText.h"
#import "IMBCloudAuthorizeWindowController.h"
#import "IMBAlertViewController.h"

@class IMBCloudEntity;
@interface IMBAddCloudViewController : NSViewController<CloudCategoryDelegate,NSCollectionViewDelegate,NSCollectionViewDataSource,NSTableViewDataSource,NSTableViewDelegate,NSTextViewDelegate> {
    NSNotificationCenter *_nc;
    id _delegate;
    NSMutableArray *_dataSourceAryM;
    NSMutableArray *_personCloudAryM;
    
    IBOutlet NSTextField *_titleTextField;
    IBOutlet NSTextField *_subtitleTextField;
    IBOutlet IMBCloudCategoryView *_cloudCategoryView;
    IBOutlet IMBWhiteView *_iCloudCategoryLineView;
    IBOutlet NSCollectionView *_collectionView;
    IBOutlet IMBScrollView *_collectionScrollView;
    IBOutlet NSBox *_contentBox;
    IBOutlet IMBScrollView *_tableViewScrollView;
    IBOutlet NSTableView *_itemTableView;
    IBOutlet NSView *_innerView;
    
    //nodata界面
    IBOutlet IMBWhiteView *_noDataView;
    IBOutlet NSImageView *_noDataImage;
    IBOutlet IMBCanClickText *_noDataText;
    IMBCloudAuthorizeWindowController *_authorizeWindow;
    
    IMBAlertViewController *_alertViewController;
}

@property (nonatomic, retain) NSMutableArray *dataSourceAryM;

- (id)initWithDelegate:(id)delegate;

/**
 *  选择cloud
 *
 *  @param cloud 选择cloud实体
 */
- (void)chooseCloud:(IMBCloudEntity *)cloud;

/**
 *  跳转到云盘的详细界面
 *
 *  @param driveID 唯一标记
 */
- (void)jumpCloudView:(NSString *)driveID;
@end


//
//  IMBAppsListViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/25.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "LoadingView.h"
#import "IMBWhiteView.h"
#import "IMBInformation.h"
#import "IMBCustomHeaderTableView.h"
#import "IMBTransferViewController.h"
#import "IMBToolBarView.h"
@class IMBBackgroundBorderView;
@class HoverButton;
@class IMBBlankDraggableCollectionView;
@class IMBApplicationManager;
@class IMBAppEntity;
@interface IMBAppsListViewController : IMBBaseViewController <NSTableViewDataSource,NSTableViewDelegate,NSCollectionViewDelegate,IMBImageRefreshListListener,NSTextViewDelegate>
{
    IBOutlet NSView *_containTableView;
    IBOutlet NSView *_containTableCollectView;
    IBOutlet IMBCustomHeaderTableView *_leftTableView;
    IBOutlet IMBBackgroundBorderView *_backandnextView;
    IBOutlet HoverButton *_advanceButton;
    IBOutlet HoverButton *_backButton;
    IBOutlet NSTextField *_itemTitleField;
    IBOutlet NSScrollView *_scrollView;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet IMBWhiteView *_levelLineView;
    IBOutlet IMBWhiteView *_topLevelView;
    IBOutlet IMBWhiteView *_rightView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSBox *_mainBox;
    
    IMBAppEntity *_currentEntity;
    NSNotificationCenter *nc;
    NSSegmentedControl *_backandnext;
    IMBApplicationManager *applicationManger;
    NSProgressIndicator *indicator;
    IMBBackgroundBorderView *_loadingView;
    NSString *_iOSVersion;
    NSString *_appBundle;
    int currentIndex;
    NSString *_currentDevicePath;
    NSMutableArray *_backContainer;
    NSMutableArray *_nextContainer;
    NSMutableArray *_itemArray;
    NSMutableArray *_currentArray;

//    IBOutlet NSArrayController *_arrayController;
    IBOutlet IMBWhiteView *_loadingDataVeiw;
    IBOutlet LoadingView *_loadingAnimationView;
    
//    IBOutlet IMBCustomHeaderTableView *_itemTableView;
//    IBOutlet IMBBlankDraggableCollectionView *_collectionView;
//    NSMutableArray *_dataSourceArray;
//    IMBInformation *_information;
    
//    NSOpenPanel *_openPanel;
    IMBTransferViewController *_transferViewController;
}
@property (nonatomic,retain)NSString *currentDevicePath;
@property (nonatomic, retain) NSMutableArray *itemArray;
- (void)showloading:(BOOL)isloading baseView:(NSView *)view;

- (id)initWithIpod:(IMBiPod *)ipod;
@end

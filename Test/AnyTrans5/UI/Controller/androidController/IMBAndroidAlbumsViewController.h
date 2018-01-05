//
//  IMBMyAlbumsViewController.h
//  iMobieTrans
//
//  Created by iMobie on 7/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBTabTableView.h"
#import "IMBScrollView.h"
#import "IMBBGColoerView.h"
#import "HoverButton.h"
#import "IMBPhotoEntity.h"
#import "IMBImageAndTitleButton.h"
#import "LoadingView.h"
#import "CNGridView.h"
@class IMBAlertViewController;
@interface IMBAndroidAlbumsViewController : IMBBaseViewController<TransferDelegate> {
    IBOutlet IMBCustomHeaderTableView *_albumTableView;
    IBOutlet NSBox *_boxContent;
    IBOutlet NSMenu *_menu;
    IBOutlet NSMenuItem *_renameMenuItem;
    IBOutlet NSMenuItem *_deleteItem;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSTextView *_noDataTextTwo;
    IBOutlet NSView *_contentView;
    IBOutlet NSBox *_mainBox;
    IMBAlertViewController *alerView;
    int _currentSelectView;
    int _curIndex;
    NSView *_currentView;
    
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    NSTrackingArea *_trackingArea;
    IMBADAlbumEntity *_currentAlbum;
    
    IBOutlet IMBCustomHeaderTableView *_rightTableView;
    IBOutlet CNGridView *_gridView;
    IBOutlet NSView *_rightListDetailView;
    IBOutlet NSView *_rightColDetailView;
    CNGridViewItemLayout *_defaultLayout;
    CNGridViewItemLayout *_hoverLayout;
    CNGridViewItemLayout *_selectionLayout;
    NSOperationQueue *_operation;
}

@property (nonatomic, retain) IMBCustomHeaderTableView *albumTableView;
@property (nonatomic,assign) AlbumTypeEnum selectedType;
@property (nonatomic,assign) int currentSelectView;
@property (nonatomic,assign) IMBADAlbumEntity *currentAlbum;

@property (nonatomic, retain) CNGridViewItemLayout *defaultLayout;
@property (nonatomic, retain) CNGridViewItemLayout *hoverLayout;
@property (nonatomic, retain) CNGridViewItemLayout *selectionLayout;

@end

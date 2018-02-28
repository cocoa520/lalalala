//
//  IMBSystemCollectionViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "LoadingView.h"
#import "IMBTransferViewController.h"
#import "IMBWhiteView.h"
#import "IMBScrollView.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBiPod.h"
#import "IMBInformation.h"
#import "IMBToolBarView.h"
@class HoverButton;
@class IMBBackgroundBorderView;
@class IMBFileSystemManager;
@interface IMBSystemCollectionViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate,NSCollectionViewDelegate,NSTextViewDelegate,NSPopoverDelegate>
{
    IBOutlet IMBBackgroundBorderView *_backandnextView;
    IBOutlet NSTextField *_itemTitleField;
    IBOutlet HoverButton *advanceButton;
    IBOutlet HoverButton *backButton;
    IBOutlet IMBScrollView *_scrollView;

    IBOutlet NSView *_noDataView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSView *_detailView;
    IBOutlet NSBox *_mainBox;
    IBOutlet IMBWhiteView *_bgView;
    IMBFileSystemManager *systemManager;
    IMBInformation *_information;
//    NSSegmentedControl *backandnext;
    NSMutableArray *_backContainer;
    NSMutableArray *_nextContainer;
    int currentIndex;
    NSMutableArray *_currentArray;
    NSString *_currentDevicePath;
    NSNotificationCenter *nc;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    NSMutableArray *_dataSourceArray;
    IMBiPod *_ipod;
    IBOutlet IMBBlankDraggableCollectionView *_collectionView;
    int _deleteTotalItems;
    IBOutlet NSArrayController *_arrayController;
    id _delegate;
    NSOpenPanel *_openPanel;
    BOOL _isOpen;
    
    IMBTransferViewController *_transferViewController;
    IBOutlet IMBToolBarView *_toolBarView;
    NSMutableArray *_delArray;
   
}
@property(nonatomic,retain)NSMutableArray *currentArray;
@property (nonatomic,retain)NSString *currentDevicePath;

- (void)refresh;
- (void)addItems;
- (void)toMac;
- (void)setDeleteCurItems:(int)curItem;
- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate;
@end

@interface IMBPhotoCollectionViewItem : NSCollectionViewItem

@end


@interface IMBPhotoImageView : NSImageView
{
    BOOL _isSected;
    NSImage *_loadImage;
    
    BOOL _isDraw;
    BOOL _isload; //图片加载了
    BOOL _isfree;//图片释放了
    BOOL _exist;//图片是否能取到
}

@property(nonatomic,assign)BOOL isSelected;
@property (nonatomic,retain,readwrite) NSImage *loadImage;
@property(nonatomic,assign)BOOL isload;
@property(nonatomic,assign)BOOL isfree;
@property(nonatomic,assign)BOOL exist;
@end

@interface IMBCollectionImageView :IMBPhotoImageView
{
    NSImage *_backgroundImage;
    
}

@property(nonatomic,retain)NSImage *backgroundImage;

@end


@interface IMBFolderOrFileCollectionItemView : NSView
{
    NSTrackingArea *_trackingArea;
    BOOL _done;
}
@property (nonatomic,assign) BOOL done;
@end

@interface IMBFolderOrFileCollectionViewItem : NSCollectionViewItem

@end
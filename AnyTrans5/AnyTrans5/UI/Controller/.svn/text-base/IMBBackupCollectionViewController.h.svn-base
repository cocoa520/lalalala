//
//  IMBBackupCollectionViewController.h
//  AnyTrans
//
//  Created by smz on 17/10/16.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "IMBBlankDraggableCollectionView.h"
#import "LoadingView.h"
#define NSPhotoCollectionViewBoundsDidChangeNotification  @"NSPhotoCollectionViewBoundsDidChangeNotification"
@class IMBBackupCollectionViewItem;
@interface IMBBackupCollectionViewController : IMBBaseViewController<IMBImageRefreshCollectionListener>
{
    IBOutlet NSImageView *_photoSelectedView;
    IBOutlet IMBScrollView *_scrollView;
    int currentRow;
    NSOperationQueue *queue;
    NSImage *_defaultImage;
    int currentIndex;
    NSMutableArray *_dataArr;
    int maxColumn;
    IBOutlet IMBBackupCollectionViewItem *collectionViewItem;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_detailView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSScrollView *_noDataScrollView;
    IMBPhotoEntity *_curEntity;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    NSNotificationCenter *nc;
    NSString *_toolTip;
    //上传总共的大小
    float _upLoadTotolSize;
    int _updateCount;
    
    //当前文件已经下载的大小
    float _nowFileSize;
    float _upLoadDownTotolSize;
    float _upLoadNowDownSize;
    float _upLoadLastDownSize;
    int _transtotalCount;
    BOOL _istransView;
    
}

@property(nonatomic,retain)NSImage *defaultImage;
@property(nonatomic,retain)NSMutableArray *dataArr;
@property (nonatomic, retain) IMBPhotoEntity *curEntity;
@property (nonatomic, retain)NSString *toolTip;
- (void)setToolBar:(IMBToolBarView *)toolBar;

@end

@interface IMBBackupCollectionViewItem : NSCollectionViewItem

@end

@interface IMBBackupPhotoImageView : NSImageView
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
//
//  IMBPhotosCollectionViewController.h
//  iMobieTrans
//
//  Created by iMobie on 14-6-11.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "IMBBlankDraggableCollectionView.h"
#import "LoadingView.h"
@class IMBPhotoCollectionViewItem;
#define NSPhotoCollectionViewBoundsDidChangeNotification  @"NSPhotoCollectionViewBoundsDidChangeNotification"
@interface IMBPhotosCollectionViewController : IMBBaseViewController<IMBImageRefreshCollectionListener>
{
    IBOutlet NSImageView *_photoSelectedView;
    IBOutlet IMBScrollView *_scrollView;
    int currentRow;
    NSOperationQueue *queue;
    NSImage *_defaultImage;
//    NSNotificationCenter *nc;
    int currentIndex;
    NSMutableArray *_dataArr;
    int maxColumn;
    IBOutlet IMBPhotoCollectionViewItem *collectionViewItem;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_detailView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSScrollView *_noDataScrollView;
//    dispatch_queue_t _tqueue;
    IMBPhotoEntity *_curEntity;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    NSNotificationCenter *nc;
    NSString *_toolTip;
    IMBiCloudBackup *_iCloudBackup;
    IBOutlet NSImageView *_backUpNoDataImageView;
    IBOutlet NSTextField *_backUpNoDataTextView;
    IBOutlet NSView *_backUpNoDataView;
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
    
    IMBToiCloudPhotoEntity *_iCloudPhotoEntity;
    id _icloudPhotoDelegate;
}
@property(nonatomic,assign) id icloudPhotoDelegate;
@property(nonatomic,retain)NSImage *defaultImage;
@property(nonatomic,retain)NSMutableArray *dataArr;
@property (nonatomic, retain) IMBPhotoEntity *curEntity;
@property (nonatomic, retain)NSString *toolTip;
- (id)initWithiPod:(IMBiPod*)iPod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate withPhotoEntity:(IMBPhotoEntity *)entity;
- (void)setToolBar:(IMBToolBarView *)toolBar;

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

//
//  IMBTracksCollectionViewController.h
//  iMobieTrans
//
//  Created by iMobie on 14-5-16.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import <Quartz/Quartz.h>
#import "IMBBlankDraggableCollectionView.h"
#import "IMBPhotosCollectionViewController.h"
#import "IMBScrollView.h"
#import "LoadingView.h"
@class IMBCollectionImageView;
@interface IMBTracksCollectionViewController : IMBBaseViewController<IMBImageRefreshCollectionListener>
{
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_contentView;
    int currentRow;
    NSOperationQueue *queue;
    NSImage *_defaultImage;
    int currentIndex;
    NSMutableArray *_dataArr;
    
    dispatch_queue_t _tqueue;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IMBLogManager *_logManger;
    NSNotificationCenter *_nc;
    IBOutlet NSImageView *_photoSelectedImageView;
    
    
}
@property(nonatomic,retain)NSMutableArray *dataArr;
@end

@interface IMBCollectionViewItem : NSCollectionViewItem
{
    NSInteger _index;
}
@property (assign) NSInteger index;
@end

@interface IMBCollectionItemView : NSView {
    IMBBlankDraggableCollectionView *_blankDraggableView;
    BOOL _done;
    NSTrackingArea *_trackingArea;
    IBOutlet NSImageView *_bgImageView;
    BOOL _hasLargeImage;
}
@property (nonatomic,assign) BOOL done;

@end

@interface IMBCollectionImageView :IMBPhotoImageView
{
       NSImage *_backgroundImage;
    
}

@property(nonatomic,retain)NSImage *backgroundImage;

@end

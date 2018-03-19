//
//  IMBPhotosListViewController.h
//  iMobieTrans
//
//  Created by iMobie on 7/29/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBInformation.h"
#import "LoadingView.h"
@interface IMBPhotosListViewController : IMBBaseViewController <IMBImageRefreshListListener> {
    
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_containTableView;
    IBOutlet NSScrollView *_scrollVeiw;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSScrollView *_noDataScrollView;
    
    NSOperationQueue *queue;
    NSMutableArray *_visibleItems;
    dispatch_queue_t _tqueue;
    IMBPhotoEntity *_curEntity;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
//    IMBToiCloudPhotoEntity *_iCloudPhotoEntity;
    id _icloudPhotoDelegate;
    IBOutlet NSTextField *_noDataLable;
}
@property (nonatomic, assign) id icloudPhotoDelegate;
@property (nonatomic, retain) IMBPhotoEntity *curEntity;
- (void)setToolBar:(IMBToolBarView *)toolBar;
- (id)initWithiPod:(IMBiPod *)ipod;


@end
